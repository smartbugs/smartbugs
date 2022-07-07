/**
 *Submitted for verification at Etherscan.io on 2020-02-10
*/

/**
 * Developed by The Flowchain Foundation
 *
 * The Flowchain tokens (FLC v2) smart contract
 */
pragma solidity 0.5.16;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }

    modifier onlyNewOwner() {
        require(msg.sender != address(0));
        require(tx.origin == newOwner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }
    
    function isOwner(address account) public view returns (bool) {
        if( account == owner ){
            return true;
        }
        else {
            return false;
        }
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0));
        newOwner = _newOwner;
    }

    function acceptOwnership() public onlyNewOwner {
        emit OwnershipTransferred(owner, newOwner);        
        owner = newOwner;
        newOwner = address(0);
    }
}

/**
 * @title Pausable
 * @dev The Pausable can pause and unpause the token transfers.
 */
contract Pausable is Ownable {
    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;

    constructor () internal {
        _paused = false;
    }    

    /**
     * @return true if the contract is paused, false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused);
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused);
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() public onlyOwner whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() public onlyOwner whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}

/**
 * @title The mintable FLC tokens.
 */
contract Mintable {
    /**
     * @dev Mint a amount of tokens and the funds to the user.
     */
    function mintToken(address to, uint256 amount) public returns (bool success);  

    /**
     * @dev Setup a mintable address that can mint or mine tokens.
     */    
    function setupMintableAddress(address _mintable) public returns (bool success);
}

/**
 * @title The off-chain issuable FLC tokens.
 */
contract OffchainIssuable {
    /**
     * The minimal withdraw ammount.
     */
    uint256 public MIN_WITHDRAW_AMOUNT = 100;

    /**
     * @dev Suspend the issuance of new tokens.
     * Once set to false, '_isIssuable' can never be set to 'true' again.
     */
    function setMinWithdrawAmount(uint256 amount) public returns (bool success);

    /**
     * @dev Resume the issuance of new tokens.
     * Once set to false, '_isIssuable' can never be set to 'true' again.
     */
    function getMinWithdrawAmount() public view returns (uint256 amount);

    /**
     * @dev Returns the amount of tokens redeemed to `_owner`.
     * @param _owner The address from which the amount will be retrieved
     * @return The amount
     */
    function amountRedeemOf(address _owner) public view returns (uint256 amount);

    /**
     * @dev Returns the amount of tokens withdrawn by `_owner`.
     * @param _owner The address from which the amount will be retrieved
     * @return The amount
     */
    function amountWithdrawOf(address _owner) public view returns (uint256 amount);

    /**
     * @dev Redeem the value of tokens to the address 'msg.sender'
     * @param to The user that will receive the redeemed token.
     * @param amount Number of tokens to redeem.
     */
    function redeem(address to, uint256 amount) external returns (bool success);

    /**
     * @dev The user withdraw API.
     * @param amount Number of tokens to redeem.
     */
    function withdraw(uint256 amount) public returns (bool success);   
}

/**
 * @dev The ERC20 standard as defined in the EIP.
 */
contract Token {
    /**
     * @dev The total amount of tokens.
     */
    uint256 public totalSupply;

    /**
     * @dev Returns the amount of tokens owned by `account`.
     * @param _owner The address from which the balance will be retrieved
     * @return The balance
     */
    function balanceOf(address _owner) public view returns (uint256 balance);

    /**
     * @dev send `_value` token to `_to` from `msg.sender`
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return Whether the transfer was successful or not
     *
     * Emits a {Transfer} event.
     */
    function transfer(address _to, uint256 _value) public returns (bool success);

    /**
     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return Whether the transfer was successful or not
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    /**
     * @notice `msg.sender` approves `_addr` to spend `_value` tokens
     * @param _spender The address of the account able to transfer the tokens
     * @param _value The amount of wei to be approved for transfer
     * @return Whether the approval was successful or not
     */
    function approve(address _spender, uint256 _value) public returns (bool success);

    /**
     * @param _owner The address of the account owning tokens
     * @param _spender The address of the account able to transfer the tokens
     * @return Amount of remaining tokens allowed to spent
     */
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/**
 * @dev The ERC20 standard implementation of FLC. 
 */
contract StandardToken is Token {
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);
        
        // Ensure not overflow
        require(balances[_to] + _value >= balances[_to]);
        
        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        
        // Ensure not overflow
        require(balances[_to] + _value >= balances[_to]);          

        balances[_from] -= _value;
        balances[_to] += _value;

        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }  

        emit Transfer(_from, _to, _value);
        return true; 
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }
}


/**
 * @dev Extension of ERC-20 that adds off-chain issuable and mintable tokens.
 * It allows miners to mint (create) new FLC tokens.
 *
 * At construction, the contract `_mintableAddress` is the only token minter.
 */
