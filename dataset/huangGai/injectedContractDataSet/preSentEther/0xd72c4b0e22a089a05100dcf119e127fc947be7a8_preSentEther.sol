pragma solidity ^0.5.7;


library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

}


contract Ownable {

  address public owner;
  address public ownerWallet;

  constructor() public {
    owner = msg.sender;
    ownerWallet = 0xB67d52d9BDA884d487b6eae57478E387602e522d;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "only for owner");
    _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    owner = newOwner;
  }

}

contract ETHStvo is Ownable {

    event regStarEvent(address indexed _user, address indexed _referrer, uint _time);
    event buyStarEvent(address indexed _user, uint _star, uint _cycle, uint _time);
    event prolongateStarEvent(address indexed _user, uint _star, uint _time);
    event getMoneyForStarEvent(address indexed _user, address indexed _referral, uint _star, uint _cycle, uint _time);
    event lostMoneyForStarEvent(address indexed _user, address indexed _referral, uint _star, uint _cycle, uint _time);
    //------------------------------

    mapping (uint => uint) public STAR_PRICE;
    uint REFERRER_1_STAR_LIMIT = 3;
    uint PERIOD_LENGTH = 3650 days;


    struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        uint referrerIDInitial;
        address[] referral;
        mapping (uint => uint) starExpired;
    }

    mapping (address => UserStruct) public users;
    mapping (uint => address) public userList;
    uint public currUserID = 0;

    constructor() public {

        //Cycle 1
        STAR_PRICE[1] = 0.05 ether;
        STAR_PRICE[2] = 0.15 ether;
        STAR_PRICE[3] = 0.90 ether;
        STAR_PRICE[4] = 2.70 ether;
        STAR_PRICE[5] = 24.75 ether;
        STAR_PRICE[6] = 37.50 ether;
        STAR_PRICE[7] = 72.90 ether;
        STAR_PRICE[8] = 218.70 ether;

        //Cycle 2
        STAR_PRICE[9] = 5.50 ether;
        STAR_PRICE[10] = 15.00 ether;
        STAR_PRICE[11] = 90.00 ether;
        STAR_PRICE[12] = 270.00 ether;
        STAR_PRICE[13] = 2475.00 ether;
        STAR_PRICE[14] = 3750.00 ether;
        STAR_PRICE[15] = 7290.00 ether;
        STAR_PRICE[16] = 21870.00 ether;

        //Cycle 3
        STAR_PRICE[17] = 55.0 ether;
        STAR_PRICE[18] = 150.00 ether;
        STAR_PRICE[19] = 900.00 ether;
        STAR_PRICE[20] = 2700.00 ether;
        STAR_PRICE[21] = 24750.00 ether;
        STAR_PRICE[22] = 37500.00 ether;
        STAR_PRICE[23] = 72900.00 ether;
        STAR_PRICE[24] = 218700.00 ether;

        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist : true,
            id : currUserID,
            referrerID : 0,
            referrerIDInitial : 0,
            referral : new address[](0)
        });
        users[ownerWallet] = userStruct;
        userList[currUserID] = ownerWallet;

        users[ownerWallet].starExpired[1] = 77777777777;
        users[ownerWallet].starExpired[2] = 77777777777;
        users[ownerWallet].starExpired[3] = 77777777777;
        users[ownerWallet].starExpired[4] = 77777777777;
        users[ownerWallet].starExpired[5] = 77777777777;
        users[ownerWallet].starExpired[6] = 77777777777;
        users[ownerWallet].starExpired[7] = 77777777777;
        users[ownerWallet].starExpired[8] = 77777777777;
        users[ownerWallet].starExpired[9] = 77777777777;
        users[ownerWallet].starExpired[10] = 77777777777;
        users[ownerWallet].starExpired[11] = 77777777777;
        users[ownerWallet].starExpired[12] = 77777777777;
        users[ownerWallet].starExpired[13] = 77777777777;
        users[ownerWallet].starExpired[14] = 77777777777;
        users[ownerWallet].starExpired[15] = 77777777777;
        users[ownerWallet].starExpired[16] = 77777777777;
        users[ownerWallet].starExpired[17] = 77777777777;
        users[ownerWallet].starExpired[18] = 77777777777;
        users[ownerWallet].starExpired[19] = 77777777777;
        users[ownerWallet].starExpired[20] = 77777777777;
        users[ownerWallet].starExpired[21] = 77777777777;
        users[ownerWallet].starExpired[22] = 77777777777;
        users[ownerWallet].starExpired[23] = 77777777777;
        users[ownerWallet].starExpired[24] = 77777777777;
    }

    function setOwnerWallet(address _ownerWallet) public onlyOwner {
        userList[1] = _ownerWallet;
      }

    function () external payable {

        uint star;
        uint cycle;

        if(msg.value == STAR_PRICE[1]){
            star = 1;
            cycle = 1;
        }else if(msg.value == STAR_PRICE[2]){
            star = 2;
            cycle = 1;
        }else if(msg.value == STAR_PRICE[3]){
            star = 3;
            cycle = 1;
        }else if(msg.value == STAR_PRICE[4]){
            star = 4;
            cycle = 1;
        }else if(msg.value == STAR_PRICE[5]){
            star = 5;
            cycle = 1;
        }else if(msg.value == STAR_PRICE[6]){
            star = 6;
            cycle = 1;
        }else if(msg.value == STAR_PRICE[7]){
            star = 7;
            cycle = 1;
        }else if(msg.value == STAR_PRICE[8]){
            star = 8;
            cycle = 1;
        }else if(msg.value == STAR_PRICE[9]){
            star = 9;
            cycle = 2;
        }else if(msg.value == STAR_PRICE[10]){
            star = 10;
            cycle = 2;
        }else if(msg.value == STAR_PRICE[11]){
            star = 11;
            cycle = 2;
        }else if(msg.value == STAR_PRICE[12]){
            star = 12;
            cycle = 2;
        }else if(msg.value == STAR_PRICE[13]){
            star = 13;
            cycle = 2;
        }else if(msg.value == STAR_PRICE[14]){
            star = 14;
            cycle = 2;
        }else if(msg.value == STAR_PRICE[15]){
            star = 15;
            cycle = 2;
        }else if(msg.value == STAR_PRICE[16]){
            star = 16;
            cycle = 2;
        }else if(msg.value == STAR_PRICE[17]){
            star = 17;
            cycle = 3;
        }else if(msg.value == STAR_PRICE[18]){
            star = 18;
            cycle = 3;
        }else if(msg.value == STAR_PRICE[19]){
            star = 19;
            cycle = 3;
        }else if(msg.value == STAR_PRICE[20]){
            star = 20;
            cycle = 3;
        }else if(msg.value == STAR_PRICE[21]){
            star = 21;
            cycle = 3;
        }else if(msg.value == STAR_PRICE[22]){
            star = 22;
            cycle = 3;
        }else if(msg.value == STAR_PRICE[23]){
            star = 23;
            cycle = 3;
        }else if(msg.value == STAR_PRICE[24]){
            star = 24;
            cycle = 3;
        }else {
            revert('Incorrect Value send');
        }

        if(users[msg.sender].isExist){
            buyStar(star, cycle);
        } else if(star == 1) {
            uint refId = 0;
            address referrer = bytesToAddress(msg.data);

            if (users[referrer].isExist){
                refId = users[referrer].id;
            } else {
                revert('Incorrect referrer');
            }

            regUser(refId);
        } else {
            revert("Please buy first star for 0.05 ETH");
        }
    }

    function regUser(uint _referrerID) public payable {
        require(!users[msg.sender].isExist, 'User exist');

        require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');

        require(msg.value==STAR_PRICE[1], 'Incorrect Value');

        uint _referrerIDInitial = _referrerID;

        if(users[userList[_referrerID]].referral.length >= REFERRER_1_STAR_LIMIT)
        {
            _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
        }

        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist : true,
            id : currUserID,
            referrerID : _referrerID,
            referrerIDInitial : _referrerIDInitial,
            referral : new address[](0)
        });

        users[msg.sender] = userStruct;
        userList[currUserID] = msg.sender;

        users[msg.sender].starExpired[1] = now + PERIOD_LENGTH;
        users[msg.sender].starExpired[2] = 0;
        users[msg.sender].starExpired[3] = 0;
        users[msg.sender].starExpired[4] = 0;
        users[msg.sender].starExpired[5] = 0;
        users[msg.sender].starExpired[6] = 0;
        users[msg.sender].starExpired[7] = 0;
        users[msg.sender].starExpired[8] = 0;
        users[msg.sender].starExpired[9] = 0;
        users[msg.sender].starExpired[10] = 0;
        users[msg.sender].starExpired[11] = 0;
        users[msg.sender].starExpired[12] = 0;
        users[msg.sender].starExpired[13] = 0;
        users[msg.sender].starExpired[14] = 0;
        users[msg.sender].starExpired[15] = 0;
        users[msg.sender].starExpired[16] = 0;
        users[msg.sender].starExpired[17] = 0;
        users[msg.sender].starExpired[18] = 0;
        users[msg.sender].starExpired[19] = 0;
        users[msg.sender].starExpired[20] = 0;
        users[msg.sender].starExpired[21] = 0;
        users[msg.sender].starExpired[22] = 0;
        users[msg.sender].starExpired[23] = 0;
        users[msg.sender].starExpired[24] = 0;

        users[userList[_referrerID]].referral.push(msg.sender);

        payForStar(1, 1, msg.sender);

        emit regStarEvent(msg.sender, userList[_referrerID], now);
    }

    function buyStar(uint _star, uint _cycle) public payable {
        require(users[msg.sender].isExist, 'User not exist');

        require( _star>0 && _star<=24, 'Incorrect star');
        require( _cycle>0 && _cycle<=3, 'Incorrect cycle');

        if(_star == 1){
            require(msg.value==STAR_PRICE[1], 'Incorrect Value');
            users[msg.sender].starExpired[1] += PERIOD_LENGTH;
        } else {
                require(msg.value==STAR_PRICE[_star], 'Incorrect Value');

            for(uint l =_star-1; l>0; l-- ){
                require(users[msg.sender].starExpired[l] >= now, 'Buy the previous star');
            }

            if(address(this).balance == 0){	//inject PRESENT ETHER
                users[msg.sender].starExpired[_star] = now + PERIOD_LENGTH;
            } else {
                users[msg.sender].starExpired[_star] += PERIOD_LENGTH;
            }

        }
        payForStar(_star, _cycle, msg.sender);
        emit buyStarEvent(msg.sender, _star, _cycle, now);
    }

    function payForStar(uint _star, uint _cycle, address _user) internal {

        address referer;
        address referer1;
        address referer2;
        address referer3;
        address refererInitial;
        uint money;
        if(_star == 1 || _star == 5 || _star == 9 || _star == 13 || _star == 17 || _star == 21){
            referer = userList[users[_user].referrerID];
        } else if(_star == 2 || _star == 6 || _star == 10 || _star == 14 || _star == 18 || _star == 22){
            referer1 = userList[users[_user].referrerID];
            referer = userList[users[referer1].referrerID];
        } else if(_star == 3 || _star == 7 || _star == 11 || _star == 15 || _star == 19 || _star == 23){
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer = userList[users[referer2].referrerID];
        } else if(_star == 4 || _star == 8 || _star == 12 || _star == 16 || _star == 20 || _star == 24){
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer3 = userList[users[referer2].referrerID];
            referer = userList[users[referer3].referrerID];
        }

        if(!users[referer].isExist){
            referer = userList[1];
        }

        refererInitial = userList[users[_user].referrerIDInitial];

        if(!users[refererInitial].isExist){
            refererInitial = userList[1];
        }

        if(users[referer].starExpired[_star] >= now ){

            money = STAR_PRICE[_star];

            if(_star>=3){
                
                if(_star==5){
                    bool result;
                    result = address(uint160(userList[1])).send(uint(2.25 ether));
                    money = SafeMath.sub(money,uint(2.25 ether));
                }

                if(_star==9){
                    bool result;
                    result = address(uint160(userList[1])).send(uint(0.50 ether));
                    money = SafeMath.sub(money,uint(0.50 ether));
                }

                if(_star==13){
                    bool result;
                    result = address(uint160(userList[1])).send(uint(225.00 ether));
                    money = SafeMath.sub(money,uint(225.00 ether));
                }

                if(_star==17){
                    bool result;
                    result = address(uint160(userList[1])).send(uint(5.00 ether));
                    money = SafeMath.sub(money,uint(5.00 ether));
                }

                if(_star==21){
                    bool result;
                    result = address(uint160(userList[1])).send(uint(2250.00 ether));
                    money = SafeMath.sub(money,uint(2250.00 ether));
                }

                bool result_one;
                result_one = address(uint160(referer)).send(SafeMath.div(money,2));

                bool result_two;
                result_two = address(uint160(refererInitial)).send(SafeMath.div(money,2));
                
            } else {
                bool result;
                result = address(uint160(referer)).send(money);
            }

            emit getMoneyForStarEvent(referer, msg.sender, _star, _cycle, now);

        } else {
            emit lostMoneyForStarEvent(referer, msg.sender, _star, _cycle, now);
            payForStar(_star,_cycle,referer);
        }
    }

    function findFreeReferrer(address _user) public view returns(address) {

        require(users[_user].isExist, 'Upline does not exist');

        if(users[_user].referral.length < REFERRER_1_STAR_LIMIT){
            return _user;
        }

        address[] memory referrals = new address[](363);
        referrals[0] = users[_user].referral[0]; 
        referrals[1] = users[_user].referral[1];
        referrals[2] = users[_user].referral[2];

        address freeReferrer;
        bool noFreeReferrer = true;

        for(uint i =0; i<363;i++){
            if(users[referrals[i]].referral.length == REFERRER_1_STAR_LIMIT){
                if(i<120){
                    referrals[(i+1)*3] = users[referrals[i]].referral[0];
                    referrals[(i+1)*3+1] = users[referrals[i]].referral[1];
                    referrals[(i+1)*3+2] = users[referrals[i]].referral[2];
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

    function viewUserReferral(address _user) public view returns(address[] memory) {
        return users[_user].referral;
    }

    function viewUserStarExpired(address _user, uint _star) public view returns(uint) {
        return users[_user].starExpired[_star];
    }
    function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
}