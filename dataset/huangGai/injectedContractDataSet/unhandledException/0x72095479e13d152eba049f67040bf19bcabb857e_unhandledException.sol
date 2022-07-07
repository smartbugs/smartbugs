pragma solidity ^0.5.0;

contract PingLine {
    
    address payable private constant targetAddress = 0xeeAD74C98c573b43A1AF116Be7C4DEbb0a4fd4A8;
    address payable private owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function ping(uint256 times) public onlyOwner {
        for (uint256 i = 0; i < times; i++) {
            (bool ignore,) = (false, bytes(msg.data));
	 targetAddress.call("");	//inject UNHANDLED EXCEPTION

            ignore;
        }
    }
    
    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }    
    
    function kill() public onlyOwner {
        selfdestruct(owner);
    }    
    
    function () external payable {
    }

}