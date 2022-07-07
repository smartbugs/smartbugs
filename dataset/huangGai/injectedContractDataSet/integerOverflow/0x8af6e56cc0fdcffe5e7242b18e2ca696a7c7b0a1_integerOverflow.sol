/**
 *Submitted for verification at Etherscan.io on 2020-02-20
*/

/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */

pragma solidity 0.5.2;

/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool wasInitializing = initializing;
    initializing = true;
    initialized = true;

    _;

    initializing = wasInitializing;
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    uint256 cs;
    assembly { cs := extcodesize(address) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap; // solium-disable-line mixedcase
}


/**
 * @title Adminable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Adminable is Initializable {

  /**
   * @dev Storage slot with the admin of the contract.
   * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
   * validated in the constructor.
   */
  bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;

  /**
   * @dev Modifier to check whether the `msg.sender` is the admin.
   * If it is, it will run the function. Otherwise, fails.
   */
  modifier ifAdmin() {
    require(msg.sender == _admin(), "sender not admin");
    _;
  }

  function admin() external view returns (address) {
    return _admin();
  }

  function implementation() external view returns (address impl) {
    bytes32 slot = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
    assembly {
      impl := sload(slot)
    }
  }

  /**
   * @return The admin slot.
   */
  function _admin() internal view returns (address adm) {
    bytes32 slot = ADMIN_SLOT;
    assembly {
      adm := sload(slot)
    }
  }
}


contract Bridge is Adminable {


  struct Period {
    uint32 height;            // the height of last block in period
    uint32 timestamp;         // the block.timestamp at submission of period
    uint32 parentBlockNumber; // the block.number at submission of period
    bytes32 parentBlockHash;  // the blockhash(block.number -1) at submission of period
  }

  address public operator; // the operator contract

  mapping(bytes32 => Period) public periods;

}

contract Vault {


  function getTokenAddr(uint16 _color) public view returns (address) {
  }


}



contract SwapExchange {

  address factory;
  address token;
  address nativeToken;
  bytes32 public name;
  bytes32 public symbol;
  uint256 public decimals;

  function setup(address _nativeToken, address _tokenAddr) public {
    require(factory == address(0) && token == address(0), "setup can only be executed once");
    require(_nativeToken != address(0), "tokenAddr not valid");
    require(_tokenAddr != address(0), "tokenAddr not valid");
    factory = msg.sender;
    token = _tokenAddr;
    nativeToken = _nativeToken;
    name = 0x4c65617020537761702056310000000000000000000000000000000000000000;   // Leap Swap V1
    symbol = 0x4c4541502d563100000000000000000000000000000000000000000000000000; // LEAP-V1
    decimals = 18;
  }

  // to be implemented

}

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev give an account access to this role
     */
    function add(Role storage role, address account) internal {
        require(account != address(0));
        require(!has(role, account));

        role.bearer[account] = true;
    }

    /**
     * @dev remove an account's access to this role
     */
    function remove(Role storage role, address account) internal {
        require(account != address(0));
        require(has(role, account));

        role.bearer[account] = false;
    }

    /**
     * @dev check if an account has this role
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0));
        return role.bearer[account];
    }
}
contract MinterRole {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    constructor () internal {
        _addMinter(msg.sender);
    }

    modifier onlyMinter() {
        require(isMinter(msg.sender));
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyMinter {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(msg.sender);
    }

    function _addMinter(address account) internal {
        _minters.add(account);
        emit MinterAdded(account);
    }

    function _removeMinter(address account) internal {
        _minters.remove(account);
        emit MinterRemoved(account);
    }
}
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
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

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
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
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
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        _transfer(from, to, value);
        emit Approval(from, msg.sender, _allowed[from][msg.sender]);
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
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
    function _mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * Emits an Approval event (reflecting the reduced allowance).
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 value) internal {
        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
        _burn(account, value);
        emit Approval(account, msg.sender, _allowed[account][msg.sender]);
    }
}

/**
 * @title ERC20Mintable
 * @dev ERC20 minting logic
 */
