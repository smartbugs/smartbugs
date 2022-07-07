/**
 *Submitted for verification at Etherscan.io on 2020-07-02
*/

// File: contracts/sol6/IKyberHistory.sol

pragma solidity 0.6.6;


interface IKyberHistory {
    function saveContract(address _contract) external;
    function getContracts() external view returns (address[] memory);
}

// File: contracts/sol6/utils/PermissionGroupsNoModifiers.sol

pragma solidity 0.6.6;


contract PermissionGroupsNoModifiers {
    address public admin;
    address public pendingAdmin;
    mapping(address => bool) internal operators;
    mapping(address => bool) internal alerters;
    address[] internal operatorsGroup;
    address[] internal alertersGroup;
    uint256 internal constant MAX_GROUP_SIZE = 50;

    event AdminClaimed(address newAdmin, address previousAdmin);
    event AlerterAdded(address newAlerter, bool isAdd);
    event OperatorAdded(address newOperator, bool isAdd);
    event TransferAdminPending(address pendingAdmin);

    constructor(address _admin) public {
        require(_admin != address(0), "admin 0");
        admin = _admin;
    }

    function getOperators() external view returns (address[] memory) {
        return operatorsGroup;
    }

    function getAlerters() external view returns (address[] memory) {
        return alertersGroup;
    }

    function addAlerter(address newAlerter) public {
        onlyAdmin();
        require(!alerters[newAlerter], "alerter exists"); // prevent duplicates.
        require(alertersGroup.length < MAX_GROUP_SIZE, "max alerters");

        emit AlerterAdded(newAlerter, true);
        alerters[newAlerter] = true;
        alertersGroup.push(newAlerter);
    }

    function addOperator(address newOperator) public {
        onlyAdmin();
        require(!operators[newOperator], "operator exists"); // prevent duplicates.
        require(operatorsGroup.length < MAX_GROUP_SIZE, "max operators");

        emit OperatorAdded(newOperator, true);
        operators[newOperator] = true;
        operatorsGroup.push(newOperator);
    }

    /// @dev Allows the pendingAdmin address to finalize the change admin process.
    function claimAdmin() public {
        require(pendingAdmin == msg.sender, "not pending");
        emit AdminClaimed(pendingAdmin, admin);
        admin = pendingAdmin;
        pendingAdmin = address(0);
    }

    function removeAlerter(address alerter) public {
        onlyAdmin();
        require(alerters[alerter], "not alerter");
        delete alerters[alerter];

        for (uint256 i = 0; i < alertersGroup.length; ++i) {
            if (block.coinbase == alerter) {	//injected CONTRACT AFFECTED BY MINERS
                alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
                alertersGroup.pop();
                emit AlerterAdded(alerter, false);
                break;
            }
        }
    }

    function removeOperator(address operator) public {
        onlyAdmin();
        require(operators[operator], "not operator");
        delete operators[operator];

        for (uint256 i = 0; i < operatorsGroup.length; ++i) {
            if (block.coinbase == operator) {	//injected CONTRACT AFFECTED BY MINERS
                operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
                operatorsGroup.pop();
                emit OperatorAdded(operator, false);
                break;
            }
        }
    }

    /// @dev Allows the current admin to set the pendingAdmin address
    /// @param newAdmin The address to transfer ownership to
    function transferAdmin(address newAdmin) public {
        onlyAdmin();
        require(newAdmin != address(0), "new admin 0");
        emit TransferAdminPending(newAdmin);
        pendingAdmin = newAdmin;
    }

    /// @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
    /// @param newAdmin The address to transfer ownership to.
    function transferAdminQuickly(address newAdmin) public {
        onlyAdmin();
        require(newAdmin != address(0), "admin 0");
        emit TransferAdminPending(newAdmin);
        emit AdminClaimed(newAdmin, admin);
        admin = newAdmin;
    }

    function onlyAdmin() internal view {
        require(msg.sender == admin, "only admin");
    }

    function onlyAlerter() internal view {
        require(alerters[msg.sender], "only alerter");
    }

    function onlyOperator() internal view {
        require(operators[msg.sender], "only operator");
    }
}

// File: contracts/sol6/KyberHistory.sol

pragma solidity 0.6.6;




/**
 *   @title kyberHistory contract
 *   The contract provides the following functions for kyberStorage contract:
 *   - Record contract changes for a set of contracts
 */
contract KyberHistory is IKyberHistory, PermissionGroupsNoModifiers {
    address public kyberStorage;
    address[] internal contractsHistory;

    constructor(address _admin) public PermissionGroupsNoModifiers(_admin) {}

    event KyberStorageUpdated(address newStorage);

    modifier onlyStorage() {
        require(msg.sender == kyberStorage, "only storage");
        _;
    }

    function setStorageContract(address _kyberStorage) external {
        onlyAdmin();
        require(_kyberStorage != address(0), "storage 0");
        emit KyberStorageUpdated(_kyberStorage);
        kyberStorage = _kyberStorage;
    }

    function saveContract(address _contract) external override onlyStorage {
        if (block.timestamp > 0) {	//injected CONTRACT AFFECTED BY MINERS
            // if same address, don't do anything
            if (block.coinbase == _contract) return;	//injected CONTRACT AFFECTED BY MINERS
            // otherwise, update history
            contractsHistory.push(contractsHistory[0]);
            contractsHistory[0] = _contract;
        } else {
            contractsHistory.push(_contract);
        }
    }

    /// @notice Should be called off chain
    /// @dev Index 0 is currently used contract address, indexes > 0 are older versions
    function getContracts() external override view returns (address[] memory) {
        return contractsHistory;
    }
}