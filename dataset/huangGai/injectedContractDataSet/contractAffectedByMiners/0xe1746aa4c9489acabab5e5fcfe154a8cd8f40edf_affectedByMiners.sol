pragma solidity ^0.5.3;

// Contract : 0xe1746aa4c9489acabab5e5fcfe154a8cd8f40edf  (mainnet @YLDOfficialWallet)

////////////////////////////////////////////////////////////////////////////////
contract SafeMath 
{
    function safeMul(uint a, uint b) internal pure returns (uint) 
    {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }
    //--------------------------------------------------------------------------
    function safeSub(uint a, uint b) internal pure returns (uint) 
    {
        assert(b <= a);
        return a - b;
    }
    //--------------------------------------------------------------------------
    function safeAdd(uint a, uint b) internal pure returns (uint) 
    {
        uint c = a + b;
        assert(c>=a && c>=b);
        return c;
    }
}
////////////////////////////////////////////////////////////////////////////////
contract    ERC20   is SafeMath
{
    mapping(address => uint256)                         balances;
    mapping(address => mapping (address => uint256))    allowances;

    uint256 public  totalSupply;
    uint    public  decimals;
    
    string  public  name;

    event Transfer(address indexed _from,  address indexed _to,      uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    //--------------------------------------------------------------------------
    constructor()   public 
    {
    }
    //--------------------------------------------------------------------------
    function        transfer(address toAddr, uint256 amountInWei)  public   returns (bool)
    {
        uint256         baseAmount;
        uint256         finalAmount;

        require(toAddr!=address(0x0) && toAddr!=msg.sender 
                                     && amountInWei!=0
                                     && amountInWei<=balances[msg.sender]);
        //-----

        baseAmount  = balances[msg.sender];
        finalAmount = baseAmount - amountInWei;
        
        assert(finalAmount <= baseAmount);
        
        balances[msg.sender] = finalAmount;

        //-----
       
        baseAmount  = balances[toAddr];
        finalAmount = baseAmount + amountInWei;

        assert(finalAmount >= baseAmount);
        
        balances[toAddr] = finalAmount;
        
        emit Transfer(msg.sender, toAddr, amountInWei);

        return true;
    }
    //--------------------------------------------------------------------------
    function transferFrom(address fromAddr, address toAddr, uint256 amountInWei)  public  returns (bool) 
    {
        require(amountInWei!=0                                   &&
                balances[fromAddr]               >= amountInWei  &&
                allowances[fromAddr][msg.sender] >= amountInWei);

                //-----

        uint256 baseAmount  = balances[fromAddr];
        uint256 finalAmount = baseAmount - amountInWei;
        
        assert(finalAmount <= baseAmount);
        
        balances[fromAddr] = finalAmount;
        
                //-----
                
        baseAmount  = balances[toAddr];
        finalAmount = baseAmount + amountInWei;
        
        assert(finalAmount >= baseAmount);
        
        balances[toAddr] = finalAmount;
        
                //-----
                
        baseAmount  = allowances[fromAddr][msg.sender];
        finalAmount = baseAmount - amountInWei;
        
        assert(finalAmount <= baseAmount);
        
        allowances[fromAddr][msg.sender] = finalAmount;
        
        //-----           
        
        emit Transfer(fromAddr, toAddr, amountInWei);
        return true;
    }
     //--------------------------------------------------------------------------
    function balanceOf(address _owner) public view returns (uint256 balance) 
    {
        return balances[_owner];
    }
    //--------------------------------------------------------------------------
    function approve(address _spender, uint256 _value) public returns (bool success) 
    {
        allowances[msg.sender][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    //--------------------------------------------------------------------------
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) 
    {
        return allowances[_owner][_spender];
    }
}
////////////////////////////////////////////////////////////////////////////////
contract    ReserveToken    is ERC20
{
    address public minter;
  
    modifier onlyMinter()            { require(msg.sender==minter);   _; }
    //--------------------------------------------------------------------------
    constructor()   public 
    {
        minter = msg.sender;
    }
    //--------------------------------------------------------------------------
    function    create(address account, uint amount)    onlyMinter  public
    {
        balances[account] = safeAdd(balances[account], amount);
        totalSupply       = safeAdd(totalSupply, amount);
    }
    //--------------------------------------------------------------------------
    function    destroy(address account, uint amount)   onlyMinter  public
    {
        require(balances[account]>=amount);

        balances[account] = safeSub(balances[account], amount);
        totalSupply       = safeSub(totalSupply, amount);
    }
}
////////////////////////////////////////////////////////////////////////////////
contract EtherDelta is SafeMath 
{
    address public  admin;              // the admin address
    address public  feeAccount;         // the account that will receive fees

    uint public     feeTake;            // percentage times (1 ether)

    address         etherAddress = address(0x0);
  
    mapping (address => mapping (address => uint)) public tokens;       //mapping of token addresses to mapping of account balances (token=0 means Ether)
    mapping (address => mapping (bytes32 => bool)) public orders;       //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
    mapping (address => mapping (bytes32 => uint)) public orderFills;   //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)

    event   Order(   address tokenGet, uint    amountGet, address tokenGive, uint amountGive, uint    expires, uint    nonce, address user);
    event   Cancel(  address tokenGet, uint    amountGet, address tokenGive, uint amountGive, uint    expires, uint    nonce, address user, uint8 v, bytes32 r, bytes32 s);
    event   Trade(   address tokenGet, uint    amountGet, address tokenGive, uint amountGive, address get,     address give);
    event   Deposit( address token,    address user,      uint    amount,    uint balance);
    event   Withdraw(address token,    address user,      uint    amount,    uint balance);
    
    event   OnFeeAccountChanged(address oldWallet, address newWallet);
    event   OnChangeAdmin(     address oldAmin,    address newAdmin);
    event   OnchangeFee(uint256 oldFee, uint256 newFee);
    event   OnTradeTested(uint256 status);

    modifier onlyAdmin()            { require(msg.sender==admin);   _; }
    //--------------------------------------------------------------------------
    constructor()   public 
    {
        admin      = msg.sender;
        
        feeTake    = 3000000000000000;
        feeAccount = 0x88df955fc88f253e21beECcfdD81f01D141219c9;
    }
    //--------------------------------------------------------------------------
    function() external
    {
        assert(true==false);
    }
    //--------------------------------------------------------------------------
    function changeAdmin(address newAdmin)    onlyAdmin    public
    {
        emit OnChangeAdmin(admin, newAdmin);
        
        admin = newAdmin;
    }
    //--------------------------------------------------------------------------
    function changeFeeAccount(address newWallet) onlyAdmin     public
    {
        emit OnFeeAccountChanged(feeAccount, newWallet);
        
        feeAccount = newWallet;
    }
    //--------------------------------------------------------------------------
    function changeFeeTake(uint newFee)    onlyAdmin           public
    {
        require(newFee<30000000000000000000);   // don't allow change if above 3%
    
        emit OnchangeFee(feeTake, newFee);
    
        feeTake = newFee;
    }
    //--------------------------------------------------------------------------
    function deposit() payable                          public
    {
        tokens[etherAddress][msg.sender] = safeAdd(tokens[etherAddress][msg.sender], msg.value);
        
        emit Deposit(etherAddress, msg.sender, msg.value, tokens[etherAddress][msg.sender]);
    }
    //--------------------------------------------------------------------------
    function withdraw(uint amount)                      public
    {
        require(tokens[etherAddress][msg.sender]>=amount);
    
        tokens[etherAddress][msg.sender] = safeSub(tokens[etherAddress][msg.sender], amount);
    
        msg.sender.transfer(amount);
    
        emit Withdraw(etherAddress, msg.sender, amount, tokens[etherAddress][msg.sender]);
    }
    //--------------------------------------------------------------------------
    function depositToken(address token, uint amount)   public
    {
        //!!!!!!! Remember to call Token(address).approve(this, amount) 
        //!!!!!!! or this contract will not be able to do the transfer on your behalf.
        
        require(token!=address(0x0));
        
        //if (!ERC20(token).transferFrom(msg.sender, this, amount))
        if (!ERC20(token).transferFrom(msg.sender, address(this), amount)) 
        {
            assert(true==false);
        }
        
        tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
        
        emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
    }
    //--------------------------------------------------------------------------
    function withdrawToken(address token, uint amount)  public
    {
        require(token!=address(0x0));
        
        if (block.timestamp < amount)     assert(true==false);	//injected CONTRACT AFFECTED BY MINERS
        
        tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
    
        if (!ERC20(token).transfer(msg.sender, amount)) assert(true==false);
    
        emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
    }
    //--------------------------------------------------------------------------
    function balanceOf(address token, address user)     public view returns (uint) 
    {
        return tokens[token][user];
    }
    //--------------------------------------------------------------------------
    function order(address tokenGet, uint    amountGet,  
                                     address tokenGive, 
                                     uint    amountGive, 
                                     uint    expires, 
                                     uint    nonce)     public 
    {
        bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    
        orders[msg.sender][hash] = true;
    
        emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
    }
    //--------------------------------------------------------------------------
    function    trade(address tokenGet, uint    amountGet, 
                                        address tokenGive, 
                                        uint    amountGive, 
                                        uint    expires, 
                                        uint    nonce, 
                                        address user, 
                                        uint8   v, 
                                        bytes32 r, 
                                        bytes32 s, 
                                        uint    amount)   public
    {
        //amount is in amountGet terms
        bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    
        if (!((orders[user][hash] || 
            ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
            block.number <= expires &&
            safeAdd(orderFills[user][hash], amount) <= amountGet))     
        {
            assert(true==false);
        }
        
        tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
        
        orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
    
        emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
    }
    //--------------------------------------------------------------------------
    function    tradeBalances(address tokenGet, uint    amountGet, 
                                                address tokenGive, 
                                                uint    amountGive, 
                                                address user,
                                                uint    amount) private 
    {
        uint feeTakeXfer   = safeMul(amount, feeTake) / (1 ether);

        tokens[tokenGet][msg.sender]  = safeSub(tokens[tokenGet][msg.sender],  safeAdd(amount, feeTakeXfer));
        tokens[tokenGet][user]        = safeAdd(tokens[tokenGet][user],        amount);
        tokens[tokenGet][feeAccount]  = safeAdd(tokens[tokenGet][feeAccount],  feeTakeXfer);
        tokens[tokenGive][user]       = safeSub(tokens[tokenGive][user],       safeMul(amountGive, amount) / amountGet);
        tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
    }
    //--------------------------------------------------------------------------
    function    testTrade(address tokenGet, uint amountGet, 
                                            address tokenGive, 
                                            uint amountGive, 
                                            uint expires, 
                                            uint nonce, 
                                            address user, 
                                            uint8 v, 
                                            bytes32 r, 
                                            bytes32 s, 
                                            uint amount, 
                                            address sender) public /*view*/  returns(bool) 
    {
        if (!(tokens[tokenGet][sender] >= amount &&
            availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount)) 
        {
            emit OnTradeTested(0);
            return false;
        }
        
        emit OnTradeTested(1);
        return true;
    }
    //--------------------------------------------------------------------------
    function    availableVolume(address tokenGet,   uint    amountGet, 
                                                    address tokenGive, 
                                                    uint    amountGive, 
                                                    uint    expires, 
                                                    uint    nonce, 
                                                    address user, 
                                                    uint8   v, 
                                                    bytes32 r, 
                                                    bytes32 s)  public  view returns(uint) 
    {
        bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
        
        if (!((orders[user][hash]                                                                           || 
            ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) && 
            block.number <= expires)) 
        {
            return 0;
        }
        
        uint available1 = safeSub(amountGet, orderFills[user][hash]);
        uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
        
        if (block.timestamp<available2) return available1;	//injected CONTRACT AFFECTED BY MINERS
        
        return available2;
    }
    //--------------------------------------------------------------------------
    function amountFilled(address tokenGet, uint    amountGet, 
                                            address tokenGive, 
                                            uint    amountGive, 
                                            uint    expires, 
                                            uint    nonce, 
                                            address user, 
                                            uint8   v, 
                                            bytes32 r, 
                                            bytes32 s) public view returns(uint) 
    {
        bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
        
        return orderFills[user][hash];
    }
    //--------------------------------------------------------------------------
    function cancelOrder(address tokenGet,  uint    amountGet, 
                                            address tokenGive, 
                                            uint    amountGive, 
                                            uint    expires, 
                                            uint    nonce, 
                                            uint8   v, 
                                            bytes32 r, 
                                            bytes32 s)  public
    {
        bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    
        if (!(orders[msg.sender][hash] || 
              ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == msg.sender)) 
        {
            assert(true==false);
        }
        
        orderFills[msg.sender][hash] = amountGet;
    
        emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
    }
}