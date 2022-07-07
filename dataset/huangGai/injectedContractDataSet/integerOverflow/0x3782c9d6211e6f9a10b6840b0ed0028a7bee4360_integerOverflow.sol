/**
 *Submitted for verification at Etherscan.io on 2020-06-12
*/

pragma solidity ^0.5.17;
// @notice SECURITY TOKEN CONTRACT
// @dev ERC-1404 with ERC-20 with ERC-223 protection Token Standard Compliant
// @author Geoffrey Tipton at AEN
// ----------------------------------------------------------------------------
// Deployed by : Geoffrey Tipton
// Symbol      : YOGEE
// Name        : YOGEE Smart Token
// Total supply: 13,520,000,000
// Decimals    : 0
//
// (c) AENSmart. The MIT Licence.
// ----------------------------------------------------------------------------
// THE TOKENS HAVE NOT BEEN REGISTERED UNDER THE U.S. SECURITIES ACT OF
// 1933, AS AMENDED (THE11SECURITIES ACT1).  THE TOKENS WERE ISSUED IN
// A TRANSACTION EXEMPT FROM THE REGISTRATION REQUIREMENTS OF THE SECURITIES
// ACT PURSUANT TO REGULATION S PROMULGATED UNDER IT.  THE TOKENS MAY NOT
// BE OFFERED OR SOLD IN THE UNITED STATES UNLESS REGISTERED UNDER THE SECURITIES
// ACT OR AN EXEMPTION FROM REGISTRATION IS AVAILABLE.  TRANSFERS OF THE
// TOKENS MAY NOT BE MADE EXCEPT IN ACCORDANCE WITH THE PROVISIONS OF REGULATION S,
// PURSUANT TO REGISTRATION UNDER THE SECURITIES ACT, OR PURSUANT TO AN AVAILABLE
// EXEMPTION FROM REGISTRATION.  FURTHER, HEDGING TRANSACTIONS WITH REGARD TO THE
// TOKENS MAY NOT BE CONDUCTED UNLESS IN COMPLIANCE WITH THE SECURITIES ACT.
// ----------------------------------------------------------------------------

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b; //require(c >= a,"Can not add negative values"); }
    function sub(uint a, uint b) internal pure returns (uint c) {
        //require(b <= a, "Result can not be negative"); c = a - b;  }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b; require(a == 0 || c / a == b,"Divide by zero protection"); }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0,"Divide by zero protection"); c = a / b; }
}

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) public view returns (uint256 balance);
    function allowance(address owner, address spender) public view returns (uint remaining);
    function transfer(address to, uint value) public returns (bool success);
    function approve(address spender, uint value) public returns (bool success);
    function transferFrom(address from, address to, uint value) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// ----------------------------------------------------------------------------
// Open Standard ERC Token Standard #1404 Interface
// https://erc1404.org
// ----------------------------------------------------------------------------
contract ERC1404 is ERC20Interface {
    function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);
    function messageForTransferRestriction (uint8 restrictionCode) public view returns (string memory);
}

contract Owned {
    address public owner;
    address internal newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can execute this function");
        _;
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        newOwner = _newOwner;
    }

    // Prevent accidental false ownership change
    function acceptOwnership() external {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
        emit OwnershipTransferred(owner, newOwner);
    }

    function getOwner() external view returns (address) {
        return owner;
    }
}

contract Managed is Owned {
    mapping(address => bool) public managers;

    modifier onlyManager() {
        require(managers[msg.sender], "Only managers can perform this action");
        _;
    }

    function addManager(address managerAddress) external onlyOwner {
        managers[managerAddress] = true;
    }

    function removeManager(address managerAddress) external onlyOwner {
        managers[managerAddress] = false;
    }
}

/* ----------------------------------------------------------------------------
 * Contract function to manage the white list
 * Byte operation to control function of the whitelist,
 * and prevent duplicate address entries. simple example
 * whiteList[add] = 0000 = 0x00 = Not allowed to do either
 * whiteList[add] = 0001 = 0x01 = Allowed to receive
 * whiteList[add] = 0010 = 0x02 = Allowed to send
 * whiteList[add] = 0011 = 0x03 = Allowed to send and receive
 * whiteList[add] = 0100 = 0x04 = Frozen not allowed to do either
 * whiteList[add] = 1000 = 0x08 = Paused No one can transfer any tokens
 *----------------------------------------------------------------------------
 */
