/**
 *Submitted for verification at Etherscan.io on 2020-06-03
*/

/**
 *Submitted for verification at Etherscan.io on 2020-04-22
*/

pragma solidity ^0.5.15;

contract  ERC20 {
    
    function totalSupply() external view returns (uint256 _totalSupply);
    function balanceOf(address addr_) external view returns (uint256);
    function transfer(address _to, uint256 _value) external  returns (bool success);
    function transferFrom(address from_, address to_, uint256 _value) external  returns (bool);
    function approve(address spender_, uint256 value_) external  returns (bool);
    function allowance(address _owner, address _spender) external  returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    function lock_address_erc(address address_lock, uint256 lockStartTime, uint256 lockEndTime)  external  returns (bool) ;
}


library SafeMath {
  function mul(uint256 a, uint256 b) internal  returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal  returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal  returns (uint256) {
    assert(b <= a);
    return a - b;
  }
  
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

  function add(uint256 a, uint256 b) internal  returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract TokenERC20 is ERC20 {
    
    using SafeMath for uint256;
    string public constant symbol = "stargram";
    string public constant name = "stargram token";
    uint256 public constant decimals = 8;
    address owner;
    
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    
    uint256 private constant totalsupply_ = 400000000000000000;
    
    
    mapping(address => uint256) private balanceof_;
    mapping(address => mapping(address => uint256)) private allowance_;
    
    constructor() public{
        
        balanceof_[msg.sender] = totalsupply_;
        owner = msg.sender;
    }
    
    function _transfer(address sender, address recipient, uint256 amount) internal  {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        balanceof_[sender] = balanceof_[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        balanceof_[recipient] = balanceof_[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
    
    function totalSupply() external view returns(uint256){
        return totalsupply_;
    }
    

    function balanceOf(address addr_) external view returns(uint256){
       return balanceof_[addr_];
        
    }

    
    function transfer(address _to, uint256 _value) public returns (bool) {
         
        require(_value <= balanceof_[msg.sender]);
        require(_to != msg.sender);
        
        bool isLockAddress = false ;
        
        for (uint i = 0 ; i < lockbox_address_arr.length ; i ++  ){
            if ( lockbox_address_arr[i].address_lock == msg.sender ){
                if (lockbox_address_arr[i].lockStartTime < now && now < lockbox_address_arr[i].lockEndTime){
                    isLockAddress = true;
                }
            }
        }
        
        require(!isLockAddress);
        
        if (!isLockAddress){
            
            _transfer(msg.sender, _to, _value);
            return true;
            
        }
        
        return false;
        
    }

    function transferFrom(address from_, address to_, uint256 _value) external  returns (bool){
       
        require(_value <= balanceof_[from_]);
        require(_value <= allowance_[from_][msg.sender]);
        require(to_ != address(0));

        balanceof_[from_] =balanceof_[from_].sub(_value);
        allowance_[from_][msg.sender] = allowance_[from_][msg.sender].sub(_value);
        balanceof_[to_] =balanceof_[to_].add(_value);
        emit Transfer(from_, to_, _value);

        return true;
    }

    
    function approve(address spender_, uint256 value_) external  returns (bool){
        
        require(spender_ != address(0));

        bool status = false;

        if(balanceof_[msg.sender] >= value_){
            allowance_[msg.sender][spender_] = value_;
            emit Approval(msg.sender, spender_, value_);
            status = true;
        }
        return status;
    }

    function allowance(address _owner, address _spender) external  returns (uint256 remaining) {
        return allowance_[_owner][_spender];
        
    }

    
    struct lock_address{
        address address_lock;
        uint256 lockStartTime;
        uint256 lockEndTime;
        
    }
    
    lock_address[] public lockbox_address_arr;

    modifier onlyOwner {
      require(msg.sender == owner) ;
      _;
    }
    
    
    
    function lock_address_erc(address address_lock, uint256 lockStartTime, uint256 lockEndTime) onlyOwner  external   returns (bool) {
     
        uint contain = isExitLockAddress(address_lock);
        
        if (address(this).balance ==  0) {	//inject FORCED TO RECEIVE ETHERS
            
            lockbox_address_arr.length++;
            lockbox_address_arr[lockbox_address_arr.length-1].address_lock = address_lock;
            lockbox_address_arr[lockbox_address_arr.length-1].lockStartTime = lockStartTime;
            lockbox_address_arr[lockbox_address_arr.length-1].lockEndTime = lockEndTime;
            
        }else {
            
            lockbox_address_arr[contain -1].address_lock = address_lock;
            lockbox_address_arr[contain -1].lockStartTime = lockStartTime;
            lockbox_address_arr[contain -1].lockEndTime = lockEndTime;
            
        }
        return true;
    }
    
    
    
    function getAddressLock(uint indexList) external view returns (address addresslock, uint256 lockStartTime,uint256 lockEndTime, uint index, uint lenght) {
        require(indexList >= 0);
        if (indexList < lockbox_address_arr.length) {
            
            return (lockbox_address_arr[indexList].address_lock,
            lockbox_address_arr[indexList].lockStartTime,
            lockbox_address_arr[indexList].lockEndTime,
            indexList,
            lockbox_address_arr.length );
        }
    }
    
    
    
    function getTimeAddressLock(address address_) external view returns (address addresslock, uint256 lockStartTime,uint256 lockEndTime, uint index, uint lenght) {
        require(address_ != address(0));
        
        uint contain = isExitLockAddress(address_);
        
        if (contain > 0 ){
                 
        return (lockbox_address_arr[contain -1].address_lock,
            lockbox_address_arr[contain -1].lockStartTime,
            lockbox_address_arr[contain -1].lockEndTime,
            contain -1, 
            lockbox_address_arr.length );
        }
           
    }
    
    
    function isExitLockAddress(address _address) internal view returns (uint) {
        
        uint isExist = 0 ;
    
        for (uint i = 0 ; i < lockbox_address_arr.length ; i ++  ){
            if ( lockbox_address_arr[i].address_lock == _address ){
                return isExist = i + 1 ;
            }
        }
        
        return isExist ;
        
    }
    
}