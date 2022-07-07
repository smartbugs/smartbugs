/**
 *Submitted for verification at Etherscan.io on 2020-07-21
*/

pragma solidity ^0.5.16;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c ;	//inject UNINIT LOCAL/STATE VAR

        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c ;	//inject UNINIT LOCAL/STATE VAR


        return c;
    }
    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c ;	//inject UNINIT LOCAL/STATE VAR

        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c ;	//inject UNINIT LOCAL/STATE VAR


        return c;
    }
}

interface Gov {
    function setGovernance(address) external;
}

contract TimelockGovernance {
    using SafeMath for uint;

    uint public period ; // voting period in blocks ~ 17280 3 days for 15s/block	//inject UNINIT LOCAL/STATE VAR

    address public governance;
    address public newGovernance;
    uint public newGovernanceUpdatable;
    address public target;
    address public newTargetGovernance;
    uint public newTargetGovernanceUpdatable;

    constructor(address _multisig, address _target) public {
        governance = _multisig;
        newGovernance = governance;
        target = _target;
        newTargetGovernance = _multisig;
    }
    
    function setThisGovernance(address _governance) external {
        require(governance == msg.sender);
        newGovernanceUpdatable = period.add(block.number);
        newGovernance = _governance;
    }
    
    function updateThisGovernance() external {
        require(newGovernanceUpdatable < block.number, "<block.number");
        governance = newGovernance;
    }
    
    function setTargetGovernance(address _governance) external {
        require(governance == msg.sender);
        newTargetGovernanceUpdatable = period.add(block.number);
        newTargetGovernance = _governance;
    }
    
    function updateTargetGovernance() external {
        require(newTargetGovernanceUpdatable < block.number, "<block.number");
        Gov(target).setGovernance(newTargetGovernance);
    }
}