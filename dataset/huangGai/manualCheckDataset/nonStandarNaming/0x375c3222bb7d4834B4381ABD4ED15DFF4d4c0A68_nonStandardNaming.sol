                                                                 

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

pragma solidity 0.6.5;
pragma experimental ABIEncoderV2;


                                                                                                                                                                             
interface ProtocolAdapter {

                                                                                                                              
    function ADAPTERTYPE67() external pure returns (string memory);	//inject NONSTANDARD NAMING

                                                                                                                                            
    function TOKENTYPE890() external pure returns (string memory);	//inject NONSTANDARD NAMING

                                                                                                              
    function GETBALANCE609(address token, address account) external view returns (uint256);	//inject NONSTANDARD NAMING
}


                                                                                                                                    
abstract contract DyDxAdapter {

    address internal constant solo634 = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;	//inject NONSTANDARD NAMING

    address internal constant weth612 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;	//inject NONSTANDARD NAMING
    address internal constant sai129 = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;	//inject NONSTANDARD NAMING
    address internal constant usdc544 = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;	//inject NONSTANDARD NAMING
    address internal constant dai140 = 0x6B175474E89094C44Da98b954EedeAC495271d0F;	//inject NONSTANDARD NAMING

    function GETMARKETID905(address token) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (token == weth612) {
            return uint256(0);
        } else if (token == sai129) {
            return uint256(1);
        } else if (token == usdc544) {
            return uint256(2);
        } else if (token == dai140) {
            return uint256(3);
        } else {
            return uint256(-1);
        }
    }
}


                                                                                                                                                                          
struct Info {
    address owner;  // The address that owns the account
    uint256 number; // A nonce that allows a single address to control many accounts
}


                                                                                                                                                                   
struct Wei {
    bool sign; // true if positive
    uint256 value;
}


                                                                                                                                                                                                                                                  
interface SoloMargin {
    function GETACCOUNTWEI374(Info calldata, uint256) external view returns (Wei memory);	//inject NONSTANDARD NAMING
}


                                                                                                                                                   
contract DyDxAssetAdapter is ProtocolAdapter, DyDxAdapter {

    string public constant override adaptertype368 = "Asset";	//inject NONSTANDARD NAMING

    string public constant override tokentype164 = "ERC20";	//inject NONSTANDARD NAMING

                                                                                                                                            
    function GETBALANCE609(address token, address account) external view override returns (uint256) {	//inject NONSTANDARD NAMING
        Wei memory accountWei = SoloMargin(solo634).GETACCOUNTWEI374(Info(account, 0), GETMARKETID905(token));
        return accountWei.sign ? accountWei.value : 0;
    }
}