pragma experimental ABIEncoderV2;
pragma solidity 0.5.15;

contract IAugur {
    function createChildUniverse(bytes32 _parentPayoutDistributionHash, uint256[] memory _parentPayoutNumerators) public returns (IUniverse);
    function isKnownUniverse(IUniverse _universe) public view returns (bool);
    function trustedCashTransfer(address _from, address _to, uint256 _amount) public returns (bool);
    function isTrustedSender(address _address) public returns (bool);
    function onCategoricalMarketCreated(uint256 _endTime, string memory _extraInfo, IMarket _market, address _marketCreator, address _designatedReporter, uint256 _feePerCashInAttoCash, bytes32[] memory _outcomes) public returns (bool);
    function onYesNoMarketCreated(uint256 _endTime, string memory _extraInfo, IMarket _market, address _marketCreator, address _designatedReporter, uint256 _feePerCashInAttoCash) public returns (bool);
    function onScalarMarketCreated(uint256 _endTime, string memory _extraInfo, IMarket _market, address _marketCreator, address _designatedReporter, uint256 _feePerCashInAttoCash, int256[] memory _prices, uint256 _numTicks)  public returns (bool);
    function logInitialReportSubmitted(IUniverse _universe, address _reporter, address _market, address _initialReporter, uint256 _amountStaked, bool _isDesignatedReporter, uint256[] memory _payoutNumerators, string memory _description, uint256 _nextWindowStartTime, uint256 _nextWindowEndTime) public returns (bool);
    function disputeCrowdsourcerCreated(IUniverse _universe, address _market, address _disputeCrowdsourcer, uint256[] memory _payoutNumerators, uint256 _size, uint256 _disputeRound) public returns (bool);
    function logDisputeCrowdsourcerContribution(IUniverse _universe, address _reporter, address _market, address _disputeCrowdsourcer, uint256 _amountStaked, string memory description, uint256[] memory _payoutNumerators, uint256 _currentStake, uint256 _stakeRemaining, uint256 _disputeRound) public returns (bool);
    function logDisputeCrowdsourcerCompleted(IUniverse _universe, address _market, address _disputeCrowdsourcer, uint256[] memory _payoutNumerators, uint256 _nextWindowStartTime, uint256 _nextWindowEndTime, bool _pacingOn, uint256 _totalRepStakedInPayout, uint256 _totalRepStakedInMarket, uint256 _disputeRound) public returns (bool);
    function logInitialReporterRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256[] memory _payoutNumerators) public returns (bool);
    function logDisputeCrowdsourcerRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256[] memory _payoutNumerators) public returns (bool);
    function logMarketFinalized(IUniverse _universe, uint256[] memory _winningPayoutNumerators) public returns (bool);
    function logMarketMigrated(IMarket _market, IUniverse _originalUniverse) public returns (bool);
    function logReportingParticipantDisavowed(IUniverse _universe, IMarket _market) public returns (bool);
    function logMarketParticipantsDisavowed(IUniverse _universe) public returns (bool);
    function logCompleteSetsPurchased(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets) public returns (bool);
    function logCompleteSetsSold(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets, uint256 _fees) public returns (bool);
    function logMarketOIChanged(IUniverse _universe, IMarket _market) public returns (bool);
    function logTradingProceedsClaimed(IUniverse _universe, address _sender, address _market, uint256 _outcome, uint256 _numShares, uint256 _numPayoutTokens, uint256 _fees) public returns (bool);
    function logUniverseForked(IMarket _forkingMarket) public returns (bool);
    function logReputationTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value, uint256 _fromBalance, uint256 _toBalance) public returns (bool);
    function logReputationTokensBurned(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);
    function logReputationTokensMinted(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);
    function logShareTokensBalanceChanged(address _account, IMarket _market, uint256 _outcome, uint256 _balance) public returns (bool);
    function logDisputeCrowdsourcerTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value, uint256 _fromBalance, uint256 _toBalance) public returns (bool);
    function logDisputeCrowdsourcerTokensBurned(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);
    function logDisputeCrowdsourcerTokensMinted(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);
    function logDisputeWindowCreated(IDisputeWindow _disputeWindow, uint256 _id, bool _initial) public returns (bool);
    function logParticipationTokensRedeemed(IUniverse universe, address _sender, uint256 _attoParticipationTokens, uint256 _feePayoutShare) public returns (bool);
    function logTimestampSet(uint256 _newTimestamp) public returns (bool);
    function logInitialReporterTransferred(IUniverse _universe, IMarket _market, address _from, address _to) public returns (bool);
    function logMarketTransferred(IUniverse _universe, address _from, address _to) public returns (bool);
    function logParticipationTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value, uint256 _fromBalance, uint256 _toBalance) public returns (bool);
    function logParticipationTokensBurned(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);
    function logParticipationTokensMinted(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);
    function logMarketRepBondTransferred(address _universe, address _from, address _to) public returns (bool);
    function logWarpSyncDataUpdated(address _universe, uint256 _warpSyncHash, uint256 _marketEndTime) public returns (bool);
    function isKnownFeeSender(address _feeSender) public view returns (bool);
    function lookup(bytes32 _key) public view returns (address);
    function getTimestamp() public view returns (uint256);
    function getMaximumMarketEndDate() public returns (uint256);
    function isKnownMarket(IMarket _market) public view returns (bool);
    function derivePayoutDistributionHash(uint256[] memory _payoutNumerators, uint256 _numTicks, uint256 numOutcomes) public view returns (bytes32);
    function logValidityBondChanged(uint256 _validityBond) public returns (bool);
    function logDesignatedReportStakeChanged(uint256 _designatedReportStake) public returns (bool);
    function logNoShowBondChanged(uint256 _noShowBond) public returns (bool);
    function logReportingFeeChanged(uint256 _reportingFee) public returns (bool);
    function getUniverseForkIndex(IUniverse _universe) public view returns (uint256);
}

contract IOwnable {
    function getOwner() public view returns (address);
    function transferOwnership(address _newOwner) public returns (bool);
}

contract ITyped {
    function getTypeName() public view returns (bytes32);
}

contract Initializable {
    bool private initialized ;	//inject UNINIT LOCAL/STATE VAR


    modifier beforeInitialized {
        require(!initialized);
        _;
    }

    function endInitialization() internal beforeInitialized {
        initialized = true;
    }

    function getInitialized() public view returns (bool) {
        return initialized;
    }
}

contract ReentrancyGuard {
    /**
     * @dev We use a single lock for the whole contract.
     */
    bool private rentrancyLock ;	//inject UNINIT LOCAL/STATE VAR


    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * @notice If you mark a function `nonReentrant`, you should also mark it `external`. Calling one nonReentrant function from another is not supported. Instead, you can implement a `private` function doing the actual work, and a `external` wrapper marked as `nonReentrant`.
     */
    modifier nonReentrant() {
        require(!rentrancyLock);
        rentrancyLock = true;
        _;
        rentrancyLock = false;
    }
}

library TokenId {

    function getTokenId(IMarket _market, uint256 _outcome) internal pure returns (uint256 _tokenId) {
        bytes memory _tokenIdBytes = abi.encodePacked(_market, uint8(_outcome));
        assembly {
            _tokenId := mload(add(_tokenIdBytes, add(0x20, 0)))
        }
    }

    function getTokenIds(IMarket _market, uint256[] memory _outcomes) internal pure returns (uint256[] memory _tokenIds) {
        _tokenIds = new uint256[](_outcomes.length);
        for (uint256 _i ; _i < _outcomes.length; _i++) {	//inject UNINIT LOCAL/STATE VAR

            _tokenIds[_i] = getTokenId(_market, _outcomes[_i]);
        }
    }

    function unpackTokenId(uint256 _tokenId) internal pure returns (address _market, uint256 _outcome) {
        assembly {
            _market := shr(96,  and(_tokenId, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000))
            _outcome := shr(88, and(_tokenId, 0x0000000000000000000000000000000000000000FF0000000000000000000000))
        }
    }
}

