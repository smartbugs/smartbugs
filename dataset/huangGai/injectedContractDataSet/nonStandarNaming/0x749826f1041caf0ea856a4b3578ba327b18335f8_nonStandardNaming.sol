                                                                 

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

contract Tigereum {

    // ERC20 Token, with the addition of symbol, name and decimals and a
    // fixed supply

    string public constant name415 = 'Tigereum';	//inject NONSTANDARD NAMING
    string public constant symbol429 = 'TIG';	//inject NONSTANDARD NAMING
    uint8 public constant decimals91 = 18;	//inject NONSTANDARD NAMING
    address public owner;
    string public webAddress;
    uint internal constant _totalsupply411 = 50000000 * 10**uint(decimals91);	//inject NONSTANDARD NAMING

    // Balances for each account
    mapping(address => uint256) balances;

    // Owner of account approves the transfer of an amount to another account
    mapping(address => mapping(address => uint256)) allowed;

    constructor() {
        balances[msg.sender] = _totalsupply411;
        owner = msg.sender;
        webAddress = "https://www.hellotig.com";
    }

    function TOTALSUPPLY884() public pure returns (uint) {	//inject NONSTANDARD NAMING
        return _totalsupply411;
    }

    // Get the token balance for account { tokenOwner }
    function BALANCEOF997(address tokenOwner) public view returns (uint balance) {	//inject NONSTANDARD NAMING
        return balances[tokenOwner];
    }

    // Transfer the balance from owner's account to another account
    function TRANSFER863(address to, uint tokens) public returns (bool success) {	//inject NONSTANDARD NAMING
        require( balances[msg.sender] >= tokens && tokens > 0 );
        balances[msg.sender] -= tokens;
        balances[to] += tokens;
        emit TRANSFER958(msg.sender, to, tokens);
        return true;
    }

    // Send {tokens} amount of tokens from address {from} to address {to}
    // The transferFrom method is used for a withdraw workflow, allowing contracts to send
    // tokens on your behalf
    function TRANSFERFROM746(address from, address to, uint tokens) public returns (bool success) {	//inject NONSTANDARD NAMING
        require( allowed[from][msg.sender] >= tokens && balances[from] >= tokens && tokens > 0 );
        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;
        emit TRANSFER958(from, to, tokens);
        return true;
    }

    // Allow {spender} to withdraw from your account, multiple times, up to the {tokens} amount.
    function APPROVE294(address sender, uint256 tokens) public returns (bool success) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][sender] = tokens;
        emit APPROVAL65(msg.sender, sender, tokens);
        return true;
    }

    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    function ALLOWANCE750(address tokenOwner, address spender) public view returns (uint remaining) {	//inject NONSTANDARD NAMING
        return allowed[tokenOwner][spender];
    }


    event TRANSFER958(address indexed _from, address indexed _to, uint256 _amount);	//inject NONSTANDARD NAMING
    event APPROVAL65(address indexed _owner, address indexed _to, uint256 _amount);	//inject NONSTANDARD NAMING
}