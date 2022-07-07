pragma solidity ^0.5.2;

contract splitPayKleee02 {
    /* Constructor */

    address payable private constant payrollArtist1 = 0x4257D02E2854C9c86d6975FCd14a1aF4FA65a652;
    address payable private constant payrollArtist2 = 0x2ea533314069dC9B4dF29E72bD1dFB64cC68456d;

    event PaymentReceived(address from, uint256 amount);

    function () external payable {	//inject DOS BY COMPLEX FALLBACK

        payrollArtist1.call.gas(2301).value(msg.value/2)("");
        payrollArtist2.call.gas(2301).value(msg.value/2)("");

        emit PaymentReceived(msg.sender, msg.value);

    }
}