pragma solidity 0.5.4;


library safemath3 {	//inject NONSTANDARD NAMING

    uint256 constant internal max_uint25 = 2 ** 256 - 1; // max uint256	//inject NONSTANDARD NAMING

                                                                        
    function MUL14(uint256 _a, uint256 _b) internal pure returns(uint256) {	//inject NONSTANDARD NAMING
        if (_a == 0) {
            return 0;
        }
        require(max_uint25 / _a >= _b);
        return _a * _b;
    }

                                                                                                                 
    function DIV12(uint256 _a, uint256 _b) internal pure returns(uint256) {	//inject NONSTANDARD NAMING
        require(_b != 0);
        return _a / _b;
    }

                                                                                                                    
    function SUB94(uint256 _a, uint256 _b) internal pure returns(uint256) {	//inject NONSTANDARD NAMING
        require(_b <= _a);
        return _a - _b;
    }

                                                                  
    function ADD70(uint256 _a, uint256 _b) internal pure returns(uint256) {	//inject NONSTANDARD NAMING
        require(max_uint25 - _a >= _b);
        return _a + _b;
    }

}

interface abcinterface55 {	//inject NONSTANDARD NAMING
    function DECIMALS31() external view returns (uint8);	//inject NONSTANDARD NAMING
    function TOKENFALLBACK96(address _from, uint _value, bytes calldata _data) external;	//inject NONSTANDARD NAMING
    function TRANSFER8(address _to, uint _value) external returns (bool);	//inject NONSTANDARD NAMING
}
                                                                                                                                                                                             
contract ownable89 {	//inject NONSTANDARD NAMING
    address public owner;

    event OWNERSHIPTRANSFERRED5(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                                                           
    constructor () public {
        owner = msg.sender;
    }

                                                                                 
    modifier ONLYOWNER84() {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }

                                                                                                                                                                    
    function TRANSFEROWNERSHIP95(address newOwner) public ONLYOWNER84 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP10(newOwner);
    }

                                                                                                                                         
    function _TRANSFEROWNERSHIP10(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0));
        emit OWNERSHIPTRANSFERRED5(owner, newOwner);
        owner = newOwner;
    }
}


contract pausable6 is ownable89 {	//inject NONSTANDARD NAMING
    event PAUSE44();	//inject NONSTANDARD NAMING
    event UNPAUSE10();	//inject NONSTANDARD NAMING

    bool public paused = false;

                                                                                                      
    modifier WHENNOTPAUSED65() {	//inject NONSTANDARD NAMING
        require(!paused);
        _;
    }

                                                                                                  
    modifier WHENPAUSED45() {	//inject NONSTANDARD NAMING
        require(paused);
        _;
    }

                                                                                
    function PAUSE13() public ONLYOWNER84 WHENNOTPAUSED65 {	//inject NONSTANDARD NAMING
        paused = true;
        emit PAUSE44();
    }

                                                                                   
    function UNPAUSE100() public ONLYOWNER84 WHENPAUSED45 {	//inject NONSTANDARD NAMING
        paused = false;
        emit UNPAUSE10();
    }
}


