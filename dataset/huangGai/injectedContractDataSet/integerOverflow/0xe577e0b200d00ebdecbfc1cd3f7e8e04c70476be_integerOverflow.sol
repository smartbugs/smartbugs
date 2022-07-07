pragma solidity 0.5.7;

/*
*  xEuro.sol
*  xEUR tokens smart contract
*  implements [ERC-20 Token Standard](https://eips.ethereum.org/EIPS/eip-20)
*  ver. 1.0.7
*  2019-04-29
*  https://xeuro.online
*  address: https://etherscan.io/address/0xe577e0B200d00eBdecbFc1cd3F7E8E04C70476BE 
*  deployed on block: 7660532
*  solc version : 0.5.7+commit.6da8b019
**/

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        //require(b <= a);
        uint256 c = a - b;
        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //require(c >= a);
        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

/**
* ERC-677
* see: https://github.com/ethereum/EIPs/issues/677
* Allow tokens to be transferred to contracts and have the contract trigger logic for how to respond to receiving
* the tokens within a single transaction.
*/
contract TokenRecipient {

    function onTokenTransfer(address _from, uint256 _value, bytes calldata _extraData) external returns (bool);
    // function tokenFallback(address _from, uint256 _value, bytes calldata _extraData) external returns (bool);

}

/**
* see: https://www.cryptonomica.net/#!/verifyEthAddress/
* in our smart contract every new admin should have a verified identity on cryptonomica.net
*/
contract CryptonomicaVerification {

    // returns 0 if verification is not revoked
    function revokedOn(address _address) external view returns (uint unixTime);

    function keyCertificateValidUntil(address _address) external view returns (uint unixTime);

}

