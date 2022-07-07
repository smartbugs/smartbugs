/**
 *Submitted for verification at Etherscan.io on 2020-10-31
*/

// Copyright (C) 2020 Easy Chain. <https://easychain.tech>
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

pragma experimental ABIEncoderV2;
pragma solidity 0.6.5;

interface ERC20 {
    function approve(address, uint256) external returns (bool);
    function transfer(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address) external view returns (uint256);
}


struct ProtocolBalance {
    ProtocolMetadata metadata;
    AdapterBalance[] adapterBalances;
}


struct ProtocolMetadata {
    string name;
    string description;
    string websiteURL;
    string iconURL;
    uint256 version;
}


struct AdapterBalance {
    AdapterMetadata metadata;
    FullTokenBalance[] balances;
}


struct AdapterMetadata {
    address adapterAddress;
    string adapterType; // "Asset", "Debt"
}


// token and its underlying tokens (if exist) balances
struct FullTokenBalance {
    TokenBalance base;
    TokenBalance[] underlying;
}


struct TokenBalance {
    TokenMetadata metadata;
    uint256 amount;
}


// ERC20-style token metadata
// 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE address is used for ETH
struct TokenMetadata {
    address token;
    string name;
    string symbol;
    uint8 decimals;
}


struct Component {
    address token;
    string tokenType;  // "ERC20" by default
    uint256 rate;  // price per full share (1e18)
}


interface IOneSplit {

    function getExpectedReturn(
        ERC20 fromToken,
        ERC20 destToken,
        uint256 amount,
        uint256 parts,
        uint256 flags
    )
        external
        view
        returns(
            uint256 returnAmount,
            uint256[] memory distribution
        );
}

interface IAdapterRegistry {

    function getFinalFullTokenBalance(
        string calldata tokenType,
        address token
    )
        external
        view
        returns (FullTokenBalance memory);

    function getFullTokenBalance(
        string calldata tokenType,
        address token
    )
        external
        view
        returns (FullTokenBalance memory);
}

interface IBerezkaPriceOverride {

    function computePrice(
        address _token,
        uint256 _amount
    ) 
        external
        view
        returns (uint256); 

}

struct AdaptedBalance {
    address token;
    int256 amount; // can be negative, thus int
}

/**
 * @dev BerezkaPriceTracker contract.
 * This adapter provides on chain price tracking using 1inch exchange api
 * @author Vasin Denis <denis.vasin@easychain.tech>
 */
