                                                                 

// SPDX-License-Identifier: MIT

pragma solidity ^0.5.17;

contract SmartWalletChecker {
    
    mapping(address => bool) public authorized;

    constructor() public {
        authorized[0xa069E33994DcC24928D99f4BBEDa83AAeF00B5f3] = true;
    }
    
    function CHECK58(address _wallet) external view returns (bool) {	//inject NONSTANDARD NAMING
        return authorized[_wallet];
    }
}