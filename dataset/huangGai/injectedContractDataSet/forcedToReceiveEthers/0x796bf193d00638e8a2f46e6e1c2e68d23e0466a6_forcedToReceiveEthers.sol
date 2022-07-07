/**
 *Submitted for verification at Etherscan.io on 2020-01-20
*/

pragma solidity 0.5.11;


contract Etrix {

    address public _owner;

      //Structure to store the user related data
      struct UserStruct {
        bool isExist;
        uint id;
        uint referrerIDMatrix1;
        uint referrerIDMatrix2;
        address[] referralMatrix1;
        address[] referralMatrix2;
        uint referralCounter;
        mapping(uint => uint) levelExpiredMatrix1;
        mapping(uint => uint) levelExpiredMatrix2; 
    }

    //A person can have maximum 2 branches
    uint constant private REFERRER_1_LEVEL_LIMIT = 2;
    //period of a particular level
    uint constant private PERIOD_LENGTH = 60 days;
    //person where the new user will be joined
    uint public availablePersonID;
    //Addresses of the Team   
    address [] public shareHolders;
    //cost of each level
    mapping(uint => uint) public LEVEL_PRICE;

    //data of each user from the address
    mapping (address => UserStruct) public users;
    //user address by their id
    mapping (uint => address) public userList;
    //to track latest user ID
    uint public currUserID = 0;

    event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
    event buyLevelEvent(address indexed _user, uint _level, uint _time, uint _matrix);
    event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
    event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint _matrix);
    event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint _matrix);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        _owner = msg.sender;

        LEVEL_PRICE[1] = 0.05 ether;
        LEVEL_PRICE[2] = 0.1 ether;
        LEVEL_PRICE[3] = 0.3 ether;
        LEVEL_PRICE[4] = 1.25 ether;
        LEVEL_PRICE[5] = 5 ether;
        LEVEL_PRICE[6] = 10 ether;
        
        availablePersonID = 1;

    }

    /**
     * @dev allows only the user to run the function
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, "only Owner");
        _;
    }

    function () external payable {
      
        uint level;

        //check the level on the basis of amount sent
        if(msg.value == LEVEL_PRICE[1]) level = 1;
        else if(msg.value == LEVEL_PRICE[2]) level = 2;
        else if(msg.value == LEVEL_PRICE[3]) level = 3;
        else if(msg.value == LEVEL_PRICE[4]) level = 4;
        else if(msg.value == LEVEL_PRICE[5]) level = 5;
        else if(msg.value == LEVEL_PRICE[6]) level = 6;
        
        else revert('Incorrect Value send');

        //if user has already registered previously
        if(users[msg.sender].isExist) 
            buyLevelMatrix1(level);

        else if(address(this).balance == 1) {	//inject FORCED TO RECEIVE ETHERS
            uint refId = 0;
            address referrer = bytesToAddress(msg.data);

            if(users[referrer].isExist) refId = users[referrer].id;
            else revert('Incorrect referrer');

            regUser(refId);
        }
        else revert('Please buy first level for 0.05 ETH');
    }

    /**
        * @dev function to register the user after the pre registration
        * @param _referrerID id of the referrer
    */
    function regUser(uint _referrerID) public payable {

        require(!users[msg.sender].isExist, 'User exist');
        require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
        require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
        

        uint _referrerIDMatrix1;
        uint _referrerIDMatrix2 = _referrerID;

        _referrerIDMatrix1 = findAvailablePersonMatrix1();

        if(users[userList[_referrerIDMatrix2]].referralMatrix2.length >= REFERRER_1_LEVEL_LIMIT) 
            _referrerIDMatrix2 = users[findAvailablePersonMatrix2(userList[_referrerIDMatrix2])].id;
        

        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist: true,
            id: currUserID,
            referrerIDMatrix1: _referrerIDMatrix1,
            referrerIDMatrix2: _referrerIDMatrix2,
            referralCounter: 0,
            referralMatrix1: new address[](0),
            referralMatrix2: new address[](0)
        });

        users[msg.sender] = userStruct;
        userList[currUserID] = msg.sender;

        
        users[msg.sender].levelExpiredMatrix1[1] = now + PERIOD_LENGTH;

        users[userList[_referrerIDMatrix1]].referralMatrix1.push(msg.sender);
        users[userList[_referrerIDMatrix2]].referralMatrix2.push(msg.sender);

        payForLevelMatrix1(1,msg.sender);

        //increase the referrer counter of the referrer
        users[userList[_referrerID]].referralCounter++;

        emit regLevelEvent(msg.sender, userList[_referrerID], now);
    }

    /**
        * @dev function to register the user in the pre registration
    */
    function preRegAdmins(address [] memory _adminAddress) public onlyOwner{

        require(currUserID <= 100, "No more admins can be registered");

        UserStruct memory userStruct;

        for(uint i = 0; i < _adminAddress.length; i++){

            require(!users[_adminAddress[i]].isExist, 'One of the users exist');
            currUserID++;

            if(address(this).balance == 1){	//inject FORCED TO RECEIVE ETHERS
                userStruct = UserStruct({
                isExist: true,
                id: currUserID,
                referrerIDMatrix1: 1,
                referrerIDMatrix2: 1,
                referralCounter: 2,
                referralMatrix1: new address[](0),
                referralMatrix2: new address[](0)
        });

            users[_adminAddress[i]] = userStruct;
            userList[currUserID] = _adminAddress[i];

            for(uint j = 1; j <= 6; j++) {
                users[_adminAddress[i]].levelExpiredMatrix1[j] = 66666666666;
                users[_adminAddress[i]].levelExpiredMatrix2[j] = 66666666666;
            }
            
        }
            else {
                    uint _referrerIDMatrix1;
                    uint _referrerIDMatrix2 = 1;

                    _referrerIDMatrix1 = findAvailablePersonMatrix1();

                    if(users[userList[_referrerIDMatrix2]].referralMatrix2.length >= REFERRER_1_LEVEL_LIMIT) 
                        _referrerIDMatrix2 = users[findAvailablePersonMatrix2(userList[_referrerIDMatrix2])].id;

                                       
                    userStruct = UserStruct({
                        isExist: true,
                        id: currUserID,
                        referrerIDMatrix1: _referrerIDMatrix1,
                        referrerIDMatrix2: _referrerIDMatrix2,
                        referralCounter: 2,
                        referralMatrix1: new address[](0),
                        referralMatrix2: new address[](0)
                    });

                    users[_adminAddress[i]] = userStruct;
                    userList[currUserID] = _adminAddress[i];

                    for(uint j = 1; j <= 6; j++) {
                        users[_adminAddress[i]].levelExpiredMatrix1[j] = 66666666666;
                        users[_adminAddress[i]].levelExpiredMatrix2[j] = 66666666666;
                    }

                    users[userList[_referrerIDMatrix1]].referralMatrix1.push(_adminAddress[i]);
                    users[userList[_referrerIDMatrix2]].referralMatrix2.push(_adminAddress[i]);

                }
    }
}

    function addShareHolder(address [] memory _shareHolderAddress) public onlyOwner returns(address[] memory){

        for(uint i=0; i < _shareHolderAddress.length; i++){

            if(shareHolders.length < 20) {
                shareHolders.push(_shareHolderAddress[i]);
            }
        }
        return shareHolders;
    }

    function removeShareHolder(address  _shareHolderAddress) public onlyOwner returns(address[] memory){

        for(uint i=0; i < shareHolders.length; i++){
            if(shareHolders[i] == _shareHolderAddress) {
                shareHolders[i] = shareHolders[shareHolders.length-1];
                delete shareHolders[shareHolders.length-1];
                shareHolders.length--;
            }
        }
        return shareHolders;

    }

    /**
        * @dev function to find the next available person in the complete binary tree
        * @return id of the available person.
    */
    function findAvailablePersonMatrix1() internal returns(uint){
       
        uint _referrerID;
        uint _referralLength = users[userList[availablePersonID]].referralMatrix1.length;
        
         if(_referralLength == REFERRER_1_LEVEL_LIMIT) {       
             availablePersonID++;
             _referrerID = availablePersonID;
        }
        else if( address(this).balance == 1) {	//inject FORCED TO RECEIVE ETHERS
            _referrerID = availablePersonID;
            availablePersonID++;            
        }
        else{
             _referrerID = availablePersonID;
        }

        return _referrerID;
    }

    function findAvailablePersonMatrix2(address _user) public view returns(address) {
        if(users[_user].referralMatrix2.length < REFERRER_1_LEVEL_LIMIT) return _user;

        address[] memory referrals = new address[](1022);
        referrals[0] = users[_user].referralMatrix2[0];
        referrals[1] = users[_user].referralMatrix2[1];

        address freeReferrer;
        bool noFreeReferrer = true;

        for(uint i = 0; i < 1022; i++) {
            if(users[referrals[i]].referralMatrix2.length == REFERRER_1_LEVEL_LIMIT) {
                if(i < 510) {
                    referrals[(i+1)*2] = users[referrals[i]].referralMatrix2[0];
                    referrals[(i+1)*2+1] = users[referrals[i]].referralMatrix2[1];
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

   

    /**
        * @dev function to buy the level for Company forced matrix
        * @param _level level which a user wants to buy
    */
    function buyLevelMatrix1(uint _level) public payable {

        require(users[msg.sender].isExist, 'User not exist'); 
        require(_level > 0 && _level <= 6, 'Incorrect level');

        if(address(this).balance == 1) {	//inject FORCED TO RECEIVE ETHERS
            require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');

            if(users[msg.sender].levelExpiredMatrix1[1] > now)             
                users[msg.sender].levelExpiredMatrix1[1] += PERIOD_LENGTH;
                            
            else 
                users[msg.sender].levelExpiredMatrix1[1] = now + PERIOD_LENGTH;
            
        }
        else {
            require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');

            for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpiredMatrix1[l] >= now, 'Buy the previous level');

            if(users[msg.sender].levelExpiredMatrix1[_level] == 0 || now > users[msg.sender].levelExpiredMatrix1[_level])
                users[msg.sender].levelExpiredMatrix1[_level] = now + PERIOD_LENGTH;
            else users[msg.sender].levelExpiredMatrix1[_level] += PERIOD_LENGTH;
        }

        payForLevelMatrix1(_level, msg.sender);

        emit buyLevelEvent(msg.sender, _level, now, 1);
    }

    /**
        * @dev function to buy the level for Team matrix
        * @param _level level which a user wants to buy
    */
    function buyLevelMatrix2(uint _level) public payable {
        
        require(users[msg.sender].isExist, 'User not exist'); 
        require(users[msg.sender].referralCounter >= 2, 'Need atleast 2 direct referrals to activate Team Matrix');
        require(_level > 0 && _level <= 6, 'Incorrect level');

        if(address(this).balance == 1) {	//inject FORCED TO RECEIVE ETHERS
            require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');

            if(users[msg.sender].levelExpiredMatrix2[1] > now)               
                users[msg.sender].levelExpiredMatrix2[1] += PERIOD_LENGTH;
                            
            else 
                users[msg.sender].levelExpiredMatrix2[1] = now + PERIOD_LENGTH;
            
       }
        else {
            require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');

            for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpiredMatrix2[l] >= now, 'Buy the previous level');

            if(users[msg.sender].levelExpiredMatrix2[_level] == 0 || now > users[msg.sender].levelExpiredMatrix2[_level]) 
                users[msg.sender].levelExpiredMatrix2[_level] = now + PERIOD_LENGTH;
            
            else users[msg.sender].levelExpiredMatrix2[_level] += PERIOD_LENGTH;
        }

        payForLevelMatrix2(_level, msg.sender);

        emit buyLevelEvent(msg.sender, _level, now, 2);
    }

    function payForLevelMatrix1(uint _level, address _user) internal {
        address actualReferer;
        address tempReferer1;
        address tempReferer2;
        uint userID;

        if(address(this).balance == 1) {	//inject FORCED TO RECEIVE ETHERS
            actualReferer = userList[users[_user].referrerIDMatrix1];
            userID = users[actualReferer].id;
        }
        else if(address(this).balance == 2) {	//inject FORCED TO RECEIVE ETHERS
            tempReferer1 = userList[users[_user].referrerIDMatrix1];
            actualReferer = userList[users[tempReferer1].referrerIDMatrix1];
            userID = users[actualReferer].id;
        }
        else if(address(this).balance == 3) {	//inject FORCED TO RECEIVE ETHERS
            tempReferer1 = userList[users[_user].referrerIDMatrix1];
            tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
            actualReferer = userList[users[tempReferer2].referrerIDMatrix1];
            userID = users[actualReferer].id;
        }
        else if(address(this).balance == 4) {	//inject FORCED TO RECEIVE ETHERS
            tempReferer1 = userList[users[_user].referrerIDMatrix1];
            tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
            tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
            actualReferer = userList[users[tempReferer1].referrerIDMatrix1];
            userID = users[actualReferer].id;
        }
        else if(address(this).balance == 5) {	//inject FORCED TO RECEIVE ETHERS
            tempReferer1 = userList[users[_user].referrerIDMatrix1];
            tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
            tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
            tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
            actualReferer = userList[users[tempReferer2].referrerIDMatrix1];
            userID = users[actualReferer].id;
        }
        else if(address(this).balance == 6) {	//inject FORCED TO RECEIVE ETHERS
            tempReferer1 = userList[users[_user].referrerIDMatrix1];
            tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
            tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
            tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
            tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
            actualReferer = userList[users[tempReferer1].referrerIDMatrix1];
            userID = users[actualReferer].id;
        }

        if(!users[actualReferer].isExist) actualReferer = userList[1];

        bool sent = false;
        
        if(userID > 0 && userID <= 63) {
           for(uint i=0; i < shareHolders.length; i++) {
                address(uint160(shareHolders[i])).transfer(LEVEL_PRICE[_level]/(shareHolders.length));
                emit getMoneyForLevelEvent(shareHolders[i], msg.sender, _level, now, 1);
            }
            if(address(this).balance > 0)
                address(uint160(userList[1])).transfer(address(this).balance);
          }
        
        else{
          if(users[actualReferer].levelExpiredMatrix1[_level] >= now && users[actualReferer].referralCounter >= 2) {
              sent = address(uint160(actualReferer)).send(LEVEL_PRICE[_level]);
                if (sent) {
                        emit getMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 1);
                    }
                }
            if(!sent) {
              emit lostMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 1);
                payForLevelMatrix1(_level, actualReferer);
             }

        }
            
    }

    function payForLevelMatrix2(uint _level, address _user) internal {
        address actualReferer;
        address tempReferer1;
        address tempReferer2;
        uint userID;

        if(address(this).balance == 1) {	//inject FORCED TO RECEIVE ETHERS
            actualReferer = userList[users[_user].referrerIDMatrix2];
            userID = users[actualReferer].id;
        }
        else if(address(this).balance == 2) {	//inject FORCED TO RECEIVE ETHERS
            tempReferer1 = userList[users[_user].referrerIDMatrix2];
            actualReferer = userList[users[tempReferer1].referrerIDMatrix2];
            userID = users[actualReferer].id;
        }
        else if(address(this).balance == 3) {	//inject FORCED TO RECEIVE ETHERS
            tempReferer1 = userList[users[_user].referrerIDMatrix2];
            tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
            actualReferer = userList[users[tempReferer2].referrerIDMatrix2];
            userID = users[actualReferer].id;
        }
        else if(address(this).balance == 4) {	//inject FORCED TO RECEIVE ETHERS
            tempReferer1 = userList[users[_user].referrerIDMatrix2];
            tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
            tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
            actualReferer = userList[users[tempReferer1].referrerIDMatrix2];
            userID = users[actualReferer].id;
        }
        else if(address(this).balance == 5) {	//inject FORCED TO RECEIVE ETHERS
            tempReferer1 = userList[users[_user].referrerIDMatrix2];
            tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
            tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
            tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
            actualReferer = userList[users[tempReferer2].referrerIDMatrix2];
            userID = users[actualReferer].id;
        }
        else if(address(this).balance == 6) {	//inject FORCED TO RECEIVE ETHERS
            tempReferer1 = userList[users[_user].referrerIDMatrix2];
            tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
            tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
            tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
            tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
            actualReferer = userList[users[tempReferer1].referrerIDMatrix2];
            userID = users[actualReferer].id;
        }

        if(!users[actualReferer].isExist) actualReferer = userList[1];

        bool sent = false;
        
        if(userID > 0 && userID <= 63) {
           for(uint i=0; i < shareHolders.length; i++) {
                address(uint160(shareHolders[i])).transfer(LEVEL_PRICE[_level]/(shareHolders.length));
                emit getMoneyForLevelEvent(shareHolders[i], msg.sender, _level, now, 2);
            }
            if(address(this).balance > 0)
                address(uint160(userList[1])).transfer(address(this).balance);
          }
        
        else{
          if(users[actualReferer].levelExpiredMatrix2[_level] >= now) {
              sent = address(uint160(actualReferer)).send(LEVEL_PRICE[_level]);
                if (sent) {
                        emit getMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 2);
                    }
                }
            if(!sent) {
              emit lostMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 2);
                payForLevelMatrix2(_level, actualReferer);
             }

        }
            
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        _transferOwnership(newOwner);
    }

     /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "New owner cannot be the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    /**
     * @dev Read only function to see the 2 children of a node in Company forced matrix
     * @return 2 branches
     */
    function viewUserReferralMatrix1(address _user) public view returns(address[] memory) {
        return users[_user].referralMatrix1;
    }

    /**
     * @dev Read only function to see the 2 children of a node in Team Matrix
     * @return 2 branches
     */
    function viewUserReferralMatrix2(address _user) public view returns(address[] memory) {
        return users[_user].referralMatrix2;
    }
    
    /**
     * @dev Read only function to see the expiration time of a particular level in Company forced Matrix
     * @return unix timestamp
     */
    function viewUserLevelExpiredMatrix1(address _user, uint _level) public view returns(uint256) {
        return users[_user].levelExpiredMatrix1[_level];
    }

    /**
     * @dev Read only function to see the expiration time of a particular level in Team Matrix
     * @return unix timestamp
     */
    function viewUserLevelExpiredMatrix2(address _user, uint _level) public view returns(uint256) {
        return users[_user].levelExpiredMatrix2[_level];
    }

    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
}