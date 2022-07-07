pragma solidity 0.5.10;

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
    require(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    //require(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    //require(c >= a);
    return c;
  }
}

contract ERC20 {
  function totalSupply()public view returns (uint256 total_Supply);
  function balanceOf(address who)public view returns (uint256);
  function allowance(address owner, address spender)public view returns (uint256);
  function transferFrom(address from, address to, uint256 value)public returns (bool ok);
  function approve(address spender, uint256 value)public returns (bool ok);
  function transfer(address to, uint256 value)public returns (bool ok);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract WOWX is ERC20 { 
    using SafeMath for uint256;
    //--- Token configurations ----// 
    string private constant _name = "WOWX Token";
    string private constant _symbol = "WOWX";
    uint8 private constant _decimals = 18;
    uint256 private constant _maxCap = 185000000 ether;

    //--- Milestones --------------//
    uint256 private _icoStartDate = 1551412800;   // 01-03-2019 12:00 GMT+8
    uint256 private _icoEndDate = 1561867200;     // 30-06-2019 12:00 GMT+8
    
    //--- Token allocations -------//
    uint256 private _totalsupply;

    //--- Address -----------------//
    address private _owner;
    address private _walletWowX;
    address payable private _ethFundMain;
    
    //--- Variables ---------------//
    bool private _lockToken = true;
    bool private _allowICO = true;
    
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;
    mapping(address => bool) private locked;
    
    event Mint(address indexed from, address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);
    event ChangeReceiveWallet(address indexed newAddress);
    event ChangeOwnerShip(address indexed newOwner);
    event ChangeWowxWallet(address indexed newAddress);
    event ChangeLockStatusFrom(address indexed investor, bool locked);
    event ChangeTokenLockStatus(bool locked);
    event ChangeAllowICOStatus(bool allow);
    
    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner is allowed");
        _;
    }

    modifier onlyICO() {
        require(now >= _icoStartDate && now < _icoEndDate, "CrowdSale is not running");
        _;
    }

    modifier onlyFinishedICO() {
        require(now >= _icoEndDate, "CrowdSale is running");
        _;
    }
    
    modifier onlyAllowICO() {
        require(_allowICO, "ICO stopped");
        _;
    }
    
    modifier onlyUnlockToken() {
        require(!_lockToken, "Token locked");
        _;
    }

    constructor() public
    {
        _owner = msg.sender;
    }
    
    function name() public pure returns (string memory) {
        return _name;
    }
    
    function symbol() public pure returns (string memory) {
        return _symbol;
    }
    
    function decimals() public pure returns (uint8) {
        return _decimals;
    }
    
    function maxCap() public pure returns (uint256) {
        return _maxCap;
    }
    
    function owner() public view returns (address) {
        return _owner;
    }

    function walletWowX() public view returns (address) {
        return _walletWowX;
    }
    
    function ethFundMain() public view returns (address) {
        return _ethFundMain;
    }
    
    function icoStartDate() public view returns (uint256) {
        return _icoStartDate;
    }
    
    function icoEndDate() public view returns (uint256) {
        return _icoEndDate;
    }
    
    function lockToken() public view returns (bool) {
        return _lockToken;
    }
    
    function allowICO() public view returns (bool) {
        return _allowICO;
    }
    
    function lockStatusFrom(address investor) public view returns (bool) {
        return locked[investor];
    }

    function totalSupply() public view returns (uint256) {
        return _totalsupply;
    }
    
    function balanceOf(address investor) public view returns (uint256) {
        return balances[investor];
    }
    
    function approve(address _spender, uint256 _amount) public onlyFinishedICO onlyUnlockToken returns (bool)  {
        require( _spender != address(0), "Address can not be 0x0");
        require(balances[msg.sender] >= _amount, "Balance does not have enough tokens");
        require(!locked[msg.sender], "Sender address is locked");
        require(!locked[_spender], "Sender address is locked");
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }
  
    function allowance(address _from, address _spender) public view returns (uint256) {
        return allowed[_from][_spender];
    }

    function transfer(address _to, uint256 _amount) public onlyFinishedICO onlyUnlockToken returns (bool) {
        require( _to != address(0), "Receiver can not be 0x0");
        require(!locked[msg.sender], "Sender address is locked");
        require(!locked[_to], "Receiver address is locked");
        balances[msg.sender] = (balances[msg.sender]).sub(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        balances[_to] = (balances[_to]).add(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Transfer(msg.sender, _to, _amount);
        return true;
    }
    
    function transferFrom( address _from, address _to, uint256 _amount ) public onlyFinishedICO onlyUnlockToken returns (bool)  {
        require( _to != address(0), "Receiver can not be 0x0");
        require(!locked[_from], "From address is locked");
        require(!locked[_to], "Receiver address is locked");
        balances[_from] = (balances[_from]).sub(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        balances[_to] = (balances[_to]).add(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Transfer(_from, _to, _amount);
        return true;
    }

    function burn(uint256 _value) public onlyOwner returns (bool) {
        balances[msg.sender] = (balances[msg.sender]).sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW
            
        _totalsupply = _totalsupply.sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW
                     
        emit Burn(msg.sender, _value);
        return true;
    }

    function stopTransferToken() external onlyOwner onlyFinishedICO {
        _lockToken = true;
        emit ChangeTokenLockStatus(true);
    }

    function startTransferToken() external onlyOwner onlyFinishedICO {
        _lockToken = false;
        emit ChangeTokenLockStatus(false);
    }

    function () external payable onlyICO onlyAllowICO {
        
    }

    function manualMint(address receiver, uint256 _value) public onlyOwner{
        mint(_owner, receiver, _value);
    }

    function mint(address from, address receiver, uint256 value) internal {
        require(receiver != address(0), "Address can not be 0x0");
        require(_walletWowX != address(0), "Address can not be 0x0");
        require(value > 0, "Value should larger than 0");
        balances[receiver] = balances[receiver].add(value);
        uint256 wowxShare = value;
        balances[_walletWowX] = balances[_walletWowX] + wowxShare;
        _totalsupply = _totalsupply.add(value).add(wowxShare);
        require(_totalsupply <= _maxCap, "CrowdSale hit max cap");
        emit Mint(from, receiver, value);
        emit Transfer(address(0), receiver, value);
        emit Mint(from, _walletWowX, wowxShare);
        emit Transfer(address(0), _walletWowX, wowxShare);
    }
    
    function haltCrowdSale() external onlyOwner {
        _allowICO = false;
        emit ChangeAllowICOStatus(false);
    }

    function resumeCrowdSale() external onlyOwner {
        _allowICO = true;
        emit ChangeAllowICOStatus(true);
    }

    function changeReceiveWallet(address payable newAddress) external onlyOwner {
        require(newAddress != address(0), "Address can not be 0x0");
        _ethFundMain = newAddress;
        emit ChangeReceiveWallet(newAddress);
    }

    function setWowxWallet(address newAddress) external onlyOwner {
        require(newAddress != address(0), "Address can not be 0x0");
        uint256 _wowxBalance = balances[_walletWowX];
        balances[newAddress] = (balances[newAddress]).add(_wowxBalance);
        balances[_walletWowX] = 0;
        emit Transfer(_walletWowX, newAddress, _wowxBalance);
	    _walletWowX = newAddress;
	    emit ChangeWowxWallet(newAddress);
    }

	function assignOwnership(address newOwner) external onlyOwner {
	    require(newOwner != address(0), "Address can not be 0x0");
	    _owner = newOwner;
	    emit ChangeOwnerShip(newOwner);
	}

    function forwardFunds() external onlyOwner {
        require(_ethFundMain != address(0));
        _ethFundMain.transfer(address(this).balance);
    }

    function haltTokenTransferFromAddress(address investor) external onlyOwner {
        locked[investor] = true;
        emit ChangeLockStatusFrom(investor, true);
    }

    function resumeTokenTransferFromAddress(address investor) external onlyOwner {
        locked[investor] = false;
        emit ChangeLockStatusFrom(investor, false);
    }
}