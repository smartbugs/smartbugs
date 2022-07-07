pragma solidity 0.5.7;

contract ERC223ReceivingContract { 
    function tokenFallback(address _from, uint _value) public;
}

contract IRC223 {
  uint public totalSupply;
  function balanceOf(address who) public view returns (uint);
  
  function name() public view returns (string memory _name);
  function symbol() public view returns (string memory _symbol);
  function decimals() public view returns (uint8 _decimals);

  function transfer(address to, uint value) public;
  
  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

contract PIBC is IRC223 {
    using SafeMath for uint;
    
    mapping(address => uint) public balances;
    mapping(address => mapping (address => uint)) public approved;
    mapping(address => mapping (address => uint)) public ttl;
    string private _name;
    string private _symbol;
    uint8 _decimals;
    uint public commisionRate;
    address private _owner;
    address private _commisioner; //0x4E911d2D6B83e4746055ccb167596bF9f2e680d2
    event Commision(uint256 commision);
    uint private _ttlLimit;
    
    constructor(address commisioner, address owner) public{
        _name = "Pi token";
        _symbol = "PIT";
        _decimals = 5;
        totalSupply = 10000000000000000000;
        balances[owner] = totalSupply;
        _owner = owner;
        _commisioner = commisioner;
        commisionRate = 10000;
        _ttlLimit = 360;
    }
    
    
    function name() public view returns (string memory){
        return _name;
    }
    function symbol() public view returns (string memory){
        return _symbol;
    }
    function decimals() public view returns (uint8){
        return _decimals;
    }
    
    function _transfer(address _to, address _from, uint _value) internal{
           require(balances[_from] >= _value);
        uint codeLength;
        uint256 commision;
        bytes memory empty;

        assembly {
            // Retrieve the size of the code on target address, this needs assembly .
            codeLength := extcodesize(_to)
        }
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        commision = _value.div(commisionRate);
        balances[_from] = balances[_from].sub(commision);
        balances[_commisioner] = balances[_commisioner].add(commision);
        if(codeLength>0) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(_from, _value);
        }
        emit Transfer(_from, _to, _value, empty);
        emit Commision(commision);
    }
    
    function transfer(address _to, uint _value) public {
        _transfer(_to, msg.sender,_value);
    }
    
    function transferFrom (address _to, address _from) public {
        require(approved[_from][_to] > 0);
        require(ttl[msg.sender][_to] > block.number);
        uint _value = approved[_from][_to];
        ttl[msg.sender][_to] = 0;
        approved[_from][_to] = 0;
        _transfer(_to, _from, _value);
        
    }
    
    function approve (address _to, uint _value) public{
        require(_value <= balances[msg.sender]);
        approved[msg.sender][_to] = approved[msg.sender][_to].add(_value);
        ttl[msg.sender][_to] = block.number.add(_ttlLimit);

    }

    function balanceOf(address _user) public view returns (uint balance) {
        return balances[_user];
    }
    
    function setTtl(uint ttlLimit) public {
        require(tx.origin == _owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _ttlLimit = ttlLimit;
    }
    
    function setCommisionRate (uint _commisionRate) public {
        require(tx.origin == _owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        commisionRate = _commisionRate;
    }
    
    function setCommisioner (address commisioner) public {
        require(tx.origin == _owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _commisioner = commisioner;
    }
}