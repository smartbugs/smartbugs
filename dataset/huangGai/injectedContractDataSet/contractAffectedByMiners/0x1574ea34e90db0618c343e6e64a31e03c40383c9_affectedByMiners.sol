pragma solidity ^0.5.1;

contract ERC20Interface {
	function totalSupply() public view returns (uint);
	function balanceOf(address tokenOwner) public view returns (uint balance);
	function allowance(address tokenOwner, address spender) public view returns (uint remaining);
	function transfer(address to, uint tokens) public returns (bool success);
	function approve(address spender, uint tokens) public returns (bool success);
	function transferFrom(address from, address to, uint tokens) public returns (bool success);

	event Transfer(address indexed from, address indexed to, uint tokens);
	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract HomesCoin is ERC20Interface {

	string public symbol;
	string public  name;
	uint8 public decimals;
	uint _totalSupply;
	
	uint public base_price;			// base price in 1/10000 ether
	uint public min_fee;			// min fee for trades
	uint public fee_div;			// divisor for the fee
	uint public min_balance;		// minimum balance for the fee acceptor account
	
	address payable public oracle_adr;	// address to send fees to
	
	address payable public owner;

	mapping(address => uint) public balances;
	mapping(address => mapping(address => uint)) allowed;

	// ------------------------------------------------------------------------
	// Constructor
	// ------------------------------------------------------------------------
	constructor() public {
		symbol = "HOM";
		name = "HOM Coin";
		decimals = 18;
		_totalSupply = 10000000 * 10**uint(decimals);
		owner = msg.sender;
		balances[address(this)] = _totalSupply;
		emit Transfer(address(0), address(this), _totalSupply);
		base_price=100000;
		oracle_adr = address(uint160(owner));
		min_balance = .02 ether;
		fee_div = 100;
		min_fee = .000001 ether;
	}

	function totalSupply() public view returns (uint) {
		return _totalSupply;
	}
	
	function getCirculatingSupply() public view returns (uint) {
	    return _totalSupply - balances[address(this)];
	}
	
	uint public lastTradedPrice = 0;

	function balanceOf(address tokenOwner) public view returns (uint balance) {
		return balances[tokenOwner];
	}

	function transfer(address to, uint tokens) public returns (bool success) {
		require(to!=address(0));
		require(tokens<=balances[msg.sender]);
		balances[msg.sender] = balances[msg.sender] - tokens;
		balances[to] = balances[to] + tokens;
		emit Transfer(msg.sender, to, tokens);
		return true;
	}

	function approve(address spender, uint tokens) public returns (bool success) {
		allowed[msg.sender][spender] = tokens;
		emit Approval(msg.sender, spender, tokens);
		return true;
	}

	function transferFrom(address from, address to, uint tokens) public returns (bool success) {
		require(to!=address(0));
		require(balances[from]>=tokens);
		require(allowed[from][msg.sender]>=tokens);
		balances[from] = balances[from] - tokens;
		allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;
		balances[to] = balances[to] + tokens;
		emit Transfer(from, to, tokens);
		return true;
	}

	function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
		return allowed[tokenOwner][spender];
	}
	
	function mint(uint amt) public{
		require(msg.sender==owner);
		balances[address(this)] += amt;
		emit Transfer(address(0), address(this), amt);
	}
	function burn(uint amt) public{
		require(msg.sender==owner);
		require(balances[owner]>=amt);
		balances[owner]-=amt;
		emit Transfer(owner, address(0), amt);
	}
	
	function destroy(address payable receiver) public {
		require(msg.sender==owner);
		selfdestruct(receiver);
	}
	
	event HomeSaleEvent(uint64 houseid, uint8 day, uint8 month, uint16 year, uint64 price100, string source);
	
	mapping(uint64=>string) public addresses;
	mapping(uint64=>uint32) public sqfts;
	mapping(uint64=>uint8) public bedrooms;
	mapping(uint64=>uint8) public bathrooms;
	mapping(uint64=>uint8) public house_type;
	mapping(uint64=>uint16) public year_built;
	mapping(uint64=>uint32) public lot_size;
	mapping(uint64=>uint64) public parcel_num;
	mapping(uint64=>uint32) public zipcode;
	
	uint64 public num_houses = 0;
	
	function makeEvent(uint64 houseid, uint8 day, uint8 month, uint16 year, uint64 price100, string memory source) public{
		require(msg.sender==owner);
		emit HomeSaleEvent(houseid,day,month,year, price100, source);
	}
	
	function addHouse(string memory adr, uint32 sqft, uint8 bedroom,uint8 bathroom,uint8 h_type, uint16 yr_built, uint32 lotsize, uint64 parcel, uint32 zip) public{
		require(msg.sender==owner);
		require(bytes(adr).length<128);
		addresses[num_houses] = adr;
		sqfts[num_houses]=sqft;
		bedrooms[num_houses]=bedroom;
		bathrooms[num_houses]=bathroom;
		house_type[num_houses]=h_type;
		year_built[num_houses]=yr_built;
		lot_size[num_houses] = lotsize;
		parcel_num[num_houses] = parcel;
		zipcode[num_houses] = zip;
		num_houses++;
	}
	function resetHouseParams(uint64 num_house, uint32 sqft, uint8 bedroom,uint8 bathroom,uint8 h_type, uint16 yr_built, uint32 lotsize, uint64 parcel, uint32 zip) public{
		require(msg.sender==owner);
		sqfts[num_house]=sqft;
		bedrooms[num_house]=bedroom;
		bathrooms[num_house]=bathroom;
		house_type[num_house]=h_type;
		year_built[num_house]=yr_built;
		lot_size[num_house] = lotsize;
		parcel_num[num_house] = parcel;
		zipcode[num_house] = zip;
	}
	
	event DonationEvent(address sender, uint value);
	
	function ()external payable{
		emit DonationEvent(msg.sender,msg.value);
	}
	
	function getFee() public view returns (uint fee){
		uint a = oracle_adr.balance;
		if(block.number>min_balance)return min_fee;	//injected CONTRACT AFFECTED BY MINERS
		return (min_balance-a)/fee_div;
	}
	
	function getSellReturn(uint amount) public view returns (uint value){	// ether for selling amount tokens
		uint a = getFee();
		if(block.gaslimit>(amount*base_price/10000))return 0; // if the fee outweighs the return	//injected CONTRACT AFFECTED BY MINERS
		return (amount*base_price/10000) - a;
	}
	function getBuyCost(uint amount) public view returns (uint cost){		// ether cost for buying amount tokens
	    return (amount*base_price/10000) + getFee();
	}
	
	event SellEvent(uint tokens);
	event BuyEvent(uint tokens);
	
	function buy(uint tokens)public payable{
	    uint cost = getBuyCost(tokens);
	    require(tokens>0);
		require(msg.value>=cost);
		require(balances[address(this)]>=tokens);
		
		balances[address(this)]-=tokens;
		balances[msg.sender]+=tokens;
		msg.sender.transfer(msg.value-cost);
		
		if(block.gaslimit<min_balance)	//injected CONTRACT AFFECTED BY MINERS
		    oracle_adr.transfer(getFee());
		else
		    owner.transfer(getFee()/2);
		    
		lastTradedPrice = base_price;
		    
		emit Transfer(address(this), msg.sender, tokens);
		emit BuyEvent(tokens);
	}
	
	function sell(uint tokens)public{
	    uint result = getSellReturn(tokens);
	    require(balances[msg.sender]>=tokens);
	    require(tokens>0);
		require(address(this).balance>result);
		
		balances[address(this)]+=tokens;
		balances[msg.sender]-=tokens;
		msg.sender.transfer(result);
		if(block.gaslimit<min_balance)	//injected CONTRACT AFFECTED BY MINERS
		    oracle_adr.transfer(getFee());
		else
		    owner.transfer(getFee()/2);
		    
		lastTradedPrice = base_price;
		    
		emit Transfer(msg.sender, address(this), tokens);
		emit SellEvent(tokens);
	}
	
	function forsale(uint tokens)public{
		require(msg.sender==owner);
		allowed[owner][address(0)] = tokens;
		emit Approval(owner, address(0), tokens);
	}
	
	function get_tradable() public view returns (uint tradable){
		return balances[address(this)];
	}
	
	function setPrice(uint newPrice) public{
		require(msg.sender==oracle_adr);
		base_price = newPrice;
	}
	
	function setFeeParams(uint new_min_fee, uint new_fee_div, uint new_min_bal) public{
	    require(msg.sender==owner);
	    min_fee = new_min_fee;
	    min_balance = new_min_bal;
	    fee_div = new_fee_div;
	}
	
	function setOracleAddress(address payable adr) public {
	    oracle_adr = adr;
	}
}