pragma solidity ^0.5.0;

contract ZTY {

    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowed;
    uint256 internal sellPrice;
    uint256 internal buyPrice;
    uint256 internal numDecimalsBuyPrice;
    uint256 internal numDecimalsSellPrice;
    string public name;                   
    uint8 public decimals;                
    string public symbol;                 
    address payable internal  owner;
    uint256 internal totalSupply;

    constructor () public {
        balances[msg.sender] = 4485600000000000000000000000;
        totalSupply = 4485600000000000000000000000;
        name = "Zity";
        decimals = 18;
        symbol = "ZTY";
        owner = msg.sender;
        sellPrice = 8;
        numDecimalsSellPrice = 10000;
        buyPrice = 8;
        numDecimalsBuyPrice = 10000;
    }

    function recieveFunds() external payable {
        emit ReciveFunds(msg.sender,msg.value);   
    } 
    
    function returnFunds(uint256 _value) public onlyOwner {
        require (address (this).balance >= _value);
        owner.transfer (_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit ReturnFunds(msg.sender, _value);
    }
    
    function getBalance() public view returns(uint256) { 
        return address(this).balance; 
    }    

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    function transferOwnership(address payable newOwner) public onlyOwner {
        owner = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit TransferOwnership(newOwner); 
    }
    
    function setPrices(uint256 newSellPrice, uint256 newnumDecimalsSellPrice, uint256 newBuyPrice, uint256 newnumDecimalsBuyPrice) public onlyOwner {
        sellPrice = newSellPrice;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        buyPrice = newBuyPrice;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        numDecimalsBuyPrice = newnumDecimalsBuyPrice;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        numDecimalsSellPrice = newnumDecimalsSellPrice;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit SetPrices(newSellPrice, newnumDecimalsSellPrice, newBuyPrice, newnumDecimalsBuyPrice);
    }

    function buy()public payable  returns (uint256 _value){
        _value = (msg.value * numDecimalsBuyPrice) / buyPrice;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require (balances[address (this)] >= _value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[msg.sender] += _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[address (this)] -= _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Buy(address (this), msg.sender, _value);
        return _value;
    }  

    function sell(uint256 _value) public returns (uint256 revenue){
        require(balances[msg.sender] >= _value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[address (this)] += _value;         	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[msg.sender] -= _value;                  	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        revenue =   (_value * sellPrice) /numDecimalsSellPrice;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        msg.sender.transfer(revenue);
        emit Sell(msg.sender, address (this), _value);             
        return revenue;                                   
    }   

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require (_to != address(0x0));
        require(balances[msg.sender] >= _value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[msg.sender] -= _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[_to] += _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(msg.sender, _to, _value); 
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require (_to != address(0x0));
        require(balances[_from] >= _value && allowance >= _value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[_to] += _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[_from] -= _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        allowed[_from][msg.sender] -= _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(_from, _to, _value); 
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Approval(msg.sender, _spender, _value); 
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
 
    function burn(uint256 _value) public onlyOwner returns (bool success) {
        require(balances[msg.sender] >= _value);   // Check if the sender has enough	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[msg.sender] -= _value;            // Subtract from the sender	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalSupply -= _value;                      // Updates totalSupply	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Burn(msg.sender, _value);
        return true;
    }
    
    function selfdestructcontract () public onlyOwner {
        selfdestruct(owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Sell(address indexed _from, address indexed _to, uint256 _value);
    event Buy(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed _from, uint256 value);
    event SetPrices(uint256 newSellPrice, uint256 newnumDecimalsSellPrice, uint256 newBuyPrice, uint256 newnumDecimalsBuyPrice);
    event TransferOwnership(address indexed newOwner);
    event ReturnFunds(address indexed _from, uint256 _value);
    event ReciveFunds(address indexed _from, uint256 _value);
}