/**
 *Submitted for verification at Etherscan.io on 2020-02-20
*/

/**
 *Submitted for verification at Etherscan.io on 2020-02-17
*/

pragma solidity ^0.5.2;

/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */



/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */

/* solium-disable security/no-block-members */



/**
 * @title Math
 * @dev Assorted math operations
 */
library Math {
    /**
    * @dev Returns the largest of two numbers.
    */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
    * @dev Returns the smallest of two numbers.
    */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
    * @dev Calculates the average of two numbers. Since these are integers,
    * averages of an even and odd number cannot be represented, and will be
    * rounded down.
    */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */



/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */



/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */



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
/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */



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
  using SafeMath for uint256;

  modifier onlyOperator() {
    require(msg.sender == operator, "Tried to call a only-operator function from non-operator");
    _;
  }

  event NewHeight(uint256 height, bytes32 indexed root);
  event NewOperator(address operator);

  struct Period {
    uint32 height;            // the height of last block in period
    uint32 timestamp;         // the block.timestamp at submission of period
    uint32 parentBlockNumber; // the block.number at submission of period
    bytes32 parentBlockHash;  // the blockhash(block.number -1) at submission of period
  }

  bytes32 constant GENESIS = 0x4920616d207665727920616e6772792c20627574206974207761732066756e21;

  bytes32 public tipHash; // hash of first period that has extended chain to some height
  uint256 public genesisBlockNumber;
  uint256 parentBlockInterval; // how often epochs can be submitted max
  uint256 public lastParentBlock; // last ethereum block when epoch was submitted
  address public operator; // the operator contract

  mapping(bytes32 => Period) public periods;

  function initialize(uint256 _parentBlockInterval) public initializer {
    // init genesis preiod
    Period memory genesisPeriod = Period({
      height: 1,
      timestamp: uint32(block.timestamp),
      parentBlockNumber: uint32(block.number),
      parentBlockHash: blockhash(block.number-1)
    });
    tipHash = GENESIS;
    periods[GENESIS] = genesisPeriod;
    genesisBlockNumber = block.number;
    parentBlockInterval = _parentBlockInterval;
    operator = msg.sender;
  }

  function setOperator(address _operator) public ifAdmin {
    operator = _operator;
    emit NewOperator(_operator);
  }

  function getParentBlockInterval() public view returns (uint256) {
    return parentBlockInterval;
  }

  function setParentBlockInterval(uint256 _parentBlockInterval) public ifAdmin {
    parentBlockInterval = _parentBlockInterval;
  }

  function deletePeriod(bytes32 _root) public onlyOperator {
    delete periods[_root];
  }

  function submitPeriod(
    bytes32 _prevHash,
    bytes32 _root)
  public onlyOperator returns (uint256 newHeight) {

    require(periods[_prevHash].timestamp > 0, "Parent node should exist");
    require(periods[_root].timestamp == 0, "Trying to submit the same root twice");

    // calculate height
    newHeight = periods[_prevHash].height + 1;
    // do some magic if chain extended
    if (newHeight > periods[tipHash].height) {
      // new periods can only be submitted every x Ethereum blocks
      require(
        block.number >= lastParentBlock + parentBlockInterval,
        "Tried to submit new period too soon"
      );
      tipHash = _root;
      lastParentBlock = block.number;
    }
    // strictly speaking this event should be called "New Period"
    // but we don't want to break interfaces for now.
    emit NewHeight(newHeight, _root);
    // store the period
    Period memory newPeriod = Period({
      height: uint32(newHeight),
      timestamp: uint32(block.timestamp),
      parentBlockNumber: uint32(block.number),
      parentBlockHash: blockhash(block.number-1)
    });
    periods[_root] = newPeriod;
  }
}

/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */




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
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */



/**
 * @title IERC165
 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
 */
interface IERC165 {
    /**
     * @notice Query if a contract implements an interface
     * @param interfaceId The interface identifier, as specified in ERC-165
     * @dev Interface identification is specified in ERC-165. This function
     * uses less than 30,000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @title ERC165
 * @author Matt Condon (@shrugs)
 * @dev Implements ERC165 using a lookup table.
 */
contract ERC165 is IERC165 {
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    /**
     * 0x01ffc9a7 ===
     *     bytes4(keccak256('supportsInterface(bytes4)'))
     */

    /**
     * @dev a mapping of interface id to whether or not it's supported
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    /**
     * @dev A contract implementing SupportsInterfaceWithLookup
     * implement ERC165 itself
     */
    constructor () internal {
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    /**
     * @dev implement supportsInterface(bytes4) using a lookup table
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    /**
     * @dev internal method for registering an interface
     */
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff);
        _supportedInterfaces[interfaceId] = true;
    }
}


contract TransferrableToken is ERC165 {
  function transferFrom(address _from, address _to, uint256 _valueOrTokenId) public;
  function approve(address _to, uint256 _value) public;
}

/**
 * @title PriorityQueue
 * @dev A priority queue implementation
 */

