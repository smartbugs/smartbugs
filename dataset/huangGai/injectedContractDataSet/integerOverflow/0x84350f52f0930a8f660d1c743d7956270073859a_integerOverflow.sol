/**
 *Submitted for verification at Etherscan.io on 2020-05-29
*/

pragma solidity 0.5.0;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        //require(c >= a);
    }

    function sub(uint a, uint b) internal pure returns (uint c) {
        //require(b <= a);
        c = a - b;
    }

    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}//____________________________________________________________________________________________
//_____________________________________________________________________________________________

contract Owned {
    address public owner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, 'only owner can make this call');
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        owner = _newOwner;
        emit OwnershipTransferred(owner, _newOwner);
    }
}//____________________________________________________________________________________________
//_____________________________________________________________________________________________

contract EquableToken is Owned {
    
    using SafeMath for uint256;
    
    string public name = "EquableToken";
    string public symbol = "EQB";
    uint8 public decimals = 8;
    uint public _totalSupply;
    
    /**
     * Constrctor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    constructor(uint _initialSupply) public {
        _totalSupply = _initialSupply * 10 ** uint(decimals);
        balances[0xe921c6a0Ee46685F8D7FC47272ACc4a39Cadee8f] = _totalSupply;
        emit Transfer(address(0x0), 0xe921c6a0Ee46685F8D7FC47272ACc4a39Cadee8f, _totalSupply);
    }
    
    // Generates a public event on the blockchain that will notify clients
    event Transfer(address indexed _from, address indexed _to, uint _value);
    
    // This notifies clients about the amount burnt
    event Burn(address indexed from, uint value);                                                                                          
    
    // Generates a public event on the blockchain that will notify clients
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    
    // This creates an array with all balances
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
  
    function totalSupply() external view returns (uint) {
        return _totalSupply;
    }
    
    /**
     * Internal transfer, can only be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != address(0x0));
        require(balances[_from] >= _value);
        require(balances[_to].add(_value) >= balances[_to]);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(_from, _to, _value);
    }
    
    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint _value) public returns(bool success){
        _transfer(msg.sender, _to, _value);
        return true;
    }
    
    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` in behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        require(_value <= allowed[_from][msg.sender]);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        _transfer(_from, _to, _value);
        return true;
    }
    
    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens in your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    /**
     * Returns the amount of tokens approved by the owner that can be transferred to the spender's account
     */
    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return allowed[_owner][_spender];
    }
    
    /**
     * Get the token balance for account `tokenOwner`
     */
    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }
    
    /** 
     * @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function mint(address _account, uint _amount) public onlyOwner {
        require(_account != address(0x0), "ERC20: mint to the zero address");
        _totalSupply = _totalSupply.add(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        balances[_account] = balances[_account].add(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Transfer(address(0), _account, _amount);
    }
    
    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value is the amount of token to burn
     */
    function burn(uint _value) public onlyOwner returns (bool success) {
        require(balances[msg.sender] >= _value);   
        balances[msg.sender] = balances[msg.sender].sub(_value);
        _totalSupply = _totalSupply.sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW
                      
        emit Burn(msg.sender, _value);
        return true;
    }
}