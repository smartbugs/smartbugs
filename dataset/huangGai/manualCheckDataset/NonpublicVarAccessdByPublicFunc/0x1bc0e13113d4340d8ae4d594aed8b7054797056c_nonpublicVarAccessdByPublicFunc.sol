/**
 *Submitted for verification at Etherscan.io on 2020-07-23
*/

pragma solidity ^0.5.1;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		if (a == 0) {
			return 0;
		}
		uint256 c = a * b;
		assert(c / a == b);
		return c;
	}

	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		assert(b > 0);
		uint256 c = a / b;
		return c;
	}

	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		assert(b <= a);
		return a - b;
	}

	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		assert(c >= a);
		return c;
	}
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
	uint256 public totalSupply;
	function balanceOf(address who) public view returns (uint256);
	function transfer(address to, uint256 value) public returns (bool);
	function allowance(address owner, address spender) public view returns (uint256);
	function transferFrom(address from, address to, uint256 value) public returns (bool);
	function approve(address spender, uint256 value) public returns (bool);

	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Owned {
	address internal owner;

	event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor(address _owner) public {
        owner = _owner;
    }


	modifier onlyOwner {
		require(msg.sender == owner);
		_;
	}

	function transferOwnership(address _owner) onlyOwner public {
		require(_owner != address(0));
		owner = _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

		emit OwnershipTransferred(owner, _owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
}

contract ERC20Token is ERC20, Owned {
	using SafeMath for uint256;

	mapping(address => uint256) balances;
	mapping(address => mapping (address => uint256)) allowed;


	// True if transfers are allowed
	bool internal transferable = true;

	modifier canTransfer() {
		require(transferable == true);
		_;
	}

	function setTransferable(bool _transferable) onlyOwner public {
		transferable = _transferable;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}

	/**
	 * @dev transfer token for a specified address
	 * @param _to The address to transfer to.
	 * @param _value The amount to be transferred.
	 */
	function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
		require(_to != address(0));
		require(_value <= balances[msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

		balances[msg.sender] = balances[msg.sender].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		balances[_to] = balances[_to].add(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		emit Transfer(msg.sender, _to, _value);
		return true;
	}

	/**
	* @dev Gets the balance of the specified address.
	* @param _owner The address to query the the balance of.
		* @return An uint256 representing the amount owned by the passed address.
		*/
	function balanceOf(address _owner) public view returns (uint256 balance) {
		return balances[_owner];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}

	/**
	* @dev Transfer tokens from one address to another
	* @param _from address The address which you want to send tokens from
	* @param _to address The address which you want to transfer to
	* @param _value uint256 the amount of tokens to be transferred
	*/
	function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
		require(_to != address(0));
		require(_value <= balances[_from]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		require(_value <= allowed[_from][msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

		balances[_from] = balances[_from].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		balances[_to] = balances[_to].add(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		emit Transfer(_from, _to, _value);
		return true;
	}

	// Allow `_spender` to withdraw from your account, multiple times.
	function approve(address _spender, uint _value) public returns (bool success) {
		// To change the approve amount you first have to reduce the addresses`
		//  allowance to zero by calling `approve(_spender, 0)` if it is not
		//  already 0 to mitigate the race condition described here:
		//  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
		if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
			revert();
		}
		allowed[msg.sender][_spender] = _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	/**
	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
	 * @param _owner address The address which owns the funds.
	 * @param _spender address The address which will spend the funds.
	 * @return A uint256 specifying the amount of tokens still available for the spender.
	 */
	function allowance(address _owner, address _spender) public view returns (uint256) {
		return allowed[_owner][_spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}

	function () external payable {
		revert();
	}
}

contract SealToken is ERC20Token{
	string public name = "SealSC";
	string public symbol = "SEAL";
	uint8 public decimals = 18;

	uint256 public totalSupplyCap = 10 * 10**8 * 10**uint256(decimals);

	constructor(address _issuer) public Owned(_issuer) {
		totalSupply = totalSupplyCap;
		balances[msg.sender] = totalSupplyCap;
		emit Transfer(address(0), msg.sender, totalSupplyCap);
	}
}