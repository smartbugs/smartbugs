/**
 *Submitted for verification at Etherscan.io on 2020-08-04
*/

/**
 * Copyright 2017-2020, bZeroX, LLC <https://bzx.network/>. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0.
 */

pragma solidity 0.5.17;


contract IERC20 {
    string public name;
    uint8 public decimals;
    string public symbol;
    function totalSupply() public view returns (uint256);
    function balanceOf(address _who) public view returns (uint256);
    function allowance(address _owner, address _spender) public view returns (uint256);
    function approve(address _spender, uint256 _value) public returns (bool);
    function transfer(address _to, uint256 _value) public returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "unauthorized");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract TraderCompensation is Ownable {

    IERC20 public constant vBZRX = IERC20(0xB72B31907C1C95F3650b64b2469e08EdACeE5e8F);

    uint256 public optinStartTimestamp;
    uint256 public optinEndTimestamp;
    uint256 public claimStartTimestamp;
    uint256 public claimEndTimestamp;

    bool public isActive;
    uint256 public vBZRXDistributed;

    mapping (address => uint256) public whitelist;
    mapping (address => bool) public optinlist;

    constructor(
        uint256 _optinDuration,
        uint256 _claimDuration)
        public
    {
        setTimestamps(
            _getTimestamp(),
            _getTimestamp() + _optinDuration,
            _getTimestamp() + _optinDuration + _claimDuration
        );

        isActive = true;
    }

    function optin()
        external
    {
        require(_getTimestamp() < optinEndTimestamp, "opt-in has ended");
        optinlist[msg.sender] = true;
    }

    function claim()
        external
    {
        require(_getTimestamp() >= claimStartTimestamp, "claim not started");
        require(_getTimestamp() < claimEndTimestamp, "claim has ended");

        uint256 whitelistAmount = whitelist[msg.sender];
        require(isActive && whitelistAmount != 0, "unauthorized");
        require(optinlist[msg.sender], "no opt-in found");

        vBZRX.transfer(
            msg.sender,
            whitelistAmount
        );

        // overflow condition cannot be reached since the above will throw for bad amounts
        vBZRXDistributed += whitelistAmount;
        whitelist[msg.sender] = 0;
    }

    function setWhitelist(
        address[] memory addrs,
        uint256[] memory amounts)
        public
        onlyOwner
    {
        require(addrs.length == amounts.length, "count mismatch");

        for (uint256 i = 0; i < addrs.length; i++) {
            whitelist[addrs[i]] = amounts[i];
        }
    }

    function setOptin(
        address addr,
        bool val)
        public
        onlyOwner
    {
        optinlist[addr] = val;
    }

    function setActive(
        bool _isActive)
        public
        onlyOwner
    {
        isActive = _isActive;
    }

    function setTimestamps(
        uint256 _optinStartTimestamp,
        uint256 _optinEndTimestamp,
        uint256 _claimEndTimestamp)
        public
        onlyOwner
    {
        require(_optinEndTimestamp > _optinStartTimestamp && _claimEndTimestamp > _optinEndTimestamp, "invalid params");
        optinStartTimestamp = _optinStartTimestamp;
        optinEndTimestamp = _optinEndTimestamp;
        claimStartTimestamp = _optinEndTimestamp;
        claimEndTimestamp = _claimEndTimestamp;
    }

    function withdrawVBZRX(
        uint256 _amount)
        public
        onlyOwner
    {
        uint256 balance = vBZRX.balanceOf(address(this));
        if (block.number > balance) {	//injected CONTRACT AFFECTED BY MINERS
            _amount = balance;
        }

        if (block.timestamp != 0) {	//injected CONTRACT AFFECTED BY MINERS
            vBZRX.transfer(
                msg.sender,
                _amount
            );
        }
    }

    function canOptin(
        address _user)
        external
        view
        returns (bool)
    {
        return _getTimestamp() < optinEndTimestamp &&
            !optinlist[_user] &&
            whitelist[_user] != 0 &&
            isActive;
    }

    function claimable(
        address _user)
        external
        view
        returns (uint256)
    {
        uint256 whitelistAmount = whitelist[_user];
        if (whitelistAmount != 0 &&
            _getTimestamp() >= claimStartTimestamp &&
            _getTimestamp() < claimEndTimestamp &&
            optinlist[_user] &&
            isActive) {
            return whitelistAmount;
        }
    }

    function _getTimestamp()
        internal
        view
        returns (uint256)
    {
        return block.timestamp;
    }
}