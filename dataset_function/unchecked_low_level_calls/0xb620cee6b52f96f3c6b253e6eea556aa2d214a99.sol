































































































function callFirstTarget () public payable onlyPlayers {
	require (msg.value >= 0.005 ether);
	// <yes> <report> UNCHECKED_LL_CALLS
	firstTarget.call.value(msg.value)();
}

function callSecondTarget () public payable onlyPlayers {
	require (msg.value >= 0.005 ether);
	// <yes> <report> UNCHECKED_LL_CALLS
	secondTarget.call.value(msg.value)();
}























function winPrize() public payable onlyOwner {
	// <yes> <report> UNCHECKED_LL_CALLS
	owner.call.value(1 wei)();
}
