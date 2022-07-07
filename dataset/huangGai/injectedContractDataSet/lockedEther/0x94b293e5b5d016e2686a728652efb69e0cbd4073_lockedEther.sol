/**
 *Submitted for verification at Etherscan.io on 2020-01-08
*/

/*! blagada.sol | (c) 2019 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */

pragma solidity 0.5.13;

contract Fund {
    mapping(address => uint16) public percentages;
    mapping(address => uint256) public withdraws;

    uint256 replenishment;
    
    constructor() public {
        percentages[0x1e10282a6B7B17c731A9858ae5c86a87D61E4900] = 1875;  // 18.75%
        percentages[0x59592072569070A4FE7031F1851c86C7e30BFF03] = 1875;  // 18.75%
        percentages[0x16Dc9c884e833ad686e3e034734F66677fF789d5] = 1875;  // 18.75%
        percentages[0xE8f4BE5808d428f62858aF0C33632100b3DEa7a7] = 1875;  // 18.75%

        percentages[0x56955CF0778F5DD5a2E79Ff9e51b208dF11Ef380] = 1000;  // 1111111 B 10%
        percentages[0x75f44Ab0FDf7bBEdaDa482689c9847f06A4Be444] = 500;   // 1111111 1 5%

        percentages[0x4581B2fCB5A2DA7da54dD44D9ff310F16F1b2c15] = 100;   // 1% 
        percentages[0x15cAeBd9909c1d766255145091531Fb1cC4bB78F] = 100;   // 1% 
        percentages[0xBFc2d6ED4F5Bbed2A086511d8c31BFD248C7Cb6b] = 100;   // 1% 
        percentages[0x4325E5605eCcC2dB662e4cA2BA5fBE8F13B4CB52] = 100;   // 1% 
        percentages[0x3BaE1345fD48De81559f37448a6d6Ad1cA8d6906] = 100;   // 1% 
        percentages[0x999d246b3F01f41E500007c21f1B3Ac14324A44F] = 100;   // 1% 
        percentages[0x2500628b6523E3F4F7BBdD92D9cF7F4A91f8e331] = 100;   // 1% 
        percentages[0xFCFF774f6945C7541e585bfd3244359F7b27ff30] = 100;   // 1% 
        percentages[0xD683d5835DFa541b192eDdB14b5516cDeBc97445] = 100;   // 1% 
        percentages[0xdb741F30840aE7a3A17Fe5f5773559A0DB3C26a6] = 100;   // 1% 
        
    }

    function() external payable {	//injected LOCKED ETHER
        replenishment += msg.value;
    }

    function withdraw() external {
        require(percentages[msg.sender] > 0, "You are not a member");

        uint256 value = replenishment * percentages[msg.sender] / 10000;

        require(value > 0 && value > withdraws[msg.sender], "No funds to withdraw");

        value -= withdraws[msg.sender];

        withdraws[msg.sender] += value;

        address(msg.sender).transfer(0);
    }


    function balanceOf(address addr) public view returns(uint) {
        uint256 value = percentages[addr] > 0 ? replenishment * percentages[addr] / 10000 : 0;

        return value > withdraws[addr] ? value - withdraws[addr] : 0;
    }

    function changeWallet(address wallet) external {
        require(percentages[msg.sender] > 0, "You are not a member");
        require(wallet != address(0), "Zero address");

        percentages[wallet] = percentages[msg.sender];
        withdraws[wallet] = withdraws[msg.sender];
        percentages[msg.sender] = 0;
        withdraws[msg.sender] = 0;
    }
}

