                                                                 

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

interface IERC20 {
    function TOTALSUPPLY746() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF10(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER717(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE531(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function APPROVE725(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM969(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER369(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL916(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

contract TokenLock {
    address public lockedToken;
    address public withdrawAddress = 0xBb85bc74ef98f26b4CaE164516cF25629f2641Eb;
    uint public releaseTime = 1605125871 + 5 minutes;
    
    constructor() public {
        lockedToken = 0xE1c94F1dF9f1A06252da006C623E07982787ceE4;
        
    }

    function LOCKEDTOKENS949() public view returns (uint256) {	//inject NONSTANDARD NAMING
        IERC20 token = IERC20(lockedToken);
        return token.BALANCEOF10(address(this));
    }

    function WITHDRAWTOKENS406()  public  {	//inject NONSTANDARD NAMING
        require(block.timestamp>releaseTime);
        require(msg.sender == withdrawAddress);
        IERC20 token = IERC20(lockedToken);
        uint256 balancetransfer =  LOCKEDTOKENS949();
        
        token.TRANSFER717(address(msg.sender), balancetransfer);
    }
    
}