library SafeMathUint256 {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c >= a);
        return c;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a <= b) {
            return a;
        } else {
            return b;
        }
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a >= b) {
            return a;
        } else {
            return b;
        }
    }

    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            uint256 x ;	//inject UNINIT LOCAL/STATE VAR

            z = y;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function getUint256Min() internal pure returns (uint256) {
        return 0;
    }

    function getUint256Max() internal pure returns (uint256) {
        // 2 ** 256 - 1
        return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    }

    function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
        return a % b == 0;
    }

    // Float [fixed point] Operations
    function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
        return div(mul(a, b), base);
    }

    function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
        return div(mul(a, base), b);
    }
}

interface IERC1155 {

    /// @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred,
    ///      including zero value transfers as well as minting or burning.
    /// Operator will always be msg.sender.
    /// Either event from address `0x0` signifies a minting operation.
    /// An event to address `0x0` signifies a burning or melting operation.
    /// The total value transferred from address 0x0 minus the total value transferred to 0x0 may
    /// be used by clients and exchanges to be added to the "circulating supply" for a given token ID.
    /// To define a token ID with no initial balance, the contract SHOULD emit the TransferSingle event
    /// from `0x0` to `0x0`, with the token creator as `_operator`.
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

    /// @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred,
    ///      including zero value transfers as well as minting or burning.
    ///Operator will always be msg.sender.
    /// Either event from address `0x0` signifies a minting operation.
    /// An event to address `0x0` signifies a burning or melting operation.
    /// The total value transferred from address 0x0 minus the total value transferred to 0x0 may
    /// be used by clients and exchanges to be added to the "circulating supply" for a given token ID.
    /// To define multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event
    /// from `0x0` to `0x0`, with the token creator as `_operator`.
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /// @dev MUST emit when an approval is updated.
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    /// @dev MUST emit when the URI is updated for a token ID.
    /// URIs are defined in RFC 3986.
    /// The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema".
    event URI(
        string value,
        uint256 indexed id
    );

    /// @notice Transfers value amount of an _id from the _from address to the _to address specified.
    /// @dev MUST emit TransferSingle event on success.
    /// Caller must be approved to manage the _from account's tokens (see isApprovedForAll).
    /// MUST throw if `_to` is the zero address.
    /// MUST throw if balance of sender for token `_id` is lower than the `_value` sent.
    /// MUST throw on any other error.
    /// When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0).
    /// If so, it MUST call `onERC1155Received` on `_to` and revert if the return value
    /// is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`.
    /// @param from    Source address
    /// @param to      Target address
    /// @param id      ID of the token type
    /// @param value   Transfer amount
    /// @param data    Additional data with no specified format, sent in call to `_to`
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    )
        external;

    /// @notice Send multiple types of Tokens from a 3rd party in one transfer (with safety call).
    /// @dev MUST emit TransferBatch event on success.
    /// Caller must be approved to manage the _from account's tokens (see isApprovedForAll).
    /// MUST throw if `_to` is the zero address.
    /// MUST throw if length of `_ids` is not the same as length of `_values`.
    ///  MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_values` sent.
    /// MUST throw on any other error.
    /// When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0).
    /// If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return value
    /// is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`.
    /// @param from    Source addresses
    /// @param to      Target addresses
    /// @param ids     IDs of each token type
    /// @param values  Transfer amounts per token type
    /// @param data    Additional data with no specified format, sent in call to `_to`
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    )
        external;

    /// @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
    /// @dev MUST emit the ApprovalForAll event on success.
    /// @param operator  Address to add to the set of authorized operators
    /// @param approved  True if the operator is approved, false to revoke approval
    function setApprovalForAll(address operator, bool approved) external;

    /// @notice Queries the approval status of an operator for a given owner.
    /// @param owner     The owner of the Tokens
    /// @param operator  Address of authorized operator
    /// @return           True if the operator is approved, false if not
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /// @notice Get the balance of an account's Tokens.
    /// @param owner  The address of the token holder
    /// @param id     ID of the Token
    /// @return        The _owner's balance of the Token type requested
    function balanceOf(address owner, uint256 id) external view returns (uint256);

    /// @notice Get the total supply of a Token.
    /// @param id     ID of the Token
    /// @return        The total supply of the Token type requested
    function totalSupply(uint256 id) external view returns (uint256);

    /// @notice Get the balance of multiple account/token pairs
    /// @param owners The addresses of the token holders
    /// @param ids    ID of the Tokens
    /// @return        The _owner's balance of the Token types requested
    function balanceOfBatch(
        address[] calldata owners,
        uint256[] calldata ids
    )
        external
        view
        returns (uint256[] memory balances_);
}

contract IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) public view returns (uint256);
    function transfer(address to, uint256 amount) public returns (bool);
    function transferFrom(address from, address to, uint256 amount) public returns (bool);
    function approve(address spender, uint256 amount) public returns (bool);
    function allowance(address owner, address spender) public view returns (uint256);

    // solhint-disable-next-line no-simple-event-func-name
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ICash is IERC20 {
}

contract IAffiliateValidator {
    function validateReference(address _account, address _referrer) external view returns (bool);
}

contract IDisputeWindow is ITyped, IERC20 {
    function invalidMarketsTotal() external view returns (uint256);
    function validityBondTotal() external view returns (uint256);

    function incorrectDesignatedReportTotal() external view returns (uint256);
    function initialReportBondTotal() external view returns (uint256);

    function designatedReportNoShowsTotal() external view returns (uint256);
    function designatedReporterNoShowBondTotal() external view returns (uint256);

    function initialize(IAugur _augur, IUniverse _universe, uint256 _disputeWindowId, bool _participationTokensEnabled, uint256 _duration, uint256 _startTime) public;
    function trustedBuy(address _buyer, uint256 _attotokens) public returns (bool);
    function getUniverse() public view returns (IUniverse);
    function getReputationToken() public view returns (IReputationToken);
    function getStartTime() public view returns (uint256);
    function getEndTime() public view returns (uint256);
    function getWindowId() public view returns (uint256);
    function isActive() public view returns (bool);
    function isOver() public view returns (bool);
    function onMarketFinalized() public;
    function redeem(address _account) public returns (bool);
}

