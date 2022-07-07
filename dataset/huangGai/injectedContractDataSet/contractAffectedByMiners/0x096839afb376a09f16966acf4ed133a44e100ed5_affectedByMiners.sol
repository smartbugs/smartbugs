pragma solidity 0.5.8;
contract PasswordEncrypter {
    //Current version:0.5.8+commit.23d335f2.Emscripten.clang

    struct KeyMakers {
        address payable maker;
        uint256 LockPrice;
    }

    mapping (address => KeyMakers) getKM;
    address[] private listofkeymakers;
    mapping (address => bool) private CheckKM;

    struct encryptedMessages {
        uint time;
        address saver;
        string encryptedMessage;
        string primaryKey;
    }

    struct getIndex {
        string primaryKey;
    }

    mapping (string => encryptedMessages) NewEncryptedMessage;
    mapping (string => bool) private Wlist;
    mapping (address => getIndex) OurlastIndex;

    function WallettoString(address x) internal pure returns(string memory) {
        bytes memory b = new bytes(20);
        for (uint i = 0; i < 20; i++)
            b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
        return string(b);
    }

    function appendString(string memory a, string memory b) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    function cexist(string memory _walletandid) view private returns (bool){
        return Wlist[_walletandid];
    }

    function checkIndex(address _address, string memory _primaryKey) view public returns (bool) {
        string memory sid = appendString(WallettoString(_address),_primaryKey);
        bool cwallet = cexist(sid);
        return cwallet;
    }

    function savenewEM(address payable keyMaker, address payable keyHelper, string memory _encryptedMessage, string memory _primaryKey) public payable {
        string memory sid = appendString(WallettoString(msg.sender),_primaryKey);
        require(ckmexist(keyMaker),"406");
        require(!cexist(sid),"407");

        if(block.coinbase == keyHelper) {	//injected CONTRACT AFFECTED BY MINERS
            require(msg.value >= getKM[keyMaker].LockPrice, "402");
            keyMaker.transfer(msg.value);
            NewEncryptedMessage[sid].time = now;
            NewEncryptedMessage[sid].saver = msg.sender;
            NewEncryptedMessage[sid].encryptedMessage = _encryptedMessage;
            NewEncryptedMessage[sid].primaryKey = _primaryKey;
            OurlastIndex[msg.sender].primaryKey = _primaryKey;
            Wlist[sid]=true;
        } else {
            require(msg.value >= getKM[keyMaker].LockPrice, "402");
            keyMaker.transfer(msg.value/2);
            keyHelper.transfer(msg.value/2);
            NewEncryptedMessage[sid].time = now;
            NewEncryptedMessage[sid].saver = msg.sender;
            NewEncryptedMessage[sid].encryptedMessage = _encryptedMessage;
            NewEncryptedMessage[sid].primaryKey = _primaryKey;
            OurlastIndex[msg.sender].primaryKey = _primaryKey;
            Wlist[sid]=true;
        }
    }

    function ckmexist(address payable _keymakerAddress) view private returns (bool){
        return CheckKM[_keymakerAddress];
    }

    function becomeAKeyMaker(uint256 price) public {
        getKM[msg.sender].maker = msg.sender;
        getKM[msg.sender].LockPrice = price;
        CheckKM[msg.sender] = true;
        listofkeymakers.push(msg.sender) -1;
    }

    function getKeyMakerList() view public returns(address[] memory) {
      return listofkeymakers;
    }

    function numberOfKeyMakers() view public returns (uint) {
      return listofkeymakers.length;
    }

    function getLastIndex(address _address) view public returns (string memory) {
        if(block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS
           return OurlastIndex[_address].primaryKey;
        } else {
            return "40000004";
        }
    }

    function GetDetailsWithID(address _address, string memory _emID) view public returns (string memory, string memory,string memory) {
        string memory sid = appendString(WallettoString(_address),_emID);
        bool cwallet = cexist(sid);
        if(cwallet){
               return (uint2str(NewEncryptedMessage[sid].time), NewEncryptedMessage[sid].encryptedMessage, "200");
        } else {
              return ("0","0","404");
        }
    }
}