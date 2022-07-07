pragma solidity ^0.5.6;

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply = 2e28;
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract TOPToken is ERC20Basic {
  bytes32 public name = "TOP Network";
  bytes32 public symbol = "TOP";
  uint256 public decimals = 18;
  address private owner = address(0);
  bool private active = false;

  mapping(address => uint256) private balances;

  event OwnershipTransferred(address indexed orgOwner, address indexed newOwner);

  constructor() public {
    owner = msg.sender;
    balances[owner] = totalSupply;
    active = true;
  }

  modifier onlyOwner() {
    require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

    _;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(active);
    require(_to != address(0));
    require(_to != msg.sender);
    require(_value <= balances[msg.sender]);

    uint256 bal = balances[_to] + _value;
    require(bal >= balances[_to]);

    balances[msg.sender] = balances[msg.sender] - _value;
    balances[_to] = bal;

    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 bal) {
    require(active);
    return balances[_owner];
  }

  // Only owner can deactivate
  function deactivate() public onlyOwner {
    active = false;
  }

  // Only owner can activate
  function activate() public onlyOwner {
    active = true;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  // Only owner can kill
  function kill() public onlyOwner {
    require(!active);
    selfdestruct(msg.sender);
  }
}