contract IMarket is IOwnable {
    enum MarketType {
        YES_NO,
        CATEGORICAL,
        SCALAR
    }

    function initialize(IAugur _augur, IUniverse _universe, uint256 _endTime, uint256 _feePerCashInAttoCash, IAffiliateValidator _affiliateValidator, uint256 _affiliateFeeDivisor, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public;
    function derivePayoutDistributionHash(uint256[] memory _payoutNumerators) public view returns (bytes32);
    function doInitialReport(uint256[] memory _payoutNumerators, string memory _description, uint256 _additionalStake) public returns (bool);
    function getUniverse() public view returns (IUniverse);
    function getDisputeWindow() public view returns (IDisputeWindow);
    function getNumberOfOutcomes() public view returns (uint256);
    function getNumTicks() public view returns (uint256);
    function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
    function getForkingMarket() public view returns (IMarket _market);
    function getEndTime() public view returns (uint256);
    function getWinningPayoutDistributionHash() public view returns (bytes32);
    function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
    function getWinningReportingParticipant() public view returns (IReportingParticipant);
    function getReputationToken() public view returns (IV2ReputationToken);
    function getFinalizationTime() public view returns (uint256);
    function getInitialReporter() public view returns (IInitialReporter);
    function getDesignatedReportingEndTime() public view returns (uint256);
    function getValidityBondAttoCash() public view returns (uint256);
    function affiliateFeeDivisor() external view returns (uint256);
    function getNumParticipants() public view returns (uint256);
    function getDisputePacingOn() public view returns (bool);
    function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
    function recordMarketCreatorFees(uint256 _marketCreatorFees, address _sourceAccount, bytes32 _fingerprint) public returns (bool);
    function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
    function isFinalizedAsInvalid() public view returns (bool);
    function finalize() public returns (bool);
    function isFinalized() public view returns (bool);
    function getOpenInterest() public view returns (uint256);
}

contract IReportingParticipant {
    function getStake() public view returns (uint256);
    function getPayoutDistributionHash() public view returns (bytes32);
    function liquidateLosing() public;
    function redeem(address _redeemer) public returns (bool);
    function isDisavowed() public view returns (bool);
    function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
    function getPayoutNumerators() public view returns (uint256[] memory);
    function getMarket() public view returns (IMarket);
    function getSize() public view returns (uint256);
}

contract IInitialReporter is IReportingParticipant, IOwnable {
    function initialize(IAugur _augur, IMarket _market, address _designatedReporter) public;
    function report(address _reporter, bytes32 _payoutDistributionHash, uint256[] memory _payoutNumerators, uint256 _initialReportStake) public;
    function designatedReporterShowed() public view returns (bool);
    function initialReporterWasCorrect() public view returns (bool);
    function getDesignatedReporter() public view returns (address);
    function getReportTimestamp() public view returns (uint256);
    function migrateToNewUniverse(address _designatedReporter) public;
    function returnRepFromDisavow() public;
}

contract IReputationToken is IERC20 {
    function migrateOutByPayout(uint256[] memory _payoutNumerators, uint256 _attotokens) public returns (bool);
    function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
    function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function trustedDisputeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function getUniverse() public view returns (IUniverse);
    function getTotalMigrated() public view returns (uint256);
    function getTotalTheoreticalSupply() public view returns (uint256);
    function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
}

contract IShareToken is ITyped, IERC1155 {
    function initialize(IAugur _augur) external;
    function initializeMarket(IMarket _market, uint256 _numOutcomes, uint256 _numTicks) public;
    function unsafeTransferFrom(address _from, address _to, uint256 _id, uint256 _value) public;
    function unsafeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values) public;
    function claimTradingProceeds(IMarket _market, address _shareHolder, bytes32 _fingerprint) external returns (uint256[] memory _outcomeFees);
    function getMarket(uint256 _tokenId) external view returns (IMarket);
    function getOutcome(uint256 _tokenId) external view returns (uint256);
    function getTokenId(IMarket _market, uint256 _outcome) public pure returns (uint256 _tokenId);
    function getTokenIds(IMarket _market, uint256[] memory _outcomes) public pure returns (uint256[] memory _tokenIds);
    function buyCompleteSets(IMarket _market, address _account, uint256 _amount) external returns (bool);
    function buyCompleteSetsForTrade(IMarket _market, uint256 _amount, uint256 _longOutcome, address _longRecipient, address _shortRecipient) external returns (bool);
    function sellCompleteSets(IMarket _market, address _holder, address _recipient, uint256 _amount, bytes32 _fingerprint) external returns (uint256 _creatorFee, uint256 _reportingFee);
    function sellCompleteSetsForTrade(IMarket _market, uint256 _outcome, uint256 _amount, address _shortParticipant, address _longParticipant, address _shortRecipient, address _longRecipient, uint256 _price, address _sourceAccount, bytes32 _fingerprint) external returns (uint256 _creatorFee, uint256 _reportingFee);
    function totalSupplyForMarketOutcome(IMarket _market, uint256 _outcome) public view returns (uint256);
    function balanceOfMarketOutcome(IMarket _market, uint256 _outcome, address _account) public view returns (uint256);
    function lowestBalanceOfMarketOutcomes(IMarket _market, uint256[] memory _outcomes, address _account) public view returns (uint256);
}

contract IUniverse {
    function creationTime() external view returns (uint256);
    function marketBalance(address) external view returns (uint256);

    function fork() public returns (bool);
    function updateForkValues() public returns (bool);
    function getParentUniverse() public view returns (IUniverse);
    function createChildUniverse(uint256[] memory _parentPayoutNumerators) public returns (IUniverse);
    function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
    function getReputationToken() public view returns (IV2ReputationToken);
    function getForkingMarket() public view returns (IMarket);
    function getForkEndTime() public view returns (uint256);
    function getForkReputationGoal() public view returns (uint256);
    function getParentPayoutDistributionHash() public view returns (bytes32);
    function getDisputeRoundDurationInSeconds(bool _initial) public view returns (uint256);
    function getOrCreateDisputeWindowByTimestamp(uint256 _timestamp, bool _initial) public returns (IDisputeWindow);
    function getOrCreateCurrentDisputeWindow(bool _initial) public returns (IDisputeWindow);
    function getOrCreateNextDisputeWindow(bool _initial) public returns (IDisputeWindow);
    function getOrCreatePreviousDisputeWindow(bool _initial) public returns (IDisputeWindow);
    function getOpenInterestInAttoCash() public view returns (uint256);
    function getTargetRepMarketCapInAttoCash() public view returns (uint256);
    function getOrCacheValidityBond() public returns (uint256);
    function getOrCacheDesignatedReportStake() public returns (uint256);
    function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
    function getOrCacheMarketRepBond() public returns (uint256);
    function getOrCacheReportingFeeDivisor() public returns (uint256);
    function getDisputeThresholdForFork() public view returns (uint256);
    function getDisputeThresholdForDisputePacing() public view returns (uint256);
    function getInitialReportMinValue() public view returns (uint256);
    function getPayoutNumerators() public view returns (uint256[] memory);
    function getReportingFeeDivisor() public view returns (uint256);
    function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
    function getWinningChildPayoutNumerator(uint256 _outcome) public view returns (uint256);
    function isOpenInterestCash(address) public view returns (bool);
    function isForkingMarket() public view returns (bool);
    function getCurrentDisputeWindow(bool _initial) public view returns (IDisputeWindow);
    function getDisputeWindowStartTimeAndDuration(uint256 _timestamp, bool _initial) public view returns (uint256, uint256);
    function isParentOf(IUniverse _shadyChild) public view returns (bool);
    function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
    function isContainerForDisputeWindow(IDisputeWindow _shadyTarget) public view returns (bool);
    function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
    function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
    function migrateMarketOut(IUniverse _destinationUniverse) public returns (bool);
    function migrateMarketIn(IMarket _market, uint256 _cashBalance, uint256 _marketOI) public returns (bool);
    function decrementOpenInterest(uint256 _amount) public returns (bool);
    function decrementOpenInterestFromMarket(IMarket _market) public returns (bool);
    function incrementOpenInterest(uint256 _amount) public returns (bool);
    function getWinningChildUniverse() public view returns (IUniverse);
    function isForking() public view returns (bool);
    function deposit(address _sender, uint256 _amount, address _market) public returns (bool);
    function withdraw(address _recipient, uint256 _amount, address _market) public returns (bool);
    function createScalarMarket(uint256 _endTime, uint256 _feePerCashInAttoCash, IAffiliateValidator _affiliateValidator, uint256 _affiliateFeeDivisor, address _designatedReporterAddress, int256[] memory _prices, uint256 _numTicks, string memory _extraInfo) public returns (IMarket _newMarket);
}

