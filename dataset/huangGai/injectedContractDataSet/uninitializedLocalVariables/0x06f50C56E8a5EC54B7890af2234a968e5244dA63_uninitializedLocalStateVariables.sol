/**
 *Submitted for verification at Etherscan.io on 2020-04-22
*/

// File: contracts/libs/ERC20Wrapper.sol

pragma solidity 0.5.12;


interface IERC20NotStandard {
    function transfer(address _to, uint256 _quantity) external;

    function transferFrom(
        address _from,
        address _to,
        uint256 _quantity
    ) external;

    function approve(address _spender, uint256 _quantity) external;
}


interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address _owner) external view returns (uint256);

    function allowance(address _owner, address _spender) external view returns (uint256);

    function transfer(address _to, uint256 _quantity) external returns (bool);

    function transferFrom(
        address _from,
        address _to,
        uint256 _quantity
    ) external returns (bool);

    function approve(address _spender, uint256 _quantity) external returns (bool);

    function symbol() external view returns (string memory);
}


library ERC20Wrapper {
    function balanceOf(address _token, address _owner) external view returns (uint256) {
        return IERC20(_token).balanceOf(_owner);
    }

    function allowance(
        address _token,
        address owner,
        address spender
    ) external view returns (uint256) {
        return IERC20(_token).allowance(owner, spender);
    }

    function transfer(
        address _token,
        address _to,
        uint256 _quantity
    ) external returns (bool) {
        if (isIssuedToken(_token)) {
            IERC20NotStandard(_token).transfer(_to, _quantity);

            require(checkSuccess(), "ERC20Wrapper.transfer: Bad return value");
            return true;
        } else {
            return IERC20(_token).transfer(_to, _quantity);
        }
    }

    function transferFrom(
        address _token,
        address _from,
        address _to,
        uint256 _quantity
    ) external returns (bool) {
        if (isIssuedToken(_token)) {
            IERC20NotStandard(_token).transferFrom(_from, _to, _quantity);
            // Check that transferFrom returns true or null
            require(checkSuccess(), "ERC20Wrapper.transferFrom: Bad return value");
            return true;
        } else {
            return IERC20(_token).transferFrom(_from, _to, _quantity);
        }
    }

    function approve(
        address _token,
        address _spender,
        uint256 _quantity
    ) external returns (bool) {
        if (isIssuedToken(_token)) {
            IERC20NotStandard(_token).approve(_spender, _quantity);
            // Check that approve returns true or null
            require(checkSuccess(), "ERC20Wrapper.approve: Bad return value");
            return true;
        } else {
            return IERC20(_token).approve(_spender, _quantity);
        }
    }

    function isIssuedToken(address _token) private view returns (bool) {
        return (keccak256(abi.encodePacked((IERC20(_token).symbol()))) ==
            keccak256(abi.encodePacked(("USDT"))));
    }

    // ============ Private Functions ============

    /**
     * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
     * function returned 0 bytes or 1.
     */
    function checkSuccess() private pure returns (bool) {
        // default to failure
        uint256 returnValue ;	//inject UNINIT LOCAL/STATE VAR


        assembly {
            // check number of bytes returned from last function call
            switch returndatasize
                // no bytes returned: assume success
                case 0x0 {
                    returnValue := 1
                }
                // 32 bytes returned
                case 0x20 {
                    // copy 32 bytes into scratch space
                    returndatacopy(0x0, 0x0, 0x20)

                    // load those bytes into returnValue
                    returnValue := mload(0x0)
                }
                // not sure what was returned: dont mark as success
                default {

                }
        }

        // check if returned value is one or nothing
        return returnValue != 0;
    }
}