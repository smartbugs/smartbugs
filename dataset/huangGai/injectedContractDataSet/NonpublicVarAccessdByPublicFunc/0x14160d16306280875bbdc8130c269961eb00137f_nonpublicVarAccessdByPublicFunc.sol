/**
 *Submitted for verification at Etherscan.io on 2020-07-21
*/

pragma solidity ^0.5.16;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

interface Gov {
    function setGovernance(address) external;
}

contract TimelockGovernance {
    using SafeMath for uint;

    uint internal period = 17280; // voting period in blocks ~ 17280 3 days for 15s/block
    address internal governance;
    address internal newGovernance;
    uint internal newGovernanceUpdatable;
    address internal target;
    address internal newTargetGovernance;
    uint internal newTargetGovernanceUpdatable;

    constructor(address _multisig, address _target) public {
        governance = _multisig;
        newGovernance = governance;
        target = _target;
        newTargetGovernance = _multisig;
    }
    
    function setThisGovernance(address _governance) external {
        require(governance == msg.sender);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        newGovernanceUpdatable = period.add(block.number);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        newGovernance = _governance;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function updateThisGovernance() external {
        require(newGovernanceUpdatable < block.number, "<block.number");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        governance = newGovernance;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function setTargetGovernance(address _governance) external {
        require(governance == msg.sender);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        newTargetGovernanceUpdatable = period.add(block.number);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        newTargetGovernance = _governance;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function updateTargetGovernance() external {
        require(newTargetGovernanceUpdatable < block.number, "<block.number");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        Gov(target).setGovernance(newTargetGovernance);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}