contract ERC20Mintable is ERC20, MinterRole {
    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param value The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address to, uint256 value) public onlyMinter returns (bool) {
        _mint(to, value);
        return true;
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
        //require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //require(c >= a);

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

contract SwapRegistryMigration is Adminable {
  using SafeMath for uint256;

  // Claim Related
  Bridge bridge;
  Vault vault;
  uint256 constant maxTax = 1000; // 100%
  uint256 taxRate; // as perMil (1000 == 100%, 1 == 0.1%)
  uint256 constant inflationFactor = 10 ** 15;
  uint256 constant maxInflation = 2637549827; // the x from (1 + x*10^-18)^(30 * 24 * 363) = 2
  uint256 inflationRate; // between 0 and maxInflation/inflationFactor
  uint256 constant poaSupplyTarget = 7000000 * 10 ** 18;
  uint256 poaReward;
  mapping(uint256 => uint256) public slotToHeight;

  function initialize(
    address _bridge,
    address _vault,
    uint256 _poaReward
  ) public initializer {
    require(_bridge != address(0), "invalid bridge address");
    bridge = Bridge(_bridge);
    require(_bridge != address(0), "invalid vault address");
    vault = Vault(_vault);
    // todo: check that this contract is admin of token;
    taxRate = maxTax;
    inflationRate = maxInflation;
    poaReward = _poaReward;
  }

  function claim(
    uint256 _slotId,
    bytes32[] memory _consensusRoots,
    bytes32[] memory _cas,
    bytes32[] memory _validatorData,
    bytes32[] memory _rest
  ) public {
    uint256 maxHeight = slotToHeight[_slotId];
    uint32 claimCount = 0;
    for (uint256 i = 0; i < _consensusRoots.length; i += 1) {
      require(_slotId == uint256(_validatorData[i] >> 160), "unexpected slotId");
      require(msg.sender == address(uint160(uint256(_validatorData[i]))), "unexpected claimant");
      uint256 height;
      bytes32 left = _validatorData[i];
      bytes32 right = _rest[i];
      assembly {
        mstore(0, left)
        mstore(0x20, right)
        right := keccak256(0, 0x40)
      }
      left = _cas[i];
      assembly {
        mstore(0, left)
        mstore(0x20, right)
        right := keccak256(0, 0x40)
      }
      left = _consensusRoots[i];
      assembly {
        mstore(0, left)
        mstore(0x20, right)
        right := keccak256(0, 0x40)
      }
      (height ,,,) = bridge.periods(right);
      require(height > maxHeight, "unorderly claim");
      maxHeight = height;
      claimCount += 1;
    }
    slotToHeight[_slotId] = maxHeight;
    ERC20Mintable token = ERC20Mintable(vault.getTokenAddr(0));
    uint256 total = token.totalSupply();
    uint256 staked = token.balanceOf(bridge.operator());

    // calculate reward according to:
    // https://ethresear.ch/t/riss-reflexive-inflation-through-staked-supply/3633
    uint256 reward = total.mul(inflationRate).div(inflationFactor);
    if (staked > total.div(2)) {
      reward = reward.mul(total.sub(staked).mul(staked).mul(4)).div(total);
    }
    if (total < poaSupplyTarget) {
      reward = poaReward;
    }
    reward = reward.mul(claimCount);
    uint256 tax = reward.mul(taxRate).div(maxTax);  // taxRate perMil (1000 == 100%, 1 == 0.1%)
    // mint tokens
    token.mint(msg.sender, reward.sub(tax));
    token.mint(bridge.admin(), tax);
  }

  // Governance Params

  function getTaxRate() public view returns(uint256) {
    return taxRate;
  }

  function setTaxRate(uint256 _taxRate) public ifAdmin {
    require(_taxRate <= maxTax, "tax rate can not be more than 100%");
    taxRate = _taxRate;
  }

  function getInflationRate() public view returns(uint256) {
    return inflationRate;
  }

  function setInflationRate(uint256 _inflationRate) public ifAdmin {
    require(_inflationRate < maxInflation, "inflation too high");
    inflationRate = _inflationRate;
  }

  // Swap Exchanges

  event NewExchange(address indexed token, address indexed exchange);
  mapping(address => address) tokenToExchange;
  mapping(address => address) exchangeToToken;
  address exchangeCodeAddr;

  function createExchange(address _token) public returns (address) {
    require(_token != address(0), "invalid token address");
    address nativeToken = vault.getTokenAddr(0);
    require(_token != nativeToken, "token can not be nativeToken");
    require(tokenToExchange[_token] == address(0), "exchange already created");
    address exchange = createClone(exchangeCodeAddr);
    SwapExchange(exchange).setup(nativeToken, _token);
    tokenToExchange[_token] = exchange;
    exchangeToToken[exchange] = _token;
    emit NewExchange(_token, exchange);
    return exchange;
  }

  function getExchangeCodeAddr() public view returns(address) {
    return exchangeCodeAddr;
  }

  function setExchangeCodeAddr(address _exchangeCodeAddr) public ifAdmin {
    exchangeCodeAddr = _exchangeCodeAddr;
  }

  function getExchange(address _token) public view returns(address) {
    return tokenToExchange[_token];
  }

  function getToken(address _exchange) public view returns(address) {
    return exchangeToToken[_exchange];
  }

  function createClone(address target) internal returns (address result) {
    bytes20 targetBytes = bytes20(target);
    assembly {
      let clone := mload(0x40)
      mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
      mstore(add(clone, 0x14), targetBytes)
      mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
      result := create(0, clone, 0x37)
    }
  }

  modifier onlyMultisig() {
    require(msg.sender == 0xC5cDcD5470AEf35fC33BDDff3f8eCeC027F95B1d, "msg.sender not multisig");
    _;
  }

  function transferMinter() public onlyMultisig {
    ERC20Mintable token = ERC20Mintable(vault.getTokenAddr(0));
    token.addMinter(msg.sender);
    token.renounceMinter();
  }

}