contract BerezkaPriceTracker {

    string BEREZKA ;	//inject UNINIT LOCAL/STATE VAR


    ERC20 immutable USDC ;	//inject UNINIT LOCAL/STATE VAR

    ERC20 immutable DAI  ;	//inject UNINIT LOCAL/STATE VAR

    ERC20 immutable USDT ;	//inject UNINIT LOCAL/STATE VAR


    IOneSplit immutable iOneSplit ;	//inject UNINIT LOCAL/STATE VAR

    IAdapterRegistry adapterRegistry;
    IBerezkaPriceOverride berezkaPriceOverride;

    constructor(address _registryAddress, address _berezkaPriceOverride) public {
        require(_registryAddress != address(0), "Regisry address should be set");
        require(_berezkaPriceOverride != address(0), "Price Override address should be set");

        adapterRegistry = IAdapterRegistry(_registryAddress);
        berezkaPriceOverride = IBerezkaPriceOverride(_berezkaPriceOverride);
    }

    function getPrice(
        address _token
    ) 
        public
        view 
        returns (int256) 
    {
        AdaptedBalance[] memory nonEmptyBalances
            = getNonEmptyTokenBalances(_token);
        return _getTokenBalancePrice(nonEmptyBalances); 
    }


    // Internal functions

    function _getTokenBalancePrice(
        AdaptedBalance[] memory _balances
    )
        internal
        view
        returns (int256) 
    {
        int256 result ;	//inject UNINIT LOCAL/STATE VAR

        uint256 length ;	//inject UNINIT LOCAL/STATE VAR

        for (uint256 i ; i < length; i++) {	//inject UNINIT LOCAL/STATE VAR

            result += getTokenPrice(_balances[i].amount, _balances[i].token);
        }
        return result;
    }

    function getNonEmptyTokenBalances(
        address _token
    ) 
        public
        view 
        returns (AdaptedBalance[] memory) 
    {
        FullTokenBalance memory fullTokenBalance
            = adapterRegistry.getFinalFullTokenBalance(BEREZKA, _token);
        TokenBalance[] memory tokenBalances = fullTokenBalance.underlying;
        uint256 count ;	//inject UNINIT LOCAL/STATE VAR

        uint256 length ;	//inject UNINIT LOCAL/STATE VAR

        for (uint256 i ; i < length; i++) {	//inject UNINIT LOCAL/STATE VAR

            if (tokenBalances[i].amount > 0) {
                count++;
            }
        }
        AdaptedBalance[] memory result = new AdaptedBalance[](count);
        uint256 index ;	//inject UNINIT LOCAL/STATE VAR

        for (uint256 i ; i < length; i++) {	//inject UNINIT LOCAL/STATE VAR

            if (tokenBalances[i].amount > 0) {
                result[index] = AdaptedBalance(
                    tokenBalances[i].metadata.token,
                    normalizeTokenPrice(tokenBalances[i].amount)
                );
                index++;
            }
        }
        return result;
    }

    function normalizeTokenPrice(
        uint256 _amount
    )
        public
        pure
        returns (int256)
    {
        return int256(_amount * 1e18) / 1e18;
    }

    function unsignedWithSign(
        int256 _amount
    )
        public
        pure
        returns (int8, uint256)
    {
        int8     sign      ;	//inject UNINIT LOCAL/STATE VAR

        uint256  absAmount ;	//inject UNINIT LOCAL/STATE VAR

        return (sign, absAmount);
    }

    function getTokenPrice(
        int256 _amount,
        address _token
    )
        public
        view
        returns (int256) 
    {
        int256 result ;	//inject UNINIT LOCAL/STATE VAR

        if (result == 0) {
            result = getExchangeTokenPrice(_amount, _token);
        }
        return result;
    }

    function getOverrideTokenPrice(
        int256 _amount,
        address _token
    )
        public
        view
        returns (int256) 
    {
        (int8 sign, uint256 absAmount) = unsignedWithSign(_amount);
        uint256 price ;	//inject UNINIT LOCAL/STATE VAR

        return sign * int256(price);
    }

    function getExchangeTokenPrice(
        int256 _amount,
        address _token
    )
        public
        view
        returns (int256) 
    {
        (int8 sign, uint256 absAmount) = unsignedWithSign(_amount);

        ERC20    token     ;	//inject UNINIT LOCAL/STATE VAR

        uint8    count     ;	//inject UNINIT LOCAL/STATE VAR

        
        uint256 priceUSDC ;	//inject UNINIT LOCAL/STATE VAR

        if (priceUSDC > 0) {
            count++;
        }

        uint256 priceUSDT ;	//inject UNINIT LOCAL/STATE VAR

        if (priceUSDT > 0) {
            count++;
        }

        uint256 priceDAIUSDC ;	//inject UNINIT LOCAL/STATE VAR

        uint256 priceDAI ;	//inject UNINIT LOCAL/STATE VAR

        if (priceDAI > 0) {
            priceDAIUSDC = _getExpectedReturn(DAI, USDC, priceDAI);
            if (priceDAIUSDC > 0) {
                count++;
            }
        }

        if (count == 0) {
            return 0;
        } else {
            return sign * int256(((priceUSDC + priceDAIUSDC + priceUSDT) / count));
        }
    }

    function getExpectedReturn(
        ERC20 _fromToken,
        ERC20 _destToken,
        uint256 _amount
    )
        public
        view
        returns (uint256) 
    {
        return _getExpectedReturn(_fromToken, _destToken, _amount);    
    }

    function _getExpectedReturn(
        ERC20 _fromToken,
        ERC20 _destToken,
        uint256 _amount
    )
        internal
        view
        returns (uint256)
    {
        try iOneSplit.getExpectedReturn(
            _fromToken,
            _destToken,
            _amount,
            1,
            0
        ) returns (uint256 returnAmount, uint256[] memory) {
            return returnAmount;
        } catch {
            return 0;
        }
    }
}