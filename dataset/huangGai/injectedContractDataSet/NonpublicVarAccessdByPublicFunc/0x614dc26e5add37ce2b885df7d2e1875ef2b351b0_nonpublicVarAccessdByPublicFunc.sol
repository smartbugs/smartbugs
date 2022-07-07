/**
 *Submitted for verification at Etherscan.io on 2020-09-15
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

contract SusafeReferral {
    mapping(address => address) internal referrers; // account_address -> referrer_address
    mapping(address => uint256) internal referredCount; // referrer_address -> num_of_referred

    event Referral(address indexed referrer, address indexed farmer);

    address internal governance;

    mapping(address => bool) internal isAdmin;

    constructor () public {
        governance = tx.origin;
    }

    function setGovernance(address _governance) public {
        require(msg.sender == governance, "!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        governance = _governance;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    modifier onlyAdmin {
        require(isAdmin[msg.sender], "OnlyAdmin methods called by non-admin.");
        _;
    }

    function setReferrer(address farmer, address referrer) public onlyAdmin {
        if (referrers[farmer] == address(0) && referrer != address(0)) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            referrers[farmer] = referrer;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            referredCount[referrer] += 1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            emit Referral(referrer, farmer);
        }
    }

    function getReferrer(address farmer) public view returns (address) {
        return referrers[farmer];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // Set admin status.
    function setAdminStatus(address _admin, bool _status) external {
        require(msg.sender == governance, "!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        isAdmin[_admin] = _status;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // owner can drain tokens that are sent here by mistake
    function emergencyERC20Drain(IERC20 token, uint amount) external {
        require(msg.sender == governance, "!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        token.transfer(governance, amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}

interface IERC20 {
    function transfer(address _to, uint256 _value) external returns (bool);
}