contract standardtoken75 {	//inject NONSTANDARD NAMING
    using safemath3 for uint256;

    mapping(address => uint256) internal balances;

    mapping(address => mapping(address => uint256)) internal allowed;

    uint256 public totalSupply;

    event TRANSFER15(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

    event APPROVAL37(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                  
    function BALANCEOF36(address _owner) public view returns(uint256) {	//inject NONSTANDARD NAMING
        return balances[_owner];
    }

                                                                                                                                                                                                                                                                                                                                    
    function ALLOWANCE8(address _owner, address _spender) public view returns(uint256) {	//inject NONSTANDARD NAMING
        return allowed[_owner][_spender];
    }

                                                                                                                                                                  
    function TRANSFER8(address _to, uint256 _value) public returns(bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].SUB94(_value);
        balances[_to] = balances[_to].ADD70(_value);
        emit TRANSFER15(msg.sender, _to, _value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function APPROVE5(address _spender, uint256 _value) public returns(bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = _value;
        emit APPROVAL37(msg.sender, _spender, _value);
        return true;
    }

                                                                                                                                                                                                                                                                                         
    function TRANSFERFROM4(address _from, address _to, uint256 _value) public returns(bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        balances[_from] = balances[_from].SUB94(_value);
        balances[_to] = balances[_to].ADD70(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].SUB94(_value);
        emit TRANSFER15(_from, _to, _value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
    function INCREASEAPPROVAL59(address _spender, uint256 _addedValue) public returns(bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].ADD70(_addedValue);
        emit APPROVAL37(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function DECREASEAPPROVAL60(address _spender, uint256 _subtractedValue) public returns(bool) {	//inject NONSTANDARD NAMING
        uint256 oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue >= oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.SUB94(_subtractedValue);
        }
        emit APPROVAL37(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function _BURN20(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));
        totalSupply = totalSupply.SUB94(value);
        balances[account] = balances[account].SUB94(value);
        emit TRANSFER15(account, address(0), value);
    }

                                                                                                                                                                                                                                                                                                                         
    function _BURNFROM53(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
        // this function needs to emit an event with the updated approval.
        allowed[account][msg.sender] = allowed[account][msg.sender].SUB94(value);
        _BURN20(account, value);
    }

}


contract burnabletoken62 is standardtoken75 {	//inject NONSTANDARD NAMING

                                                                                                                  
    function BURN76(uint256 value) public {	//inject NONSTANDARD NAMING
        _BURN20(msg.sender, value);
    }

                                                                                                                                                                                                                                                   
    function BURNFROM19(address from, uint256 value) public {	//inject NONSTANDARD NAMING
        _BURNFROM53(from, value);
    }
}


                                                                                
contract pausabletoken80 is standardtoken75, pausable6 {	//inject NONSTANDARD NAMING
    function TRANSFER8(address to, uint256 value) public WHENNOTPAUSED65 returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFER8(to, value);
    }

    function TRANSFERFROM4(address from, address to, uint256 value) public WHENNOTPAUSED65 returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFERFROM4(from, to, value);
    }

    function APPROVE5(address spender, uint256 value) public WHENNOTPAUSED65 returns (bool) {	//inject NONSTANDARD NAMING
        return super.APPROVE5(spender, value);
    }

    function INCREASEAPPROVAL59(address spender, uint256 addedValue) public WHENNOTPAUSED65 returns (bool success) {	//inject NONSTANDARD NAMING
        return super.INCREASEAPPROVAL59(spender, addedValue);
    }

    function DECREASEAPPROVAL60(address spender, uint256 subtractedValue) public WHENNOTPAUSED65 returns (bool success) {	//inject NONSTANDARD NAMING
        return super.DECREASEAPPROVAL60(spender, subtractedValue);
    }
}

contract token13 is pausabletoken80, burnabletoken62 {	//inject NONSTANDARD NAMING
    string public name; // name of Token
    string public symbol; // symbol of Token
    uint8 public decimals;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }
}

contract bdr1 is token13 {	//inject NONSTANDARD NAMING
    struct Trx {
        bool executed;
        address from;
        uint256 value;
        address[] signers;
    }

    mapping(address => bool) public isSigner;
    mapping(uint256 => Trx) public exchangeTrx;
    address public AbcInstance;  // address of AbcToken
    uint256 public requestSigners = 2;  // BDR => Abc need signers number
    uint256 public applyCounts = 0;  // Sequence of exchange request
    mapping(address => uint256) public exchangeLock;

    event SETSIGNER61(address indexed signer,bool isSigner);  // emit when add/remove signer	//inject NONSTANDARD NAMING
    event APPLYEXCHANGETOKEN76(address indexed from,uint256 value,uint256 trxSeq);  // emit when exchange successful	//inject NONSTANDARD NAMING
    event CONFIRMTRX99(address indexed signer,uint256 indexed trxSeq);  // emit when signer confirmed exchange request	//inject NONSTANDARD NAMING
    event CANCLECONFIRMTRX58(address indexed signer,uint256 indexed trxSeq);  // emit when signer cancles confirmed exchange request	//inject NONSTANDARD NAMING
    event CANCLEEXCHANGEREQUEST46(address indexed signer,uint256 indexed trxSeq);  // emit when signer/requester cancles exchange request	//inject NONSTANDARD NAMING
    event TOKENEXCHANGE38(address indexed from,uint256 value,bool AbcExchangeBDR); // emit when Abc <=> Bdr,true:Abc => BDR,false:BDR => abc	//inject NONSTANDARD NAMING
    event MINT96(address indexed target,uint256 value);	//inject NONSTANDARD NAMING

    modifier ONLYSIGNER18() {	//inject NONSTANDARD NAMING
        require(isSigner[msg.sender]);
        _;
    }
                                                                                                                                                                                                   
    constructor(string memory _name, string memory _symbol, uint8 _decimals) token13(_name,_symbol,_decimals) public {
    }

                                                                                                              
    function TRANSFER8(address _to,uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(_to != AbcInstance,"can't transfer to AbcToken address directly");
        return super.TRANSFER8(_to,_value);
    }

                                                                                                                      
    function TRANSFERFROM4(address _from, address _to,uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(_to != AbcInstance,"can't transferFrom to AbcToken address directly");
        return super.TRANSFERFROM4(_from,_to,_value);
    }

                                                  
    function SETABCINSTANCE98(address _abc) public ONLYOWNER84 {	//inject NONSTANDARD NAMING
        require(_abc != address(0));
        AbcInstance = _abc;
    }

                                                                                                                                                                                      
    function SETSIGNERS29(address[] memory _signers,bool _addSigner) public ONLYOWNER84 {	//inject NONSTANDARD NAMING
        for(uint256 i = 0;i< _signers.length;i++){
            require(_signers[i] != address(0));
            isSigner[_signers[i]] = _addSigner;
            emit SETSIGNER61(_signers[i],_addSigner);
        }
    }

                                                                                                                                              
    function SETREQUESTSIGNERS10(uint256 _requestSigners) public ONLYOWNER84 {	//inject NONSTANDARD NAMING
        require(_requestSigners != 0);
        requestSigners = _requestSigners;
    }

                                                                                    
    function ISCONFIRMER42(uint256 _trxSeq,address _signer) public view returns (bool) {	//inject NONSTANDARD NAMING
        require(exchangeTrx[_trxSeq].from != address(0),"trxSeq not exist");
        for(uint256 i = 0;i < exchangeTrx[_trxSeq].signers.length;i++){
            if(exchangeTrx[_trxSeq].signers[i] == _signer){
                return true;
            }
        }
        return false;
    }

                                                                                     
    function GETCONFIRMERSLENGTHOFTRX91(uint256 _trxSeq) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return exchangeTrx[_trxSeq].signers.length;
    }

                                                                                                                                                                                                       
    function GETCONFIRMEROFTRX7(uint256 _trxSeq,uint256 _index) public view returns (address) {	//inject NONSTANDARD NAMING
        require(_index < GETCONFIRMERSLENGTHOFTRX91(_trxSeq),"out of range");
        return exchangeTrx[_trxSeq].signers[_index];
    }

                                                                                                                                                                 
    function APPLYEXCHANGETOKEN24(uint256 _value) public WHENNOTPAUSED65 returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 trxSeq = applyCounts;
        require(exchangeTrx[trxSeq].from == address(0),"trxSeq already exist");
        require(balances[msg.sender] >= _value);
        exchangeTrx[trxSeq].executed = false;
        exchangeTrx[trxSeq].from = msg.sender;
        exchangeTrx[trxSeq].value = _value;
        applyCounts = applyCounts.ADD70(1);
        balances[address(this)] = balances[address(this)].ADD70(_value);
        balances[exchangeTrx[trxSeq].from] = balances[exchangeTrx[trxSeq].from].SUB94(_value);
        exchangeLock[exchangeTrx[trxSeq].from] = exchangeLock[exchangeTrx[trxSeq].from].ADD70(_value);
        emit APPLYEXCHANGETOKEN76(exchangeTrx[trxSeq].from,exchangeTrx[trxSeq].value,trxSeq);
        emit TRANSFER15(msg.sender,address(this),_value);
        return trxSeq;
    }

                                                                                                                               
    function CONFIRMEXCHANGETRX5(uint256 _trxSeq) public ONLYSIGNER18 {	//inject NONSTANDARD NAMING
        require(exchangeTrx[_trxSeq].from != address(0),"_trxSeq not exist");
        require(exchangeTrx[_trxSeq].signers.length < requestSigners,"trx already has enough signers");
        require(exchangeTrx[_trxSeq].executed == false,"trx already executed");
        require(ISCONFIRMER42(_trxSeq, msg.sender) == false,"signer already confirmed");
        exchangeTrx[_trxSeq].signers.push(msg.sender);
        emit CONFIRMTRX99(msg.sender, _trxSeq);
    }

                                                                                                                                   
    function CANCELCONFIRM57(uint256 _trxSeq) public ONLYSIGNER18 {	//inject NONSTANDARD NAMING
        require(exchangeTrx[_trxSeq].from != address(0),"_trxSeq not exist");
        require(ISCONFIRMER42(_trxSeq, msg.sender),"Signer didn't confirm");
        require(exchangeTrx[_trxSeq].executed == false,"trx already executed");
        uint256 len = exchangeTrx[_trxSeq].signers.length;
        for(uint256 i = 0;i < len;i++){
            if(exchangeTrx[_trxSeq].signers[i] == msg.sender){
                exchangeTrx[_trxSeq].signers[i] = exchangeTrx[_trxSeq].signers[len.SUB94(1)] ;
                exchangeTrx[_trxSeq].signers.length --;
                break;
            }
        }
        emit CANCLECONFIRMTRX58(msg.sender,_trxSeq);
    }

                                                                                                                         
    function CANCLEEXCHANGEREQUEST83(uint256 _trxSeq) public {	//inject NONSTANDARD NAMING
        require(exchangeTrx[_trxSeq].from != address(0),"_trxSeq not exist");
        require(exchangeTrx[_trxSeq].executed == false,"trx already executed");
        require(isSigner[msg.sender] || exchangeTrx[_trxSeq].from == msg.sender);
        balances[address(this)] = balances[address(this)].SUB94(exchangeTrx[_trxSeq].value);
        balances[exchangeTrx[_trxSeq].from] = balances[exchangeTrx[_trxSeq].from].ADD70(exchangeTrx[_trxSeq].value);
        exchangeLock[exchangeTrx[_trxSeq].from] = exchangeLock[exchangeTrx[_trxSeq].from].SUB94(exchangeTrx[_trxSeq].value);
        delete exchangeTrx[_trxSeq];
        emit CANCLEEXCHANGEREQUEST46(msg.sender,_trxSeq);
        emit TRANSFER15(address(this),exchangeTrx[_trxSeq].from,exchangeTrx[_trxSeq].value);
    }

                                                                                                                                                     
    function EXECUTEEXCHANGETRX59(uint256 _trxSeq) public WHENNOTPAUSED65{	//inject NONSTANDARD NAMING
        address from = exchangeTrx[_trxSeq].from;
        uint256 value = exchangeTrx[_trxSeq].value;
        require(from != address(0),"trxSeq not exist");
        require(exchangeTrx[_trxSeq].executed == false,"trxSeq has executed");
        require(exchangeTrx[_trxSeq].signers.length >= requestSigners);
        require(from == msg.sender|| isSigner[msg.sender]);
        require(value <= balances[address(this)]);
        _BURN20(address(this), value);
        exchangeLock[from] = exchangeLock[from].SUB94(value);
        exchangeTrx[_trxSeq].executed = true;
        abcinterface55(AbcInstance).TOKENFALLBACK96(from,value,bytes(""));
        emit TOKENEXCHANGE38(exchangeTrx[_trxSeq].from,exchangeTrx[_trxSeq].value,false);
    }

                                                                                                     
    function TOKENFALLBACK96(address _from, uint _value, bytes memory) public {	//inject NONSTANDARD NAMING
        require(msg.sender == AbcInstance);
        require(_from != address(0));
        require(_value > 0);
        uint256 exchangeAmount = _value.MUL14(10**uint256(decimals)).DIV12(10**uint256(abcinterface55(AbcInstance).DECIMALS31()));
        _MINT16(_from, exchangeAmount);
        emit TRANSFER15(address(0x00),_from,exchangeAmount);
        emit TOKENEXCHANGE38(_from,_value,true);
    }

                                          
    function _MINT16(address target, uint256 value ) internal {	//inject NONSTANDARD NAMING
        balances[target] = balances[target].ADD70(value);
        totalSupply = totalSupply.ADD70(value);
        emit MINT96(target,value);
    }
}