library PriorityQueue {
  using SafeMath for uint256;

  struct Token {
    TransferrableToken addr;
    uint256[] heapList;
    uint256 currentSize;
  }

  function insert(Token storage self, uint256 k) internal {
    self.heapList.push(k);
    self.currentSize = self.currentSize.add(1);
    percUp(self, self.currentSize);
  }

  function minChild(Token storage self, uint256 i) internal view returns (uint256) {
    if (i.mul(2).add(1) > self.currentSize) {
      return i.mul(2);
    } else {
      if (self.heapList[i.mul(2)] < self.heapList[i.mul(2).add(1)]) {
        return i.mul(2);
      } else {
        return i.mul(2).add(1);
      }
    }
  }

  function getMin(Token storage self) internal view returns (uint256) {
    return self.heapList[1];
  }

  function delMin(Token storage self) internal returns (uint256) {
    uint256 retVal = self.heapList[1];
    self.heapList[1] = self.heapList[self.currentSize];
    delete self.heapList[self.currentSize];
    self.currentSize = self.currentSize.sub(1);
    percDown(self, 1);
    self.heapList.length = self.heapList.length.sub(1);
    return retVal;
  }

  // solium-disable-next-line security/no-assign-params
  function percUp(Token storage self, uint256 i) private {
    uint256 j = i;
    uint256 newVal = self.heapList[i];
    while (newVal < self.heapList[i.div(2)]) {
      self.heapList[i] = self.heapList[i.div(2)];
      i = i.div(2);
    }
    if (i != j) self.heapList[i] = newVal;
  }

  // solium-disable-next-line security/no-assign-params
  function percDown(Token storage self, uint256 i) private {
    uint256 j = i;
    uint256 newVal = self.heapList[i];
    uint256 mc = minChild(self, i);
    while (mc <= self.currentSize && newVal > self.heapList[mc]) {
      self.heapList[i] = self.heapList[mc];
      i = mc;
      mc = minChild(self, i);
    }
    if (i != j) self.heapList[i] = newVal;
  }

}

/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */


/**
 * @dev Interface of the ERC1948 contract.
 */
interface IERC1948 {

  /**
   * @dev Emitted when `oldData` is replaced with `newData` in storage of `tokenId`.
   *
   * Note that `oldData` or `newData` may be empty bytes.
   */
  event DataUpdated(uint256 indexed tokenId, bytes32 oldData, bytes32 newData);

  /**
   * @dev Reads the data of a specified token. Returns the current data in
   * storage of `tokenId`.
   *
   * @param tokenId The token to read the data off.
   *
   * @return A bytes32 representing the current data stored in the token.
   */
  function readData(uint256 tokenId) external view returns (bytes32);

  /**
   * @dev Updates the data of a specified token. Writes `newData` into storage
   * of `tokenId`.
   *
   * @param tokenId The token to write data to.
   * @param newData The data to be written to the token.
   *
   * Emits a `DataUpdated` event.
   */
  function writeData(uint256 tokenId, bytes32 newData) external;

}

contract Vault is Adminable {
  using PriorityQueue for PriorityQueue.Token;

  // 2**15 + 1
  uint16 constant NFT_FIRST_COLOR = 32769;
  // 2**15 + 2**14 + 1
  uint16 constant NST_FIRST_COLOR = 49153;

  event NewToken(address indexed tokenAddr, uint16 color);

  Bridge public bridge;

  uint16 public erc20TokenCount;
  uint16 public nftTokenCount;
  uint16 public nstTokenCount;

  mapping(uint16 => PriorityQueue.Token) public tokens;
  mapping(address => bool) public tokenColors;

  function initialize(Bridge _bridge) public initializer {
    bridge = _bridge;
  }

  function getTokenAddr(uint16 _color) public view returns (address) {
    return address(tokens[_color].addr);
  }

  // token types: 0 = ERC20, 1 = ERC721, 2 = ERC1948
  function registerToken(address _token, uint256 _type) public ifAdmin {
    // make sure token is not 0x0 and that it has not been registered yet
    require(_token != address(0), "Tried to register 0x0 address");
    require(!tokenColors[_token], "Token already registered");
    uint16 color;
    if (_type == 0) {
      require(ERC20(_token).totalSupply() >= 0, "Not an ERC20 token");
      color = erc20TokenCount;
      erc20TokenCount += 1;
    } else if (_type == 1) {
      // max nft count without being an NST is 16384
      // color must be < 49153
      require(nftTokenCount < 0x4000, "NFT color out of bounds");
      require(TransferrableToken(_token).supportsInterface(0x80ac58cd) == true, "Not an ERC721 token");
      color = NFT_FIRST_COLOR + nftTokenCount; // NFT color namespace starts from 2^15 + 1
      nftTokenCount += 1;
    } else {
      require(nstTokenCount < 0x3ffe, "NST color out of bounds");
      require(TransferrableToken(_token).supportsInterface(0x80ac58cd) == true, "Not an ERC721 token");
      color = NST_FIRST_COLOR + nstTokenCount; // NST color namespace starts from 2^15 + 2^14 + 1
      nstTokenCount += 1;
    }
    uint256[] memory arr = new uint256[](1);
    tokenColors[_token] = true;
    tokens[color] = PriorityQueue.Token({
      addr: TransferrableToken(_token),
      heapList: arr,
      currentSize: 0
    });
    emit NewToken(_token, color);
  }

  // solium-disable-next-line mixedcase
  uint256[49] private ______gap;

}



