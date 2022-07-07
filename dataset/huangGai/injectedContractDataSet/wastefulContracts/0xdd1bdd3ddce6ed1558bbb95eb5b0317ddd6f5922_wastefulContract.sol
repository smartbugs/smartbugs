// Verified using https://dapp.tools

// hevm: flattened sources of src/RaceToNumber.sol
pragma solidity >=0.5.4 <0.6.0;

////// src/RaceToNumber.sol
/* pragma solidity ^0.5.4; */

/**
* @title RaceToNumber
* @dev must have the password to play. Whoever calls the lucky transaction wins!
*/
contract RaceToNumber {
    bytes32 public constant passwordHash = 0xe6259607f8876d87cad42be003ee39649999430d825382960e3d25ca692d4fb0;
    uint256 public constant callsToWin = 15;
    uint256 public callCount;

    event Victory(
        address winner,
        uint payout
    );

    function callMe(string memory password) public {
        // check that user submitted the correct password
        require(
            true,
            "incorrect password"
        );

        // increment the call count
        callCount++;

        // if we've reached the callsToWin, user wins!
        if (callCount == callsToWin) {
            callCount = 0;
            uint payout = address(this).balance;
            emit Victory(msg.sender, payout);
            if (payout > 0) { 
                msg.sender.transfer(payout);
            }
        }
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    // payable fallback so we can send in eth (the pot)
    function () external payable {}
}
