/**
 *Submitted for verification at Etherscan.io on 2020-10-29
*/

/* Keep4r 1 kp4r.network - 2020 */

pragma solidity 0.6.6;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

contract Keep4rPresale {
    using SafeMath for uint256;

    // cannot purchase until started
    bool internal started;

    IERC20 KP4R;
    address kp4rAddress;

    address internal manager;
    address internal managerPending;
    uint256 constant managerS = 80;
    uint256 internal managerWithdrawn;
    address internal overseer;
    address internal overseerPending;
    uint256 constant overseerS = 20;
    uint256 internal overseerWithdrawn;

    uint256 internal unitPrice = 1e18/2;
    uint256 internal minimumOrder = 100000;

    /** @notice the date when purchased KP4R can be claimed */
    uint256 internal unlocksOn;

    /** @notice the date when KP4R can no longer be purchased from the contract */
    uint256 internal endsOn;

    /** @notice percentage bonus actived upon purchasing more than the trigger
    * value. */
    uint256 internal bonusTrigger;
    uint256 internal bonusPercentage;

    // Stats:
    uint256 internal totalForSale;
    uint256 internal totalSold;
    uint256 internal totalSettled;
    uint256 internal weiRaised;

    mapping(address => uint256) internal balance;

    event Purchase (address indexed buyer, uint256 amount, uint256 price);

    constructor(address _kp4r) public {
        manager = msg.sender;
        overseer = msg.sender;
        KP4R = IERC20(_kp4r);
        kp4rAddress = _kp4r;
    }

    modifier onlyManager {
        require( msg.sender == manager, "Only the manager can call this function." );
        _;
    }

    modifier onlyOverseer {
        require( msg.sender == overseer, "Only the overseer can call this function.");
        _;
    }

    function transferRole(address _new) public {
        require(msg.sender == manager || msg.sender == overseer, "!manager or overseer");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if (msg.sender == manager) { managerPending = _new; return; }	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if (msg.sender == overseer) { overseerPending = _new; return; }	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function acceptRole() public {
        require(msg.sender == managerPending || msg.sender == overseerPending, "!managerPending or overseerPending");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if (msg.sender == managerPending) { manager = managerPending; managerPending = address(0); return; }	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if (msg.sender == overseerPending) { overseer = overseerPending; managerPending = address(0); return; }	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function managerSetPrice(uint256 _price) public onlyManager {
        unitPrice = _price;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function managerSetMinimum(uint256 _minimum) public onlyManager {
        minimumOrder = _minimum;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function managerSetBonus(uint256 _trigger, uint256 _percentage) public onlyManager {
        bonusTrigger = _trigger;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bonusPercentage = _percentage;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function managerDeposit(uint256 _amount) public onlyManager {
        KP4R.transferFrom(msg.sender, address(this), _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalForSale = totalForSale.add(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /** @notice manager can reclaim unsold tokens */
    function managerReclaim(uint256 _amount) public onlyManager {
        // calculate the amount of tokens that haven not been sold
        // and settled and are thus reclaimable:
        uint256 unreclaimable = totalSold.sub(totalSettled);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 reclaimable = KP4R.balanceOf(address(this)).sub(unreclaimable);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(_amount <= reclaimable, "cannot withdraw already sold tokens");

        // transfer the tokens to the manager
        KP4R.transfer(msg.sender, _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalForSale = totalForSale.sub(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function managerWithdraw(uint256 _amount) public onlyManager {
        require(managerWithdrawn.add(_amount) <= weiRaised.mul(managerS).div(100), "cannot withdraw more than the managers share");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        managerWithdrawn = managerWithdrawn.add(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        msg.sender.transfer(_amount);
    }

    function overseerWithdraw(uint _amount) public onlyOverseer {
        require(overseerWithdrawn.add(_amount) <= weiRaised.mul(overseerS).div(100), "cannot withdraw more than overseerS");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        overseerWithdrawn = overseerWithdrawn.add(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        msg.sender.transfer(_amount);
    }

    function managerClose(uint256 amount) public onlyManager {
        require(block.timestamp > endsOn.add(31536000).mul(2), "must wait until 6 months past end date");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        msg.sender.transfer(amount);
    }

    function managerForceUnlock() public onlyManager {
        unlocksOn = block.timestamp-1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function start(uint256 _unlocksOn, uint256 _endsOn, uint256 _price, uint256 _minimumOrder) public onlyManager {
        require(!started, "already started");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        unlocksOn = _unlocksOn;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        endsOn = _endsOn;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        unitPrice = _price;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        minimumOrder = _minimumOrder;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        started = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /** @notice The amount of KP4R remaining */
    function remaining() public view returns (uint256) {
        return KP4R.balanceOf(address(this));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /** @notice purchase KP4R at the current unit price */
    function purchase() public payable {
        require(started, "token sale has not yet started");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(msg.value > minimumOrder, "amount purchased is too small");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(block.timestamp < endsOn, "presale has ended");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        // calculate the amount of KP4R purchasable
        uint256 _kp4r = calculateAmountPurchased(msg.value);
        require(_kp4r <= KP4R.balanceOf(address(this)), "not enough KP4R left");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        // update the users balance
        balance[msg.sender] = balance[msg.sender].add(_kp4r);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalSold = totalSold.add(_kp4r);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        weiRaised = weiRaised.add(msg.value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        emit Purchase(msg.sender, _kp4r, msg.value);
    }

    /** @notice calculates the amount purchasedfor a given amount of eth */
    function calculateAmountPurchased(uint256 _value) public view returns (uint256) {
        uint256 _kp4r = _value.div(unitPrice).mul(1e18);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if (_value > bonusTrigger) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            uint256 _bonus = _kp4r.mul(bonusPercentage).div(1000);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            if (_kp4r.add(_bonus) <= KP4R.balanceOf(address(this))) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                _kp4r = _kp4r.add(_bonus);
            }
        }
        return _kp4r;
    }

    /** @notice claim you eth */
    function claim() public {
        require(block.timestamp > unlocksOn, "presale has not unlocked yet");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(balance[msg.sender] > 0, "nothing to withdraw");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        KP4R.transfer(msg.sender, balance[msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalSettled = totalSettled.add(balance[msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // fallbacks to allow users to send to the contract to purchase KP4R
    receive() external payable { purchase(); }
    fallback() external payable { purchase(); }
}