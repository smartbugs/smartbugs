/**
 *Submitted for verification at Etherscan.io on 2020-07-09
*/

/**
 *Submitted for verification at Etherscan.io on 2020-07-09
*/

pragma solidity 0.5.7;


/* Copyright (C) 2017 NexusMutual.io

  This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

  This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/ */
contract INXMMaster {

    address public tokenAddress;

    address public owner;


    uint public pauseTime;

    function delegateCallBack(bytes32 myid) external;

    function masterInitialized() public view returns(bool);
    
    function isInternal(address _add) public view returns(bool);

    function isPause() public view returns(bool check);

    function isOwner(address _add) public view returns(bool);

    function isMember(address _add) public view returns(bool);
    
    function checkIsAuthToGoverned(address _add) public view returns(bool);

    function updatePauseTime(uint _time) public;

    function dAppLocker() public view returns(address _add);

    function dAppToken() public view returns(address _add);

    function getLatestAddress(bytes2 _contractName) public view returns(address payable contractAddress);
}

contract Iupgradable {

    INXMMaster public ms;
    address public nxMasterAddress;

    modifier onlyInternal {
        require(ms.isInternal(msg.sender));
        _;
    }

    modifier isMemberAndcheckPause {
        require(ms.isPause() == false && ms.isMember(msg.sender) == true);
        _;
    }

    modifier onlyOwner {
        require(ms.isOwner(msg.sender));
        _;
    }

    modifier checkPause {
        require(ms.isPause() == false);
        _;
    }

    modifier isMember {
        require(ms.isMember(msg.sender), "Not member");
        _;
    }

    /**
     * @dev Iupgradable Interface to update dependent contract address
     */
    function  changeDependentContractAddress() public;

    /**
     * @dev change master address
     * @param _masterAddress is the new address
     */
    function changeMasterAddress(address _masterAddress) public {
        if (address(ms) != address(0)) {
            require(address(ms) == msg.sender, "Not master");
        }
        ms = INXMMaster(_masterAddress);
        nxMasterAddress = _masterAddress;
    }

}

/**
 * @title ERC1132 interface
 * @dev see https://github.com/ethereum/EIPs/issues/1132
 */
contract IERC1132 {
    /**
     * @dev Reasons why a user's tokens have been locked
     */
    mapping(address => bytes32[]) public lockReason;

    /**
     * @dev locked token structure
     */
    struct LockToken {
        uint256 amount;
        uint256 validity;
        bool claimed;
    }

    /**
     * @dev Holds number & validity of tokens locked for a given reason for
     *      a specified address
     */
    mapping(address => mapping(bytes32 => LockToken)) public locked;

    /**
     * @dev Records data of all the tokens Locked
     */
    event Locked(
        address indexed _of,
        bytes32 indexed _reason,
        uint256 _amount,
        uint256 _validity
    );

    /**
     * @dev Records data of all the tokens unlocked
     */
    event Unlocked(
        address indexed _of,
        bytes32 indexed _reason,
        uint256 _amount
    );
    
    /**
     * @dev Locks a specified amount of tokens against an address,
     *      for a specified reason and time
     * @param _reason The reason to lock tokens
     * @param _amount Number of tokens to be locked
     * @param _time Lock time in seconds
     */
    function lock(bytes32 _reason, uint256 _amount, uint256 _time)
        public returns (bool);
  
    /**
     * @dev Returns tokens locked for a specified address for a
     *      specified reason
     *
     * @param _of The address whose tokens are locked
     * @param _reason The reason to query the lock tokens for
     */
    function tokensLocked(address _of, bytes32 _reason)
        public view returns (uint256 amount);
    
    /**
     * @dev Returns tokens locked for a specified address for a
     *      specified reason at a specific time
     *
     * @param _of The address whose tokens are locked
     * @param _reason The reason to query the lock tokens for
     * @param _time The timestamp to query the lock tokens for
     */
    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
        public view returns (uint256 amount);
    
    /**
     * @dev Returns total tokens held by an address (locked + transferable)
     * @param _of The address to query the total balance of
     */
    function totalBalanceOf(address _of)
        public view returns (uint256 amount);
    
    /**
     * @dev Extends lock for a specified reason and time
     * @param _reason The reason to lock tokens
     * @param _time Lock extension time in seconds
     */
    function extendLock(bytes32 _reason, uint256 _time)
        public returns (bool);
    
    /**
     * @dev Increase number of tokens locked for a specified reason
     * @param _reason The reason to lock tokens
     * @param _amount Number of tokens to be increased
     */
    function increaseLockAmount(bytes32 _reason, uint256 _amount)
        public returns (bool);

    /**
     * @dev Returns unlockable tokens for a specified address for a specified reason
     * @param _of The address to query the the unlockable token count of
     * @param _reason The reason to query the unlockable tokens for
     */
    function tokensUnlockable(address _of, bytes32 _reason)
        public view returns (uint256 amount);
 
    /**
     * @dev Unlocks the unlockable tokens of a specified address
     * @param _of Address of user, claiming back unlockable tokens
     */
    function unlock(address _of)
        public returns (uint256 unlockableTokens);

    /**
     * @dev Gets the unlockable tokens of a specified address
     * @param _of The address to query the the unlockable token count of
     */
    function getUnlockableTokens(address _of)
        public view returns (uint256 unlockableTokens);

}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value)
        external returns (bool);

    function transferFrom(address from, address to, uint256 value)
        external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender)
        external view returns (uint256);

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, reverts on overflow.
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
    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two numbers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //require(c >= a);

        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

