                                                                 

pragma solidity 0.5.15;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             

contract YUANGovernanceStorage {
                                                  
    mapping(address => address) internal _delegates;

                                                                           
    struct Checkpoint {
        uint32 fromBlock;
        uint256 votes;
    }

                                                                        
    mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;

                                                          
    mapping(address => uint32) public numCheckpoints;

                                                              
    bytes32 public constant domain_typehash467 = keccak256(	//inject NONSTANDARD NAMING
        "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
    );

                                                                                   
    bytes32 public constant delegation_typehash708 = keccak256(	//inject NONSTANDARD NAMING
        "Delegation(address delegatee,uint256 nonce,uint256 expiry)"
    );

                                                                      
    mapping(address => uint256) public nonces;
}

// Storage for a YUAN token
contract YUANTokenStorage {
    using SafeMath for uint256;

                                                                                     
    bool internal _notEntered;

                                                               
    string public name;

                                                                 
    string public symbol;

                                                                   
    uint8 public decimals;

                                                         
    address public gov;

                                                                   
    address public pendingGov;

                                                                 
    address public rebaser;

                                                                  
    address public migrator;

                                                                    
    address public incentivizer;

                                                    
    uint256 public totalSupply;

                                                                              
    uint256 public constant internaldecimals289 = 10**24;	//inject NONSTANDARD NAMING

                                                        
    uint256 public constant base843 = 10**18;	//inject NONSTANDARD NAMING

                                                                              
    uint256 public yuansScalingFactor;

    mapping(address => uint256) internal _yuanBalances;

    mapping(address => mapping(address => uint256)) internal _allowedFragments;

    uint256 public initSupply;

    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32	//inject NONSTANDARD NAMING
        public constant permit_typehash503 = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    bytes32 public DOMAIN_SEPARATOR;
}

