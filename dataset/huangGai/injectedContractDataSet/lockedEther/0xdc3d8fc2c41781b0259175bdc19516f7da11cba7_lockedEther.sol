pragma solidity ^0.5.7;

library ECDSA {
    /**
     * @dev Recover signer address from a message by using their signature
     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
     * @param signature bytes signature, the signature is generated using web3.eth.sign()
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        // Check the signature length
        if (signature.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }

        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return (address(0));
        } else {
            return ecrecover(hash, v, r, s);
        }
    }

    /**
     * toEthSignedMessageHash
     * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
     * and hash the result
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}

contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract FizzyRoles is Ownable {
    address private _signer;
    address payable private _assetManager;
    address private _oracle;

    event SignershipTransferred(address previousSigner, address newSigner);
    event AssetManagerChanged(address payable previousAssetManager, address payable newAssetManager);
    event OracleChanged(address previousOracle, address newOracle);

    /**
     * @dev Throws if called by any account other than the asset manager.
     */
    modifier onlyAssetManager() {
        require(_assetManager == msg.sender, "Sender is not the asset manager");
        _;
    }

    /**
     * @dev Throws if called by any account other than the oracle.
     */
    modifier onlyOracle() {
        require(_oracle == msg.sender, "Sender is not the oracle");
        _;
    }

    /**
     * @dev The FizzyRoles constructor set the original signer, asset manager and oracle to the creator account.
     */
    constructor () internal {
        _signer = msg.sender;
        _assetManager = msg.sender;
        _oracle = msg.sender;
        emit SignershipTransferred(address(0), _signer);
        emit AssetManagerChanged(address(0), _assetManager);
        emit OracleChanged(address(0), _oracle);
    }

    /**
     * @dev Allows the current owner to transfer the signership to a newSigner.
     * @param newSigner The address to transfer signership to.
     */
    function transferSignership(address newSigner) external onlyOwner {
        require(newSigner != address(0), "newSigner should not be address(0).");
        emit SignershipTransferred(_signer, newSigner);
        _signer = newSigner;
    }

    /**
     * @dev Allows the current owner to change the asset manager to a newManager.
     * @param newManager The address to change asset management to.
     */
    function changeAssetManager(address payable newManager) external onlyOwner {
        require(newManager != address(0), "newManager should not be address(0).");
        emit AssetManagerChanged(_assetManager, newManager);
        _assetManager = newManager;
    }

    /**
     * @dev Allows the current owner to change the oracle to a newOracle.
     * @param newOracle The address to change oracle to.
     */
    function changeOracle(address newOracle) external onlyOwner {
        require(newOracle != address(0), "newOracle should not be address(0).");
        emit OracleChanged(_oracle, newOracle);
        _oracle = newOracle;
    }

    /**
     * @return the address of the signer
     */
    function getSigner() public view returns(address) {
        return _signer;
    }

    /**
     * @return the address of the oracle
     */
    function getOracle() public view returns(address) {
        return _oracle;
    }

    /**
     * @return the address of the asset manager
     */
    function getAssetManager() public view returns(address payable) {
        return _assetManager;
    }
}

