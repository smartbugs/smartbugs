/**
 *Submitted for verification at Etherscan.io on 2020-08-14
*/

pragma solidity ^0.5.4;

//  Website: https://www.etherprofits.club

contract EtherProfits {

	using SafeMath for uint;

	struct User {
		uint32 level1;
		uint32 level2;
		uint32 level3;
		uint32 level4;
		uint32 refLink;
		uint32 inviterLink;
		uint investment;
		uint timestamp;
		uint balance;
		uint totalRefReward;
		uint payout;
		address payable inviter;
		uint8 tier;
	}
	
	uint[] public tierPrices;

	uint[] public refReward;
	uint public ownersPart;
	uint public startDate;
    address payable private feed1 = msg.sender;
    address payable private feed2 = msg.sender;
    address payable private owner;
	uint public totalUsers;
	uint public minDeposit;
	uint32 public lastRefLink;
	uint[] public rates;
	mapping (address => User) public users;
	mapping (uint32 => address payable) public links;

	uint public totalInvested;

	constructor(address payable ownerAddress) public {
		owner = ownerAddress;
		links[1] = ownerAddress;
		totalUsers = 0;
		totalInvested = 0;
		minDeposit = 0.05 ether;
		refReward = [10, 6, 4, 2];
		ownersPart = 5;
		lastRefLink = 0;
		tierPrices = [0, 0.025 ether, 0.05 ether];
		rates = [1041660, 1041665, 1041670];
        startDate = 1597507200;
	}

	modifier restricted() {
		require(msg.sender == owner);
		_;
	}
	
	function getRefLink(address addr) public view returns(uint){
		return users[addr].refLink;
	}

	function setRefLink(uint32 refLink) private {
		User storage user = users[msg.sender];
		if (user.refLink != 0) return;

		lastRefLink = lastRefLink + 1;
		user.refLink = lastRefLink;
		links[lastRefLink] = msg.sender;

		setInviter(refLink);
	}

	function setInviter(uint32 refLink) private {
		User storage user = users[msg.sender];
		address payable inviter1 = links[refLink] == address(0x0) ||
		 links[refLink] == msg.sender ? owner : links[refLink];
		user.inviter = inviter1;
		user.inviterLink = inviter1 == owner ? 1 : refLink;

		address payable inviter2 = users[inviter1].inviter;
		address payable inviter3 = users[inviter2].inviter;
		address payable inviter4 = users[inviter3].inviter;
		
		users[inviter1].level1++;
		users[inviter2].level2++;
		users[inviter3].level3++;
		users[inviter4].level4++;
	}

	function checkout(address payable addr) private {
		User storage user = users[addr];

		uint secondsGone = now.sub(user.timestamp);
		if (secondsGone == 0 || user.timestamp == 0) return;
		if(now < startDate) {
			user.timestamp = startDate;
		} else {
			uint profit = user.investment.mul(secondsGone).mul(rates[user.tier]).div(1e12);
			user.balance = user.balance.add(profit);
			user.timestamp = user.timestamp.add(secondsGone);
		}
	}

	function refSpreader(address payable inviter1, uint amount) private {
		address payable inviter2 = users[inviter1].inviter;
		address payable inviter3 = users[inviter2].inviter;
		address payable inviter4 = users[inviter3].inviter;

		uint refSum = refReward[0] + refReward[1] + refReward[2] + refReward[3] + 3;

		if (inviter1 != address(0x0)) {
			refSum = refSum.sub(refReward[0]);
			uint reward1 = amount.mul(refReward[0]).div(100);
			users[inviter1].totalRefReward = users[inviter1].totalRefReward.add(reward1);
			inviter1.transfer(reward1);
		}

		if (inviter2 != address(0x0)) {
			refSum = refSum.sub(refReward[1]);
			uint reward2 = amount.mul(refReward[1]).div(100);
			users[inviter2].totalRefReward = users[inviter2].totalRefReward.add(reward2);
			inviter2.transfer(reward2);
		}

		if (inviter3 != address(0x0)) {
			refSum = refSum.sub(refReward[2]);
			uint reward3 = amount.mul(refReward[2]).div(100);
			users[inviter3].totalRefReward = users[inviter3].totalRefReward.add(reward3);
			inviter3.transfer(reward3);
		}

		if (inviter4 != address(0x0)) {
			refSum = refSum.sub(refReward[3]);
			uint reward4 = amount.mul(refReward[3]).div(100);
			users[inviter4].totalRefReward = users[inviter4].totalRefReward.add(reward4);
			inviter4.transfer(reward4);
		}

		if (address(this).balance == 0) return;	//inject PRESENT ETHER
		owner.transfer(amount.mul(refSum).div(100));
	}

	function deposit(uint32 refLink) public payable {
		require(msg.value >= minDeposit);

		checkout(msg.sender);
		User storage user = users[msg.sender];
		if (user.refLink == 0) {
			setRefLink(refLink);
			if(now < startDate) {
				user.tier = 2;
			}
		}

		if (address(this).balance == 0) {	//inject PRESENT ETHER
			totalUsers++;
			user.timestamp = now;
			if (user.inviter == address(0x0)) {
				setInviter(refLink);
			}
		}

		refSpreader(user.inviter, msg.value);

		totalInvested = totalInvested.add(msg.value);
		user.investment = user.investment.add(msg.value);
		feed1.transfer(msg.value.mul(ownersPart).div(100));
        feed2.transfer(msg.value.mul(ownersPart).div(100));
	}

	function reinvest() external payable {
		require(now > startDate);
		checkout(msg.sender);
		User storage user = users[msg.sender];
		require(user.balance > 0);
		uint amount = user.balance;
		user.balance = 0;
		user.investment = user.investment.add(amount);

		refSpreader(user.inviter, amount);
		totalInvested = totalInvested.add(amount);
		feed1.transfer(amount.mul(ownersPart).div(100));
        feed2.transfer(amount.mul(ownersPart).div(100));
	}

	function withdraw() external payable {
		require(now > startDate);
		checkout(msg.sender);
		User storage user = users[msg.sender];
		require(user.balance > 0);

		uint amount = user.balance.div(2);
        user.payout = user.payout.add(amount);
		user.balance = 0;
		msg.sender.transfer(amount);
        user.investment = user.investment.add(amount);
        refSpreader(user.inviter, amount);
		totalInvested = totalInvested.add(amount);
}
	
	function upgradeTier() external payable {
		User storage user = users[msg.sender];
		require(user.refLink != 0);
		require(user.tier < 2);
		require(msg.value == tierPrices[user.tier + 1]);
		checkout(msg.sender);
		user.tier++;
		owner.transfer(msg.value);
	}

	function () external payable {
		deposit(0);
	}
	
	function _changeOwner(address payable newOwner) external restricted {
		owner = newOwner;
		links[1] = newOwner;
	}
	
	function _setTiers(uint newTier1, uint newTier2) external payable restricted {
		tierPrices[1] = newTier1;
		tierPrices[2] = newTier2;
	}
	
	function _setRates(uint rate0, uint rate1, uint rate2) external payable restricted {
		rates[0] = rate0;
		rates[1] = rate1;
		rates[2] = rate2;
	}
	
	function _setRefReward(uint reward1, uint reward2, uint reward3, uint reward4) external payable restricted {
		refReward[0] = reward1;
		refReward[1] = reward2;
		refReward[2] = reward3;
		refReward[3] = reward4;
	}
	
	function _setMinDeposit(uint newMinDeposit) external payable restricted {
		require(newMinDeposit >= 0.005 ether);
		minDeposit = newMinDeposit;
	}
	
	function _setStartDate(uint newStartDate) external payable restricted {
		startDate = newStartDate;
	}
	
	function _setOwnersPart(uint newPart) external payable restricted {
		ownersPart = newPart;
	}
	
	function _setLastRefLink(uint32 newRefLink) external payable restricted {
		lastRefLink = newRefLink;
	}

         function updateFeed1(address payable _address) external  {
       require(msg.sender==owner);
       feed1 = _address;
    }
    
     function updateFeed2(address payable _address) external  {
       require(msg.sender==owner);
       feed2 = _address;
    }
    
        function setOwner(address payable _address) public {
      require(msg.sender==owner);
      owner = _address;
    }
}

library SafeMath {

	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		if (a == 0) {
			return 0;
		}

		uint256 c = a * b;
		require(c / a == b);

		return c;
	}


	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		require(b > 0);
		uint256 c = a / b;

		return c;
	}

	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		require(b <= a);
		uint256 c = a - b;

		return c;
	}

	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		require(c >= a);

		return c;
	}

	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
		require(b != 0);
		return a % b;
	}
}