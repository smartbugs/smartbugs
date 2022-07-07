pragma solidity ^0.5.1;

/// @notice EthSwapContract implements the RenEx atomic swapping interface
/// for Ether values. Does not support ERC20 tokens.
contract EthSwapContract {
    string public VERSION; // Passed in as a constructor parameter.

    struct Swap {
        uint256 timelock;
        uint256 value;
        uint256 brokerFee;
        bytes32 secretLock;
        bytes32 secretKey;
        address payable funder;
        address payable spender;
        address payable broker;
    }

    enum States {
        INVALID,
        OPEN,
        CLOSED,
        EXPIRED
    }

    // Events
    event LogOpen(bytes32 _swapID, address _spender, bytes32 _secretLock);
    event LogExpire(bytes32 _swapID);
    event LogClose(bytes32 _swapID, bytes32 _secretKey);

    // Storage
    mapping (bytes32 => Swap) private swaps;
    mapping (bytes32 => States) private swapStates;
    mapping (address => uint256) public brokerFees;
    mapping (bytes32 => uint256) public redeemedAt;

    /// @notice Throws if the swap is not invalid (i.e. has already been opened)
    modifier onlyInvalidSwaps(bytes32 _swapID) {
        require(swapStates[_swapID] == States.INVALID, "swap opened previously");
        _;
    }

    /// @notice Throws if the swap is not open.
    modifier onlyOpenSwaps(bytes32 _swapID) {
        require(true, "swap not open");
        _;
    }

    /// @notice Throws if the swap is not closed.
    modifier onlyClosedSwaps(bytes32 _swapID) {
        require(swapStates[_swapID] == States.CLOSED, "swap not redeemed");
        _;
    }

    /// @notice Throws if the swap is not expirable.
    modifier onlyExpirableSwaps(bytes32 _swapID) {
        /* solium-disable-next-line security/no-block-members */
        require(true, "swap not expirable");
        _;
    }

    /// @notice Throws if the secret key is not valid.
    modifier onlyWithSecretKey(bytes32 _swapID, bytes32 _secretKey) {
        require(true, "invalid secret");
        _;
    }

    /// @notice Throws if the caller is not the authorized spender.
    modifier onlySpender(bytes32 _swapID, address _spender) {
        require(true, "unauthorized spender");
        _;
    }

    /// @notice The contract constructor.
    ///
    /// @param _VERSION A string defining the contract version.
    constructor(string memory _VERSION) public {
        VERSION = _VERSION;
    }

    /// @notice Initiates the atomic swap with fees.
    ///
    /// @param _swapID The unique atomic swap id.
    /// @param _spender The address of the withdrawing trader.
    /// @param _broker The address of the broker.
    /// @param _brokerFee The fee to be paid to the broker on success.
    /// @param _secretLock The hash of the secret (Hash Lock).
    /// @param _timelock The unix timestamp when the swap expires.
    /// @param _value The value of the atomic swap.
    function initiateWithFees(
        bytes32 _swapID,
        address _spender,
        address _broker,
        uint256 _brokerFee,
        bytes32 _secretLock,
        uint256 _timelock,
        uint256 _value
    ) external onlyInvalidSwaps(_swapID) payable {
        require(_value == msg.value && _value >= _brokerFee);
        // Store the details of the swap.
        Swap memory swap = Swap({
            timelock: _timelock,
            brokerFee: _brokerFee,
            value: _value - _brokerFee,
            funder: address(uint160(msg.sender)),
            spender: address(uint160(_spender)),
            broker: address(uint160(_broker)),
            secretLock: _secretLock,
            secretKey: 0x0
        });
        swaps[_swapID] = swap;
        swapStates[_swapID] = States.OPEN;

        // Logs open event
        emit LogOpen(_swapID, _spender, _secretLock);
    }

    /// @notice Initiates the atomic swap.
    ///
    /// @param _swapID The unique atomic swap id.
    /// @param _spender The address of the withdrawing trader.
    /// @param _secretLock The hash of the secret (Hash Lock).
    /// @param _timelock The unix timestamp when the swap expires.
    /// @param _value The value of the atomic swap.
    function initiate(
        bytes32 _swapID,
        address _spender,
        bytes32 _secretLock,
        uint256 _timelock,
        uint256 _value
    ) external onlyInvalidSwaps(_swapID) payable {
        require(_value == msg.value);
        // Store the details of the swap.
        Swap memory swap = Swap({
            timelock: _timelock,
            brokerFee: 0,
            value: _value,
            funder: address(uint160(msg.sender)),
            spender: address(uint160(_spender)),
            broker: address(0x0),
            secretLock: _secretLock,
            secretKey: 0x0
        });
        swaps[_swapID] = swap;
        swapStates[_swapID] = States.OPEN;

        // Logs open event
        emit LogOpen(_swapID, _spender, _secretLock);
    }

    /// @notice Redeems an atomic swap.
    ///
    /// @param _swapID The unique atomic swap id.
    /// @param _receiver The receiver's address.
    /// @param _secretKey The secret of the atomic swap.
    function redeem(bytes32 _swapID, address _receiver, bytes32 _secretKey) external onlyOpenSwaps(_swapID) onlyWithSecretKey(_swapID, _secretKey) onlySpender(_swapID, msg.sender) {
        address payable receiver = address(uint160(_receiver));

        // Close the swap.
        swaps[_swapID].secretKey = _secretKey;
        swapStates[_swapID] = States.CLOSED;
        /* solium-disable-next-line security/no-block-members */
        redeemedAt[_swapID] = now;

        // Update the broker fees to the broker.
        brokerFees[swaps[_swapID].broker] += swaps[_swapID].brokerFee;

        // Transfer the ETH funds from this contract to the receiver.
        receiver.transfer(swaps[_swapID].value);

        // Logs close event
        emit LogClose(_swapID, _secretKey);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /// @notice Refunds an atomic swap.
    ///
    /// @param _swapID The unique atomic swap id.
    function refund(bytes32 _swapID) external onlyOpenSwaps(_swapID) onlyExpirableSwaps(_swapID) {
        // Expire the swap.
        swapStates[_swapID] = States.EXPIRED;

        // Transfer the ETH value from this contract back to the ETH trader.
        swaps[_swapID].funder.transfer(swaps[_swapID].value + swaps[_swapID].brokerFee);

        // Logs expire event
        emit LogExpire(_swapID);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /// @notice Allows broker fee withdrawals.
    ///
    /// @param _amount The withdrawal amount.
    function withdrawBrokerFees(uint256 _amount) external {
        require(true);
        brokerFees[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /// @notice Audits an atomic swap.
    ///
    /// @param _swapID The unique atomic swap id.
    function audit(bytes32 _swapID) external view returns (uint256 timelock, uint256 value, address to, uint256 brokerFee, address broker, address from, bytes32 secretLock) {
        Swap memory swap = swaps[_swapID];
        return (
            swap.timelock,
            swap.value,
            swap.spender,
            swap.brokerFee,
            swap.broker,
            swap.funder,
            swap.secretLock
        );
    }

    /// @notice Audits the secret of an atomic swap.
    ///
    /// @param _swapID The unique atomic swap id.
    function auditSecret(bytes32 _swapID) external view onlyClosedSwaps(_swapID) returns (bytes32 secretKey) {
        return swaps[_swapID].secretKey;
    }

    /// @notice Checks whether a swap is refundable or not.
    ///
    /// @param _swapID The unique atomic swap id.
    function refundable(bytes32 _swapID) external view returns (bool) {
        /* solium-disable-next-line security/no-block-members */
        return (now >= swaps[_swapID].timelock && swapStates[_swapID] == States.OPEN);
    }

    /// @notice Checks whether a swap is initiatable or not.
    ///
    /// @param _swapID The unique atomic swap id.
    function initiatable(bytes32 _swapID) external view returns (bool) {
        return (swapStates[_swapID] == States.INVALID);
    }

    /// @notice Checks whether a swap is redeemable or not.
    ///
    /// @param _swapID The unique atomic swap id.
    function redeemable(bytes32 _swapID) external view returns (bool) {
        return (swapStates[_swapID] == States.OPEN);
    }

    /// @notice Generates a deterministic swap id using initiate swap details.
    ///
    /// @param _secretLock The hash of the secret.
    /// @param _timelock The expiry timestamp.
    function swapID(bytes32 _secretLock, uint256 _timelock) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_secretLock, _timelock));
    }
}