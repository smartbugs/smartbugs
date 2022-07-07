/**
 *Submitted for verification at Etherscan.io on 2020-06-18
*/

// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity =0.6.6;

interface IPermitAndCall {
  function permitAndCall(
    address token,
    uint value,
    bytes4 permitSelector,
    bytes calldata permitData,
    bytes4 routerFunctionSelector,
    bytes calldata routerFunctionData
  )
    external;
}

interface IUniswapV2Router02 {
  function WETH() external pure returns (address); 
}

interface IERC20 {
  function allowance(address owner, address spender) external view returns (uint);
}

contract PermitAndCall is IPermitAndCall {
  address public immutable router;
  address public immutable WETH;

  constructor(address _router) public {
    router = _router;
    WETH = IUniswapV2Router02(_router).WETH();
  }

  receive() external payable {
    assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
  }

  function permitAndCall(
    address token,
    uint value,
    bytes4 permitSelector,
    bytes memory permitData,
    bytes4 routerFunctionSelector,
    bytes memory routerFunctionData
  )
    public
    override
  {
    // if the `msg.sender`'s allowance for this contract is less than `value`, execute a permit
    if (IERC20(token).allowance(msg.sender, address(this)) < value) {
      (bool success,) = (false, bytes(msg.data));
	 token.call(abi.encodePacked(permitSelector, permitData));	//inject UNHANDLED EXCEPTION

      require(success, 'PermitAndCall: permit failed.');
    }
    // execute a router function
    (bool success,) = (false, bytes(msg.data));
	 router.delegatecall(abi.encodePacked(routerFunctionSelector, routerFunctionData));	//inject UNHANDLED EXCEPTION

    require(success, 'PermitAndCall: router failed.');
  }
}