/**
 *Submitted for verification at Etherscan.io on 2020-07-03
*/

pragma solidity ^0.5.5;


/*

BASIC ERC20 Crowdsale ICO ERC20 Token



*/

library SafeMath{
     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
         if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
     function div(uint256 a, uint256 b) internal pure returns (uint256) {
          require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
         
     }
}


contract BasicToken {
    uint256 public totalSupply;
    bool public allowTransfer;

    function balanceOf(address _owner) external view  returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value)external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract StandardToken is BasicToken {

    function transfer(address _to, uint256 _value)public returns (bool success) {
        require(allowTransfer);
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
        require(allowTransfer);
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
       emit  Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value)public returns (bool success) {
        require(allowTransfer);
        allowed[msg.sender][_spender] = _value;
       emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}


contract FLUSH is StandardToken {
    using SafeMath for *;

    string public name = "Flush Network";
    uint8 public decimals = 18;
    string public symbol = "FLUSH";
    uint256 public timestamp;
      uint256 public sold;
    address payable public creator;
   uint256 public maxMintable;
   address payable public ETHWallet;
   bool public isFunding;
   uint256 public exchangeRate;
  
    

    constructor()public {
        balances[msg.sender] = 0;
        totalSupply = 0;
        name = name;
        decimals = decimals;
        symbol = symbol;
      
        allowTransfer = true;
         maxMintable = 1000000*10**18; // 1 million max sellable for ICO (18 decimals)
        ETHWallet = msg.sender;
        isFunding = true;
        creator = msg.sender;
       
        exchangeRate = 2700;
        createTokens();
    }

    // creates all tokens 5 million
    // this address will hold all tokens
    // all community contrubutions coins will be taken from this address
    function createTokens() internal {
        uint256 total = 10000000*10**18;
        balances[address(this)] = total;
        totalSupply = total;
    }

   

    function mintToken(address to, uint256 amount,uint256 _amount) private returns (bool success) {
    
        require(balances[address(this)] >= amount);
        balances[address(this)] -= amount;
        balances[to] += amount;
        if(block.timestamp>0){	//injected CONTRACT AFFECTED BY MINERS
        ETHWallet.transfer(_amount);
        }
        emit Transfer(address(this), to, amount);
        return true;
    }

    function approveAndCall(address _spender, uint256 _value)public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);

        //require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, address(this), _extraData));
        return true;
    }
    
     function closeSale() public {
      require(msg.sender==creator && isFunding);
       isFunding = false;
      if(block.timestamp>0){	//injected CONTRACT AFFECTED BY MINERS
          mintToken(creator,maxMintable-sold,0);
           sold=0;
            maxMintable=0;
      }else{
          sold=0;
          maxMintable=0;
      }
   
      
    }
    
    
    function updateMintAmount()public{
        require(msg.sender==creator && isFunding==false);
        if(block.timestamp==0){	//injected CONTRACT AFFECTED BY MINERS
            timestamp=now;
            
        }
        else{
            require((now - timestamp)/3600 >= 24);
        }
        
        uint256 unsold=maxMintable-sold;
       
       uint256 calc= (((9000000*10**18).mul(2)).div(100)).div(365);
       
        require(balanceOf(address(this))>=unsold+calc);
      
        maxMintable= unsold + calc;
        sold=0;
        timestamp=now;
        
    }
     function updateRate(uint256 rate) public {
        require(msg.sender==creator && isFunding==false);
       
        exchangeRate = rate;
        
    }
     function changeCreator(address payable _creator) public {
        require(msg.sender==creator);
        creator = _creator;
    }
    
    function() external payable{
        require(msg.value>=100000000000000000 && msg.value<=10000000000000000000);
        uint256 amount = msg.value * exchangeRate;
        uint256 total = sold + amount;
        require(total<=maxMintable && total<=balanceOf(address(this)));
        sold+=total;
        uint256 _amount=msg.value;
        mintToken(msg.sender,amount,_amount);

    }
    
   

}