contract Whitelist is Managed {
    mapping(address => bytes1) public whiteList;
    bytes1 internal listRule;
    bytes1 internal constant WHITELISTED_CAN_RX_CODE = 0x01;  // binary for 0001
    bytes1 internal constant WHITELISTED_CAN_TX_CODE = 0x02;  // binary for 0010
    bytes1 internal constant WHITELISTED_FREEZE_CODE = 0x04;  // binary for 0100 Always applies
    bytes1 internal constant WHITELISTED_PAUSED_CODE = 0x08;  // binary for 1000 Always applies

    function isFrozen(address _account) public view returns (bool) {
        return (WHITELISTED_FREEZE_CODE == (whiteList[_account] & WHITELISTED_FREEZE_CODE)); // 10 & 11 = True
    }

    function addToSendAllowed(address _to) external onlyManager {
        whiteList[_to] = whiteList[_to] | WHITELISTED_CAN_TX_CODE; // just add the code 1
    }

    function addToReceiveAllowed(address _to) external onlyManager {
        whiteList[_to] = whiteList[_to] | WHITELISTED_CAN_RX_CODE; // just add the code 2
    }

    function removeFromSendAllowed(address _to) public onlyManager {
        if (WHITELISTED_CAN_TX_CODE == (whiteList[_to] & WHITELISTED_CAN_TX_CODE))  { // check code 4 so it does toggle when recalled
            whiteList[_to] = whiteList[_to] ^ WHITELISTED_CAN_TX_CODE; // xor the code to remove the flag
        }
    }

    function removeFromReceiveAllowed(address _to) public onlyManager {
        if (WHITELISTED_CAN_RX_CODE == (whiteList[_to] & WHITELISTED_CAN_RX_CODE))  {
            whiteList[_to] = whiteList[_to] ^ WHITELISTED_CAN_RX_CODE;
        }
    }

    function removeFromBothSendAndReceiveAllowed (address _to) external onlyManager {
        removeFromSendAllowed(_to);
        removeFromReceiveAllowed(_to);
    }

    /*  this overrides the individual whitelisting and manager positions so a
        frozen account can not be unfrozen by a lower level manager
    */
    function freeze(address _to) external onlyOwner {
        whiteList[_to] = whiteList[_to] | WHITELISTED_FREEZE_CODE; // 4 [0100]
    }

    function unFreeze(address _to) external onlyOwner {
        if (WHITELISTED_FREEZE_CODE == (whiteList[_to] & WHITELISTED_FREEZE_CODE )) { // Already Unfrozen
            whiteList[_to] = whiteList[_to] ^ WHITELISTED_FREEZE_CODE; // 4 [0100]
        }
    }

    function pause() external onlyOwner {
        listRule = WHITELISTED_PAUSED_CODE; // 8 [1000]
    }

    function resume() external onlyOwner {
        if (WHITELISTED_PAUSED_CODE == listRule ) { // Already Unfrozen
            listRule = listRule ^ WHITELISTED_PAUSED_CODE; // 4 [0100]
        }
    }

    /*    Whitelist Rule defines what the rules are for the whitelisting
          0x00 = No rule
          0x01 = Receiver must be whitelisted
          0x10 = Sender must be whitelisted
          0x11 = Both must be whitelisted
    */
    function setWhitelistRule(byte _newRule) external onlyOwner {
        listRule = _newRule;
    }

    function getWhitelistRule() external view returns (byte){
        return listRule;
    }
}

// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and an initial fixed supply
// ----------------------------------------------------------------------------
contract YOGEEToken is ERC1404, Owned, Whitelist {
    using SafeMath for uint;

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    uint8 internal restrictionCheck;

    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() public {
        symbol = "YOGEE";
        name = "YOGA Smart Token";
        decimals = 1;
        _totalSupply = 13520000000 * 10**uint(decimals);
        balances[msg.sender] = _totalSupply;
        managers[msg.sender] = true;
        listRule = 0x00; // Receiver does not need to be whitelisted
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    modifier transferAllowed(address _from, address _to, uint256 _amount ) {
        require(!isFrozen(_to) && !isFrozen(_from), "One of the accounts are frozen");  // If not frozen go check
        if ((listRule & WHITELISTED_CAN_TX_CODE) != 0) { // If whitelist send rule applies then must be set
            require(WHITELISTED_CAN_TX_CODE == (whiteList[_from] & WHITELISTED_CAN_TX_CODE), "Sending account is not whitelisted"); // 10 & 11 = true
        }
        if ((listRule & WHITELISTED_CAN_RX_CODE) != 0) { // If whitelist to receive is required, then check,
            require(WHITELISTED_CAN_RX_CODE == (whiteList[_to] & WHITELISTED_CAN_RX_CODE),"Receiving account is not whitelisted"); // 01 & 11 = True
        }
        _;
    }

    // ------------------------------------------------------------------------
    // Total supply minus any lost tokens to the zero address (Potential burn)
    function totalSupply() external view returns (uint) {
        return _totalSupply.sub(balances[address(0)]);
    }

    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // function transfer(address _to, uint _tokens)  public receiveAllowed(_to)  returns (bool success) {
    function transfer(address _to, uint _value)  public transferAllowed(msg.sender, _to, _value) returns (bool) {
        require((_to != address(0)) && (_to != address(this))); // Do not allow transfer to 0x0 or the token contract itself
        balances[msg.sender] = balances[msg.sender].sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        balances[_to] = balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    function approve(address spender, uint value) public transferAllowed(msg.sender, spender, value) returns (bool) {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    function transferFrom(address _from, address _to, uint _value) public transferAllowed(_from, _to, _value) returns (bool) {
        // function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        require((_to != address(0)) && (_to != address(this))); // Do not allow transfer to 0x0 or the token contract itself
        balances[_from] = balances[_from].sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        balances[_to] = balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Transfer(_from, _to, _value);
        return true;
    }

    /* ------------------------------------------------------------------------
     * Returns the amount of tokens approved by the owner that can be
     * transferred to the spender's account
    */
    function allowance(address owner, address spender) public view returns (uint) {
        return allowed[owner][spender];
    }


    /* ----------------------------------------------------------------------------------------
     * @dev Creates `amount` tokens and assigns them to `account`, increasing the total supply.
     * Emits a `Transfer` event with `from` set to the zero address.
     * Requirements
     * - `to` cannot be the zero address.
     */
    function mint(address account, uint256 amount) public onlyOwner {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        balances[account] = balances[account].add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Transfer(address(0), account, amount);
    }

    /* ------------------------------------------------------------------------
     * @dev Destroys `amount` tokens from `account`, reducing the total supply.
     * Emits a `Transfer` event with `to` set to the zero address.
     * Requirements
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function burn(address account, uint256 value) public onlyOwner {
        require(account != address(0), "ERC20: prevent burn from a zero address");

        balances[account] = balances[account].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        _totalSupply = _totalSupply.sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Transfer(account, address(0), value);
    }


    /* ------------------------------------------------------------------------
     * don't accept ETH
     */
    function() payable external {
        revert();
    }

    /* ------------------------------------------------------------------------
     * This function prevents accidentally sent tokens to the contract
     */
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }

    /* ------------------------------------------------------------------------
     * The following functions are for 1404 interface compliance, to detect
     * a transaction is allowed before sending, to save gas and obtain a clear Message
    */
    function detectTransferRestriction (address _from, address _to, uint256 _value) public view returns (uint8 restrictionCode)
    {
        restrictionCode = 0; // No restrictions
        if ( WHITELISTED_CAN_TX_CODE == (listRule & WHITELISTED_CAN_TX_CODE) ) { //Can Send rule applies
            if (!(WHITELISTED_CAN_TX_CODE == (whiteList[_to] & WHITELISTED_CAN_TX_CODE)) ) { //True if allowed to send
                restrictionCode += 1; // Send is not allowed
            }
        }
        if (WHITELISTED_CAN_RX_CODE == (listRule & WHITELISTED_CAN_RX_CODE)){ // Can Receive Rule applied
            if (!(WHITELISTED_CAN_RX_CODE == (whiteList[_from] & WHITELISTED_CAN_RX_CODE))) {
                restrictionCode += 2; // Receive is not allowed
            }
        }
        if ((WHITELISTED_FREEZE_CODE == (whiteList[_from] & WHITELISTED_FREEZE_CODE)) ) { // Added to Frozen
            restrictionCode += 4; // Sender is Frozen
        }
        if ((WHITELISTED_FREEZE_CODE == (whiteList[_to] & WHITELISTED_FREEZE_CODE)) ) { // Added to Frozen
            restrictionCode += 8; // Receiver is Frozen
        }

        if (balanceOf(_from) < _value) {
            restrictionCode += 16; // Send has insufficient balance
        }

        if (listRule == (listRule & WHITELISTED_PAUSED_CODE) ) {
            restrictionCode += 32; // Send has insufficient balance
        }

        return restrictionCode;
    }

    /* ------------------------------------------------------------------------------------
    * helper function to return a human readable message for the detectTransferRestriction
    */
    function messageForTransferRestriction (uint8 _restrictionCode) public view returns (string memory _message) {
        _message = "Transfer Allowed";  // default and when is zero

        if (_restrictionCode >= 32) {
            _message = "Contract Token is Paused for all transfers";
        } else if (_restrictionCode >= 16) {
            _message = "Insufficient Balance to send";
        } else if (_restrictionCode >= 8) {
            _message = "To Account is Frozen, contact provider";
        } else if (_restrictionCode >= 4) {
            _message = "From Account is Frozen, contact provider";
        } else if (_restrictionCode >= 3) {
            _message = "Both Sending and receiving address has not been KYC Approved";
        } else if (_restrictionCode >= 2) {
            _message = "Receiving address has not been KYC Approved";
        } else if (_restrictionCode >= 1) {
            _message = "Sending address has not been KYC Approved";
        }
        return _message;
    }
}