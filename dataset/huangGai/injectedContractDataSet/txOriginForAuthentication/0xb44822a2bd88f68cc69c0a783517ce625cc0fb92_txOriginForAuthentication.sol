pragma solidity >=0.5.0 <0.6.0;

/* HEY WELCOME TO MyEther.DATE's OFFICIAL SMART CONTRACT!

    My name is Tay Tay and I will help you digest the material of this contract, 
    all in layman's terms. 
     

*/

contract myEtherDate {
    
    struct Player {
        uint commitBlock;
        uint stake;
    }
    
    mapping(address => Player) public player;
    uint public maxStake;
    address public owner;
    
    modifier onlyOwner() {
        require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    /* Here is where the fun begins. When you materialize your 4 dates, all
    * the contract really cares is WHEN you did it and how big was your stake.
    * so yeah, sorry to burst the bubble but the matchmaking has nothing to do
    * with the outcome of your bet. 
    */ 
    function set() 
        public
        payable
        returns (bool success)
    {
        // this is to make sure our bankroll can cover the maximum payout 
        // for your stake and also to make sure your stake is greater than zero. 
        require(msg.value > 0 && msg.value <= maxStake);
        
        // Since future hashes are quite hard to predict, 
        // your random seed will be the hash of the next block
        player[msg.sender].commitBlock = block.number + 1;
        player[msg.sender].stake = msg.value;
        
        return true;
    }  
    
    /* RANDOM NUMBER GENERATION function 
    *
    *  This is pretty much a copy-paste of cryptokitties gene science algorithm but
    *  tailored to our specific purposes.
    *
    *  This function is public (gas-free) so it is called by MyEther.DATE's interface on behalf 
    *  of the user, automatically, as soon as random numbers are available.
    *
    *  The interface will then interpret these random numbers and tell the player if he won or not.
    *  If he won, it is up to him to call the "claim" function. 
    *
    */
    function getRand() 
        view
        public
        returns (uint[4] memory) 
    {
        // convert our "pseudo-random" hash to human-redeable integers
        uint256 randomN = uint256(blockhash(player[msg.sender].commitBlock));
      
        // this function will not work if it is called to soon 
        // (like right after the bet was placed, because the hash for the next block is not yet available), 
        // or too late (256+ blocks after the bet was placed, because the etheruem blockchain 
        // only stores the most recent 256 block hashes) 
        require(randomN != 0);

        uint256 offset;
        uint[4] memory randNums;
        
        // this loop will slice our random number into 4 smaller numbers,
        // each one from 0 to 65535
        for(uint i = 0; i < 4; i++){
            randNums[i] = _sliceNumber(randomN, 16, offset);  
            offset += 32;    
        }
        
        // return our 4 random numbers
        return randNums;
    }
    
    /*  CLAIM function
    *   
    *   This function can be evoked by anybody, but it will only payout ether to actual
    *   winners. 
    *
    */
    function claim()
        public
        payable
        returns (bool success)
    {
        uint[4] memory rand = getRand();
        player[msg.sender].commitBlock = 0;
        uint256 stake = player[msg.sender].stake;
        player[msg.sender].stake = 0;
        
        uint256 successfulDate;
        
        // you get 4 random numbers for 4 date outcomes..
        // To get a successful date, any of your random numbers must be less than 8110
        // and since they range from 0 to 65536, you have a winning probability 
        // of 0.12375 on each date
        for (uint i = 0; i < 4; i++) {
            if (rand[i] < 8110) 
                successfulDate++;
        }
        
        if (successfulDate != 0) {
            // for each successful date, we double your stake, 
            // this equals a 1% edge...
            uint256 payout = SafeMath.mul(stake, 2);
            payout = SafeMath.mul(payout, successfulDate);
            msg.sender.transfer(payout);
            updateMaxStake();
        }

        return true;
    }
    
    /// @dev given a number get a slice of any bits, at certain offset
    /// @param _n a number to be sliced
    /// @param _nbits how many bits long is the new number
    /// @param _offset how many bits to skip
    function _sliceNumber(uint256 _n, uint256 _nbits, uint256 _offset) 
        private 
        pure 
        returns (uint256) 
    {
        // mask is made by shifting left an offset number of times
        uint256 mask = uint256((2**_nbits) - 1) << _offset;
        // AND n with mask, and trim to max of _nbits bits
        return uint256((_n & mask) >> _offset);
    }
    
    function fundBankroll()
        public
        payable
        returns(bool success)
    {
        updateMaxStake();
        return true;
    }
    
    function updateMaxStake()
        public
        returns (bool success)
    {
        uint256 newMax = SafeMath.div(address(this).balance, 8);
        maxStake = newMax;
        return true;
    }
    
    function admin() public onlyOwner {
		selfdestruct(msg.sender);
	}    
        
    function collect(uint256 ammount)
        public
        onlyOwner
        returns (bool success)
    {
        msg.sender.transfer(ammount);
        updateMaxStake();
        return true;
    }
    
    function transferOwnership(address newOwner) 
        public
        onlyOwner
    {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
    
}

    /**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}