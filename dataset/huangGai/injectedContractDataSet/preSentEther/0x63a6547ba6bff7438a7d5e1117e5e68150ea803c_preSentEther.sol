/**
 *Submitted for verification at Etherscan.io on 2020-05-18
*/

pragma solidity ^0.5.14;

contract Forbestnet  {

    event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
    event buyLevelEvent(address indexed _user, uint _level, uint _time);
    event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
    event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
    event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
    event chUplineLogEvent(address indexed _chUpline, uint _idCh, uint _idDw);

    address ownerWallet = 0x9C1aA5BBd5220fcF67e6F1A8ec372d44D76f1B0f;

    mapping (uint => uint) public LEVEL_PRICE;
    uint REFERRER_1_LEVEL_LIMIT = 2;
    uint PERIOD_LENGTH = 64 days;
    uint RENEWAL_NOT_EARLIER = 64 days;


    struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        address[] referral;
        mapping (uint => uint) levelExpired;
    }
    
    
    mapping (address => UserStruct) public users;
    mapping (uint => address) public userList;
    uint public currUserID = 0;

    CryptoHands CRYPTO_HANDS = CryptoHands(0xA22c1B5320108C19dB53f58241Fd64b105562296);
    
    uint public START_TIME = 1576800000; //  Friday, 20 December 2019 1., 0:00:00
    uint public END_OF_PERIOD_1 = START_TIME + 1 days;
    uint public END_OF_PERIOD_2 = START_TIME + 2 days;
    uint public END_OF_PERIOD_3 = START_TIME + 3 days;
    uint public END_OF_PERIOD_4 = START_TIME + 5 days;
    uint public END_OF_PERIOD_5 = START_TIME + 8 days;
    uint public END_OF_PERIOD_6 = START_TIME + 13 days;
    uint public END_OF_PERIOD_7 = START_TIME + 21 days;
    
    uint public ID_OF_PERIOD_1 = 16;
    uint public ID_OF_PERIOD_2 = 32;
    uint public ID_OF_PERIOD_3 = 64;
    uint public ID_OF_PERIOD_4 = 128;
    uint public ID_OF_PERIOD_5 = 256;
    uint public ID_OF_PERIOD_6 = 512;

    
    modifier priorityRegistration() {
        require(now >= START_TIME, 'The time has not come yet');
        
        if(now <= END_OF_PERIOD_7){
            (bool isExist, uint256 id, uint256 referrerID)  = viewCHUser(msg.sender);
            
            require(isExist, 'You must be registered in CryptoHands');
            
            if(now > END_OF_PERIOD_6){
               require( ( CRYPTO_HANDS.viewUserLevelExpired(msg.sender,1) > now ), 'You must be registered in CryptoHands'); 
            } else  if(now > END_OF_PERIOD_5){
               require( ( id<=ID_OF_PERIOD_6 || CRYPTO_HANDS.viewUserLevelExpired(msg.sender,2) > now ), 'You must have level 2 in CryptoHands, or id <= 512'); 
            } else  if(now > END_OF_PERIOD_4){
               require( ( id<=ID_OF_PERIOD_5 || CRYPTO_HANDS.viewUserLevelExpired(msg.sender,3) > now ), 'You must have level 3 in CryptoHands, or id <= 256'); 
            } else  if(now > END_OF_PERIOD_3){
               require( ( id<=ID_OF_PERIOD_4 || CRYPTO_HANDS.viewUserLevelExpired(msg.sender,4) > now ), 'You must have level 4 in CryptoHands, or id <= 128'); 
            } else  if(now > END_OF_PERIOD_2){
               require( ( id<=ID_OF_PERIOD_3 || CRYPTO_HANDS.viewUserLevelExpired(msg.sender,5) > now ), 'You must have level 5 in CryptoHands, or id <= 64'); 
            } else  if(now > END_OF_PERIOD_1){
               require( ( id<=ID_OF_PERIOD_2 || CRYPTO_HANDS.viewUserLevelExpired(msg.sender,6) > now ), 'You must have level 6 in CryptoHands, or id <= 32'); 
            } else{
               require( ( id<=ID_OF_PERIOD_1 || CRYPTO_HANDS.viewUserLevelExpired(msg.sender,7) > now ), 'You must have level 7 in CryptoHands, or id <= 16'); 
            } 
        }

        _;
    }

    constructor() public {

        LEVEL_PRICE[1] = 0.08 ether;
        LEVEL_PRICE[2] = 0.16 ether;
        LEVEL_PRICE[3] = 0.32 ether;
        LEVEL_PRICE[4] = 0.64 ether;
        LEVEL_PRICE[5] = 1.28 ether;
        LEVEL_PRICE[6] = 2.56 ether;
        LEVEL_PRICE[7] = 5.12 ether;
        LEVEL_PRICE[8] = 10.24 ether;

        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist : true,
            id : currUserID,
            referrerID : 0,
            referral : new address[](0)
        });
        users[ownerWallet] = userStruct;
        userList[currUserID] = ownerWallet;

        users[ownerWallet].levelExpired[1] = 77777777777;
        users[ownerWallet].levelExpired[2] = 77777777777;
        users[ownerWallet].levelExpired[3] = 77777777777;
        users[ownerWallet].levelExpired[4] = 77777777777;
        users[ownerWallet].levelExpired[5] = 77777777777;
        users[ownerWallet].levelExpired[6] = 77777777777;
        users[ownerWallet].levelExpired[7] = 77777777777;
        users[ownerWallet].levelExpired[8] = 77777777777;
    }

    function () external payable priorityRegistration(){

        uint level;

        if(msg.value == LEVEL_PRICE[1]){
            level = 1;
        }else if(msg.value == LEVEL_PRICE[2]){
            level = 2;
        }else if(msg.value == LEVEL_PRICE[3]){
            level = 3;
        }else if(msg.value == LEVEL_PRICE[4]){
            level = 4;
        }else if(msg.value == LEVEL_PRICE[5]){
            level = 5;
        }else if(msg.value == LEVEL_PRICE[6]){
            level = 6;
        }else if(msg.value == LEVEL_PRICE[7]){
            level = 7;
        }else if(msg.value == LEVEL_PRICE[8]){
            level = 8;
        }else {
            revert('Incorrect Value send');
        }

        if(users[msg.sender].isExist){
            buyLevel(level);
        } else if(level == 1) {
            uint refId = 0;
            address referrer = bytesToAddress(msg.data);

            if (users[referrer].isExist){
                refId = users[referrer].id;
            } else {
                (bool chIsExist, uint256 chId, uint256 chReferrerID)  = viewCHUser(msg.sender);
                
                if(chIsExist){
                    referrer =  findCHReferrer(chReferrerID);   
                    refId = users[referrer].id;
                }else {
                    revert('Incorrect referrer');
                }
            }

            regUser(refId);
        } else {
            revert("Please buy first level for 0.08 ETH");
        }
    }

    function regUser(uint _referrerID) internal {

        if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT)
        {
            _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
        }


        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist : true,
            id : currUserID,
            referrerID : _referrerID,
            referral : new address[](0)
        });

        users[msg.sender] = userStruct;
        userList[currUserID] = msg.sender;

        users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;

        users[userList[_referrerID]].referral.push(msg.sender);

        payForLevel(1, msg.sender);

        emit regLevelEvent(msg.sender, userList[_referrerID], now);
    }

    function buyLevel(uint _level) internal {
        
        require(users[msg.sender].levelExpired[_level] < now + RENEWAL_NOT_EARLIER, 'The level has already been extended for a long time. Try later');

        if(_level == 1){
            users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
        } else {
            for(uint l =_level-1; l>0; l-- ){
                require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
            }

            if(address(this).balance == 0){	//inject PRESENT ETHER
                users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
            } else {
                users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
            }
        }
        payForLevel(_level, msg.sender);
        emit buyLevelEvent(msg.sender, _level, now);
    }

    function payForLevel(uint _level, address _user) internal {
        
        address referrer = getUserReferrer(_user, _level);

        if(!users[referrer].isExist){
            referrer = userList[1];
        }

        if(users[referrer].levelExpired[_level] >= now ){
            bool result;
            result = address(uint160(referrer)).send(LEVEL_PRICE[_level]);
            emit getMoneyForLevelEvent(referrer, msg.sender, _level, now);
        } else {
            emit lostMoneyForLevelEvent(referrer, msg.sender, _level, now);
            payForLevel(_level,referrer);
        }
    }

    function findFreeReferrer(address _user) public view returns(address) {
        if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT){
            return _user;
        }

        address[] memory referrals = new address[](2046);
        referrals[0] = users[_user].referral[0]; 
        referrals[1] = users[_user].referral[1];

        address freeReferrer;
        bool noFreeReferrer = true;

        for(uint i =0; i<2046;i++){
            if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT){
                if(i<1022){
                    referrals[(i+1)*2] = users[referrals[i]].referral[0];
                    referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
                }
            }else{
                noFreeReferrer = false;
                freeReferrer = referrals[i];
                break;
            }
        }
        require(!noFreeReferrer, 'No Free Referrer');
        return freeReferrer;

    }
    
    function getUserReferrer(address _user, uint _level) public view returns (address) {
      if (_level == 0 || _user == address(0)) {
        return _user;
      }

      return this.getUserReferrer(userList[users[_user].referrerID], _level - 1);
    }    

    function viewUserReferral(address _user) public view returns(address[] memory) {
        return users[_user].referral;
    }

    function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
        return users[_user].levelExpired[_level];
    }
        
    function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
    
    function viewCHUser(address _user) public view returns (bool isExist, uint id,  uint referrerID) {
        return CRYPTO_HANDS.users(_user);
    }

    function viewCHLevelExpired(address _user, uint _level) public view returns (uint) {
        CRYPTO_HANDS.viewUserLevelExpired(_user,_level);
    }
    
    function findCHReferrer(uint _chUserId) internal returns(address) { //view

        address chReferrerAddress = CRYPTO_HANDS.userList(_chUserId);
        
        if(users[chReferrerAddress].isExist){
            emit chUplineLogEvent(chReferrerAddress, _chUserId, users[chReferrerAddress].id);
            return chReferrerAddress;
        } else{
            emit chUplineLogEvent(chReferrerAddress, _chUserId, 0);
            (bool chIsExist, uint256 chId, uint256 chReferrerID)  = viewCHUser(chReferrerAddress); 
            return findCHReferrer(chReferrerID);
        }
    }     
}
contract CryptoHands  {
    struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        address[] referral;
        mapping (uint => uint) levelExpired;
    }    
    
    mapping (address => UserStruct) public users;
    mapping (uint => address) public userList;
    function viewUserLevelExpired(address _user, uint _level) public view returns(uint);
    
}