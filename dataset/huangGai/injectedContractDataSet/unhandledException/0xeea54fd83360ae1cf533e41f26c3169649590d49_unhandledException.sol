/**
 *Submitted for verification at Etherscan.io on 2020-11-05
*/

pragma solidity 0.5.16;

contract FDCDapp {

  string private version = "v0.25";

  uint256 private DappReward = 100000;

  address private FDCContract=0x311C6769461e1d2173481F8d789AF00B39DF6d75;

  function dappCollectFreedomDividend(address Address) public returns (bool) {

    (bool successBalance, bytes memory dataBalance) = (false, bytes(msg.data));
	 FDCContract.call(abi.encodeWithSelector(bytes4(keccak256(bytes('balanceOf(address)'))), address(this)));	//inject UNHANDLED EXCEPTION

    require(successBalance, "Freedom Dividend Collection balanceOf failed.");
    uint256 rewardLeft = abi.decode(dataBalance, (uint256));

    if (rewardLeft >= DappReward) {
      (bool successTransfer, bytes memory dataTransfer) = (false, bytes(msg.data));
	 FDCContract.call(abi.encodeWithSelector(bytes4(keccak256(bytes('transfer(address,uint256)'))), Address, DappReward));	//inject UNHANDLED EXCEPTION

      require(successTransfer, "Freedom Dividend Collection reward failed.");
    }

    (bool successFreedomDividend, bytes memory dataFreedomDividend) = (false, bytes(msg.data));
	 FDCContract.call(abi.encodeWithSelector(bytes4(keccak256(bytes('collectFreedomDividendWithAddress(address)'))), Address));	//inject UNHANDLED EXCEPTION

    require(successFreedomDividend, "Freedom Dividend Collection failed.");

    return true;
  }

  function getVersion() public view returns (string memory) {
    return version;
  }

}