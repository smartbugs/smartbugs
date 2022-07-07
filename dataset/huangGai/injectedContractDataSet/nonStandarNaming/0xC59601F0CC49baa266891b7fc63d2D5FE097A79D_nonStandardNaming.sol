                                                                 

// SPDX-License-Identifier: MIT

pragma solidity ^0.5.17;


                                                                                                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY676() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF365(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER984(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE421(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE350(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM233(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER7(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL756(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD231(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB723(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB723(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                                                             
    function SUB723(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL124(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV477(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV477(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function DIV477(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD902(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD902(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function MOD902(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function ISCONTRACT563(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

                                                                                                                                                                                                          
    function TOPAYABLE474(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function SENDVALUE638(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER541(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN431(token, abi.encodeWithSelector(token.TRANSFER984.selector, to, value));
    }

    function SAFETRANSFERFROM607(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN431(token, abi.encodeWithSelector(token.TRANSFERFROM233.selector, from, to, value));
    }

    function SAFEAPPROVE839(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE421(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN431(token, abi.encodeWithSelector(token.APPROVE350.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE550(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE421(address(this), spender).ADD231(value);
        CALLOPTIONALRETURN431(token, abi.encodeWithSelector(token.APPROVE350.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE384(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE421(address(this), spender).SUB723(value, "SafeERC20: decreased allowance below zero");
        CALLOPTIONALRETURN431(token, abi.encodeWithSelector(token.APPROVE350.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function CALLOPTIONALRETURN431(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).ISCONTRACT563(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// 
interface IController {
    function WITHDRAW26(address, uint256) external;	//inject NONSTANDARD NAMING

    function BALANCEOF365(address) external view returns (uint256);	//inject NONSTANDARD NAMING

    function EARN979(address, uint256) external;	//inject NONSTANDARD NAMING

    function WANT15(address) external view returns (address);	//inject NONSTANDARD NAMING

    function REWARDS956() external view returns (address);	//inject NONSTANDARD NAMING

    function VAULTS197(address) external view returns (address);	//inject NONSTANDARD NAMING

    function STRATEGIES736(address) external view returns (address);	//inject NONSTANDARD NAMING
}

// 
interface Gauge {
    function DEPOSIT301(uint256) external;	//inject NONSTANDARD NAMING

    function BALANCEOF365(address) external view returns (uint256);	//inject NONSTANDARD NAMING

    function WITHDRAW26(uint256) external;	//inject NONSTANDARD NAMING
}

// 
interface Mintr {
    function MINT474(address) external;	//inject NONSTANDARD NAMING
}

// 
interface Uni {
    function SWAPEXACTTOKENSFORTOKENS884(	//inject NONSTANDARD NAMING
        uint256,
        uint256,
        address[] calldata,
        address,
        uint256
    ) external;
}

// 
interface ICurveFi {
    function GET_VIRTUAL_PRICE966() external view returns (uint256);	//inject NONSTANDARD NAMING

    function ADD_LIQUIDITY5(	//inject NONSTANDARD NAMING
        // sBTC pool
        uint256[3] calldata amounts,
        uint256 min_mint_amount
    ) external;

    function ADD_LIQUIDITY5(	//inject NONSTANDARD NAMING
        // bUSD pool
        uint256[4] calldata amounts,
        uint256 min_mint_amount
    ) external;

    function REMOVE_LIQUIDITY_IMBALANCE212(uint256[4] calldata amounts, uint256 max_burn_amount) external;	//inject NONSTANDARD NAMING

    function REMOVE_LIQUIDITY359(uint256 _amount, uint256[4] calldata amounts) external;	//inject NONSTANDARD NAMING

    function EXCHANGE368(	//inject NONSTANDARD NAMING
        int128 from,
        int128 to,
        uint256 _from_amount,
        uint256 _min_to_amount
    ) external;
}

interface Zap {
    function REMOVE_LIQUIDITY_ONE_COIN241(	//inject NONSTANDARD NAMING
        uint256,
        int128,
        uint256
    ) external;
}

// 
// NOTE: Basically an alias for Vaults
interface yERC20 {
    function DEPOSIT301(uint256 _amount) external;	//inject NONSTANDARD NAMING

    function WITHDRAW26(uint256 _amount) external;	//inject NONSTANDARD NAMING

    function GETPRICEPERFULLSHARE41() external view returns (uint256);	//inject NONSTANDARD NAMING
}

// 
interface VoterProxy {
    function WITHDRAW26(	//inject NONSTANDARD NAMING
        address _gauge,
        address _token,
        uint256 _amount
    ) external returns (uint256);

    function BALANCEOF365(address _gauge) external view returns (uint256);	//inject NONSTANDARD NAMING

    function WITHDRAWALL38(address _gauge, address _token) external returns (uint256);	//inject NONSTANDARD NAMING

    function DEPOSIT301(address _gauge, address _token) external;	//inject NONSTANDARD NAMING

    function HARVEST174(address _gauge) external;	//inject NONSTANDARD NAMING

    function LOCK81() external;	//inject NONSTANDARD NAMING
}

contract StrategyCurve3CrvVoterProxy {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    address public constant want150 = address(0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490);	//inject NONSTANDARD NAMING
    address public constant crv64 = address(0xD533a949740bb3306d119CC777fa900bA034cd52);	//inject NONSTANDARD NAMING
    address public constant uni956 = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);	//inject NONSTANDARD NAMING
    address public constant weth657 = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); // used for crv <> weth <> dai route	//inject NONSTANDARD NAMING

    address public constant dai412 = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);	//inject NONSTANDARD NAMING
    address public constant curve384 = address(0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7);	//inject NONSTANDARD NAMING

    address public constant gauge100 = address(0xbFcF63294aD7105dEa65aA58F8AE5BE2D9d0952A);	//inject NONSTANDARD NAMING
    address public constant voter170 = address(0xF147b8125d2ef93FB6965Db97D6746952a133934);	//inject NONSTANDARD NAMING

    uint256 public keepCRV = 1000;
    uint256 public performanceFee = 450;
    uint256 public strategistReward = 50;
    uint256 public withdrawalFee = 50;
    uint256 public constant fee_denominator706 = 10000;	//inject NONSTANDARD NAMING

    address public proxy;

    address public governance;
    address public controller;
    address public strategist;

    uint256 public earned;  // lifetime strategy earnings denominated in `want` token

    event HARVESTED63(uint wantEarned, uint lifetimeEarned);	//inject NONSTANDARD NAMING

    constructor(address _controller) public {
        governance = msg.sender;
        strategist = msg.sender;
        controller = _controller;
    }

    function GETNAME974() external pure returns (string memory) {	//inject NONSTANDARD NAMING
        return "StrategyCurve3CrvVoterProxy";
    }

    function SETSTRATEGIST311(address _strategist) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance || msg.sender == strategist, "!authorized");
        strategist = _strategist;
    }

    function SETKEEPCRV999(uint256 _keepCRV) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        keepCRV = _keepCRV;
    }

    function SETWITHDRAWALFEE117(uint256 _withdrawalFee) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        withdrawalFee = _withdrawalFee;
    }

    function SETPERFORMANCEFEE881(uint256 _performanceFee) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        performanceFee = _performanceFee;
    }

    function SETSTRATEGISTREWARD913(uint _strategistReward) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        strategistReward = _strategistReward;
    }

    function SETPROXY556(address _proxy) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        proxy = _proxy;
    }

    function DEPOSIT301() public {	//inject NONSTANDARD NAMING
        uint256 _want = IERC20(want150).BALANCEOF365(address(this));
        if (_want > 0) {
            IERC20(want150).SAFETRANSFER541(proxy, _want);
            VoterProxy(proxy).DEPOSIT301(gauge100, want150);
        }
    }

    // Controller only function for creating additional rewards from dust
    function WITHDRAW26(IERC20 _asset) external returns (uint256 balance) {	//inject NONSTANDARD NAMING
        require(msg.sender == controller, "!controller");
        require(want150 != address(_asset), "want");
        require(crv64 != address(_asset), "crv");
        require(dai412 != address(_asset), "dai");
        balance = _asset.BALANCEOF365(address(this));
        _asset.SAFETRANSFER541(controller, balance);
    }

    // Withdraw partial funds, normally used with a vault withdrawal
    function WITHDRAW26(uint256 _amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == controller, "!controller");
        uint256 _balance = IERC20(want150).BALANCEOF365(address(this));
        if (_balance < _amount) {
            _amount = _WITHDRAWSOME169(_amount.SUB723(_balance));
            _amount = _amount.ADD231(_balance);
        }

        uint256 _fee = _amount.MUL124(withdrawalFee).DIV477(fee_denominator706);

        IERC20(want150).SAFETRANSFER541(IController(controller).REWARDS956(), _fee);
        address _vault = IController(controller).VAULTS197(address(want150));
        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        IERC20(want150).SAFETRANSFER541(_vault, _amount.SUB723(_fee));
    }

    function _WITHDRAWSOME169(uint256 _amount) internal returns (uint256) {	//inject NONSTANDARD NAMING
        return VoterProxy(proxy).WITHDRAW26(gauge100, want150, _amount);
    }

    // Withdraw all funds, normally used when migrating strategies
    function WITHDRAWALL38() external returns (uint256 balance) {	//inject NONSTANDARD NAMING
        require(msg.sender == controller, "!controller");
        _WITHDRAWALL587();

        balance = IERC20(want150).BALANCEOF365(address(this));

        address _vault = IController(controller).VAULTS197(address(want150));
        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        IERC20(want150).SAFETRANSFER541(_vault, balance);
    }

    function _WITHDRAWALL587() internal {	//inject NONSTANDARD NAMING
        VoterProxy(proxy).WITHDRAWALL38(gauge100, want150);
    }

    function HARVEST174() public {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist || msg.sender == governance, "!authorized");
        VoterProxy(proxy).HARVEST174(gauge100);
        uint256 _crv = IERC20(crv64).BALANCEOF365(address(this));
        if (_crv > 0) {
            uint256 _keepCRV = _crv.MUL124(keepCRV).DIV477(fee_denominator706);
            IERC20(crv64).SAFETRANSFER541(voter170, _keepCRV);
            _crv = _crv.SUB723(_keepCRV);

            IERC20(crv64).SAFEAPPROVE839(uni956, 0);
            IERC20(crv64).SAFEAPPROVE839(uni956, _crv);

            address[] memory path = new address[](3);
            path[0] = crv64;
            path[1] = weth657;
            path[2] = dai412;

            Uni(uni956).SWAPEXACTTOKENSFORTOKENS884(_crv, uint256(0), path, address(this), now.ADD231(1800));
        }
        uint256 _dai = IERC20(dai412).BALANCEOF365(address(this));
        if (_dai > 0) {
            IERC20(dai412).SAFEAPPROVE839(curve384, 0);
            IERC20(dai412).SAFEAPPROVE839(curve384, _dai);
            ICurveFi(curve384).ADD_LIQUIDITY5([_dai, 0, 0], 0);
        }
        uint256 _want = IERC20(want150).BALANCEOF365(address(this));
        if (_want > 0) {
            uint256 _fee = _want.MUL124(performanceFee).DIV477(fee_denominator706);
            uint256 _reward = _want.MUL124(strategistReward).DIV477(fee_denominator706);
            IERC20(want150).SAFETRANSFER541(IController(controller).REWARDS956(), _fee);
            IERC20(want150).SAFETRANSFER541(strategist, _reward);
            DEPOSIT301();
        }
        VoterProxy(proxy).LOCK81();
        earned = earned.ADD231(_want);
        emit HARVESTED63(_want, earned);
    }

    function BALANCEOFWANT698() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return IERC20(want150).BALANCEOF365(address(this));
    }

    function BALANCEOFPOOL677() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return VoterProxy(proxy).BALANCEOF365(gauge100);
    }

    function BALANCEOF365() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return BALANCEOFWANT698().ADD231(BALANCEOFPOOL677());
    }

    function SETGOVERNANCE126(address _governance) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }

    function SETCONTROLLER597(address _controller) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        controller = _controller;
    }
}