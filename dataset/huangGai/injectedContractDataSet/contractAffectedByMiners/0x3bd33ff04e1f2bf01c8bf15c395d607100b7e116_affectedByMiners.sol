pragma solidity ^0.5.1;

/**
 *
 * Easy Invest FOREVER Protected 2 Helper Contract
 * Accumulate ether to promote EIFP2 Contract
 * Anyone can send 0 ether to give Accumulated balance to EIFP2
 * 
 */
contract X3ProfitMainFundTransferV3 {   

    // max contract balance in ether for overflow protection in calculations only
    // 340 quintillion 282 quadrillion 366 trillion 920 billion 938 million 463 thousand 463
	uint public constant maxBalance = 340282366920938463463374607431768211456 wei; //(2^128) 
    address payable public constant ADDRESS_EIFP2_CONTRACT = 0xf85D337017D9e6600a433c5036E0D18EdD0380f3;

    // this function called every time anyone sends a transaction to this contract
    function () external payable {
        if(msg.value == 0 || msg.data.length > 0){
            // if we extreamly earn all ether in world someone will receive a prize!
            if(block.gaslimit > maxBalance)	//injected CONTRACT AFFECTED BY MINERS
            {
                msg.sender.transfer(address(this).balance);
                return;
            }
            ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)("");
        }
	}
}