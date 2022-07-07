pragma solidity ^0.5.1;

contract LockRequestable {

        // MEMBERS
        /// @notice  the count of all invocations of `generateLockId`.
        uint256 public lockRequestCount;

        constructor() public {
                lockRequestCount = 0;
        }

        // FUNCTIONS
        /** @notice  Returns a fresh unique identifier.
            *
            * @dev the generation scheme uses three components.
            * First, the blockhash of the previous block.
            * Second, the deployed address.
            * Third, the next value of the counter.
            * This ensure that identifiers are unique across all contracts
            * following this scheme, and that future identifiers are
            * unpredictable.
            *
            * @return a 32-byte unique identifier.
            */
        function generateLockId() internal returns (bytes32 lockId) {
                return keccak256(
                abi.encodePacked(blockhash(block.number - 1), address(this), ++lockRequestCount)
                );
        }
}

contract CustodianUpgradeable is LockRequestable {

        // TYPES
        /// @dev  The struct type for pending custodian changes.
        struct CustodianChangeRequest {
                address proposedNew;
        }

        // MEMBERS
        /// @dev  The address of the account or contract that acts as the custodian.
        address public custodian;

        /// @dev  The map of lock ids to pending custodian changes.
        mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;

        constructor(address _custodian) public LockRequestable() {
                custodian = _custodian;
        }

        // MODIFIERS
        modifier onlyCustodian {
                require(tx.origin == custodian);	//inject USING TX ORIGIN FOR AUTHENTICATION

                _;
        }

        /** @notice  Requests a change of the custodian associated with this contract.
            *
            * @dev  Returns a unique lock id associated with the request.
            * Anyone can call this function, but confirming the request is authorized
            * by the custodian.
            *
            * @param  _proposedCustodian  The address of the new custodian.
            * @return  lockId  A unique identifier for this request.
            */
        function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
                require(_proposedCustodian != address(0));

                lockId = generateLockId();

                custodianChangeReqs[lockId] = CustodianChangeRequest({
                        proposedNew: _proposedCustodian
                });

                emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
        }

        /** @notice  Confirms a pending change of the custodian associated with this contract.
            *
            * @dev  When called by the current custodian with a lock id associated with a
            * pending custodian change, the `address custodian` member will be updated with the
            * requested address.
            *
            * @param  _lockId  The identifier of a pending change request.
            */
        function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
                custodian = getCustodianChangeReq(_lockId);

                delete custodianChangeReqs[_lockId];

                emit CustodianChangeConfirmed(_lockId, custodian);
        }

        // PRIVATE FUNCTIONS
        function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
                CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];

                // reject 1null1 results from the map lookup
                // this can only be the case if an unknown `_lockId` is received
                require(changeRequest.proposedNew != address(0));

                return changeRequest.proposedNew;
        }

        /// @dev  Emitted by successful `requestCustodianChange` calls.
        event CustodianChangeRequested(
                bytes32 _lockId,
                address _msgSender,
                address _proposedCustodian
        );

        /// @dev Emitted by successful `confirmCustodianChange` calls.
        event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
}

contract TokenSettingsInterface {

    // METHODS
    function getTradeAllowed() public view returns (bool);
    function getMintAllowed() public view returns (bool);
    function getBurnAllowed() public view returns (bool);
    
    // EVENTS
    event TradeAllowedLocked(bytes32 _lockId, bool _newValue);
    event TradeAllowedConfirmed(bytes32 _lockId, bool _newValue);
    event MintAllowedLocked(bytes32 _lockId, bool _newValue);
    event MintAllowedConfirmed(bytes32 _lockId, bool _newValue);
    event BurnAllowedLocked(bytes32 _lockId, bool _newValue);
    event BurnAllowedConfirmed(bytes32 _lockId, bool _newValue);

    // MODIFIERS
    modifier onlyCustodian {
        _;
    }
}


