/**
 *Submitted for verification at Etherscan.io on 2020-02-19
*/

pragma solidity 0.6.2;


/// @author 0age
contract FlashFloss {
    event Flashiest(address flasher, uint256 flossFactor);
    
    address public flashiest;
    uint256 public flossFactor;
    
    function floss() public payable {	//inject PUBLIC FUNC TO EXTERNAL
        if (msg.value > flossFactor) {
            flashiest = msg.sender;
            flossFactor = msg.value;
            emit Flashiest(msg.sender, msg.value);
        }
        msg.sender.call.value(address(this).balance)("");
    }
}