contract Fizzy is FizzyRoles {

    /**
     * @dev Possible covered conditions.
     * Each bit of a uint256 match a condition.
     */
    uint256 constant NONE       = 0;
    uint256 constant CANCELLED  = 2**0;
    uint256 constant DIVERTED   = 2**1;
    uint256 constant REDIRECTED = 2**2;
    uint256 constant DELAY      = 2**3;
    uint256 constant MANUAL     = 2**4;

    /**
     * @dev Represents the status of an insurance.
     * - Open: we do not have landing data for the flight
     * - ClosedCompensated: the user received an indemnity and the insurance can not be updated
     * - ClosedNotCompensated: the user did not received an indemnity and the insurance can not be updated
     */
    enum InsuranceStatus {
        Open, ClosedCompensated, ClosedNotCompensated
    }

    /**
     * @dev Structure representing an insurance.
     * @param productId The productId of the insurance.
     * @param premium The premium of the insurance.
     * @param indemnity The indemnity amount sent to the user if one of the conditions of the insurance is fullfilled.
     * @param limitArrivalTime Timestamp in seconds after which the delayCondition (when covered) is triggered when the flight land.
     * @param conditions Flight statuses triggering compensation.
     * @param InsuranceStatus The status of the insurance.
     * @param compensationAddress The indemnity is sent to this address if the insurance has been paid in cryptocurrency and should be compensated.
     */
    struct Insurance {
        uint256         productId;
        uint256         premium;
        uint256         indemnity;
        uint256         limitArrivalTime;
        uint256         conditions;
        InsuranceStatus status;
        address payable compensationAddress;
    }

    /**
     * @dev Mapping of a flightId to an array of insurances.
     */
    mapping(bytes32 => Insurance[]) private insuranceList;

    /**
     * @dev Mapping of a productId to a boolean.
     */
    mapping(uint256 => bool) private boughtProductIds;

    /**
     * @dev Event triggered when an insurance is created.
     * @param flightId The flightId of the insurance. Format: <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
     * @param productId ID string of product linked to the insurance.
     * @param premium Amount of premium paid by the client.
     * @param indemnity Amount (potentially) perceived by the client.
     * @param limitArrivalTime Maximum time after which we trigger the delay compensation (timestamp in sec).
     * @param conditions Flight statuses triggering compensation.
     * @param compensationAddress The indemnity is sent to this address if the insurance has been paid in cryptocurrency and should be compensated.
     */

    event InsuranceCreation(
        bytes32         flightId,
        uint256         productId,
        uint256         premium,
        uint256         indemnity,
        uint256         limitArrivalTime,
        uint256         conditions,
        address payable compensationAddress
    );

    /**
     * @dev Event triggered when an insurance is updated.
     * @param flightId The flightId of the insurance. Format: <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
     * @param productId ID string of product linked to the insurance.
     * @param premium Amount of premium paid by the client.
     * @param indemnity Amount (potentially) perceived by the client.
     * @param triggeredCondition The condition triggered.
     * @param status The new status of the insurance.
     */
    event InsuranceUpdate(
        bytes32         flightId,
        uint256         productId,
        uint256         premium,
        uint256         indemnity,
        uint256         triggeredCondition,
        InsuranceStatus status
    );

    /**
     * @return the count of the insurances.
     */
    function getInsurancesCount(bytes32 flightId) public view returns (uint256) {
        return insuranceList[flightId].length;
    }

    /**
     * @dev Returns the specified insurance.
     * @param flightId The flightId containing the insurance.
     * @param index The index of the insurance in the array of the flight.
     * @return An insurance
     */
    function getInsurance(bytes32 flightId, uint256 index) public view returns (uint256         productId,
                                                                uint256         premium,
                                                                uint256         indemnity,
                                                                uint256         limitArrivalTime,
                                                                uint256         conditions,
                                                                InsuranceStatus status,
                                                                address payable compensationAddress) {
        productId = insuranceList[flightId][index].productId;
        premium = insuranceList[flightId][index].premium;
        indemnity = insuranceList[flightId][index].indemnity;
        limitArrivalTime = insuranceList[flightId][index].limitArrivalTime;
        conditions = insuranceList[flightId][index].conditions;
        status = insuranceList[flightId][index].status;
        compensationAddress = insuranceList[flightId][index].compensationAddress;
    }


    /**
     * @return True if a product is bought, false otherwise.
     */
    function isProductBought(uint256 productId) public view returns (bool) {
        return boughtProductIds[productId];
    }

    /**
    * @dev Allow the owner to add a new insurance for the given flight.
    *       A maximum amount of policies per flight is enforced service side.
    * @param flightId The flightId of the insurance. Format: <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
    * @param productId ID string of product linked to the insurance.
    * @param premium Amount of premium paid by the client.
    * @param indemnity Amount (potentially) perceived by the client.
    * @param limitArrivalTime Maximum time after which we trigger the delay compensation (timestamp in sec).
    * @param conditions Flight statuses triggering compensation.
    */
    function addNewInsurance(
        bytes32 flightId,
        uint256 productId,
        uint256 premium,
        uint256 indemnity,
        uint256 limitArrivalTime,
        uint256 conditions
        ) external onlyOwner {

        _addNewInsurance(flightId, productId, premium, indemnity, limitArrivalTime, conditions, address(0));
    }

    /**
    * @dev Set the actual arrival time of a flight.
    *       Out of gas: a maximum amount of policies per flight is enforced server side.
    * @param flightId <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
    * @param actualArrivalTime The actual arrival time of the flight (timestamp in sec)
    */
    function setFlightLandedAndArrivalTime(
        bytes32 flightId,
        uint256 actualArrivalTime)
        external
        onlyOracle {

        for (uint i = 0; i < insuranceList[flightId].length; i++) {
            Insurance memory insurance = insuranceList[flightId][i];
            if (insurance.status == InsuranceStatus.Open) {
                InsuranceStatus newStatus;
                uint256 triggeredCondition;

                if (_containsCondition(insurance.conditions, DELAY)) {
                    if (actualArrivalTime > insurance.limitArrivalTime) {
                        triggeredCondition = DELAY;
                        newStatus = InsuranceStatus.ClosedCompensated;
                        compensateIfEtherPayment(insurance);
                    } else {
                        triggeredCondition = NONE;
                        newStatus = InsuranceStatus.ClosedNotCompensated;
                        noCompensateIfEtherPayment(insurance);
                    }
                } else {
                    triggeredCondition = NONE;
                    newStatus = InsuranceStatus.ClosedNotCompensated;
                    noCompensateIfEtherPayment(insurance);
                }

                insuranceList[flightId][i].status = newStatus;

                emit InsuranceUpdate(
                    flightId,
                    insurance.productId,
                    insurance.premium,
                    insurance.indemnity,
                    triggeredCondition,
                    newStatus
                    );
            }
        }
    }

    /**
    * @dev Trigger an insurance's condition for a flight.
    *       Out of gas: a maximum amount of policies per flight is enforced server side.
    * @param flightId <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
    * @param conditionToTrigger insurance condition triggered.
    */
    function triggerCondition(
        bytes32 flightId,
        uint256 conditionToTrigger)
        external
        onlyOracle {

        for (uint i = 0; i < insuranceList[flightId].length; i++) {
            Insurance memory insurance = insuranceList[flightId][i];

            if (insurance.status == InsuranceStatus.Open) {
                InsuranceStatus newInsuranceStatus;
                uint256 triggeredCondition;

                if (_containsCondition(insurance.conditions, conditionToTrigger)) {
                    triggeredCondition = conditionToTrigger;
                    newInsuranceStatus = InsuranceStatus.ClosedCompensated;
                    compensateIfEtherPayment(insurance);
                } else {
                    triggeredCondition = NONE;
                    newInsuranceStatus = InsuranceStatus.ClosedNotCompensated;
                    noCompensateIfEtherPayment(insurance);
                }

                insuranceList[flightId][i].status = newInsuranceStatus;

                emit InsuranceUpdate(
                    flightId,
                    insurance.productId,
                    insurance.premium,
                    insurance.indemnity,
                    triggeredCondition,
                    newInsuranceStatus
                    );
            }
        }
    }

    /**
    * @dev Manually resolve an insurance contract
    *       Out of gas: a maximum amount of policies per flight is enforced server side.
    * @param flightId <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
    * @param productId ID string of the product linked to the insurance.
    * @param newStatus ID of the resolution status for this insurance contract.
    */
    function manualInsuranceResolution(
        bytes32 flightId,
        uint256 productId,
        InsuranceStatus newStatus
    )
        external
        onlyOwner {
        require(newStatus == InsuranceStatus.ClosedCompensated || newStatus == InsuranceStatus.ClosedNotCompensated,
                "Insurance already compensated.");

        for (uint i = 0; i < insuranceList[flightId].length; i++) {
            Insurance memory insurance = insuranceList[flightId][i];
            if (insurance.status == InsuranceStatus.Open && insurance.productId == productId) {
                if (newStatus == InsuranceStatus.ClosedCompensated) {
                    compensateIfEtherPayment(insurance);
                } else if (newStatus == InsuranceStatus.ClosedNotCompensated) {
                    noCompensateIfEtherPayment(insurance);
                }

                insuranceList[flightId][i].status = newStatus;

                emit InsuranceUpdate(
                    flightId,
                    insurance.productId,
                    insurance.premium,
                    insurance.indemnity,
                    MANUAL,
                    newStatus
                    );
            }
        }
    }

    function _addNewInsurance (
        bytes32 flightId,
        uint256 productId,
        uint256 premium,
        uint256 indemnity,
        uint256  limitArrivalTime,
        uint256 conditions,
        address payable compensationAddress
    ) internal {

        require(boughtProductIds[productId] == false, "This product has already been bought.");

        Insurance memory newInsurance;
        newInsurance.productId = productId;
        newInsurance.premium = premium;
        newInsurance.indemnity = indemnity;
        newInsurance.limitArrivalTime = limitArrivalTime;
        newInsurance.conditions = conditions;
        newInsurance.status = InsuranceStatus.Open;
        newInsurance.compensationAddress = compensationAddress;

        insuranceList[flightId].push(newInsurance);

        boughtProductIds[productId] = true;

        emit InsuranceCreation(flightId, productId, premium, indemnity, limitArrivalTime, conditions, compensationAddress);
    }

    function _compensate(address payable to, uint256 amount, uint256 productId) internal returns (bool success);
    function _noCompensate(uint256 amount) internal returns (bool success);

    /**
     * @dev Compensate the customer if the compensation address is different from address(0).
     * @param insurance Insurance to compensate.
     */
    function compensateIfEtherPayment(Insurance memory insurance) private {
        if (insurance.compensationAddress != address(0)) {
            _compensate(insurance.compensationAddress, insurance.indemnity, insurance.productId);
        }
    }

    /**
     * @dev Do not compensate the insurance. Add indemnity to available exposure.
     * @param insurance Closed insurance which will not be compensated.
     */
    function noCompensateIfEtherPayment(Insurance memory insurance) private {
        if (insurance.compensationAddress != address(0)) {
            _noCompensate(insurance.indemnity);
        }
    }

    /**
     * @dev Check if the conditions covered by the insurance includes the specified condition.
     * @param a All the conditions covered by the insurance.
     * @param b Single condition to check.
     * @return True if the condition to check is included in the covered conditions, false otherwise.
     */
    function _containsCondition(uint256 a, uint256 b) private pure returns (bool) {
        return (a & b) != 0;
    }
}