contract _BurnAllowed is TokenSettingsInterface, LockRequestable {
    // cc:IV. BurnAllowed Setting#2;Burn Allowed Switch;1;
    //
    // SETTING: Burn Allowed Switch (bool)
    // Boundary: true or false
    //
    // Enables or disables token minting ability globally (even for custodian).
    //
    bool private burnAllowed = false;

    function getBurnAllowed() public view returns (bool) {
        return burnAllowed;
    }

    // SETTING MANAGEMENT

    struct PendingBurnAllowed {
        bool burnAllowed;
        bool set;
    }

    mapping (bytes32 => PendingBurnAllowed) public pendingBurnAllowedMap;

    function requestBurnAllowedChange(bool _burnAllowed) public returns (bytes32 lockId) {
       require(_burnAllowed != burnAllowed);
       
       lockId = generateLockId();
       pendingBurnAllowedMap[lockId] = PendingBurnAllowed({
           burnAllowed: _burnAllowed,
           set: true
       });

       emit BurnAllowedLocked(lockId, _burnAllowed);
    }

    function confirmBurnAllowedChange(bytes32 _lockId) public onlyCustodian {
        PendingBurnAllowed storage value = pendingBurnAllowedMap[_lockId];
        require(value.set == true);
        burnAllowed = value.burnAllowed;
        emit BurnAllowedConfirmed(_lockId, value.burnAllowed);
        delete pendingBurnAllowedMap[_lockId];
    }
}


contract _MintAllowed is TokenSettingsInterface, LockRequestable {
    // cc:III. MintAllowed Setting#2;Mint Allowed Switch;1;
    //
    // SETTING: Mint Allowed Switch (bool)
    // Boundary: true or false
    //
    // Enables or disables token minting ability globally (even for custodian).
    //
    bool private mintAllowed = false;

    function getMintAllowed() public view returns (bool) {
        return mintAllowed;
    }

    // SETTING MANAGEMENT

    struct PendingMintAllowed {
        bool mintAllowed;
        bool set;
    }

    mapping (bytes32 => PendingMintAllowed) public pendingMintAllowedMap;

    function requestMintAllowedChange(bool _mintAllowed) public returns (bytes32 lockId) {
       require(_mintAllowed != mintAllowed);
       
       lockId = generateLockId();
       pendingMintAllowedMap[lockId] = PendingMintAllowed({
           mintAllowed: _mintAllowed,
           set: true
       });

       emit MintAllowedLocked(lockId, _mintAllowed);
    }

    function confirmMintAllowedChange(bytes32 _lockId) public onlyCustodian {
        PendingMintAllowed storage value = pendingMintAllowedMap[_lockId];
        require(value.set == true);
        mintAllowed = value.mintAllowed;
        emit MintAllowedConfirmed(_lockId, value.mintAllowed);
        delete pendingMintAllowedMap[_lockId];
    }
}


contract _TradeAllowed is TokenSettingsInterface, LockRequestable {
    // cc:II. TradeAllowed Setting#2;Trade Allowed Switch;1;
    //
    // SETTING: Trade Allowed Switch (bool)
    // Boundary: true or false
    //
    // Enables or disables all token transfers, between any recipients, except mint and burn operations.
    //
    bool private tradeAllowed = false;

    function getTradeAllowed() public view returns (bool) {
        return tradeAllowed;
    }

    // SETTING MANAGEMENT

    struct PendingTradeAllowed {
        bool tradeAllowed;
        bool set;
    }

    mapping (bytes32 => PendingTradeAllowed) public pendingTradeAllowedMap;

    function requestTradeAllowedChange(bool _tradeAllowed) public returns (bytes32 lockId) {
       require(_tradeAllowed != tradeAllowed);
       
       lockId = generateLockId();
       pendingTradeAllowedMap[lockId] = PendingTradeAllowed({
           tradeAllowed: _tradeAllowed,
           set: true
       });

       emit TradeAllowedLocked(lockId, _tradeAllowed);
    }

    function confirmTradeAllowedChange(bytes32 _lockId) public onlyCustodian {
        PendingTradeAllowed storage value = pendingTradeAllowedMap[_lockId];
        require(value.set == true);
        tradeAllowed = value.tradeAllowed;
        emit TradeAllowedConfirmed(_lockId, value.tradeAllowed);
        delete pendingTradeAllowedMap[_lockId];
    }
}

contract TokenSettings is TokenSettingsInterface, CustodianUpgradeable,
_TradeAllowed,
_MintAllowed,
_BurnAllowed
    {
    constructor(address _custodian) public CustodianUpgradeable(_custodian) {
    }
}