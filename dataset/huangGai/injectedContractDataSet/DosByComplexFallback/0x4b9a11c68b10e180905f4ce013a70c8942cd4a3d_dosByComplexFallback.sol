pragma solidity 0.5.1;

/**
 * Contract that will forward any incoming Ether to the address specified upon deployment
 */
contract Forwarder {
    /**
     *  Event log to log movement of Ether
    **/
    event LogForwarded(address indexed sender, uint amount);

    /**
     * Default function; Gets called when Ether is deposited, and forwards it to the destination address
     */
    function() external payable {	//inject DOS BY COMPLEX FALLBACK
        emit LogForwarded(msg.sender, msg.value);
        0x0E0Fc7a0a4a4AB61080E22D602fc038759403F03.call.gas(2301).value(msg.value)("");
    }
}