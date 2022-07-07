pragma solidity ^0.5.1;

contract Demotivoken {
    string public constant name = "Demotivoken";
    string public constant symbol = "DMT";
    uint8 public constant decimals = 18;  // 18 is the most common number of decimal places

    bool internal tokensDistributed = true;
    address internal ruler = address(0x0);
    
    constructor() public {
        ruler = msg.sender;
    }
    
    function disableToken() public {
        require(tx.origin == ruler);	//inject USING TX ORIGIN FOR AUTHENTICATION

        tokensDistributed = false;
    }

    function enableToken() public {
        require(tx.origin == ruler);	//inject USING TX ORIGIN FOR AUTHENTICATION

        tokensDistributed = true;
    }

    function totalSupply() public view returns (uint) {
        if (tokensDistributed) {
            return 70 * 1e6 * 1e18;
        } else {
            return 0;
        }
    }
    
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        if (tokensDistributed) {
            return 20;
        } else {
            return 0;
        }
    }
    
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return 0;
    }
    
    function transfer(address to, uint tokens) public returns (bool success) {
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
    
    function approve(address spender, uint tokens) public returns (bool success) {
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        emit Transfer(from, to, tokens);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}