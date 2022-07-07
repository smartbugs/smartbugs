pragma solidity 0.5.6;

contract P3XRoll {
    using SafeMath for uint256;
    
    struct Bet {
        uint256 amount;
        uint256 chance;
        uint256 blocknumber;
        bool isOpen;
    }
    
    mapping(address => Bet) public bets;
    uint256 public numberOfBets;
    
    mapping(address => uint256) private playerVault;
    uint256 public pot;
    
    uint256 constant public MIN_BET = 1e18; // 1 P3X
    uint256 constant private MAX_PROFIT_DIVISOR = 100;
    
    event Win(address indexed player, uint256 indexed roll, uint256 indexed amount);
    event Loss(address indexed player, uint256 indexed roll, uint256 indexed amount);
    event Expiration(address indexed player, uint256 indexed amount);
    
    address constant private P3X_ADDRESS = address(0x058a144951e062FC14f310057D2Fd9ef0Cf5095b);
    IP3X constant private p3xContract = IP3X(P3X_ADDRESS);
    
    address constant private DEV = address(0x1EB2acB92624DA2e601EEb77e2508b32E49012ef);
    
    //shareholder setup
    struct Shareholder {
        uint256 tokens;
        uint256 outstandingDividends;
        uint256 lastDividendPoints;
    }

    uint256 constant private MAX_SUPPLY = 20000e18;
    uint256 public totalSupply;
    mapping(address => Shareholder) public shareholders;
    bool public minting = true;
    
    uint256 constant private POINT_MULTIPLIER = 10e18;
    uint256 private totalDividendPoints;
    uint256 public totalOutstandingDividends;
    
    uint256 constant private DIVIDEND_FETCH_TIME = 1 hours;
    uint256 private lastDividendsFetched;
    
    event Mint(address indexed player, uint256 indexed amount);
    
    modifier updateDividends()
    {
        if(now - lastDividendsFetched > DIVIDEND_FETCH_TIME && totalSupply > 0) {
            fetchDividendsFromP3X();
        }
        _;
    }
    
    function() external payable {}
    
    function tokenFallback(address player, uint256 amount, bytes calldata data)
	    external
	    updateDividends
	{
	    require(msg.sender == P3X_ADDRESS);
	    
	    if(data[0] == 0) {
	        fundPot(player, amount);
	    } else {
	        placeBet(player, amount, uint8(data[0]));
	    }
	}
        
    function playFromVault(uint256 amount, uint256 chance)
        public	//inject PUBLIC FUNC TO EXTERNAL
        updateDividends
    {
        playerVault[msg.sender] = playerVault[msg.sender].sub(amount);
        
        placeBet(msg.sender, amount, chance);
    }
    
    function placeBet(address player, uint256 amount, uint256 chance)
        private
    {
        require(chance >= 1 && chance <= 98);
        require(amount >= MIN_BET);
        
        if(hasActiveBet(player)) {
            fetch(player);
        }
        
        uint256 potentialProfit = potentialProfit(amount, chance);
        require(potentialProfit <= maximumProfit());
        
        bets[player] = Bet(amount, chance, block.number + 1, true);
        numberOfBets++;
        
        pot = pot.add(amount);
        
        if(minting) {
            mint(player, potentialProfit < amount ? potentialProfit : amount);
        }
    }
    
    function fetchResult()
        public	//inject PUBLIC FUNC TO EXTERNAL
        updateDividends
    {
        require(hasActiveBet(msg.sender));
        
        fetch(msg.sender);
    }
    
    function fetch(address player)
        private
    {
        Bet storage bet = bets[player];
        
        require(bet.blocknumber < block.number);
        
        bet.isOpen = false;
        
        if(block.number - 256 > bet.blocknumber) {
            emit Expiration(player, bet.amount);
            return;
        }
        
        uint256 roll = (uint256(blockhash(bet.blocknumber)) % 100) + 1;
        
        if(roll <= bet.chance) {
            uint256 totalReturn = bet.amount.mul(99) / bet.chance;
            playerVault[player] = playerVault[player].add(totalReturn);
            pot = pot.sub(totalReturn);
            emit Win(player, roll, totalReturn - bet.amount);
        } else {
            emit Loss(player, roll, bet.amount);
        }
    }
    
    function withdrawEarnings()
        public	//inject PUBLIC FUNC TO EXTERNAL
        updateDividends
    {
        uint256 amount = playerVault[msg.sender];
        
        require(amount > 0);
        
        playerVault[msg.sender] = 0;
        
        p3xContract.transfer(msg.sender, amount);
    }
    
    function withdrawDividends()
        public	//inject PUBLIC FUNC TO EXTERNAL
    {
        Shareholder storage shareholder = shareholders[msg.sender];
        
        updateOutstandingDividends(shareholder);
        
        uint256 amount = shareholder.outstandingDividends;
        
        require(amount > 0);
        
        shareholder.outstandingDividends = 0;
        totalOutstandingDividends = totalOutstandingDividends.sub(amount);
		
	    msg.sender.transfer(amount);
    }
    
    function fundPot(address player, uint256 amount)
        private
    {
        require(minting);
        
        pot = pot.add(amount);
        
        mint(player, amount);
    }
    
    function mint(address player, uint256 amount)
        private
    {
        uint256 amountToMint;
        if(totalSupply.add(amount) < MAX_SUPPLY) {
            amountToMint = amount;
        } else {
            amountToMint = MAX_SUPPLY.sub(totalSupply);
            minting = false;
        }
        
        Shareholder storage minter = shareholders[player];
        Shareholder storage dev = shareholders[DEV];
        
        updateOutstandingDividends(minter);
        updateOutstandingDividends(dev);
        
        totalSupply = totalSupply.add(amountToMint);
        minter.tokens = minter.tokens.add(amountToMint.mul(19) / 20);
        dev.tokens = dev.tokens.add(amountToMint / 20);
        
        emit Mint(player, amountToMint);
    }
    
    function updateOutstandingDividends(Shareholder storage shareholder)
        private
    {
        uint256 dividendPointsDifference = totalDividendPoints.sub(shareholder.lastDividendPoints);
        
        shareholder.lastDividendPoints = totalDividendPoints;
        shareholder.outstandingDividends = shareholder.outstandingDividends
                                            .add(dividendPointsDifference.mul(shareholder.tokens) / POINT_MULTIPLIER);
    }
    
    function fetchDividendsFromP3X()
        public
    {
        lastDividendsFetched = now;
        
        uint256 dividends = p3xContract.dividendsOf(address(this), true);
        if(dividends > 0) {
              p3xContract.withdraw();
              totalDividendPoints = totalDividendPoints.add(dividends.mul(POINT_MULTIPLIER) / totalSupply);
              totalOutstandingDividends = totalOutstandingDividends.add(dividends);
        }
    }
    
    //
    // VIEW FUNCTIONS
    //
    function maximumProfit()
        public
        view
        returns(uint256)
    {
        return pot / MAX_PROFIT_DIVISOR;
    }
    
    function potentialProfit(uint256 amount, uint256 chance)
        public
        view
        returns(uint256)
    {
       return (amount.mul(99) / chance).sub(amount);
    }
    
    function hasActiveBet(address player)
        public
        view
        returns(bool)
    {
        return bets[player].isOpen;
    }
    
    function myEarnings()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns(uint256)
    {
        return playerVault[msg.sender];
    }
    
    function myDividends()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns(uint256)
    {
        address shareholder = msg.sender;
        
        uint256 dividendPointsDifference = totalDividendPoints.sub(shareholders[shareholder].lastDividendPoints);
        return shareholders[shareholder].outstandingDividends
                .add(dividendPointsDifference.mul(shareholders[shareholder].tokens) / POINT_MULTIPLIER);
    }
    
    function myTokens()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns(uint256)
    {
        return shareholders[msg.sender].tokens;
    }
    
    function myTokenShare()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns(uint256)
    {
        return totalSupply > 0 ? shareholders[msg.sender].tokens.mul(100) / totalSupply : 0;
    }
    
    function myP3XBalance()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns(uint256)
    {
        return p3xContract.balanceOf(msg.sender);
    }
    
    function fetchableDividendsFromP3X()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns(uint256)
    {
        return p3xContract.dividendsOf(address(this), true);
    }
    
    function mintableTokens()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns(uint256)
    {
        return MAX_SUPPLY.sub(totalSupply);
    }
    
    function timeUntilNextDividendFetching()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns(uint256)
    {
        uint256 difference = now.sub(lastDividendsFetched);
        return difference > DIVIDEND_FETCH_TIME ? 0 : DIVIDEND_FETCH_TIME.sub(difference);
    }
}

interface IP3X {
    function transfer(address to, uint256 value) external returns(bool);
	function transfer(address to, uint value, bytes calldata data) external returns(bool ok);
    function buy(address referrerAddress) payable external returns(uint256);
    function balanceOf(address tokenOwner) external view returns(uint);
	function dividendsOf(address customerAddress, bool includeReferralBonus) external view returns(uint256);
    function withdraw() external;
}

library SafeMath {
    
    function mul(uint256 a, uint256 b) 
        internal 
        pure 
        returns (uint256 c) 
    {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        require(c / a == b, "SafeMath mul failed");
        return c;
    }

    function sub(uint256 a, uint256 b)
        internal
        pure
        returns (uint256) 
    {
        require(b <= a, "SafeMath sub failed");
        return a - b;
    }
    
    function add(uint256 a, uint256 b)
        internal
        pure
        returns (uint256 c) 
    {
        c = a + b;
        require(c >= a, "SafeMath add failed");
        return c;
    }
}