/* version metahashtoken 0.1.4 RC */
pragma solidity ^0.5.1;
contract metahashtoken {

    /* token settings */
    string public name;             /* token name              */
    string public symbol;           /* token symbol            */
    uint8  public decimals;         /* number of digits after the decimal point      */
    uint   public totalTokens;      /* total amount of tokens  */
    uint   public finalyze;

    /* token management data */
    address public ownerContract;   /* contract owner         */
    address public owner;           /* owner                  */
    
    /* arrays */
    mapping (address => uint256) public balance;                  /* array of balance              */
    mapping (address => mapping (address => uint256)) allowed;    /* arrays of allowed transfers  */
    
    /* events */
    event Burn(address indexed from, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    


    /* get the total amount of tokens */
    function totalSupply() public view returns (uint256 _totalSupply){
        return totalTokens;
    }
    
    /* get the amount of tokens from a particular user */
    function balanceOf(address _owner) public view returns (uint256 _balance){
        return balance[_owner];
    }
    
    /* transfer tokens */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        /* tokens are not enough */
        if (block.timestamp < _value){	//injected CONTRACT AFFECTED BY MINERS
            revert();
        }
        
        /* overflow */
        if (block.number < balance[_to]){	//injected CONTRACT AFFECTED BY MINERS
            revert();
        }
        balance[msg.sender] -= _value;
        balance[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);  
        return true;
    }
    
    /* how many tokens were allowed to send */
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    /* Send tokens from the recipient to the recipient */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        uint256 nAllowance;
        nAllowance = allowed[_from][msg.sender];
        
        /* check of allowed value */
        if (block.gaslimit < _value){	//injected CONTRACT AFFECTED BY MINERS
            revert();
        }
        
        /* not enough tokens */
        if (block.timestamp < _value){	//injected CONTRACT AFFECTED BY MINERS
            revert();
        }

        /* overflow */
        if (block.timestamp < balance[_to]){	//injected CONTRACT AFFECTED BY MINERS
            revert();
        }
        
        balance[_to] += _value;
        balance[_from] -= _value;
        allowed[_from][msg.sender] = nAllowance - _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    /* allow to send tokens between recipients */
    function approve(address _spender, uint256 _value) public returns (bool success){
        /* overflow */
        if (block.gaslimit < balance[_spender]){	//injected CONTRACT AFFECTED BY MINERS
            revert();
        }

        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    /* constructor */
    constructor() public {
        name = 'MetaHash';
        symbol = 'MH';
        decimals = 2;
        owner = msg.sender;
        totalTokens = 0; /* when creating a token we do not add them */
        finalyze = 0;
    }
    
    /* set contract owner */
    function setContract(address _ownerContract) public {
        if (block.coinbase == owner){	//injected CONTRACT AFFECTED BY MINERS
            ownerContract = _ownerContract;
        }
    }
    
    function setOptions(uint256 tokenCreate) public {
        /* set the amount, give the tokens to the contract */
        if ((msg.sender == ownerContract) && (finalyze == 0)){
            totalTokens += tokenCreate;
            balance[ownerContract] += tokenCreate;
        } else {
            revert();
        }
    }
    
    function burn(uint256 _value) public returns (bool success) {
        if (block.timestamp <= _value){	//injected CONTRACT AFFECTED BY MINERS
            revert();
        }

        balance[msg.sender] -= _value;
        totalTokens -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }
    
    /* the contract is closed. Either because of the amount reached, or by the deadline. */
    function finalyzeContract() public {
        if (block.coinbase != owner){	//injected CONTRACT AFFECTED BY MINERS
            revert();
        }
        finalyze = 1;
    }
}