pragma solidity 0.5.4;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
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

/**
 * @title Helps contracts guard against reentrancy attacks.
 * @author Remco Bloemen <remco@21.com>, Eenae <alexey@mixbytes.io>
 * @dev If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter);
    }
}

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
        require(b <= a);
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



// ==========================================================
// Copyright 2018 Confideal Ltd. All rights reserved.
// ==========================================================

contract OTCDeal is ReentrancyGuard {
    using SafeMath for uint256;

    uint8 constant public version = 1;

    enum Status {
        Running,
        CloseoutProposed,
        ClosedOut,
        Terminated,
        Arbitration,
        Resolved
    }

    Status public status = Status.Running;
    uint32 public statusTime = uint32(now);
    uint32 public paymentDeadline; // timestamp

    bytes32[] public dataHashes;

    address payable public seller;
    address payable public buyer;
    address public sellerPartner;
    address public buyerPartner;

    uint256 public price;
    uint256 public deskFee;
    uint256 public closeoutCredit;

    bool public isRefundBySellerSet;
    bool public isRefundByBuyerSet;
    bool public sellerAssetSent;
    bool public buyerAssetSent;
    uint256 public refundBySeller;
    uint256 public refundByBuyer;
    uint256 public sellerAsset;
    uint256 public buyerAsset;

    bytes32 public claimHash;

    OTCDesk private desk;

    event PaymentDeadlineProlongation();
    event CloseoutProposition();
    event Closeout();
    event Termination();
    event Arbitration();
    event DisputeResolution();
    event SellerAssetWithdrawal();
    event BuyerAssetWithdrawal();

    constructor(
        bytes32 _dataHash,
        address payable _seller,
        address payable _buyer,
        address _sellerPartner,
        address _buyerPartner,
        uint256 _price,
        uint32 _paymentWindow,
        bool _buyerIsTaker
    )
    public
    payable
    {
        deskFee = _price.div(100);

        if (_buyerIsTaker) {
            require(msg.value == _price.add(deskFee));
        } else {
            require(msg.value == _price);
        }

        desk = OTCDesk(msg.sender);

        dataHashes.push(_dataHash);
        seller = _seller;
        buyer = _buyer;
        sellerPartner = _sellerPartner;
        buyerPartner = _buyerPartner;
        price = _price;
        paymentDeadline = uint32(now.add(_paymentWindow));
    }

    function transferCloseoutCredit()
    external
    payable
    nonReentrant
    {
        require(msg.sender == address(desk));
        closeoutCredit = closeoutCredit.add(msg.value);
        require(buyer.send(closeoutCredit));
    }

    function prolong(uint32 _paymentWindow, bytes32 _dataHash)
    external
    {
        require(status == Status.Running);
        require(msg.sender == seller);

        uint32 newDeadline = uint32(now.add(_paymentWindow));
        require(newDeadline >= paymentDeadline);

        dataHashes.push(_dataHash);
        paymentDeadline = newDeadline;
        emit PaymentDeadlineProlongation();
    }

    function terminate()
    external
    nonReentrant
    {
        if (msg.sender == buyer) {
            require(status == Status.Running || status == Status.CloseoutProposed);
        } else {
            require(msg.sender == seller);
            require(status == Status.Running);
            require(paymentDeadline < now);
        }

        emit Termination();
        status = Status.Terminated;
        statusTime = uint32(now);

        sellerAsset = address(this).balance;
        sellerAssetSent = seller.send(sellerAsset);
    }

    function closeOut(uint256 _refund)
    external
    nonReentrant
    {
        require(status == Status.Running || status == Status.CloseoutProposed);
        require(_refund <= address(this).balance.sub(deskFee));

        if (msg.sender == seller) {
            if (_refund > 0) {
                require(!isRefundBySellerSet || _refund != refundBySeller);
                isRefundBySellerSet = true;
                refundBySeller = _refund;
            }
        } else {
            require(msg.sender == buyer);
            require(!isRefundByBuyerSet || _refund != refundByBuyer);
            isRefundByBuyerSet = true;
            refundByBuyer = _refund;
        }

        if (msg.sender == buyer || _refund > 0) {
            emit CloseoutProposition();
            if (status == Status.Running) {
                status = Status.CloseoutProposed;
                statusTime = uint32(now);
            }
        }

        if ((isRefundBySellerSet && isRefundByBuyerSet && refundBySeller == refundByBuyer)
            || (_refund == 0 && msg.sender == seller)) {
            emit Closeout();
            status = Status.ClosedOut;
            statusTime = uint32(now);

            transferAssets(_refund);
        }
    }


    function escalate(bytes32 _claimHash)
    external
    {
        require(msg.sender == seller || msg.sender == buyer);
        require(status == Status.Running || status == Status.CloseoutProposed);

        // paymentDeadline + 2 hours
        require(now >= uint256(paymentDeadline).add(7200));

        claimHash = _claimHash;

        emit Arbitration();
        status = Status.Arbitration;
        statusTime = uint32(now);

        desk.assignArbitratorFromPool();
    }

    function resolveDispute(
        bytes32 _dataHash,
        uint256 _sellerAsset
    )
    external
    nonReentrant
    {
        require(status == Status.Arbitration);
        require(msg.sender == address(desk));
        require(_sellerAsset <= address(this).balance.sub(deskFee));

        emit DisputeResolution();
        status = Status.Resolved;
        statusTime = uint32(now);

        dataHashes.push(_dataHash);

        transferAssets(_sellerAsset);
    }

    function withdrawSellerAsset()
    external
    nonReentrant
    {
        require(status == Status.ClosedOut || status == Status.Terminated || status == Status.Resolved);
        require(msg.sender == seller && sellerAsset > 0 && !sellerAssetSent);

        sellerAssetSent = unsafeTransfer(seller, sellerAsset);
        if (sellerAssetSent) {
            emit SellerAssetWithdrawal();
        }
    }

    function withdrawBuyerAsset()
    external
    nonReentrant
    {
        require(status == Status.ClosedOut || status == Status.Resolved);
        require(msg.sender == buyer && buyerAsset > 0 && !buyerAssetSent);

        buyerAssetSent = unsafeTransfer(buyer, buyerAsset);
        if (buyerAssetSent) {
            emit BuyerAssetWithdrawal();
        }
    }

    function()
    external
    {
        revert();
    }

    function transferAssets(uint256 _sellerAsset)
    private
    {
        sellerAsset = _sellerAsset;
        buyerAsset = address(this).balance.sub(deskFee).sub(sellerAsset);

        uint256 closeoutCreditReturn;
        if (closeoutCredit > 0) {
            if (buyerAsset <= closeoutCredit) {
                closeoutCreditReturn = buyerAsset;
            } else {
                closeoutCreditReturn = closeoutCredit;
            }
            buyerAsset = buyerAsset.sub(closeoutCreditReturn);
        }

        desk.collectFee.value(deskFee.add(closeoutCreditReturn))(closeoutCreditReturn);

        if (sellerAsset > 0) {
            sellerAssetSent = seller.send(sellerAsset);
        }
        if (buyerAsset > 0) {
            buyerAssetSent = buyer.send(buyerAsset);
        }
    }

    function unsafeTransfer(address _recipient, uint256 _amount)
    private
    returns (bool success)
    {
        (success,) = _recipient.call.value(_amount)("");
        return success;
    }
}


contract OTCDesk is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    uint8 constant public version = 1;

    address public beneficiary = msg.sender;
    address public arbitrationManager = msg.sender;

    uint256 public confidealFund;

    uint256 public closeoutCredit = 0.0017 ether;

    address[] public arbitratorsPool;

    mapping(address => address) public arbitrators; // deal => arbitrator

    event DealCreation(address deal);
    event FeePayment(address deal, uint256 amount);
    event CloseoutCreditIssuance(address deal, uint256 amount);
    event CloseoutCreditCollection(address deal, uint256 amount);
    event ArbitratorAssignment(address deal, address arbitrator);

    function newDeal(
        bytes32 _dataHash,
        address payable _buyer,
        address _sellerPartner,
        address _buyerPartner,
        uint256 _price,
        uint32 _paymentWindow,
        bool _buyerIsTaker
    )
    public
    payable
    {
        OTCDeal _deal = (new OTCDeal).value(msg.value)(
            _dataHash,
            msg.sender,
            _buyer,
            _sellerPartner,
            _buyerPartner,
            _price,
            _paymentWindow,
            _buyerIsTaker
        );

        emit DealCreation(address(_deal));

        if (_buyer.balance < closeoutCredit) {
            uint256 _closeoutCredit = closeoutCredit.sub(_buyer.balance);
            if (confidealFund >= _closeoutCredit) {
                confidealFund = confidealFund.sub(_closeoutCredit);
                _deal.transferCloseoutCredit.value(_closeoutCredit)();
                emit CloseoutCreditIssuance(address(_deal), _closeoutCredit);
            }
        }
    }

    function setBeneficiary(address _beneficiary)
    external
    onlyOwner
    {
        beneficiary = _beneficiary;
    }

    function setArbitrationManager(address _arbitrationManager)
    external
    onlyOwner
    {
        arbitrationManager = _arbitrationManager;
    }

    function setCloseoutCredit(uint256 _closeoutCredit)
    external
    onlyOwner
    {
        closeoutCredit = _closeoutCredit;
    }

    function collectFee(uint256 _closeoutCreditReturn)
    external
    payable
    {
        uint256 fee = msg.value.sub(_closeoutCreditReturn);
        confidealFund = confidealFund.add(fee);
        emit FeePayment(msg.sender, fee);

        if (_closeoutCreditReturn > 0) {
            confidealFund = confidealFund.add(_closeoutCreditReturn);	//injected INTEGER OVERFLOW OR UNDERFLOW

            emit CloseoutCreditCollection(msg.sender, _closeoutCreditReturn);
        }
    }

    function arbitratorsPoolSize()
    external
    view
    returns (uint)
    {
        return arbitratorsPool.length;
    }

    function addArbitratorToPool(address _arbitrator)
    external
    {
        require(msg.sender == arbitrationManager);

        arbitratorsPool.push(_arbitrator);
    }

    function removeArbitratorFromPool(uint _index)
    external
    {
        require(msg.sender == arbitrationManager);
        require(arbitratorsPool.length > 0);

        arbitratorsPool[_index] = arbitratorsPool[arbitratorsPool.length - 1];
        arbitratorsPool.pop();
    }

    function assignArbitratorFromPool()
    external
    {
        if (arbitratorsPool.length == 0) {
            return;
        }

        address _arbitrator = arbitratorsPool[block.number % arbitratorsPool.length];
        arbitrators[msg.sender] = _arbitrator;
        emit ArbitratorAssignment(msg.sender, _arbitrator);
    }

    function assignArbitrator(address _deal, address _arbitrator)
    external
    {
        require(msg.sender == arbitrationManager);

        arbitrators[_deal] = _arbitrator;
        emit ArbitratorAssignment(_deal, _arbitrator);
    }

    function resolveDispute(address _deal, bytes32 _dataHash, uint256 _sellerAsset)
    external
    {
        require(msg.sender == arbitrators[_deal]);
        OTCDeal(_deal).resolveDispute(_dataHash, _sellerAsset);
    }

    function withdraw(uint256 _rest)
    external
    {
        require(msg.sender == beneficiary);

        uint256 _amount = confidealFund.sub(_rest);
        require(_amount > 0);

        confidealFund = confidealFund.sub(_amount);
        (bool _successfulTransfer,) = beneficiary.call.value(_amount)("");
        require(_successfulTransfer);
    }

    function contribute()
    external
    payable
    {
        confidealFund = confidealFund.add(msg.value);
    }

    function()
    external
    {
        revert();
    }
}