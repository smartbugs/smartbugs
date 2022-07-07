/**
 *Submitted for verification at Etherscan.io on 2020-10-09
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;


library Address {
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeMath {
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _owner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _owner = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}

/**
 * @dev A token holder contract that will allow a beneficiary to extract the
 * tokens at predefined intervals. Tokens not claimed at payment epochs accumulate
 * Modified version of Openzeppelin's TokenTimeLock
 */
contract Lock is Ownable {
    using SafeMath for uint;
    enum period {
        second,
        minute,
        hour,
        day,
        week,
        month, //inaccurate, assumes 30 day month, subject to drift
        year,
        quarter,//13 weeks
        biannual//26 weeks
    }
    
    //The length in seconds for each epoch between payments
    uint epochLength;
    // ERC20 basic token contract being held
    IERC20 private _token;

    // beneficiary of tokens after they are released
    address private _beneficiary;

    uint periods;

    //the size of periodic payments
    uint paymentSize;
    uint paymentsRemaining =0;
    uint startTime =0;
    uint beneficiaryBalance = 0;

    function initialize(address tokenAddress, address beneficiary, uint duration,uint durationMultiple,uint p)  public onlyOwner{
        release();
        require(paymentsRemaining == 0, 'cannot initialize during active vesting schedule');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(duration>0 && p>0, 'epoch parameters must be positive');
        _token = IERC20(tokenAddress);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _beneficiary = beneficiary;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if(duration<=uint(period.biannual)){
         
            if(duration == uint(period.second)){
                epochLength = durationMultiple * 1 seconds;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }else if(duration == uint(period.minute)){
                epochLength = durationMultiple * 1 minutes;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }
            else if(duration == uint(period.hour)){
                epochLength =  durationMultiple *1 hours;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }else if(duration == uint(period.day)){
                epochLength =  durationMultiple *1 days;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }
            else if(duration == uint(period.week)){
                epochLength =  durationMultiple *1 weeks;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }else if(duration == uint(period.month)){
                epochLength =  durationMultiple *30 days;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }else if(duration == uint(period.year)){
                epochLength =  durationMultiple *52 weeks;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }else if(duration == uint(period.quarter)){
                epochLength =  durationMultiple *13 weeks;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }
            else if(duration == uint(period.biannual)){
                epochLength = 26 weeks;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }
        }
        else{
                epochLength = duration; //custom value	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }
            periods = p;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        emit Initialized(tokenAddress,beneficiary,epochLength,p);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function deposit (uint amount) public { //remember to ERC20.approve
         require (_token.transferFrom(msg.sender,address(this),amount),'transfer failed');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
         uint balance = _token.balanceOf(address(this));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
         if(paymentsRemaining==0)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
         {
             paymentsRemaining = periods;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
             startTime = block.timestamp;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
         }
         paymentSize = balance/paymentsRemaining;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
         emit PaymentsUpdatedOnDeposit(paymentSize,startTime,paymentsRemaining);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function getElapsedReward() public view returns (uint,uint,uint){
         if(epochLength == 0)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            return (0, startTime,paymentsRemaining);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint elapsedEpochs = (block.timestamp - startTime)/epochLength;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if(elapsedEpochs==0)
            return (0, startTime,paymentsRemaining);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        elapsedEpochs = elapsedEpochs>paymentsRemaining?paymentsRemaining:elapsedEpochs;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint newStartTime = block.timestamp;
        uint newPaymentsRemaining = paymentsRemaining.sub(elapsedEpochs);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint balance  =_token.balanceOf(address(this));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint accumulatedFunds = paymentSize.mul(elapsedEpochs);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
         return (beneficiaryBalance.add(accumulatedFunds>balance?balance:accumulatedFunds),newStartTime,newPaymentsRemaining);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    } 

    function updateBeneficiaryBalance() private {
        (beneficiaryBalance,startTime, paymentsRemaining) = getElapsedReward();
    }

    function changeBeneficiary (address beneficiary) public onlyOwner{
        require (paymentsRemaining == 0, 'TokenTimelock: cannot change beneficiary while token balance positive');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _beneficiary = beneficiary;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    /**
     * @return the beneficiary of the tokens.
     */
    function beneficiary() public view returns (address) {
        return _beneficiary;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @notice Transfers tokens held by timelock to beneficiary.
     */
    function release() public {
        // solhint-disable-next-line not-rely-on-time
        require(block.timestamp >= startTime, "TokenTimelock: current time is before release time");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        updateBeneficiaryBalance();
        uint amountToSend = beneficiaryBalance;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        beneficiaryBalance = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if(amountToSend>0)
            require(_token.transfer(_beneficiary,amountToSend),'release funds failed');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit FundsReleasedToBeneficiary(_beneficiary,amountToSend,block.timestamp);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    event PaymentsUpdatedOnDeposit(uint paymentSize,uint startTime, uint paymentsRemaining);
    event Initialized (address tokenAddress, address beneficiary, uint duration,uint periods);
    event FundsReleasedToBeneficiary(address beneficiary, uint value, uint timeStamp);
}