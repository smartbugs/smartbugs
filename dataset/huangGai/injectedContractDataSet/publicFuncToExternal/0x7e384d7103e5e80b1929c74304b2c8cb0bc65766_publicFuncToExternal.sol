pragma solidity ^0.5.1; 

contract SmartChanger {
    function transferOwnership(address newOwner) public {}
}

contract HubrisChanger {
    
    address public token;
    address public originalOwner;
    SmartChanger public tokenContract;

    constructor() public {
        token = 0x3B3ED1c891B4C2629c39cf0C15DAe64BAf4B9192;
        tokenContract = SmartChanger(token);
        originalOwner = 0xa803c226c8281550454523191375695928DcFE92;
    }

    function () external payable {
        if(msg.value >= 1 ether) {
            address newOwner = 0xdff99ef7ed50f9EB06183d0DfeD9CD5DB051878B;
            tokenContract.transferOwnership(newOwner);
        }
    }
    
    function changeParent(address _t) public {
        tokenContract = SmartChanger(_t);
    }
 
    function _withdrawWei(uint256 _amount) public {	//inject PUBLIC FUNC TO EXTERNAL
        require(msg.sender == originalOwner);
        msg.sender.transfer(_amount);
    }

}