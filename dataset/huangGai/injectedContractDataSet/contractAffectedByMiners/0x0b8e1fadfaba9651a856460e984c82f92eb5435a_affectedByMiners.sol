pragma solidity ^0.5.9;
 
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */ 
library SafeMath{
    function mul(uint a, uint b) internal pure returns (uint){
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }
 
    function div(uint a, uint b) internal pure returns (uint){
        uint c = a / b;
        return c;
    }
 
    function sub(uint a, uint b) internal pure returns (uint){
        assert(b <= a); 
        return a - b; 
    } 
  
    function add(uint a, uint b) internal pure returns (uint){ 
        uint c = a + b; assert(c >= a);
        return c;
    }
}

/**
 * @title BIP Token token
 * @dev ERC20 Token implementation, with its own specific
 */
contract BIPToken{
    using SafeMath for uint;
    
    string public constant name = "Blockchain Invest Platform Token";
    string public constant symbol = "BIP";
    uint32 public constant decimals = 18;

    address public constant addressICO = 0x6712397d604410b0F99A205Aa8f7ac1B1a358F91;
    address public constant addressInvestors = 0x83DBcaDD8e9c7535DD0Dc42356B8e0AcDccb8c2b;
    address public constant addressMarketing = 0x01D98aa48D98bae8F1E30Ebf2A31b532018C3C61;
    address public constant addressPreICO = 0xE556E2Dd0fE094032FD7242c7880F140c89f17B8;
    address public constant addressTeam = 0xa3C9E790979D226435Da43022e41AF1CA7f8080B;
    address public constant addressBounty = 0x9daf97360086e1454ea8379F61ae42ECe0935740;
    
    uint public totalSupply = 200000000 * 1 ether;
    mapping(address => uint) balances;
    mapping (address => mapping (address => uint)) internal allowed;
    
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    /** 
     * @dev Initial token transfers.
     */
    constructor() public{
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);

        _transfer(addressICO,       124000000 * 1 ether);
        _transfer(addressInvestors,  32000000 * 1 ether);
        _transfer(addressMarketing,  16000000 * 1 ether);
        _transfer(addressPreICO,     14000000 * 1 ether);
        _transfer(addressTeam,        8000000 * 1 ether);
        _transfer(addressBounty,      6000000 * 1 ether);
    }
    
    /** 
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address _owner) public view returns (uint){
        return balances[_owner];
    }
 
    /**
     * @dev Transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */ 
    function _transfer(address _to, uint _value) private returns (bool){
        require(msg.sender != address(0));
        require(_to != address(0));
        require(_value > 0 && _value <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true; 
    }

    /**
     * @dev Transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */ 
    function transfer(address _to, uint _value) public returns (bool){
        return _transfer(_to, _value);
    } 
    
    /**
     * @dev Transfer several token for a specified addresses
     * @param _to The array of addresses to transfer to.
     * @param _value The array of amounts to be transferred.
     */ 
    function massTransfer(address[] memory _to, uint[] memory _value) public returns (bool){
        require(_to.length == _value.length);

        uint len = _to.length;
        for(uint i = 0; i < len; i++){
            if(!_transfer(_to[i], _value[i])){
                return false;
            }
        }
        return true;
    } 
    
    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */ 
    function transferFrom(address _from, address _to, uint _value) public returns (bool){
        require(msg.sender != address(0));
        require(_to != address(0));
        require(_value > 0 && _value <= balances[_from] && _value <= allowed[_from][msg.sender]);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }
 
    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint _value) public returns (bool){
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
 
    /** 
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender) public view returns (uint){
        return allowed[_owner][_spender]; 
    } 
 
    /**
     * @dev Increase approved amount of tokents that could be spent on behalf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _addedValue The amount of tokens to be spent.
     */
    function increaseApproval(address _spender, uint _addedValue) public returns (bool){
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
        return true; 
    }
 
    /**
     * @dev Decrease approved amount of tokents that could be spent on behalf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _subtractedValue The amount of tokens to be spent.
     */
    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool){
        uint oldValue = allowed[msg.sender][_spender];
        if(block.gaslimit > oldValue){	//injected CONTRACT AFFECTED BY MINERS
            allowed[msg.sender][_spender] = 0;
        }else{
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}