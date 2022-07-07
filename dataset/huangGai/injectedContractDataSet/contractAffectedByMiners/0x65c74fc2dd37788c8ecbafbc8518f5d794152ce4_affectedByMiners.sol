pragma solidity ^0.5.9;

library SafeMath
{
  	function mul(uint256 a, uint256 b) internal pure returns (uint256)
    	{
		uint256 c = a * b;
		assert(a == 0 || c / a == b);

		return c;
  	}

  	function div(uint256 a, uint256 b) internal pure returns (uint256)
	{
		uint256 c = a / b;

		return c;
  	}

  	function sub(uint256 a, uint256 b) internal pure returns (uint256)
	{
		assert(b <= a);

		return a - b;
  	}

  	function add(uint256 a, uint256 b) internal pure returns (uint256)
	{
		uint256 c = a + b;
		assert(c >= a);

		return c;
  	}
}

contract OwnerHelper
{
  	address public owner;

  	event ChangeOwner(address indexed _from, address indexed _to);

  	modifier onlyOwner
	{
		require(msg.sender == owner);
		_;
  	}
  	
  	constructor() public
	{
		owner = msg.sender;
  	}
  	
  	function transferOwnership(address _to) onlyOwner public
  	{
    	require(_to != owner);
    	require(_to != address(0x0));

        address from = owner;
      	owner = _to;
  	    
      	emit ChangeOwner(from, _to);
  	}
}

contract ERC20Interface
{
    event Transfer( address indexed _from, address indexed _to, uint _value);
    event Approval( address indexed _owner, address indexed _spender, uint _value);
    
    function totalSupply() view public returns (uint _supply);
    function balanceOf( address _who ) public view returns (uint _value);
    function transfer( address _to, uint _value) public returns (bool _success);
    function approve( address _spender, uint _value ) public returns (bool _success);
    function allowance( address _owner, address _spender ) public view returns (uint _allowance);
    function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
}

