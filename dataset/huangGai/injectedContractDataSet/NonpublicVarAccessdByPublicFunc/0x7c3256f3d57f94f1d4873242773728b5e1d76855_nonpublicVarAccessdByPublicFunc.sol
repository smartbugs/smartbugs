pragma solidity ^0.5.2;

/*
 * Admin sets only for revealling address restricton
 */
contract RevealPrivilege {
    address owner;
    address internal delegateAddr;
    mapping(address => bool) internal isAdmin;

    modifier onlyAdmins() {
        require(isAdmin[msg.sender] == true);
        _;
    }
    
    modifier isContractOwner() {
        require(owner == msg.sender);
        _;
    }
    
    function addAdmin(address _addr) isContractOwner public {
        isAdmin[_addr] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function removeAdmin(address _addr) isContractOwner public {
        isAdmin[_addr] = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function transferOwner(address _addr) isContractOwner public {
        owner = _addr;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function setdelegateAddr(address _addr) onlyAdmins public {
        delegateAddr = _addr;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}

contract FIH is RevealPrivilege {
    using SafeMath for uint256;
    
    // constant value
    uint256 constant withdrawalFee = 0.05 ether;
    uint256 constant stake = 0.01 ether;
    
    uint256 internal bonusCodeNonce;
    uint16 internal currentPeriod;
    uint256 bonusPool;
    uint256 internal teamBonus;
    
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
    mapping(address => bool) internal allowance;
    // _period => BonusCode
    mapping(uint16 => BonusCode) internal revealResultPerPeriod;
    mapping(uint16 => uint256) revealBonusPerPeriod;
    
    mapping(address => BonusCode[]) revealInfoByAddr;

    mapping(uint16 => uint256) gameBonusPerPeriod;
    
    mapping(uint16 => mapping(address => uint256)) invitedBonus; // period => address => amount
    mapping(address => address) invitedRelations;

    mapping(uint16 => mapping(uint8 => uint256)) sideTotalAmount; // period => prefix => amount
    mapping(uint16 => mapping(uint256 => BonusCode)) internal revealBonusCodes; // period => code => BonusCode
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
        if (msg.sender != _to) {
            require(msg.sender == delegateAddr, "deposit can only from self-address or delegated address");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            allowance[_to] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], msg.value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Deposit(msg.sender, _to, msg.value);
    }
    
    function bet(address _from, address _invitedAddr, uint256 _amount, uint8 _fType) public {
        // validate
        require(stake <= _amount  && _amount <= balanceOf[_from], "amount should more than stake and less or equal to balance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if (msg.sender != _from) {
            require(msg.sender == delegateAddr && allowance[_from] == true, "permission rejected");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        if (_invitedAddr != address(0x0)) {
             require(_from != _invitedAddr, "bet _from is not equals _invitedAddr");
        }
        
        //handler balance and allowance
        balanceOf[_from] = balanceOf[_from].safeSub(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
         
        sideTotalAmount[currentPeriod][_fType] = sideTotalAmount[currentPeriod][_fType].safeAdd(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        /* split amount */
        //1. bonusPool
        uint256 currentAmount = _amount;
        uint256 gameBonusPercentVal = _amount.safeMul(20).safeDiv(100);
        uint256 teamBonusPercentVal = _amount.safeMul(15).safeDiv(100);
        uint256 bonusPoolPercentVal = _amount.safeMul(50).safeDiv(100);
        
        gameBonusPerPeriod[currentPeriod] = gameBonusPerPeriod[currentPeriod].safeAdd(gameBonusPercentVal);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        currentAmount = currentAmount.safeSub(gameBonusPercentVal);
        
        teamBonus = teamBonus.safeAdd(teamBonusPercentVal);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        currentAmount = currentAmount.safeSub(teamBonusPercentVal);
        
        bonusPool = bonusPool.safeAdd(bonusPoolPercentVal);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        currentAmount = currentAmount.safeSub(bonusPoolPercentVal);
        
        //invited bonus 
        uint256 bonusLevelOne = _amount.safeMul(10).safeDiv(100);
        uint256 bonusLevelTwo = _amount.safeMul(5).safeDiv(100);
        
        if(_invitedAddr != address(0x0)) {
            invitedRelations[_from] = _invitedAddr;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        if (invitedRelations[_from] != address(0x0)) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            address fa = invitedRelations[_from];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            invitedBonus[currentPeriod][fa] = invitedBonus[currentPeriod][fa].safeAdd(bonusLevelOne);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            balanceOf[fa] = balanceOf[fa].safeAdd(bonusLevelOne);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            currentAmount = currentAmount.safeSub(bonusLevelOne);
            address gfa = invitedRelations[fa];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            if (gfa != address(0x0)) {
               invitedBonus[currentPeriod][gfa] = invitedBonus[currentPeriod][gfa].safeAdd(bonusLevelTwo);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
               balanceOf[gfa] = balanceOf[gfa].safeAdd(bonusLevelTwo);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
               currentAmount = currentAmount.safeSub(bonusLevelTwo);
            }
        }
        assert(currentAmount >= 0);
        bonusPool = bonusPool.safeAdd(currentAmount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        //generate order and bonusCodes
        uint256 oId = block.timestamp;
        
        BonusCode memory bc = BonusCode({
            orderId: oId,
            prefix:  _fType,
            code:    bonusCodeNonce,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            nums:    _amount.safeDiv(stake),	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            addr:    _from, 
            period:  currentPeriod	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        });
        revealBonusCodes[currentPeriod][bonusCodeNonce] = bc;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bcodes[currentPeriod].push(bonusCodeNonce);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Bet(currentPeriod, oId, bonusCodeNonce, _from);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bonusCodeNonce = bonusCodeNonce.safeAdd(_amount.safeDiv(stake));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    event Debug(uint256 winnerIndex, uint256 bcodesLen, uint256 pos);
    function reveal(string memory _seed) public onlyAdmins {
        // random winner index
        
        uint256 winner = uint256(keccak256(abi.encodePacked(_seed, msg.sender, block.timestamp))) % bonusCodeNonce;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 lt = 0;
        uint256 rt = bcodes[currentPeriod].length - 1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(lt <= rt, "bcodes length is not correct");
        uint256 pos = lt;
        while (lt <= rt) {
            uint256 mid = lt + (rt - lt) / 2;
            if (bcodes[currentPeriod][mid] <= winner) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                pos = mid;
                lt = mid + 1;
            } else {
                rt = mid - 1;
            }
        }
        emit Debug(winner, bcodes[currentPeriod].length, pos);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        
        uint256 halfBonusPool = bonusPool.safeMul(50).safeDiv(100);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        BonusCode memory winnerBcode = revealBonusCodes[currentPeriod][bcodes[currentPeriod][pos]];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        // iterate;  
        uint256 bcodesLen = bcodes[currentPeriod].length;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        for (uint256 i = 0; i < bcodesLen; i++) {
            if (revealBonusCodes[currentPeriod][bcodes[currentPeriod][i]].prefix != winnerBcode.prefix) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                continue;
            }
            BonusCode memory thisBonusCode = revealBonusCodes[currentPeriod][bcodes[currentPeriod][i]];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            if (thisBonusCode.addr == winnerBcode.addr && thisBonusCode.orderId == winnerBcode.orderId) {
                balanceOf[winnerBcode.addr] = balanceOf[winnerBcode.addr].safeAdd(halfBonusPool);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            } else {
                uint256 bonusAmount = halfBonusPool.safeMul(
                    thisBonusCode.nums.safeMul(stake).safeDiv(sideTotalAmount[currentPeriod][winnerBcode.prefix])	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    );
                balanceOf[thisBonusCode.addr] = balanceOf[thisBonusCode.addr].safeAdd(bonusAmount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }
        }
        
        // update reveal result && reset value
        revealBonusPerPeriod[currentPeriod] = halfBonusPool;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        revealResultPerPeriod[currentPeriod] = winnerBcode;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        revealInfoByAddr[winnerBcode.addr].push(winnerBcode);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        currentPeriod++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bonusPool = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bonusCodeNonce = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        gameBonusPerPeriod[currentPeriod] = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        emit Reveal(currentPeriod - 1, winnerBcode.orderId, winnerBcode.prefix, winnerBcode.code, winnerBcode.addr, halfBonusPool);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function withdrawal(address _from, address payable _to, uint256 _amount) public {
        // permission check
        if (msg.sender != _from) {
            require(allowance[_from] == true && msg.sender == delegateAddr, "permission rejected");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        // amount check
        require(withdrawalFee <= _amount && _amount <= balanceOf[_from], "Don't have enough balance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        balanceOf[_from] = balanceOf[_from].safeSub(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _amount = _amount.safeSub(withdrawalFee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        teamBonus = teamBonus.safeAdd(withdrawalFee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
	  	_to.transfer(_amount);
	    emit Withdrawal(_to, _amount);
    }
    
    function teamWithdrawal() onlyAdmins public {
        require(teamBonus > 0, "Don't have enough teamBonus");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 tmp = teamBonus;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        teamBonus = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        msg.sender.transfer(tmp);
    }
    
    function gameBonusWithdrawal(uint16 _period) onlyAdmins public {
        require(gameBonusPerPeriod[_period] > 0, "Don't have enough money");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 tmp = gameBonusPerPeriod[_period];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        gameBonusPerPeriod[_period] = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
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
        return balanceOf[_addr];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function getBonusPool() public view returns(uint256) {
        return bonusPool;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function getBonusInvited(address _from) public view returns(uint256) {
        return invitedBonus[currentPeriod][_from];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function getRevealResultPerPeriod(uint16 _period) public view returns(uint8 _prefix, uint256 _orderId, uint256 _code, uint256 _nums, address _addr, uint256 _revealBonus) {
        _prefix = revealResultPerPeriod[_period].prefix;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _orderId = revealResultPerPeriod[_period].orderId;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _code = revealResultPerPeriod[_period].code;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _nums = revealResultPerPeriod[_period].nums;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _addr = revealResultPerPeriod[_period].addr;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _revealBonus = revealBonusPerPeriod[_period];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
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