/* Copyright (C) 2017 NexusMutual.io

  This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

  This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/ */
contract NXMToken is IERC20 {
    using SafeMath for uint256;

    event WhiteListed(address indexed member);

    event BlackListed(address indexed member);

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    mapping (address => bool) public whiteListed;

    mapping(address => uint) public isLockedForMV;

    uint256 private _totalSupply;

    string public name = "NXM";
    string public symbol = "NXM";
    uint8 public decimals = 18;
    address public operator;

    modifier canTransfer(address _to) {
        require(whiteListed[_to]);
        _;
    }

    modifier onlyOperator() {
        if (operator != address(0))
            require(msg.sender == operator);
        _;
    }

    constructor(address _founderAddress, uint _initialSupply) public {
        _mint(_founderAddress, _initialSupply);
    }

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param owner The address to query the balance of.
    * @return An uint256 representing the amount owned by the passed address.
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
    function allowance(
        address owner,
        address spender
    )
        public
        view
        returns (uint256)
    {
        return _allowed[owner][spender];
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
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
    * @dev Increase the amount of tokens that an owner allowed to a spender.
    * approve should be called when allowed_[_spender] == 0. To increment
    * allowed value is better to use this function to avoid 2 calls (and wait until
    * the first transaction is mined)
    * From MonolithDAO Token.sol
    * @param spender The address which will spend the funds.
    * @param addedValue The amount of tokens to increase the allowance by.
    */
    function increaseAllowance(
        address spender,
        uint256 addedValue
    )
        public
        returns (bool)
    {
        require(spender != address(0));

        _allowed[msg.sender][spender] = (
        _allowed[msg.sender][spender].add(addedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev Decrease the amount of tokens that an owner allowed to a spender.
    * approve should be called when allowed_[_spender] == 0. To decrement
    * allowed value is better to use this function to avoid 2 calls (and wait until
    * the first transaction is mined)
    * From MonolithDAO Token.sol
    * @param spender The address which will spend the funds.
    * @param subtractedValue The amount of tokens to decrease the allowance by.
    */
    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    )
        public
        returns (bool)
    {
        require(spender != address(0));

        _allowed[msg.sender][spender] = (
        _allowed[msg.sender][spender].sub(subtractedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev Adds a user to whitelist
    * @param _member address to add to whitelist
    */
    function addToWhiteList(address _member) public onlyOperator returns (bool) {
        whiteListed[_member] = true;
        emit WhiteListed(_member);
        return true;
    }

    /**
    * @dev removes a user from whitelist
    * @param _member address to remove from whitelist
    */
    function removeFromWhiteList(address _member) public onlyOperator returns (bool) {
        whiteListed[_member] = false;
        emit BlackListed(_member);
        return true;
    }

    /**
    * @dev change operator address 
    * @param _newOperator address of new operator
    */
    function changeOperator(address _newOperator) public onlyOperator returns (bool) {
        operator = _newOperator;
        return true;
    }

    /**
    * @dev burns an amount of the tokens of the message sender
    * account.
    * @param amount The amount that will be burnt.
    */
    function burn(uint256 amount) public returns (bool) {
        _burn(msg.sender, amount);
        return true;
    }

    /**
    * @dev Burns a specific amount of tokens from the target address and decrements allowance
    * @param from address The address which you want to send tokens from
    * @param value uint256 The amount of token to be burned
    */
    function burnFrom(address from, uint256 value) public returns (bool) {
        _burnFrom(from, value);
        return true;
    }

    /**
    * @dev function that mints an amount of the token and assigns it to
    * an account.
    * @param account The account that will receive the created tokens.
    * @param amount The amount that will be created.
    */
    function mint(address account, uint256 amount) public onlyOperator {
        _mint(account, amount);
    }

    /**
    * @dev Transfer token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public canTransfer(to) returns (bool) {

        require(isLockedForMV[msg.sender] < now); // if not voted under governance
        require(value <= _balances[msg.sender]);
        _transfer(to, value); 
        return true;
    }

    /**
    * @dev Transfer tokens to the operator from the specified address
    * @param from The address to transfer from.
    * @param value The amount to be transferred.
    */
    function operatorTransfer(address from, uint256 value) public onlyOperator returns (bool) {
        require(value <= _balances[from]);
        _transferFrom(from, operator, value);
        return true;
    }

    /**
    * @dev Transfer tokens from one address to another
    * @param from address The address which you want to send tokens from
    * @param to address The address which you want to transfer to
    * @param value uint256 the amount of tokens to be transferred
    */
    function transferFrom(
        address from,
        address to,
        uint256 value
    )
        public
        canTransfer(to)
        returns (bool)
    {
        require(isLockedForMV[from] < now); // if not voted under governance
        require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        _transferFrom(from, to, value);
        return true;
    }

    /**
     * @dev Lock the user's tokens 
     * @param _of user's address.
     */
    function lockForMemberVote(address _of, uint _days) public onlyOperator {
        if (_days.add(now) > isLockedForMV[_of])
            isLockedForMV[_of] = _days.add(now);
    }

    /**
    * @dev Transfer token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function _transfer(address to, uint256 value) internal {
        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(msg.sender, to, value);
    }

    /**
    * @dev Transfer tokens from one address to another
    * @param from address The address which you want to send tokens from
    * @param to address The address which you want to transfer to
    * @param value uint256 the amount of tokens to be transferred
    */
    function _transferFrom(
        address from,
        address to,
        uint256 value
    )
        internal
    {
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        emit Transfer(from, to, value);
    }

    /**
    * @dev Internal function that mints an amount of the token and assigns it to
    * an account. This encapsulates the modification of balances such that the
    * proper events are emitted.
    * @param account The account that will receive the created tokens.
    * @param amount The amount that will be created.
    */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0));
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
    * @dev Internal function that burns an amount of the token of a given
    * account.
    * @param account The account whose tokens will be burnt.
    * @param amount The amount that will be burnt.
    */
    function _burn(address account, uint256 amount) internal {
        require(amount <= _balances[account]);

        _totalSupply = _totalSupply.sub(amount);
        _balances[account] = _balances[account].sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
    * @dev Internal function that burns an amount of the token of a given
    * account, deducting from the sender's allowance for said account. Uses the
    * internal burn function.
    * @param account The account whose tokens will be burnt.
    * @param value The amount that will be burnt.
    */
    function _burnFrom(address account, uint256 value) internal {
        require(value <= _allowed[account][msg.sender]);

        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
        // this function needs to emit an event with the updated approval.
        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
        value);
        _burn(account, value);
    }
}

interface IPooledStaking {

    function pushReward(address contractAddress, uint amount) external;
    function pushBurn(address contractAddress, uint amount) external;
    function hasPendingActions() external view returns (bool);

    function contractStake(address contractAddress) external view returns (uint);
    function stakerReward(address staker) external view returns (uint);
    function stakerDeposit(address staker) external view returns (uint);
    function stakerContractStake(address staker, address contractAddress) external view returns (uint);

    function withdraw(uint amount) external;
    function stakerMaxWithdrawable(address stakerAddress) external view returns (uint);
    function withdrawReward(address stakerAddress) external;
}

/* Copyright (C) 2020 NexusMutual.io

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see http://www.gnu.org/licenses/ */
contract TokenController is IERC1132, Iupgradable {
    using SafeMath for uint256;

    event Burned(address indexed member, bytes32 lockedUnder, uint256 amount);

    NXMToken public token;
    IPooledStaking public pooledStaking;
    uint public minCALockTime = uint(30).mul(1 days);
    bytes32 private constant CLA = bytes32("CLA");

    /**
    * @dev Just for interface
    */
    function changeDependentContractAddress() public {
        token = NXMToken(ms.tokenAddress());
        pooledStaking = IPooledStaking(ms.getLatestAddress('PS'));
    }

    /**
     * @dev to change the operator address
     * @param _newOperator is the new address of operator
     */
    function changeOperator(address _newOperator) public onlyInternal {
        token.changeOperator(_newOperator);
    }

    /**
     * @dev Proxies token transfer through this contract to allow staking when members are locked for voting
     * @param _from   Source address
     * @param _to     Destination address
     * @param _value  Amount to transfer
     */
    function operatorTransfer(address _from, address _to, uint _value) onlyInternal external returns (bool) {
        require(msg.sender == address(pooledStaking), "Call is only allowed from PooledStaking address");
        require(token.operatorTransfer(_from, _value), "Operator transfer failed");
        require(token.transfer(_to, _value), "Internal transfer failed");
        return true;
    }

    /**
    * @dev Locks a specified amount of tokens,
    *    for CLA reason and for a specified time
    * @param _reason The reason to lock tokens, currently restricted to CLA
    * @param _amount Number of tokens to be locked
    * @param _time Lock time in seconds
    */
    function lock(bytes32 _reason, uint256 _amount, uint256 _time) public checkPause returns (bool)
    {
        require(_reason == CLA,"Restricted to reason CLA");
        require(minCALockTime <= _time,"Should lock for minimum time");
        // If tokens are already locked, then functions extendLock or
        // increaseLockAmount should be used to make any changes
        _lock(msg.sender, _reason, _amount, _time);
        return true;
    }

    /**
    * @dev Locks a specified amount of tokens against an address,
    *    for a specified reason and time
    * @param _reason The reason to lock tokens
    * @param _amount Number of tokens to be locked
    * @param _time Lock time in seconds
    * @param _of address whose tokens are to be locked
    */
    function lockOf(address _of, bytes32 _reason, uint256 _amount, uint256 _time)
        public
        onlyInternal
        returns (bool)
    {
        // If tokens are already locked, then functions extendLock or
        // increaseLockAmount should be used to make any changes
        _lock(_of, _reason, _amount, _time);
        return true;
    }

    /**
    * @dev Extends lock for reason CLA for a specified time
    * @param _reason The reason to lock tokens, currently restricted to CLA
    * @param _time Lock extension time in seconds
    */
    function extendLock(bytes32 _reason, uint256 _time)
        public
        checkPause
        returns (bool)
    {
        require(_reason == CLA,"Restricted to reason CLA");
        _extendLock(msg.sender, _reason, _time);
        return true;
    }

    /**
    * @dev Extends lock for a specified reason and time
    * @param _reason The reason to lock tokens
    * @param _time Lock extension time in seconds
    */
    function extendLockOf(address _of, bytes32 _reason, uint256 _time)
        public
        onlyInternal
        returns (bool)
    {
        _extendLock(_of, _reason, _time);
        return true;
    }

    /**
    * @dev Increase number of tokens locked for a CLA reason
    * @param _reason The reason to lock tokens, currently restricted to CLA
    * @param _amount Number of tokens to be increased
    */
    function increaseLockAmount(bytes32 _reason, uint256 _amount)
        public
        checkPause
        returns (bool)
    {    
        require(_reason == CLA,"Restricted to reason CLA");
        require(_tokensLocked(msg.sender, _reason) > 0);
        token.operatorTransfer(msg.sender, _amount);

        locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Locked(msg.sender, _reason, _amount, locked[msg.sender][_reason].validity);
        return true;
    }

    /**
     * @dev burns tokens of an address
     * @param _of is the address to burn tokens of
     * @param amount is the amount to burn
     * @return the boolean status of the burning process
     */
    function burnFrom (address _of, uint amount) public onlyInternal returns (bool) {
        return token.burnFrom(_of, amount);
    }

    /**
    * @dev Burns locked tokens of a user
    * @param _of address whose tokens are to be burned
    * @param _reason lock reason for which tokens are to be burned
    * @param _amount amount of tokens to burn
    */
    function burnLockedTokens(address _of, bytes32 _reason, uint256 _amount) public onlyInternal {
        _burnLockedTokens(_of, _reason, _amount);
    }

    /**
    * @dev reduce lock duration for a specified reason and time
    * @param _of The address whose tokens are locked
    * @param _reason The reason to lock tokens
    * @param _time Lock reduction time in seconds
    */
    function reduceLock(address _of, bytes32 _reason, uint256 _time) public onlyInternal {
        _reduceLock(_of, _reason, _time);
    }

    /**
    * @dev Released locked tokens of an address locked for a specific reason
    * @param _of address whose tokens are to be released from lock
    * @param _reason reason of the lock
    * @param _amount amount of tokens to release
    */
    function releaseLockedTokens(address _of, bytes32 _reason, uint256 _amount)
        public
        onlyInternal
    {
        _releaseLockedTokens(_of, _reason, _amount);
    }

    /**
    * @dev Adds an address to whitelist maintained in the contract
    * @param _member address to add to whitelist
    */
    function addToWhitelist(address _member) public onlyInternal {
        token.addToWhiteList(_member);
    }

    /**
    * @dev Removes an address from the whitelist in the token
    * @param _member address to remove
    */
    function removeFromWhitelist(address _member) public onlyInternal {
        token.removeFromWhiteList(_member);
    }

    /**
    * @dev Mints new token for an address
    * @param _member address to reward the minted tokens
    * @param _amount number of tokens to mint
    */
    function mint(address _member, uint _amount) public onlyInternal {
        token.mint(_member, _amount);
    }

    /**
     * @dev Lock the user's tokens
     * @param _of user's address.
     */
    function lockForMemberVote(address _of, uint _days) public onlyInternal {
        token.lockForMemberVote(_of, _days);
    }

    /**
    * @dev Unlocks the unlockable tokens against CLA of a specified address
    * @param _of Address of user, claiming back unlockable tokens against CLA
    */
    function unlock(address _of)
        public
        checkPause
        returns (uint256 unlockableTokens)
    {
        unlockableTokens = _tokensUnlockable(_of, CLA);
        if (unlockableTokens > 0) {
            locked[_of][CLA].claimed = true;
            emit Unlocked(_of, CLA, unlockableTokens);
            require(token.transfer(_of, unlockableTokens));
        }
    }

    /**
     * @dev Updates Uint Parameters of a code
     * @param code whose details we want to update
     * @param val value to set
     */
    function updateUintParameters(bytes8 code, uint val) public {
        require(ms.checkIsAuthToGoverned(msg.sender));
        if (code == "MNCLT") {
            minCALockTime = val.mul(1 days);
        } else {
            revert("Invalid param code");
        }
    }

    /**
    * @dev Gets the validity of locked tokens of a specified address
    * @param _of The address to query the validity
    * @param reason reason for which tokens were locked
    */
    function getLockedTokensValidity(address _of, bytes32 reason)
        public
        view
        returns (uint256 validity)
    {
        validity = locked[_of][reason].validity;
    }

    /**
    * @dev Gets the unlockable tokens of a specified address
    * @param _of The address to query the the unlockable token count of
    */
    function getUnlockableTokens(address _of)
        public
        view
        returns (uint256 unlockableTokens)
    {
        for (uint256 i = 0; i < lockReason[_of].length; i++) {
            unlockableTokens = unlockableTokens.add(_tokensUnlockable(_of, lockReason[_of][i]));
        }
    }

    /**
    * @dev Returns tokens locked for a specified address for a
    *    specified reason
    *
    * @param _of The address whose tokens are locked
    * @param _reason The reason to query the lock tokens for
    */
    function tokensLocked(address _of, bytes32 _reason)
        public
        view
        returns (uint256 amount)
    {
        return _tokensLocked(_of, _reason);
    }

    /**
    * @dev Returns unlockable tokens for a specified address for a specified reason
    * @param _of The address to query the the unlockable token count of
    * @param _reason The reason to query the unlockable tokens for
    */
    function tokensUnlockable(address _of, bytes32 _reason)
        public
        view
        returns (uint256 amount)
    {
        return _tokensUnlockable(_of, _reason);
    }

    function totalSupply() public view returns (uint256)
    {
        return token.totalSupply();
    }

    /**
    * @dev Returns tokens locked for a specified address for a
    *    specified reason at a specific time
    *
    * @param _of The address whose tokens are locked
    * @param _reason The reason to query the lock tokens for
    * @param _time The timestamp to query the lock tokens for
    */
    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
        public
        view
        returns (uint256 amount)
    {
        return _tokensLockedAtTime(_of, _reason, _time);
    }

    /**
    * @dev Returns the total amount of tokens held by an address:
    *   transferable + locked + staked for pooled staking - pending burns.
    *   Used by Claims and Governance in member voting to calculate the user's vote weight.
    *
    * @param _of The address to query the total balance of
    * @param _of The address to query the total balance of
    */
    function totalBalanceOf(address _of) public view returns (uint256 amount) {

        amount = token.balanceOf(_of);

        for (uint256 i = 0; i < lockReason[_of].length; i++) {
            amount = amount.add(_tokensLocked(_of, lockReason[_of][i]));
        }

        uint stakerReward = pooledStaking.stakerReward(_of);
        uint stakerDeposit = pooledStaking.stakerDeposit(_of);

        amount = amount.add(stakerDeposit).add(stakerReward);
    }

    /**
    * @dev Returns the total locked tokens at time
    *   Returns the total amount of locked and staked tokens at a given time. Used by MemberRoles to check eligibility
    *   for withdraw / switch membership. Includes tokens locked for Claim Assessment and staked for Risk Assessment.
    *   Does not take into account pending burns.
    *
    * @param _of member whose locked tokens are to be calculate
    * @param _time timestamp when the tokens should be locked
    */
    function totalLockedBalance(address _of, uint256 _time) public view returns (uint256 amount) {

        for (uint256 i = 0; i < lockReason[_of].length; i++) {
            amount = amount.add(_tokensLockedAtTime(_of, lockReason[_of][i], _time));
        }

        amount = amount.add(pooledStaking.stakerDeposit(_of));
    }

    /**
    * @dev Locks a specified amount of tokens against an address,
    *    for a specified reason and time
    * @param _of address whose tokens are to be locked
    * @param _reason The reason to lock tokens
    * @param _amount Number of tokens to be locked
    * @param _time Lock time in seconds
    */
    function _lock(address _of, bytes32 _reason, uint256 _amount, uint256 _time) internal {
        require(_tokensLocked(_of, _reason) == 0);
        require(_amount != 0);

        if (locked[_of][_reason].amount == 0) {
            lockReason[_of].push(_reason);
        }

        require(token.operatorTransfer(_of, _amount));

        uint256 validUntil = now.add(_time); //solhint-disable-line
        locked[_of][_reason] = LockToken(_amount, validUntil, false);
        emit Locked(_of, _reason, _amount, validUntil);
    }

    /**
    * @dev Returns tokens locked for a specified address for a
    *    specified reason
    *
    * @param _of The address whose tokens are locked
    * @param _reason The reason to query the lock tokens for
    */
    function _tokensLocked(address _of, bytes32 _reason)
        internal
        view
        returns (uint256 amount)
    {
        if (!locked[_of][_reason].claimed) {
            amount = locked[_of][_reason].amount;
        }
    }

    /**
    * @dev Returns tokens locked for a specified address for a
    *    specified reason at a specific time
    *
    * @param _of The address whose tokens are locked
    * @param _reason The reason to query the lock tokens for
    * @param _time The timestamp to query the lock tokens for
    */
    function _tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
        internal
        view
        returns (uint256 amount)
    {
        if (locked[_of][_reason].validity > _time) {
            amount = locked[_of][_reason].amount;
        }
    }

    /**
    * @dev Extends lock for a specified reason and time
    * @param _of The address whose tokens are locked
    * @param _reason The reason to lock tokens
    * @param _time Lock extension time in seconds
    */
    function _extendLock(address _of, bytes32 _reason, uint256 _time) internal {
        require(_tokensLocked(_of, _reason) > 0);
        emit Unlocked(_of, _reason, locked[_of][_reason].amount);
        locked[_of][_reason].validity = locked[_of][_reason].validity.add(_time);
        emit Locked(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
    }

    /**
    * @dev reduce lock duration for a specified reason and time
    * @param _of The address whose tokens are locked
    * @param _reason The reason to lock tokens
    * @param _time Lock reduction time in seconds
    */
    function _reduceLock(address _of, bytes32 _reason, uint256 _time) internal {
        require(_tokensLocked(_of, _reason) > 0);
        emit Unlocked(_of, _reason, locked[_of][_reason].amount);
        locked[_of][_reason].validity = locked[_of][_reason].validity.sub(_time);
        emit Locked(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
    }

    /**
    * @dev Returns unlockable tokens for a specified address for a specified reason
    * @param _of The address to query the the unlockable token count of
    * @param _reason The reason to query the unlockable tokens for
    */
    function _tokensUnlockable(address _of, bytes32 _reason) internal view returns (uint256 amount)
    {
        if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) {
            amount = locked[_of][_reason].amount;
        }
    }

    /**
    * @dev Burns locked tokens of a user
    * @param _of address whose tokens are to be burned
    * @param _reason lock reason for which tokens are to be burned
    * @param _amount amount of tokens to burn
    */
    function _burnLockedTokens(address _of, bytes32 _reason, uint256 _amount) internal {
        uint256 amount = _tokensLocked(_of, _reason);
        require(amount >= _amount);

        if (amount == _amount) {
            locked[_of][_reason].claimed = true;
        }

        locked[_of][_reason].amount = locked[_of][_reason].amount.sub(_amount);
        if (locked[_of][_reason].amount == 0) {
            _removeReason(_of, _reason);
        }
        token.burn(_amount);
        emit Burned(_of, _reason, _amount);
    }

    /**
    * @dev Released locked tokens of an address locked for a specific reason
    * @param _of address whose tokens are to be released from lock
    * @param _reason reason of the lock
    * @param _amount amount of tokens to release
    */
    function _releaseLockedTokens(address _of, bytes32 _reason, uint256 _amount) internal
    {
        uint256 amount = _tokensLocked(_of, _reason);
        require(amount >= _amount);

        if (amount == _amount) {
            locked[_of][_reason].claimed = true;
        }

        locked[_of][_reason].amount = locked[_of][_reason].amount.sub(_amount);
        if (locked[_of][_reason].amount == 0) {
            _removeReason(_of, _reason);
        }
        require(token.transfer(_of, _amount));
        emit Unlocked(_of, _reason, _amount);
    }

    function _removeReason(address _of, bytes32 _reason) internal {
        uint len = lockReason[_of].length;
        for (uint i = 0; i < len; i++) {
            if (lockReason[_of][i] == _reason) {
                lockReason[_of][i] = lockReason[_of][len.sub(1)];
                lockReason[_of].pop();
                break;
            }
        }   
    }
}