contract IV2ReputationToken is IReputationToken {
    function parentUniverse() external returns (IUniverse);
    function burnForMarket(uint256 _amountToBurn) public returns (bool);
    function mintForWarpSync(uint256 _amountToMint, address _target) public returns (bool);
}

contract IAugurTrading {
    function lookup(bytes32 _key) public view returns (address);
    function logProfitLossChanged(IMarket _market, address _account, uint256 _outcome, int256 _netPosition, uint256 _avgPrice, int256 _realizedProfit, int256 _frozenFunds, int256 _realizedCost) public returns (bool);
    function logOrderCreated(IUniverse _universe, bytes32 _orderId, bytes32 _tradeGroupId) public returns (bool);
    function logOrderCanceled(IUniverse _universe, IMarket _market, address _creator, uint256 _tokenRefund, uint256 _sharesRefund, bytes32 _orderId) public returns (bool);
    function logOrderFilled(IUniverse _universe, address _creator, address _filler, uint256 _price, uint256 _fees, uint256 _amountFilled, bytes32 _orderId, bytes32 _tradeGroupId) public returns (bool);
    function logMarketVolumeChanged(IUniverse _universe, address _market, uint256 _volume, uint256[] memory _outcomeVolumes, uint256 _totalTrades) public returns (bool);
    function logZeroXOrderFilled(IUniverse _universe, IMarket _market, bytes32 _orderHash, bytes32 _tradeGroupId, uint8 _orderType, address[] memory _addressData, uint256[] memory _uint256Data) public returns (bool);
    function logZeroXOrderCanceled(address _universe, address _market, address _account, uint256 _outcome, uint256 _price, uint256 _amount, uint8 _type, bytes32 _orderHash) public;
}

contract IFillOrder {
    function publicFillOrder(bytes32 _orderId, uint256 _amountFillerWants, bytes32 _tradeGroupId, bytes32 _fingerprint) external returns (uint256);
    function fillOrder(address _filler, bytes32 _orderId, uint256 _amountFillerWants, bytes32 tradeGroupId, bytes32 _fingerprint) external returns (uint256);
    function fillZeroXOrder(IMarket _market, uint256 _outcome, uint256 _price, Order.Types _orderType, address _creator, uint256 _amount, bytes32 _fingerprint, bytes32 _tradeGroupId, address _filler) external returns (uint256, uint256);
    function getMarketOutcomeValues(IMarket _market) public view returns (uint256[] memory);
    function getMarketVolume(IMarket _market) public view returns (uint256);
}

contract IOrders {
    function saveOrder(uint256[] calldata _uints, bytes32[] calldata _bytes32s, Order.Types _type, IMarket _market, address _sender) external returns (bytes32 _orderId);
    function removeOrder(bytes32 _orderId) external returns (bool);
    function getMarket(bytes32 _orderId) public view returns (IMarket);
    function getOrderType(bytes32 _orderId) public view returns (Order.Types);
    function getOutcome(bytes32 _orderId) public view returns (uint256);
    function getAmount(bytes32 _orderId) public view returns (uint256);
    function getPrice(bytes32 _orderId) public view returns (uint256);
    function getOrderCreator(bytes32 _orderId) public view returns (address);
    function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
    function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
    function getOrderDataForCancel(bytes32 _orderId) public view returns (uint256, uint256, Order.Types, IMarket, uint256, address);
    function getOrderDataForLogs(bytes32 _orderId) public view returns (Order.Types, address[] memory _addressData, uint256[] memory _uint256Data);
    function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
    function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
    function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
    function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
    function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
    function getOrderId(Order.Types _type, IMarket _market, uint256 _amount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
    function getTotalEscrowed(IMarket _market) public view returns (uint256);
    function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
    function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
    function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
    function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
    function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled, uint256 _fill) external returns (bool);
    function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
}

contract IProfitLoss {
    function initialize(IAugur _augur) public;
    function recordFrozenFundChange(IUniverse _universe, IMarket _market, address _account, uint256 _outcome, int256 _frozenFundDelta) public returns (bool);
    function adjustTraderProfitForFees(IMarket _market, address _trader, uint256 _outcome, uint256 _fees) public returns (bool);
    function recordTrade(IUniverse _universe, IMarket _market, address _longAddress, address _shortAddress, uint256 _outcome, int256 _amount, int256 _price, uint256 _numLongTokens, uint256 _numShortTokens, uint256 _numLongShares, uint256 _numShortShares) public returns (bool);
    function recordClaim(IMarket _market, address _account, uint256[] memory _outcomeFees) public returns (bool);
}

library Order {
    using SafeMathUint256 for uint256;

    enum Types {
        Bid, Ask
    }

    enum TradeDirections {
        Long, Short
    }

    struct Data {
        // Contracts
        IMarket market;
        IAugur augur;
        IAugurTrading augurTrading;
        IShareToken shareToken;
        ICash cash;

        // Order
        bytes32 id;
        address creator;
        uint256 outcome;
        Order.Types orderType;
        uint256 amount;
        uint256 price;
        uint256 sharesEscrowed;
        uint256 moneyEscrowed;
        bytes32 betterOrderId;
        bytes32 worseOrderId;
    }

    function create(IAugur _augur, IAugurTrading _augurTrading, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data memory) {
        require(_outcome < _market.getNumberOfOutcomes(), "Order.create: Outcome is not within market range");
        require(_price != 0, "Order.create: Price may not be 0");
        require(_price < _market.getNumTicks(), "Order.create: Price is outside of market range");
        require(_attoshares > 0, "Order.create: Cannot use amount of 0");
        require(_creator != address(0), "Order.create: Creator is 0x0");

        IShareToken _shareToken ;	//inject UNINIT LOCAL/STATE VAR


        return Data({
            market: _market,
            augur: _augur,
            augurTrading: _augurTrading,
            shareToken: _shareToken,
            cash: ICash(_augur.lookup("Cash")),
            id: 0,
            creator: _creator,
            outcome: _outcome,
            orderType: _type,
            amount: _attoshares,
            price: _price,
            sharesEscrowed: 0,
            moneyEscrowed: 0,
            betterOrderId: _betterOrderId,
            worseOrderId: _worseOrderId
        });
    }

    //
    // "public" functions
    //

    function getOrderId(Order.Data memory _orderData, IOrders _orders) internal view returns (bytes32) {
        if (_orderData.id == bytes32(0)) {
            bytes32 _orderId ;	//inject UNINIT LOCAL/STATE VAR

            require(_orders.getAmount(_orderId) == 0, "Order.getOrderId: New order had amount. This should not be possible");
            _orderData.id = _orderId;
        }
        return _orderData.id;
    }

    function calculateOrderId(Order.Types _type, IMarket _market, uint256 _amount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) internal pure returns (bytes32) {
        return sha256(abi.encodePacked(_type, _market, _amount, _price, _sender, _blockNumber, _outcome, _moneyEscrowed, _sharesEscrowed));
    }

    function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
        return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
    }

    function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
        return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
    }

    function saveOrder(Order.Data memory _orderData, bytes32 _tradeGroupId, IOrders _orders) internal returns (bytes32) {
        getOrderId(_orderData, _orders);
        uint256[] memory _uints = new uint256[](5);
        _uints[0] = _orderData.amount;
        _uints[1] = _orderData.price;
        _uints[2] = _orderData.outcome;
        _uints[3] = _orderData.moneyEscrowed;
        _uints[4] = _orderData.sharesEscrowed;
        bytes32[] memory _bytes32s = new bytes32[](4);
        _bytes32s[0] = _orderData.betterOrderId;
        _bytes32s[1] = _orderData.worseOrderId;
        _bytes32s[2] = _tradeGroupId;
        _bytes32s[3] = _orderData.id;
        return _orders.saveOrder(_uints, _bytes32s, _orderData.orderType, _orderData.market, _orderData.creator);
    }
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

