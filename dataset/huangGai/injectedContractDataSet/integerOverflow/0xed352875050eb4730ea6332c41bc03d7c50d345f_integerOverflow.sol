/**
 *Submitted for verification at Etherscan.io on 2020-07-30
*/

pragma solidity ^ 0.5.17;

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
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        //assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Ownable {
    
  address public owner;
  event OwnershipTransferred(address indexed _from, address indexed _to);
  
  constructor() public {
    owner = msg.sender;
  }
  
  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }
  
  function transferOwnership(address newOwner) public onlyOwner {
    if (newOwner != address(0)) {
            owner = newOwner;
    emit OwnershipTransferred(owner, newOwner);
  }
  }
}


contract ERC20Interface {
  function totalSupply() public view returns(uint);
  function balanceOf(address tokenOwner) public view returns(uint balance);
  function allowance(address tokenOwner, address spender) public view returns(uint remaining);
  function transfer(address to, uint tokens) public returns(bool success);
  function approve(address spender, uint tokens) public returns(bool success);
  function transferFrom(address from, address to, uint tokens) public returns(bool success);
  uint public basisPointsRate = 0;
  uint256 public maximumFee = 0;
  uint public MAX_UINT = 2**256 - 1;
  modifier onlyPayloadSize(uint size) {
        require(!(msg.data.length < size + 4));
        _;
    }
  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed owner, address indexed spender, uint value);
}


contract ApproveAndCallFallBack {
  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}


contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;

  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  modifier whenPaused() {
    require(paused);
    _;
  }

  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}

contract managerList is Ownable {
    mapping(address => bool) managerlist;
  
  function addManager(address whois) public onlyOwner {
    managerlist[whois] = true;
    emit AddManager(whois);
  }

  function removeManager(address whois) public onlyOwner {
    managerlist[whois] = false;
    emit RemoveManager(whois);
  }

    event AddManager(address indexed whois);
    event RemoveManager(address indexed whois);
}

contract blackList is Ownable, managerList{
    mapping(address => bool) blacklist;
    
    modifier permissionCheck {
    require(!blacklist[msg.sender]);
    _;
  }
  
  function lockUser(address whois) public {
    require(whois != owner,"DON'T_LOCKING_OWNER");
    require(managerlist[msg.sender],"YOU_ARE_NOT_A_MANAGER");
    blacklist[whois] = true;
    emit LockedUser(whois);
  }

  function unlockUser(address whois) public {
    require(managerlist[msg.sender],"YOU_ARE_NOT_A_MANAGER");
    blacklist[whois] = false;
    emit UnlockedkUser(whois);
  }
  
    event LockedUser(address indexed whois);
    event UnlockedkUser(address indexed whois);
}

contract token { 
    function transfer(address receiver, uint amount) public{ 
        receiver; amount; 
    } 
} 

