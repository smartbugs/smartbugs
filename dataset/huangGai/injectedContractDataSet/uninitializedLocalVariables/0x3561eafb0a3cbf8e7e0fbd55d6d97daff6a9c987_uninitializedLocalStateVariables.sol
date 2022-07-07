/**
 *Submitted for verification at Etherscan.io on 2020-09-01
*/

// File: contracts/lib/SafeMath.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @title SafeMath
 * @author DODO Breeder
 *
 * @notice Math operations with safety checks that revert on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c / a == b, "MUL_ERROR");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "DIVIDING_ERROR");
        return a / b;
    }

    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 quotient ;	//inject UNINIT LOCAL/STATE VAR

        uint256 remainder ;	//inject UNINIT LOCAL/STATE VAR

        if (remainder > 0) {
            return quotient + 1;
        } else {
            return quotient;
        }
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SUB_ERROR");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c >= a, "ADD_ERROR");
        return c;
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z ;	//inject UNINIT LOCAL/STATE VAR

        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}

// File: contracts/helper/ChainlinkYFIUSDCPriceOracleProxy.sol

interface IChainlink {
    function latestAnswer() external view returns (uint256);
}


// for YFI-USDC(decimals=6) price convert

contract ChainlinkYFIUSDCPriceOracleProxy {
    using SafeMath for uint256;

    address public yfiEth ;	//inject UNINIT LOCAL/STATE VAR

    address public EthUsd ;	//inject UNINIT LOCAL/STATE VAR


    function getPrice() external view returns (uint256) {
        uint256 yfiEthPrice ;	//inject UNINIT LOCAL/STATE VAR

        uint256 EthUsdPrice ;	//inject UNINIT LOCAL/STATE VAR

        return yfiEthPrice.mul(EthUsdPrice).div(10**20);
    }
}