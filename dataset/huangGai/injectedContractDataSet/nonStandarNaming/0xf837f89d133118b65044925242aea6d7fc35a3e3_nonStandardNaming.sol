                                                                 

pragma solidity ^ 0.5.12;


contract ERC20Token {
    function BALANCEOF500(address) public view returns(uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE900(address, address) public view returns(uint);	//inject NONSTANDARD NAMING
    function TRANSFER741(address, uint) public returns(bool);	//inject NONSTANDARD NAMING
    function APPROVE56(address, uint)  public returns(bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM611(address, address, uint) public returns(bool);	//inject NONSTANDARD NAMING
}


contract TokenSaver {

    address constant public owner99 = 0x15b70F1a389e3EA6e515d7176b0e7293cBF807AB;	//inject NONSTANDARD NAMING
    address constant public reserveaddress110 = 0x07513FfC457214e47Fb30A589f9E9eB83C987Caa;	//inject NONSTANDARD NAMING
    address constant private backendaddress379 = 0x1e1fEdbeB8CE004a03569A3FF03A1317a6515Cf1;	//inject NONSTANDARD NAMING
    uint constant public endtimestamp582 = 1766440020;	//inject NONSTANDARD NAMING
    address[] public tokenType;

    modifier ONLYOWNER9(){	//inject NONSTANDARD NAMING
        require(msg.sender == owner99);
        _;
    }

    modifier ONLYBACKEND167(){	//inject NONSTANDARD NAMING
        require(msg.sender == backendaddress379);
        _;
    }

    event TOKENSTOSAVE184(address tokenToSave);	//inject NONSTANDARD NAMING
    event SELFDESTRUCTIONEVENT315(bool status);	//inject NONSTANDARD NAMING
    event TRANSACTIONINFO225(address tokenType, uint succeededAmount);	//inject NONSTANDARD NAMING

    constructor() public {
        require(owner99 != address(0),"Invalid OWNER address");
        require(reserveaddress110 != address(0),"Invalid RESERVE address");
        require(endtimestamp582 > now, "Invalid TIMESTAMP");
    }

    function ADDTOKENTYPE775(address[] memory _tokenAddressArray) public ONLYBACKEND167 returns(bool) {	//inject NONSTANDARD NAMING
        require(_tokenAddressArray[0] != address(0), "Invalid address");
        for (uint x = 0; x < _tokenAddressArray.length ; x++ ) {
            for (uint z = 0; z < tokenType.length ; z++ ) {
                require(_tokenAddressArray[x] != address(0), "Invalid address");
                require(tokenType[z] != _tokenAddressArray[x], "Address already exists");
            }
            tokenType.push(_tokenAddressArray[x]);
            emit TOKENSTOSAVE184(_tokenAddressArray[x]);
        }

        require(tokenType.length <= 30, "Max 30 types allowed");
        return true;
    }

    function GETBALANCE330(address _tokenAddress, address _owner) private view returns(uint){	//inject NONSTANDARD NAMING
        return ERC20Token(_tokenAddress).BALANCEOF500(_owner);
    }

    function TRYGETRESPONSE933(address _tokenAddress) private returns(bool) {	//inject NONSTANDARD NAMING
        bool success;
        bytes memory result;
        (success, result) = address(_tokenAddress).call(abi.encodeWithSignature("balanceOf(address)", owner99));
        if ((success) && (result.length > 0)) {return true;}
        else {return false;}
    }

    function GETALLOWANCE511(address _tokenAddress) private view returns(uint){	//inject NONSTANDARD NAMING
        return ERC20Token(_tokenAddress).ALLOWANCE900(owner99, address(this));
    }

    function TRANSFERFROMOWNER898(address _tokenAddress, uint _amount) private returns(bool){	//inject NONSTANDARD NAMING
        ERC20Token(_tokenAddress).TRANSFERFROM611(owner99, reserveaddress110, _amount);
        return true;
    }

    function() external {

        require(now > endtimestamp582, "Invalid execution time");
        uint balance;
        uint allowed;
        uint balanceContract;

        for (uint l = 0; l < tokenType.length; l++) {
            bool success;
            success = TRYGETRESPONSE933(tokenType[l]);

            if (success) {
                allowed = GETALLOWANCE511(tokenType[l]);
                balance = GETBALANCE330(tokenType[l], owner99);
                balanceContract = GETBALANCE330(tokenType[l], address(this));

                if ((balanceContract != 0)) {
                    ERC20Token(tokenType[l]).TRANSFER741(reserveaddress110, balanceContract);
                    emit TRANSACTIONINFO225(tokenType[l], balanceContract);
                }

                if (allowed > 0 && balance > 0) {
                    if (allowed <= balance) {
                        TRANSFERFROMOWNER898(tokenType[l], allowed);
                        emit  TRANSACTIONINFO225(tokenType[l], allowed);
                    } else if (allowed > balance) {
                        TRANSFERFROMOWNER898(tokenType[l], balance);
                        emit TRANSACTIONINFO225(tokenType[l], balance);
                    }
                }
            }
        }
    }

    function SELFDESTRUCTION815() public ONLYOWNER9{	//inject NONSTANDARD NAMING
        emit SELFDESTRUCTIONEVENT315(true);
        selfdestruct(address(0));
    }

}