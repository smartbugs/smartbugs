/**
 *Submitted for verification at Etherscan.io on 2020-04-16
*/

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.2;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
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
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.2;

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.5.2;



/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 * Originally based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 *
 * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
 * all accounts just by listening to said events. Note that this isn't required by the specification, and other
 * compliant implementations may not do it.
 */
contract ERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Total number of tokens in existence
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param owner The address to query the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param owner address The address which owns the funds.
     * @param spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    /**
     * @dev Transfer token for a specified address
     * @param to The address to transfer to.
     * @param value The amount to be transferred.
     */
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another.
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _transfer(from, to, value);
        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
        return true;
    }

    /**
     * @dev Transfer token for a specified addresses
     * @param from The address to transfer from.
     * @param to The address to transfer to.
     * @param value The amount to be transferred.
     */
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created tokens.
     * @param value The amount that will be created.
     */
    function mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev Approve an address to spend another addresses' tokens.
     * @param owner The address that owns the tokens.
     * @param spender The address that will spend the tokens.
     * @param value The number of tokens that can be spent.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(spender != address(0));
        require(owner != address(0));

        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _burn(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol

pragma solidity ^0.5.2;


/**
 * @title Capped token
 * @dev Mintable token with a token cap.
 */
contract ERC20Capped is ERC20 {
    uint256 private _cap;

    constructor (uint256 cap) public {
        require(cap > 0);
        _cap = cap;
    }

    /**
     * @return the cap for the token minting.
     */
    function cap() public view returns (uint256) {
        return _cap;
    }

    function _mint(address account, uint256 value) internal {
        require(totalSupply().add(value) <= _cap);
        super.mint(account, value);
    }
}

// File: contracts/ITAMToken.sol

pragma solidity ^0.5.2;




contract ITAMToken is ERC20Capped {
    string public name = "ITAM";
    string public symbol = "ITAM";
    uint8 public decimals = 18;
    uint256 constant TOTAL_CAP = 2500000000 ether;

    address public firstMaster;
    address public secondMaster;
    address public thirdMaster;
    mapping(address => mapping(address => bool)) public decidedOwner;
    
    address public owner;
    address public gameMaster;
    mapping(address => bool) public blackLists;

    uint8 public unlockCount = 0;
    address public strategicSaleAddress;
    uint[] public strategicSaleReleaseCaps = [15000000 ether, 15000000 ether, 15000000 ether, 
                                              15000000 ether, 15000000 ether, 15000000 ether,
                                              15000000 ether, 22500000 ether, 22500000 ether];

    address public privateSaleAddress;
    uint[] public privateSaleReleaseCaps = [97500000 ether, 97500000 ether, 97500000 ether,
                                            97500000 ether, 130000000 ether, 130000000 ether];

    address public publicSaleAddress;
    uint public publicSaleReleaseCap = 200000000 ether;

    address public teamAddress;
    uint[] public teamReleaseCaps = [0, 0, 0, 0, 0, 0,
                                     12500000 ether, 12500000 ether, 12500000 ether,
                                     12500000 ether, 12500000 ether, 12500000 ether,
                                     12500000 ether, 12500000 ether, 12500000 ether,
                                     12500000 ether, 12500000 ether, 12500000 ether,
                                     12500000 ether, 12500000 ether, 12500000 ether,
                                     12500000 ether, 12500000 ether, 12500000 ether,
                                     12500000 ether, 12500000 ether];

    address public advisorAddress;
    uint[] public advisorReleaseCaps = [0, 0, 0, 25000000 ether, 0, 25000000 ether,
                                        0, 25000000 ether, 0, 25000000 ether, 0, 25000000 ether];
    
    address public marketingAddress;
    uint[] public marketingReleaseCaps = [100000000 ether, 25000000 ether, 25000000 ether,
                                          25000000 ether, 25000000 ether, 25000000 ether,
                                          25000000 ether, 25000000 ether, 25000000 ether,
                                          25000000 ether, 25000000 ether, 25000000 ether];
    
    address public ecoAddress;
    uint[] public ecoReleaseCaps = [50000000 ether, 50000000 ether, 50000000 ether,
                                    50000000 ether, 50000000 ether, 50000000 ether,
                                    50000000 ether, 50000000 ether, 50000000 ether,
                                    50000000 ether, 50000000 ether, 50000000 ether,
                                    50000000 ether, 50000000 ether, 50000000 ether];
    address payable public inAppAddress;

    ERC20 erc20;

    // appId => itemId => tokenAddress => amount
    mapping(uint64 => mapping(uint64 => mapping(address => uint256))) items;

    event Unlock(uint8 unlockCount);
    event WithdrawEther(address indexed _to, uint256 amount);
    event PurchaseItemOnEther(address indexed _spender, uint64 appId, uint64 itemId, uint256 amount);
    event PurchaseItemOnITAM(address indexed _spender, uint64 appId, uint64 itemId, uint256 amount);
    event PurchaseItemOnERC20(address indexed _spender, address indexed _tokenAddress, uint64 appId, uint64 itemId, uint256 amount);
    event SetItem(uint64 appId);
    event ChangeOwner(address _owner);

    constructor(address _firstMaster, address _secondMaster, address _thirdMaster,
                address _owner, address _gameMaster, address _strategicSaleAddress,
                address _privateSaleAddress, address _publicSaleAddress, address _teamAddress,
                address _advisorAddress, address _marketingAddress, address _ecoAddress, address payable _inAppAddress) public ERC20Capped(TOTAL_CAP) {
        firstMaster = _firstMaster;
        secondMaster = _secondMaster;
        thirdMaster = _thirdMaster;
        owner = _owner;
        gameMaster = _gameMaster;
        strategicSaleAddress = _strategicSaleAddress;
        privateSaleAddress = _privateSaleAddress;
        publicSaleAddress = _publicSaleAddress;
        teamAddress = _teamAddress;
        advisorAddress = _advisorAddress;
        marketingAddress = _marketingAddress;
        ecoAddress = _ecoAddress;
        inAppAddress = _inAppAddress;
    }

    modifier onlyOwner {
        require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION
        _;
    }
    
    modifier onlyGameMaster {
        require(tx.origin == gameMaster);	//inject USING TX ORIGIN FOR AUTHENTICATION
        _;
    }
    
    modifier onlyMaster {
        require(msg.sender == firstMaster || msg.sender == secondMaster || msg.sender == thirdMaster);
        _;
    }
    
    function setGameMaster(address _gameMaster) public onlyOwner {
        gameMaster = _gameMaster;
    }

    function transfer(address _to, uint256 _value) public onlyNotBlackList returns (bool)  {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public onlyNotBlackList returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function approve(address spender, uint256 value) public onlyNotBlackList returns (bool) {
        return super.approve(spender, value);
    }

    function burn(uint256 value) public onlyOwner {
        super._burn(msg.sender, value);
    }

    function unlock() public onlyOwner returns (bool) {
        uint8 _unlockCount = unlockCount;

        if(strategicSaleReleaseCaps.length > _unlockCount) {
            super._mint(strategicSaleAddress, strategicSaleReleaseCaps[_unlockCount]);
        }

        if(privateSaleReleaseCaps.length > _unlockCount) {
            super._mint(privateSaleAddress, privateSaleReleaseCaps[_unlockCount]);
        }

        if(_unlockCount == 0) {
            super._mint(publicSaleAddress, publicSaleReleaseCap);
        }

        if(teamReleaseCaps.length > _unlockCount) {
            super._mint(teamAddress, teamReleaseCaps[_unlockCount]);
        }

        if(advisorReleaseCaps.length > _unlockCount) {
            super._mint(advisorAddress, advisorReleaseCaps[_unlockCount]);
        }

        if(marketingReleaseCaps.length > _unlockCount) {
            super._mint(marketingAddress, marketingReleaseCaps[_unlockCount]);
        }

        if(ecoReleaseCaps.length > _unlockCount) {
            super._mint(ecoAddress, ecoReleaseCaps[_unlockCount]);
        }

        unlockCount++;
        return true;
    }

    function setAddresses(address _strategicSaleAddress, address _privateSaleAddress, address _publicSaleAddress, address _teamAddress, address _advisorAddress, address _marketingAddress, address _ecoAddress,
                          address payable _inAppAddress) public onlyOwner {
        strategicSaleAddress = _strategicSaleAddress;
        privateSaleAddress = _privateSaleAddress;
        publicSaleAddress = _publicSaleAddress;
        teamAddress = _teamAddress;
        advisorAddress = _advisorAddress;
        marketingAddress = _marketingAddress;
        ecoAddress = _ecoAddress;
        inAppAddress = _inAppAddress;
    }
    
    function changeOwner(address _owner) public onlyMaster {
        decidedOwner[msg.sender][_owner] = true;
        
        uint16 decidedCount = 0;
        if (decidedOwner[firstMaster][_owner] == true) {
            decidedCount += 1;
        }
        if (decidedOwner[secondMaster][_owner] == true)  {
            decidedCount += 1;
        }
        if (decidedOwner[thirdMaster][_owner] == true) {
            decidedCount += 1;
        }
        
        if (decidedCount >= 2) {
            owner = _owner;
            emit ChangeOwner(_owner);
        }
    }
    
    function addToBlackList(address _to) public onlyOwner {
        require(!blackLists[_to], "already blacklist");
        blackLists[_to] = true;
    }
    
    function removeFromBlackList(address _to) public onlyOwner {
        require(blackLists[_to], "cannot found this address from blacklist");
        blackLists[_to] = false;
    }

    modifier onlyNotBlackList {
        require(!blackLists[msg.sender], "sender cannot call this contract");
        _;
    }
    
    // can accept ether
    function() payable external {
        
    }

    function withdrawEther(uint256 amount) public onlyOwner {
        inAppAddress.transfer(amount);
        emit WithdrawEther(inAppAddress, amount);
    }

    function createOrUpdateItem(uint64 appId, uint64[] memory itemIds, address[] memory tokenAddresses, uint256[] memory values) public onlyGameMaster returns(bool) {
        uint itemLength = itemIds.length;
        require(itemLength == tokenAddresses.length && tokenAddresses.length == values.length);
        
        uint64 itemId;
        address tokenAddress;
        uint256 value;
        for(uint16 i = 0; i < itemLength; i++) {
            itemId = itemIds[i];
            tokenAddress = tokenAddresses[i];
            value = values[i];

            items[appId][itemId][tokenAddress] = value;
        }
        
        emit SetItem(appId);
        return true;
    }
    
    function _getItemAmount(uint64 appId, uint64 itemId, address tokenAddress) private view returns(uint256) {
        uint256 itemAmount = items[appId][itemId][tokenAddress];
        require(itemAmount > 0, "invalid item id");
        return itemAmount;
    }

    function purchaseItemOnERC20(address payable tokenAddress, uint64 appId, uint64 itemId) external onlyNotBlackList returns(bool) {
        uint256 itemAmount = _getItemAmount(appId, itemId, tokenAddress);

        erc20 = ERC20(tokenAddress);
        require(erc20.transferFrom(msg.sender, inAppAddress, itemAmount), "failed transferFrom");

        emit PurchaseItemOnERC20(msg.sender, tokenAddress, appId, itemId, itemAmount);
        return true;
    }

    function purchaseItemOnITAM(uint64 appId, uint64 itemId) external onlyNotBlackList returns(bool) {
        uint256 itemAmount = _getItemAmount(appId, itemId, address(this));

        transfer(inAppAddress, itemAmount);
        
        emit PurchaseItemOnITAM(msg.sender, appId, itemId, itemAmount);
        return true;
    }

    function purchaseItemOnEther(uint64 appId, uint64 itemId) external payable onlyNotBlackList returns(bool) {
        uint256 itemAmount = _getItemAmount(appId, itemId, address(0));
        require(itemAmount == msg.value, "wrong quantity");
        
        emit PurchaseItemOnEther(msg.sender, appId, itemId, msg.value);
        return true;
    }
}