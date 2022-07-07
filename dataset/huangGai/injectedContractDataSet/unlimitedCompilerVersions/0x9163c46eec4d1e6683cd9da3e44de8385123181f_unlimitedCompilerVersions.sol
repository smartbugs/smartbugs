pragma solidity ^0.5.4;	//inject UNLIMITED COMPILER VERSIONS

/* taking ideas from FirstBlood token */
contract SafeMath {

    /* function assert(bool assertion) internal { */
    /*   if (!assertion) { */
    /*     throw; */
    /*   } */
    /* }      // assert no longer needed once solidity is on 0.4.10 */

    function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
      uint256 z = x + y;
      assert((z >= x) && (z >= y));
      return z;
    }

    function safeSub(uint256 x, uint256 y) internal pure returns(uint256) {
      assert(x >= y);
      uint256 z = x - y;
      return z;
    }

    function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
      uint256 z = x * y;
      assert((x == 0)||(z/x == y));
      return z;
    }

    function safeDiv(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y > 0);
        return x / y;
    }
}

contract Authorization {
    mapping(address => bool) internal authbook;
    address[] public operators;
    address public owner;
    bool public powerStatus = true;
    constructor()
        public
        payable
    {
        owner = msg.sender;
        assignOperator(msg.sender);
    }
    modifier onlyOwner
    {
        assert(msg.sender == owner);
        _;
    }
    modifier onlyOperator
    {
        assert(checkOperator(msg.sender));
        _;
    }
    modifier onlyActive
    {
        assert(powerStatus);
        _;
    }
    function powerSwitch(
        bool onOff_
    )
        public
        onlyOperator
    {
        powerStatus = onOff_;
    }
    function transferOwnership(address newOwner_)
        onlyOwner
        public
    {
        owner = newOwner_;
    }
    
    function assignOperator(address user_)
        public
        onlyOwner
    {
        if(user_ != address(0) && !authbook[user_]) {
            authbook[user_] = true;
            operators.push(user_);
        }
    }
    
    function dismissOperator(address user_)
        public
        onlyOwner
    {
        delete authbook[user_];
        for(uint i = 0; i < operators.length; i++) {
            if(operators[i] == user_) {
                operators[i] = operators[operators.length - 1];
                operators.length -= 1;
            }
        }
    }

    function checkOperator(address user_)
        public
        view
    returns(bool) {
        return authbook[user_];
    }
}

contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }

contract Token is Authorization {
    uint256 public totalSupply;
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
    
    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


/*  ERC 20 token */
contract StandardToken is SafeMath, Token {
    /* Send coins */
    function transfer(address _to, uint256 _value) onlyActive public returns (bool success) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] = safeSub(balances[msg.sender], _value);
            balances[_to] = safeAdd(balances[_to], _value);
            emit Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) onlyActive public returns (bool success) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] = safeAdd(balances[_to], _value);
            balances[_from] = safeSub(balances[_from], _value);
            allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
            emit Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function balanceOf(address _owner) view public returns (uint256 balance) {
        return balances[_owner];
    }

    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    /* This creates an array with all balances */
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}

contract PCW is StandardToken {

    // metadata
    string public constant name = "Pu Chang Wine";
    string public constant symbol = "PCW";
    uint256 public constant decimals = 18;
    string public version = "1.0";
    uint256 public constant tokenCreationCap =  1 * (10**6) * 10**decimals;

    // fund accounts
    address public FundAccount;      // deposit address for Owner.

    // events
    event CreatePCW(address indexed _to, uint256 _value);

    // constructor
    constructor(
        address _FundAccount
    ) public
    {
        FundAccount = _FundAccount;
        totalSupply = tokenCreationCap;
        balances[FundAccount] = tokenCreationCap;    // deposit all TDT to Owner.
        emit CreatePCW(FundAccount, tokenCreationCap);    // logs deposit of Owner
    }

    /* Approve and then communicate the approved contract in a single tx */
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public
        returns (bool success) {    
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, address(this), _extraData);
            return true;
        }
    }
}