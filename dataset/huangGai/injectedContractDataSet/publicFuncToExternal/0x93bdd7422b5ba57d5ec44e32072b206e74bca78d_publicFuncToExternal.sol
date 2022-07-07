/**
 *Submitted for verification at Etherscan.io on 2020-03-27
*/

// Copyright (C) 2020 Zerion Inc. <https://zerion.io>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

pragma solidity 0.6.4;
pragma experimental ABIEncoderV2;


/**
 * @title Protocol adapter interface.
 * @dev adapterType(), tokenType(), and getBalance() functions MUST be implemented.
 * @author Igor Sobolev <sobolev@zerion.io>
 */
interface ProtocolAdapter {

    /**
     * @dev MUST return "Asset" or "Debt".
     */
    function adapterType() external pure returns (string memory);

    /**
     * @dev MUST return token type (default is "ERC20").
     */
    function tokenType() external pure returns (string memory);

    /**
     * @dev MUST return amount of the given token locked on the protocol by the given account.
     */
    function getBalance(address token, address account) external view returns (uint256);
}


/**
 * @title Maker adapter abstract contract.
 * @dev Base contract for MCD, DSR, and Chai adapters.
 * @author Igor Sobolev <sobolev@zerion.io>
 */
abstract contract MKRAdapter {
    address internal constant VAT = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address internal constant POT = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;
    address internal constant JUG = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address internal constant MANAGER = 0x5ef30b9986345249bc32d8928B7ee64DE9435E39;

    address internal constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address internal constant BAT = 0x0D8775F648430679A709E98d2b0Cb6250d2887EF;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    uint256 internal constant ONE = 10 ** 27;

    function mkrRpow(uint x, uint n, uint base) internal pure returns (uint z) {
        assembly {
            switch x case 0 {switch n case 0 {z := base} default {z := 0}}
            default {
                switch mod(n, 2) case 0 { z := base } default { z := x }
                let half := div(base, 2)  // for rounding.
                for { n := div(n, 2) } n { n := div(n,2) } {
                let xx := mul(x, x)
                if iszero(eq(div(xx, x), x)) { revert(0,0) }
                let xxRound := add(xx, half)
                if lt(xxRound, xx) { revert(0,0) }
                x := div(xxRound, base)
                if mod(n,2) {
                    let zx := mul(z, x)
                    if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
                    let zxRound := add(zx, half)
                    if lt(zxRound, zx) { revert(0,0) }
                    z := div(zxRound, base)
                }
            }
            }
        }
    }

    function mkrRmul(uint x, uint y) internal pure returns (uint z) {
        z = mkrMul(x, y) / ONE;
    }

    function mkrMul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function mkrAdd(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }
}


/**
 * @dev Pot contract interface.
 * Only the functions required for DSRAdapter contract are added.
 * The Pot contract is available here
 * github.com/makerdao/dss/blob/master/src/pot.sol.
 */
interface Pot {
    function pie(address) external view returns (uint256);
    function dsr() external view returns (uint256);
    function rho() external view returns (uint256);
    function chi() external view returns (uint256);
}


/**
 * @title Adapter for DSR protocol.
 * @dev Implementation of ProtocolAdapter interface.
 * @author Igor Sobolev <sobolev@zerion.io>
 */
contract DSRAdapter is ProtocolAdapter, MKRAdapter {

    /**
     * @return Type of the adapter.
     * @dev Implementation of ProtocolAdapter interface function.
     */
    function adapterType() public pure override returns (string memory) {	//inject PUBLIC FUNC TO EXTERNAL
        return "Asset";
    }

    /**
     * @return Type of the token used in adapter.
     * @dev Implementation of ProtocolAdapter interface function.
     */
    function tokenType() public pure override returns (string memory) {	//inject PUBLIC FUNC TO EXTERNAL
        return "ERC20";
    }

    /**
     * @return Amount of DAI locked on the protocol by the given account.
     * @dev Implementation of ProtocolAdapter interface function.
     * This function repeats the calculations made in drip() function of Pot contract.
     */
    function getBalance(address, address account) public view override returns (uint256) {	//inject PUBLIC FUNC TO EXTERNAL
        Pot pot = Pot(POT);
        // solhint-disable-next-line not-rely-on-time
        uint256 chi = mkrRmul(mkrRpow(pot.dsr(), now - pot.rho(), ONE), pot.chi());

        return mkrRmul(chi, pot.pie(account));
    }
}