contract YUANTokenInterface is YUANTokenStorage, YUANGovernanceStorage {
                                                                           
    event DELEGATECHANGED444(	//inject NONSTANDARD NAMING
        address indexed delegator,
        address indexed fromDelegate,
        address indexed toDelegate
    );

                                                                                     
    event DELEGATEVOTESCHANGED965(	//inject NONSTANDARD NAMING
        address indexed delegate,
        uint256 previousBalance,
        uint256 newBalance
    );

                                                                    
    event REBASE678(	//inject NONSTANDARD NAMING
        uint256 epoch,
        uint256 prevYuansScalingFactor,
        uint256 newYuansScalingFactor
    );

                        

                                                                       
    event NEWPENDINGGOV591(address oldPendingGov, address newPendingGov);	//inject NONSTANDARD NAMING

                                                                
    event NEWGOV954(address oldGov, address newGov);	//inject NONSTANDARD NAMING

                                                        
    event NEWREBASER453(address oldRebaser, address newRebaser);	//inject NONSTANDARD NAMING

                                                         
    event NEWMIGRATOR48(address oldMigrator, address newMigrator);	//inject NONSTANDARD NAMING

                                                             
    event NEWINCENTIVIZER28(address oldIncentivizer, address newIncentivizer);	//inject NONSTANDARD NAMING

                          

                                                   
    event TRANSFER462(address indexed from, address indexed to, uint256 amount);	//inject NONSTANDARD NAMING

                                                   
    event APPROVAL374(	//inject NONSTANDARD NAMING
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

                          
                                                  
    event MINT854(address to, uint256 amount);	//inject NONSTANDARD NAMING

    // Public functions
    function TRANSFER508(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM276(	//inject NONSTANDARD NAMING
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function BALANCEOF369(address who) external view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOFUNDERLYING28(address who) external view returns (uint256);	//inject NONSTANDARD NAMING

    function ALLOWANCE671(address owner_, address spender)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

    function APPROVE975(address spender, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function INCREASEALLOWANCE36(address spender, uint256 addedValue)	//inject NONSTANDARD NAMING
        external
        returns (bool);

    function DECREASEALLOWANCE115(address spender, uint256 subtractedValue)	//inject NONSTANDARD NAMING
        external
        returns (bool);

    function MAXSCALINGFACTOR640() external view returns (uint256);	//inject NONSTANDARD NAMING

    function YUANTOFRAGMENT975(uint256 yuan) external view returns (uint256);	//inject NONSTANDARD NAMING

    function FRAGMENTTOYUAN110(uint256 value) external view returns (uint256);	//inject NONSTANDARD NAMING

                                  
    function GETPRIORVOTES568(address account, uint256 blockNumber)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

    function DELEGATEBYSIG273(	//inject NONSTANDARD NAMING
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function DELEGATE794(address delegatee) external;	//inject NONSTANDARD NAMING

    function DELEGATES57(address delegator) external view returns (address);	//inject NONSTANDARD NAMING

    function GETCURRENTVOTES80(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                               
    function MINT564(address to, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

    function REBASE123(	//inject NONSTANDARD NAMING
        uint256 epoch,
        uint256 indexDelta,
        bool positive
    ) external returns (uint256);

    function _SETREBASER150(address rebaser_) external;	//inject NONSTANDARD NAMING

    function _SETINCENTIVIZER861(address incentivizer_) external;	//inject NONSTANDARD NAMING

    function _SETPENDINGGOV492(address pendingGov_) external;	//inject NONSTANDARD NAMING

    function _ACCEPTGOV305() external;	//inject NONSTANDARD NAMING
}

contract YUANGovernanceToken is YUANTokenInterface {
                                                                           
    event DELEGATECHANGED444(	//inject NONSTANDARD NAMING
        address indexed delegator,
        address indexed fromDelegate,
        address indexed toDelegate
    );

                                                                                     
    event DELEGATEVOTESCHANGED965(	//inject NONSTANDARD NAMING
        address indexed delegate,
        uint256 previousBalance,
        uint256 newBalance
    );

                                                                                                                               
    function DELEGATES57(address delegator) external view returns (address) {	//inject NONSTANDARD NAMING
        return _delegates[delegator];
    }

                                                                                                                                       
    function DELEGATE794(address delegatee) external {	//inject NONSTANDARD NAMING
        return _DELEGATE422(msg.sender, delegatee);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DELEGATEBYSIG273(	//inject NONSTANDARD NAMING
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        bytes32 structHash = keccak256(
            abi.encode(delegation_typehash708, delegatee, nonce, expiry)
        );

        bytes32 digest = keccak256(
            abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash)
        );

        address signatory = ecrecover(digest, v, r, s);
        require(
            signatory != address(0),
            "YUAN::delegateBySig: invalid signature"
        );
        require(
            nonce == nonces[signatory]++,
            "YUAN::delegateBySig: invalid nonce"
        );
        require(now <= expiry, "YUAN::delegateBySig: signature expired");
        return _DELEGATE422(signatory, delegatee);
    }

                                                                                                                                                                                           
    function GETCURRENTVOTES80(address account) external view returns (uint256) {	//inject NONSTANDARD NAMING
        uint32 nCheckpoints = numCheckpoints[account];
        return
            nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                               
    function GETPRIORVOTES568(address account, uint256 blockNumber)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256)
    {
        require(
            blockNumber < block.number,
            "YUAN::getPriorVotes: not yet determined"
        );

        uint32 nCheckpoints = numCheckpoints[account];
        if (nCheckpoints == 0) {
            return 0;
        }

        // First check most recent balance
        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
            return checkpoints[account][nCheckpoints - 1].votes;
        }

        // Next check implicit zero balance
        if (checkpoints[account][0].fromBlock > blockNumber) {
            return 0;
        }

        uint32 lower = 0;
        uint32 upper = nCheckpoints - 1;
        while (upper > lower) {
            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
            Checkpoint memory cp = checkpoints[account][center];
            if (cp.fromBlock == blockNumber) {
                return cp.votes;
            } else if (cp.fromBlock < blockNumber) {
                lower = center;
            } else {
                upper = center - 1;
            }
        }
        return checkpoints[account][lower].votes;
    }

    function _DELEGATE422(address delegator, address delegatee) internal {	//inject NONSTANDARD NAMING
        address currentDelegate = _delegates[delegator];
        uint256 delegatorBalance = _yuanBalances[delegator]; // balance of underlying YUANs (not scaled);
        _delegates[delegator] = delegatee;

        emit DELEGATECHANGED444(delegator, currentDelegate, delegatee);

        _MOVEDELEGATES829(currentDelegate, delegatee, delegatorBalance);
    }

    function _MOVEDELEGATES829(	//inject NONSTANDARD NAMING
        address srcRep,
        address dstRep,
        uint256 amount
    ) internal {
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                // decrease old representative
                uint32 srcRepNum = numCheckpoints[srcRep];
                uint256 srcRepOld = srcRepNum > 0
                    ? checkpoints[srcRep][srcRepNum - 1].votes
                    : 0;
                uint256 srcRepNew = srcRepOld.SUB548(amount);
                _WRITECHECKPOINT921(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }

            if (dstRep != address(0)) {
                // increase new representative
                uint32 dstRepNum = numCheckpoints[dstRep];
                uint256 dstRepOld = dstRepNum > 0
                    ? checkpoints[dstRep][dstRepNum - 1].votes
                    : 0;
                uint256 dstRepNew = dstRepOld.ADD618(amount);
                _WRITECHECKPOINT921(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }
        }
    }

    function _WRITECHECKPOINT921(	//inject NONSTANDARD NAMING
        address delegatee,
        uint32 nCheckpoints,
        uint256 oldVotes,
        uint256 newVotes
    ) internal {
        uint32 blockNumber = SAFE32762(
            block.number,
            "YUAN::_writeCheckpoint: block number exceeds 32 bits"
        );

        if (
            nCheckpoints > 0 &&
            checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
        ) {
            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
        } else {
            checkpoints[delegatee][nCheckpoints] = Checkpoint(
                blockNumber,
                newVotes
            );
            numCheckpoints[delegatee] = nCheckpoints + 1;
        }

        emit DELEGATEVOTESCHANGED965(delegatee, oldVotes, newVotes);
    }

    function SAFE32762(uint256 n, string memory errorMessage)	//inject NONSTANDARD NAMING
        internal
        pure
        returns (uint32)
    {
        require(n < 2**32, errorMessage);
        return uint32(n);
    }

    function GETCHAINID188() internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        return chainId;
    }
}

                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY978() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF369(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER508(address recipient, uint256 amount)	//inject NONSTANDARD NAMING
        external
        returns (bool);

                                                                                                                                                                                                                                                                            
    function ALLOWANCE671(address owner, address spender)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE975(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM276(	//inject NONSTANDARD NAMING
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

                                                                                                                                                                  
    event TRANSFER462(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL374(	//inject NONSTANDARD NAMING
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD618(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB548(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB548(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB548(	//inject NONSTANDARD NAMING
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL341(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV216(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV216(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV216(	//inject NONSTANDARD NAMING
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD958(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD958(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD958(	//inject NONSTANDARD NAMING
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT826(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE586(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL879(address target, bytes memory data)	//inject NONSTANDARD NAMING
        internal
        returns (bytes memory)
    {
        return FUNCTIONCALL879(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL879(	//inject NONSTANDARD NAMING
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _FUNCTIONCALLWITHVALUE730(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE156(	//inject NONSTANDARD NAMING
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            FUNCTIONCALLWITHVALUE156(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE156(	//inject NONSTANDARD NAMING
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        return _FUNCTIONCALLWITHVALUE730(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE730(	//inject NONSTANDARD NAMING
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(ISCONTRACT826(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call.value(weiValue)(
            data
        );
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER589(	//inject NONSTANDARD NAMING
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _CALLOPTIONALRETURN469(
            token,
            abi.encodeWithSelector(token.TRANSFER508.selector, to, value)
        );
    }

    function SAFETRANSFERFROM16(	//inject NONSTANDARD NAMING
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _CALLOPTIONALRETURN469(
            token,
            abi.encodeWithSelector(token.TRANSFERFROM276.selector, from, to, value)
        );
    }

                                                                                                                                                                                                                                                             
    function SAFEAPPROVE191(	//inject NONSTANDARD NAMING
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.ALLOWANCE671(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _CALLOPTIONALRETURN469(
            token,
            abi.encodeWithSelector(token.APPROVE975.selector, spender, value)
        );
    }

    function SAFEINCREASEALLOWANCE753(	//inject NONSTANDARD NAMING
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.ALLOWANCE671(address(this), spender).ADD618(
            value
        );
        _CALLOPTIONALRETURN469(
            token,
            abi.encodeWithSelector(
                token.APPROVE975.selector,
                spender,
                newAllowance
            )
        );
    }

    function SAFEDECREASEALLOWANCE777(	//inject NONSTANDARD NAMING
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.ALLOWANCE671(address(this), spender).SUB548(
            value,
            "SafeERC20: decreased allowance below zero"
        );
        _CALLOPTIONALRETURN469(
            token,
            abi.encodeWithSelector(
                token.APPROVE975.selector,
                spender,
                newAllowance
            )
        );
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function _CALLOPTIONALRETURN469(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).FUNCTIONCALL879(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

contract YUANToken is YUANGovernanceToken {
    // Modifiers
    modifier ONLYGOV644() {	//inject NONSTANDARD NAMING
        require(msg.sender == gov);
        _;
    }

    modifier ONLYREBASER711() {	//inject NONSTANDARD NAMING
        require(msg.sender == rebaser);
        _;
    }

    modifier ONLYMINTER815() {	//inject NONSTANDARD NAMING
        require(
            msg.sender == rebaser ||
                msg.sender == gov ||
                msg.sender == incentivizer ||
                msg.sender == migrator,
            "not minter"
        );
        _;
    }

    modifier VALIDRECIPIENT953(address to) {	//inject NONSTANDARD NAMING
        require(to != address(0x0));
        require(to != address(this));
        _;
    }

    function INITIALIZE963(	//inject NONSTANDARD NAMING
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) public {
        require(yuansScalingFactor == 0, "already initialized");
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
    }

                                                                      
    function MAXSCALINGFACTOR640() external view returns (uint256) {	//inject NONSTANDARD NAMING
        return _MAXSCALINGFACTOR654();
    }

    function _MAXSCALINGFACTOR654() internal view returns (uint256) {	//inject NONSTANDARD NAMING
        // scaling factor can only go up to 2**256-1 = initSupply * yuansScalingFactor
        // this is used to check if yuansScalingFactor will be too high to compute balances when rebasing.
        return uint256(-1) / initSupply;
    }

                                                                                                                                                    
    function MINT564(address to, uint256 amount)	//inject NONSTANDARD NAMING
        external
        ONLYMINTER815
        returns (bool)
    {
        _MINT778(to, amount);
        return true;
    }

    function _MINT778(address to, uint256 amount) internal {	//inject NONSTANDARD NAMING
        if (msg.sender == migrator) {
            // migrator directly uses v2 balance for the amount

            // increase initSupply
            initSupply = initSupply.ADD618(amount);

            // get external value
            uint256 scaledAmount = _YUANTOFRAGMENT236(amount);

            // increase totalSupply
            totalSupply = totalSupply.ADD618(scaledAmount);

            // make sure the mint didnt push maxScalingFactor too low
            require(
                yuansScalingFactor <= _MAXSCALINGFACTOR654(),
                "max scaling factor too low"
            );

            // add balance
            _yuanBalances[to] = _yuanBalances[to].ADD618(amount);

            // add delegates to the minter
            _MOVEDELEGATES829(address(0), _delegates[to], amount);
            emit MINT854(to, scaledAmount);
            emit TRANSFER462(address(0), to, scaledAmount);
        } else {
            // increase totalSupply
            totalSupply = totalSupply.ADD618(amount);

            // get underlying value
            uint256 yuanValue = _FRAGMENTTOYUAN426(amount);

            // increase initSupply
            initSupply = initSupply.ADD618(yuanValue);

            // make sure the mint didnt push maxScalingFactor too low
            require(
                yuansScalingFactor <= _MAXSCALINGFACTOR654(),
                "max scaling factor too low"
            );

            // add balance
            _yuanBalances[to] = _yuanBalances[to].ADD618(yuanValue);

            // add delegates to the minter
            _MOVEDELEGATES829(address(0), _delegates[to], yuanValue);
            emit MINT854(to, amount);
            emit TRANSFER462(address(0), to, amount);
        }
    }

                                 

                                                                                                                                                                                                                   
    function TRANSFER508(address to, uint256 value)	//inject NONSTANDARD NAMING
        external
        VALIDRECIPIENT953(to)
        returns (bool)
    {
        // underlying balance is stored in yuans, so divide by current scaling factor

        // note, this means as scaling factor grows, dust will be untransferrable.
        // minimum transfer value == yuansScalingFactor / 1e24;

        // get amount in underlying
        uint256 yuanValue = _FRAGMENTTOYUAN426(value);

        // sub from balance of sender
        _yuanBalances[msg.sender] = _yuanBalances[msg.sender].SUB548(yuanValue);

        // add to balance of receiver
        _yuanBalances[to] = _yuanBalances[to].ADD618(yuanValue);
        emit TRANSFER462(msg.sender, to, value);

        _MOVEDELEGATES829(_delegates[msg.sender], _delegates[to], yuanValue);
        return true;
    }

                                                                                                                                                                                                                                                       
    function TRANSFERFROM276(	//inject NONSTANDARD NAMING
        address from,
        address to,
        uint256 value
    ) external VALIDRECIPIENT953(to) returns (bool) {
        // decrease allowance
        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg
            .sender]
            .SUB548(value);

        // get value in yuans
        uint256 yuanValue = _FRAGMENTTOYUAN426(value);

        // sub from from
        _yuanBalances[from] = _yuanBalances[from].SUB548(yuanValue);
        _yuanBalances[to] = _yuanBalances[to].ADD618(yuanValue);
        emit TRANSFER462(from, to, value);

        _MOVEDELEGATES829(_delegates[from], _delegates[to], yuanValue);
        return true;
    }

                                                                                                            
    function BALANCEOF369(address who) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return _YUANTOFRAGMENT236(_yuanBalances[who]);
    }

                                                                                                                                                                             
    function BALANCEOFUNDERLYING28(address who) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return _yuanBalances[who];
    }

                                                                                                                                                                                                                                                                                                    
    function ALLOWANCE671(address owner_, address spender)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256)
    {
        return _allowedFragments[owner_][spender];
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function APPROVE975(address spender, uint256 value) external returns (bool) {	//inject NONSTANDARD NAMING
        _allowedFragments[msg.sender][spender] = value;
        emit APPROVAL374(msg.sender, spender, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                     
    function INCREASEALLOWANCE36(address spender, uint256 addedValue)	//inject NONSTANDARD NAMING
        external
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] = _allowedFragments[msg
            .sender][spender]
            .ADD618(addedValue);
        emit APPROVAL374(
            msg.sender,
            spender,
            _allowedFragments[msg.sender][spender]
        );
        return true;
    }

                                                                                                                                                                                                                                                       
    function DECREASEALLOWANCE115(address spender, uint256 subtractedValue)	//inject NONSTANDARD NAMING
        external
        returns (bool)
    {
        uint256 oldValue = _allowedFragments[msg.sender][spender];
        if (subtractedValue >= oldValue) {
            _allowedFragments[msg.sender][spender] = 0;
        } else {
            _allowedFragments[msg.sender][spender] = oldValue.SUB548(
                subtractedValue
            );
        }
        emit APPROVAL374(
            msg.sender,
            spender,
            _allowedFragments[msg.sender][spender]
        );
        return true;
    }

    // --- Approve by signature ---
    function PERMIT439(	//inject NONSTANDARD NAMING
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(now <= deadline, "YUAN/permit-expired");

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        permit_typehash503,
                        owner,
                        spender,
                        value,
                        nonces[owner]++,
                        deadline
                    )
                )
            )
        );

        require(owner != address(0), "YUAN/invalid-address-0");
        require(owner == ecrecover(digest, v, r, s), "YUAN/invalid-permit");
        _allowedFragments[owner][spender] = value;
        emit APPROVAL374(owner, spender, value);
    }

                                  

                                                                                                                              
    function _SETREBASER150(address rebaser_) external ONLYGOV644 {	//inject NONSTANDARD NAMING
        address oldRebaser = rebaser;
        rebaser = rebaser_;
        emit NEWREBASER453(oldRebaser, rebaser_);
    }

                                                                                                                                 
    function _SETMIGRATOR264(address migrator_) external ONLYGOV644 {	//inject NONSTANDARD NAMING
        address oldMigrator = migrator_;
        migrator = migrator_;
        emit NEWMIGRATOR48(oldMigrator, migrator_);
    }

                                                                                                                                        
    function _SETINCENTIVIZER861(address incentivizer_) external ONLYGOV644 {	//inject NONSTANDARD NAMING
        address oldIncentivizer = incentivizer;
        incentivizer = incentivizer_;
        emit NEWINCENTIVIZER28(oldIncentivizer, incentivizer_);
    }

                                                                                                                                    
    function _SETPENDINGGOV492(address pendingGov_) external ONLYGOV644 {	//inject NONSTANDARD NAMING
        address oldPendingGov = pendingGov;
        pendingGov = pendingGov_;
        emit NEWPENDINGGOV591(oldPendingGov, pendingGov_);
    }

                                                                
    function _ACCEPTGOV305() external {	//inject NONSTANDARD NAMING
        require(msg.sender == pendingGov, "!pending");
        address oldGov = gov;
        gov = pendingGov;
        pendingGov = address(0);
        emit NEWGOV954(oldGov, gov);
    }

                    

                                                                                                                                                                                                                                                                                                                                                                  
    function REBASE123(	//inject NONSTANDARD NAMING
        uint256 epoch,
        uint256 indexDelta,
        bool positive
    ) external ONLYREBASER711 returns (uint256) {
        // no change
        if (indexDelta == 0) {
            emit REBASE678(epoch, yuansScalingFactor, yuansScalingFactor);
            return totalSupply;
        }

        // for events
        uint256 prevYuansScalingFactor = yuansScalingFactor;

        if (!positive) {
            // negative rebase, decrease scaling factor
            yuansScalingFactor = yuansScalingFactor
                .MUL341(base843.SUB548(indexDelta))
                .DIV216(base843);
        } else {
            // positive reabse, increase scaling factor
            uint256 newScalingFactor = yuansScalingFactor
                .MUL341(base843.ADD618(indexDelta))
                .DIV216(base843);
            if (newScalingFactor < _MAXSCALINGFACTOR654()) {
                yuansScalingFactor = newScalingFactor;
            } else {
                yuansScalingFactor = _MAXSCALINGFACTOR654();
            }
        }

        // update total supply, correctly
        totalSupply = _YUANTOFRAGMENT236(initSupply);

        emit REBASE678(epoch, prevYuansScalingFactor, yuansScalingFactor);
        return totalSupply;
    }

    function YUANTOFRAGMENT975(uint256 yuan) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return _YUANTOFRAGMENT236(yuan);
    }

    function FRAGMENTTOYUAN110(uint256 value) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return _FRAGMENTTOYUAN426(value);
    }

    function _YUANTOFRAGMENT236(uint256 yuan) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return yuan.MUL341(yuansScalingFactor).DIV216(internaldecimals289);
    }

    function _FRAGMENTTOYUAN426(uint256 value) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return value.MUL341(internaldecimals289).DIV216(yuansScalingFactor);
    }

    // Rescue tokens
    function RESCUETOKENS788(	//inject NONSTANDARD NAMING
        address token,
        address to,
        uint256 amount
    ) external ONLYGOV644 returns (bool) {
        // transfer to
        SafeERC20.SAFETRANSFER589(IERC20(token), to, amount);
        return true;
    }
}

contract YUAN is YUANToken {
                                                                                                                                                                                                                             
    function INITIALIZE963(	//inject NONSTANDARD NAMING
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        address initial_owner,
        uint256 initTotalSupply_
    ) public {
        super.INITIALIZE963(name_, symbol_, decimals_);

        yuansScalingFactor = base843;
        initSupply = _FRAGMENTTOYUAN426(initTotalSupply_);
        totalSupply = initTotalSupply_;
        _yuanBalances[initial_owner] = initSupply;

        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                domain_typehash467,
                keccak256(bytes(name)),
                GETCHAINID188(),
                address(this)
            )
        );
    }
}

contract YUANDelegationStorage {
                                                                       
    address public implementation;
}

contract YUANDelegatorInterface is YUANDelegationStorage {
                                                                     
    event NEWIMPLEMENTATION947(	//inject NONSTANDARD NAMING
        address oldImplementation,
        address newImplementation
    );

                                                                                                                                                                                                                                                                                                                                                                                                
    function _SETIMPLEMENTATION470(	//inject NONSTANDARD NAMING
        address implementation_,
        bool allowResign,
        bytes memory becomeImplementationData
    ) public;
}

contract YUANDelegateInterface is YUANDelegationStorage {
                                                                                                                                                                                                                                                
    function _BECOMEIMPLEMENTATION61(bytes memory data) public;	//inject NONSTANDARD NAMING

                                                                                                  
    function _RESIGNIMPLEMENTATION160() public;	//inject NONSTANDARD NAMING
}

contract YUANDelegate is YUAN, YUANDelegateInterface {
                                                          
    constructor() public {}

                                                                                                                                                               
    function _BECOMEIMPLEMENTATION61(bytes memory data) public {	//inject NONSTANDARD NAMING
        // Shh -- currently unused
        data;

        // Shh -- we don't ever want this hook to be marked pure
        if (false) {
            implementation = address(0);
        }

        require(
            msg.sender == gov,
            "only the gov may call _becomeImplementation"
        );
    }

                                                                                                  
    function _RESIGNIMPLEMENTATION160() public {	//inject NONSTANDARD NAMING
        // Shh -- we don't ever want this hook to be marked pure
        if (false) {
            implementation = address(0);
        }

        require(
            msg.sender == gov,
            "only the gov may call _resignImplementation"
        );
    }
}