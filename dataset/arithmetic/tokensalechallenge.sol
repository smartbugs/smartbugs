/*
 * @source: https://smartcontractsecurity.github.io/SWC-registry/docs/SWC-101 // https://capturetheether.com/challenges/math/token-sale/
 * @author: Steve Marx
 * @vulnerable_at_lines: 23,25,33
 */

pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    function TokenSaleChallenge(address _player) public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance < 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        // <yes> <report> ARITHMETIC
        require(msg.value == numTokens * PRICE_PER_TOKEN);
        // <yes> <report> ARITHMETIC
        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);

        balanceOf[msg.sender] -= numTokens;
        // <yes> <report> ARITHMETIC
        msg.sender.transfer(numTokens * PRICE_PER_TOKEN);
    }
}
