                                                                 

                                                                                                   
pragma solidity 0.5.16;

                                                                                                                                                                                             
contract Ownable {
    address public owner;
    address public newOwner;

    event OWNERSHIPTRANSFERRED255(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

    constructor() public {
        owner = msg.sender;
        newOwner = address(0);
    }

    modifier ONLYOWNER801() {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }

    modifier ONLYNEWOWNER910() {	//inject NONSTANDARD NAMING
        require(msg.sender != address(0));
        require(msg.sender == newOwner);
        _;
    }
    
    function ISOWNER322(address account) public view returns (bool) {	//inject NONSTANDARD NAMING
        if( account == owner ){
            return true;
        }
        else {
            return false;
        }
    }

    function TRANSFEROWNERSHIP66(address _newOwner) public ONLYOWNER801 {	//inject NONSTANDARD NAMING
        require(_newOwner != address(0));
        newOwner = _newOwner;
    }

    function ACCEPTOWNERSHIP649() public ONLYNEWOWNER910 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED255(owner, newOwner);        
        owner = newOwner;
        newOwner = address(0);
    }
}

                                                                                          
contract Pausable is Ownable {
    event PAUSED648(address account);	//inject NONSTANDARD NAMING
    event UNPAUSED784(address account);	//inject NONSTANDARD NAMING

    bool private _paused;

    constructor () internal {
        _paused = false;
    }    

                                                                               
    function PAUSED429() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _paused;
    }

                                                                                                      
    modifier WHENNOTPAUSED792() {	//inject NONSTANDARD NAMING
        require(!_paused);
        _;
    }

                                                                                                  
    modifier WHENPAUSED835() {	//inject NONSTANDARD NAMING
        require(_paused);
        _;
    }

                                                                                
    function PAUSE539() public ONLYOWNER801 WHENNOTPAUSED792 {	//inject NONSTANDARD NAMING
        _paused = true;
        emit PAUSED648(msg.sender);
    }

                                                                                   
    function UNPAUSE742() public ONLYOWNER801 WHENPAUSED835 {	//inject NONSTANDARD NAMING
        _paused = false;
        emit UNPAUSED784(msg.sender);
    }
}

                                          
contract Mintable {
                                                                              
    function MINTTOKEN168(address to, uint256 amount) public returns (bool success);  	//inject NONSTANDARD NAMING

                                                                                      
    function SETUPMINTABLEADDRESS676(address _mintable) public returns (bool success);	//inject NONSTANDARD NAMING
}

                                                    
contract OffchainIssuable {
                                                    
    uint256 public MIN_WITHDRAW_AMOUNT = 100;

                                                                                                                                         
    function SETMINWITHDRAWAMOUNT929(uint256 amount) public returns (bool success);	//inject NONSTANDARD NAMING

                                                                                                                                        
    function GETMINWITHDRAWAMOUNT682() public view returns (uint256 amount);	//inject NONSTANDARD NAMING

                                                                                                                                                                                 
    function AMOUNTREDEEMOF405(address _owner) public view returns (uint256 amount);	//inject NONSTANDARD NAMING

                                                                                                                                                                                  
    function AMOUNTWITHDRAWOF128(address _owner) public view returns (uint256 amount);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                   
    function REDEEM734(address to, uint256 amount) external returns (bool success);	//inject NONSTANDARD NAMING

                                                                                                   
    function WITHDRAW552(uint256 amount) public returns (bool success);   	//inject NONSTANDARD NAMING
}

                                                         
contract Token {
                                                       
    uint256 public totalSupply;

                                                                                                                                                                                 
    function BALANCEOF407(address _owner) public view returns (uint256 balance);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                      
    function TRANSFER676(address _to, uint256 _value) public returns (bool success);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM24(address _from, address _to, uint256 _value) public returns (bool success);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                
    function APPROVE688(address _spender, uint256 _value) public returns (bool success);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                      
    function ALLOWANCE78(address _owner, address _spender) public view returns (uint256 remaining);	//inject NONSTANDARD NAMING

    event TRANSFER664(address indexed _from, address indexed _to, uint256 _value);	//inject NONSTANDARD NAMING
    event APPROVAL898(address indexed _owner, address indexed _spender, uint256 _value);	//inject NONSTANDARD NAMING
}

                                                          
contract StandardToken is Token {
    uint256 constant private max_uint256778 = 2**256 - 1;	//inject NONSTANDARD NAMING
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    function TRANSFER676(address _to, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(balances[msg.sender] >= _value);
        
        // Ensure not overflow
        require(balances[_to] + _value >= balances[_to]);
        
        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit TRANSFER664(msg.sender, _to, _value);
        return true;
    }

    function TRANSFERFROM24(address _from, address _to, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        
        // Ensure not overflow
        require(balances[_to] + _value >= balances[_to]);          

        balances[_from] -= _value;
        balances[_to] += _value;

        if (allowance < max_uint256778) {
            allowed[_from][msg.sender] -= _value;
        }  

        emit TRANSFER664(_from, _to, _value);
        return true; 
    }

    function BALANCEOF407(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return balances[account];
    }

    function APPROVE688(address _spender, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = _value;
        emit APPROVAL898(msg.sender, _spender, _value);
        return true;
    }

    function ALLOWANCE78(address _owner, address _spender) public view returns (uint256 remaining) {	//inject NONSTANDARD NAMING
      return allowed[_owner][_spender];
    }
}


                                                                                                                                                                                                                           
contract FlowchainToken is StandardToken, Mintable, OffchainIssuable, Ownable, Pausable {

                                       
    string public name = "Flowchain";
    string public symbol = "FLC";    
    uint8 public decimals = 18;
    string public version = "2.0";
    address public mintableAddress;
    address public multiSigWallet;

    bool internal _isIssuable;

    event FREEZE881(address indexed account);	//inject NONSTANDARD NAMING
    event UNFREEZE906(address indexed account);	//inject NONSTANDARD NAMING

    mapping (address => uint256) private _amountMinted;
    mapping (address => uint256) private _amountRedeem;
    mapping (address => bool) public frozenAccount;

    modifier NOTFROZEN65(address _account) {	//inject NONSTANDARD NAMING
        require(!frozenAccount[_account]);
        _;
    }

    constructor(address _multiSigWallet) public {
        // 1 billion tokens + 18 decimals
        totalSupply = 10**27;

        // The multisig wallet that holds the unissued tokens
        multiSigWallet = _multiSigWallet;

        // Give the multisig wallet all initial tokens (unissued tokens)
        balances[multiSigWallet] = totalSupply;  

        emit TRANSFER664(address(0), multiSigWallet, totalSupply);
    }

    function TRANSFER676(address to, uint256 value) public NOTFROZEN65(msg.sender) WHENNOTPAUSED792 returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFER676(to, value);
    }   

    function TRANSFERFROM24(address from, address to, uint256 value) public NOTFROZEN65(from) WHENNOTPAUSED792 returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFERFROM24(from, to, value);
    }

                                                                                                                                         
    function SUSPENDISSUANCE45() external ONLYOWNER801 {	//inject NONSTANDARD NAMING
        _isIssuable = false;
    }

                                                                                                                                        
    function RESUMEISSUANCE530() external ONLYOWNER801 {	//inject NONSTANDARD NAMING
        _isIssuable = true;
    }

                                                                                                                                     
    function ISISSUABLE383() public view returns (bool success) {	//inject NONSTANDARD NAMING
        return _isIssuable;
    }

                                                                                                                                                                                 
    function AMOUNTREDEEMOF405(address _owner) public view returns (uint256 amount) {	//inject NONSTANDARD NAMING
        return _amountRedeem[_owner];
    }

                                                                                                                                                                                  
    function AMOUNTWITHDRAWOF128(address _owner) public view returns (uint256 amount) {	//inject NONSTANDARD NAMING
        return _amountRedeem[_owner];
    }

                                                                                                                                                                                                                                                                           
    function REDEEM734(address to, uint256 amount) external returns (bool success) {	//inject NONSTANDARD NAMING
        require(msg.sender == mintableAddress);    
        require(_isIssuable == true);
        require(amount > 0);

        // The total amount of redeem tokens to the user.
        _amountRedeem[to] += amount;

        // Mint new tokens and send the funds to the account `mintableAddress`
        // Users can withdraw funds.
        MINTTOKEN168(mintableAddress, amount);

        return true;
    }

                                                                                                                                                                        
    function WITHDRAW552(uint256 amount) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(_isIssuable == true);

        // Safety check
        require(amount > 0);        
        require(amount <= _amountRedeem[msg.sender]);
        require(amount >= MIN_WITHDRAW_AMOUNT);

        // Transfer the amount of tokens in the mining contract `mintableAddress` to the user account
        require(balances[mintableAddress] >= amount);

        // The balance of the user redeemed tokens.
        _amountRedeem[msg.sender] -= amount;

        // Keep track of the tokens minted by the user.
        _amountMinted[msg.sender] += amount;

        balances[mintableAddress] -= amount;
        balances[msg.sender] += amount;
        
        emit TRANSFER664(mintableAddress, msg.sender, amount);
        return true;               
    }

                                                                                                                                                                            
    function SETUPMINTABLEADDRESS676(address _mintable) public ONLYOWNER801 returns (bool success) {	//inject NONSTANDARD NAMING
        mintableAddress = _mintable;
        return true;
    }

                                                                                                                                                                                                                                                 
    function MINTTOKEN168(address to, uint256 amount) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(msg.sender == mintableAddress);
        require(balances[multiSigWallet] >= amount);

        balances[multiSigWallet] -= amount;
        balances[to] += amount;

        emit TRANSFER664(multiSigWallet, to, amount);
        return true;
    }

                                                                                                                                         
    function SETMINWITHDRAWAMOUNT929(uint256 amount) public ONLYOWNER801 returns (bool success) {	//inject NONSTANDARD NAMING
        require(amount > 0);
        MIN_WITHDRAW_AMOUNT = amount;
        return true;
    }

                                                                                                                                        
    function GETMINWITHDRAWAMOUNT682() public view returns (uint256 amount) {	//inject NONSTANDARD NAMING
        return MIN_WITHDRAW_AMOUNT;
    }

                                                                                                                                                         
    function FREEZEACCOUNT522(address account) public ONLYOWNER801 returns (bool) {	//inject NONSTANDARD NAMING
        require(!frozenAccount[account]);
        frozenAccount[account] = true;
        emit FREEZE881(account);
        return true;
    }

                                                                                                                                                               
    function UNFREEZEACCOUNT409(address account) public ONLYOWNER801 returns (bool) {	//inject NONSTANDARD NAMING
        require(frozenAccount[account]);
        frozenAccount[account] = false;
        emit UNFREEZE906(account);
        return true;
    }

                                                                                                                                    
    function GETCREATOR217() external view returns (address) {	//inject NONSTANDARD NAMING
        return owner;
    }

                                                                                                                              
    function GETMINTABLEADDRESS583() external view returns (address) {	//inject NONSTANDARD NAMING
        return mintableAddress;
    }
}