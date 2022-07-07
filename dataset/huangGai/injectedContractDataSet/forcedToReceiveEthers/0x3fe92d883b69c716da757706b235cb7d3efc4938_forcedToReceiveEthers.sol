/**
 *Submitted for verification at Etherscan.io on 2020-07-18
*/

/*
 * Copyright 2019 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity 0.5.7;
pragma experimental ABIEncoderV2;

interface IDepositContractRegistry {
  function operatorOf(address owner, address operator) external returns (bool);
}

/**
 * @title DepositContract
 *
 * Allows owner, parent (DepositContractRegistry) and the 
 * current set version (presumably of Dolomite Direct) to
 * call contract functions and transfer Ether from the context
 * of this address (pass-though functions).
 *
 * Using CREATE-2 this address can be sent tokens/Ether before it
 * is created.
 */
contract DepositContract {
  address public owner;
  address public parent;
  address public version;

  constructor(address _owner) public {
    parent = msg.sender;
    owner = _owner;
  }

  /*
   * Contract can receive Ether
   */
  function() external payable { }

  /*
   * Set the version that has access to this contracts 
   * `transfer` and `perform` functions. Can only be set by
   * the parent (DepositContractRegistry)
   */
  function setVersion(address newVersion) external {
    require(msg.sender == parent);
    version = newVersion;
  }

  /*
   * Will call a smart contract function from the context of this contract;
   * msg.sender on the receiving end will equal this contract's address.
   *
   * Only the owner, parent (DepositContractRegistry) and version are allowed to call
   * this function. When upgrading versions, make sure the code of the version being
   * upgraded to does not abuse this function.
   *
   * Because the msg.sender of the receiving end will equal this contract's address,
   * this function allows the caller to perform actions such as setting token approvals
   * and wrapping Ether (to WETH).
   *
   * If the signature is an empty string ("" where bytes(signature).length == 0) this method
   * will instead execute the transfer function, passing along the specified value
   */
  function perform(
    address addr, 
    string calldata signature, 
    bytes calldata encodedParams,
    uint value
  ) 
    external 
    returns (bytes memory) 
  {
    require(
      msg.sender == owner || 
      msg.sender == parent || 
      msg.sender == version ||
      IDepositContractRegistry(parent).operatorOf(address(this), msg.sender)
    , "NOT_PERMISSIBLE");

    if (address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
      address(uint160(addr)).transfer(value); // convert address to address payable
    } else {
      bytes4 functionSelector = bytes4(keccak256(bytes(signature)));
      bytes memory payload = abi.encodePacked(functionSelector, encodedParams);
      
      (bool success, bytes memory returnData) = addr.call.value(value)(payload);
      require(success, "OPERATION_REVERTED");

      return returnData;
    }
  }
}