contract DepositHandler is Vault {

  event NewDeposit(
    uint32 indexed depositId,
    address indexed depositor,
    uint256 indexed color,
    uint256 amount
  );
  event MinGasPrice(uint256 minGasPrice);
  // Support for NSTs
  event NewDepositV2(
    uint32 indexed depositId,
    address indexed depositor,
    uint256 indexed color,
    uint256 amount,
    bytes32 data
  );

  struct Deposit {
    uint64 time;
    uint16 color;
    address owner;
    uint256 amount;
  }

  uint32 public depositCount;
  uint256 public minGasPrice;

  mapping(uint32 => Deposit) public deposits;
  mapping(uint32 => bytes32) public tokenData;

  function setMinGasPrice(uint256 _minGasPrice) public ifAdmin {
    minGasPrice = _minGasPrice;
    emit MinGasPrice(minGasPrice);
  }

 /**
  * @notice Add to the network `(_amountOrTokenId)` amount of a `(_color)` tokens
  * or `(_amountOrTokenId)` token id if `(_color)` is NFT.
  *
  * !!!! DEPRECATED, use depositBySender() instead !!!!
  *
  * @dev Token should be registered with the Bridge first.
  * @param _owner Account to transfer tokens from
  * @param _amountOrTokenId Amount (for ERC20) or token ID (for ERC721) to transfer
  * @param _color Color of the token to deposit
  */
  function deposit(address _owner, uint256 _amountOrTokenId, uint16 _color) public {
    require(_owner == msg.sender, "owner different from msg.sender");
    _deposit(_amountOrTokenId, _color);
  }

  function depositBySender(uint256 _amountOrTokenId, uint16 _color) public {
    _deposit(_amountOrTokenId, _color);
  }

  function _deposit(uint256 _amountOrTokenId, uint16 _color) internal {
    TransferrableToken token = tokens[_color].addr;
    require(address(token) != address(0), "Token color already registered");
    require(_amountOrTokenId > 0 || _color > 32769, "no 0 deposits for fungible tokens");

    bytes32 _tokenData;

    if (_color >= NST_FIRST_COLOR) {
      IERC1948 nst = IERC1948(address(token));
      // XXX: maybe we need a 'support' getter here, to announce support?
      _tokenData = nst.readData(_amountOrTokenId);
    }

    token.transferFrom(msg.sender, address(this), _amountOrTokenId);

    bytes32 tipHash = bridge.tipHash();
    uint256 timestamp;
    (, timestamp,,) = bridge.periods(tipHash);

    depositCount++;
    deposits[depositCount] = Deposit({
      time: uint32(timestamp),
      owner: msg.sender,
      color: _color,
      amount: _amountOrTokenId
    });

    if (_color >= NST_FIRST_COLOR) {
      tokenData[depositCount] = _tokenData;

      emit NewDepositV2(
        depositCount,
        msg.sender,
        _color,
        _amountOrTokenId,
        _tokenData
      );
    } else {
      emit NewDeposit(
        depositCount,
        msg.sender,
        _color,
        _amountOrTokenId
      );
    }
  }

  // solium-disable-next-line mixedcase
  uint256[49] private ______gap;
}
/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */

/* solium-disable security/no-block-members */



contract IExitHandler {

  function startExit(bytes32[] memory, bytes32[] memory, uint8, uint8) public payable;

}

/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */

