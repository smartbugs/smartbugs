/**
 *Submitted for verification at Etherscan.io on 2020-10-09
*/

// File: contracts/IEpochUtils.sol

pragma solidity 0.6.6;

interface IEpochUtils {
    function epochPeriodInSeconds() external view returns (uint256);

    function firstEpochStartTimestamp() external view returns (uint256);

    function getCurrentEpochNumber() external view returns (uint256);

    function getEpochNumber(uint256 timestamp) external view returns (uint256);
}

// File: contracts/IKyberDao.sol

pragma solidity 0.6.6;



interface IKyberDao is IEpochUtils {
    event Voted(address indexed staker, uint indexed epoch, uint indexed campaignID, uint option);

    function getLatestNetworkFeeDataWithCache()
        external
        returns (uint256 feeInBps, uint256 expiryTimestamp);

    function getLatestBRRDataWithCache()
        external
        returns (
            uint256 burnInBps,
            uint256 rewardInBps,
            uint256 rebateInBps,
            uint256 epoch,
            uint256 expiryTimestamp
        );

    function handleWithdrawal(address staker, uint256 penaltyAmount) external;

    function vote(uint256 campaignID, uint256 option) external;

    function getLatestNetworkFeeData()
        external
        view
        returns (uint256 feeInBps, uint256 expiryTimestamp);

    function shouldBurnRewardForEpoch(uint256 epoch) external view returns (bool);

    /**
     * @dev  return staker's reward percentage in precision for a past epoch only
     *       fee handler should call this function when a staker wants to claim reward
     *       return 0 if staker has no votes or stakes
     */
    function getPastEpochRewardPercentageInPrecision(address staker, uint256 epoch)
        external
        view
        returns (uint256);

    /**
     * @dev  return staker's reward percentage in precision for the current epoch
     *       reward percentage is not finalized until the current epoch is ended
     */
    function getCurrentEpochRewardPercentageInPrecision(address staker)
        external
        view
        returns (uint256);
}

// File: @kyber.network/utils-sc/contracts/IERC20.sol

pragma solidity 0.6.6;


interface IERC20 {
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function transfer(address _to, uint256 _value) external returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function decimals() external view returns (uint8 digits);

    function totalSupply() external view returns (uint256 supply);
}


// to support backward compatible contract name -- so function signature remains same
abstract contract ERC20 is IERC20 {

}

// File: contracts/IERC20.sol

pragma solidity 0.6.6;

// File: contracts/IKyberFeeHandler.sol

pragma solidity 0.6.6;



interface IKyberFeeHandler {
    event RewardPaid(address indexed staker, uint256 indexed epoch, IERC20 indexed token, uint256 amount);
    event RebatePaid(address indexed rebateWallet, IERC20 indexed token, uint256 amount);
    event PlatformFeePaid(address indexed platformWallet, IERC20 indexed token, uint256 amount);
    event KncBurned(uint256 kncTWei, IERC20 indexed token, uint256 amount);

    function handleFees(
        IERC20 token,
        address[] calldata eligibleWallets,
        uint256[] calldata rebatePercentages,
        address platformWallet,
        uint256 platformFee,
        uint256 networkFee
    ) external payable;

    function claimReserveRebate(address rebateWallet) external returns (uint256);

    function claimPlatformFee(address platformWallet) external returns (uint256);

    function claimStakerReward(
        address staker,
        uint256 epoch
    ) external returns(uint amount);
}

// File: contracts/wrappers/IMultipleEpochRewardsClaimer.sol

pragma solidity 0.6.6;


interface IFeeHandler is IKyberFeeHandler {
    function hasClaimedReward(address, uint256) external view returns (bool);
}

interface IMultipleEpochRewardsClaimer {
    function claimMultipleRewards(
        IFeeHandler feeHandler,
        uint256[] calldata unclaimedEpochs
    ) external;

    function getUnclaimedEpochs(IFeeHandler feeHandler, address staker)
        external
        view
        returns (uint256[] memory unclaimedEpochs);
}

// File: @kyber.network/utils-sc/contracts/PermissionGroups.sol

pragma solidity 0.6.6;

