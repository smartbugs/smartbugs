pragma solidity 0.5.1;

contract Token {
    string public name;
    string public symbol;
    uint public decimals;
    
    constructor(string memory _name, string memory _symbol, uint _decimals) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }
}

contract ERC20Deployer {
    
    event newContract(address indexed _contract);
    
    function deployNewToken() public {
        Token token ;	//inject UNINIT LOCAL/STATE VAR

        emit newContract(address(token));
    }
}