contract FlowchainToken is StandardToken, Mintable, OffchainIssuable, Ownable, Pausable {

    /* Public variables of the token */
    string public name = "Flowchain";
    string public symbol = "FLC";    
    uint8 public decimals = 18;
    string public version = "2.0";
    address public mintableAddress;
    address public multiSigWallet;

    bool internal _isIssuable;

    event Freeze(address indexed account);
    event Unfreeze(address indexed account);

    mapping (address => uint256) private _amountMinted;
    mapping (address => uint256) private _amountRedeem;
    mapping (address => bool) public frozenAccount;

    modifier notFrozen(address _account) {
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

        emit Transfer(address(0), multiSigWallet, totalSupply);
    }

    function transfer(address to, uint256 value) public notFrozen(msg.sender) whenNotPaused returns (bool) {
        return super.transfer(to, value);
    }   

    function transferFrom(address from, address to, uint256 value) public notFrozen(from) whenNotPaused returns (bool) {
        return super.transferFrom(from, to, value);
    }

    /**
     * @dev Suspend the issuance of new tokens.
     * Once set to false, '_isIssuable' can never be set to 'true' again.
     */
    function suspendIssuance() external onlyOwner {
        _isIssuable = false;
    }

    /**
     * @dev Resume the issuance of new tokens.
     * Once set to false, '_isIssuable' can never be set to 'true' again.
     */
    function resumeIssuance() external onlyOwner {
        _isIssuable = true;
    }

    /**
     * @return bool return 'true' if tokens can still be issued by the issuer, 
     * 'false' if they can't anymore.
     */
    function isIssuable() public view returns (bool success) {
        return _isIssuable;
    }

    /**
     * @dev Returns the amount of tokens redeemed to `_owner`.
     * @param _owner The address from which the amount will be retrieved
     * @return The amount
     */
    function amountRedeemOf(address _owner) public view returns (uint256 amount) {
        return _amountRedeem[_owner];
    }

    /**
     * @dev Returns the amount of tokens withdrawn by `_owner`.
     * @param _owner The address from which the amount will be retrieved
     * @return The amount
     */
    function amountWithdrawOf(address _owner) public view returns (uint256 amount) {
        return _amountMinted[_owner];
    }

    /**
     * @dev Redeem user mintable tokens. Only the mining contract can redeem tokens.
     * @param to The user that will receive the redeemed token.     
     * @param amount The amount of tokens to be withdrawn
     * @return The result of the redeem
     */
    function redeem(address to, uint256 amount) external returns (bool success) {
        require(msg.sender == mintableAddress);    
        require(_isIssuable == true);
        require(amount > 0);

        // The total amount of redeem tokens to the user.
        _amountRedeem[to] += amount;

        // Mint new tokens and send the funds to the account `mintableAddress`
        // Users can withdraw funds.
        mintToken(mintableAddress, amount);

        return true;
    }

    /**
     * @dev The user can withdraw his minted tokens.
     * @param amount The amount of tokens to be withdrawn
     * @return The result of the withdraw
     */
    function withdraw(uint256 amount) public returns (bool success) {
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
        
        emit Transfer(mintableAddress, msg.sender, amount);
        return true;               
    }

    /**
     * @dev Setup the contract address that can mint tokens
     * @param _mintable The address of the smart contract
     * @return The result of the setup
     */
    function setupMintableAddress(address _mintable) public onlyOwner returns (bool success) {
        mintableAddress = _mintable;
        return true;
    }

    /**
     * @dev Mint an amount of tokens and transfer to the user
     * @param to The address of the user who will receive the tokens
     * @param amount The amount of rewarded tokens
     * @return The result of token transfer
     */
    function mintToken(address to, uint256 amount) public returns (bool success) {
        require(msg.sender == mintableAddress);
        require(balances[multiSigWallet] >= amount);

        balances[multiSigWallet] -= amount;
        balances[to] += amount;

        emit Transfer(multiSigWallet, to, amount);
        return true;
    }

    /**
     * @dev Suspend the issuance of new tokens.
     * Once set to false, '_isIssuable' can never be set to 'true' again.
     */
    function setMinWithdrawAmount(uint256 amount) public onlyOwner returns (bool success) {
        require(amount > 0);
        MIN_WITHDRAW_AMOUNT = amount;
        return true;
    }

    /**
     * @dev Resume the issuance of new tokens.
     * Once set to false, '_isIssuable' can never be set to 'true' again.
     */
    function getMinWithdrawAmount() public view returns (uint256 amount) {
        return MIN_WITHDRAW_AMOUNT;
    }

    /**
     * @dev Freeze an user
     * @param account The address of the user who will be frozen
     * @return The result of freezing an user
     */
    function freezeAccount(address account) public onlyOwner returns (bool) {
        require(!frozenAccount[account]);
        frozenAccount[account] = true;
        emit Freeze(account);
        return true;
    }

    /**
     * @dev Unfreeze an user
     * @param account The address of the user who will be unfrozen
     * @return The result of unfreezing an user
     */
    function unfreezeAccount(address account) public onlyOwner returns (bool) {
        require(frozenAccount[account]);
        frozenAccount[account] = false;
        emit Unfreeze(account);
        return true;
    }

    /**
     * @dev This function makes it easy to get the creator of the tokens
     * @return The address of token creator
     */
    function getCreator() external view returns (address) {
        return owner;
    }

    /**
     * @dev This function makes it easy to get the mintableAddress
     * @return The address of token creator
     */
    function getMintableAddress() external view returns (address) {
        return mintableAddress;
    }
}