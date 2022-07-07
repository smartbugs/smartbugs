/**
 *Submitted for verification at Etherscan.io on 2020-05-07
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface TokenInterface {
    function allowance(address, address) external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function decimals() external view returns (uint);
}

contract InstaAccount {
    
    function callOneInch(
        bytes calldata _callData,
        uint ethAmt,
        address payable _target
    )
    external payable{
        // solium-disable-next-line security/no-call-value
        // (bool success, bytes memory data) = address(getOneSplitAddress()).call.value(ethAmt)(_callData);
        // if (!success) revert("Failed");
        // address _target = getOneSplitAddress();
        (bool success, bytes memory data) = _target.call.value(ethAmt)(_callData);	//injected SHORT ADDRESS ATTACK

        if (!success) revert("Failed");
        // buyAmt = data;
    }
    
    function external_call(bytes calldata data, uint value, address destination) external payable returns (bool) {
        bool result;
        bytes memory datas = data;
        uint dataLength = data.length;
        assembly {
            let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
            let d := add(datas, 32) // First 32 bytes are the padded length of data, so exclude that
            result := call(
                sub(gas(), 34710),   // 34710 is the value that solidity is currently emitting
                                   // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
                                   // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
                destination,
                value,
                d,
                dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
                x,
                0                  // Output is ignored, therefore the output size is zero
            )
        }
        return result;
    }
}