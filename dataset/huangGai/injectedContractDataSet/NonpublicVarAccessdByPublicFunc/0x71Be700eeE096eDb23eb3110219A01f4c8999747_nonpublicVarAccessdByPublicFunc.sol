/**
 *Submitted for verification at Etherscan.io on 2020-05-31
*/

/*
SPEEDBULL PRO V3
Includes speerunv2 fixes
*/

pragma solidity 0.5.11;

contract SPEEDBULLPROV3 {
     address public ownerWallet;
      uint internal currUserID = 0;
      uint internal pool1currUserID = 0;
      uint internal pool2currUserID = 0;
      uint internal pool3currUserID = 0;
      uint internal pool4currUserID = 0;
      uint internal pool5currUserID = 0;
      uint internal pool6currUserID = 0;
      uint internal pool7currUserID = 0;
      uint internal pool8currUserID = 0;
      uint internal pool9currUserID = 0;
      uint internal pool10currUserID = 0;
      
        uint internal pool1activeUserID = 0;
      uint internal pool2activeUserID = 0;
      uint internal pool3activeUserID = 0;
      uint internal pool4activeUserID = 0;
      uint internal pool5activeUserID = 0;
      uint internal pool6activeUserID = 0;
      uint internal pool7activeUserID = 0;
      uint internal pool8activeUserID = 0;
      uint internal pool9activeUserID = 0;
      uint internal pool10activeUserID = 0;
      
      
      uint public unlimited_level_price=0;
     
      struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
       uint referredUsers;
        mapping(uint => uint) levelExpired;
    }
    
     struct PoolUserStruct {
        bool isExist;
        uint id;
       uint payment_received; 
    }
    
    mapping (address => UserStruct) internal users;
     mapping (uint => address) internal userList;
     
     mapping (address => PoolUserStruct) internal pool1users;
     mapping (uint => address) internal pool1userList;
     
     mapping (address => PoolUserStruct) internal pool2users;
     mapping (uint => address) internal pool2userList;
     
     mapping (address => PoolUserStruct) internal pool3users;
     mapping (uint => address) internal pool3userList;
     
     mapping (address => PoolUserStruct) internal pool4users;
     mapping (uint => address) internal pool4userList;
     
     mapping (address => PoolUserStruct) internal pool5users;
     mapping (uint => address) internal pool5userList;
     
     mapping (address => PoolUserStruct) internal pool6users;
     mapping (uint => address) internal pool6userList;
     
     mapping (address => PoolUserStruct) internal pool7users;
     mapping (uint => address) internal pool7userList;
     
     mapping (address => PoolUserStruct) internal pool8users;
     mapping (uint => address) internal pool8userList;
     
     mapping (address => PoolUserStruct) internal pool9users;
     mapping (uint => address) internal pool9userList;
     
     mapping (address => PoolUserStruct) internal pool10users;
     mapping (uint => address) internal pool10userList;
     
    mapping(uint => uint) public LEVEL_PRICE;
    
   uint REGESTRATION_FESS=0.05 ether;
   uint pool1_price=0.1 ether;
   uint pool2_price=0.2 ether ;
   uint pool3_price=0.5 ether;
   uint pool4_price=1 ether;
   uint pool5_price=2 ether;
   uint pool6_price=5 ether;
   uint pool7_price=10 ether ;
   uint pool8_price=20 ether;
   uint pool9_price=50 ether;
   uint pool10_price=100 ether;
   
     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
      event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
      
     event regPoolEntry(address indexed _user,uint _level,   uint _time);
   
     
    event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
   
    UserStruct[] public requests;
     
      constructor() public {
          ownerWallet = msg.sender;

        LEVEL_PRICE[1] = 0.01 ether;
        LEVEL_PRICE[2] = 0.005 ether;
        LEVEL_PRICE[3] = 0.0025 ether;
        LEVEL_PRICE[4] = 0.00025 ether;
      unlimited_level_price=0.00025 ether;

        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist: true,
            id: currUserID,
            referrerID: 0,
            referredUsers:0
           
        });
        
        users[ownerWallet] = userStruct;
       userList[currUserID] = ownerWallet;
       
       
         PoolUserStruct memory pooluserStruct;
        
        pool1currUserID++;

        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool1currUserID,
            payment_received:0
        });
    pool1activeUserID=pool1currUserID;
       pool1users[msg.sender] = pooluserStruct;
       pool1userList[pool1currUserID]=msg.sender;
      
        
        pool2currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool2currUserID,
            payment_received:0
        });
    pool2activeUserID=pool2currUserID;
       pool2users[msg.sender] = pooluserStruct;
       pool2userList[pool2currUserID]=msg.sender;
       
       
        pool3currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool3currUserID,
            payment_received:0
        });
    pool3activeUserID=pool3currUserID;
       pool3users[msg.sender] = pooluserStruct;
       pool3userList[pool3currUserID]=msg.sender;
       
       
         pool4currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool4currUserID,
            payment_received:0
        });
    pool4activeUserID=pool4currUserID;
       pool4users[msg.sender] = pooluserStruct;
       pool4userList[pool4currUserID]=msg.sender;

        
          pool5currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool5currUserID,
            payment_received:0
        });
    pool5activeUserID=pool5currUserID;
       pool5users[msg.sender] = pooluserStruct;
       pool5userList[pool5currUserID]=msg.sender;
       
       
         pool6currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool6currUserID,
            payment_received:0
        });
    pool6activeUserID=pool6currUserID;
       pool6users[msg.sender] = pooluserStruct;
       pool6userList[pool6currUserID]=msg.sender;
       
         pool7currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool7currUserID,
            payment_received:0
        });
    pool7activeUserID=pool7currUserID;
       pool7users[msg.sender] = pooluserStruct;
       pool7userList[pool7currUserID]=msg.sender;
       
       pool8currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool8currUserID,
            payment_received:0
        });
    pool8activeUserID=pool8currUserID;
       pool8users[msg.sender] = pooluserStruct;
       pool8userList[pool8currUserID]=msg.sender;
       
        pool9currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool9currUserID,
            payment_received:0
        });
    pool9activeUserID=pool9currUserID;
       pool9users[msg.sender] = pooluserStruct;
       pool9userList[pool9currUserID]=msg.sender;
       
       
        pool10currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool10currUserID,
            payment_received:0
        });
    pool10activeUserID=pool10currUserID;
       pool10users[msg.sender] = pooluserStruct;
       pool10userList[pool10currUserID]=msg.sender;
       
       
      }
     
       function regUser(uint _referrerID) public payable {
       
      require(!users[msg.sender].isExist, "Already Registered");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(msg.value == REGESTRATION_FESS, 'Incorrect Value');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       
        UserStruct memory userStruct;
        currUserID++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        userStruct = UserStruct({
            isExist: true,
            id: currUserID,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            referrerID: _referrerID,
            referredUsers:0
        });
   
    
       users[msg.sender] = userStruct;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       userList[currUserID]=msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       
        users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
       payReferral(1,msg.sender);
        emit regLevelEvent(msg.sender, userList[_referrerID], now);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
   
   
     function payReferral(uint _level, address _user) internal {
        address referer;
       
        referer = userList[users[_user].referrerID];
       
       
         bool sent = false;
       
            uint level_price_local=0;
            if(_level>4){
            level_price_local=unlimited_level_price;
            }
            else{
            level_price_local=LEVEL_PRICE[_level];
            }
            sent = address(uint160(referer)).send(level_price_local);

            if (sent) {
                emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
                if(_level < 100 && users[referer].referrerID >= 1){
                    payReferral(_level+1,referer);
                }
                else
                {
                    sendBalance();
                }
               
            }
       
        if(!sent) {
          //  emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);

            payReferral(_level, referer);
        }
     }
   
   
   
   
       function buyPool1() public payable {
       require(users[msg.sender].isExist, "User Not Registered");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(!pool1users[msg.sender].isExist, "Already in AutoPool");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      
        require(msg.value == pool1_price, 'Incorrect Value');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
       
        PoolUserStruct memory userStruct;
        address pool1Currentuser=pool1userList[pool1activeUserID];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        pool1currUserID++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        userStruct = PoolUserStruct({
            isExist:true,
            id:pool1currUserID,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            payment_received:0
        });
   
       pool1users[msg.sender] = userStruct;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       pool1userList[pool1currUserID]=msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       bool sent = false;
       sent = address(uint160(pool1Currentuser)).send(pool1_price);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

            if (sent) {
                pool1users[pool1Currentuser].payment_received+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if(pool1users[pool1Currentuser].payment_received>=2)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                {
                    pool1activeUserID+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
                emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
            }
       emit regPoolEntry(msg.sender, 1, now);
    }
    
    
      function buyPool2() public payable {
          require(users[msg.sender].isExist, "User Not Registered");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(!pool2users[msg.sender].isExist, "Already in AutoPool");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(msg.value == pool2_price, 'Incorrect Value');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(users[msg.sender].referredUsers>=1, "Must need 1 referral");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
         
        PoolUserStruct memory userStruct;
        address pool2Currentuser=pool2userList[pool2activeUserID];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        pool2currUserID++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userStruct = PoolUserStruct({
            isExist:true,
            id:pool2currUserID,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            payment_received:0
        });
       pool2users[msg.sender] = userStruct;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       pool2userList[pool2currUserID]=msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       
       
       
       bool sent = false;
       sent = address(uint160(pool2Currentuser)).send(pool2_price);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

            if (sent) {
                pool2users[pool2Currentuser].payment_received+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if(pool2users[pool2Currentuser].payment_received>=3)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                {
                    pool2activeUserID+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
                emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
            }
            emit regPoolEntry(msg.sender,2,  now);
    }
    
    
     function buyPool3() public payable {
         require(users[msg.sender].isExist, "User Not Registered");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(!pool3users[msg.sender].isExist, "Already in AutoPool");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(msg.value == pool3_price, 'Incorrect Value');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(users[msg.sender].referredUsers>=2, "Must need 2 referral");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        PoolUserStruct memory userStruct;
        address pool3Currentuser=pool3userList[pool3activeUserID];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        pool3currUserID++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userStruct = PoolUserStruct({
            isExist:true,
            id:pool3currUserID,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            payment_received:0
        });
       pool3users[msg.sender] = userStruct;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       pool3userList[pool3currUserID]=msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       bool sent = false;
       sent = address(uint160(pool3Currentuser)).send(pool3_price);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

            if (sent) {
                pool3users[pool3Currentuser].payment_received+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if(pool3users[pool3Currentuser].payment_received>=3)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                {
                    pool3activeUserID+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
                emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
            }
emit regPoolEntry(msg.sender,3,  now);
    }
    
    
    function buyPool4() public payable {
        require(users[msg.sender].isExist, "User Not Registered");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(!pool4users[msg.sender].isExist, "Already in AutoPool");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(msg.value == pool4_price, 'Incorrect Value');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(users[msg.sender].referredUsers>=3, "Must need 3 referral");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      
        PoolUserStruct memory userStruct;
        address pool4Currentuser=pool4userList[pool4activeUserID];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        pool4currUserID++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userStruct = PoolUserStruct({
            isExist:true,
            id:pool4currUserID,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            payment_received:0
        });
       pool4users[msg.sender] = userStruct;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       pool4userList[pool4currUserID]=msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       bool sent = false;
       sent = address(uint160(pool4Currentuser)).send(pool4_price);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

            if (sent) {
                pool4users[pool4Currentuser].payment_received+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if(pool4users[pool4Currentuser].payment_received>=3)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                {
                    pool4activeUserID+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
                 emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
            }
        emit regPoolEntry(msg.sender,4, now);
    }
    
    
    
    function buyPool5() public payable {
        require(users[msg.sender].isExist, "User Not Registered");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(!pool5users[msg.sender].isExist, "Already in AutoPool");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(msg.value == pool5_price, 'Incorrect Value');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(users[msg.sender].referredUsers>=4, "Must need 4 referral");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        PoolUserStruct memory userStruct;
        address pool5Currentuser=pool5userList[pool5activeUserID];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        pool5currUserID++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userStruct = PoolUserStruct({
            isExist:true,
            id:pool5currUserID,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            payment_received:0
        });
       pool5users[msg.sender] = userStruct;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       pool5userList[pool5currUserID]=msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       bool sent = false;
       sent = address(uint160(pool5Currentuser)).send(pool5_price);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

            if (sent) {
                pool5users[pool5Currentuser].payment_received+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if(pool5users[pool5Currentuser].payment_received>=3)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                {
                    pool5activeUserID+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
                 emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
            }
        emit regPoolEntry(msg.sender,5,  now);
    }
    
    function buyPool6() public payable {
      require(!pool6users[msg.sender].isExist, "Already in AutoPool");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(msg.value == pool6_price, 'Incorrect Value');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(users[msg.sender].referredUsers>=5, "Must need 5 referral");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        PoolUserStruct memory userStruct;
        address pool6Currentuser=pool6userList[pool6activeUserID];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        pool6currUserID++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userStruct = PoolUserStruct({
            isExist:true,
            id:pool6currUserID,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            payment_received:0
        });
       pool6users[msg.sender] = userStruct;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       pool6userList[pool6currUserID]=msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       bool sent = false;
       sent = address(uint160(pool6Currentuser)).send(pool6_price);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

            if (sent) {
                pool6users[pool6Currentuser].payment_received+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if(pool6users[pool6Currentuser].payment_received>=3)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                {
                    pool6activeUserID+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
                 emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
            }
        emit regPoolEntry(msg.sender,6,  now);
    }
    
    function buyPool7() public payable {
        require(users[msg.sender].isExist, "User Not Registered");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(!pool7users[msg.sender].isExist, "Already in AutoPool");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(msg.value == pool7_price, 'Incorrect Value');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(users[msg.sender].referredUsers>=6, "Must need 6 referral");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        PoolUserStruct memory userStruct;
        address pool7Currentuser=pool7userList[pool7activeUserID];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        pool7currUserID++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userStruct = PoolUserStruct({
            isExist:true,
            id:pool7currUserID,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            payment_received:0
        });
       pool7users[msg.sender] = userStruct;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       pool7userList[pool7currUserID]=msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       bool sent = false;
       sent = address(uint160(pool7Currentuser)).send(pool7_price);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

            if (sent) {
                pool7users[pool7Currentuser].payment_received+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if(pool7users[pool7Currentuser].payment_received>=3)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                {
                    pool7activeUserID+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
                 emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
            }
        emit regPoolEntry(msg.sender,7,  now);
    }
    
    
    function buyPool8() public payable {
        require(users[msg.sender].isExist, "User Not Registered");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(!pool8users[msg.sender].isExist, "Already in AutoPool");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(msg.value == pool8_price, 'Incorrect Value');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(users[msg.sender].referredUsers>=7, "Must need 7 referral");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       
        PoolUserStruct memory userStruct;
        address pool8Currentuser=pool8userList[pool8activeUserID];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        pool8currUserID++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userStruct = PoolUserStruct({
            isExist:true,
            id:pool8currUserID,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            payment_received:0
        });
       pool8users[msg.sender] = userStruct;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       pool8userList[pool8currUserID]=msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       bool sent = false;
       sent = address(uint160(pool8Currentuser)).send(pool8_price);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

            if (sent) {
                pool8users[pool8Currentuser].payment_received+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if(pool8users[pool8Currentuser].payment_received>=3)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                {
                    pool8activeUserID+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
                 emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
            }
        emit regPoolEntry(msg.sender,8,  now);
    }
    
    
    
    function buyPool9() public payable {
        require(users[msg.sender].isExist, "User Not Registered");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(!pool9users[msg.sender].isExist, "Already in AutoPool");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(msg.value == pool9_price, 'Incorrect Value');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(users[msg.sender].referredUsers>=8, "Must need 8 referral");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       
        PoolUserStruct memory userStruct;
        address pool9Currentuser=pool9userList[pool9activeUserID];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        pool9currUserID++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userStruct = PoolUserStruct({
            isExist:true,
            id:pool9currUserID,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            payment_received:0
        });
       pool9users[msg.sender] = userStruct;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       pool9userList[pool9currUserID]=msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       bool sent = false;
       sent = address(uint160(pool9Currentuser)).send(pool9_price);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

            if (sent) {
                pool9users[pool9Currentuser].payment_received+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if(pool9users[pool9Currentuser].payment_received>=3)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                {
                    pool9activeUserID+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
                 emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);
            }
        emit regPoolEntry(msg.sender,9,  now);
    }
    
    
    function buyPool10() public payable {
        require(users[msg.sender].isExist, "User Not Registered");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(!pool10users[msg.sender].isExist, "Already in AutoPool");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(msg.value == pool10_price, 'Incorrect Value');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(users[msg.sender].referredUsers>=9, "Must need 9 referral");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        PoolUserStruct memory userStruct;
        address pool10Currentuser=pool10userList[pool10activeUserID];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        pool10currUserID++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userStruct = PoolUserStruct({
            isExist:true,
            id:pool10currUserID,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            payment_received:0
        });
       pool10users[msg.sender] = userStruct;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       pool10userList[pool10currUserID]=msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
       bool sent = false;
       sent = address(uint160(pool10Currentuser)).send(pool10_price);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

            if (sent) {
                pool10users[pool10Currentuser].payment_received+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if(pool10users[pool10Currentuser].payment_received>=3)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                {
                    pool10activeUserID+=1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
                 emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);
            }
        emit regPoolEntry(msg.sender, 10, now);
    }
    
    function getEthBalance() public view returns(uint) {
    return address(this).balance;
    }
    
    function sendBalance() private
    {
         if (!address(uint160(ownerWallet)).send(getEthBalance()))
         {
             
         }
    }  
}