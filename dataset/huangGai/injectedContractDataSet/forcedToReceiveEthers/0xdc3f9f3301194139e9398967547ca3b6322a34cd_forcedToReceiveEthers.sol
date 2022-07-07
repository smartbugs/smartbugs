pragma solidity ^0.5.7;
pragma experimental ABIEncoderV2;

contract IRequireUtils {
    function requireCode(uint256 code) external pure;

    //function interpret(uint256 code) public pure returns (string memory);
}


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


interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowed;

    uint256 private _totalSupply;

    /**
     * @dev Total number of tokens in existence.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param owner The address to query the balance of.
     * @return A uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param owner address The address which owns the funds.
     * @param spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    /**
     * @dev Transfer token to a specified address.
     * @param to The address to transfer to.
     * @param value The amount to be transferred.
     */
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another.
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _transfer(from, to, value);
        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * approve should be called when _allowed[msg.sender][spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    /**
     * @dev Transfer token for a specified addresses.
     * @param from The address to transfer from.
     * @param to The address to transfer to.
     * @param value The amount to be transferred.
     */
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created tokens.
     * @param value The amount that will be created.
     */
    function _mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Approve an address to spend another addresses' tokens.
     * @param owner The address that owns the tokens.
     * @param spender The address that will spend the tokens.
     * @param value The number of tokens that can be spent.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(spender != address(0));
        require(owner != address(0));

        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * Emits an Approval event (reflecting the reduced allowance).
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 value) internal {
        _burn(account, value);
        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
    }
}
contract Coke is ERC20 {
    using SafeMath for uint256;

    IRequireUtils internal rUtils;

    //1 Coke = 10^18 Tin
    string public name = "CB";
    string public symbol = "CB";
    uint256 public decimals = 18; //1:1

    address public cokeAdmin;// admin has rights to mint and burn and etc.
    mapping(address => bool) public gameMachineRecords;// game machine has permission to mint coke

    uint256 public step;
    uint256 public remain;
    uint256 public currentDifficulty;//starts from 0
    uint256 public currentStageEnd;

    address internal team;
    uint256 public teamRemain;
    uint256 public unlockAllBlockNumber;
    //uint256 unlockRate;
    uint256 internal unlockNumerator;
    uint256 internal unlockDenominator;

    event Reward(address indexed account, uint256 amount, uint256 rawAmount);
    event UnlockToTeam(address indexed account, uint256 amount, uint256 rawReward);
    event PermitGameMachine(address indexed gameMachineAddress, bool approved);


    constructor (IRequireUtils _rUtils, address _cokeAdmin, address _team, uint256 _unlockAllBlockNumber, address _bounty) public {
        rUtils = _rUtils;
        cokeAdmin = _cokeAdmin;

        require(_cokeAdmin != address(0));
        require(_team != address(0));
        require(_bounty != address(0));

        unlockAllBlockNumber = _unlockAllBlockNumber;
        uint256 cap = 8000000000000000000000000000;
        team = _team;
        teamRemain = 1600000000000000000000000000;

        _mint(address(this), 1600000000000000000000000000);
        _mint(_bounty, 800000000000000000000000000);

        step = cap.mul(5).div(100);
        remain = cap.sub(teamRemain).sub(800000000000000000000000000);

        _mint(address(this), remain);

        //unlockRate = remain / _toTeam;
        unlockNumerator = 7;
        unlockDenominator = 2;
        if (remain.sub(step) > 0) {
            currentStageEnd = remain.sub(step);
        } else {
            currentStageEnd = 0;
        }
        currentDifficulty = 0;
    }

    //this reward is for mining COKE by playing game using ETH
    function betReward(address _account, uint256 _amount) public mintPermission returns (uint256 minted){
        if (address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
            return 0;
        }

        uint256 input = _amount;
        uint256 totalMint = 0;
        while (input > 0) {

            uint256 factor = 2 ** currentDifficulty;
            uint256 discount = input.div(factor);
            //we ceil it here
            if (input.mod(factor) != 0) {
                discount = discount.add(1);
            }

            if (discount > remain.sub(currentStageEnd)) {
                uint256 toMint = remain.sub(currentStageEnd);
                totalMint = totalMint.add(toMint);
                input = input.sub(toMint.mul(factor));
                //remain = remain.sub(toMint);
                remain = currentStageEnd;
            } else {
                totalMint = totalMint.add(discount);
                input = 0;
                remain = remain.sub(discount);
            }

            //update to next stage
            if (remain <= currentStageEnd) {
                if (currentStageEnd != 0) {
                    currentDifficulty = currentDifficulty.add(1);
                    if (remain.sub(step) > 0) {
                        currentStageEnd = remain.sub(step);
                    } else {
                        currentStageEnd = 0;
                    }
                } else {
                    //all cokes are minted, we can't do any more further
                    //set input to 0 to escape
                    input = 0;
                }
            }
        }
        //_mint(_account, totalMint);
        _transfer(address(this), _account, totalMint);
        emit Reward(_account, totalMint, _amount);

        //uint256 mintToTeam = totalMint / unlockRate;
        uint256 mintToTeam = totalMint.mul(unlockDenominator).div(unlockNumerator);
        if (teamRemain >= mintToTeam) {
            teamRemain = teamRemain.sub(mintToTeam);
            //_mint(team, mintToTeam);
            _transfer(address(this), team, mintToTeam);
            emit UnlockToTeam(team, mintToTeam, totalMint);
        } else {
            mintToTeam = teamRemain;
            teamRemain = 0;
            _transfer(address(this), team, mintToTeam);
            emit UnlockToTeam(team, mintToTeam, totalMint);
        }

        return totalMint;
    }

    function activateGameMachine(address _input) public onlyCokeAdmin {
        gameMachineRecords[_input] = true;
        emit PermitGameMachine(_input, true);
    }

    function deactivateGameMachine(address _input) public onlyCokeAdmin {
        gameMachineRecords[_input] = false;
        emit PermitGameMachine(_input, false);
    }

    function unlockAllTeamCoke() public onlyCokeAdmin {
        if (block.number > unlockAllBlockNumber) {
            _transfer(address(this), team, teamRemain);
            teamRemain = 0;
            emit UnlockToTeam(team, teamRemain, 0);
        }
    }

    modifier onlyCokeAdmin(){
        rUtils.requireCode(msg.sender == cokeAdmin ? 0 : 503);
        _;
    }

    /*modifier burnPermission(){
        rUtils.requireCode(msg.sender == address(lottery) ? 0 : 504);
        _;
    }*/

    modifier mintPermission(){
        rUtils.requireCode(gameMachineRecords[msg.sender] == true ? 0 : 505);
        _;
    }
}