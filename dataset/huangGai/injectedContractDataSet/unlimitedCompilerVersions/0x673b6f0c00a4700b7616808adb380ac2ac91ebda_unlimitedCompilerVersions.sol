pragma solidity ^0.5.1;	//inject UNLIMITED COMPILER VERSIONS

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
                require(msg.sender == custodian);
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

contract ServiceRegistry is CustodianUpgradeable {
    mapping (string => address) services;

    event ServiceReplaced(string indexed _name, address _oldAddr, address _newAddr);

    constructor(address _custodian) public CustodianUpgradeable(_custodian) {
    }

    function replaceService(string calldata _name, address _newAddr) external onlyCustodian withContract(_newAddr) {
        address _prevAddr = services[_name];
        services[_name] = _newAddr;
        emit ServiceReplaced(_name, _prevAddr, _newAddr);
    }

    function getService(string memory _name) public view returns (address) {
        return services[_name];
    }

    modifier withContract(address _addr) {
        uint length;
        assembly { length := extcodesize(_addr) }
        require(length > 0);
        _;
    }
}