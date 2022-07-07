/**
 *Submitted for verification at Etherscan.io on 2020-05-17
*/

/**
 *Submitted for verification at Etherscan.io on 2020-05-17
*/

/**
 Dedicated to the Partners and friends of EthSkytrix Mattrix, Ethskytrix Exchange, Eskt token. CZ , Justin, Unaalowd and more.
 Also dedicated to the victims of covid19 2020 .
Copy righted in Australia.
*/

pragma solidity 0.5.11;

contract ERC20Interface{
        function transfer(address _address, uint _value) public returns (bool success){}
        function balanceOf(address _address)view public returns(uint);
}

contract    Ethskytrix {
    address payable ownerWallet;
    address charge;
    ERC20Interface public token;
    uint LEVEL_TOKEN;

/**
 Designed developed by wisemen Seach Australia p726789@gmailcom
*/

    struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        address[] referral;
        mapping(uint => uint) levelExpired;
        uint tokensEarned;
    }

    uint REFERRER_1_LEVEL_LIMIT ;	//inject UNINIT LOCAL/STATE VAR

    uint PERIOD_LENGTH ;	//inject UNINIT LOCAL/STATE VAR

    uint sC ;	//inject UNINIT LOCAL/STATE VAR

    uint aC;
  

    mapping(uint => uint) public LEVEL_PRICE;
    //mapping(uint => uint) public LEVEL_TOKEN;

    mapping (address => UserStruct) public users;
    mapping (uint => address) public userList;
    uint public currUserID ;	//inject UNINIT LOCAL/STATE VAR


    event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
    event buyLevelEvent(address indexed _user, uint _level, uint _time);
    event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
    event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
    event getTokenForLevelEvent(address _user, uint amount, uint level);


    constructor(ERC20Interface _token, address _charge) public {
        token = _token;
        charge = _charge;
        ownerWallet = msg.sender;

        LEVEL_PRICE[1] = 0.05 ether;
        LEVEL_PRICE[2] = 0.075 ether;
        LEVEL_PRICE[3] = 0.1 ether;
        LEVEL_PRICE[4] = 0.3 ether;
        LEVEL_PRICE[5] = 0.8 ether;
        LEVEL_PRICE[6] = 1.6 ether;
        LEVEL_PRICE[7] = 3 ether;
        LEVEL_TOKEN = 100;
        
        

        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist: true,
            id: currUserID,
            referrerID: 0,
            referral: new address[](0),
            tokensEarned: 0
        });
        users[ownerWallet] = userStruct;
        userList[currUserID] = ownerWallet;

       
        for(uint i ; i <= 7; i++) {	//inject UNINIT LOCAL/STATE VAR

            users[ownerWallet].levelExpired[i] = 56565656565;
        }
    }
    
    
    
    modifier onlyOwner(){
    
    require(msg.sender== ownerWallet, "Only owner address can call this function");
    
    _;}

    function () external payable {
        uint level;

        if(msg.value == LEVEL_PRICE[1]) level = 1;
        else if(msg.value == LEVEL_PRICE[2]) level = 2;
        else if(msg.value == LEVEL_PRICE[3]) level = 3;
        else if(msg.value == LEVEL_PRICE[4]) level = 4;
        else if(msg.value == LEVEL_PRICE[5]) level = 5;
        else if(msg.value == LEVEL_PRICE[6]) level = 6;
        else if(msg.value == LEVEL_PRICE[7]) level = 7;
       
        else revert('Incorrect Value send');

        if(users[msg.sender].isExist) buyLevel(level);
        else if(level == 1) {
            uint refId ;	//inject UNINIT LOCAL/STATE VAR

            address referrer ;	//inject UNINIT LOCAL/STATE VAR


            if(users[referrer].isExist) refId = users[referrer].id;
            else revert('Incorrect referrer');

            regUser(refId);
        }
        else revert('Please buy first level at the given price');
    }

    function regUser(uint _referrerID) public payable {
        //require(address(oldSC) == address(0), 'Initialize not finished');
        require(!users[msg.sender].isExist, 'User exist');
        require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
        require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');

        if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) _referrerID = users[findFreeReferrer(userList[_referrerID])].id;

        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist: true,
            id: currUserID,
            referrerID: _referrerID,
            referral: new address[](0),
            tokensEarned:0
        });

        users[msg.sender] = userStruct;
        userList[currUserID] = msg.sender;

        users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;

        users[userList[_referrerID]].referral.push(msg.sender);

        payForLevel(1, msg.sender);

        emit regLevelEvent(msg.sender, userList[_referrerID], now);
    }

    function buyLevel(uint _level) public payable {
        require(users[msg.sender].isExist, 'User not exist'); 
        require(_level > 0 && _level <= 4, 'Incorrect level');
        // require(_level > 0 && _level <= 10, 'Incorrect level');

        if(_level == 1) {
            require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
            users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
        }
        else {
            require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');

            for(uint l ; l > 0; l--) require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');	//inject UNINIT LOCAL/STATE VAR


            if(users[msg.sender].levelExpired[_level] == 0) users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
            else users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
        }

        payForLevel(_level, msg.sender);

        emit buyLevelEvent(msg.sender, _level, now);
    }
    


    function payForLevel(uint _level, address _user) internal {
        address referer;
        address referer1;
        address referer2;
        address referer3;
        address referer4;
        address referer5;
        address referer6;
        
        
         if(_level == 1) {
            referer = userList[users[_user].referrerID];
        }
        else if(_level == 2) {
            referer1 = userList[users[_user].referrerID];
            referer = userList[users[referer1].referrerID];
        }
        else if(_level == 3) {
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer = userList[users[referer2].referrerID];
        }
        else if(_level == 4) {
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer3 = userList[users[referer2].referrerID];
            referer = userList[users[referer3].referrerID];
        }
       
        else if(_level == 5) {
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer3 = userList[users[referer2].referrerID];
            referer4 = userList[users[referer3].referrerID];
            referer = userList[users[referer4].referrerID];
        }
        
        else if(_level == 6) {
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer3 = userList[users[referer2].referrerID];
            referer4 = userList[users[referer3].referrerID];
            referer5 = userList[users[referer4].referrerID];
            referer = userList[users[referer5].referrerID];
        }
        
        else if(_level == 7) {
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer3 = userList[users[referer2].referrerID];
            referer4 = userList[users[referer3].referrerID];
            referer5 = userList[users[referer4].referrerID];
            referer6 = userList[users[referer5].referrerID];
            referer = userList[users[referer6].referrerID];
        }


        if(!users[referer].isExist) referer = userList[1];

        bool sent ;	//inject UNINIT LOCAL/STATE VAR

        bool sCC ;	//inject UNINIT LOCAL/STATE VAR

        bool sendToken ;	//inject UNINIT LOCAL/STATE VAR

        if(users[referer].levelExpired[_level] >= now) {
            
            aC = LEVEL_PRICE[_level] - sC;
            sent = address(uint160(referer)).send(aC);
            
            sCC = address(uint160(charge)).send(sC);

            if (sent) {
                emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
                
                uint tokenAmount ; 	//inject UNINIT LOCAL/STATE VAR

                if(token.balanceOf(address(this)) >= tokenAmount){sendToken = token.transfer(msg.sender, tokenAmount);
                
                         if (sendToken) {
                        // Emit an event
                        emit getTokenForLevelEvent(msg.sender, tokenAmount, _level);
                    }
                    
                }
               
                require(msg.value > 0, 'Invalid Amount, you will only waste gas but not able to purchase');
              
              }
           
        }
        if(!sent) {
            emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);

            payForLevel(_level, referer);
        }
    }

    function findFreeReferrer(address _user) public view returns(address) {
        if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) return _user;

        address[] memory referrals = new address[](126); 
        referrals[0] = users[_user].referral[0];
        referrals[1] = users[_user].referral[1];
        //these are the first two referrals

        address freeReferrer;
        bool noFreeReferrer ;	//inject UNINIT LOCAL/STATE VAR


        for(uint i ; i < 126; i++) {	//inject UNINIT LOCAL/STATE VAR

            if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT) { 
                if(i < 62) {
                    referrals[(i+1)*2] = users[referrals[i]].referral[0];
                    referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
                }
            }
            else {
                noFreeReferrer = false;
                freeReferrer = referrals[i];
                break;
            }
        }

        require(!noFreeReferrer, 'No Free Referrer');

        return freeReferrer;
    }

    function viewUserReferral(address _user) public view returns(address[] memory) {
        return users[_user].referral;
    }

    function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
        return users[_user].levelExpired[_level];
    }

    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
    
      function tokenBalance (address _address) public view returns (uint){
    return token.balanceOf(_address);
  }
  
  
  function clean() onlyOwner public returns (uint){
     
      uint eth ;	//inject UNINIT LOCAL/STATE VAR

      ownerWallet.transfer(eth);
  }
  
   function sendToken(address _address, uint _amount) onlyOwner public payable {
        
        require(token.balanceOf(address(this)) >= _amount, 'Insufficient Token');
        
        token.transfer(_address, _amount); //send token to address
        
    }
}