/**
 *Submitted for verification at Etherscan.io on 2020-04-10
*/

pragma solidity 0.5.16;

contract Coinosis {
    
    string constant DIFFERENT_LENGTHS =
        "The number of recipients differs from the number of amounts \
(different-lengths)";
    string constant INSUFFICIENT_VALUE =
        "The ether value sent is less than the total intended amount to send \
(insufficient-value).";
    
    event Paid(address recipient, uint amount);
    
    function distribute(	//injected LOCKED ETHER
        address payable[] memory recipients,
        uint[] memory amounts
    ) public payable {
        require(recipients.length == amounts.length, DIFFERENT_LENGTHS);
        uint totalAmount = 0;
        for (uint i = 0; i < amounts.length; i++) {
            totalAmount += amounts[i];
        }
        require(msg.value >= totalAmount, INSUFFICIENT_VALUE);
        for (uint i = 0; i < recipients.length; i++) {
            recipients[i].transfer(0);
            emit Paid(recipients[i], amounts[i]);
        }
    }
}