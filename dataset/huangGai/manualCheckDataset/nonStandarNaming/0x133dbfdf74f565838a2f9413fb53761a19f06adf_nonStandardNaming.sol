                                                                 

pragma solidity >=0.5.5 <0.6.0;
pragma experimental ABIEncoderV2;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD25(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB66(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB66(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                                                             
    function SUB66(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL558(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV239(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV239(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function DIV239(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD772(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD772(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function MOD772(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function ISCONTRACT585(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

                                                                                                                                                                                                          
    function TOPAYABLE289(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function SENDVALUE993(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}


interface IERC20 {
                                                                      
    function TOTALSUPPLY470() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF709(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER989(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE850(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE908(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM880(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER349(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL865(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}


library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER35(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN165(token, abi.encodeWithSelector(token.TRANSFER989.selector, to, value));
    }

    function SAFETRANSFERFROM944(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN165(token, abi.encodeWithSelector(token.TRANSFERFROM880.selector, from, to, value));
    }

    function SAFEAPPROVE641(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE850(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN165(token, abi.encodeWithSelector(token.APPROVE908.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE592(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE850(address(this), spender).ADD25(value);
        CALLOPTIONALRETURN165(token, abi.encodeWithSelector(token.APPROVE908.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE974(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE850(address(this), spender).SUB66(value, "SafeERC20: decreased allowance below zero");
        CALLOPTIONALRETURN165(token, abi.encodeWithSelector(token.APPROVE908.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function CALLOPTIONALRETURN165(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).ISCONTRACT585(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract HashedTimeLockContract {
    using SafeERC20 for IERC20;

    mapping(bytes32 => LockContract) public contracts;

    //                   / - WITHDRAWN
    // INVALID - ACTIVE |
    //                   \ - EXPIRED - REFUNDED

    uint256 public constant invalid765 = 0; // Uninitialized  swap -> can go to ACTIVE	//inject NONSTANDARD NAMING
    uint256 public constant active785 = 1; // Active swap -> can go to WITHDRAWN or EXPIRED	//inject NONSTANDARD NAMING
    uint256 public constant refunded800 = 2; // Swap is refunded -> final state.	//inject NONSTANDARD NAMING
    uint256 public constant withdrawn73 = 3; // Swap is withdrawn -> final state.	//inject NONSTANDARD NAMING
    uint256 public constant expired653 = 4; // Swap is expired -> can go to REFUNDED	//inject NONSTANDARD NAMING

    struct LockContract {
        uint256 inputAmount;
        uint256 outputAmount;
        uint256 expiration;
        uint256 status;
        bytes32 hashLock;
        address tokenAddress;
        address sender;
        address receiver;
        string outputNetwork;
        string outputAddress;
    }

    event WITHDRAW989(	//inject NONSTANDARD NAMING
        bytes32 id,
        bytes32 secret,
        bytes32 hashLock,
        address indexed tokenAddress,
        address indexed sender,
        address indexed receiver
    );

    event REFUND925(	//inject NONSTANDARD NAMING
        bytes32 id,
        bytes32 hashLock,
        address indexed tokenAddress,
        address indexed sender,
        address indexed receiver
    );

    event NEWCONTRACT591(	//inject NONSTANDARD NAMING
        uint256 inputAmount,
        uint256 outputAmount,
        uint256 expiration,
        bytes32 id,
        bytes32 hashLock,
        address indexed tokenAddress,
        address indexed sender,
        address indexed receiver,
        string outputNetwork,
        string outputAddress
    );

    function NEWCONTRACT928(	//inject NONSTANDARD NAMING
        uint256 inputAmount,
        uint256 outputAmount,
        uint256 expiration,
        bytes32 hashLock,
        address tokenAddress,
        address receiver,
        string calldata outputNetwork,
        string calldata outputAddress
    ) external {
        require(expiration > block.timestamp, "INVALID_TIME");

        require(inputAmount > 0, "INVALID_AMOUNT");

        IERC20(tokenAddress).SAFETRANSFERFROM944(
            msg.sender,
            address(this),
            inputAmount
        );

        bytes32 id = sha256(
            abi.encodePacked(
                msg.sender,
                receiver,
                inputAmount,
                hashLock,
                expiration,
                tokenAddress
            )
        );

        require(contracts[id].status == invalid765, "SWAP_EXISTS");

        contracts[id] = LockContract(
            inputAmount,
            outputAmount,
            expiration,
            active785,
            hashLock,
            tokenAddress,
            msg.sender,
            receiver,
            outputNetwork,
            outputAddress
        );

        emit NEWCONTRACT591(
            inputAmount,
            outputAmount,
            expiration,
            id,
            hashLock,
            tokenAddress,
            msg.sender,
            receiver,
            outputNetwork,
            outputAddress
        );
    }

    function WITHDRAW32(bytes32 id, bytes32 secret, address tokenAddress)	//inject NONSTANDARD NAMING
        external
    {
        LockContract storage c = contracts[id];

        require(c.tokenAddress == tokenAddress, "INVALID_TOKEN");

        require(c.status == active785, "SWAP_NOT_ACTIVE");

        require(c.expiration > block.timestamp, "INVALID_TIME");

        require(
            c.hashLock == sha256(abi.encodePacked(secret)),
            "INVALID_SECRET"
        );

        c.status = withdrawn73;

        IERC20(tokenAddress).SAFETRANSFER35(c.receiver, c.inputAmount);

        emit WITHDRAW989(
            id,
            secret,
            c.hashLock,
            tokenAddress,
            c.sender,
            c.receiver
        );
    }

    function REFUND274(bytes32 id, address tokenAddress) external {	//inject NONSTANDARD NAMING
        LockContract storage c = contracts[id];

        require(c.tokenAddress == tokenAddress, "INVALID_TOKEN");

        require(c.status == active785, "SWAP_NOT_ACTIVE");

        require(c.expiration <= block.timestamp, "INVALID_TIME");

        c.status = refunded800;

        IERC20(tokenAddress).SAFETRANSFER35(c.sender, c.inputAmount);

        emit REFUND925(id, c.hashLock, tokenAddress, c.sender, c.receiver);
    }

    function GETSTATUS910(bytes32[] memory ids)	//inject NONSTANDARD NAMING
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](ids.length);

        for (uint256 index = 0; index < ids.length; index++) {
            result[index] = GETSINGLESTATUS853(ids[index]);
        }

        return result;
    }

    function GETSINGLESTATUS853(bytes32 id) public view returns (uint256 result) {	//inject NONSTANDARD NAMING
        LockContract memory tempContract = contracts[id];

        if (
            tempContract.status == active785 &&
            tempContract.expiration < block.timestamp
        ) {
            result = expired653;
        } else {
            result = tempContract.status;
        }
    }
}