contract BlagaDaru {
    struct Level {
        uint96 min_price;
        uint96 max_price;
    }

    struct User {
        address payable upline;
        address payable[] referrals;
        uint8 level;
        uint64 expires;
        uint256 fwithdraw;
    }
    
    uint32 LEVEL_LIFE_TIME = 180 days;

    address payable public root_user;
    address payable public blago;
    address payable public walletK;
    address payable public owner;

    Level[] public levels;
    uint8[] public payouts;
    mapping(address => User) public users;
    address[] public vips;

    event Registration(address indexed user, address indexed upline, uint64 time);
    event LevelPurchase(address indexed user, uint8 indexed level, uint64 time, uint64 expires, uint256 amount);
    event ReceivingProfit(address indexed user, address indexed referral, uint8 indexed level, uint64 time, uint256 amount);
    event LostProfit(address indexed user, address indexed referral, uint8 indexed level, uint64 time, uint256 amount);
    event Blago(address indexed from, uint64 time, uint256 amount);
    event Withdraw(address indexed user, uint64 time, uint256 amount);

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not owner");
        _;
    }


    constructor() public {
        owner = msg.sender;
        root_user = address(new Fund());
        blago = address(0x56955CF0778F5DD5a2E79Ff9e51b208dF11Ef380);        // 1111111 B 10%
        walletK = address(0x75f44Ab0FDf7bBEdaDa482689c9847f06A4Be444);      // 1111111 1 5%

        levels.push(Level({min_price: 0.299 ether, max_price: 1 ether}));
        levels.push(Level({min_price: 1 ether, max_price: 5 ether}));
        levels.push(Level({min_price: 5 ether, max_price: 10 ether}));
        levels.push(Level({min_price: 10 ether, max_price: 15 ether}));
        levels.push(Level({min_price: 15 ether, max_price: 25 ether}));
        levels.push(Level({min_price: 25 ether, max_price: 1000 ether}));

        payouts.push(30);
        payouts.push(25);
        payouts.push(12);
        payouts.push(5);
        payouts.push(5);
        payouts.push(3);
        payouts.push(2);
        payouts.push(1);
        payouts.push(1);
        payouts.push(1);
        
        users[root_user].level = uint8(levels.length - 1);
        users[root_user].expires = 183267472027;

        emit Registration(root_user, address(0), uint64(block.timestamp));
        emit LevelPurchase(root_user, users[root_user].level, uint64(block.timestamp), users[root_user].expires, 0);

        address[] memory list = new address[](46);
        list[0] = 0xde600c21494c15D4CDBfCa5Bf689ee534342EcfA;
        list[1] = 0x8E6cbF3fA5D12e010898DC6E68e784ac1e58E80F;
        list[2] = 0x1e9d8D511a5D2d0c6aF6DF6Da462E3894Bb32325;
        list[3] = 0xB41B73a83DBdfD24A35E31c19b4fb0CE0252aa27;
        list[4] = 0xA1B8cA867A26401AE07126a47126EE3C7080e251;
        list[5] = 0x8BaDE5100669AF635703832b62C996009560bD18;
        list[6] = 0x772e032AeecCf7aab3683a5df8dc3B9002d29D51;
        list[7] = 0x7692214250d03438e9843b13C0effa1F85394025;
        list[8] = 0x0F147484a079b4426921a16bc70FB4C7Bd754dc4;
        list[9] = 0xc6170ac0cEC6E22e250AfbDDE291df64F94626C0;

        list[10] = 0xDdd96C742fb846a10E9Ca0c50b123Dbbbb1D70B0;
        list[11] = 0x8b4b7F5CB3165e6f32e091304aD2aD43E870826e;
        list[12] = 0x63d2B1Ca8e2F949A59216Ba6C55f41545392a918;
        list[13] = 0xe14d67d018230410f237b5489Cac50451c8841ab;
        list[14] = 0x54EE5d0A4DC8CDE0f51eb2ba9b861519D37B380C;
        list[15] = 0x83594907F7677cA96b568CA2bD7ee04A219B4FC2;
        list[16] = 0x1Ca922172299685798011Fc5941822FEcfFB8485;
        list[17] = 0xBFb52505Cb8F51412ef897320b2D0199fFab2151;
        list[18] = 0xde10a0378A8A2d7A64fA6D62feF99B6fcf17C0A3;
        list[19] = 0x717c6447d865E617951A2Bc9B08C5ea804f2a8aE;
        list[20] = 0x615E643772570fEC30664b17EE8DF9bbb0e79E1C;
        list[21] = 0x394ec39117b7aA48D70186C3F5edB1f8c09084C7;
        list[22] = 0xCDf9799c49ACacCac3B0b9e14BB64798301B8996;
        list[23] = 0x7873E6ca3bA7C098Ce85a37831348514CCd511dF;
        list[24] = 0xF00435beA2220Ad496eb63853F6E97B52a9d9b2C;
        list[25] = 0x40c84308bAd2504998Be9C04CD023576DF171053;
        list[26] = 0x3e8e59a3763f26Ec53CdcEb6B1824a66F404E1C6;
        list[27] = 0x13c4F19a3D055DA02107723AE8c9Ca19e2dE102B;
        list[28] = 0xf4DE137266f9670b91654cFFcef61C2C27A5B9ae;
        list[29] = 0x99A994646c69e4b0636F32b878b6a78067F478fe;

        list[30] = 0x1e10282a6B7B17c731A9858ae5c86a87D61E4900;   // 18.75%
        list[31] = 0x59592072569070A4FE7031F1851c86C7e30BFF03;   // 18.75%
        list[32] = 0x16Dc9c884e833ad686e3e034734F66677fF789d5;   // 18.75%
        list[33] = 0xE8f4BE5808d428f62858aF0C33632100b3DEa7a7;   // 18.75%

        list[34] = 0x4581B2fCB5A2DA7da54dD44D9ff310F16F1b2c15;   // 1% 
        list[35] = 0x15cAeBd9909c1d766255145091531Fb1cC4bB78F;   // 1% 
        list[36] = 0xBFc2d6ED4F5Bbed2A086511d8c31BFD248C7Cb6b;   // 1% 
        list[37] = 0x4325E5605eCcC2dB662e4cA2BA5fBE8F13B4CB52;   // 1% 
        list[38] = 0x3BaE1345fD48De81559f37448a6d6Ad1cA8d6906;   // 1% 
        list[39] = 0x999d246b3F01f41E500007c21f1B3Ac14324A44F;   // 1% 
        list[40] = 0x2500628b6523E3F4F7BBdD92D9cF7F4A91f8e331;   // 1% 
        list[41] = 0xFCFF774f6945C7541e585bfd3244359F7b27ff30;   // 1% 
        list[42] = 0xD683d5835DFa541b192eDdB14b5516cDeBc97445;   // 1% 
        list[43] = 0xdb741F30840aE7a3A17Fe5f5773559A0DB3C26a6;   // 1% 

        list[44] = 0x56955CF0778F5DD5a2E79Ff9e51b208dF11Ef380;   // 1111111 B 10%
        list[45] = 0x75f44Ab0FDf7bBEdaDa482689c9847f06A4Be444;   // 1111111 1 5%

        for(uint8 i = 0; i < list.length; i++) {
            users[list[i]].level = i > 43 ? 0 : uint8(levels.length - 1);
            users[list[i]].expires = 183267472027;

            if(i < 44)vips.push(list[i]);

            emit Registration(list[i], root_user, uint64(block.timestamp));
            emit LevelPurchase(list[i], users[list[i]].level, uint64(block.timestamp), users[list[i]].expires, 0);
        }

    }

    function payout(address payable user, uint256 value, uint8 level) private {
        address payable member = users[user].upline;
        uint256 balance = value;
        uint256 bvalue = 0;

        blago.transfer(0);
        walletK.transfer(0);

        balance -= balance * 14 / 100;

        for(uint8 i = 0; i < payouts.length; i++) {
            if(member == address(0) || member == root_user) break;
            
            uint256 amount = value * payouts[i] / 100;

            if(i > 5 && users[member].level < i - 5) {
                amount /= 2;
                bvalue += amount;
            }

            if(users[member].expires >= block.timestamp && users[member].level >= level) {
                if(member.send(0)) {
                    balance -= amount;

                    emit ReceivingProfit(member, user, level, uint64(block.timestamp), amount);
                }
            }
            else {
                bvalue += amount;

                emit LostProfit(member, user, level, uint64(block.timestamp), amount);
            }

            member = users[member].upline;
        }

        if(bvalue > 0) {
            blago.transfer(0);
            balance -= bvalue;

            emit Blago(user, uint64(block.timestamp), bvalue);
        }

        if(vips.length > 0) {
            uint256 vpay = value / 100;
            uint256 vpay_pm = vpay / vips.length;
            balance -= vpay;

            for(uint256 i = 0; i < vips.length; i++) {
                users[vips[i]].fwithdraw += vpay_pm;
            }
        }

        (bool success,) = address(root_user).call.value(0).gas(180000)("");
        require(success, "Error send root money");

        emit ReceivingProfit(root_user, user, level, uint64(block.timestamp), balance);
    }

    function setLevel(uint8 index, uint96 min_price, uint96 max_price) external onlyOwner {
        levels[index] = Level({min_price: min_price, max_price: max_price});
    }

    function() external payable {	//injected LOCKED ETHER
        User storage user = users[msg.sender];
        
        if(user.upline == address(0)) {
            user.upline = bytesToAddress(msg.data);

            if(users[user.upline].upline == address(0)) {
                user.upline = root_user;
            }

            users[user.upline].referrals.push(msg.sender);

            emit Registration(msg.sender, user.upline, uint64(block.timestamp));
        }

        uint8 level = this.getLevelByPrice(msg.value);

        require(user.expires == 0 || (user.expires >= block.timestamp && level > user.level) || (user.expires < block.timestamp && level >= user.level), "Invalid level");
        
        if(user.level < 5 && level == 5) {
            vips.push(msg.sender);
        }

        user.level = level;

        user.expires = uint64(block.timestamp + LEVEL_LIFE_TIME);

        emit LevelPurchase(msg.sender, level, uint64(block.timestamp), user.expires, msg.value);

        payout(msg.sender, msg.value, level);
    }


    function withdraw() external {
        require(users[msg.sender].fwithdraw > 0, "Your balance is empty");
        require(users[msg.sender].expires > block.timestamp, "Pay level");

        address(msg.sender).transfer(0);

        emit Withdraw(msg.sender, uint64(block.timestamp), users[msg.sender].fwithdraw);

        users[msg.sender].fwithdraw = 0;
    }

    function getLevelByPrice(uint value) external view returns(uint8) {
        require(value >= levels[0].min_price && value <= levels[levels.length - 1].max_price, "Amount not in the range");

        for(uint8 i = 0; i < levels.length; i++) {
            if(value > levels[i].min_price && value <= levels[i].max_price) {
                return i;
            }
        }
    }

    function getUserReferrals(address user) external view returns(address payable[] memory) {
        return users[user].referrals;
    }

    function bytesToAddress(bytes memory data) private pure returns(address payable addr) {
        assembly {
            addr := mload(add(data, 20))
        }
    }
}