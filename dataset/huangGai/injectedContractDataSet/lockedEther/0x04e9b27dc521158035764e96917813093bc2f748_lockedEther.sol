pragma solidity ^0.5.7;


library SafeMath {

  function mul(uint a, uint b) internal pure returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint a, uint b) internal pure returns (uint) {
    uint c = a / b;
    return c;
  }

  function sub(uint a, uint b) internal pure returns (uint) {
    assert(b <= a);
    return a - b;
  }

  function add(uint a, uint b) internal pure returns (uint) {
    uint c = a + b;
    assert(c >= a);
    return c;
  }

}


contract Ownable {

  address public owner;
  address public mainAddress;

  constructor() public {
    owner = msg.sender;
    mainAddress = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only for owner");
    _;
  }

  function transferOwnership(address _owner) public onlyOwner {
    owner = _owner;
  }

}

contract ETHStvo is Ownable {
    
    event Register(uint indexed _user, uint indexed _referrer, uint indexed _introducer, uint _time);
    event SponsorChange(uint indexed _user, uint indexed _referrer, uint indexed _introducer, uint _time);
    event Upgrade(uint indexed _user, uint _star, uint _price, uint _time);
    event Payment(uint indexed _user, uint indexed _referrer, uint indexed _introducer, uint _star, uint _money, uint _fee, uint _time);
    event LostMoney(uint indexed _referrer, uint indexed _referral, uint _star, uint _money, uint _time);

    mapping (uint => uint) public STAR_PRICE;
    mapping (uint => uint) public STAR_FEE;
    uint REFERRER_1_STAR_LIMIT = 3;

    struct UserStruct {
        bool isExist;
        address wallet;
        uint referrerID;
        uint introducerID;
        address[] referral;
        mapping (uint => bool) starActive;
    }

    mapping (uint => UserStruct) public users;
    mapping (address => uint) public userList;

    uint public currentUserID = 0;
    uint public total = 0 ether;
    uint public totalFees = 0 ether;
    bool public paused = false;
    bool public allowSponsorChange = true;

    constructor() public {

        //Cycle 1
        STAR_PRICE[1] = 0.05 ether;
        STAR_PRICE[2] = 0.15 ether;
        STAR_PRICE[3] = 0.60 ether;
        STAR_PRICE[4] = 2.70 ether;
        STAR_PRICE[5] = 24.75 ether;
        STAR_PRICE[6] = 37.50 ether;
        STAR_PRICE[7] = 72.90 ether;
        STAR_PRICE[8] = 218.70 ether;

        //Cycle 2
        STAR_PRICE[9] = 385.00 ether;
        STAR_PRICE[10] = 700.00 ether;
        STAR_PRICE[11] = 1250.00 ether;
        STAR_PRICE[12] = 2500.00 ether;
        STAR_PRICE[13] = 5500.00 ether;
        STAR_PRICE[14] = 7500.00 ether;
        STAR_PRICE[15] = 10000.00 ether;
        STAR_PRICE[16] = 15000.00 ether;

        STAR_FEE[5] = 2.25 ether;
        STAR_FEE[9] = 35.00 ether;
        STAR_FEE[13] = 500.00 ether;

        UserStruct memory userStruct;
        currentUserID++;

        userStruct = UserStruct({
            isExist : true,
            wallet : mainAddress,
            referrerID : 0,
            introducerID : 0,
            referral : new address[](0)
        });

        users[currentUserID] = userStruct;
        userList[mainAddress] = currentUserID;

        users[currentUserID].starActive[1] = true;
        users[currentUserID].starActive[2] = true;
        users[currentUserID].starActive[3] = true;
        users[currentUserID].starActive[4] = true;
        users[currentUserID].starActive[5] = true;
        users[currentUserID].starActive[6] = true;
        users[currentUserID].starActive[7] = true;
        users[currentUserID].starActive[8] = true;
        users[currentUserID].starActive[9] = true;
        users[currentUserID].starActive[10] = true;
        users[currentUserID].starActive[11] = true;
        users[currentUserID].starActive[12] = true;
        users[currentUserID].starActive[13] = true;
        users[currentUserID].starActive[14] = true;
        users[currentUserID].starActive[15] = true;
        users[currentUserID].starActive[16] = true;
    }

    function setMainAddress(address _mainAddress) public onlyOwner {

        require(userList[_mainAddress] == 0, 'Address is already in use by another user');
        
        delete userList[mainAddress];
        userList[_mainAddress] = uint(1);
        mainAddress = _mainAddress;
        users[1].wallet = _mainAddress;
      }

    function setPaused(bool _paused) public onlyOwner {
        paused = _paused;
      }

      function setAllowSponsorChange(bool _allowSponsorChange) public onlyOwner {
        allowSponsorChange = _allowSponsorChange;
      }

    //https://etherconverter.online to Ether
    function setStarPrice(uint _star, uint _price) public onlyOwner {
        STAR_PRICE[_star] = _price;
      }

    //https://etherconverter.online to Ether
    function setStarFee(uint _star, uint _price) public onlyOwner {
        STAR_FEE[_star] = _price;
      }

    function setCurrentUserID(uint _currentUserID) public onlyOwner {
        currentUserID = _currentUserID;
      }

    //Null address is 0x0000000000000000000000000000000000000000
    function setUserData(uint _userID, address _wallet, uint _referrerID, uint _introducerID, address _referral1, address _referral2, address _referral3, uint star) public onlyOwner {

        require(_userID > 0, 'Invalid user ID');
        require(_wallet != address(0), 'Invalid user wallet');
        require(_referrerID > 0, 'Invalid referrer ID');
        require(_introducerID > 0, 'Invalid introducer ID');

        if(_userID > currentUserID){
            currentUserID++;
        }

        if(users[_userID].isExist){
            delete userList[users[_userID].wallet];
            delete users[_userID];
        }

        UserStruct memory userStruct;

        userStruct = UserStruct({
            isExist : true,
            wallet : _wallet,
            referrerID : _referrerID,
            introducerID : _introducerID,
            referral : new address[](0)
        });
    
        users[_userID] = userStruct;
        userList[_wallet] = _userID;

        for(uint a = 1; a <= uint(16); a++){
            if(a <= star){
                users[_userID].starActive[a] = true;
            } else {
                users[_userID].starActive[a] = false;
            }
        }

        if(_referral1 != address(0)){
            users[_userID].referral.push(_referral1);
        }
           
        if(_referral2 != address(0)){
            users[_userID].referral.push(_referral2);
        }

        if(_referral3 != address(0)){
            users[_userID].referral.push(_referral3);
        }

    }

    function () external payable {	//injected LOCKED ETHER

        require(!paused, 'Temporarily not accepting new users and Star upgrades');

        uint star;

        if(msg.value == STAR_PRICE[1]){
            star = 1;
        }else if(msg.value == STAR_PRICE[2]){
            star = 2;
        }else if(msg.value == STAR_PRICE[3]){
            star = 3;
        }else if(msg.value == STAR_PRICE[4]){
            star = 4;
        }else if(msg.value == STAR_PRICE[5]){
            star = 5;
        }else if(msg.value == STAR_PRICE[6]){
            star = 6;
        }else if(msg.value == STAR_PRICE[7]){
            star = 7;
        }else if(msg.value == STAR_PRICE[8]){
            star = 8;
        }else if(msg.value == STAR_PRICE[9]){
            star = 9;
        }else if(msg.value == STAR_PRICE[10]){
            star = 10;
        }else if(msg.value == STAR_PRICE[11]){
            star = 11;
        }else if(msg.value == STAR_PRICE[12]){
            star = 12;
        }else if(msg.value == STAR_PRICE[13]){
            star = 13;
        }else if(msg.value == STAR_PRICE[14]){
            star = 14;
        }else if(msg.value == STAR_PRICE[15]){
            star = 15;
        }else if(msg.value == STAR_PRICE[16]){
            star = 16;
        }else {
            revert('You have sent incorrect payment amount');
        }

        if(star == 1){

            uint referrerID = 0;
            address referrer = bytesToAddress(msg.data);

            if (userList[referrer] > 0 && userList[referrer] <= currentUserID){
                referrerID = userList[referrer];
            } else {
                revert('Incorrect referrer');
            }

            if(users[userList[msg.sender]].isExist){
                changeSponsor(referrerID);
            } else {
                registerUser(referrerID);
            }
        } else if(users[userList[msg.sender]].isExist){
            upgradeUser(star);
        } else {
            revert("Please buy first star");
        }
    }

    function changeSponsor(uint _referrerID) internal {

        require(allowSponsorChange, 'You are already signed up. Sponsor change not allowed');
        require(users[userList[msg.sender]].isExist, 'You are not signed up');
        require(userList[msg.sender] != _referrerID, 'You cannot sponsor yourself');
        require(users[userList[msg.sender]].referrerID != _referrerID && users[userList[msg.sender]].introducerID != _referrerID, 'You are already under this sponsor');
        require(_referrerID > 0 && _referrerID <= currentUserID, 'Incorrect referrer ID');
        require(msg.value==STAR_PRICE[1], 'You have sent incorrect payment amount');
        require(users[userList[msg.sender]].starActive[2] == false, 'Sponsor change is allowed only on Star 1');

        uint _introducerID = _referrerID;
        uint oldReferrer = users[userList[msg.sender]].referrerID;

        if(users[_referrerID].referral.length >= REFERRER_1_STAR_LIMIT)
        {
            _referrerID = userList[findFreeReferrer(_referrerID)];
        }

        users[userList[msg.sender]].referrerID = _referrerID;
        users[userList[msg.sender]].introducerID = _introducerID;

        users[_referrerID].referral.push(msg.sender);

        uint arrayLength = SafeMath.sub(uint(users[oldReferrer].referral.length),uint(1));

        address[] memory referrals = new address[](arrayLength);

        for(uint a = 0; a <= arrayLength; a++){
            if(users[oldReferrer].referral[a] != msg.sender){
                referrals[a] = users[oldReferrer].referral[a];
            }
        }

        for(uint b = 0; b <= arrayLength; b++){
            users[oldReferrer].referral.pop();
        }

        uint arrayLengthSecond = SafeMath.sub(uint(referrals.length),uint(1));

        for(uint c = 0; c <= arrayLengthSecond; c++){
            if(referrals[c] != address(0)){
                users[oldReferrer].referral.push(referrals[c]);
            }
        }

        upgradePayment(userList[msg.sender], 1);

        emit SponsorChange(userList[msg.sender], _referrerID, _introducerID, now);

    }

    function registerUser(uint _referrerID) internal {

        require(!users[userList[msg.sender]].isExist, 'You are already signed up');
        require(_referrerID > 0 && _referrerID <= currentUserID, 'Incorrect referrer ID');
        require(msg.value==STAR_PRICE[1], 'You have sent incorrect payment amount');

        uint _introducerID = _referrerID;

        if(users[_referrerID].referral.length >= REFERRER_1_STAR_LIMIT)
        {
            _referrerID = userList[findFreeReferrer(_referrerID)];
        }

        UserStruct memory userStruct;
        currentUserID++;

        userStruct = UserStruct({
            isExist : true,
            wallet : msg.sender,
            referrerID : _referrerID,
            introducerID : _introducerID,
            referral : new address[](0)
        });

        users[currentUserID] = userStruct;
        userList[msg.sender] = currentUserID;

        users[currentUserID].starActive[1] = true;
        users[currentUserID].starActive[2] = false;
        users[currentUserID].starActive[3] = false;
        users[currentUserID].starActive[4] = false;
        users[currentUserID].starActive[5] = false;
        users[currentUserID].starActive[6] = false;
        users[currentUserID].starActive[7] = false;
        users[currentUserID].starActive[8] = false;
        users[currentUserID].starActive[9] = false;
        users[currentUserID].starActive[10] = false;
        users[currentUserID].starActive[11] = false;
        users[currentUserID].starActive[12] = false;
        users[currentUserID].starActive[13] = false;
        users[currentUserID].starActive[14] = false;
        users[currentUserID].starActive[15] = false;
        users[currentUserID].starActive[16] = false;

        users[_referrerID].referral.push(msg.sender);

        upgradePayment(currentUserID, 1);

        emit Register(currentUserID, _referrerID, _introducerID, now);
    }

    function upgradeUser(uint _star) internal {

        require(users[userList[msg.sender]].isExist, 'You are not signed up yet');
        require( _star >= 2 && _star <= 16, 'Incorrect star');
        require(msg.value==STAR_PRICE[_star], 'You have sent incorrect payment amount');
        require(users[userList[msg.sender]].starActive[_star] == false, 'You have already activated this star');

        uint previousStar = SafeMath.sub(_star,uint(1));
        require(users[userList[msg.sender]].starActive[previousStar] == true, 'Buy the previous star first');
        
        users[userList[msg.sender]].starActive[_star] = true;

        upgradePayment(userList[msg.sender], _star);
        
        emit Upgrade(userList[msg.sender], _star, STAR_PRICE[_star], now);
    }

    function upgradePayment(uint _user, uint _star) internal {

        address referrer;
        address introducer;

        uint referrerFinal;
        uint referrer1;
        uint referrer2;
        uint referrer3;
        uint money;

        if(_star == 1 || _star == 5 || _star == 9 || _star == 13){
            referrerFinal = users[_user].referrerID;
        } else if(_star == 2 || _star == 6 || _star == 10 || _star == 14){
            referrer1 = users[_user].referrerID;
            referrerFinal = users[referrer1].referrerID;
        } else if(_star == 3 || _star == 7 || _star == 11 || _star == 15){
            referrer1 = users[_user].referrerID;
            referrer2 = users[referrer1].referrerID;
            referrerFinal = users[referrer2].referrerID;
        } else if(_star == 4 || _star == 8 || _star == 12 || _star == 16){
            referrer1 = users[_user].referrerID;
            referrer2 = users[referrer1].referrerID;
            referrer3 = users[referrer2].referrerID;
            referrerFinal = users[referrer3].referrerID;
        }

        if(!users[referrerFinal].isExist || users[referrerFinal].starActive[_star] == false){
            referrer = mainAddress;
        } else {
            referrer = users[referrerFinal].wallet;
        }

        money = STAR_PRICE[_star];
                
        if(STAR_FEE[_star] > 0){
            bool result;
            result = address(uint160(mainAddress)).send(0);
            money = SafeMath.sub(money,STAR_FEE[_star]);
            totalFees = SafeMath.add(totalFees,money);
        }

        total = SafeMath.add(total,money);

        if(_star>=3){

            if(!users[users[_user].introducerID].isExist){
                introducer = mainAddress;
            } else {
                introducer = users[users[_user].introducerID].wallet;
            }

            money = SafeMath.div(money,2);

            bool result_one;
            result_one = address(uint160(referrer)).send(0);

            bool result_two;
            result_two = address(uint160(introducer)).send(0);
            
        } else {
            bool result_three;
            result_three = address(uint160(referrer)).send(0);
        }

        if(users[referrerFinal].starActive[_star] == false ){
            emit LostMoney(referrerFinal, userList[msg.sender], _star, money, now);
        }

        emit Payment(userList[msg.sender], userList[referrer], userList[introducer], _star, money, STAR_FEE[_star], now);

    }

    function findFreeReferrer(uint _user) public view returns(address) {

        require(users[_user].isExist, 'User does not exist');

        if(users[_user].referral.length < REFERRER_1_STAR_LIMIT){
            return users[_user].wallet;
        }

        address[] memory referrals = new address[](363);
        referrals[0] = users[_user].referral[0]; 
        referrals[1] = users[_user].referral[1];
        referrals[2] = users[_user].referral[2];

        address freeReferrer;
        bool noFreeReferrer = true;

        for(uint i = 0; i < 363; i++){
            if(users[userList[referrals[i]]].referral.length == REFERRER_1_STAR_LIMIT){
                if(i < 120){
                    referrals[(i+1)*3] = users[userList[referrals[i]]].referral[0];
                    referrals[(i+1)*3+1] = users[userList[referrals[i]]].referral[1];
                    referrals[(i+1)*3+2] = users[userList[referrals[i]]].referral[2];
                }
            } else {
                noFreeReferrer = false;
                freeReferrer = referrals[i];
                break;
            }
        }
        require(!noFreeReferrer, 'Free referrer not found');
        return freeReferrer;

    }

    function viewUserReferrals(uint _user) public view returns(address[] memory) {
        return users[_user].referral;
    }

    function viewUserStarActive(uint _user, uint _star) public view returns(bool) {
        return users[_user].starActive[_star];
    }

    function bytesToAddress(bytes memory bys) private pure returns (address  addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
}