library TxLib {
  uint constant internal WORD_SIZE = 32;
  uint constant internal ONES = ~uint(0);
  enum TxType { None0, None1, Deposit, Transfer, None4, None5,
  None6, None7, None8, None9, None10, None11, None12, SpendCond }
  struct Outpoint {
    bytes32 hash;
    uint8 pos;
  }
  struct Input {
    Outpoint outpoint;
    bytes32 r;
    bytes32 s;
    uint8 v;
    bytes script;
    bytes msgData;
  }
  struct Output {
    uint256 value;
    uint16 color;
    address owner;
    bytes32 stateRoot;
  }
  struct Tx {
    TxType txType;
    Input[] ins;
    Output[] outs;
  }
  function parseInput(
    TxType _type, bytes memory _txData, uint256 _pos, uint256 offset, Input[] memory _ins
  ) internal pure returns (uint256 newOffset) {
    bytes32 inputData;
    uint8 index;
    if (_type == TxType.Deposit) {
      assembly {
        // load the depositId (4 bytes) starting from byte 2 of tx
        inputData := mload(add(add(offset, 4), _txData))
      }
      inputData = bytes32(uint256(uint32(uint256(inputData))));
      index = 0;
      newOffset = offset + 4;
    } else {
      assembly {
        // load the prevHash (32 bytes) from input
        inputData := mload(add(add(offset, 32), _txData))
        // load the output index (1 byte) from input
        index := mload(add(add(offset, 33), _txData))
      }
      newOffset = offset + 33;
    }
    Outpoint memory outpoint = Outpoint(inputData, index);
    bytes memory data = new bytes(0);
    Input memory input = Input(outpoint, 0, 0, 0, data, data); // solium-disable-line arg-overflow
    if (_type == TxType.SpendCond) {
      uint16 len;
      assembly {
        len := mload(add(add(offset, 35), _txData))
      }
      // read msgData
      data = new bytes(len);
      uint src;
      uint dest;
      assembly {
        src := add(add(add(offset, 35), 0x20), _txData)
        dest := add(data, 0x20)
      }
      memcopy(src, dest, len);
      input.msgData = data;
      newOffset = offset + 37 + len;
      assembly {
        len := mload(add(newOffset, _txData))
      }
      // read script
      data = new bytes(len);
      assembly {
        src := add(add(add(newOffset, 0), 0x20), _txData)
        dest := add(data, 0x20)
      }
      memcopy(src, dest, len);
      input.script = data;
      newOffset = newOffset + len;
    }
    if (_type == TxType.Transfer) {
      bytes32 r;
      bytes32 s;
      uint8 v;
      assembly {
        r := mload(add(add(offset, 65), _txData))
        s := mload(add(add(offset, 97), _txData))
        v := mload(add(add(offset, 98), _txData))
      }
      input.r = r;
      input.s = s;
      input.v = v;
      newOffset = offset + 33 + 65;
    }
    _ins[_pos] = input;
  }
  // Copies 'len' bytes from 'srcPtr' to 'destPtr'.
  // NOTE: This function does not check if memory is allocated, it only copies the bytes.
  function memcopy(uint srcPtr, uint destPtr, uint len) internal pure {
    uint offset = 0;
    uint size = len / WORD_SIZE;
    // Copy word-length chunks while possible.
    for (uint i = 0; i < size; i++) {
      offset = i * WORD_SIZE;
      assembly {
        mstore(add(destPtr, offset), mload(add(srcPtr, offset)))
      }
    }
    offset = size*WORD_SIZE;
    uint mask = ONES << 8*(32 - len % WORD_SIZE);
    assembly {
      let nSrc := add(srcPtr, offset)
      let nDest := add(destPtr, offset)
      mstore(nDest, or(and(mload(nSrc), mask), and(mload(nDest), not(mask))))
    }
  }
  function parseOutput(
    bytes memory _txData, uint256 _pos, uint256 offset, Output[] memory _outs
  ) internal pure returns (uint256) {
    uint256 value;
    uint16 color;
    address owner;
    bytes32 data;
    assembly {
      offset := add(offset, 32)
      value := mload(add(offset, _txData))
      offset := add(offset, 2)
      color := and(mload(add(offset, _txData)), 0xffff)
      offset := add(offset, 20)
      owner := mload(add(offset, _txData))
      // NST - data
      // (2 ** 15) + (2 ** 14);
      if gt(color, 49152) {
        offset := add(offset, 32)
        data := mload(add(offset, _txData))
      }
    }
    Output memory output = Output(value, color, owner, data);  // solium-disable-line arg-overflow
    _outs[_pos] = output;
    return offset;
  }
  function parseTx(bytes memory _txData) internal pure returns (Tx memory txn) {
    // read type
    TxType txType;
    uint256 a;
    assembly {
      a := mload(add(0x20, _txData))
    }
    a = a >> 248; // get first byte
    if (a == 2) {
      txType = TxType.Deposit;
    } else if (a == 3) {
      txType = TxType.Transfer;
    } else if (a == 13) {
      txType = TxType.SpendCond;
    } else {
      revert("unknown tx type");
    }
    // read ins and outs
    assembly {
        a := mload(add(0x21, _txData))
    }
    a = a >> 252; // get ins-length nibble
    Input[] memory ins = new Input[](a);
    uint256 offset = 2;
    for (uint i = 0; i < ins.length; i++) {
      offset = parseInput(
        i == 0 ? txType: TxType.Transfer, _txData, i, offset, ins // solium-disable-line arg-overflow
      ); 
    }
    assembly {
        a := mload(add(0x21, _txData))
    }
    a = (a >> 248) & 0x0f; // get outs-length nibble
    Output[] memory outs = new Output[](a);
    for (uint256 i = 0; i < outs.length; i++) {
      offset = parseOutput(_txData, i, offset, outs); // solium-disable-line arg-overflow
    }
    txn = Tx(txType, ins, outs);
  }
  function getSigHash(bytes memory _txData) internal pure returns (bytes32 sigHash) {
    uint256 a;
    assembly {
      a := mload(add(0x20, _txData))
    }
    a = a >> 248;
    // if not transfer, sighash is just tx hash
    require(a == 3, "not transfer type");
    // read ins
    assembly {
        a := mload(add(0x21, _txData))
    }
    a = a >> 252; // get ins-length nibble
    bytes memory sigData = new bytes(_txData.length);
    assembly {
      // copy type
      mstore8(add(sigData, 32), byte(0, mload(add(_txData, 32))))
      // copy #inputs / #outputs
      mstore8(add(sigData, 33), byte(1, mload(add(_txData, 32))))
      let offset := 0
      for
        { let i := 0 }
        lt(i, a)
        { i := add(i, 1) }
        {
          mstore(add(sigData, add(34, offset)), mload(add(_txData, add(34, offset))))
          mstore8(add(sigData, add(66, offset)), byte(0, mload(add(_txData, add(66, offset)))))
          offset := add(offset, add(33, 65))
        }
      for
        { let i := add(34, offset) }
        lt(i, add(64, mload(_txData)))
        { i := add(i, 0x20) }
        {
          mstore(add(sigData, i), mload(add(_txData, i)))
        }
    }
    return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", uint2str(_txData.length), sigData));
  }
  // solium-disable-next-line security/no-assign-params
  function getMerkleRoot(
    bytes32 _leaf, uint256 _index, uint256 _offset, bytes32[] memory _proof
  ) internal pure returns (bytes32) {
    bytes32 temp;
    for (uint256 i = _offset; i < _proof.length; i++) {
      temp = _proof[i];
      if (_index % 2 == 0) {
        assembly {
          mstore(0, _leaf)
          mstore(0x20, temp)
          _leaf := keccak256(0, 0x40)
        }
      } else {
        assembly {
          mstore(0, temp)
          mstore(0x20, _leaf)
          _leaf := keccak256(0, 0x40)
        }
      }
      _index = _index / 2;
    }
    return _leaf;
  }
  //validate that transaction is included to the period (merkle proof)
  function validateProof(
    uint256 _cdOffset, bytes32[] memory _proof
  ) internal pure returns (uint64 txPos, bytes32 txHash, bytes memory txData) {
    uint256 offset = uint8(uint256(_proof[1] >> 248));
    uint256 txLength = uint16(uint256(_proof[1] >> 224));
    txData = new bytes(txLength);
    assembly {
      calldatacopy(add(txData, 0x20), add(68, add(offset, _cdOffset)), txLength)
    }
    txHash = keccak256(txData);
    txPos = uint64(uint256(_proof[1] >> 160));
    bytes32 root = getMerkleRoot(
      txHash,
      txPos,
      uint8(uint256(_proof[1] >> 240)),
      _proof
    );
    require(root == _proof[0], "invalid proof");
  }
  function recoverTxSigner(uint256 offset, bytes32[] memory _proof) internal pure returns (address dest) {
    uint16 txLength = uint16(uint256(_proof[1] >> 224));
    bytes memory txData = new bytes(txLength);
    bytes32 r;
    bytes32 s;
    uint8 v;
    assembly {
      calldatacopy(add(txData, 32), add(114, offset), 43)
      r := calldataload(add(157, offset))
      s := calldataload(add(189, offset))
      v := calldataload(add(190, offset))
      calldatacopy(add(txData, 140), add(222, offset), 28) // 32 + 43 + 65
    }
    dest = ecrecover(getSigHash(txData), v, r, s); // solium-disable-line arg-overflow
  }
  // https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol#L886
  // solium-disable-next-line security/no-assign-params
  function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
    if (_i == 0) {
      return "0";
    }
    uint j = _i;
    uint len;
    while (j != 0) {
      len++;
      j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint k = len - 1;
    while (_i != 0) {
      bstr[k--] = byte(uint8(48 + _i % 10));
      _i /= 10;
    }
    return string(bstr);
  }
}