contract xEuro {

    /**
    * see: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
    */
    using SafeMath for uint256;

    CryptonomicaVerification public cryptonomicaVerification;

    /* --- ERC-20 variables ----- */

    /**
    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#name
    * function name() constant returns (string name)
    */
    string public constant name = "xEuro";

    /**
    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#symbol
    * function symbol() constant returns (string symbol)
    */
    string public constant symbol = "xEUR";

    /**
    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#decimals
    * function decimals() constant returns (uint8 decimals)
    */
    uint8 public constant decimals = 0; // 1 token = 11, no smaller unit

    /**
    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#totalsupply
    * function totalSupply() constant returns (uint256 totalSupply)
    * we start with zero
    */
    uint256 public totalSupply = 0;

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#balanceof
    // function balanceOf(address _owner) constant returns (uint256 balance)
    mapping(address => uint256) public balanceOf;

    /**
    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#allowance
    * function allowance(address _owner, address _spender) constant returns (uint256 remaining)
    */
    mapping(address => mapping(address => uint256)) public allowance;

    /* --- administrative variables */

    /**
    * addresses that are admins in this smart contracts
    * admin can assign and revoke authority to perform functions (mint, burn, transfer) in this contract
    * for other addresses and for himself
    */
    mapping(address => bool) public isAdmin;

    /**
    * addresses that can mint tokens
    */
    mapping(address => bool) public canMint;

    /**
    * addresses allowed to transfer tokens from contract's own address to another address
    * for example after tokens were minted, they can be transferred to user
    * (tokenholder of new (fresh minted) tokens is always this smart contract itself)
    */
    mapping(address => bool) public canTransferFromContract;

    /**
    * addresses allowed to burn tokens
    * tokens can burned only if their tokenholder is smart contract itself
    * nobody can burn tokens owned by user
    */
    mapping(address => bool) public canBurn;

    /* --- ERC-20 events */

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#events

    /**
    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer-1
    */
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /**
    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approval
    */
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    /**
    * event we fire when data are sent from this smart contract to other smart contract
    * @param _from will be msg.sender
    * @param _toContract address of smart contract information is sent to
    * @param _extraData any data that msg.sender sends to another smart contract
    */
    event DataSentToAnotherContract(address indexed _from, address indexed _toContract, bytes _extraData);

    /* --- ERC-20 Functions */
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods

    /*
    *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
    * there is and attack:
    * https://github.com/CORIONplatform/solidity/issues/6,
    * https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view
    * but this function is required by ERC-20:
    * To prevent attack vectors like the one described on https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/
    * and discussed on https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 ,
    * clients SHOULD make sure to create user interfaces in such a way that they set the allowance first to 0 before
    * setting it to another value for the same spender.
    * THOUGH The contract itself shouldn1t enforce it, to allow backwards compatibility with contracts deployed before
    *
    * @param _spender The address which will spend the funds.
    * @param _value The amount of tokens to be spent.
    */
    function approve(address _spender, uint256 _value) public returns (bool success){

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    /**
    * Overloaded (see https://solidity.readthedocs.io/en/v0.5.7/contracts.html#function-overloading) approve function
    * see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/
    */
    function approve(address _spender, uint256 _currentValue, uint256 _value) external returns (bool success){

        require(allowance[msg.sender][_spender] == _currentValue);

        return approve(_spender, _value);
    }

    /**
    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer
    */
    function transfer(address _to, uint256 _value) public returns (bool success){
        return transferFrom(msg.sender, _to, _value);
    }

    /**
    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom
    */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){

        // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
        // Variables of uint type cannot be negative. Thus, comparing uint variable with zero (greater than or equal) is redundant
        // require(_value >= 0);

        require(_to != address(0));

        // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
        require(
            msg.sender == _from
        || _value <= allowance[_from][msg.sender]
        || (_from == address(this) && canTransferFromContract[msg.sender]),
            "Sender not authorized");

        // check if _from account have required amount
        require(_value <= balanceOf[_from], "Account doesn't have required amount");

        if (_to == address(this)) {// tokens sent to smart contract itself (for exchange to fiat)

            // (!) only token holder can send tokens to smart contract address to get fiat, not using allowance
            require(_from == msg.sender, "Only token holder can do this");

            require(_value >= minExchangeAmount, "Value is less than min. exchange amount");

            // this event used by our bot to monitor tokens that have to be burned and to make a fiat payment
            // bot also verifies this information checking 'tokensInTransfer' mapping, which contains the same data
            tokensInEventsCounter++;
            emit TokensIn(
                _from,
                _value,
                tokensInEventsCounter
            );

            // here we write information about this transfer
            // (the same as in event, but stored in contract variable and with timestamp)
            tokensInTransfer[tokensInEventsCounter].from = _from;
            tokensInTransfer[tokensInEventsCounter].value = _value;
            // timestamp:
            tokensInTransfer[tokensInEventsCounter].receivedOn = now;

        }

        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW


        // If allowance used, change allowances correspondingly
        if (_from != msg.sender && _from != address(this)) {
            allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        }

        emit Transfer(_from, _to, _value);

        return true;
    }

    /*  ---------- Interaction with other contracts  */

    /**
    * ERC-677
    * https://github.com/ethereum/EIPs/issues/677
    * transfer tokens with additional info to another smart contract, and calls its correspondent function
    * @param _to - another smart contract address
    * @param _value - number of tokens
    * @param _extraData - data to send to another contract
    * this is a recommended method to send tokens to smart contracts
    */
    function transferAndCall(address _to, uint256 _value, bytes memory _extraData) public returns (bool success){

        TokenRecipient receiver = TokenRecipient(_to);

        if (transferFrom(msg.sender, _to, _value)) {

            // if (receiver.tokenFallback(msg.sender, _value, _extraData)) {
            if (receiver.onTokenTransfer(msg.sender, _value, _extraData)) {
                emit DataSentToAnotherContract(msg.sender, _to, _extraData);
                return true;
            }

        }

        return false;
    }

    /**
    * the same as above ('transferAndCall'), but for all tokens on user account
    * for example for converting ALL tokens of user account to another tokens
    */
    function transferAllAndCall(address _to, bytes calldata _extraData) external returns (bool){
        return transferAndCall(_to, balanceOf[msg.sender], _extraData);
    }

    /* --- Administrative functions */

    /**
    * @param from old address
    * @param to new address
    * @param by who made a change
    */
    event CryptonomicaArbitrationContractAddressChanged(address from, address to, address indexed by);

    /*
    * @param _newAddress address of new contract to be used to verify identity of new admins
    */
    function changeCryptonomicaVerificationContractAddress(address _newAddress) public returns (bool success) {

        require(isAdmin[msg.sender], "Only admin can do that");

        emit CryptonomicaArbitrationContractAddressChanged(address(cryptonomicaVerification), _newAddress, msg.sender);

        cryptonomicaVerification = CryptonomicaVerification(_newAddress);

        return true;
    }

    /**
   * @param by who added new admin
   * @param newAdmin address of new admin
   */
    event AdminAdded(address indexed by, address indexed newAdmin);

    function addAdmin(address _newAdmin) public returns (bool success){

        require(isAdmin[msg.sender], "Only admin can do that");
        require(_newAdmin != address(0), "Address can not be zero-address");

        require(cryptonomicaVerification.keyCertificateValidUntil(_newAdmin) > now, "New admin has to be verified on Cryptonomica.net");

        // revokedOn returns uint256 (unix time), it's 0 if verification is not revoked
        require(cryptonomicaVerification.revokedOn(_newAdmin) == 0, "Verification for this address was revoked, can not add");

        isAdmin[_newAdmin] = true;

        emit AdminAdded(msg.sender, _newAdmin);

        return true;
    }

    /**
    * @param by an address who removed admin
    * @param _oldAdmin address of the admin removed
    */
    event AdminRemoved(address indexed by, address indexed _oldAdmin);

    /**
    * @param _oldAdmin address to be removed from admins
    */
    function removeAdmin(address _oldAdmin) external returns (bool success){

        require(isAdmin[msg.sender], "Only admin can do that");

        // prevents from deleting the last admin (can be multisig smart contract) by itself:
        require(msg.sender != _oldAdmin, "Admin can't remove himself");

        isAdmin[_oldAdmin] = false;

        emit AdminRemoved(msg.sender, _oldAdmin);

        return true;
    }

    /**
    * minimum amount of tokens than can be exchanged to fiat
    * can be changed by admin
    */
    uint256 public minExchangeAmount;

    /**
    * @param by address who made a change
    * @param from value before the change
    * @param to value after the change
    */
    event MinExchangeAmountChanged (address indexed by, uint256 from, uint256 to);

    /**
    * @param _minExchangeAmount new value of minimum amount of tokens that can be exchanged to fiat
    * only admin can make this change
    */
    function changeMinExchangeAmount(uint256 _minExchangeAmount) public returns (bool success){

        require(isAdmin[msg.sender], "Only admin can do that");

        uint256 from = minExchangeAmount;

        minExchangeAmount = _minExchangeAmount;

        emit MinExchangeAmountChanged(msg.sender, from, minExchangeAmount);

        return true;
    }

    /**
    * @param by who add permission to mint (only admin can do this)
    * @param newAddress address that was authorized to mint new tokens
    */
    event AddressAddedToCanMint(address indexed by, address indexed newAddress);

    /**
    * Add permission to mint new tokens to address _newAddress
    */
    function addToCanMint(address _newAddress) public returns (bool success){

        require(isAdmin[msg.sender], "Only admin can do that");
        require(_newAddress != address(0), "Address can not be zero-address");

        canMint[_newAddress] = true;

        emit AddressAddedToCanMint(msg.sender, _newAddress);

        return true;
    }

    event AddressRemovedFromCanMint(address indexed by, address indexed removedAddress);

    function removeFromCanMint(address _addressToRemove) external returns (bool success){

        require(isAdmin[msg.sender], "Only admin can do that");

        canMint[_addressToRemove] = false;

        emit AddressRemovedFromCanMint(msg.sender, _addressToRemove);

        return true;
    }

    /**
    * @param by who add permission (should be admin)
    * @param newAddress address that got permission
    */
    event AddressAddedToCanTransferFromContract(address indexed by, address indexed newAddress);

    function addToCanTransferFromContract(address _newAddress) public returns (bool success){

        require(isAdmin[msg.sender], "Only admin can do that");
        require(_newAddress != address(0), "Address can not be zero-address");

        canTransferFromContract[_newAddress] = true;

        emit AddressAddedToCanTransferFromContract(msg.sender, _newAddress);

        return true;
    }

    event AddressRemovedFromCanTransferFromContract(address indexed by, address indexed removedAddress);

    function removeFromCanTransferFromContract(address _addressToRemove) external returns (bool success){

        require(isAdmin[msg.sender], "Only admin can do that");

        canTransferFromContract[_addressToRemove] = false;

        emit AddressRemovedFromCanTransferFromContract(msg.sender, _addressToRemove);

        return true;
    }

    /**
    * @param by who add permission (should be admin)
    * @param newAddress address that got permission
    */
    event AddressAddedToCanBurn(address indexed by, address indexed newAddress);

    function addToCanBurn(address _newAddress) public returns (bool success){

        require(isAdmin[msg.sender], "Only admin can do that");
        require(_newAddress != address(0), "Address can not be zero-address");

        canBurn[_newAddress] = true;

        emit AddressAddedToCanBurn(msg.sender, _newAddress);

        return true;
    }

    event AddressRemovedFromCanBurn(address indexed by, address indexed removedAddress);

    function removeFromCanBurn(address _addressToRemove) external returns (bool success){

        require(isAdmin[msg.sender], "Only admin can do that");

        canBurn[_addressToRemove] = false;

        emit AddressRemovedFromCanBurn(msg.sender, _addressToRemove);

        return true;
    }

    /* ---------- Create and burn tokens  */

    /**
    * number (id) for MintTokensEvent
    */
    uint public mintTokensEventsCounter = 0;

    /**
    * struct used to write information about every transaction that mint new tokens (we call it 'MintTokensEvent')
    * every 'MintTokensEvent' has its number/id (mintTokensEventsCounter)
    */
    struct MintTokensEvent {
        address mintedBy; // address that minted tokens (msg.sender)
        uint256 fiatInPaymentId; // reference to fiat transfer (deposit)
        uint value;  // number of new tokens minted
        uint on;    // UnixTime
        uint currentTotalSupply; // new value of totalSupply
    }

    /**
    * keep all fiat tx ids, to prevent minting tokens twice (or more times) for the same fiat deposit
    * @param uint256 reference (id) of fiat deposit
    * @param bool if true tokens already were minted for this fiat deposit
    * (see: require(!fiatInPaymentIds[fiatInPaymentId]); in function mintTokens
    */
    mapping(uint256 => bool) public fiatInPaymentIds;

    /**
    * here we can find a MintTokensEvent by fiatInPaymentId (id of fiat deposit),
    * so we now if tokens were minted for given incoming fiat payment (deposit), and if yes when and how many
    * @param uint256 reference (id) of fiat deposit
    */
    mapping(uint256 => MintTokensEvent) public fiatInPaymentsToMintTokensEvent;

    /**
    * here we store MintTokensEvent with its ordinal numbers/ids (mintTokensEventsCounter)
    * @param uint256 > mintTokensEventsCounter
    */
    mapping(uint256 => MintTokensEvent) public mintTokensEvent;

    /**
    * an event with the same information as in struct MintTokensEvent
    */
    event TokensMinted(
        address indexed by, // who minted new tokens
        uint256 indexed fiatInPaymentId, // reference to fiat payment (deposit)
        uint value, // number of new minted tokens
        uint currentTotalSupply, // totalSupply value after new tokens were minted
        uint indexed mintTokensEventsCounter //
    );

    /**
    * tokens should be minted to contract own address, (!) after that tokens should be transferred using transferFrom
    * @param value number of tokens to create
    * @param fiatInPaymentId fiat payment (deposit) id
    */
    function mintTokens(uint256 value, uint256 fiatInPaymentId) public returns (bool success){

        require(canMint[msg.sender], "Sender not authorized");

        // require that this fiatInPaymentId was not used before:
        require(!fiatInPaymentIds[fiatInPaymentId], "This fiat payment id is already used");

        // Variables of uint type cannot be negative. Thus, comparing uint variable with zero (greater than or equal) is redundant
        // require(value >= 0);

        // this is the moment when new tokens appear in the system
        totalSupply = totalSupply.add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW


        // first token holder of fresh minted tokens always is the contract itself
        // (than tokens have to be transferred from contract address to user address)
        balanceOf[address(this)] = balanceOf[address(this)].add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW


        mintTokensEventsCounter++;
        mintTokensEvent[mintTokensEventsCounter].mintedBy = msg.sender;
        mintTokensEvent[mintTokensEventsCounter].fiatInPaymentId = fiatInPaymentId;
        mintTokensEvent[mintTokensEventsCounter].value = value;
        mintTokensEvent[mintTokensEventsCounter].on = block.timestamp;
        mintTokensEvent[mintTokensEventsCounter].currentTotalSupply = totalSupply;

        // fiatInPaymentId => struct mintTokensEvent
        fiatInPaymentsToMintTokensEvent[fiatInPaymentId] = mintTokensEvent[mintTokensEventsCounter];

        emit TokensMinted(msg.sender, fiatInPaymentId, value, totalSupply, mintTokensEventsCounter);

        // mark fiatInPaymentId as used to mint tokens
        fiatInPaymentIds[fiatInPaymentId] = true;

        return true;
    }

    /**
    * mint and transfer new tokens to user in one tx
    * requires msg.sender to have both 'canMint' and 'canTransferFromContract' permissions
    * @param _value number of new tokens to create (to mint)
    * @param fiatInPaymentId id of fiat payment (deposit) received for new tokens
    * @param _to receiver of new tokens
    */
    function mintAndTransfer(uint256 _value, uint256 fiatInPaymentId, address _to) public returns (bool success){

        if (mintTokens(_value, fiatInPaymentId) && transferFrom(address(this), _to, _value)) {
            return true;
        }

        return false;
    }

    /* -- Exchange tokens to fiat (tokens sent to contract owns address > fiat payment) */

    /**
    * number for every 'event' when we receive tokens to contract own address for exchange to fiat
    */
    uint public tokensInEventsCounter = 0;

    /**
    * @param from who sent tokens for exchange
    * @param value number of tokens received for exchange
    * @param receivedOn timestamp (UnixTime)
    */
    struct TokensInTransfer {// <<< used in 'transfer'
        address from; //
        uint value;   //
        uint receivedOn; // unix time
    }

    /**
    * @param uint256 < tokensInEventsCounter
    */
    mapping(uint256 => TokensInTransfer) public tokensInTransfer;

    /**
    * @param from address that sent tokens for exchange to fiat
    * @param value number of tokens received
    * @param tokensInEventsCounter number of event
    */
    event TokensIn(
        address indexed from,
        uint256 value,
        uint256 indexed tokensInEventsCounter
    );

    /**
    * we also count every every token burning
    */
    uint public burnTokensEventsCounter = 0;//

    /**
    * @param by who burned tokens
    * @param value number of tokens burned
    * @param tokensInEventId corresponding id on tokensInEvent, after witch tokens were burned
    * @param fiatOutPaymentId id of outgoing fiat payment to user
    * @param burnedOn timestamp (unix time)
    * @param currentTotalSupply totalSupply after tokens were burned
    */
    struct burnTokensEvent {
        address by; //
        uint256 value;   //
        uint256 tokensInEventId;
        uint256 fiatOutPaymentId;
        uint256 burnedOn; // UnixTime
        uint256 currentTotalSupply;
    }

    /**
    * @param uint256 < burnTokensEventsCounter
    */
    mapping(uint256 => burnTokensEvent) public burnTokensEvents;

    /**
    *  we count every fiat payment id used when burn tokens to prevent using it twice
    */
    mapping(uint256 => bool) public fiatOutPaymentIdsUsed; //

    /**
    * smart contract event with the same data as in struct burnTokensEvent
    */
    event TokensBurned(
        address indexed by,
        uint256 value,
        uint256 indexed tokensInEventId, // this is the same as uint256 indexed tokensInEventsCounter in event TokensIn
        uint256 indexed fiatOutPaymentId,
        uint burnedOn, // UnixTime
        uint currentTotalSupply
    );

    /**
    * (!) only contract's own tokens (balanceOf[this]) can be burned
    * @param value number of tokens to burn
    * @param tokensInEventId reference to tokensInEventsCounter value for incoming tokens event (tokensInEvent)
    * @param fiatOutPaymentId id of outgoing fiat payment (from the bank)
    */
    function burnTokens(
        uint256 value,
        uint256 tokensInEventId, // this is the same as uint256 indexed tokensInEventsCounter in event TokensIn
        uint256 fiatOutPaymentId
    ) public returns (bool success){

        // Variables of uint type cannot be negative. Thus, comparing uint variable with zero (greater than or equal) is redundant
        // require(value >= 0);

        require(canBurn[msg.sender], "Sender not authorized");
        require(balanceOf[address(this)] >= value, "Account does not have required amount");

        // require(!tokensInEventIdsUsed[tokensInEventId]);
        require(!fiatOutPaymentIdsUsed[fiatOutPaymentId], "This fiat payment id is already used");

        balanceOf[address(this)] = balanceOf[address(this)].sub(value);
        totalSupply = totalSupply.sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW


        burnTokensEventsCounter++;
        burnTokensEvents[burnTokensEventsCounter].by = msg.sender;
        burnTokensEvents[burnTokensEventsCounter].value = value;
        burnTokensEvents[burnTokensEventsCounter].tokensInEventId = tokensInEventId;
        burnTokensEvents[burnTokensEventsCounter].fiatOutPaymentId = fiatOutPaymentId;
        burnTokensEvents[burnTokensEventsCounter].burnedOn = block.timestamp;
        burnTokensEvents[burnTokensEventsCounter].currentTotalSupply = totalSupply;

        emit TokensBurned(msg.sender, value, tokensInEventId, fiatOutPaymentId, block.timestamp, totalSupply);

        fiatOutPaymentIdsUsed[fiatOutPaymentId] = true;

        return true;
    }

    /* ---------- Constructor */
    constructor() public {// Constructor must be public or internal

        // initial admin:
        isAdmin[msg.sender] = true;

        addToCanMint(msg.sender);
        addToCanTransferFromContract(msg.sender);
        addToCanBurn(msg.sender);

        changeCryptonomicaVerificationContractAddress(0x846942953c3b2A898F10DF1e32763A823bf6b27f);
        addAdmin(0xD851d045d8Aee53EF24890afBa3d701163AcbC8B);

        // to test main functions and events (can be removed in production, or can be not):
        changeMinExchangeAmount(12);
        mintAndTransfer(12, 0, msg.sender);
        transfer(msg.sender, 12);
        transfer(address(this), 12);
        burnTokens(12, 1, 0);

    }

}