/**
 *Submitted for verification at Etherscan.io on 2020-09-28
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface Proxy {
  function upgradeTo(address newImplementation) external;
}

contract sbUpgrader {
  event Upgraded(address indexed proxyAddress, address indexed implementationAddress);

  address internal sbTimelock;

  constructor(address sbTimelockAddress) public {
    sbTimelock = sbTimelockAddress;
  }

  function upgrade(address proxyAddress, address implementationAddress) external {
    require(tx.origin == sbTimelock, 'not sbTimelock');	//inject USING TX ORIGIN FOR AUTHENTICATION

    Proxy proxy = Proxy(proxyAddress);
    proxy.upgradeTo(implementationAddress);
    emit Upgraded(proxyAddress, implementationAddress);
  }

  function getSbTimelockAddressUsed() public view returns (address) {
    return sbTimelock;
  }
}