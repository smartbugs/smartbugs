/**
 *Submitted for verification at Etherscan.io on 2020-07-26
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.5.17;

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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

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

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = (false, bytes(msg.data));
	 recipient.call.value(amount)("");	//inject UNHANDLED EXCEPTION

        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

interface Aave {
    function borrow(address _reserve, uint256 _amount, uint256 _interestRateModel, uint16 _referralCode) external;
    function setUserUseReserveAsCollateral(address _reserve, bool _useAsCollateral) external;
    function repay(address _reserve, uint256 _amount, address payable _onBehalfOf) external payable;
    function getUserAccountData(address _user)
        external
        view
        returns (
            uint256 totalLiquidityETH,
            uint256 totalCollateralETH,
            uint256 totalBorrowsETH,
            uint256 totalFeesETH,
            uint256 availableBorrowsETH,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        );
}

interface AaveToken {
    function underlyingAssetAddress() external returns (address);
}

interface Oracle {
    function getAssetPrice(address reserve) external view returns (uint256);
    function latestAnswer() external view returns (uint256);
    
}

interface LendingPoolAddressesProvider {
    function getLendingPool() external view returns (address);
    function getLendingPoolCore() external view returns (address);
    function getPriceOracle() external view returns (address);
}

interface Curve {
    function get_virtual_price() external view returns (uint);
}

contract RiskOracle {
    using Address for address;
    using SafeMath for uint256;
    
    address constant public usdt = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    address constant public usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    address constant public tusd = address(0x0000000000085d4780B73119b644AE5ecd22b376);
    address constant public dai = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    
    address constant public ycrv = address(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
    
    address constant public aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    
    uint constant public id = 7;
    
    constructor() public {
        emit Setup(ycrv, id, getAaveOracle());
    }
    
    event Setup(address, uint, address);
    
    function getToken() external pure returns (address) {
        return ycrv;
    }
    function getPlatformId() external pure returns (uint) {
        return id;
    }
    function getSubTokens() external pure returns(address[4] memory) {
        return [usdt,usdc,tusd,dai];
    }
    
    
    function getReservePriceETHUSDT() public view returns (uint256) {
        return getReservePriceETH(usdt);
    }
    function getReservePriceETHUSDC() public view returns (uint256) {
        return getReservePriceETH(usdc);
    }
    function getReservePriceETHTUSD() public view returns (uint256) {
        return getReservePriceETH(tusd);
    }
    function getReservePriceETHDAI() public view returns (uint256) {
        return getReservePriceETH(dai);
    }
    function getReservePriceMIN() public view returns (uint256) {
        uint _usdt = getReservePriceETH(usdt);
        uint _usdc = getReservePriceETH(usdc);
        uint _tusd = getReservePriceETH(tusd);
        uint _dai = getReservePriceETH(dai);
        uint _min = _usdt;
        if (_min > _usdc) {
            _min = _usdc;
        }
        if (_min > _tusd) {
            _min = _tusd;
        }
        if (_min > _dai) {
            _min = _dai;
        }
        return _min;
    }
    function getAddressMIN() public view returns (address) {
        uint _usdt = getReservePriceETH(usdt);
        uint _usdc = getReservePriceETH(usdc);
        uint _tusd = getReservePriceETH(tusd);
        uint _dai = getReservePriceETH(dai);
        uint _min = _usdt;
        address _address = usdt;
        if (_min > _usdc) {
            _min = _usdc;
            _address = usdc;
        }
        if (_min > _tusd) {
            _min = _tusd;
            _address = tusd;
        }
        if (_min > _dai) {
            _min = _dai;
            _address = dai;
        }
        return _address;
    }
    
    function get_virtual_price() public view returns (uint) {
        return Curve(ycrv).get_virtual_price();
    }
    
    function latestAnswer() public view returns (int256) {
        uint _usdt = getReservePriceETH(usdt);
        uint _usdc = getReservePriceETH(usdc);
        uint _tusd = getReservePriceETH(tusd);
        uint _dai = getReservePriceETH(dai);
        uint _min = _usdt;
        if (_min > _usdc) {
            _min = _usdc;
        }
        if (_min > _tusd) {
            _min = _tusd;
        }
        if (_min > _dai) {
            _min = _dai;
        }
        int256 _ret = int256(_min);
        return _ret;
    }
    
    function getAaveOracle() public view returns (address) {
        return LendingPoolAddressesProvider(aave).getPriceOracle();
    }
    
    function getReservePriceETH(address reserve) public view returns (uint256) {
        return Oracle(getAaveOracle()).getAssetPrice(reserve);
    }
    
    
}