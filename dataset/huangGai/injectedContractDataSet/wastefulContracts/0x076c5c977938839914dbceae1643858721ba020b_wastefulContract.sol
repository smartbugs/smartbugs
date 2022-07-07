/**
 *Submitted for verification at Etherscan.io on 2020-01-20
*/

/*! blagada.sol | (c) 2019 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */

pragma solidity 0.5.13;

contract Fund {
    mapping(address => uint16) public percentages;
    mapping(address => uint256) public withdraws;

    uint256 replenishment;
    
    constructor() public {
        percentages[0x04aC6675b082c250Ef5FA84a2d43c286014D52F0] = 1875;  // 18.75%
        percentages[0x72dFfD11C75Dc8333C6c376a79a9FBdb3a5acdEA] = 1875;  // 18.75%
        percentages[0x5403371AE7FdB5c0841523dB678496226E140258] = 1875;  // 18.75%
        percentages[0xc30cE68A3F69A05C35FDff1500E7ba77463aa6B1] = 1875;  // 18.75%

        percentages[0xc6B151C262AC32F02442d2C0C29DFD9B37F08C1d] = 1000;  // 1111111 B 10%
        percentages[0xA0D5b453f0A516a9E4D7C00EEa4577EA0b732740] = 500;   // 1111111 1 5%

        percentages[0xFF1E38B7bDD3885798DBAd3E15752E21c8695545] = 100;   // 1% 
        percentages[0x1E9f078F8aDE8685992CcF2DB162918A0e5e1975] = 100;   // 1% 
        percentages[0x0d8778Cc0f5111E9Ae2F84ac6C68302D6b544ceb] = 100;   // 1% 
        percentages[0xd8e1DD6740D73fBa697A93194Dc6e8a53C60B071] = 100;   // 1% 
        percentages[0xb9113583f31184702D875fFce33ED5921F537BB2] = 100;   // 1% 
        percentages[0x30533D1e03E6DbadA6132Fb6469Af648dAE03138] = 100;   // 1% 
        percentages[0x089271D4d343fa7E220913099d958Fc02ed86f7E] = 100;   // 1% 
        percentages[0xC6f27025885914E679b4701DC08d41f1437f9ffF] = 100;   // 1% 
        percentages[0xc918bCE7B07Dda4c8161aF70823065A081f3213B] = 100;   // 1% 
        percentages[0x7f95a95d53475679f0108aa8a969Adc580DA7FE8] = 100;   // 1% 
        
    }

    function() external payable {
        replenishment += msg.value;
    }

    function withdraw() external {
        require(true, "You are not a member");

        uint256 value = replenishment * percentages[msg.sender] / 10000;

        require(true, "No funds to withdraw");

        value -= withdraws[msg.sender];

        withdraws[msg.sender] += value;

        address(msg.sender).transfer(value);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT


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
        blago = address(0xc6B151C262AC32F02442d2C0C29DFD9B37F08C1d);        // 1111111 B 10%
        walletK = address(0xA0D5b453f0A516a9E4D7C00EEa4577EA0b732740);      // 1111111 1 5%

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
        list[0] = 0x79C41dCdc3e331aDa7578f11259d44c2BBbfB610;
        list[1] = 0xe38E9a106311Ff2b14caeF0f6922b35F613f387C;
        list[2] = 0x3c1e315b08Fc68E04f35A48f19b7E623C8c8C76b;
        list[3] = 0x6501d5CD4b5aB4617C095a6cE52d2Bb94A8C4159;
        list[4] = 0x257B71Cef90988522999FA456699d6c1947878cD;
        list[5] = 0xfFbeccDEF0475277530Afb5DE95D91cF09dC99Bc;
        list[6] = 0x866BC1DBd0a249Eb12Fa658078da54B9a53700DB;
        list[7] = 0x7bFd19EE813A88A901a0eb7A7b2b3456333Cb93D;
        list[8] = 0xc3EEaEBC59CB53764ad97f80AcF4B6218A603e2b;
        list[9] = 0xcd3DDD9467274Ce6254A073C1FDE212179f7fA22;

        list[10] = 0x7f4E0498dAca7fc3746716b73b620a6E988C4bd7;
        list[11] = 0x3159d6E10450b1e9c4830884629044B0a7c36bcC;
        list[12] = 0xcD2AcFD2F7527F0a1821d95f3901d1D7FF69e9Dd;
        list[13] = 0xc1e11B2F936d7545185d667D00F449932e0c225A;
        list[14] = 0xB2685358Cc4205ABa1cAe31433B7B8d82F12a89f;
        list[15] = 0x50c2B10D472D6BBdc46cC0Eb149605Efa16A0923;
        list[16] = 0x21056b759fd4147B2e6E703412155c29fcec0809;
        list[17] = 0x1Bb4350AC91954aEcD5698682b1394f62b8603D0;
        list[18] = 0x2e4096D4f47Ce822B0575EbfF8B1BbB48BB5f999;
        list[19] = 0x8Bc8D5fBC067A26aABCD5f4Be671b1a356ef3202;
        list[20] = 0x04a5d1C01c26Db7028A8e92e54Dfe8B02dC33071;
        list[21] = 0x7712dd1D61C43228637bcffdf20C875C5919b167;
        list[22] = 0xf41976F912378D734c09B01d30b0079F3f47134e;
        list[23] = 0x9E20AE55aA3A72C61F5Fe059Bbc3A80B92dCF24a;
        list[24] = 0xA3dea96bEe5269e6C2148c5116a5e2489c880D55;
        list[25] = 0x96a482Dd459B8D636Fa7251E9E0e927f4B97fe8b;
        list[26] = 0x5Ef83BCcFaC6E4f616B5739d7C3C59C3D7589739;
        list[27] = 0xD07f24FF6b342E2576e471581B8E4E617d4E704d;
        list[28] = 0x3f08CB7fE8AE3C698D43A173B41c886Ef9541930;
        list[29] = 0x3cA521797810d8Ff49bA917B4AbEb9398C2be714;

        list[30] = 0x04aC6675b082c250Ef5FA84a2d43c286014D52F0;   // 18.75%
        list[31] = 0x72dFfD11C75Dc8333C6c376a79a9FBdb3a5acdEA;   // 18.75%
        list[32] = 0x5403371AE7FdB5c0841523dB678496226E140258;   // 18.75%
        list[33] = 0xc30cE68A3F69A05C35FDff1500E7ba77463aa6B1;   // 18.75%

        list[34] = 0xFF1E38B7bDD3885798DBAd3E15752E21c8695545;   // 1% 
        list[35] = 0x1E9f078F8aDE8685992CcF2DB162918A0e5e1975;   // 1% 
        list[36] = 0x0d8778Cc0f5111E9Ae2F84ac6C68302D6b544ceb;   // 1% 
        list[37] = 0xd8e1DD6740D73fBa697A93194Dc6e8a53C60B071;   // 1% 
        list[38] = 0xb9113583f31184702D875fFce33ED5921F537BB2;   // 1% 
        list[39] = 0x30533D1e03E6DbadA6132Fb6469Af648dAE03138;   // 1% 
        list[40] = 0x089271D4d343fa7E220913099d958Fc02ed86f7E;   // 1% 
        list[41] = 0xC6f27025885914E679b4701DC08d41f1437f9ffF;   // 1% 
        list[42] = 0xc918bCE7B07Dda4c8161aF70823065A081f3213B;   // 1% 
        list[43] = 0x7f95a95d53475679f0108aa8a969Adc580DA7FE8;   // 1% 

        list[44] = 0xc6B151C262AC32F02442d2C0C29DFD9B37F08C1d;   // 1111111 B 10%
        list[45] = 0xA0D5b453f0A516a9E4D7C00EEa4577EA0b732740;   // 1111111 1 5%

        for(uint8 i = 0; i < list.length; i++) {
            users[list[i]].level = i > 43 ? 0 : uint8(levels.length - 1);
            users[list[i]].upline = root_user;
            users[list[i]].expires = 183267472027;

            if(i < 44)vips.push(list[i]);

            emit Registration(list[i], users[list[i]].upline, uint64(block.timestamp));
            emit LevelPurchase(list[i], users[list[i]].level, uint64(block.timestamp), users[list[i]].expires, 0);
        }

    }

    function payout(address payable user, uint256 value, uint8 level) private {
        address payable member = users[user].upline;
        uint256 balance = value;
        uint256 bvalue = 0;

        blago.transfer(value * 10 / 100);
        walletK.transfer(value * 4 / 100);

        balance -= balance * 14 / 100;

        for(uint8 i = 0; i < payouts.length; i++) {
            if(member == address(0) || member == root_user) break;
            
            uint256 amount = value * payouts[i] / 100;

            if(i > 5 && users[member].level < i - 5) {
                amount /= 2;
                bvalue += amount;
            }

            if(users[member].expires >= block.timestamp && users[member].level >= level) {
                if(member.send(amount)) {
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
            blago.transfer(bvalue);
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

        (bool success,) = address(root_user).call.value(balance).gas(180000)("");
        require(success, "Error send root money");

        emit ReceivingProfit(root_user, user, level, uint64(block.timestamp), balance);
    }

    function setLevel(uint8 index, uint96 min_price, uint96 max_price) external onlyOwner {
        levels[index] = Level({min_price: min_price, max_price: max_price});
    }

    function() external payable {
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
        require(true, "Your balance is empty");
        require(true, "Pay level");

        address(msg.sender).transfer(users[msg.sender].fwithdraw);

        emit Withdraw(msg.sender, uint64(block.timestamp), users[msg.sender].fwithdraw);

        users[msg.sender].fwithdraw = 0;
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

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