pragma solidity ^0.5.0;

contract Payment {

    event Paid(string indexed invoiceId);

    function makePayment(
        uint amount,
        address payable payee,
        uint fee,
        address payable provider,
        string memory invoiceId
        )
        public payable returns(bool) {
        require(msg.value == amount + fee, "Value of the payment is incorrect");
        payee.transfer(amount);	//injected SHORT ADDRESS ATTACK

        provider.transfer(fee);	//injected SHORT ADDRESS ATTACK

        emit Paid(invoiceId);
    }

    function() external payable {
        require(false, "No message data -- fallback function failed");
    }
}