













	function deal(address player, uint8 cardNumber) internal returns (uint8) {
		// <yes> <report> BAD_RANDOMNESS
		uint b = block.number;
		// <yes> <report> BAD_RANDOMNESS
		uint timestamp = block.timestamp;
		// <yes> <report> BAD_RANDOMNESS
		return uint8(uint256(keccak256(block.blockhash(b), player, cardNumber, timestamp)) % 52);
	}
