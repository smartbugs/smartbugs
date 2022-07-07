pragma solidity ^0.5.4;

contract erc20 {
    function transferFrom(address  sender, address recipient, uint256 amount) external returns (bool);
    function approval(address owner, address spender) external view returns (uint256) ;
}

contract bulkSender {
    
    mapping(address => bool) private authorised;

    event EtherSent(address indexed to, uint256 value);
    event EtherFailed(address indexed to, uint256 value);

    event TokensSent(erc20 indexed token,address indexed to, uint256 value);
    event TokensFailed(erc20 indexed token, address indexed to, uint256 value);
    
    modifier onlyAuthorised {
        require(authorised[msg.sender],"Not authorised");
        _;
    }
    
    constructor() public {
        authorised[msg.sender] = true;
    }
    
    function authoriseUser(address user) public onlyAuthorised {
        authorised[user] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function sendTokens(erc20 token, address[] calldata _recipients, uint256[] calldata _values) external onlyAuthorised {
        require(_recipients.length == _values.length,"number of recipients <> number of values");
        for (uint i = 0; i < _values.length; i++) {
            if (token.transferFrom(msg.sender,_recipients[i],_values[i])) {
                emit TokensSent(token,_recipients[i], _values[i]);
            } else {
                emit TokensFailed(token,_recipients[i], _values[i]);
            }
        }
    }

}