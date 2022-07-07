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
	
	uint internal base_price;			// base price in 1/10000 ether
	uint internal min_fee;			// min fee for trades
	uint internal fee_div;			// divisor for the fee
	uint internal min_balance;		// minimum balance for the fee acceptor account
	
	address payable internal oracle_adr;	// address to send fees to
	
	address payable internal owner;

	mapping(address => uint) internal balances;
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
		emit Transfer(address(0), owner, _totalSupply);
		base_price=100000;
		oracle_adr = address(uint160(owner));
		min_balance = .02 ether;
		fee_div = 100;
		min_fee = .000001 ether;
	}

	function totalSupply() public view returns (uint) {
		return _totalSupply;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	
	function getCirculatingSupply() public view returns (uint) {
	    return _totalSupply - balances[address(this)];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	
	uint internal lastTradedPrice = 0;

	function balanceOf(address tokenOwner) public view returns (uint balance) {
		return balances[tokenOwner];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}

	function transfer(address to, uint tokens) public returns (bool success) {
		require(to!=address(0));
		require(tokens<=balances[msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		balances[msg.sender] = balances[msg.sender] - tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		balances[to] = balances[to] + tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		emit Transfer(msg.sender, to, tokens);
		return true;
	}

	function approve(address spender, uint tokens) public returns (bool success) {
		allowed[msg.sender][spender] = tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		emit Approval(msg.sender, spender, tokens);
		return true;
	}

	function transferFrom(address from, address to, uint tokens) public returns (bool success) {
		require(to!=address(0));
		require(balances[from]>=tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		require(allowed[from][msg.sender]>=tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		balances[from] = balances[from] - tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		balances[to] = balances[to] + tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		emit Transfer(from, to, tokens);
		return true;
	}

	function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
		return allowed[tokenOwner][spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	
	function mint(uint amt) public{
		require(msg.sender==owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		balances[address(this)] += amt;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		emit Transfer(address(0), address(this), amt);
	}
	function burn(uint amt) public{
		require(msg.sender==owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		require(balances[owner]>=amt);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		balances[owner]-=amt;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		emit Transfer(owner, address(0), amt);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	
	function destroy(address payable receiver) public {
		require(msg.sender==owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		selfdestruct(receiver);
	}
	
	event HomeSaleEvent(uint64 houseid, uint8 day, uint8 month, uint16 year, uint64 price100, string source);
	
	mapping(uint64=>string) internal addresses;
	mapping(uint64=>uint32) internal sqfts;
	mapping(uint64=>uint8) internal bedrooms;
	mapping(uint64=>uint8) internal bathrooms;
	mapping(uint64=>uint8) internal house_type;
	mapping(uint64=>uint16) internal year_built;
	mapping(uint64=>uint32) internal lot_size;
	mapping(uint64=>uint64) internal parcel_num;
	mapping(uint64=>uint32) internal zipcode;
	
	uint64 internal num_houses = 0;
	
	function makeEvent(uint64 houseid, uint8 day, uint8 month, uint16 year, uint64 price100, string memory source) public{
		require(msg.sender==owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		emit HomeSaleEvent(houseid,day,month,year, price100, source);
	}
	
	function addHouse(string memory adr, uint32 sqft, uint8 bedroom,uint8 bathroom,uint8 h_type, uint16 yr_built, uint32 lotsize, uint64 parcel, uint32 zip) public{
		require(msg.sender==owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		require(bytes(adr).length<128);
		addresses[num_houses] = adr;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		sqfts[num_houses]=sqft;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		bedrooms[num_houses]=bedroom;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		bathrooms[num_houses]=bathroom;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		house_type[num_houses]=h_type;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		year_built[num_houses]=yr_built;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		lot_size[num_houses] = lotsize;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		parcel_num[num_houses] = parcel;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		zipcode[num_houses] = zip;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		num_houses++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	function resetHouseParams(uint64 num_house, uint32 sqft, uint8 bedroom,uint8 bathroom,uint8 h_type, uint16 yr_built, uint32 lotsize, uint64 parcel, uint32 zip) public{
		require(msg.sender==owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		sqfts[num_house]=sqft;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		bedrooms[num_house]=bedroom;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		bathrooms[num_house]=bathroom;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		house_type[num_house]=h_type;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		year_built[num_house]=yr_built;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		lot_size[num_house] = lotsize;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		parcel_num[num_house] = parcel;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		zipcode[num_house] = zip;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	
	event DonationEvent(address sender, uint value);
	
	function ()external payable{
		emit DonationEvent(msg.sender,msg.value);
	}
	
	function getFee() public view returns (uint fee){
		uint a = oracle_adr.balance;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		if(a>min_balance)return min_fee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		return (min_balance-a)/fee_div;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	
	function getSellReturn(uint amount) public view returns (uint value){	// ether for selling amount tokens
		uint a = getFee();
		if(a>(amount*base_price/10000))return 0; // if the fee outweighs the return	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		return (amount*base_price/10000) - a;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	function getBuyCost(uint amount) public view returns (uint cost){		// ether cost for buying amount tokens
	    return (amount*base_price/10000) + getFee();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	
	event SellEvent(uint tokens);
	event BuyEvent(uint tokens);
	
	function buy(uint tokens)public payable{
	    uint cost = getBuyCost(tokens);
		require(msg.value>=cost);
		require(balances[address(this)]>=tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		
		balances[address(this)]-=tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		balances[msg.sender]+=tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		msg.sender.transfer(msg.value-cost);
		
		if(oracle_adr.balance<min_balance)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		    oracle_adr.transfer(getFee());	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		else
		    owner.transfer(getFee()/2);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		    
		lastTradedPrice = base_price;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		    
		emit Transfer(address(this), msg.sender, tokens);
		emit BuyEvent(tokens);
	}
	
	function sell(uint tokens)public{
	    uint result = getSellReturn(tokens);
	    require(balances[msg.sender]>=tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		require(address(this).balance>result);
		
		balances[address(this)]+=tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		balances[msg.sender]-=tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		msg.sender.transfer(result);
		if(oracle_adr.balance<min_balance)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		    oracle_adr.transfer(getFee());	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		else
		    owner.transfer(getFee()/2);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		    
		lastTradedPrice = base_price;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		    
		emit Transfer(msg.sender, address(this), tokens);
		emit SellEvent(tokens);
	}
	
	function forsale(uint tokens)public{
		require(msg.sender==owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		allowed[owner][address(0)] = tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		emit Approval(owner, address(0), tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	
	function get_tradable() public view returns (uint tradable){
		return balances[address(this)];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	
	function setPrice(uint newPrice) public{
		require(msg.sender==oracle_adr);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		base_price = newPrice;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	
	function setFeeParams(uint new_min_fee, uint new_fee_div, uint new_min_bal) public{
	    require(msg.sender==owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	    min_fee = new_min_fee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	    min_balance = new_min_bal;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	    fee_div = new_fee_div;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
	
	function setOracleAddress(address payable adr) public {
	    oracle_adr = adr;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
}