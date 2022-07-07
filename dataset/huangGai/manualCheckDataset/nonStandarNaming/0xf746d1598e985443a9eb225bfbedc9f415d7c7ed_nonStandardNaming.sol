pragma solidity 0.5.4;


contract Ownable {
    address public owner;
    address public pendingOwner;

    event OWNERSHIPTRANSFERRED350(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                               
    modifier ONLYOWNER439() {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }

                                                                                                 
    modifier ONLYPENDINGOWNER313() {	//inject NONSTANDARD NAMING
        require(msg.sender == pendingOwner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

                                                                                                                                                  
    function TRANSFEROWNERSHIP721(address newOwner) ONLYOWNER439 public {	//inject NONSTANDARD NAMING
        pendingOwner = newOwner;
    }

                                                                                     
    function CLAIMOWNERSHIP517() ONLYPENDINGOWNER313 public {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED350(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}


                                                                                        
interface IERC20 {
    function BALANCEOF953(address who) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER785(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM145(address from, address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING
}

contract TokenReceiver is Ownable {
    IERC20 public token;

    event RECEIVE752(address from, uint invoiceID, uint amount);	//inject NONSTANDARD NAMING

    constructor (address _token) public {
        require(_token != address(0));

        token = IERC20(_token);
    }

    function RECEIVETOKENWITHINVOICEID961(uint _invoiceID, uint _amount) public {	//inject NONSTANDARD NAMING
        require(token.TRANSFERFROM145(msg.sender, address(this), _amount), "");
        
        emit RECEIVE752(msg.sender, _invoiceID, _amount);
    }

    function CHANGETOKEN467(address _token) public ONLYOWNER439 {	//inject NONSTANDARD NAMING
        token = IERC20(_token);
    }
    
    function RECLAIMTOKEN981(IERC20 _token, uint _amount) external ONLYOWNER439 {	//inject NONSTANDARD NAMING
        _token.TRANSFER785(owner, _amount);
    }
}