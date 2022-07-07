pragma solidity ^ 0.5.8;
 
 /**
 *  111111111111111111111111111     1111111111111111
 *  111111111111111111111111111     1111111111111111
 *  111111111111111111111111111     1111111111111111
 *  111111111111111111111111111     1111111111111111
 *  111111111111111111111111111     1111111111111111
 *  111111111111111111111111111     1111111111111111
 *
 * 
 * The contract of acceptance and withdrawal of funds in the first, fair and open gaming platform https://x2bet.win
 * Buying coins x2bet you agree that you have turned 18 years old and you realize the risk associated with gambling and slot machines
 * For the withdrawal of winnings from the system, a commission of 3% is charged.
 * The creator of the project is not responsible for the player1s financial losses when playing fair slot machines, all actions you do at your own risk.
 * The project team has the right to suspend withdrawal of funds, in case of detection of suspicious actions, until clarification of circumstances.
 */

contract X2Bet_win {
    
    using SafeMath
    for uint;
    
    address public owner;
    mapping(address => uint) public deposit;
    mapping(address => uint) public withdrawal;
    bool public status ;	//inject UNINIT LOCAL/STATE VAR

    uint public min_payment ;	//inject UNINIT LOCAL/STATE VAR

    uint public systemPercent ;	//inject UNINIT LOCAL/STATE VAR

    
    constructor()public {
        owner = msg.sender;
    }
    
    event ByCoin(
        address indexed from,
        uint indexed block,
        uint value,
        uint user_id,
        uint time
    );
    
    event ReturnRoyalty(
        address indexed from,
        uint indexed block,
        uint value, 
        uint withdrawal_id,
        uint time
    );
    
    modifier isNotContract(){
        uint size;
        address addr ;	//inject UNINIT LOCAL/STATE VAR

        assembly { size := extcodesize(addr) }
        require(size == 0 && tx.origin == msg.sender);
        _;
    }
    
    modifier contractIsOn(){
        require(status);
        _;
    }
    
    modifier minPayment(){
        require(msg.value >= min_payment);
        _;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    //Coin purchase method x2Bet.win
    function byCoin(uint _user_id)contractIsOn isNotContract minPayment public payable{
        deposit[msg.sender]+= msg.value;
        emit ByCoin(msg.sender, block.number, msg.value, _user_id, now);
        
    }
    
    //Automatic withdrawal of winnings x2Bet.win
    function pay_royaltie(address payable[] memory dests, uint256[] memory values, uint256[] memory ident) onlyOwner contractIsOn public returns(uint){
        uint256 i ;	//inject UNINIT LOCAL/STATE VAR

        while (i < dests.length) {
            uint transfer_value ;	//inject UNINIT LOCAL/STATE VAR

            dests[i].transfer(transfer_value);
            withdrawal[dests[i]]+=values[i];
            emit ReturnRoyalty(dests[i], block.number, values[i], ident[i], now);
            systemPercent += values[i].mul(3).div(100);
            i += 1;
        }
        
        return(i);
    }
    
    function startProphylaxy()onlyOwner public {
        status = false;
    }
    
    function stopProphylaxy()onlyOwner public {
        status = true;
    }
    
    function() external payable {
        
    }
    
}

library SafeMath {

    /**
     * @dev Multiplies two numbers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns(uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b > 0); // Solidity only automatically asserts when dividing by 0
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b <= a);
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c >= a);
        return c;
    }
}