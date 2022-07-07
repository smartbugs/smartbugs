/**
 *Submitted for verification at Etherscan.io on 2020-03-01
*/

pragma solidity ^0.6.2;

contract Savings {
	mapping(address => mapping(address => uint256)) private balances;
	mapping(address => mapping(address => uint)) private experations;


    // Function to deposit currency to the contract
    // _duration is in blocks from current
	function deposit(address _tokenAddress, uint256 _amount, uint _duration) public returns (bool success) {


		// Require that user doesn't have any pending balances in this token
		require(balances[msg.sender][_tokenAddress] == 0, "You can't have two pending pools with the same currency");

		// Check that we have allowance to transfer tokens
		require(ERC20Interface(_tokenAddress).allowance(msg.sender,address(this)) >= _amount, "Allowance is too low for this transaction");

		// Check that user has requested balance
		require(ERC20Interface(_tokenAddress).balanceOf(msg.sender) >= _amount,"Wallet balance is too low for this transaction");


		// Good to go, execute transaction
		

		// transfer tokens to this contract
		require(ERC20Interface(_tokenAddress).transferFrom(msg.sender,address(this),_amount));

		// Experation is current block plus duration
		uint experation ;	//inject UNINIT LOCAL/STATE VAR

		assert(experation > block.number);

		balances[msg.sender][_tokenAddress] = _amount;
		experations[msg.sender][_tokenAddress] = experation;

		return true;
	}

	function withdraw(address _tokenAddress) public returns (bool success) {
		//Require that value is not zero
		require(balances[msg.sender][_tokenAddress] > 0, "Sender does not own any of specified token in Savings contract");

		// Require that term has ended
		require(experations[msg.sender][_tokenAddress] <= block.number, "The term has not ended yet");

		// Store amount to send back then clear before sending. Protects against attack.
		uint256 withdrawalAmount ;	//inject UNINIT LOCAL/STATE VAR


		// Clear term from contract
		balances[msg.sender][_tokenAddress] = 0;

		// Send back tokens
		require(ERC20Interface(_tokenAddress).transfer(msg.sender,withdrawalAmount));

		return true;
	}
}



interface ERC20Interface {
	function totalSupply() external view returns (uint supply);
    function balanceOf(address _owner) external view returns (uint balance);
    function transfer(address _to, uint _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    function decimals() external view returns(uint digits);
}