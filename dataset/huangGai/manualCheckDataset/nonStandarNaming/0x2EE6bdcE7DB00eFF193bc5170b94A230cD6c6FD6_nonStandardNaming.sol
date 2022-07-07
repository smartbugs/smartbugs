                                                                 

// File: contracts/vaults/IStrategy.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

pragma solidity 0.5.17;


interface istrategy59 {	//inject NONSTANDARD NAMING
    function GETNAME35() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function WANT31() external view returns (address);	//inject NONSTANDARD NAMING
    function WITHDRAW24(address) external;	//inject NONSTANDARD NAMING
    function WITHDRAW24(uint256) external;	//inject NONSTANDARD NAMING
    function WITHDRAWALL24() external returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF3() external view returns (uint256);	//inject NONSTANDARD NAMING
}

// File: contracts/IERC20.sol

//SPDX-License-Identifier: GPL-3.0-only

pragma solidity 0.5.17;


                                                                                                                                                      
interface ierc2080 {	//inject NONSTANDARD NAMING
                                                                      
    function TOTALSUPPLY74() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF3(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER92(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE58(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE17(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM23(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER57(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL94(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: contracts/ITreasury.sol

pragma solidity 0.5.17;



interface itreasury2 {	//inject NONSTANDARD NAMING
    function DEFAULTTOKEN28() external view returns (ierc2080);	//inject NONSTANDARD NAMING
    function DEPOSIT94(ierc2080 token, uint256 amount) external;	//inject NONSTANDARD NAMING
    function WITHDRAW24(uint256 amount, address withdrawAddress) external;	//inject NONSTANDARD NAMING
}

// File: contracts/vaults/IVault.sol

pragma solidity 0.5.17;



interface ivault53 {	//inject NONSTANDARD NAMING
    function WANT31() external view returns (ierc2080);	//inject NONSTANDARD NAMING
    function TRANSFERFUNDSTOSTRATEGY94(address strategy, uint256 amount) external;	//inject NONSTANDARD NAMING
    function AVAILABLEFUNDS75() external view returns (uint256);	//inject NONSTANDARD NAMING
}

// File: contracts/vaults/IVaultRewards.sol

pragma solidity 0.5.17;



interface ivaultrewards63 {	//inject NONSTANDARD NAMING
    function WANT31() external view returns (ierc2080);	//inject NONSTANDARD NAMING
    function NOTIFYREWARDAMOUNT2(uint256 reward) external;	//inject NONSTANDARD NAMING
}

// File: contracts/vaults/IController.sol

pragma solidity 0.5.17;






interface icontroller20 {	//inject NONSTANDARD NAMING
    function CURRENTEPOCHTIME27() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF3(address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function REWARDS0(address token) external view returns (ivaultrewards63);	//inject NONSTANDARD NAMING
    function VAULT69(address token) external view returns (ivault53);	//inject NONSTANDARD NAMING
    function ALLOWABLEAMOUNT15(address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TREASURY79() external view returns (itreasury2);	//inject NONSTANDARD NAMING
    function APPROVEDSTRATEGIES44(address, address) external view returns (bool);	//inject NONSTANDARD NAMING
    function GETHARVESTINFO14(address strategy, address user)	//inject NONSTANDARD NAMING
        external view returns (
        uint256 vaultRewardPercentage,
        uint256 hurdleAmount,
        uint256 harvestPercentage
    );
    function WITHDRAW24(address, uint256) external;	//inject NONSTANDARD NAMING
    function EARN37(address, uint256) external;	//inject NONSTANDARD NAMING
    function INCREASEHURDLERATE27(address token) external;	//inject NONSTANDARD NAMING
}

// File: contracts/ISwapRouter.sol

//SPDX-License-Identifier: GPL-3.0-only

pragma solidity 0.5.17;


interface swaprouter18 {	//inject NONSTANDARD NAMING
    function WETH90() external pure returns (address);	//inject NONSTANDARD NAMING
    function SWAPEXACTTOKENSFORTOKENS91(	//inject NONSTANDARD NAMING
      uint amountIn,
      uint amountOutMin,
      address[] calldata path,
      address to,
      uint deadline
    ) external returns (uint[] memory amounts);
}

// File: contracts/SafeMath.sol

pragma solidity 0.5.17;

// Note: This file has been modified to include the sqrt function for quadratic voting
                                                                         
library math29 {	//inject NONSTANDARD NAMING
                                                               
    function MAX82(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a >= b ? a : b;
    }

                                                                
    function MIN43(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a < b ? a : b;
    }

                                                                                                          
    function AVERAGE17(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }

                                                                                                                                                                          
   function SQRT87(uint256 x) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
       uint256 n = x / 2;
       uint256 lstX = 0;
       while (n != lstX){
           lstX = n;
           n = (n + x/n) / 2;
       }
       return uint256(n);
   }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library safemath85 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                             
    function ADD14(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB75(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB75(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                                                             
    function SUB75(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL41(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV62(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV62(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function DIV62(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD3(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD3(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function MOD3(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/zeppelin/Address.sol

pragma solidity 0.5.17;


                                                                   
library address35 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT42(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

                                                                                                                                                                                                          
    function TOPAYABLE96(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function SENDVALUE71(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: contracts/zeppelin/SafeERC20.sol

pragma solidity 0.5.17;




                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
library safeerc2099 {	//inject NONSTANDARD NAMING
    using safemath85 for uint256;
    using address35 for address;

    function SAFETRANSFER62(ierc2080 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN65(token, abi.encodeWithSelector(token.TRANSFER92.selector, to, value));
    }

    function SAFETRANSFERFROM40(ierc2080 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN65(token, abi.encodeWithSelector(token.TRANSFERFROM23.selector, from, to, value));
    }

    function SAFEAPPROVE5(ierc2080 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE58(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN65(token, abi.encodeWithSelector(token.APPROVE17.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE71(ierc2080 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE58(address(this), spender).ADD14(value);
        CALLOPTIONALRETURN65(token, abi.encodeWithSelector(token.APPROVE17.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE44(ierc2080 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE58(address(this), spender).SUB75(value, "SafeERC20: decreased allowance below zero");
        CALLOPTIONALRETURN65(token, abi.encodeWithSelector(token.APPROVE17.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function CALLOPTIONALRETURN65(ierc2080 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).ISCONTRACT42(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts/vaults/strategy/MStableStrategy.sol

//SPDX-License-Identifier: MIT
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

pragma solidity 0.5.17;






interface ibpt3 {	//inject NONSTANDARD NAMING
    function TOTALSUPPLY74() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF3(address whom) external view returns (uint);	//inject NONSTANDARD NAMING
    function GETSPOTPRICE26(address tokenIn, address tokenOut) external view returns (uint spotPrice);	//inject NONSTANDARD NAMING
    function SWAPEXACTAMOUNTIN69(address, uint, address, uint, uint) external returns (uint, uint);	//inject NONSTANDARD NAMING
    function SWAPEXACTAMOUNTOUT77(address, uint, address, uint, uint) external returns (uint, uint);	//inject NONSTANDARD NAMING
    function JOINSWAPEXTERNAMOUNTIN73(	//inject NONSTANDARD NAMING
        address tokenIn,
        uint tokenAmountIn,
        uint minPoolAmountOut
    ) external returns (uint poolAmountOut);
    function EXITSWAPEXTERNAMOUNTOUT85(	//inject NONSTANDARD NAMING
        address tokenOut,
        uint tokenAmountOut,
        uint maxPoolAmountIn
    ) external returns (uint poolAmountIn);
    function EXITSWAPPOOLAMOUNTIN6(	//inject NONSTANDARD NAMING
        address tokenOut,
        uint poolAmountIn,
        uint minAmountOut
    ) external returns (uint tokenAmountOut);
}

interface impool6 {	//inject NONSTANDARD NAMING
    function BALANCEOF3(address _account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function EARNED23(address _account) external view returns (uint256, uint256);	//inject NONSTANDARD NAMING
    function STAKE12(uint256 _amount) external;	//inject NONSTANDARD NAMING
    function CLAIMREWARD81() external;	//inject NONSTANDARD NAMING
    function EXIT39() external;	//inject NONSTANDARD NAMING
}

interface imtagov79 {	//inject NONSTANDARD NAMING
    function BALANCEOF3(address _account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function EARNED23(address _account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function CREATELOCK73(uint256 _value, uint256 _unlockTime) external;	//inject NONSTANDARD NAMING
    function WITHDRAW24() external;	//inject NONSTANDARD NAMING
    function INCREASELOCKAMOUNT91(uint256 _value) external;	//inject NONSTANDARD NAMING
    function CLAIMREWARD81() external;	//inject NONSTANDARD NAMING
}


contract mstablestrat66 is istrategy59 {	//inject NONSTANDARD NAMING
    using safeerc2099 for ierc2080;
    using address35 for address;
    using safemath85 for uint256;

    uint256 public constant performance_fee63 = 500; // 5%	//inject NONSTANDARD NAMING
    uint256 public constant denom43 = 10000;	//inject NONSTANDARD NAMING
    uint256 public hurdleLastUpdateTime;
    uint256 public harvestAmountThisEpoch;
    uint256 public strategistCollectedFee;
    uint256 public numPools = 1;

    ierc2080 internal usdc = ierc2080(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    ierc2080 internal musd = ierc2080(0xe2f2a5C287993345a840Db3B0845fbC70f5935a5);
    ierc2080 internal mta = ierc2080(0xa3BeD4E1c75D00fa6f4E5E6922DB7261B5E9AcD2);

    ibpt3 internal musdcBpt = ibpt3(0x72Cd8f4504941Bf8c5a21d1Fd83A96499FD71d2C);

    swaprouter18 public swapRouter = swaprouter18(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    impool6 internal mPool = impool6(0x881c72D1e6317f10a1cDCBe05040E7564E790C80);
    imtagov79 internal mtaGov = imtagov79(0xaE8bC96DA4F9A9613c323478BE181FDb2Aa0E1BF);

    ierc2080 public want = usdc; // should be set only in constructor or hardcoded
    icontroller20 public controller; // should be set only in constructor

    address public strategist; // mutable, but only by strategist

    // want must be equal to an underlying vault token (Eg. USDC)
    constructor(icontroller20 _controller) public {
        controller = _controller;
        strategist = msg.sender;
    }

    function GETNAME35() external pure returns (string memory) {	//inject NONSTANDARD NAMING
        return "MstableStrategy";
    }

    function SETSTRATEGIST71(address _strategist) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist, "!strategist");
        strategist = _strategist;
    }

    function SETNUMPOOLSFORSWAP74(uint256 _numPools) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist, "!strategist");
        numPools = _numPools;
    }

    function SETALLOWANCES18(ierc2080 token, address[] calldata recipients, bool isIncrease) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist, "!strategist");
        for (uint i = 0; i < recipients.length; i++) {
            require(
                recipients[i] == address(musdcBpt) ||
                recipients[i] == address(swapRouter) ||
                recipients[i] == address(mPool) ||
                recipients[i] == address(mtaGov),
                "bad recipient"
            );
            uint256 allowance = isIncrease ? uint256(-1) : 0;
            token.SAFEAPPROVE5(recipients[i], allowance);
        }
    }

    // Assumed that caller checks against available funds in vault
    function DEPOSIT94(uint256 amount) public {	//inject NONSTANDARD NAMING
        uint256 availFunds = controller.ALLOWABLEAMOUNT15(address(this));
        require(amount <= availFunds, "exceed contAllowance");
        controller.EARN37(address(this), amount);

        // deposit into musdcBpt
        uint256 bptTokenAmt = musdcBpt.JOINSWAPEXTERNAMOUNTIN73(address(want), amount, 0);

        // deposit into mstable pool
        mPool.STAKE12(bptTokenAmt);

        // deposit any MTA token in this contract into mStaking contract
        DEPOSITMTAINSTAKING28();
    }

    function BALANCEOF3() external view returns (uint256) {	//inject NONSTANDARD NAMING
        // get balance in mPool
        uint256 bptStakeAmt = mPool.BALANCEOF3(address(this));

        // get usdc + musd amts in BPT, and total BPT
        uint256 usdcAmt = usdc.BALANCEOF3(address(musdcBpt));
        uint256 musdAmt = musd.BALANCEOF3(address(musdcBpt));
        uint256 totalBptAmt = musdcBpt.TOTALSUPPLY74();

        // convert musd to usdc
        usdcAmt = usdcAmt.ADD14(
            musdAmt.MUL41(1e18).DIV62(musdcBpt.GETSPOTPRICE26(address(musd), address(usdc)))
        );

        return bptStakeAmt.MUL41(usdcAmt).DIV62(totalBptAmt);
    }

    function EARNED23() external view returns (uint256) {	//inject NONSTANDARD NAMING
        (uint256 earnedAmt,) = mPool.EARNED23(address(this));
        return earnedAmt.ADD14(mtaGov.EARNED23(address(this)));
    }

    function WITHDRAW24(address token) external {	//inject NONSTANDARD NAMING
        ierc2080 erc20Token = ierc2080(token);
        require(msg.sender == address(controller), "!controller");
        erc20Token.SAFETRANSFER62(address(controller), erc20Token.BALANCEOF3(address(this)));
    }

    function WITHDRAW24(uint256 amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == address(controller), "!controller");

        // exit fully
        mPool.EXIT39();

        // convert to desired amount
        musdcBpt.EXITSWAPEXTERNAMOUNTOUT85(address(want), amount, uint256(-1));

        // deposit whatever remaining bpt back into mPool
        mPool.STAKE12(musdcBpt.BALANCEOF3(address(this)));

        // send funds to vault
        want.SAFETRANSFER62(address(controller.VAULT69(address(want))), amount);
    }

    function WITHDRAWALL24() external returns (uint256 balance) {	//inject NONSTANDARD NAMING
        require(msg.sender == address(controller), "!controller");

        // exit fully
        mPool.EXIT39();

        // convert reward to want tokens
        // in case swap fails, continue
        (bool success, ) = address(this).call(
            abi.encodeWithSignature(
                "exchangeRewardForWant(bool)",
                true
            )
        );
        // to remove compiler warning
        success;

        // convert bpt to want tokens
        musdcBpt.EXITSWAPPOOLAMOUNTIN6(
            address(want),
            musdcBpt.BALANCEOF3(address(this)),
            0
        );

        // exclude collected strategist fee
        balance = want.BALANCEOF3(address(this)).SUB75(strategistCollectedFee);
        // send funds to vault
        want.SAFETRANSFER62(address(controller.VAULT69(address(want))), balance);
    }

    function HARVEST87(bool claimMPool, bool claimGov) external {	//inject NONSTANDARD NAMING
        if (claimMPool) mPool.CLAIMREWARD81();
        if (claimGov) mtaGov.CLAIMREWARD81();

        // convert 80% reward to want tokens
        // in case swap fails, return
        (bool success, ) = address(this).call(
            abi.encodeWithSignature(
                "exchangeRewardForWant(bool)",
                false
            )
        );
        // to remove compiler warning
        if (!success) return;

        uint256 amount = want.BALANCEOF3(address(this)).SUB75(strategistCollectedFee);
        uint256 vaultRewardPercentage;
        uint256 hurdleAmount;
        uint256 harvestPercentage;
        uint256 epochTime;
        (vaultRewardPercentage, hurdleAmount, harvestPercentage) =
            controller.GETHARVESTINFO14(address(this), msg.sender);

        // check if harvest amount has to be reset
        if (hurdleLastUpdateTime < epochTime) {
            // reset collected amount
            harvestAmountThisEpoch = 0;
        }
        // update variables
        hurdleLastUpdateTime = block.timestamp;
        harvestAmountThisEpoch = harvestAmountThisEpoch.ADD14(amount);

        // first, take harvester fee
        uint256 harvestFee = amount.MUL41(harvestPercentage).DIV62(denom43);
        want.SAFETRANSFER62(msg.sender, harvestFee);

        uint256 fee;
        // then, if hurdle amount has been exceeded, take performance fee
        if (harvestAmountThisEpoch >= hurdleAmount) {
            fee = amount.MUL41(performance_fee63).DIV62(denom43);
            strategistCollectedFee = strategistCollectedFee.ADD14(fee);
        }

        // do the subtraction of harvester and strategist fees
        amount = amount.SUB75(harvestFee).SUB75(fee);

        // calculate how much is to be re-invested
        // fee = vault reward amount, reusing variable
        fee = amount.MUL41(vaultRewardPercentage).DIV62(denom43);
        want.SAFETRANSFER62(address(controller.REWARDS0(address(want))), fee);
        controller.REWARDS0(address(want)).NOTIFYREWARDAMOUNT2(fee);
        amount = amount.SUB75(fee);

        // finally, use remaining want amount for reinvestment
        amount = musdcBpt.JOINSWAPEXTERNAMOUNTIN73(address(want), amount, 0);

        // deposit into mstable pool
        mPool.STAKE12(amount);

        // deposit any MTA token in this contract into mStaking contract
        DEPOSITMTAINSTAKING28();
    }

    function WITHDRAWSTRATEGISTFEE97() external {	//inject NONSTANDARD NAMING
        strategistCollectedFee = 0;
        want.SAFETRANSFER62(strategist, strategistCollectedFee);
    }

    function EXITMGOV72() external {	//inject NONSTANDARD NAMING
        mtaGov.WITHDRAW24();
        // convert to want tokens
        // in case swap fails, continue
        (bool success, ) = address(this).call(
            abi.encodeWithSignature(
                "exchangeRewardForWant(bool)",
                true
            )
        );
        // to remove compiler warning
        success;
        want.SAFETRANSFER62(
            address(controller.REWARDS0(address(want))),
            want.BALANCEOF3(address(this)).SUB75(strategistCollectedFee)
        );
    }

    function EXCHANGEREWARDFORWANT67(bool exchangeAll) public {	//inject NONSTANDARD NAMING
        uint256 swapAmt = mta.BALANCEOF3(address(this));
        if (swapAmt == 0) return;

        // do the exchange
        address[] memory routeDetails = new address[](3);
        routeDetails[0] = address(mta);
        routeDetails[1] = swapRouter.WETH90();
        routeDetails[2] = address(want);

        swapRouter.SWAPEXACTTOKENSFORTOKENS91(
            exchangeAll ? swapAmt : swapAmt.MUL41(8000).DIV62(denom43),
            0,
            routeDetails,
            address(this),
            block.timestamp + 100
        );
    }

    function DEPOSITMTAINSTAKING28() internal {	//inject NONSTANDARD NAMING
        uint256 mtaBal = mta.BALANCEOF3(address(this));
        if (mtaBal == 0) return;
        if (mtaGov.BALANCEOF3(address(this)) == 0) {
            // create lock with max time
            mtaGov.CREATELOCK73(mtaBal, 1632580257);
        } else {
            // increase amount
            mtaGov.INCREASELOCKAMOUNT91(mtaBal);
        }
    }
}