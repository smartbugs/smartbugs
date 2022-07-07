/**
 *Submitted for verification at Etherscan.io on 2020-04-14
*/

pragma solidity 0.5.16;

contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(tx.origin == owner, "permission denied");	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract ERC20 {
    function balanceOf(address owner) view public returns(uint256);
}

contract ERC20NonStandard {
    function transfer(address to, uint256 value) public;
}

contract GuildBank is Ownable {

    address constant etherAddr = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    event Withdrawal(address indexed token, address indexed receiver, uint256 amount);

    function withdraw(address token, address receiver, uint256 proportion) external onlyOwner returns (bool result) {
        if(token == etherAddr) {
            address payable self = address(this);
            uint256 amount = self.balance * proportion / 1e18;
            emit Withdrawal(token, receiver, amount);
            (bool success,) = receiver.call.value(amount)("");
            return success;
        }
        else {
            uint256 amount = ERC20(token).balanceOf(address(this)) * proportion / 1e18;
            emit Withdrawal(token, receiver, amount);
            return doTransferOut(token, receiver, amount);
        }
    }

    function() external payable {}

    function doTransferOut(address tokenAddr, address to, uint amount) internal returns (bool result) {
        ERC20NonStandard token = ERC20NonStandard(tokenAddr);
        token.transfer(to, amount);

        assembly {
            switch returndatasize()
                case 0 {                      // This is a non-standard ERC-20
                    result := not(0)          // set result to true
                }
                case 32 {                     // This is a complaint ERC-20
                    returndatacopy(0, 0, 32)
                    result := mload(0)        // Set `result = returndata` of external call
                }
                default {                     // This is an excessively non-compliant ERC-20, revert.
                    revert(0, 0)
                }
        }
    }
}