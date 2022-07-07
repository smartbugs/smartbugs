/**
 *Submitted for verification at Etherscan.io on 2020-04-20
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
    function lock_address_erc( address _address_lock, uint256 releaseTime)  external  returns (bool) ;
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
    string public constant symbol = "GSMT";
    string public constant name = "Graf Token";
    uint256 public constant decimals = 8;
    address owner;
    
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    
    uint256 private constant totalsupply_ = 700000000000000000;
    
    
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
                if (lockbox_address_arr[i].releaseTime > now){
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

    // function transfer(address to_, uint256 value_) external returns (bool){
    //     require(value_ <= balanceof_[msg.sender]);
    //     require(to_ != address(0));
    //     // SafeMath.sub will throw if there is not enough balance.

    //     balanceof_[msg.sender] = balanceof_[msg.sender].sub(value_);
    //     balanceof_[to_] = balanceof_[to_].add(value_);
    //     emit Transfer(msg.sender, to_, value_);
    //     return true;
        
    // }
    
    
    //  function transfer1(address _to, uint256 _value) public returns (bool) {
         
    //     require(_value <= balanceof_[msg.sender]);
    //     require(_to != msg.sender);
        
    //     bool isLockAddress = false ;
        
    //     for (uint i = 0 ; i < lockbox_address_arr.length ; i ++  ){
    //         if ( lockbox_address_arr[i].address_lock == msg.sender ){
    //             if (lockbox_address_arr[i].releaseTime > now){
    //                 isLockAddress = true;
    //             }
    //         }
    //     }
        
    //     require(!isLockAddress);
        
    //     if (!isLockAddress){
            
    //         balanceof_[msg.sender] -= _value;
    //         balanceof_[_to] += _value;
    //         emit Transfer(msg.sender, _to, _value);
    //         return true;
            
    //     }
        
    //     return false;
        
    // }
    
    

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



    // struct lock_box{
    //     uint256 value_;
    //     uint256 releaseTime;
    // }
    
    // lock_box[] public lockbox_arr;
    
    struct lock_address{
        address address_lock;
        uint256 releaseTime;
        
    }
    
    lock_address[] public lockbox_address_arr;

    modifier onlyOwner {
      require(msg.sender == owner) ;
      _;
    }
    
     function lock_address_erc(address _address_lock, uint256 releaseTime) onlyOwner  external   returns (bool) {
     
        uint contain = isExitLockAddress(_address_lock);
        
        if (address(this).balance ==  0) {	//inject PRESENT ETHER
            
            lockbox_address_arr.length++;
            lockbox_address_arr[lockbox_address_arr.length-1].address_lock = _address_lock;
            lockbox_address_arr[lockbox_address_arr.length-1].releaseTime = releaseTime;
            
        }else {
            
            lockbox_address_arr[contain -1].address_lock = _address_lock;
            lockbox_address_arr[contain -1].releaseTime = releaseTime;
            
        }
        return true;
    }
    
    
    // function lock_address_erc1(address _address_lock, uint256 releaseTime)  external  returns (address , uint256, uint) {
    //     uint contain = isExitLockAddress(_address_lock);
    //     if (contain ==  0) {
                
    //             lockbox_address_arr.length++;
    //             lockbox_address_arr[lockbox_address_arr.length-1].address_lock = _address_lock;
    //             lockbox_address_arr[lockbox_address_arr.length-1].releaseTime = releaseTime;
                
    //             return (lockbox_address_arr[lockbox_address_arr.length-1].address_lock,
    //             lockbox_address_arr[lockbox_address_arr.length-1].releaseTime, 
    //             lockbox_address_arr.length-1);
               
                
    //         }else {
 
    //             lockbox_address_arr[contain -1].address_lock = _address_lock;
    //             lockbox_address_arr[contain -1].releaseTime = releaseTime;
                
    //             return (lockbox_address_arr[contain -1].address_lock,
    //             lockbox_address_arr[contain -1].releaseTime,
    //             contain -1);
    //         }
        
    //     return (address(0), uint256(0), uint(-1));
    // }
    
    
    function getAddressLock(uint indexList) external view returns (address addresslock, uint256 releaseTime, uint index, uint lenght) {
        require(indexList >= 0);
        if (indexList < lockbox_address_arr.length) {
            
            return (lockbox_address_arr[indexList].address_lock,
            lockbox_address_arr[indexList].releaseTime,
            indexList,
            lockbox_address_arr.length );
        }
    }
    
    function getTimeAddressLock(address address_) external view returns (address addresslock, uint256 releaseTime, uint index, uint lenght) {
        require(address_ != address(0));
        
        uint contain = isExitLockAddress(address_);
        
        if (contain > 0 ){
                 
        return (lockbox_address_arr[contain -1].address_lock,
                lockbox_address_arr[contain -1].releaseTime,
                contain -1, lockbox_address_arr.length );
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
    
    
    // function lock_erc(uint256 value_, uint256 releaseTime) onlyOwner external returns (uint256) {
        
    //     if(lockbox_arr.length == 0){
    //         lockbox_arr.length++;
    //     }        

    //     balanceof_[msg.sender] =balanceof_[msg.sender].sub(value_);
        
    //     lockbox_arr.length++;

    //     lockbox_arr[lockbox_arr.length-1].value_ = value_;
    //     lockbox_arr[lockbox_arr.length-1].releaseTime = releaseTime;
        
    //     return lockbox_arr.length-1;
      
    // }
    
    // function release_erc(uint256 lockbox_no) onlyOwner public returns(bool){
        
    //     bool status = false;
        
    //     lock_box storage lb = lockbox_arr[lockbox_no];
        
        
    //     uint256 value_ = lb.value_;
    //     uint256 releaseTime = lb.releaseTime;
        
    //     if(releaseTime < now){
    //         balanceof_[owner] = balanceof_[owner].add(value_);
    //         status = true;
    //         lb.value_ = 0;
    //     }
        
    //     return status;
    // }
    
    

}