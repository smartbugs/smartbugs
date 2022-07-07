pragma solidity >=0.5.7 <0.6.0;

                                                                                                                                                                                                                                                                                                                                                                         

                                                                                                   
library SafeMath {
                                                                                  
    function MUL120(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

                                                                                                                           
    function DIV899(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

                                                                                                                              
    function SUB990(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;
        return c;
    }

                                                                            
    function ADD799(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

                                                                                                                                                    
    function MOD285(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}

                  

// see: https://github.com/ethereum/EIPs/issues/677
contract tokenRecipient {
    function TOKENFALLBACK38(address _from, uint256 _value, bytes memory _extraData) public returns (bool);	//inject NONSTANDARD NAMING
}

contract xEuro {

    // see: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
    using SafeMath for uint256;

                                    

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#name
    // function name() constant returns (string name)
    string public name = "xEuro";

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#symbol
    // function symbol() constant returns (string symbol)
    string public symbol = "xEUR";

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#decimals
    // function decimals() constant returns (uint8 decimals)
    uint8 public decimals = 0; // 1 token = 11, no smaller unit

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#totalsupply
    // function totalSupply() constant returns (uint256 totalSupply)
    // we start with zero
    uint256 public totalSupply = 0;

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#balanceof
    // function balanceOf(address _owner) constant returns (uint256 balance)
    mapping(address => uint256) public balanceOf;

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#allowance
    // function allowance(address _owner, address _spender) constant returns (uint256 remaining)
    mapping(address => mapping(address => uint256)) public allowance;

                                       

    // admins
    mapping(address => bool) public isAdmin;

    // addresses allowed to mint tokens:
    mapping(address => bool) public canMint;

    // addresses allowed to transfer tokens from contract's own address:
    mapping(address => bool) public canTransferFromContract;

    // addresses allowed to burn tokens (on contract's own address):
    mapping(address => bool) public canBurn;

                                
    // do not forget about:
    // https://medium.com/@codetractio/a-look-into-paritys-multisig-wallet-bug-affecting-100-million-in-ether-and-tokens-356f5ba6e90a
    constructor() public {// Constructor must be public or internal
        isAdmin[msg.sender] = true;
        canMint[msg.sender] = true;
        canTransferFromContract[msg.sender] = true;
        canBurn[msg.sender] = true;
    }

                           
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#events

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer-1
    event TRANSFER732(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                     
    event DATASENTTOANOTHERCONTRACT500(address indexed _from, address indexed _toContract, bytes _extraData);	//inject NONSTANDARD NAMING

                              
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer
    function TRANSFER626(address _to, uint256 _value) public returns (bool){	//inject NONSTANDARD NAMING
        return TRANSFERFROM372(msg.sender, _to, _value);
    }

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom
    function TRANSFERFROM372(address _from, address _to, uint256 _value) public returns (bool){	//inject NONSTANDARD NAMING

        // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
        require(_value >= 0);

        // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
        require(msg.sender == _from || _value <= allowance[_from][msg.sender] || (_from == address(this) && canTransferFromContract[msg.sender]));

        // check if _from account have required amount
        require(_value <= balanceOf[_from]);

        if (_to == address(this)) {
            // (!) only token holder can send tokens to smart contract to get fiat, not using allowance
            require(_from == msg.sender);
        }

        balanceOf[_from] = balanceOf[_from].SUB990(_value);
        balanceOf[_to] = balanceOf[_to].ADD799(_value);

        // If allowance used, change allowances correspondingly
        if (_from != msg.sender && _from != address(this)) {
            allowance[_from][msg.sender] = allowance[_from][msg.sender].SUB990(_value);
        }

        if (_to == address(this) && _value > 0) {

            require(_value >= minExchangeAmount);

            tokensInEventsCounter++;
            tokensInTransfer[tokensInEventsCounter].from = _from;
            tokensInTransfer[tokensInEventsCounter].value = _value;
            tokensInTransfer[tokensInEventsCounter].receivedOn = now;

            emit TOKENSIN207(
                _from,
                _value,
                tokensInEventsCounter
            );
        }

        emit TRANSFER732(_from, _to, _value);

        return true;
    }

                                                       

                                                                                                                                                                                                                                                                                                                                                                                                               
    function TRANSFERANDCALL810(address _to, uint256 _value, bytes memory _extraData) public returns (bool){	//inject NONSTANDARD NAMING

        tokenRecipient receiver = tokenRecipient(_to);

        if (TRANSFERFROM372(msg.sender, _to, _value)) {

            if (receiver.TOKENFALLBACK38(msg.sender, _value, _extraData)) {

                emit DATASENTTOANOTHERCONTRACT500(msg.sender, _to, _extraData);

                return true;

            }

        }
        return false;
    }

    // the same as above, but for all tokens on user account
    // for example for converting ALL tokens of user account to another tokens
    function TRANSFERALLANDCALL340(address _to, bytes memory _extraData) public returns (bool){	//inject NONSTANDARD NAMING
        return TRANSFERANDCALL810(_to, balanceOf[msg.sender], _extraData);
    }

                                      

                     
    event ADMINADDED919(address indexed by, address indexed newAdmin);//	//inject NONSTANDARD NAMING
    function ADDADMIN78(address _newAdmin) public returns (bool){	//inject NONSTANDARD NAMING
        require(isAdmin[msg.sender]);

        isAdmin[_newAdmin] = true;
        emit ADMINADDED919(msg.sender, _newAdmin);
        return true;
    } //
    event ADMINREMOVED602(address indexed by, address indexed _oldAdmin);//	//inject NONSTANDARD NAMING
    function REMOVEADMIN899(address _oldAdmin) public returns (bool){	//inject NONSTANDARD NAMING
        require(isAdmin[msg.sender]);

        // prevents from deleting the last admin (can be multisig smart contract) by itself:
        require(msg.sender != _oldAdmin);
        isAdmin[_oldAdmin] = false;
        emit ADMINREMOVED602(msg.sender, _oldAdmin);
        return true;
    }

    uint256 minExchangeAmount = 12; // xEuro tokens
    event MINEXCHANGEAMOUNTCHANGED736 (address indexed by, uint256 from, uint256 to); //	//inject NONSTANDARD NAMING
    function CHANGEMINEXCHANGEAMOUNT772(uint256 _minExchangeAmount) public returns (bool){	//inject NONSTANDARD NAMING
        require(isAdmin[msg.sender]);

        uint256 from = minExchangeAmount;
        minExchangeAmount = _minExchangeAmount;
        emit MINEXCHANGEAMOUNTCHANGED736(msg.sender, from, minExchangeAmount);
        return true;
    }

                     
    event ADDRESSADDEDTOCANMINT339(address indexed by, address indexed newAddress); //	//inject NONSTANDARD NAMING
    function ADDTOCANMINT826(address _newAddress) public returns (bool){	//inject NONSTANDARD NAMING
        require(isAdmin[msg.sender]);

        canMint[_newAddress] = true;
        emit ADDRESSADDEDTOCANMINT339(msg.sender, _newAddress);
        return true;
    }//
    event ADDRESSREMOVEDFROMCANMINT615(address indexed by, address indexed removedAddress);//	//inject NONSTANDARD NAMING
    function REMOVEFROMCANMINT471(address _addressToRemove) public returns (bool){	//inject NONSTANDARD NAMING
        require(isAdmin[msg.sender]);

        canMint[_addressToRemove] = false;
        emit ADDRESSREMOVEDFROMCANMINT615(msg.sender, _addressToRemove);
        return true;
    }

                                    
    event ADDRESSADDEDTOCANTRANSFERFROMCONTRACT607(address indexed by, address indexed newAddress); //	//inject NONSTANDARD NAMING
    function ADDTOCANTRANSFERFROMCONTRACT635(address _newAddress) public returns (bool){	//inject NONSTANDARD NAMING
        require(isAdmin[msg.sender]);

        canTransferFromContract[_newAddress] = true;
        emit ADDRESSADDEDTOCANTRANSFERFROMCONTRACT607(msg.sender, _newAddress);
        return true;
    }//
    event ADDRESSREMOVEDFROMCANTRANSFERFROMCONTRACT946(address indexed by, address indexed removedAddress);//	//inject NONSTANDARD NAMING
    function REMOVEFROMCANTRANSFERFROMCONTRACT713(address _addressToRemove) public returns (bool){	//inject NONSTANDARD NAMING
        require(isAdmin[msg.sender]);

        canTransferFromContract[_addressToRemove] = false;
        emit ADDRESSREMOVEDFROMCANTRANSFERFROMCONTRACT946(msg.sender, _addressToRemove);
        return true;
    }

                     
    event ADDRESSADDEDTOCANBURN693(address indexed by, address indexed newAddress); //	//inject NONSTANDARD NAMING
    function ADDTOCANBURN261(address _newAddress) public returns (bool){	//inject NONSTANDARD NAMING
        require(isAdmin[msg.sender]);

        canBurn[_newAddress] = true;
        emit ADDRESSADDEDTOCANBURN693(msg.sender, _newAddress);
        return true;
    }//
    event ADDRESSREMOVEDFROMCANBURN83(address indexed by, address indexed removedAddress);//	//inject NONSTANDARD NAMING
    function REMOVEFROMCANBURN127(address _addressToRemove) public returns (bool){	//inject NONSTANDARD NAMING
        require(isAdmin[msg.sender]);

        canBurn[_addressToRemove] = false;
        emit ADDRESSREMOVEDFROMCANBURN83(msg.sender, _addressToRemove);
        return true;
    }

                                            

                                                                                                                
    uint public mintTokensEventsCounter = 0;//
    struct MintTokensEvent {
        address mintedBy; //
        uint256 fiatInPaymentId;
        uint value;   //
        uint on;    // UnixTime
        uint currentTotalSupply;
    } //
    //  keep all fiat tx ids, to prevent minting tokens twice (or more times) for the same fiat tx
    mapping(uint256 => bool) public fiatInPaymentIds;

    // here we can find a MintTokensEvent by fiatInPaymentId,
    // so we now if tokens were minted for given incoming fiat payment
    mapping(uint256 => MintTokensEvent) public fiatInPaymentsToMintTokensEvent;

    // here we store MintTokensEvent with its ordinal numbers
    mapping(uint256 => MintTokensEvent) public mintTokensEvent; //
    event TOKENSMINTED883(	//inject NONSTANDARD NAMING
        address indexed by,
        uint256 indexed fiatInPaymentId,
        uint value,
        uint currentTotalSupply,
        uint indexed mintTokensEventsCounter
    );

    // tokens should be minted to contracts own address, (!) after that tokens should be transferred using transferFrom
    function MINTTOKENS200(uint256 value, uint256 fiatInPaymentId) public returns (bool){	//inject NONSTANDARD NAMING

        require(canMint[msg.sender]);

        // require that this fiatInPaymentId was not used before:
        require(!fiatInPaymentIds[fiatInPaymentId]);

        require(value >= 0);
        // <<< this is the moment when new tokens appear in the system
        totalSupply = totalSupply.ADD799(value);
        // first token holder of fresh minted tokens is the contract itself
        balanceOf[address(this)] = balanceOf[address(this)].ADD799(value);

        mintTokensEventsCounter++;
        mintTokensEvent[mintTokensEventsCounter].mintedBy = msg.sender;
        mintTokensEvent[mintTokensEventsCounter].fiatInPaymentId = fiatInPaymentId;
        mintTokensEvent[mintTokensEventsCounter].value = value;
        mintTokensEvent[mintTokensEventsCounter].on = block.timestamp;
        mintTokensEvent[mintTokensEventsCounter].currentTotalSupply = totalSupply;
        //
        fiatInPaymentsToMintTokensEvent[fiatInPaymentId] = mintTokensEvent[mintTokensEventsCounter];

        emit TOKENSMINTED883(msg.sender, fiatInPaymentId, value, totalSupply, mintTokensEventsCounter);

        fiatInPaymentIds[fiatInPaymentId] = true;

        return true;

    }

    // requires msg.sender be both 'canMint' and 'canTransferFromContract'
    function MINTANDTRANSFER453(	//inject NONSTANDARD NAMING
        uint256 _value,
        uint256 fiatInPaymentId,
        address _to
    ) public returns (bool){

        if (MINTTOKENS200(_value, fiatInPaymentId) && TRANSFERFROM372(address(this), _to, _value)) {
            return true;
        }
        return false;
    }

                                                                                                      
    uint public tokensInEventsCounter = 0;//
    struct TokensInTransfer {// <<< used in 'transfer'
        address from; //
        uint value;   //
        uint receivedOn; // UnixTime
    } //
    mapping(uint256 => TokensInTransfer) public tokensInTransfer; //
    event TOKENSIN207(	//inject NONSTANDARD NAMING
        address indexed from,
        uint256 value,
        uint256 indexed tokensInEventsCounter
    );//

    uint public burnTokensEventsCounter = 0;//
    struct burnTokensEvent {
        address by; //
        uint256 value;   //
        uint256 tokensInEventId;
        uint256 fiatOutPaymentId;
        uint256 burnedOn; // UnixTime
        uint256 currentTotalSupply;
    } //
    mapping(uint => burnTokensEvent) public burnTokensEvents;

    // we count every fiat payment id used when burn tokens to prevent using it twice
    mapping(uint256 => bool) public fiatOutPaymentIdsUsed; //

    event TOKENSBURNED510(	//inject NONSTANDARD NAMING
        address indexed by,
        uint256 value,
        uint256 indexed tokensInEventId,
        uint256 indexed fiatOutPaymentId,
        uint burnedOn, // UnixTime
        uint currentTotalSupply
    );

    // (!) only contract's own tokens (balanceOf[this]) can be burned
    function BURNTOKENS469(	//inject NONSTANDARD NAMING
        uint256 value,
        uint256 tokensInEventId,
        uint256 fiatOutPaymentId
    ) public returns (bool){

        require(canBurn[msg.sender]);

        require(value >= 0);
        require(balanceOf[address(this)] >= value);

        // require(!tokensInEventIdsUsed[tokensInEventId]);
        require(!fiatOutPaymentIdsUsed[fiatOutPaymentId]);

        balanceOf[address(this)] = balanceOf[address(this)].SUB990(value);
        totalSupply = totalSupply.SUB990(value);

        burnTokensEventsCounter++;
        burnTokensEvents[burnTokensEventsCounter].by = msg.sender;
        burnTokensEvents[burnTokensEventsCounter].value = value;
        burnTokensEvents[burnTokensEventsCounter].tokensInEventId = tokensInEventId;
        burnTokensEvents[burnTokensEventsCounter].fiatOutPaymentId = fiatOutPaymentId;
        burnTokensEvents[burnTokensEventsCounter].burnedOn = block.timestamp;
        burnTokensEvents[burnTokensEventsCounter].currentTotalSupply = totalSupply;

        emit TOKENSBURNED510(msg.sender, value, tokensInEventId, fiatOutPaymentId, block.timestamp, totalSupply);

        fiatOutPaymentIdsUsed[fiatOutPaymentId];

        return true;
    }

}