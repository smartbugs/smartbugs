pragma solidity >= 0.5.4 ;

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


interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }


contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    
    function owner() public view returns (address) {
        return _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

   
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _owner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

   
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

   
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}



contract Pausable is Ownable{
    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;

    constructor () internal {
        _paused = false;
    }

    
    function paused() public view returns (bool) {
        return _paused;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    
    modifier whenNotPaused() {
        require(!_paused);
        _;
    }

   
    modifier whenPaused() {
        require(_paused);
        _;
    }

    
    function pause() public onlyOwner whenNotPaused {
        _paused = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Paused(msg.sender);
    }

    
    function unpause() public onlyOwner whenPaused {
        _paused = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Unpaused(msg.sender);
    }
}


contract TokenERC20{
    using SafeMath for uint256;

    string internal name;
    string internal symbol;
    uint8 public decimals = 18;
    uint256 internal totalSupply;

    mapping (address => uint256) internal balanceOf;
    mapping (address => mapping (address => uint256)) internal allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event Burn(address indexed from, uint256 value);

    
    constructor(uint256 initialSupply,string memory tokenName,string memory tokenSymbol) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  
        balanceOf[msg.sender] = totalSupply;                
        name = tokenName;                                  
        symbol = tokenSymbol;                              
    }

    
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != address(0x0));

        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);

        emit Transfer(_from, _to, _value);
    }

    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

   
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _transfer(_from, _to, _value);
        return true;
    }

   
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

   
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
        public
        returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, address(this), _extraData);
            return true;
        }
    }

   
    function burn(uint256 _value) public returns (bool success) {
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);             	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalSupply = totalSupply.sub(_value);                                 	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Burn(msg.sender, _value);
        return true;
    }

    
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        balanceOf[_from] = balanceOf[_from].sub(_value);                                        	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);                	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalSupply = totalSupply.sub(_value);                                                  	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Burn(_from, _value);
        return true;
    }

}


contract VotaToken is TokenERC20, Ownable,Pausable{

    mapping (address => bool) internal frozenAccount;

    event FrozenFunds(address target, bool frozen);

    constructor() TokenERC20(900000000,"Votarist Token","VOTA") public {
    }

    function freezeAccount(address account, bool freeze) onlyOwner public {
        frozenAccount[account] = freeze;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit FrozenFunds(account, freeze);
    }

    function changeName(string memory newName) public onlyOwner {
        name = newName;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function changeSymbol(string memory newSymbol) public onlyOwner{
        symbol = newSymbol;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    
    function _transfer(address _from, address _to, uint _value) internal whenNotPaused {
        require(_to != address(0x0));

        require(!frozenAccount[_from]);
        require(!frozenAccount[_to]);

        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);

        emit Transfer(_from, _to, _value);
    }
}