contract PermissionGroups {
    uint256 internal constant MAX_GROUP_SIZE = 50;

    address internal admin;
    address internal pendingAdmin;
    mapping(address => bool) internal operators;
    mapping(address => bool) internal alerters;
    address[] internal operatorsGroup;
    address[] internal alertersGroup;

    event AdminClaimed(address newAdmin, address previousAdmin);

    event TransferAdminPending(address pendingAdmin);

    event OperatorAdded(address newOperator, bool isAdd);

    event AlerterAdded(address newAlerter, bool isAdd);

    constructor(address _admin) public {
        require(_admin != address(0), "admin 0");
        admin = _admin;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "only admin");
        _;
    }

    modifier onlyOperator() {
        require(operators[msg.sender], "only operator");
        _;
    }

    modifier onlyAlerter() {
        require(alerters[msg.sender], "only alerter");
        _;
    }

    function getOperators() external view returns (address[] memory) {
        return operatorsGroup;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function getAlerters() external view returns (address[] memory) {
        return alertersGroup;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Allows the current admin to set the pendingAdmin address.
     * @param newAdmin The address to transfer ownership to.
     */
    function transferAdmin(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "new admin 0");
        emit TransferAdminPending(newAdmin);
        pendingAdmin = newAdmin;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
     * @param newAdmin The address to transfer ownership to.
     */
    function transferAdminQuickly(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "admin 0");
        emit TransferAdminPending(newAdmin);
        emit AdminClaimed(newAdmin, admin);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        admin = newAdmin;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Allows the pendingAdmin address to finalize the change admin process.
     */
    function claimAdmin() public {
        require(pendingAdmin == msg.sender, "not pending");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit AdminClaimed(pendingAdmin, admin);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        admin = pendingAdmin;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        pendingAdmin = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function addAlerter(address newAlerter) public onlyAdmin {
        require(!alerters[newAlerter], "alerter exists"); // prevent duplicates.	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(alertersGroup.length < MAX_GROUP_SIZE, "max alerters");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        emit AlerterAdded(newAlerter, true);
        alerters[newAlerter] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        alertersGroup.push(newAlerter);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function removeAlerter(address alerter) public onlyAdmin {
        require(alerters[alerter], "not alerter");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        alerters[alerter] = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        for (uint256 i = 0; i < alertersGroup.length; ++i) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            if (alertersGroup[i] == alerter) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                alertersGroup[i] = alertersGroup[alertersGroup.length - 1];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                alertersGroup.pop();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                emit AlerterAdded(alerter, false);
                break;
            }
        }
    }

    function addOperator(address newOperator) public onlyAdmin {
        require(!operators[newOperator], "operator exists"); // prevent duplicates.	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(operatorsGroup.length < MAX_GROUP_SIZE, "max operators");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        emit OperatorAdded(newOperator, true);
        operators[newOperator] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        operatorsGroup.push(newOperator);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function removeOperator(address operator) public onlyAdmin {
        require(operators[operator], "not operator");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        operators[operator] = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        for (uint256 i = 0; i < operatorsGroup.length; ++i) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            if (operatorsGroup[i] == operator) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                operatorsGroup.pop();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                emit OperatorAdded(operator, false);
                break;
            }
        }
    }
}

// File: @kyber.network/utils-sc/contracts/Withdrawable.sol

pragma solidity 0.6.6;



contract Withdrawable is PermissionGroups {

    event TokenWithdraw(IERC20 token, uint256 amount, address sendTo);
    event EtherWithdraw(uint256 amount, address sendTo);

    constructor(address _admin) public PermissionGroups(_admin) {}

    /**
     * @dev Withdraw all IERC20 compatible tokens
     * @param token IERC20 The address of the token contract
     */
    function withdrawToken(
        IERC20 token,
        uint256 amount,
        address sendTo
    ) external onlyAdmin {
        token.transfer(sendTo, amount);
        emit TokenWithdraw(token, amount, sendTo);
    }

    /**
     * @dev Withdraw Ethers
     */
    function withdrawEther(uint256 amount, address payable sendTo) external onlyAdmin {
        (bool success, ) = sendTo.call{value: amount}("");
        require(success, "withdraw failed");
        emit EtherWithdraw(amount, sendTo);
    }
}

// File: contracts/wrappers/MultipleEpochRewardsClaimer.sol

pragma solidity 0.6.6;





contract MultipleEpochRewardsClaimer is IMultipleEpochRewardsClaimer, Withdrawable {
    IKyberDao internal immutable kyberDao;

    constructor(IKyberDao _kyberDao, address _admin) public Withdrawable(_admin) {
        kyberDao = _kyberDao;
    }

    /// @dev unclaimedEpochs is asusumed to be of reasonable length
    /// otherwise txns might run out of gas
    function claimMultipleRewards(
        IFeeHandler feeHandler,
        uint256[] calldata unclaimedEpochs
    ) external override {
        for (uint256 i = 0; i < unclaimedEpochs.length; i++) {
            feeHandler.claimStakerReward(msg.sender, unclaimedEpochs[i]);
        }
    }

    function getUnclaimedEpochs(IFeeHandler feeHandler, address staker)
        external
        view
        override
        returns (uint256[] memory unclaimedEpochs)
    {
        uint256 currentEpoch = kyberDao.getCurrentEpochNumber();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256[] memory tempArray = new uint256[](currentEpoch);
        uint256 i;
        uint256 j;
        // full array size is expected to be of reasonable length
        // for the next 1-2 years
        // we thus start iterating from epoch 0
        for (i = 0; i < currentEpoch; i++) {
            if (
                !feeHandler.hasClaimedReward(staker, i) &&
                kyberDao.getPastEpochRewardPercentageInPrecision(staker, i) != 0	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            ) {
                tempArray[j]= i;
                j++;
            }
        }
        unclaimedEpochs = new uint256[](j);
        for (i = 0; i < j; i++) {
            unclaimedEpochs[i] = tempArray[i];
        }
    }
}