library Trade {
    using SafeMathUint256 for uint256;

    enum Direction {
        Long,
        Short
    }

    struct StoredContracts {
        IAugur augur;
        IAugurTrading augurTrading;
        IOrders orders;
        ICash denominationToken;
        IProfitLoss profitLoss;
        IShareToken shareToken;
    }

    struct Contracts {
        IOrders orders;
        IMarket market;
        ICash denominationToken;
        IShareToken shareToken;
        IAugur augur;
        IUniverse universe;
        IProfitLoss profitLoss;
        IAugurTrading augurTrading;
    }

    struct FilledOrder {
        bytes32 orderId;
        uint256 outcome;
        uint256 sharePriceRange;
        uint256 sharePriceLong;
        uint256 sharePriceShort;
    }

    struct Participant {
        address participantAddress;
        Direction direction;
        uint256 startingSharesToSell;
        uint256 startingSharesToBuy;
        uint256 sharesToSell;
        uint256 sharesToBuy;
    }

    struct Data {
        Contracts contracts;
        FilledOrder order;
        Participant creator;
        Participant filler;
        uint256 longOutcome;
        uint256[] shortOutcomes;
        address longFundsAccount;
        address shortFundsAccount;
        bytes32 fingerprint;
    }

    struct OrderData {
        IMarket market;
        uint256 outcome;
        uint256 price;
        Order.Types orderType;
        uint256 sharesEscrowed;
        uint256 amount;
        address creator;
        bytes32 orderId;
    }

    //
    // Constructor
    //

    function create(StoredContracts memory _storedContracts, bytes32 _orderId, address _fillerAddress, uint256 _fillerSize, bytes32 _fingerprint) internal view returns (Data memory) {
        OrderData memory _orderData = createOrderDataWithOrderId(_storedContracts, _orderId);

        return createWithData(_storedContracts, _orderData, _fillerAddress, _fillerSize, _fingerprint);
    }

    function createWithData(StoredContracts memory _storedContracts, OrderData memory _orderData, address _fillerAddress, uint256 _fillerSize, bytes32 _fingerprint) internal view returns (Data memory) {
        Contracts memory _contracts = getContracts(_storedContracts, _orderData.market, _orderData.outcome);
        FilledOrder memory _order = getOrder(_contracts, _orderData.outcome, _orderData.price, _orderData.orderId);
        Participant memory _creator = getMaker(_orderData.sharesEscrowed, _orderData.amount, _orderData.creator, _orderData.orderType);
        uint256[] memory _shortOutcomes = getShortOutcomes(_contracts.market, _orderData.outcome);
        Participant memory _filler = getFiller(_contracts, _orderData.outcome, _shortOutcomes, _orderData.orderType, _fillerAddress, _fillerSize);

        // Signed orders which have no order id get their funds from the signed order "creator" whereas on chain orders have funds escrowed in Augur Trading.
        address _creatorFundsSource ;	//inject UNINIT LOCAL/STATE VAR


        return Data({
            contracts: _contracts,
            order: _order,
            creator: _creator,
            filler: _filler,
            longOutcome: _orderData.outcome,
            shortOutcomes: _shortOutcomes,
            longFundsAccount: _creator.direction == Direction.Long ? _creatorFundsSource : _filler.participantAddress,
            shortFundsAccount: _creator.direction == Direction.Short ? _creatorFundsSource : _filler.participantAddress,
            fingerprint: _fingerprint
        });
    }

    function createOrderDataWithOrderId(StoredContracts memory _storedContracts, bytes32 _orderId) internal view returns (OrderData memory) {
        IOrders _orders ;	//inject UNINIT LOCAL/STATE VAR


        return OrderData({
            market: _orders.getMarket(_orderId),
            outcome: _orders.getOutcome(_orderId),
            price: _orders.getPrice(_orderId),
            orderType: _orders.getOrderType(_orderId),
            sharesEscrowed: _orders.getOrderSharesEscrowed(_orderId),
            amount: _orders.getAmount(_orderId),
            creator: _orders.getOrderCreator(_orderId),
            orderId: _orderId
        });
    }

    function createOrderData(IShareToken _shareToken, IMarket _market, uint256 _outcome, uint256 _price, Order.Types _orderType, uint256 _amount, address _creator) internal view returns (OrderData memory) {
        uint256 _sharesAvailable ;	//inject UNINIT LOCAL/STATE VAR


        return OrderData({
            market: _market,
            outcome: _outcome,
            price: _price,
            orderType: _orderType,
            sharesEscrowed: _sharesAvailable,
            amount: _amount,
            creator: _creator,
            orderId: bytes32(0)
        });
    }

    function getSharesAvailable(IShareToken _shareToken, IMarket _market, Order.Types _orderType, uint256 _outcome, uint256 _amount, address _creator) private view returns (uint256) {
        // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
        uint256 _numberOfOutcomes ;	//inject UNINIT LOCAL/STATE VAR

        if (_orderType == Order.Types.Bid) {
            return _shareToken.lowestBalanceOfMarketOutcomes(_market, getShortOutcomes(_market, _outcome), _creator).min(_amount);
        }
        return _shareToken.balanceOfMarketOutcome(_market, _outcome, _creator).min(_amount);
    }

    function getShortOutcomes(IMarket _market, uint256 _outcome) private view returns (uint256[] memory) {
        uint256 _numberOfOutcomes ;	//inject UNINIT LOCAL/STATE VAR

        uint256[] memory _shortOutcomes = new uint256[](_numberOfOutcomes - 1);
        uint256 _indexOutcome ;	//inject UNINIT LOCAL/STATE VAR

        for (uint256 _i ; _i < _numberOfOutcomes - 1; _i++) {	//inject UNINIT LOCAL/STATE VAR

            if (_i == _outcome) {
                _indexOutcome++;
            }
            _shortOutcomes[_i] = _indexOutcome;
            _indexOutcome++;
        }
        return _shortOutcomes;
    }

    //
    // "public" functions
    //

    function tradeMakerSharesForFillerShares(Data memory _data) internal returns (uint256 _marketCreatorFees, uint256 _reporterFees) {
        uint256 _numberOfCompleteSets ;	//inject UNINIT LOCAL/STATE VAR

        if (_numberOfCompleteSets == 0) {
            return (0, 0);
        }

        // transfer shares and sell complete sets distributing payouts based on the price

        // Sell both account shares
        (_marketCreatorFees, _reporterFees) = _data.contracts.shareToken.sellCompleteSetsForTrade(_data.contracts.market, _data.longOutcome, _numberOfCompleteSets, _data.shortFundsAccount, _data.longFundsAccount, getShortShareSellerDestination(_data), getLongShareSellerDestination(_data), _data.order.sharePriceLong, _data.filler.participantAddress, _data.fingerprint);

        // update available shares for creator and filler
        _data.creator.sharesToSell -= _numberOfCompleteSets;
        _data.filler.sharesToSell -= _numberOfCompleteSets;
        return (_marketCreatorFees, _reporterFees);
    }

    function tradeMakerSharesForFillerTokens(Data memory _data) internal returns (bool) {
        uint256 _numberOfSharesToTrade ;	//inject UNINIT LOCAL/STATE VAR

        if (_numberOfSharesToTrade == 0) {
            return true;
        }

        // transfer shares from creator (escrowed in market) to filler
        if (_data.creator.direction == Direction.Short) {
            _data.contracts.shareToken.unsafeTransferFrom(_data.shortFundsAccount, _data.filler.participantAddress, TokenId.getTokenId(_data.contracts.market, _data.longOutcome), _numberOfSharesToTrade);
        } else {
            uint256[] memory _values = new uint256[](_data.shortOutcomes.length);
            for (uint256 _i ; _i < _data.shortOutcomes.length; _i++) {	//inject UNINIT LOCAL/STATE VAR

                _values[_i] = _numberOfSharesToTrade;
            }
            _data.contracts.shareToken.unsafeBatchTransferFrom(_data.longFundsAccount, _data.filler.participantAddress, TokenId.getTokenIds(_data.contracts.market, _data.shortOutcomes), _values);
        }

        uint256 _tokensToCover ;	//inject UNINIT LOCAL/STATE VAR

        _data.contracts.denominationToken.transferFrom(_data.filler.participantAddress, _data.creator.participantAddress, _tokensToCover);

        // update available assets for creator and filler
        _data.creator.sharesToSell -= _numberOfSharesToTrade;
        _data.filler.sharesToBuy -= _numberOfSharesToTrade;
        return true;
    }

    function tradeMakerTokensForFillerShares(Data memory _data) internal returns (bool) {
        uint256 _numberOfSharesToTrade ;	//inject UNINIT LOCAL/STATE VAR

        if (_numberOfSharesToTrade == 0) {
            return true;
        }

        // transfer shares from filler to creator
        if (_data.filler.direction == Direction.Short) {
            _data.contracts.shareToken.unsafeTransferFrom(_data.filler.participantAddress, _data.creator.participantAddress, TokenId.getTokenId(_data.contracts.market, _data.longOutcome), _numberOfSharesToTrade);
        } else {
            uint256[] memory _values = new uint256[](_data.shortOutcomes.length);
            for (uint256 _i ; _i < _data.shortOutcomes.length; _i++) {	//inject UNINIT LOCAL/STATE VAR

                _values[_i] = _numberOfSharesToTrade;
            }
            _data.contracts.shareToken.unsafeBatchTransferFrom(_data.filler.participantAddress, _data.creator.participantAddress, TokenId.getTokenIds(_data.contracts.market, _data.shortOutcomes), _values);
        }

        // transfer tokens from creator (taken from the signer for signed orders, escrowed in Augur Trading for on chain orders) to filler
        uint256 _tokensToCover ;	//inject UNINIT LOCAL/STATE VAR

        if (_data.order.orderId == bytes32(0)) {
            // No order Id indicates this is a signed order
            _data.contracts.denominationToken.transferFrom(_data.creator.participantAddress, _data.filler.participantAddress, _tokensToCover);
        } else {
            _data.contracts.denominationToken.transferFrom(address(_data.contracts.augurTrading), _data.filler.participantAddress, _tokensToCover);
        }

        // update available assets for creator and filler
        _data.creator.sharesToBuy -= _numberOfSharesToTrade;
        _data.filler.sharesToSell -= _numberOfSharesToTrade;
        return true;
    }

    function tradeMakerTokensForFillerTokens(Data memory _data) internal returns (uint256) {
        uint256 _numberOfCompleteSets ;	//inject UNINIT LOCAL/STATE VAR

        if (_numberOfCompleteSets == 0) {
            return 0;
        }

        // If someone is filling their own order with CASH both ways we just return the CASH
        if (_data.creator.participantAddress == _data.filler.participantAddress) {
            uint256 _creatorTokensToCover ;	//inject UNINIT LOCAL/STATE VAR

            uint256 _fillerTokensToCover ;	//inject UNINIT LOCAL/STATE VAR

            _data.contracts.denominationToken.transferFrom(address(_data.contracts.augurTrading), _data.creator.participantAddress, _creatorTokensToCover);

            _data.creator.sharesToBuy -= _numberOfCompleteSets;
            _data.filler.sharesToBuy -= _numberOfCompleteSets;
            return _creatorTokensToCover.add(_fillerTokensToCover);
        }

        // buy complete sets and distribute shares to participants
        uint256 _longCost ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _shortCost ;	//inject UNINIT LOCAL/STATE VAR

        IUniverse _universe ;	//inject UNINIT LOCAL/STATE VAR


        // Bring in cash from both parties
        if (_data.longFundsAccount == address(_data.contracts.market)) {
            _data.contracts.denominationToken.transferFrom(address(_data.contracts.augurTrading), address(this), _longCost);
        } else {
            _data.contracts.denominationToken.transferFrom(_data.longFundsAccount, address(this), _longCost);
        }

        if (_data.shortFundsAccount == address(_data.contracts.market)) {
            _data.contracts.denominationToken.transferFrom(address(_data.contracts.augurTrading), address(this), _shortCost);
        } else {
            _data.contracts.denominationToken.transferFrom(_data.shortFundsAccount, address(this), _shortCost);
        }

        // Buy and distribute complete sets
        address _longRecipient ;	//inject UNINIT LOCAL/STATE VAR

        address _shortRecipient ;	//inject UNINIT LOCAL/STATE VAR

        _data.contracts.shareToken.buyCompleteSetsForTrade(_data.contracts.market, _numberOfCompleteSets, _data.order.outcome, _longRecipient, _shortRecipient);

        _data.creator.sharesToBuy -= _numberOfCompleteSets;
        _data.filler.sharesToBuy -= _numberOfCompleteSets;
        return 0;
    }

    //
    // Helpers
    //

    function getLongShareBuyerDestination(Data memory _data) internal pure returns (address) {
        return (_data.creator.direction == Direction.Long) ? _data.creator.participantAddress : _data.filler.participantAddress;
    }

    function getShortShareBuyerDestination(Data memory _data) internal pure returns (address) {
        return (_data.creator.direction == Direction.Short) ? _data.creator.participantAddress : _data.filler.participantAddress;
    }

    function getLongShareSellerSource(Data memory _data) internal pure returns (address) {
        return (_data.creator.direction == Direction.Short) ? address(_data.contracts.market) : _data.filler.participantAddress;
    }

    function getShortShareSellerSource(Data memory _data) internal pure returns (address) {
        return (_data.creator.direction == Direction.Long) ? address(_data.contracts.market) : _data.filler.participantAddress;
    }

    function getLongShareSellerDestination(Data memory _data) internal pure returns (address) {
        return (_data.creator.direction == Direction.Short) ? _data.creator.participantAddress : _data.filler.participantAddress;
    }

    function getShortShareSellerDestination(Data memory _data) internal pure returns (address) {
        return (_data.creator.direction == Direction.Long) ? _data.creator.participantAddress : _data.filler.participantAddress;
    }

    function getMakerSharesDepleted(Data memory _data) internal pure returns (uint256) {
        return _data.creator.startingSharesToSell.sub(_data.creator.sharesToSell);
    }

    function getFillerSharesDepleted(Data memory _data) internal pure returns (uint256) {
        return _data.filler.startingSharesToSell.sub(_data.filler.sharesToSell);
    }

    function getMakerTokensDepleted(Data memory _data) internal pure returns (uint256) {
        return getTokensDepleted(_data, _data.creator.direction, _data.creator.startingSharesToBuy, _data.creator.sharesToBuy);
    }

    function getFillerTokensDepleted(Data memory _data) internal pure returns (uint256) {
        return getTokensDepleted(_data, _data.filler.direction, _data.filler.startingSharesToBuy, _data.filler.sharesToBuy);
    }

    function getTokensDepleted(Data memory _data, Direction _direction, uint256 _startingSharesToBuy, uint256 _endingSharesToBuy) internal pure returns (uint256) {
        return _startingSharesToBuy
            .sub(_endingSharesToBuy)
            .mul((_direction == Direction.Long) ? _data.order.sharePriceLong : _data.order.sharePriceShort);
    }

    function getTokensToCover(Data memory _data, Direction _direction, uint256 _numShares) internal pure returns (uint256) {
        return getTokensToCover(_direction, _data.order.sharePriceLong, _data.order.sharePriceShort, _numShares);
    }

    //
    // Construction helpers
    //

    function getContracts(StoredContracts memory _storedContracts, IMarket _market, uint256 _outcome) private view returns (Contracts memory) {
        return Contracts({
            orders: _storedContracts.orders,
            market: _market,
            denominationToken: _storedContracts.denominationToken,
            augur: _storedContracts.augur,
            augurTrading: _storedContracts.augurTrading,
            universe: _market.getUniverse(),
            profitLoss: _storedContracts.profitLoss,
            shareToken: _storedContracts.shareToken
        });
    }

    function getOrder(Contracts memory _contracts, uint256 _outcome, uint256 _price, bytes32 _orderId) private view returns (FilledOrder memory) {
        uint256 _sharePriceRange;
        uint256 _sharePriceLong;
        uint256 _sharePriceShort;
        (_sharePriceRange, _sharePriceLong, _sharePriceShort) = getSharePriceDetails(_contracts.market, _price);
        return FilledOrder({
            orderId: _orderId,
            outcome: _outcome,
            sharePriceRange: _sharePriceRange,
            sharePriceLong: _sharePriceLong,
            sharePriceShort: _sharePriceShort
        });
    }

    function getMaker(uint256 _sharesEscrowed, uint256 _amount, address _creator, Order.Types _orderOrderType) private pure returns (Participant memory) {
        Direction _direction ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _sharesToBuy ;	//inject UNINIT LOCAL/STATE VAR

        return Participant({
            participantAddress: _creator,
            direction: _direction,
            startingSharesToSell: _sharesEscrowed,
            startingSharesToBuy: _sharesToBuy,
            sharesToSell: _sharesEscrowed,
            sharesToBuy: _sharesToBuy
        });
    }

    function getFiller(Contracts memory _contracts, uint256 _longOutcome, uint256[] memory _shortOutcomes, Order.Types _orderOrderType, address _address, uint256 _size) private view returns (Participant memory) {
        Direction _direction ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _sharesToSell ;	//inject UNINIT LOCAL/STATE VAR

        _sharesToSell = getFillerSharesToSell(_contracts, _longOutcome, _shortOutcomes, _address, _direction, _size);
        uint256 _sharesToBuy ;	//inject UNINIT LOCAL/STATE VAR

        return Participant({
            participantAddress: _address,
            direction: _direction,
            startingSharesToSell: _sharesToSell,
            startingSharesToBuy: _sharesToBuy,
            sharesToSell: _sharesToSell,
            sharesToBuy: _sharesToBuy
        });
    }

    function getTokensToCover(Direction _direction, uint256 _sharePriceLong, uint256 _sharePriceShort, uint256 _numShares) internal pure returns (uint256) {
        return _numShares.mul((_direction == Direction.Long) ? _sharePriceLong : _sharePriceShort);
    }

    function getSharePriceDetails(IMarket _market, uint256 _price) private view returns (uint256 _sharePriceRange, uint256 _sharePriceLong, uint256 _sharePriceShort) {
        uint256 _numTicks ;	//inject UNINIT LOCAL/STATE VAR

        _sharePriceShort = uint256(_numTicks.sub(_price));
        return (_numTicks, _price, _sharePriceShort);
    }

    function getFillerSharesToSell(Contracts memory _contracts, uint256 _longOutcome, uint256[] memory _shortOutcomes, address _filler, Direction _fillerDirection, uint256 _fillerSize) private view returns (uint256) {
        if (_fillerDirection == Direction.Short) {
            return _contracts.shareToken.balanceOfMarketOutcome(_contracts.market, _longOutcome, _filler).min(_fillerSize);
        }
        return _contracts.shareToken.lowestBalanceOfMarketOutcomes(_contracts.market, _shortOutcomes, _filler).min(_fillerSize);
    }
}