contract FizzyCrypto is Fizzy {

    uint256 private _availableExposure;
    uint256 private _collectedTaxes;

    event EtherCompensation(uint256 amount, address to, uint256 productId);
    event EtherCompensationError(uint256 amount, address to, uint256 productId);

    /**
    * @dev Throws if called with a timestampLimit greater than the block timestamp.
    * @param timestampLimit Timestamp to compare to the block timestamp.
    */
    modifier beforeTimestampLimit(uint256 timestampLimit) {
        require(timestampLimit >= now, "The transaction is invalid: the timestamp limit has been reached.");
        _;
    }

    /**
    * @dev Throws if called with an amount greater than the available exposure.
    * @param amount Amount to compare to the available exposure.
    */
    modifier enoughExposure(uint256 amount) {
        require(_availableExposure >= amount, "Available exposure can not be reached");
        _;
    }

    /**
    * @dev Throws if called with an amount greater than the collected taxes.
    * @param amount Amount to compare to the collected taxes.
    */
    modifier enoughTaxes(uint256 amount) {
        require(_collectedTaxes >= amount, "Cannot withdraw more taxes than all collected taxes");
        _;
    }

    /**
    * @dev Allows the asset manager to deposit ether on the smart contract.
    */
    function deposit() external payable onlyAssetManager {	//injected LOCKED ETHER
        _availableExposure = _availableExposure + msg.value;
    }

    /**
    * @dev Allows the asset manager to withdraw ether from the smart contract.
    * @param amount Amount of ether to withdraw. Can not be greater than the available exposure.
    */
    function withdraw(uint256 amount) external onlyAssetManager enoughExposure(amount) {
        _availableExposure = _availableExposure - amount;
        msg.sender.transfer(0);
    }

    /**
    * @dev Allows the asset manager to withdraw taxes from the smart contract.
    * @param amount Amount of taxes to withdraw. Can not be greater than the available taxes.
    */
    function withdrawTaxes(uint256 amount) external onlyAssetManager enoughTaxes(amount) {
        _collectedTaxes = _collectedTaxes - amount;
        msg.sender.transfer(0);
    }

    /**
    * @dev Allows a customer to buy an insurance with ether.
    *       There is currently a maximum of 10 insurances available for each flight. It is enforced server side.
    * @param flightId The flightId of the insurance. Format: <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
    * @param productId ID string of product linked to the insurance.
    * @param premium Amount of premium paid by the client.
    * @param indemnity Amount (potentially) perceived by the client.
    * @param taxes Taxes included in the premium.
    * @param limitArrivalTime Maximum time after which we trigger the delay compensation (timestamp in sec).
    * @param conditions Flight statuses triggering compensation.
    * @param timestampLimit Maximum timestamp to accept the transaction.
    * @param buyerAddress Address of the buyer.
    * @param signature Signature of the parameters.
    */
    function buyInsurance(	//injected LOCKED ETHER
        bytes32        flightId,
        uint256        productId,
        uint256        premium,
        uint256        indemnity,
        uint256        taxes,
        uint256        limitArrivalTime,
        uint256        conditions,
        uint256        timestampLimit,
        address        buyerAddress,
        bytes calldata signature
    )
        external
        payable
        beforeTimestampLimit(timestampLimit)
        enoughExposure(indemnity)
    {
        _checkSignature(flightId, productId, premium, indemnity, taxes, limitArrivalTime, conditions, timestampLimit, buyerAddress, signature);

        require(buyerAddress == msg.sender, "Wrong buyer address.");
        require(premium >= taxes, "The taxes must be included in the premium.");
        require(premium == msg.value, "The amount sent does not match the price of the order.");

        _addNewInsurance(flightId, productId, premium, indemnity, limitArrivalTime, conditions, msg.sender);

        _availableExposure = _availableExposure + premium - taxes - indemnity;
        _collectedTaxes = _collectedTaxes + taxes;
    }

    /**
     * @return The available exposure.
     */
    function availableExposure() external view returns(uint256) {
        return _availableExposure;
    }

    /**
    * @return The collected taxes.
    */
    function collectedTaxes() external view returns(uint256) {
        return _collectedTaxes;
    }

    /**
     * @dev Sends an indemnity to a user.
     * @param to The ethereum address of the user.
     * @param amount The amount of ether to send to the user.
     * @param productId The productId of the insurance.
     */
    function _compensate(address payable to, uint256 amount, uint256 productId) internal returns (bool) {
        if(to.send(0)) {
            emit EtherCompensation(amount, to, productId);
            return true;
        } else {
            getAssetManager().transfer(0);
            emit EtherCompensationError(amount, to, productId);
            return false;
        }
    }

    /**
    * @dev Add the indemnity amount of an insurance to the available exposure.
    *       Called when no condition of the insurance was triggered.
    * @param amount Amount of the indemnity which will be added to the available exposure.
    */
    function _noCompensate(uint256 amount) internal returns (bool) {
        _availableExposure = _availableExposure + amount;
        return true;
    }

    /**
    * @dev Check the signature of the parameters. Throws if the decyphered address is not equals to the signer address.
    * @param flightId The flightId of the insurance. Format: <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
    * @param productId ID string of product linked to the insurance.
    * @param premium Amount of premium paid by the client.
    * @param indemnity Amount (potentially) perceived by the client.
    * @param taxes Taxes included in the premium.
    * @param limitArrivalTime Maximum time after which we trigger the delay compensation (timestamp in sec).
    * @param conditions Flight statuses triggering compensation.
    * @param timestampLimit Maximum timestamp to accept the transaction.
    * @param buyerAddress Address of the buyer.
    * @param signature Signature of the parameters.
    */
    function _checkSignature(
        bytes32 flightId,
        uint256 productId,
        uint256 premium,
        uint256 indemnity,
        uint256 taxes,
        uint256 limitArrivalTime,
        uint256 conditions,
        uint256 timestampLimit,
        address buyerAddress,
        bytes memory signature
    ) private view {

        bytes32 messageHash = keccak256(abi.encodePacked(
            flightId,
            productId,
            premium,
            indemnity,
            taxes,
            limitArrivalTime,
            conditions,
            timestampLimit,
            buyerAddress
        ));

        address decypheredAddress = ECDSA.recover(ECDSA.toEthSignedMessageHash(messageHash), signature);
        require(decypheredAddress == getSigner(), "The signature is invalid if it does not match the _signer address.");
    }
}