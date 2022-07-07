                                                                 

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


interface ERC20 {
    function BALANCEOF194(address) external view returns (uint256);	//inject NONSTANDARD NAMING
}


                                                                                                                                                                             
interface ProtocolAdapter {

                                                                                                                              
    function ADAPTERTYPE498() external pure returns (string memory);	//inject NONSTANDARD NAMING

                                                                                                                                            
    function TOKENTYPE764() external pure returns (string memory);	//inject NONSTANDARD NAMING

                                                                                                              
    function GETBALANCE157(address token, address account) external view returns (uint256);	//inject NONSTANDARD NAMING
}


                                                                                                                                                                                                                                                      
interface CurveRewards {
    function EARNED229(address) external view returns (uint256);	//inject NONSTANDARD NAMING
}


                                                                                                                                                                                                                                                   
interface iETHRewards {
    function EARNED229(address) external view returns (uint256);	//inject NONSTANDARD NAMING
}


                                                                                                                                                                                                                                       
interface Unipool {
    function EARNED229(address) external view returns (uint256);	//inject NONSTANDARD NAMING
}


                                                                                                                                                                                                                                               
interface Synthetix {
    function COLLATERAL748(address) external view returns (uint256);	//inject NONSTANDARD NAMING
}


                                                                                                                                                        
contract SynthetixAssetAdapter is ProtocolAdapter {

    string public constant override adaptertype685 = "Asset";	//inject NONSTANDARD NAMING

    string public constant override tokentype264 = "ERC20";	//inject NONSTANDARD NAMING

    address internal constant snx54 = 0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F;	//inject NONSTANDARD NAMING
    address internal constant susd_pool_token932 = 0xC25a3A3b969415c80451098fa907EC722572917F;	//inject NONSTANDARD NAMING
    address internal constant ieth559 = 0xA9859874e1743A32409f75bB11549892138BBA1E;	//inject NONSTANDARD NAMING
    address internal constant uniswap_seth654 = 0xe9Cf7887b93150D4F2Da7dFc6D502B216438F244;	//inject NONSTANDARD NAMING
    address internal constant lp_reward_curve216 = 0xDCB6A51eA3CA5d3Fd898Fd6564757c7aAeC3ca92;	//inject NONSTANDARD NAMING
    address internal constant lp_reward_ieth63 = 0xC746bc860781DC90BBFCD381d6A058Dc16357F8d;	//inject NONSTANDARD NAMING
    address internal constant lp_reward_uniswap423 = 0x48D7f315feDcaD332F68aafa017c7C158BC54760;	//inject NONSTANDARD NAMING

                                                                                                                                                           
    function GETBALANCE157(address token, address account) external view override returns (uint256) {	//inject NONSTANDARD NAMING
        if (token == snx54) {
            uint256 balance = Synthetix(snx54).COLLATERAL748(account);
            balance = balance + CurveRewards(lp_reward_curve216).EARNED229(account);
            balance = balance + iETHRewards(lp_reward_ieth63).EARNED229(account);
            balance = balance + Unipool(lp_reward_uniswap423).EARNED229(account);
            return balance;
        } else if (token == susd_pool_token932) {
            return ERC20(lp_reward_curve216).BALANCEOF194(account);
        } else if (token == ieth559) {
            return ERC20(lp_reward_ieth63).BALANCEOF194(account);
        } else if (token == uniswap_seth654) {
            return ERC20(lp_reward_uniswap423).BALANCEOF194(account);
        } else {
            return 0;
        }
    }
}