contract FillOrder is Initializable, ReentrancyGuard, IFillOrder {
    using SafeMathUint256 for uint256;
    using Trade for Trade.Data;

    IAugur public augur;
    IAugurTrading public augurTrading;
    address public zeroXTrade;
    address public trade;

    Trade.StoredContracts private storedContracts;

    mapping (address => uint256[]) public marketOutcomeVolumes;
    mapping (address => uint256) public marketTotalTrades;

    uint256 private constant MAX_APPROVAL_AMOUNT = 2 ** 256 - 1;

    function initialize(IAugur _augur, IAugurTrading _augurTrading) public beforeInitialized {
        endInitialization();
        augur = _augur;
        augurTrading = _augurTrading;
        ICash _cash ;	//inject UNINIT LOCAL/STATE VAR

        storedContracts = Trade.StoredContracts({
            augur: _augur,
            augurTrading: _augurTrading,
            orders: IOrders(_augurTrading.lookup("Orders")),
            denominationToken: _cash,
            profitLoss: IProfitLoss(_augurTrading.lookup("ProfitLoss")),
            shareToken: IShareToken(_augur.lookup("ShareToken"))
        });
        require(storedContracts.orders != IOrders(0));
        require(storedContracts.profitLoss != IProfitLoss(0));
        require(storedContracts.shareToken != IShareToken(0));
        trade = _augurTrading.lookup("Trade");
        require(trade != address(0));
        zeroXTrade = _augurTrading.lookup("ZeroXTrade");
        require(zeroXTrade != address(0));
        _cash.approve(address(_augur), MAX_APPROVAL_AMOUNT);
    }

    /**
     * @notice Fill an order
     * @param _orderId The id of the order to fill
     * @param _amountFillerWants The number of attoShares desired
     * @param _tradeGroupId A Bytes32 value used when attempting to associate multiple orderbook actions with a single TX
     * @param _fingerprint Fingerprint of the filler used to naively restrict affiliate fee dispursement
     * @return The amount remaining the filler wants
     */
    function publicFillOrder(bytes32 _orderId, uint256 _amountFillerWants, bytes32 _tradeGroupId, bytes32 _fingerprint) external returns (uint256) {
        address _filler ;	//inject UNINIT LOCAL/STATE VAR

        Trade.Data memory _tradeData = Trade.create(storedContracts, _orderId, _filler, _amountFillerWants, _fingerprint);
        (uint256 _amountRemaining, uint256 _fees) = fillOrderInternal(_filler, _tradeData, _amountFillerWants, _tradeGroupId);
        return _amountRemaining;
    }

    function fillOrder(address _filler, bytes32 _orderId, uint256 _amountFillerWants, bytes32 _tradeGroupId, bytes32 _fingerprint) external returns (uint256) {
        require(msg.sender == trade);
        Trade.Data memory _tradeData = Trade.create(storedContracts, _orderId, _filler, _amountFillerWants, _fingerprint);
        (uint256 _amountRemaining, uint256 _fees) = fillOrderInternal(_filler, _tradeData, _amountFillerWants, _tradeGroupId);
        return _amountRemaining;
    }

    function fillZeroXOrder(IMarket _market, uint256 _outcome, uint256 _price, Order.Types _orderType, address _creator, uint256 _amount, bytes32 _fingerprint, bytes32 _tradeGroupId, address _filler) external returns (uint256 _amountRemaining, uint256 _fees) {
        require(msg.sender == zeroXTrade);
        require(augur.isKnownMarket(_market));
        Trade.OrderData memory _orderData = Trade.createOrderData(storedContracts.shareToken, _market, _outcome, _price, _orderType, _amount, _creator);
        Trade.Data memory _tradeData = Trade.createWithData(storedContracts, _orderData, _filler, _amount, _fingerprint);
        return fillOrderInternal(_filler, _tradeData, _amount, _tradeGroupId);
    }


    function fillOrderInternal(address _filler, Trade.Data memory _tradeData, uint256 _amountFillerWants, bytes32 _tradeGroupId) internal nonReentrant returns (uint256 _amountRemainingFillerWants, uint256 _totalFees) {
        uint256 _marketCreatorFees;
        uint256 _reporterFees;

        (_marketCreatorFees, _reporterFees) = _tradeData.tradeMakerSharesForFillerShares();
        _tradeData.tradeMakerTokensForFillerShares();
        _tradeData.tradeMakerSharesForFillerTokens();
        uint256 _tokensRefunded ;	//inject UNINIT LOCAL/STATE VAR


        sellCompleteSets(_tradeData);

        uint256 _amountRemainingFillerWants ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _amountFilled ;	//inject UNINIT LOCAL/STATE VAR

        if (_tradeData.order.orderId != bytes32(0)) {
            _tradeData.contracts.orders.recordFillOrder(_tradeData.order.orderId, _tradeData.getMakerSharesDepleted(), _tradeData.getMakerTokensDepleted(), _amountFilled);
        }
        _totalFees = _marketCreatorFees.add(_reporterFees);
        if (_tradeData.order.orderId != bytes32(0)) {
            logOrderFilled(_tradeData, _tradeData.order.sharePriceLong, _totalFees, _amountFilled, _tradeGroupId);
        }
        logAndUpdateVolume(_tradeData);
        if (_totalFees > 0) {
            uint256 _longFees ;	//inject UNINIT LOCAL/STATE VAR

            uint256 _shortFees ;	//inject UNINIT LOCAL/STATE VAR

            _tradeData.contracts.profitLoss.adjustTraderProfitForFees(_tradeData.contracts.market, _tradeData.getLongShareBuyerDestination(), _tradeData.order.outcome, _longFees);
            _tradeData.contracts.profitLoss.adjustTraderProfitForFees(_tradeData.contracts.market, _tradeData.getShortShareBuyerDestination(), _tradeData.order.outcome, _shortFees);
        }
        updateProfitLoss(_tradeData, _amountFilled);
        if (_tradeData.creator.participantAddress == _tradeData.filler.participantAddress) {
            _tradeData.contracts.profitLoss.recordFrozenFundChange(_tradeData.contracts.universe, _tradeData.contracts.market, _tradeData.creator.participantAddress, _tradeData.order.outcome, -int256(_tokensRefunded));
        }

        return (_amountRemainingFillerWants, _totalFees);
    }

    function sellCompleteSets(Trade.Data memory _tradeData) internal returns (bool) {
        address _filler ;	//inject UNINIT LOCAL/STATE VAR

        address _creator ;	//inject UNINIT LOCAL/STATE VAR

        IMarket _market ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _numOutcomes ;	//inject UNINIT LOCAL/STATE VAR


        uint256[] memory _outcomes = new uint256[](_numOutcomes);
        for (uint256 _i ; _i < _numOutcomes; _i++) {	//inject UNINIT LOCAL/STATE VAR

            _outcomes[_i] = _i;
        }
        uint256 _fillerCompleteSets ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _creatorCompleteSets ;	//inject UNINIT LOCAL/STATE VAR


        if (_fillerCompleteSets > 0) {
            _tradeData.contracts.shareToken.sellCompleteSets(_market, _filler, _filler, _fillerCompleteSets, _tradeData.fingerprint);
        }

        if (_creatorCompleteSets > 0) {
            _tradeData.contracts.shareToken.sellCompleteSets(_market, _creator, _creator, _creatorCompleteSets, _tradeData.fingerprint);
        }

        return true;
    }

    function logOrderFilled(Trade.Data memory _tradeData, uint256 _price, uint256 _fees, uint256 _amountFilled, bytes32 _tradeGroupId) private returns (bool) {
        _tradeData.contracts.augurTrading.logOrderFilled(_tradeData.contracts.universe, _tradeData.creator.participantAddress, _tradeData.filler.participantAddress, _price, _fees, _amountFilled, _tradeData.order.orderId, _tradeGroupId);
        return true;
    }

    function logAndUpdateVolume(Trade.Data memory _tradeData) private {
        IMarket _market ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _makerSharesDepleted ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _fillerSharesDepleted ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _makerTokensDepleted ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _fillerTokensDepleted ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _completeSetTokens ;	//inject UNINIT LOCAL/STATE VAR

        if (marketOutcomeVolumes[address(_market)].length == 0) {
            marketOutcomeVolumes[address(_market)].length = _tradeData.shortOutcomes.length + 1;
        }
        marketOutcomeVolumes[address(_market)][_tradeData.order.outcome] = marketOutcomeVolumes[address(_market)][_tradeData.order.outcome].add(_makerTokensDepleted).add(_fillerTokensDepleted).add(_completeSetTokens);

        uint256[] memory tmpMarketOutcomeVolumes = marketOutcomeVolumes[address(_market)];
        uint256 _volume;
        for (uint256 i ; i < tmpMarketOutcomeVolumes.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            _volume += tmpMarketOutcomeVolumes[i];
        }

        uint256 _totalTrades ;	//inject UNINIT LOCAL/STATE VAR


        marketTotalTrades[address(_market)] = _totalTrades;

        _tradeData.contracts.augurTrading.logMarketVolumeChanged(_tradeData.contracts.universe, address(_market), _volume, tmpMarketOutcomeVolumes, _totalTrades);
    }

    function updateProfitLoss(Trade.Data memory _tradeData, uint256 _amountFilled) private returns (bool) {
        uint256 makerTokensDepleted ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _numLongTokens ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _numShortTokens ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _numLongShares ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _numShortShares ;	//inject UNINIT LOCAL/STATE VAR

        _tradeData.contracts.profitLoss.recordTrade(_tradeData.contracts.universe, _tradeData.contracts.market, _tradeData.getLongShareBuyerDestination(), _tradeData.getShortShareBuyerDestination(), _tradeData.order.outcome, int256(_amountFilled), int256(_tradeData.order.sharePriceLong), _numLongTokens, _numShortTokens, _numLongShares, _numShortShares);
        return true;
    }

    function getMarketOutcomeValues(IMarket _market) public view returns (uint256[] memory) {
        return marketOutcomeVolumes[address(_market)];
    }

    function getMarketVolume(IMarket _market) public view returns (uint256) {
        uint256[] memory tmpMarketOutcomeVolumes = marketOutcomeVolumes[address(_market)];
        uint256 _volume;
        for (uint256 i ; i < tmpMarketOutcomeVolumes.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            _volume += tmpMarketOutcomeVolumes[i];
        }
        return _volume;
    }
}