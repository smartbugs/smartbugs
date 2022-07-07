/**
 *Submitted for verification at Etherscan.io on 2020-08-18
*/

pragma solidity 0.5.17;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        //require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract ERC20Interface {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _who) external view returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
}

/**
 * @title HBC token
 */

contract HBC is ERC20Interface {

    using SafeMath for uint256;
   
    uint256 constant public TOKEN_DECIMALS = 10 ** 18;
    string public constant name            = "Hybrid Bank Cash";
    string public constant symbol          = "HBC";
    uint256 public totalTokenSupply        = 10000000000 * TOKEN_DECIMALS;
    uint8 public constant decimals         = 18;
    bool public stopped                    = false;
    address public owner;
    uint256 public totalBurned;

    event Burn(address indexed _burner, uint256 _value);
    event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
    event OwnershipRenounced(address indexed _previousOwner);

    /** mappings **/ 
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) internal allowed;
    mapping(address => address) private forbiddenAddresses;
 
    /**
     * @dev Throws if called by any account other than the owner.
     */

    modifier onlyOwner() {
       require(msg.sender == owner, "Caller is not owner");
       _;
    }
    
    /** constructor **/

    constructor() public {
       owner = msg.sender;
       balances[owner] = totalTokenSupply;

       emit Transfer(address(0x0), owner, balances[owner]);
    }

    /**
     * @dev To pause token transfer. In general pauseTransfer can be triggered
     *      only on some specific error conditions 
     */

    function pauseTransfer() external onlyOwner {
        stopped = true;
    }

    /**
     * @dev To resume token transfer
     */

    function resumeTransfer() external onlyOwner {
        stopped = false;
    }

    /**
     * @dev To add address into forbiddenAddresses
     */

    function addToForbiddenAddresses(address _newAddr) external onlyOwner {
       forbiddenAddresses[_newAddr] = _newAddr;
    }

    /**
     * @dev To remove address from forbiddenAddresses
     */

    function removeFromForbiddenAddresses(address _newAddr) external onlyOwner {
       delete forbiddenAddresses[_newAddr];
    }

    /**
     * @dev Burn specified number of HBC tokens from token owner wallet
     */

    function burn(uint256 _value) onlyOwner external returns (bool) {
       require(!stopped, "Paused");

       address burner = msg.sender;

       balances[burner] = balances[burner].sub(_value, "burn amount exceeds balance");	//injected INTEGER OVERFLOW OR UNDERFLOW

       totalTokenSupply = totalTokenSupply.sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

       totalBurned      = totalBurned.add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW


       emit Burn(burner, _value);
       emit Transfer(burner, address(0x0), _value);

       return true;
    }     

    /**
     * @dev total number of tokens in existence
     * @return An uint256 representing the total number of tokens in existence
     */

    function totalSupply() external view returns (uint256) { 
       return totalTokenSupply; 
    }

    /**
     * @dev Gets the balance of the specified address
     * @param _owner The address to query the the balance of 
     * @return An uint256 representing the amount owned by the passed address
     */

    function balanceOf(address _owner) external view returns (uint256) {
       return balances[_owner];
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amout of tokens to be transfered
     */

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {    

       require(!stopped, "Paused");
 
       require(_to != address(0x0), "ERC20: transferring to zero address");

       require(_from != address(0x0), "ERC20: transferring from zero address");

       require(forbiddenAddresses[_from] != _from, "ERC20: transfer from forbidden address");

       require(forbiddenAddresses[_to] != _to, "ERC20: transfer to forbidden address");


       if (_value == 0) 
       {
           emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0
           return true;
       }


       require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);

       balances[_from] = balances[_from].sub(_value, "transfer amount exceeds balance");	//injected INTEGER OVERFLOW OR UNDERFLOW

       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
       balances[_to] = balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW


       emit Transfer(_from, _to, _value);

       return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
     *
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds
     * @param _tokens The amount of tokens to be spent
     */

    function approve(address _spender, uint256 _tokens) external returns(bool) {

       require(!stopped, "Paused");

       require(_spender != address(0x0));

       allowed[msg.sender][_spender] = _tokens;

       emit Approval(msg.sender, _spender, _tokens);

       return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender
     * @param _owner address The address which owns the funds
     * @param _spender address The address which will spend the funds
     * @return A uint256 specifing the amount of tokens still avaible for the spender
     */

    function allowance(address _owner, address _spender) external view returns(uint256) {

       require(!stopped, "Paused");

       require(_owner != address(0x0) && _spender != address(0x0));

       return allowed[_owner][_spender];
    }

    /**
     * @dev transfer token for a specified address
     * @param _address The address to transfer to
     * @param _tokens The amount to be transferred
     */

    function transfer(address _address, uint256 _tokens) external returns(bool) {

       require(!stopped, "Paused");

       require(_address != address(0x0), "ERC20: transferring to zero address");

       require(forbiddenAddresses[msg.sender] != msg.sender, "ERC20: transfer from forbidden address");

       require(forbiddenAddresses[_address] != _address, "ERC20: transfer to forbidden address");

       if (_tokens == 0) 
       {
           emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0
           return true;
       }


       require(balances[msg.sender] >= _tokens);

       balances[msg.sender] = (balances[msg.sender]).sub(_tokens, "transfer amount exceeds balance");	//injected INTEGER OVERFLOW OR UNDERFLOW

       balances[_address] = (balances[_address]).add(_tokens);	//injected INTEGER OVERFLOW OR UNDERFLOW


       emit Transfer(msg.sender, _address, _tokens);

       return true;
    }

    /**
     * @dev transfer ownership of this contract, only by owner
     * @param _newOwner The address of the new owner to transfer ownership
     */

    function transferOwnership(address _newOwner) external onlyOwner {

       uint256 ownerBalances;

       require(!stopped, "Paused");

       require( _newOwner != address(0x0), "ERC20: transferOwnership address is zero address");

       ownerBalances = balances[owner];

       balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);
       balances[owner] = 0;
       owner = _newOwner;

       emit Transfer(msg.sender, _newOwner, ownerBalances);
   }

   /**
    * @dev Allows the current owner to relinquish control of the contract
    * @notice Renouncing to ownership will leave the contract without an owner
    * It will not be possible to call the functions with the `onlyOwner`
    * modifier anymore
    */

   function renounceOwnership() external onlyOwner {

      require(!stopped, "Paused");

      owner = address(0x0);
      emit OwnershipRenounced(owner);
   }

   /**
    * @dev Increase the amount of tokens that an owner allowed to a spender
    */

   function increaseApproval(address _spender, uint256 _addedValue) external returns (bool success) {

      require(!stopped, "Paused");

      allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

      return true;
   }

   /**
    * @dev Decrease the amount of tokens that an owner allowed to a spender
    */

   function decreaseApproval(address _spender, uint256 _subtractedValue) external returns (bool success) {

      uint256 oldValue = allowed[msg.sender][_spender];

      require(!stopped, "Paused");

      if (_subtractedValue > oldValue) 
      {
         allowed[msg.sender][_spender] = 0;
      }
      else 
      {
         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

      }

      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

      return true;
   }

}