contract KunToken is Pausable, ERC20Interface, blackList {
    using SafeMath for uint;
    string public symbol;
    string public name;
    uint8 public decimals;
    uint256 amount_eth;
    uint _totalSupply;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint256)) public allowed;
    token public ERC20Token;
    bool public islocked;

    constructor() public {
        name = "Kun_Global";
        symbol = "Kun";
        decimals = 6;
        _totalSupply = 10000000000000;
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }


    function balanceOf(address whois) public view returns (uint) {
        return balances[whois];
    }
    
    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return allowed[_owner][_spender];
    }

    function transfer(address _to, uint _value) public whenNotPaused onlyPayloadSize(2 * 32) returns(bool success){
        require(!blacklist[msg.sender],"MSG_SENDER_IS_LOCKED");
        require(!blacklist[_to],"USER_TO_IS_LOCKED");
        uint fee = (_value.mul(basisPointsRate)).div(10000);
        if (fee > maximumFee) {
            fee = maximumFee;
        }
        uint sendAmount = _value.sub(fee);
        balances[msg.sender] = balances[msg.sender].sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        balances[_to] = balances[_to].add(sendAmount);
        if (fee > 0) {
            balances[owner] = balances[owner].add(fee);
            emit Transfer(msg.sender, owner, fee);
        }
        emit Transfer(msg.sender, _to, sendAmount);
        return true;
    }

    function approve(address _spender, uint _value) public whenNotPaused onlyPayloadSize(2 * 32) returns(bool success){
        require(!blacklist[msg.sender],"MSG.SENDER_IS_LOCKED");
        require(!blacklist[_spender],"_SPENDER_IS_LOCKED");
        require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns(bool success){
        require(!blacklist[msg.sender],"MSG.SENDER_IS_LOCKED");
        require(!blacklist[_from],"USER_FROM_IS_LOCKED");
        require(!blacklist[_to],"USER_TO_IS_LOCKED");
        uint _allowance = allowed[_from][msg.sender];
        uint fee = (_value.mul(basisPointsRate)).div(10000);
        if (fee > maximumFee) {
            fee = maximumFee;
        }
        if (_allowance < MAX_UINT) {
            allowed[_from][msg.sender] = _allowance.sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        }
        uint sendAmount = _value.sub(fee);
        balances[_from] = balances[_from].sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        balances[_to] = balances[_to].add(sendAmount);
        if (fee > 0) {
            balances[owner] = balances[owner].add(fee);
        emit Transfer(_from, owner, fee);
        }
        emit Transfer(_from, _to, sendAmount);
        return true;
    }
    
    function totalSupply() public view returns (uint) {
       return _totalSupply.sub(balances[address(0)]);
    }

    function issue(uint amount) public onlyOwner {
        require(_totalSupply + amount > _totalSupply);
        require(balances[owner] + amount > balances[owner]);
        balances[owner] += amount;
        _totalSupply += amount;
        emit Issue(amount);
    }

    function redeem(uint amount) public onlyOwner {
        require(_totalSupply >= amount);
        require(balances[owner] >= amount);
        _totalSupply -= amount;
        balances[owner] -= amount;
        emit Redeem(amount);
    }

    function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
        require(newBasisPoints < 20);
        require(newMaxFee < 50);
        basisPointsRate = newBasisPoints;
        maximumFee = newMaxFee.mul(10**decimals);
        emit Params(basisPointsRate, maximumFee);
    }
    
    function approveAndCall(address spender, uint tokens, bytes memory data) public onlyOwner whenNotPaused 
        permissionCheck returns(bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
  }
  
    function redeemBLT (address LockUser) public onlyOwner {
        require(blacklist[LockUser]);
        uint dirtyFunds = balanceOf(LockUser);
        balances[LockUser] = 0;
        _totalSupply -= dirtyFunds;
        emit RedeemBLT(LockUser, dirtyFunds);
    }
    

    function () external payable {
    }
  
    function withDrawal() public onlyOwner returns(bool success){
        msg.sender.transfer(address(this).balance);
        return true;
    }
    
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns(bool success) {
        ERC20Token = token(tokenAddress);
        ERC20Token.transfer(owner, tokens);
        return true;
    }
    
    function payforUser(address tokenAddress, address _to, uint tokens) public returns(bool success){
        require(!blacklist[msg.sender],"YOU_ARE_LOCKED");
        require(managerlist[msg.sender],"YOU_ARE_NOT_A_MANAGER");
        ERC20Token = token(tokenAddress);
        ERC20Token.transfer(_to,tokens);
        ERC20Token = token(msg.sender);
        return true;
    }
    
    function isLocked(address whois) public {
        require(managerlist[msg.sender],"YOU_ARE_NOT_A_MANAGER");
        islocked = false;
        if (blacklist[whois] == true) {
            islocked = true;
        } 
    }

    event Issue(uint amount);

    event Redeem(uint amount);

    event Params(uint feeBasisPoints, uint maxFee);
    
    event RedeemBLT(address LockUser, uint dirtyFunds);
}