                                                                 

pragma solidity ^0.6.0;

// SPDX-License-Identifier: UNLICENSED

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
abstract contract ERC20Interface {
    function TOTALSUPPLY572() public virtual view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF708(address tokenOwner) public virtual view returns (uint256 balance);	//inject NONSTANDARD NAMING
    function ALLOWANCE480(address tokenOwner, address spender) public virtual view returns (uint256 remaining);	//inject NONSTANDARD NAMING
    function TRANSFER994(address to, uint256 tokens) public virtual returns (bool success);	//inject NONSTANDARD NAMING
    function APPROVE348(address spender, uint256 tokens) public virtual returns (bool success);	//inject NONSTANDARD NAMING
    function TRANSFERFROM644(address from, address to, uint256 tokens) public virtual returns (bool success);	//inject NONSTANDARD NAMING

    event TRANSFER514(address indexed from, address indexed to, uint256 tokens);	//inject NONSTANDARD NAMING
    event APPROVAL335(address indexed tokenOwner, address indexed spender, uint256 tokens);	//inject NONSTANDARD NAMING
}

                                                                                           

library SafeMath {
  function MUL879(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function DIV1000(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function SUB348(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    assert(b <= a);
    return a - b;
  }

  function ADD74(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

  function CEIL359(uint a, uint m) internal pure returns (uint r) {	//inject NONSTANDARD NAMING
    return (a + m - 1) / m * m;
  }
}

// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address payable public owner;

    event OWNERSHIPTRANSFERRED45(address indexed _from, address indexed _to);	//inject NONSTANDARD NAMING

    constructor() public {
        owner = msg.sender;
    }

    modifier ONLYOWNER910 {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }

    function TRANSFEROWNERSHIP407(address payable _newOwner) public ONLYOWNER910 {	//inject NONSTANDARD NAMING
        owner = _newOwner;
        emit OWNERSHIPTRANSFERRED45(msg.sender, _newOwner);
    }
}

// ----------------------------------------------------------------------------
// 'JAFAR' token contract
// Symbol      : JAFAR
// Name        : Jafar
// Total supply: 2048
// Decimals    : 18
// ----------------------------------------------------------------------------

contract Token is ERC20Interface, Owned{
    using SafeMath for uint256;
    string public symbol = "JAFAR";
    string public  name = "Jafar";
    uint256 public decimals = 18;
    uint256 _totalSupply = 2048 * 10 ** decimals;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    
    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(address preSaleContract) public {
        owner = msg.sender;
        
        balances[preSaleContract] = 1408 * 10 ** (decimals);
        emit TRANSFER514(address(0), preSaleContract, 1408 * 10 ** (decimals));
        
        balances[owner] = 640 * 10 ** (decimals);
        emit TRANSFER514(address(0), owner, 640 * 10 ** (decimals));
    }
    
                                                    

    function TOTALSUPPLY572() public override view returns (uint256){	//inject NONSTANDARD NAMING
       return _totalSupply;
    }
    
    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function BALANCEOF708(address tokenOwner) public override view returns (uint256 balance) {	//inject NONSTANDARD NAMING
        return balances[tokenOwner];
    }

    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function TRANSFER994(address to, uint256 tokens) public override returns (bool success) {	//inject NONSTANDARD NAMING
        // prevent transfer to 0x0, use burn instead
        require(address(to) != address(0));
        require(balances[msg.sender] >= tokens);
        require(balances[to] + tokens >= balances[to]);
        
        balances[msg.sender] = balances[msg.sender].SUB348(tokens);
        balances[to] = balances[to].ADD74(tokens);
        emit TRANSFER514(msg.sender,to,tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    // ------------------------------------------------------------------------
    function APPROVE348(address spender, uint256 tokens) public override returns (bool success){	//inject NONSTANDARD NAMING
        allowed[msg.sender][spender] = tokens;
        emit APPROVAL335(msg.sender,spender,tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    //
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function TRANSFERFROM644(address from, address to, uint256 tokens) public override returns (bool success){	//inject NONSTANDARD NAMING
        require(tokens <= allowed[from][msg.sender]); //check allowance
        require(balances[from] >= tokens);
        require(balances[to] + tokens >= balances[to]);
        
        balances[from] = balances[from].SUB348(tokens);
        balances[to] = balances[to].ADD74(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].SUB348(tokens);
        emit TRANSFER514(from,to,tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function ALLOWANCE480(address tokenOwner, address spender) public override view returns (uint256 remaining) {	//inject NONSTANDARD NAMING
        return allowed[tokenOwner][spender];
    }

    // -----------------------------------------------------------------------------
    // @dev function that burns an amount of the token from caller account
    // @param _amount The amount that will be burnt
    // can be used from account owner
    // -----------------------------------------------------------------------------
    function BURNTOKENS275(uint256 _amount) external{	//inject NONSTANDARD NAMING
        require(balances[msg.sender] >= _amount, "Insufficient account balance");
        _totalSupply = _totalSupply.SUB348(_amount);
        balances[msg.sender] = balances[msg.sender].SUB348(_amount);
        emit TRANSFER514(msg.sender, address(0), _amount);
    }    
}