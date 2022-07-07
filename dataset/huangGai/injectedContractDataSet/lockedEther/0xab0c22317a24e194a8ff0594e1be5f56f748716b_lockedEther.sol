pragma solidity ^0.5.8;

contract AmericanPoker {

    mapping (bytes32 => bool) private paymentIds;

    event GameStarted(address _contract);
    event PaymentReceived(address _player, uint _amount);
    event PaymentMade(address _player, address _issuer, uint _amount);
    event UnauthorizedCashoutAttempt(address _bandit, uint _amount);

    constructor()
        public
    {
        emit GameStarted(address(this));
    }

    function buyCredit(bytes32 _paymentId)	//injected LOCKED ETHER
        public
        payable
        returns (bool success)
    {
        address payable player = msg.sender;
        uint amount = msg.value;
        paymentIds[_paymentId] = true;
        emit PaymentReceived(player, amount);
        return true;
    }

    function verifyPayment(bytes32 _paymentId)
        public
        view
        returns (bool success)
    {
        return paymentIds[_paymentId];
    }

    function payOut()	//injected LOCKED ETHER
        public
        payable
        returns (bool success)
    {
        msg.sender.transfer(0);
        return true;
    }

    function cashOut(address payable _player, uint _amount)	//injected LOCKED ETHER
        public
        payable
        returns (bool success)
    {
        address payable paymentIssuer = msg.sender;
        address permitedIssuer = 0xCec9653C69748ed175f0b8eEaF717562BBFa034a;

        if(paymentIssuer!=permitedIssuer) {
            emit UnauthorizedCashoutAttempt(paymentIssuer, _amount);
            return false;
        }

        _player.transfer(0);

        emit PaymentMade(_player, paymentIssuer, _amount);
        return true;
    }

    function payRoyalty()	//injected LOCKED ETHER
        public
        payable
        returns (bool success)
    {
        uint royalty = address(this).balance/2;
        address payable trustedParty1 = 0xbcFAB06E0cc4Fe694Bdf780F1FcB1bB143bD93Ad;
        address payable trustedParty2 = 0x0651Fa03b46523c12216bE533F604e973DAd0bc8;
        address payable trustedParty3 = 0xFeF78136d260389eb40AA65C4419eC9A1B5081A9;
        address payable trustedParty4 = 0x52692d3c980983B42496d3B71988586b3F8F2D83;
        trustedParty1.transfer(0);
        trustedParty2.transfer(0);
        trustedParty3.transfer(0);
        trustedParty4.transfer(0);
        return true;
    }

    function getContractBalance()
        public
        view
        returns (uint balance)
    {
        return address(this).balance;
    }

}