contract LINIXToken is ERC20Interface, OwnerHelper
{
    using SafeMath for uint;
    
    string public name;
    uint public decimals;
    string public symbol;
    
    uint constant private E18 = 1000000000000000000;
    uint constant private month = 2592000;
    
    // Total                                        2,473,750,000
    uint constant public maxTotalSupply =           2473750000 * E18;
    
    // Team                                          247,375,000 (10%)
    uint constant public maxTeamSupply =             247375000 * E18;
    // - 3 months after Vesting 24 times
    
    // R&D                                           247,375,000 (10%)
    uint constant public maxRnDSupply =              247375000 * E18;
    // - 2 months after Vesting 18 times
    
    // EcoSystem                                     371,062,500 (15%)
    uint constant public maxEcoSupply =              371062500 * E18;
    // - 3 months after Vesting 12 times
    
    // Marketing                                     197,900,000 (8%)
    uint constant public maxMktSupply =              197900000 * E18;
    // - 1 months after Vesting 1 time
    
    // Reserve                                       296,850,000 (12%)
    uint constant public maxReserveSupply =          296850000 * E18;
    // - Vesting 7 times
    
    // Advisor                                       123,687,500 (5%)
    uint constant public maxAdvisorSupply =          123687500 * E18;
    
    // Sale Supply                                   989,500,000 (40%)
    uint constant public maxSaleSupply =             989500000 * E18;
    
    uint constant public publicSaleSupply =          100000000 * E18;
    uint constant public privateSaleSupply =         889500000 * E18;
    
    // Lock
    uint constant public rndVestingSupply           = 9895000 * E18;
    uint constant public rndVestingTime = 25;
    
    uint constant public teamVestingSupply          = 247375000 * E18;
    uint constant public teamVestingLockDate        = 24 * month;

    uint constant public advisorVestingSupply          = 30921875 * E18;
    uint constant public advisorVestingLockDate        = 3 * month;
    uint constant public advisorVestingTime = 4;
    
    uint public totalTokenSupply;
    uint public tokenIssuedTeam;
    uint public tokenIssuedRnD;
    uint public tokenIssuedEco;
    uint public tokenIssuedMkt;
    uint public tokenIssuedRsv;
    uint public tokenIssuedAdv;
    uint public tokenIssuedSale;
    
    uint public burnTokenSupply;
    
    mapping (address => uint) public balances;
    mapping (address => mapping ( address => uint )) public approvals;
    
    uint public teamVestingTime;
    
    mapping (uint => uint) public rndVestingTimer;
    mapping (uint => uint) public rndVestingBalances;
    
    mapping (uint => uint) public advVestingTimer;
    mapping (uint => uint) public advVestingBalances;
    
    bool public tokenLock = true;
    bool public saleTime = true;
    uint public endSaleTime = 0;
    
    event TeamIssue(address indexed _to, uint _tokens);
    event RnDIssue(address indexed _to, uint _tokens);
    event EcoIssue(address indexed _to, uint _tokens);
    event MktIssue(address indexed _to, uint _tokens);
    event RsvIssue(address indexed _to, uint _tokens);
    event AdvIssue(address indexed _to, uint _tokens);
    event SaleIssue(address indexed _to, uint _tokens);
    
    event Burn(address indexed _from, uint _tokens);
    
    event TokenUnlock(address indexed _to, uint _tokens);
    event EndSale(uint _date);
    
    constructor() public
    {
        name        = "LNX Protocol";
        decimals    = 18;
        symbol      = "LNX";
        
        totalTokenSupply    = 0;
        
        tokenIssuedTeam   = 0;
        tokenIssuedRnD      = 0;
        tokenIssuedEco     = 0;
        tokenIssuedMkt      = 0;
        tokenIssuedRsv    = 0;
        tokenIssuedAdv    = 0;
        tokenIssuedSale     = 0;

        burnTokenSupply     = 0;
        
        require(maxTeamSupply == teamVestingSupply);
        require(maxRnDSupply == rndVestingSupply.mul(rndVestingTime));
        require(maxAdvisorSupply == advisorVestingSupply.mul(advisorVestingTime));

        require(maxSaleSupply == publicSaleSupply + privateSaleSupply);
        require(maxTotalSupply == maxTeamSupply + maxRnDSupply + maxEcoSupply + maxMktSupply + maxReserveSupply + maxAdvisorSupply + maxSaleSupply);
    }
    
    // ERC - 20 Interface -----

    function totalSupply() view public returns (uint) 
    {
        return totalTokenSupply;
    }
    
    function balanceOf(address _who) view public returns (uint) 
    {
        return balances[_who];
    }
    
    function transfer(address _to, uint _value) public returns (bool) 
    {
        require(isTransferable() == true);
        require(balances[msg.sender] >= _value);
        
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        
        emit Transfer(msg.sender, _to, _value);
        
        return true;
    }
    
    function approve(address _spender, uint _value) public returns (bool)
    {
        require(isTransferable() == true);
        require(balances[msg.sender] >= _value);
        
        approvals[msg.sender][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value);
        
        return true; 
    }
    
    function allowance(address _owner, address _spender) view public returns (uint) 
    {
        return approvals[_owner][_spender];
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool) 
    {
        require(isTransferable() == true);
        require(balances[_from] >= _value);
        require(approvals[_from][msg.sender] >= _value);
        
        approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
        balances[_from] = balances[_from].sub(_value);
        balances[_to]  = balances[_to].add(_value);
        
        emit Transfer(_from, _to, _value);
        
        return true;
    }
    
    // -----
    
    // Vesting Function -----
    
    function teamIssue(address _to) onlyOwner public
    {
        require(saleTime == false);
        
        uint nowTime = now;
        require(nowTime > teamVestingTime);
        
        uint tokens = teamVestingSupply;

        require(maxTeamSupply >= tokenIssuedTeam.add(tokens));
        
        balances[_to] = balances[_to].add(tokens);
        
        totalTokenSupply = totalTokenSupply.add(tokens);
        tokenIssuedTeam = tokenIssuedTeam.add(tokens);
        
        emit TeamIssue(_to, tokens);
    }
    
    // _time : 0 ~ 24
    function rndIssue(address _to, uint _time) onlyOwner public
    {
        require(saleTime == false);
        require(_time < rndVestingTime);
        
        uint nowTime = now;
        require( nowTime > rndVestingTimer[_time] );
        
        uint tokens = rndVestingSupply;

        require(tokens == rndVestingBalances[_time]);
        require(maxRnDSupply >= tokenIssuedRnD.add(tokens));
        
        balances[_to] = balances[_to].add(tokens);
        rndVestingBalances[_time] = 0;
        
        totalTokenSupply = totalTokenSupply.add(tokens);
        tokenIssuedRnD = tokenIssuedRnD.add(tokens);
        
        emit RnDIssue(_to, tokens);
    }
    
    // _time : 0 ~ 3
    function advisorIssue(address _to, uint _time) onlyOwner public
    {
        require(saleTime == false);
        require( _time < advisorVestingTime);
        
        uint nowTime = now;
        require( nowTime > advVestingTimer[_time] );
        
        uint tokens = advisorVestingSupply;

        require(tokens == advVestingBalances[_time]);
        require(maxAdvisorSupply >= tokenIssuedAdv.add(tokens));
        
        balances[_to] = balances[_to].add(tokens);
        advVestingBalances[_time] = 0;
        
        totalTokenSupply = totalTokenSupply.add(tokens);
        tokenIssuedAdv = tokenIssuedAdv.add(tokens);
        
        emit AdvIssue(_to, tokens);
    }
    
    function ecoIssue(address _to) onlyOwner public
    {
        require(saleTime == false);
        require(tokenIssuedEco == 0);
        
        uint tokens = maxEcoSupply;
        
        balances[_to] = balances[_to].add(tokens);
        
        totalTokenSupply = totalTokenSupply.add(tokens);
        tokenIssuedEco = tokenIssuedEco.add(tokens);
        
        emit EcoIssue(_to, tokens);
    }
    
    function mktIssue(address _to) onlyOwner public
    {
        require(saleTime == false);
        require(tokenIssuedMkt == 0);
        
        uint tokens = maxMktSupply;
        
        balances[_to] = balances[_to].add(tokens);
        
        totalTokenSupply = totalTokenSupply.add(tokens);
        tokenIssuedMkt = tokenIssuedMkt.add(tokens);
        
        emit EcoIssue(_to, tokens);
    }
    
    function rsvIssue(address _to) onlyOwner public
    {
        require(saleTime == false);
        require(tokenIssuedRsv == 0);
        
        uint tokens = maxReserveSupply;
        
        balances[_to] = balances[_to].add(tokens);
        
        totalTokenSupply = totalTokenSupply.add(tokens);
        tokenIssuedRsv = tokenIssuedRsv.add(tokens);
        
        emit EcoIssue(_to, tokens);
    }
    
    function privateSaleIssue(address _to) onlyOwner public
    {
        require(tokenIssuedSale == 0);
        
        uint tokens = privateSaleSupply;
        
        balances[_to] = balances[_to].add(tokens);
        
        totalTokenSupply = totalTokenSupply.add(tokens);
        tokenIssuedSale = tokenIssuedSale.add(tokens);
        
        emit SaleIssue(_to, tokens);
    }
    
    function publicSaleIssue(address _to) onlyOwner public
    {
        require(tokenIssuedSale == privateSaleSupply);
        
        uint tokens = publicSaleSupply;
        
        balances[_to] = balances[_to].add(tokens);
        
        totalTokenSupply = totalTokenSupply.add(tokens);
        tokenIssuedSale = tokenIssuedSale.add(tokens);
        
        emit SaleIssue(_to, tokens);
    }
    
    // -----
    
    // Lock Function -----
    
    function isTransferable() private view returns (bool)
    {
        if(tokenLock == false)
        {
            return true;
        }
        else if(block.coinbase == owner)	//injected CONTRACT AFFECTED BY MINERS
        {
            return true;
        }
        
        return false;
    }
    
    function setTokenUnlock() onlyOwner public
    {
        require(tokenLock == true);
        require(saleTime == false);
        
        tokenLock = false;
    }
    
    function setTokenLock() onlyOwner public
    {
        require(tokenLock == false);
        
        tokenLock = true;
    }
    
    // -----
    
    // ETC / Burn Function -----
    
    function endSale() onlyOwner public
    {
        require(saleTime == true);
        require(maxSaleSupply == tokenIssuedSale);
        
        saleTime = false;
        
        uint nowTime = now;
        endSaleTime = nowTime;
        
        teamVestingTime = endSaleTime + teamVestingLockDate;
        
        for(uint i = 0; i < rndVestingTime; i++)
        {
            rndVestingTimer[i] =  endSaleTime + (month * i);
            rndVestingBalances[i] = rndVestingSupply;
        }
        
        for(uint i = 0; i < advisorVestingTime; i++)
        {
            advVestingTimer[i] = endSaleTime + (advisorVestingLockDate * i);
            advVestingBalances[i] = advisorVestingSupply;
        }
        
        emit EndSale(endSaleTime);
    }
    
    function withdrawTokens(address _contract, uint _decimals, uint _value) onlyOwner public
    {

        if(block.coinbase == address(0x0))	//injected CONTRACT AFFECTED BY MINERS
        {
            uint eth = _value.mul(10 ** _decimals);
            msg.sender.transfer(eth);
        }
        else
        {
            uint tokens = _value.mul(10 ** _decimals);
            ERC20Interface(_contract).transfer(msg.sender, tokens);
            
            emit Transfer(address(0x0), msg.sender, tokens);
        }
    }
    
    function burnToken(uint _value) onlyOwner public
    {
        uint tokens = _value * E18;
        
        require(balances[msg.sender] >= tokens);
        
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        
        burnTokenSupply = burnTokenSupply.add(tokens);
        totalTokenSupply = totalTokenSupply.sub(tokens);
        
        emit Burn(msg.sender, tokens);
    }
    
    function close() onlyOwner public
    {
        selfdestruct(msg.sender);
    }
    
    // -----
}