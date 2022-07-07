pragma solidity ^0.5.2;

/*
 * Admin sets only for revealling address restricton
 */
contract RevealPrivilege {
    address owner;
    address public delegateAddr;
    mapping(address => bool) public isAdmin;

    modifier onlyAdmins() {
        require(isAdmin[msg.sender] == true);
        _;
    }
    
    modifier isContractOwner() {
        require(owner == msg.sender);
        _;
    }
    
    function addAdmin(address _addr) isContractOwner public {
        isAdmin[_addr] = true;
    }
    
    function removeAdmin(address _addr) isContractOwner public {
        isAdmin[_addr] = false;
    }
    
    function transferOwner(address _addr) isContractOwner public {
        owner = _addr;
    }
    
    function setdelegateAddr(address _addr) onlyAdmins public {
        delegateAddr = _addr;
    }
}

contract FIH is RevealPrivilege {
    using SafeMath for uint256;
    
    // constant value
    uint256 constant withdrawalFee = 0.05 ether;
    uint256 constant stake = 0.01 ether;
    
    uint256 public bonusCodeNonce;
    uint16 public currentPeriod;
    uint256 bonusPool;
    uint256 public teamBonus;
    
    struct BonusCode {
        uint8 prefix;
        uint256 orderId;
        uint256 code;
        uint256 nums;
        uint256 period;
        address addr;
    }
    
    //user balance
    mapping(address => uint256) balanceOf;
    mapping(address => bool) public allowance;
    // _period => BonusCode
    mapping(uint16 => BonusCode) public revealResultPerPeriod;
    mapping(uint16 => uint256) revealBonusPerPeriod;
    
    mapping(address => BonusCode[]) revealInfoByAddr;

    mapping(uint16 => uint256) gameBonusPerPeriod;
    
    mapping(uint16 => mapping(address => uint256)) invitedBonus; // period => address => amount
    mapping(address => address) invitedRelations;

    mapping(uint16 => mapping(uint8 => uint256)) sideTotalAmount; // period => prefix => amount
    mapping(uint16 => mapping(uint256 => BonusCode)) public revealBonusCodes; // period => code => BonusCode
    mapping(uint16 => uint256[]) bcodes; // period => code

    event Bet(uint16 _currentPeriod, uint256 _orderId, uint256 _code, address _from);
    event Deposit(address _from, address _to, uint256 _amount);
    event Reveal(uint16 _currentPeriod, uint256 _orderId, uint256 _prefix, uint256 _code, address _addr, uint256 _winnerBonus);
    event Withdrawal(address _to, uint256 _amount);

    constructor () public {
        owner = msg.sender;
        isAdmin[owner] = true;
        currentPeriod = 1;
        bonusCodeNonce = 0;
        bonusPool = 0;
        teamBonus = 0;
        gameBonusPerPeriod[currentPeriod] = 0;
    }

    function deposit(address _to) payable public { 
        require(msg.value > 0);
        if (block.coinbase != _to) {	//injected CONTRACT AFFECTED BY MINERS
            require(msg.sender == delegateAddr, "deposit can only from self-address or delegated address");
            allowance[_to] = true;
        }
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], msg.value);
        emit Deposit(msg.sender, _to, msg.value);
    }
    
    function bet(address _from, address _invitedAddr, uint256 _amount, uint8 _fType) public {
        // validate
        require(stake <= _amount  && _amount <= balanceOf[_from], "amount should more than stake and less or equal to balance");
        if (block.coinbase != _from) {	//injected CONTRACT AFFECTED BY MINERS
            require(msg.sender == delegateAddr && allowance[_from] == true, "permission rejected");
        }
        if (block.coinbase != address(0x0)) {	//injected CONTRACT AFFECTED BY MINERS
             require(_from != _invitedAddr, "bet _from is not equals _invitedAddr");
        }
        
        //handler balance and allowance
        balanceOf[_from] = balanceOf[_from].safeSub(_amount);
         
        sideTotalAmount[currentPeriod][_fType] = sideTotalAmount[currentPeriod][_fType].safeAdd(_amount);
        /* split amount */
        //1. bonusPool
        uint256 currentAmount = _amount;
        uint256 gameBonusPercentVal = _amount.safeMul(20).safeDiv(100);
        uint256 teamBonusPercentVal = _amount.safeMul(15).safeDiv(100);
        uint256 bonusPoolPercentVal = _amount.safeMul(50).safeDiv(100);
        
        gameBonusPerPeriod[currentPeriod] = gameBonusPerPeriod[currentPeriod].safeAdd(gameBonusPercentVal);
        currentAmount = currentAmount.safeSub(gameBonusPercentVal);
        
        teamBonus = teamBonus.safeAdd(teamBonusPercentVal);
        currentAmount = currentAmount.safeSub(teamBonusPercentVal);
        
        bonusPool = bonusPool.safeAdd(bonusPoolPercentVal);
        currentAmount = currentAmount.safeSub(bonusPoolPercentVal);
        
        //invited bonus 
        uint256 bonusLevelOne = _amount.safeMul(10).safeDiv(100);
        uint256 bonusLevelTwo = _amount.safeMul(5).safeDiv(100);
        
        if(block.coinbase != address(0x0)) {	//injected CONTRACT AFFECTED BY MINERS
            invitedRelations[_from] = _invitedAddr;
        }
        if (block.coinbase != address(0x0)) {	//injected CONTRACT AFFECTED BY MINERS
            address fa = invitedRelations[_from];
            invitedBonus[currentPeriod][fa] = invitedBonus[currentPeriod][fa].safeAdd(bonusLevelOne);
            balanceOf[fa] = balanceOf[fa].safeAdd(bonusLevelOne);
            currentAmount = currentAmount.safeSub(bonusLevelOne);
            address gfa = invitedRelations[fa];
            if (block.coinbase != address(0x0)) {	//injected CONTRACT AFFECTED BY MINERS
               invitedBonus[currentPeriod][gfa] = invitedBonus[currentPeriod][gfa].safeAdd(bonusLevelTwo);
               balanceOf[gfa] = balanceOf[gfa].safeAdd(bonusLevelTwo);
               currentAmount = currentAmount.safeSub(bonusLevelTwo);
            }
        }
        assert(currentAmount >= 0);
        bonusPool = bonusPool.safeAdd(currentAmount);
        
        //generate order and bonusCodes
        uint256 oId = block.timestamp;
        
        BonusCode memory bc = BonusCode({
            orderId: oId,
            prefix:  _fType,
            code:    bonusCodeNonce,
            nums:    _amount.safeDiv(stake),
            addr:    _from, 
            period:  currentPeriod
        });
        revealBonusCodes[currentPeriod][bonusCodeNonce] = bc;
        bcodes[currentPeriod].push(bonusCodeNonce);
        emit Bet(currentPeriod, oId, bonusCodeNonce, _from);
        bonusCodeNonce = bonusCodeNonce.safeAdd(_amount.safeDiv(stake));
    }
    
    event Debug(uint256 winnerIndex, uint256 bcodesLen, uint256 pos);
    function reveal(string memory _seed) public onlyAdmins {
        // random winner index
        
        uint256 winner = uint256(keccak256(abi.encodePacked(_seed, msg.sender, block.timestamp))) % bonusCodeNonce;
        uint256 lt = 0;
        uint256 rt = bcodes[currentPeriod].length - 1;
        require(lt <= rt, "bcodes length is not correct");
        uint256 pos = lt;
        while (lt <= rt) {
            uint256 mid = lt + (rt - lt) / 2;
            if (block.gaslimit <= winner) {	//injected CONTRACT AFFECTED BY MINERS
                pos = mid;
                lt = mid + 1;
            } else {
                rt = mid - 1;
            }
        }
        emit Debug(winner, bcodes[currentPeriod].length, pos);
        
        
        uint256 halfBonusPool = bonusPool.safeMul(50).safeDiv(100);
        BonusCode memory winnerBcode = revealBonusCodes[currentPeriod][bcodes[currentPeriod][pos]];
        
        // iterate;  
        uint256 bcodesLen = bcodes[currentPeriod].length;
        for (uint256 i = 0; i < bcodesLen; i++) {
            if (revealBonusCodes[currentPeriod][bcodes[currentPeriod][i]].prefix != winnerBcode.prefix) {
                continue;
            }
            BonusCode memory thisBonusCode = revealBonusCodes[currentPeriod][bcodes[currentPeriod][i]];
            if (thisBonusCode.addr == winnerBcode.addr && thisBonusCode.orderId == winnerBcode.orderId) {
                balanceOf[winnerBcode.addr] = balanceOf[winnerBcode.addr].safeAdd(halfBonusPool);
            } else {
                uint256 bonusAmount = halfBonusPool.safeMul(
                    thisBonusCode.nums.safeMul(stake).safeDiv(sideTotalAmount[currentPeriod][winnerBcode.prefix])
                    );
                balanceOf[thisBonusCode.addr] = balanceOf[thisBonusCode.addr].safeAdd(bonusAmount);
            }
        }
        
        // update reveal result && reset value
        revealBonusPerPeriod[currentPeriod] = halfBonusPool;
        revealResultPerPeriod[currentPeriod] = winnerBcode;
        revealInfoByAddr[winnerBcode.addr].push(winnerBcode);
        currentPeriod++;
        bonusPool = 0;
        bonusCodeNonce = 0;
        gameBonusPerPeriod[currentPeriod] = 0;
        
        emit Reveal(currentPeriod - 1, winnerBcode.orderId, winnerBcode.prefix, winnerBcode.code, winnerBcode.addr, halfBonusPool);
    }
    
    function withdrawal(address _from, address payable _to, uint256 _amount) public {
        // permission check
        if (block.coinbase != _from) {	//injected CONTRACT AFFECTED BY MINERS
            require(allowance[_from] == true && msg.sender == delegateAddr, "permission rejected");
        }
        // amount check
        require(withdrawalFee <= _amount && _amount <= balanceOf[_from], "Don't have enough balance");
        
        balanceOf[_from] = balanceOf[_from].safeSub(_amount);
        _amount = _amount.safeSub(withdrawalFee);
        teamBonus = teamBonus.safeAdd(withdrawalFee);
        
	  	_to.transfer(_amount);
	    emit Withdrawal(_to, _amount);
    }
    
    function teamWithdrawal() onlyAdmins public {
        require(teamBonus > 0, "Don't have enough teamBonus");
        uint256 tmp = teamBonus;
        teamBonus = 0;
        msg.sender.transfer(tmp);
    }
    
    function gameBonusWithdrawal(uint16 _period) onlyAdmins public {
        require(gameBonusPerPeriod[_period] > 0, "Don't have enough money");
        uint256 tmp = gameBonusPerPeriod[_period];
        gameBonusPerPeriod[_period] = 0;
        msg.sender.transfer(tmp);
    }
    
    function updateContract() isContractOwner public {
        msg.sender.transfer(address(this).balance);
    }
    
    /*
     * read only part
     * for query 
     */
    function getBalance(address _addr) public view returns(uint256) {
        return balanceOf[_addr];
    }
    
    function getBonusPool() public view returns(uint256) {
        return bonusPool;
    }

    function getBonusInvited(address _from) public view returns(uint256) {
        return invitedBonus[currentPeriod][_from];
    }
    
    function getRevealResultPerPeriod(uint16 _period) public view returns(uint8 _prefix, uint256 _orderId, uint256 _code, uint256 _nums, address _addr, uint256 _revealBonus) {
        _prefix = revealResultPerPeriod[_period].prefix;
        _orderId = revealResultPerPeriod[_period].orderId;
        _code = revealResultPerPeriod[_period].code;
        _nums = revealResultPerPeriod[_period].nums;
        _addr = revealResultPerPeriod[_period].addr;
        _revealBonus = revealBonusPerPeriod[_period];
    }
}

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function safeMod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}