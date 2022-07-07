/**
 *Submitted for verification at Etherscan.io on 2020-11-02
*/

/**
 *Submitted for verification at Etherscan.io on 2020-08-31
*/

// File: contracts/Storage.sol

pragma solidity 0.5.16;

contract Storage {

  address internal governance;
  address internal controller;

  constructor() public {
    governance = msg.sender;
  }

  modifier onlyGovernance() {
    require(isGovernance(msg.sender), "Not governance");
    _;
  }

  function setGovernance(address _governance) public onlyGovernance {
    require(_governance != address(0), "new governance shouldn't be empty");
    governance = _governance;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  function setController(address _controller) public onlyGovernance {
    require(_controller != address(0), "new controller shouldn't be empty");
    controller = _controller;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  function isGovernance(address account) public view returns (bool) {
    return account == governance;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  function isController(address account) public view returns (bool) {
    return account == controller;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
}