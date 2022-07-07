// File: contracts/Dictionary.sol

pragma solidity ^0.5.2;

// Taken from https://github.com/sagivo/solidity-utils/blob/master/contracts/lib/Dictionary.sol
library Dictionary {
    uint private constant NULL = 0;

    struct Node {
        uint prev;
        uint next;
        bytes data;
        bool initialized;
    }

    struct Data {
        mapping(uint => Node) list;
        uint firstNodeId;
        uint lastNodeId;
        uint len;
    }

    function insertAfter(
        Data storage self,
        uint afterId,
        uint id,
        bytes memory data
    ) internal {
        if (self.list[id].initialized) {
            self.list[id].data = data;
            return;
        }
        self.list[id].prev = afterId;
        if (self.list[afterId].next == NULL) {
            self.list[id].next = NULL;
            self.lastNodeId = id;
        } else {
            self.list[id].next = self.list[afterId].next;
            self.list[self.list[afterId].next].prev = id;
        }
        self.list[id].data = data;
        self.list[id].initialized = true;
        self.list[afterId].next = id;
        self.len++;
    }

    function insertBefore(
        Data storage self,
        uint beforeId,
        uint id,
        bytes memory data
    ) internal {
        if (self.list[id].initialized) {
            self.list[id].data = data;
            return;
        }
        self.list[id].next = beforeId;
        if (self.list[beforeId].prev == NULL) {
            self.list[id].prev = NULL;
            self.firstNodeId = id;
        } else {
            self.list[id].prev = self.list[beforeId].prev;
            self.list[self.list[beforeId].prev].next = id;
        }
        self.list[id].data = data;
        self.list[id].initialized = true;
        self.list[beforeId].prev = id;
        self.len++;
    }

    function insertBeginning(Data storage self, uint id, bytes memory data)
        internal
    {
        if (self.list[id].initialized) {
            self.list[id].data = data;
            return;
        }
        if (self.firstNodeId == NULL) {
            self.firstNodeId = id;
            self.lastNodeId = id;
            self.list[id] = Node({
                prev: 0,
                next: 0,
                data: data,
                initialized: true
            });
            self.len++;
        } else insertBefore(self, self.firstNodeId, id, data);
    }

    function insertEnd(Data storage self, uint id, bytes memory data) internal {
        if (self.lastNodeId == NULL) insertBeginning(self, id, data);
        else insertAfter(self, self.lastNodeId, id, data);
    }

    function set(Data storage self, uint id, bytes memory data) internal {
        insertEnd(self, id, data);
    }

    function get(Data storage self, uint id)
        internal
        view
        returns (bytes memory)
    {
        return self.list[id].data;
    }

    function remove(Data storage self, uint id) internal returns (bool) {
        uint nextId = self.list[id].next;
        uint prevId = self.list[id].prev;

        if (prevId == NULL) self.firstNodeId = nextId; //first node
        else self.list[prevId].next = nextId;

        if (nextId == NULL) self.lastNodeId = prevId; //last node
        else self.list[nextId].prev = prevId;

        delete self.list[id];
        self.len--;

        return true;
    }

    function getSize(Data storage self) internal view returns (uint) {
        return self.len;
    }

    function next(Data storage self, uint id) internal view returns (uint) {
        return self.list[id].next;
    }

    function prev(Data storage self, uint id) internal view returns (uint) {
        return self.list[id].prev;
    }

    function keys(Data storage self) internal view returns (uint[] memory) {
        uint[] memory arr = new uint[](self.len);
        uint node = self.firstNodeId;
        for (uint i = 0; i < self.len; i++) {
            arr[i] = node;
            node = next(self, node);
        }
        return arr;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: contracts/Etherclear.sol

pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;




/**
 * @title Etherclear
 * @dev The Etherclear contract is meant to serve as a transition step for funds between a sender
 * and a recipient, where the sender can take the funds back if they cancel the payment,
 * and the recipient can only retrieve the funds in a specified amount of time, using
 * a passphrase communicated privately by the sender.
 *
 * The usage of the contract is as follows:
 *
 * 1) The sender generates a passphrase, and passes keccak256(passphrase,recipient_address) to the
 * contract, along with a hold time. This registers a payment ID (which must be unique), and
 * marks the start of the holding time window.
 * 2) The sender communicates this passphrase to the recipient over a secure channel.
 * 3) Before the holding time has passed, the recipient can send the passphrase to the contract to withdraw the funds.
 * 4) After the holding time has passed, the recipient is no longer able to withdraw the funds, regardless
 * of whether they have the passphrase or not.
 *
 * At any time, the sender can cancel the payment if they provide the payment ID, which
 * will initiate a transfer of funds back to the sender.
 * The sender is expected to cancel the payment if they have made a mistake in specifying
 * the recipient's address, the recipient does not claim the funds, or if the holding period has expired and the
 * funds need to be retrieved.
 *
 * TODO: Currently, the payment ID is a truncated version of the passphrase hash that is used to ensure knowledge of the
 * passphrase. They will be left as separate entities for now in case they need to be constructed differently.
 *
 * NOTE: the hold time functionality is not very secure for small time periods since it uses now (block.timestamp). It is meant to be an additional security measure, and should not be relied upon in the case of an
 attack. The current known tolerance is 900 seconds:
 * https://github.com/ethereum/wiki/blob/c02254611f218f43cbb07517ca8e5d00fd6d6d75/Block-Protocol-2.0.md
 *
 * Some parts are modified from https://github.com/forkdelta/smart_contract/blob/master/contracts/ForkDelta.sol
*/

/*
 * This is used as an interface to provide functionality when setting up the contract with ENS.
*/
contract ReverseRegistrar {
    function setName(string memory name) public returns (bytes32);
}

contract Etherclear {
    /*
    * The dictionary is used as an iterable mapping implementation.
    */
    using Dictionary for Dictionary.Data;

    // TODO: think about adding a ERC223 fallback method.

    // NOTE: PaymentClosed has the same signature
    // because we want to look for payments
    // from the latest block backwards, and
    // we want to terminate the search for
    // past events as soon as possible when doing so.
    event PaymentOpened(
        uint txnId,
        uint holdTime,
        uint openTime,
        uint closeTime,
        address token,
        uint sendAmount,
        address indexed sender,
        address indexed recipient,
        bytes codeHash
    );
    event PaymentClosed(
        uint txnId,
        uint holdTime,
        uint openTime,
        uint closeTime,
        address token,
        uint sendAmount,
        address indexed sender,
        address indexed recipient,
        bytes codeHash,
        uint state
    );

    // A Payment starts in the OPEN state.
    // Once it is COMPLETED or CANCELLED, it cannot be changed further.
    enum PaymentState {OPEN, COMPLETED, CANCELLED}

    // A Payment is created each time a sender wants to
    // send an amount to a recipient.
    struct Payment {
        // timestamps are in epoch seconds
        uint holdTime;
        uint paymentOpenTime;
        uint paymentCloseTime;
        // Token contract address, 0 is Ether.
        address token;
        uint sendAmount;
        address payable sender;
        address payable recipient;
        bytes codeHash;
        PaymentState state;
    }

    ReverseRegistrar reverseRegistrar;

    // EIP-712 code uses the examples provided at
    // https://medium.com/metamask/eip712-is-coming-what-to-expect-and-how-to-use-it-bb92fd1a7a26
    // TODO: the salt and verifyingContract still need to be changed.
    struct RetrieveFundsRequest {
        uint txnId;
        address sender;
        address recipient;
        string passphrase;
    }

    // Payments where msg.sender is the recipient.
    mapping(address => Dictionary.Data) recipientPayments;
    // Payments where msg.sender is the sender.
    mapping(address => Dictionary.Data) senderPayments;
    // Payments are looked up with a uint UUID generated within the contract.
    mapping(uint => Payment) allPayments;

    // This contract's owner (gives ability to set fees).
    address payable owner;
    // The fees are represented with a percentage times 1 ether.
    // The baseFee is to cover feeless retrieval
    // The paymentFee is to cover development costs
    uint baseFee;
    uint paymentFee;
    // mapping of token addresses to mapping of account balances (token=0 means Ether)
    mapping(address => mapping(address => uint)) public tokens;

    // NOTE: We do not lock the cancel payment functionality, so that users
    // will still be able to withdraw funds from payments they created.
    // Failsafe to lock the create payments functionality for both ether and tokens.
    bool createPaymentEnabled;
    // Failsafe to lock the retrieval (withdraw) functionality.
    bool retrieveFundsEnabled;

    address constant verifyingContract = 0x1C56346CD2A2Bf3202F771f50d3D14a367B48070;
    bytes32 constant salt = 0xf2d857f4a3edcb9b78b4d503bfe733db1e3f6cdc2b7971ee739626c97e86a558;
    string private constant RETRIEVE_FUNDS_REQUEST_TYPE = "RetrieveFundsRequest(uint256 txnId,address sender,address recipient,string passphrase)";
    string private constant EIP712_DOMAIN_TYPE = "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)";
    bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(
        abi.encodePacked(EIP712_DOMAIN_TYPE)
    );
    bytes32 private constant RETRIEVE_FUNDS_REQUEST_TYPEHASH = keccak256(
        abi.encodePacked(RETRIEVE_FUNDS_REQUEST_TYPE)
    );
    bytes32 private DOMAIN_SEPARATOR;
    uint256 chainId;

    function hashRetrieveFundsRequest(RetrieveFundsRequest memory request)
        private
        view
        returns (bytes32 hash)
    {
        return keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        RETRIEVE_FUNDS_REQUEST_TYPEHASH,
                        request.txnId,
                        request.sender,
                        request.recipient,
                        keccak256(bytes(request.passphrase))
                    )
                )
            )
        );
    }

    function verify(
        address signer,
        RetrieveFundsRequest memory request,
        bytes32 sigR,
        bytes32 sigS,
        uint8 sigV
    ) private view returns (address result) {
        return ecrecover(hashRetrieveFundsRequest(request), sigV, sigR, sigS);
    }

    // Used to test the sign and recover functionality.
    function checkRetrieveSignature(
        uint256 txnId,
        address sender,
        address recipient,
        string memory passphrase,
        bytes32 sigR,
        bytes32 sigS,
        uint8 sigV
    ) public view returns (address result) {
        RetrieveFundsRequest memory request = RetrieveFundsRequest(
            txnId,
            sender,
            recipient,
            passphrase
        );
        address signer = ecrecover(
            hashRetrieveFundsRequest(request),
            sigV,
            sigR,
            sigS
        );
        return verify(recipient, request, sigR, sigS, sigV);
    }

    constructor(uint256 _chainId) public {
        owner = msg.sender;
        baseFee = 0.001 ether;
        paymentFee = 0.005 ether;
        createPaymentEnabled = true;
        retrieveFundsEnabled = true;
        chainId = _chainId;
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                EIP712_DOMAIN_TYPEHASH,
                keccak256("Etherclear"),
                keccak256("1"),
                chainId,
                verifyingContract,
                salt
            )
        );
    }

    function getChainId() public view returns (uint256 networkID) {
        return chainId;
    }

    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only the contract owner is allowed to use this function."
        );
        _;
    }

    /*
    * SetENS sets the name of the reverse record so that it points to this contract address.
    */
    function setENS(address reverseRegistrarAddr, string memory name)
        public
        onlyOwner
    {
        reverseRegistrar = ReverseRegistrar(reverseRegistrarAddr);
        reverseRegistrar.setName(name);

    }

    function withdrawFees(address token) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        // The "owner" account is considered the fee account.
        uint total = tokens[token][owner];
        tokens[token][owner] = 0;
        if (token == address(0)) {
            owner.transfer(total);
        } else {
            require(
                IERC20(token).transfer(owner, total),
                "Could not successfully withdraw token"
            );
        }
    }

    function viewBalance(address token, address user)
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns (uint balance)
    {
        return tokens[token][user];
    }

    // TODO: change this so that the fee can only be decreased
    // (once a suitable starting fee is reached).
    function changeBaseFee(uint newFee) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        baseFee = newFee;
    }
    function changePaymentFee(uint newFee) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        paymentFee = newFee;
    }

    function getBaseFee() public view returns (uint feeAmt) {
        return baseFee;
    }

    function getPaymentFee() public view returns (uint feeAmt) {
        return paymentFee;
    }

    function getPaymentsForSender()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns (uint[] memory result)
    {
        Dictionary.Data storage payments = senderPayments[msg.sender];
        uint[] memory keys = payments.keys();
        return keys;

    }

    function disableRetrieveFunds(bool disabled) public onlyOwner {
        retrieveFundsEnabled = !disabled;
    }

    function disableCreatePayment(bool disabled) public onlyOwner {
        createPaymentEnabled = !disabled;
    }

    function getPaymentsForRecipient()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns (uint[] memory result)
    {
        Dictionary.Data storage payments = recipientPayments[msg.sender];
        uint[] memory keys = payments.keys();
        return keys;
    }

    function getPaymentInfo(uint paymentID)
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns (
        uint holdTime,
        uint paymentOpenTime,
        uint paymentCloseTime,
        address token,
        uint sendAmount,
        address sender,
        address recipient,
        bytes memory codeHash,
        uint state
    )
    {
        Payment memory txn = allPayments[paymentID];
        return (txn.holdTime, txn.paymentOpenTime, txn.paymentCloseTime, txn.token, txn.sendAmount, txn.sender, txn.recipient, txn.codeHash, uint(
            txn.state
        ));
    }

    // TODO: Should the passphrase be needed to cancel the payment?
    // Cancels the payment and returns the funds to the payment's sender.
    function cancelPayment(uint txnId) public {	//inject PUBLIC FUNC TO EXTERNAL
        // Check txn sender and state.
        Payment memory txn = allPayments[txnId];
        require(
            txn.sender == msg.sender,
            "Payment sender does not match message sender."
        );
        require(
            txn.state == PaymentState.OPEN,
            "Payment must be open to cancel."
        );

        // Update txn state.
        txn.paymentCloseTime = now;
        txn.state = PaymentState.CANCELLED;

        delete allPayments[txnId];
        recipientPayments[txn.recipient].remove(txnId);
        senderPayments[txn.sender].remove(txnId);

        // Return funds to sender.
        if (txn.token == address(0)) {
            tokens[address(0)][txn.sender] = SafeMath.sub(
                tokens[address(0)][txn.sender],
                txn.sendAmount
            );
            txn.sender.transfer(txn.sendAmount);
        } else {
            withdrawToken(txn.token, txn.sender, txn.sender, txn.sendAmount);
        }

        emit PaymentClosed(
            txnId,
            txn.holdTime,
            txn.paymentOpenTime,
            txn.paymentCloseTime,
            txn.token,
            txn.sendAmount,
            txn.sender,
            txn.recipient,
            txn.codeHash,
            uint(txn.state)
        );
    }

    /**
* This function handles deposits of ERC-20 tokens to the contract.
* Does not allow Ether.
* If token transfer fails, payment is reverted and remaining gas is refunded.
* Additionally, includes a fee which must be accounted for when approving the amount.
* Note: Remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
* @param token Ethereum contract address of the token or 0 for Ether
* @param originalAmount uint of the amount of the token the user wishes to deposit
* @param feeAmount uint total amount of the fee charged by the contract
*/
    // TODO: this doesn't follow checks-effects-interactions
    // https://solidity.readthedocs.io/en/develop/security-considerations.html?highlight=check%20effects#use-the-checks-effects-interactions-pattern
    function transferToken(
        address token,
        address user,
        uint originalAmount,
        uint feeAmount
    ) internal {
        require(token != address(0));
        // TODO: use depositingTokenFlag in the ERC223 fallback function
        //depositingTokenFlag = true;
        require(
            IERC20(token).transferFrom(
                user,
                address(this),
                SafeMath.add(originalAmount, feeAmount)
            )
        );
        //depositingTokenFlag = false;
        tokens[token][user] = SafeMath.add(
            tokens[token][msg.sender],
            originalAmount
        );
        tokens[token][owner] = SafeMath.add(tokens[token][owner], feeAmount);
    }

    // TODO: Make sure to check if amounts are available
    // We don't increment any balances because the funds are sent
    // outside of the contract.
    function withdrawToken(
        address token,
        address userFrom,
        address userTo,
        uint amount
    ) internal {
        require(token != address(0));
        require(IERC20(token).transfer(userTo, amount));
        tokens[token][userFrom] = SafeMath.sub(tokens[token][userFrom], amount);
    }

    /* This takes ether for the fee amount*/
    // TODO check order of execution.
    function createPayment(
        uint amount,
        address payable recipient,
        uint holdTime,
        bytes calldata codeHash
    ) external payable {
        return createTokenPayment(
            address(0),
            amount,
            recipient,
            holdTime,
            codeHash
        );

    }

    // Meant to be used for the approve() call, since the
    // amount in the ERC20 contract implementation will be
    // overwritten with the amount requested in the next approve().
    // This returns the amount of the token that the
    // contract still holds.
    // TODO: ensure this value will be correct.
    function getBalance(address token) public view returns (uint amt) {	//inject PUBLIC FUNC TO EXTERNAL
        return tokens[token][msg.sender];
    }

    function getPaymentId(address recipient, bytes memory codeHash)
        public
        pure
        returns (uint result)
    {
        bytes memory txnIdBytes = abi.encodePacked(
            keccak256(abi.encodePacked(codeHash, recipient))
        );
        uint txnId = sliceUint(txnIdBytes);
        return txnId;
    }
    // Creates a new payment with the msg.sender as sender.
    // Expected to take a base fee in ETH.
    // Also takes a payment fee in either ETH or the token used,
    // this payment fee is calculated from the original amount.
    // We assume here that an approve() call has already been made for
    // the original amount + payment fee.
    function createTokenPayment(
        address token,
        uint amount,
        address payable recipient,
        uint holdTime,
        bytes memory codeHash
    ) public payable {
        // Check amount and fee, make sure to truncate fee.
        require(createPaymentEnabled, "The create payments functionality is currently disabled");
        uint paymentFeeTotal = uint(
            SafeMath.mul(paymentFee, amount) / (1 ether)
        );
        if (token == address(0)) {
            require(
                msg.value >= (SafeMath.add(
                    SafeMath.add(amount, baseFee),
                    paymentFeeTotal
                )),
                "Message value is not enough to cover amount and fees"
            );
        } else {
            require(
                msg.value >= baseFee,
                "Message value is not enough to cover base fee"
            );
            // We don't check for a minimum when taking the paymentFee here. Since we don't
            // care what the original sent amount was supposed to be, we just take a percentage and
            // subtract that from the sent amount.
        }

        // Get payments for sender.
        Dictionary.Data storage sendertxns = senderPayments[msg.sender];
        // Get payments for recipient
        // TODO: make sure recipient is valid address? How much of this check is performed for you
        Dictionary.Data storage recipienttxns = recipientPayments[recipient];

        // Check payment ID.
        // TODO: should other components be included in the hash? This isn't secure
        // if someone uses a bad codeHash. But they could mess up other components anyway,
        // unless a UUID was generated in the contract, which is expensive.
        uint txnId = getPaymentId(recipient, codeHash);
        // If txnId already exists, don't overwrite.
        require(
            allPayments[txnId].sender == address(0),
            "Payment ID must be unique. Use a different passphrase hash."
        );

        // Add txnId to sender and recipient payment dicts.
        bytes memory val = "\x20";
        sendertxns.set(txnId, val);
        recipienttxns.set(txnId, val);

        // Create payments.
        Payment memory txn = Payment(
            holdTime,
            now,
            0,
            token,
            amount,
            msg.sender,
            recipient,
            codeHash,
            PaymentState.OPEN
        );

        allPayments[txnId] = txn;

        // Take fees; mark ether or token balances.
        if (token == address(0)) {
            // Mark sender's ether balance with the sent amount
            tokens[address(0)][msg.sender] = SafeMath.add(
                tokens[address(0)][msg.sender],
                amount
            );

            // Take baseFee and paymentFee (and any ether sent in the message)
            tokens[address(0)][owner] = SafeMath.add(
                tokens[address(0)][owner],
                SafeMath.sub(msg.value, amount)
            );

        } else {
            // Take baseFee (and any ether sent in the message)
            tokens[address(0)][owner] = SafeMath.add(
                tokens[address(0)][owner],
                msg.value
            );
            // Transfer tokens; mark sender's balance; take paymentFee
            transferToken(token, msg.sender, amount, paymentFeeTotal);
        }

        // TODO: is this the best step to emit events?
        emit PaymentOpened(
            txnId,
            txn.holdTime,
            txn.paymentOpenTime,
            txn.paymentCloseTime,
            txn.token,
            txn.sendAmount,
            txn.sender,
            txn.recipient,
            txn.codeHash
        );

    }

    // Meant to be called by anyone, on behalf of the recipient.
    // Will only work if the correct signature is passed in.
    function retrieveFundsForRecipient(
        uint256 txnId,
        address sender,
        address recipient,
        string memory passphrase,
        bytes32 sigR,
        bytes32 sigS,
        uint8 sigV
    ) public {
        RetrieveFundsRequest memory request = RetrieveFundsRequest(
            txnId,
            sender,
            recipient,
            passphrase
        );
        address signer = ecrecover(
            hashRetrieveFundsRequest(request),
            sigV,
            sigR,
            sigS
        );

        require(
            recipient == signer,
            "The message recipient must be the same as the signer of the message"
        );
        Payment memory txn = allPayments[txnId];
        require(
            txn.recipient == recipient,
            "The payment's recipient must be the same as signer of the message"
        );
        retrieveFunds(txn, txnId, passphrase);
    }

    // Meant to be called by the recipient.
    function retrieveFundsAsRecipient(uint txnId, string memory code) public {
        Payment memory txn = allPayments[txnId];

        // Check recipient
        require(
            txn.recipient == msg.sender,
            "Message sender must match payment recipient"
        );
        retrieveFunds(txn, txnId, code);
    }

    // Sends funds to a payment recipient.
    // Internal ONLY, because it does not do any checks with msg.sender,
    // and leaves that for calling functions.
    // TODO: find a more secure way to implement the recipient check.
    function retrieveFunds(Payment memory txn, uint txnId, string memory code)
        private
    {
    require(retrieveFundsEnabled, "The retrieve funds functionality is currently disabled.");
        require(
            txn.state == PaymentState.OPEN,
            "Payment must be open to retrieve funds"
        );
        // TODO: make sure this is secure.
        bytes memory actualHash = abi.encodePacked(
            keccak256(abi.encodePacked(code, txn.recipient))
        );
    // Check codeHash
    require(
            sliceUint(actualHash) == sliceUint(txn.codeHash),
            "Passphrase is not correct"
        );

        // Check holdTime
        require(
            (txn.paymentOpenTime + txn.holdTime) > now,
            "Hold time has already expired"
        );

        // Update state.
        txn.paymentCloseTime = now;
        txn.state = PaymentState.COMPLETED;

        delete allPayments[txnId];
        recipientPayments[txn.recipient].remove(txnId);
        senderPayments[txn.sender].remove(txnId);

        // Transfer either ether or tokens.
        if (txn.token == address(0)) {
            // Pay out retrieved funds based on payment amount
            // TODO: recipient must be valid!
            txn.recipient.transfer(txn.sendAmount);
            tokens[address(0)][txn.sender] = SafeMath.sub(
                tokens[address(0)][txn.sender],
                txn.sendAmount
            );

        } else {
            withdrawToken(txn.token, txn.sender, txn.recipient, txn.sendAmount);
        }

        emit PaymentClosed(
            txnId,
            txn.holdTime,
            txn.paymentOpenTime,
            txn.paymentCloseTime,
            txn.token,
            txn.sendAmount,
            txn.sender,
            txn.recipient,
            txn.codeHash,
            uint(txn.state)
        );

    }

    // Utility function to go from bytes -> uint
    // This is apparently not reversible.
    function sliceUint(bytes memory bs) public pure returns (uint) {
        uint start = 0;
        if (bs.length < start + 32) {
            return 0;
        }
        uint x;
        assembly {
            x := mload(add(bs, add(0x20, start)))
        }
        return x;
    }

}