pragma solidity ^0.5.2;

// File: openzeppelin-solidity\contracts\math\SafeMath.sol

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

// File: contracts\Donations.sol

contract ERC20Interface {
    function balanceOf(address _owner) external returns (uint256);
    function transfer(address _to, uint256 _value) external;
}

contract Donations {
    using SafeMath for uint256;

    struct Knight
    {
        address ethAddress;
        ///@dev amount in % of ETH and HORSE to distribute from this contract
        uint256 equity;
    }

    /// @dev list of all knights by name
    mapping(string => Knight) knights;

    /// @dev handle to access HORSE token contract to make transfers
    ERC20Interface constant horseToken = ERC20Interface(0x5B0751713b2527d7f002c0c4e2a37e1219610A6B);

    ///@dev true for HORSE, false for ETH
    mapping(bool => uint256) private _toDistribute;
    ///@dev true for HORSE, false for ETH
    mapping(bool => mapping(address => uint256)) private _balances;

    /// @dev helpers to make code look better
    bool constant ETH = false;
    bool constant HORSE = true;
   
    /**
        @dev Initialize the contract with the correct knights and their equities and addresses
        All spoils are to be shared by Five Knights, the distribution of which is decided by God almighty
    */
    constructor() public {
        knights["Safir"].equity = 27;
        knights["Safir"].ethAddress = 0x61F646be9E40F3C83Ae6C74e8b33f2708396D08C;
        knights["Lucan"].equity = 27;
        knights["Lucan"].ethAddress = 0x445D779acfE04C717cc6B0071D3713D7E405Dc99;
        knights["Lancelot"].equity = 27;
        knights["Lancelot"].ethAddress = 0x5873d3875274753f6680a2256aCb02F2e42Be1A6;
        knights["Hoel"].equity = 11;
        knights["Hoel"].ethAddress = 0x85a4F876A007649048a7D44470ec1d328895B8bb;
        knights["YwainTheBastard"].equity = 8;
        knights["YwainTheBastard"].ethAddress = 0x2AB8D865Db8b9455F4a77C70B9D8d953E314De28;
    }
    
    /**
        @dev The empty fallback function allows for ETH payments on this contract
    */
    function () external payable {
       //fallback function just accept the funds
    }
    
    /**
        @dev Called by anyone willing to pay the fees for the distribution computation and withdrawal of HIS due
        This checks for changes in the amounts of ETH and HORSE owned by the contract and updates the balances
        of all knights acordingly
    */
    function withdraw() external {
        //update the balances of all knights
        _distribute(ETH);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _distribute(HORSE);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        // check how much the caller is due of HORSE and ETH
        uint256 toSendHORSE = _balances[HORSE][msg.sender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 toSendETH = _balances[ETH][msg.sender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        //if the caller is due HORSE, send it to him
        if(toSendHORSE > 0) {
            _balances[HORSE][msg.sender] = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            horseToken.transfer.gas(40000)(msg.sender,toSendHORSE);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }

        //if the caller is due ETH, send it to him
        if(toSendETH > 0) {
            _balances[ETH][msg.sender] = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            msg.sender.transfer(toSendETH);
        }
    }
    
    /**
        @dev Allows a knight to check the amount of ETH and HORSE he can withdraw
        !!! During withdraw call, the amount is updated before being sent to the knight, so these values may increase
        @return (ETH balance, HORSE balance)
    */
    function checkBalance() external view returns (uint256,uint256) {
        return (_balances[ETH][msg.sender],_balances[HORSE][msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
        @dev Updates the amounts of ETH and HORSE to distribute
        @param isHorse [false => ETH distribution, true => HORSE distribution]
    */
    function _update(bool isHorse) internal {
        //get either ETH or HORSE balance
        uint256 balance = isHorse ? horseToken.balanceOf.gas(40000)(address(this)) : address(this).balance;
        //if there is something on the contract, compute the difference between knight balances and the contract total amount
        if(balance > 0) {
            _toDistribute[isHorse] = balance
            .sub(_balances[isHorse][knights["Safir"].ethAddress])
            .sub(_balances[isHorse][knights["Lucan"].ethAddress])
            .sub(_balances[isHorse][knights["Lancelot"].ethAddress])
            .sub(_balances[isHorse][knights["YwainTheBastard"].ethAddress])
            .sub(_balances[isHorse][knights["Hoel"].ethAddress]);

            //if _toDistribute[isHorse] is 0, then there is nothing to update
        } else {
            //just to make sure, but can be removed
            _toDistribute[isHorse] = 0;
        }
    }
    
    /**
        @dev Handles distribution of non distributed ETH or HORSE
        @param isHorse [false => ETH distribution, true => HORSE distribution]
    */
    function _distribute(bool isHorse) private {
        //check the difference between current balances levels and the contracts levels
        //this will provide the _toDistribute amount
        _update(isHorse);
        //if the contract balance is more than knights balances combined, we need a distribution
        if(_toDistribute[isHorse] > 0) {
            //we divide the amount to distribute by 100 to know how much each % represents
            uint256 parts = _toDistribute[isHorse].div(100);
            //the due of each knight is the % value * equity (27 equity = 27 * 1% => 27% of the amount to distribute)
            uint256 dueSafir = knights["Safir"].equity.mul(parts);
            uint256 dueLucan = knights["Lucan"].equity.mul(parts);
            uint256 dueLancelot = knights["Lancelot"].equity.mul(parts);
            uint256 dueYwainTheBastard = knights["YwainTheBastard"].equity.mul(parts);

            //all balances are augmented by the computed due
            _balances[isHorse][knights["Safir"].ethAddress] = _balances[isHorse][knights["Safir"].ethAddress].add(dueSafir);
            _balances[isHorse][knights["Lucan"].ethAddress] = _balances[isHorse][knights["Lucan"].ethAddress].add(dueLucan);
            _balances[isHorse][knights["Lancelot"].ethAddress] = _balances[isHorse][knights["Lancelot"].ethAddress].add(dueLancelot);
            _balances[isHorse][knights["YwainTheBastard"].ethAddress] = _balances[isHorse][knights["YwainTheBastard"].ethAddress].add(dueYwainTheBastard);
            //the 5th knight due is computed by substraction of the others to avoid dust error due to division
            _balances[isHorse][knights["Hoel"].ethAddress] = _balances[isHorse][knights["Hoel"].ethAddress]
            .add(_toDistribute[isHorse] - dueSafir - dueLucan - dueLancelot - dueYwainTheBastard);
            
            //the amount to distribute is set to zero
            _toDistribute[isHorse] = 0;
        }
    }
}