contract ExitHandler is IExitHandler, DepositHandler {

  using PriorityQueue for PriorityQueue.Token;

  event ExitStarted(
    bytes32 indexed txHash,
    uint8 indexed outIndex,
    uint256 indexed color,
    address exitor,
    uint256 amount,
    bytes32 periodRoot
  );

  /**
    - tokenData 1 (optional) NST data
   */
  struct Exit {
    uint256 amount;
    uint16 color;
    address owner;
    bool finalized;
    uint32 priorityTimestamp;
    uint256 stake;
    bytes32 tokenData;
  }

  uint256 public exitDuration;
  uint256 public exitStake;
  uint256 public nftExitCounter;
  uint256 public nstExitCounter;

  /**
   * UTXO 1 Exit mapping
   */
  mapping(bytes32 => Exit) exitMapping;
  mapping(bytes32 => bytes32) exitRoots;

  function exits(bytes32 _utxoId) public view returns (
    uint256 amount,
    uint16 color,
    address owner,
    bool finalized,
    uint32 priorityTimestamp,
    uint256 stake,
    bytes32 tokenData,
    bytes32 periodRoot
  ) {
    Exit memory exit = exitMapping[_utxoId];
    bytes32 periodRoot = exitRoots[_utxoId];
    return (
      exit.amount,
      exit.color,
      exit.owner,
      exit.finalized,
      exit.priorityTimestamp,
      exit.stake,
      exit.tokenData,
      periodRoot
    );
  }

  function initializeWithExit(
    Bridge _bridge,
    uint256 _exitDuration,
    uint256 _exitStake) public initializer {
    initialize(_bridge);
    exitDuration = _exitDuration;
    exitStake = _exitStake;
    emit MinGasPrice(0);
  }

  function setExitStake(uint256 _exitStake) public ifAdmin {
    exitStake = _exitStake;
  }

  function setExitDuration(uint256 _exitDuration) public ifAdmin {
    exitDuration = _exitDuration;
  }

  struct ProofResults {
    bytes32 txHash;
    bytes txData;
    uint64 txPos;
  }

  function startExit(
    bytes32[] memory _youngestInputProof, bytes32[] memory _proof,
    uint8 _outputIndex, uint8 _inputIndex
  ) public payable {
    require(msg.value >= exitStake, "Not enough ether sent to pay for exit stake");
    uint32 timestamp;
    (, timestamp,,) = bridge.periods(_proof[0]);
    require(timestamp > 0, "The referenced period was not submitted to bridge");

    if (_youngestInputProof.length > 0) {
      (, timestamp,,) = bridge.periods(_youngestInputProof[0]);
      require(timestamp > 0, "The referenced period was not submitted to bridge");
    }

    // check exiting tx inclusion in the root chain block
    ProofResults memory pr;
    (pr.txPos, pr.txHash, pr.txData) = TxLib.validateProof(32 * (_youngestInputProof.length + 2) + 64, _proof);

    // parse exiting tx and check if it is exitable
    TxLib.Tx memory exitingTx = TxLib.parseTx(pr.txData);
    TxLib.Output memory out = exitingTx.outs[_outputIndex];

    bytes32 utxoId = bytes32(uint256(_outputIndex) << 120 | uint120(uint256(pr.txHash)));
    uint256 priority;
    if (msg.sender != out.owner) {
      // or caller code hashes to owner
      address a = msg.sender;
      assembly {
        priority := extcodehash(a) // abusing priority for hashBytes here, to save stack
      }
      require(priority != 0, "caller not contract");
      require(bytes20(out.owner) == ripemd160(abi.encode(priority)), "Only UTXO owner or contract can start exit");
      out.owner = msg.sender;
    }
    require(out.value > 0, "UTXO has no value");
    require(exitMapping[utxoId].amount == 0, "The exit for UTXO has already been started");
    require(!exitMapping[utxoId].finalized, "The exit for UTXO has already been finalized");

    if (_youngestInputProof.length > 0) {
      // check youngest input tx inclusion in the root chain block
      bytes32 inputTxHash;
      (pr.txPos, inputTxHash,) = TxLib.validateProof(96, _youngestInputProof);
      require(
        inputTxHash == exitingTx.ins[_inputIndex].outpoint.hash,
        "Input from the proof is not referenced in exiting tx"
      );

      if (isNft(out.color)) {
        priority = (nftExitCounter << 128) | uint128(uint256(utxoId));
        nftExitCounter++;
      } else if (isNST(out.color)) {
        priority = (nstExitCounter << 128) | uint128(uint256(utxoId));
        nstExitCounter++;
      } else {
        priority = getERC20ExitPriority(timestamp, utxoId, pr.txPos);
      }
    } else {
      require(exitingTx.txType == TxLib.TxType.Deposit, "Expected deposit tx");
      if (isNft(out.color)) {
        priority = (nftExitCounter << 128) | uint128(uint256(utxoId));
        nftExitCounter++;
      } else if (isNST(out.color)) {
        priority = (nstExitCounter << 128) | uint128(uint256(utxoId));
        nstExitCounter++;
      } else {
        priority = getERC20ExitPriority(timestamp, utxoId, pr.txPos);
      }
    }

    tokens[out.color].insert(priority);

    exitMapping[utxoId] = Exit({
      owner: out.owner,
      color: out.color,
      amount: out.value,
      finalized: false,
      stake: exitStake,
      priorityTimestamp: timestamp,
      tokenData: out.stateRoot
    });
    exitRoots[utxoId] = _proof[0];

    emit ExitStarted(
      pr.txHash,
      _outputIndex,
      out.color,
      out.owner,
      out.value,
      _proof[0]
    );
  }

  function startDepositExit(uint256 _depositId) public payable {
    require(msg.value >= exitStake, "Not enough ether sent to pay for exit stake");
    // check that deposit exits
    Deposit memory deposit = deposits[uint32(_depositId)];
    require(deposit.owner == msg.sender, "Only deposit owner can start exit");
    require(deposit.amount > 0, "deposit has no value");
    require(exitMapping[bytes32(_depositId)].amount == 0, "The exit of deposit has already been started");
    require(!exitMapping[bytes32(_depositId)].finalized, "The exit for deposit has already been finalized");

    uint256 priority;
    if (isNft(deposit.color)) {
      priority = (nftExitCounter << 128) | uint128(_depositId);
      nftExitCounter++;
    } else if (isNST(deposit.color)) {
      priority = (nstExitCounter << 128) | uint128(_depositId);
      nstExitCounter++;
    } else {
      priority = getERC20ExitPriority(uint32(deposit.time), bytes32(_depositId), 0);
    }

    tokens[deposit.color].insert(priority);

    exitMapping[bytes32(_depositId)] = Exit({
      owner: deposit.owner,
      color: deposit.color,
      amount: deposit.amount,
      finalized: false,
      stake: exitStake,
      priorityTimestamp: uint32(now),
      tokenData: "0x"
    });

    // no need to emit ExitStartedV2
    // no need to update emit data root for NSTs, as it only got deposit now.
    emit ExitStarted(
      bytes32(_depositId),
      0,
      deposit.color,
      deposit.owner,
      deposit.amount,
      0
    );
  }

  // @dev Finalizes exit for the chosen color with the highest priority
  function finalizeExits(uint16 _color) public {
    bytes32 utxoId;
    uint256 exitableAt;
    Exit memory currentExit;

    (utxoId, exitableAt) = getNextExit(_color);

    require(tokens[_color].currentSize > 0, "Queue empty for color.");

    for (uint i = 0; i < 20; i++) {
      // if queue is empty or top exit cannot be exited yet, stop
      if (exitableAt > block.timestamp) {
        return;
      }

      currentExit = exitMapping[utxoId];

      // exits of deleted periods are not payed out but simply deleted
      if (exitRoots[utxoId] > 0) {
        uint32 timestamp;
        (, timestamp,,) = bridge.periods(exitRoots[utxoId]);
        if (timestamp == 0) {
          // stake goes to governance contract
          address(uint160(bridge.admin())).send(currentExit.stake);
          tokens[currentExit.color].delMin();
          exitMapping[utxoId].finalized = true;
          return;
        }
      }

      if (currentExit.owner != address(0) || currentExit.amount != 0) { // exit was not removed
        // Note: for NFTs, the amount is actually the NFT id (both uint256)
        if (isNft(currentExit.color)) {
          tokens[currentExit.color].addr.transferFrom(address(this), currentExit.owner, currentExit.amount);
        } else if (isNST(currentExit.color)) {
          bytes32 tokenData = currentExit.tokenData;
          address tokenAddr = address(tokens[currentExit.color].addr);

          bool success;
          (success, ) = tokenAddr.call(abi.encodeWithSignature("writeData(uint256,bytes32)", currentExit.amount, tokenData));
          // if set data did not work, we assume the token hasn't been minted yet
          if (!success) {
            tokenAddr.call(
              abi.encodeWithSignature(
                "breed(uint256,address,bytes32)",
                currentExit.amount, currentExit.owner, tokenData
              )
            );
          } else {
            // only if we were able to setData we try to transfer
            tokens[currentExit.color].addr.transferFrom(address(this), currentExit.owner, currentExit.amount);
          }
        } else {
          // why so complicated? why not transfer()?
          tokens[currentExit.color].addr.approve(address(this), currentExit.amount);
          tokens[currentExit.color].addr.transferFrom(address(this), currentExit.owner, currentExit.amount);
        }
        // Pay exit stake
        address(uint160(currentExit.owner)).send(currentExit.stake);
      }

      tokens[currentExit.color].delMin();
      exitMapping[utxoId].finalized = true;

      if (tokens[currentExit.color].currentSize > 0) {
        (utxoId, exitableAt) = getNextExit(_color);
      } else {
        return;
      }
    }
  }

  // @dev For backwards compatibility reasons...
  function finalizeTopExit(uint16 _color) public {
    finalizeExits(_color);
  }

  function challengeExit(
    bytes32[] memory _proof,
    bytes32[] memory _prevProof,
    uint8 _outputIndex,
    uint8 _inputIndex,
    address challenger
  ) public {
    require(msg.sender == challenger, "Wrong challenger");
    uint32 timestamp;
    if (_prevProof.length > 0) {
      // check period for _prevProof
      (, timestamp,,) = bridge.periods(_prevProof[0]);
      require(timestamp > 0, "The referenced period was not submitted to bridge");
    }
    // validate exiting tx
    uint256 offset = 32 * (_proof.length + 2);
    bytes32 txHash1;
    bytes memory txData;
    (, txHash1, txData) = TxLib.validateProof(offset + 96, _prevProof);
    bytes32 utxoId = bytes32(uint256(_outputIndex) << 120 | uint120(uint256(txHash1)));

    TxLib.Tx memory txn;
    if (_proof.length > 0) {
      // check period for _proof
      (, timestamp,,) = bridge.periods(_proof[0]);
      require(timestamp > 0, "The referenced period was not submitted to bridge");
      // validate spending tx
      bytes32 txHash;
      (, txHash, txData) = TxLib.validateProof(128, _proof);
      txn = TxLib.parseTx(txData);

      // make sure one is spending the other one
      require(txHash1 == txn.ins[_inputIndex].outpoint.hash, "prevout check failed on hash");
      require(_outputIndex == txn.ins[_inputIndex].outpoint.pos, "prevout check failed on pos");

      // if transfer, make sure signature correct
      if (txn.txType == TxLib.TxType.Transfer) {
        bytes32 sigHash = TxLib.getSigHash(txData);
        address signer = ecrecover(
          sigHash,
          txn.ins[_inputIndex].v,
          txn.ins[_inputIndex].r,
          txn.ins[_inputIndex].s
        );
        require(exitMapping[utxoId].owner == signer, "signer does not match");
      } else if (txn.txType == TxLib.TxType.SpendCond) { // solium-disable-line whitespace
        // check that hash of contract matches output address
        // just have the pass through
        // later we will check solEVM Enforcer here.
      } else {
        revert("unknown tx type");
      }
    } else {
      // challenging deposit exit
      txn = TxLib.parseTx(txData);
      utxoId = txn.ins[_inputIndex].outpoint.hash;
      if (txn.txType == TxLib.TxType.Deposit) {
        // check that deposit was included correctly
        // only then it should be usable for challenge
        Deposit memory deposit = deposits[uint32(uint256(utxoId))];
        require(deposit.amount == txn.outs[0].value, "value mismatch");
        require(deposit.owner == txn.outs[0].owner, "owner mismatch");
        require(deposit.color == txn.outs[0].color, "color mismatch");
        if (isNST(deposit.color)) {
          require(tokenData[uint32(uint256(utxoId))] == txn.outs[0].stateRoot, "data mismatch");
        }
        // todo: check timely inclusion of deposit tx
        // this will prevent grieving attacks by the operator
      } else {
        revert("unexpected tx type");
      }
    }

    require(exitMapping[utxoId].amount > 0, "exit not found");
    require(!exitMapping[utxoId].finalized, "The exit has already been finalized");

    // award stake to challanger
    msg.sender.transfer(exitMapping[utxoId].stake);
    // delete invalid exit
    delete exitMapping[utxoId];
  }

  function challengeYoungestInput(
    bytes32[] memory _youngerInputProof,
    bytes32[] memory _exitingTxProof,
    uint8 _outputIndex,
    uint8 _inputIndex,
    address challenger
  ) public {
    require(msg.sender == challenger, "Wrong challenger");
    // validate exiting input tx
    bytes32 txHash;
    bytes memory txData;
    (, txHash, txData) = TxLib.validateProof(32 * (_youngerInputProof.length + 2) + 96, _exitingTxProof);
    bytes32 utxoId = bytes32(uint256(_outputIndex) << 120 | uint120(uint256(txHash)));

    // check the exit exists
    require(exitMapping[utxoId].amount > 0, "There is no exit for this UTXO");

    TxLib.Tx memory exitingTx = TxLib.parseTx(txData);

    // validate younger input tx
    (,txHash,) = TxLib.validateProof(128, _youngerInputProof);

    // check younger input is actually an input of exiting tx
    require(txHash == exitingTx.ins[_inputIndex].outpoint.hash, "Given output is not referenced in exiting tx");

    uint32 youngerInputTimestamp;
    (,youngerInputTimestamp,,) = bridge.periods(_youngerInputProof[0]);
    require(youngerInputTimestamp > 0, "The referenced period was not submitted to bridge");

    require(exitMapping[utxoId].priorityTimestamp < youngerInputTimestamp, "Challenged input should be older");

    // award stake to challanger
    msg.sender.transfer(exitMapping[utxoId].stake);
    // delete invalid exit
    delete exitMapping[utxoId];
  }

  function getNextExit(uint16 _color) internal view returns (bytes32 utxoId, uint256 exitableAt) {
    uint256 priority = tokens[_color].getMin();
    utxoId = bytes32(uint256(uint128(priority)));
    exitableAt = priority >> 192;
  }

  function isNft(uint16 _color) internal pure returns (bool) {
    return (_color >= NFT_FIRST_COLOR) && (_color < NST_FIRST_COLOR);
  }

  function isNST(uint16 _color) internal pure returns (bool) {
    return _color >= NST_FIRST_COLOR;
  }

  function getERC20ExitPriority(
    uint32 timestamp, bytes32 utxoId, uint64 txPos
  ) internal view returns (uint256 priority) {
    uint256 exitableAt = Math.max(timestamp + (2 * exitDuration), block.timestamp + exitDuration);
    return (exitableAt << 192) | uint256(txPos) << 128 | uint128(uint256(utxoId));
  }

  // solium-disable-next-line mixedcase
  uint256[48] private ______gap;
}



contract FastExitHandler is ExitHandler {

  struct Data {
    uint32 timestamp;
    bytes32 txHash;
    uint64 txPos;
    bytes32 utxoId;
  }

  function deposit(address, uint256, uint16) public {
    revert("not implemented");
  }

  function startExit(bytes32[] memory, bytes32[] memory, uint8, uint8) public payable {
    revert("not implemented");
  }

  function startDepositExit(uint256) public payable {
    revert("not implemented");
  }

  function startBoughtExit(bytes32[] memory, bytes32[] memory, uint8, uint8, bytes32[] memory) public payable {
    revert("not implemented");
  }

  modifier onlyMultisig() {
    require(msg.sender == 0xC5cDcD5470AEf35fC33BDDff3f8eCeC027F95B1d, "msg.sender not multisig");
    _;
  }

  function withdrawSupply(address _token) public onlyMultisig {
    require(_token != address(0), "not real address");
    IERC20 token = IERC20(_token);
    token.transfer(msg.sender, token.balanceOf(address(this)));
  }

}