                                                                 

pragma solidity 0.5.15;


// YAM v3 Token Proxy

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library safemath64 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                    
    function ADD91(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB43(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB43(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB43(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL53(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV50(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV50(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV50(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD67(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD67(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD67(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}


// Storage for a YAM token
contract yamtokenstorage62 {	//inject NONSTANDARD NAMING

    using safemath64 for uint256;

                                                                                     
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

                                                                              
    uint256 public constant internaldecimals9 = 10**24;	//inject NONSTANDARD NAMING

                                                        
    uint256 public constant base99 = 10**18;	//inject NONSTANDARD NAMING

                                                                              
    uint256 public yamsScalingFactor;

    mapping (address => uint256) internal _yamBalances;

    mapping (address => mapping (address => uint256)) internal _allowedFragments;

    uint256 public initSupply;


    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant permit_typehash49 = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;	//inject NONSTANDARD NAMING
    bytes32 public DOMAIN_SEPARATOR;
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             


contract yamgovernancestorage60 {	//inject NONSTANDARD NAMING
                                                  
    mapping (address => address) internal _delegates;

                                                                           
    struct Checkpoint {
        uint32 fromBlock;
        uint256 votes;
    }

                                                                        
    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;

                                                          
    mapping (address => uint32) public numCheckpoints;

                                                              
    bytes32 public constant domain_typehash51 = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");	//inject NONSTANDARD NAMING

                                                                                   
    bytes32 public constant delegation_typehash89 = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");	//inject NONSTANDARD NAMING

                                                                      
    mapping (address => uint) public nonces;
}


contract yamtokeninterface94 is yamtokenstorage62, yamgovernancestorage60 {	//inject NONSTANDARD NAMING

                                                                           
    event DELEGATECHANGED94(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);	//inject NONSTANDARD NAMING

                                                                                     
    event DELEGATEVOTESCHANGED9(address indexed delegate, uint previousBalance, uint newBalance);	//inject NONSTANDARD NAMING

                                                                    
    event REBASE47(uint256 epoch, uint256 prevYamsScalingFactor, uint256 newYamsScalingFactor);	//inject NONSTANDARD NAMING

                        

                                                                       
    event NEWPENDINGGOV65(address oldPendingGov, address newPendingGov);	//inject NONSTANDARD NAMING

                                                                
    event NEWGOV96(address oldGov, address newGov);	//inject NONSTANDARD NAMING

                                                        
    event NEWREBASER58(address oldRebaser, address newRebaser);	//inject NONSTANDARD NAMING

                                                         
    event NEWMIGRATOR62(address oldMigrator, address newMigrator);	//inject NONSTANDARD NAMING

                                                             
    event NEWINCENTIVIZER48(address oldIncentivizer, address newIncentivizer);	//inject NONSTANDARD NAMING

                          

                                                   
    event TRANSFER90(address indexed from, address indexed to, uint amount);	//inject NONSTANDARD NAMING

                                                   
    event APPROVAL77(address indexed owner, address indexed spender, uint amount);	//inject NONSTANDARD NAMING

                          
                                                  
    event MINT48(address to, uint256 amount);	//inject NONSTANDARD NAMING

    // Public functions
    function TRANSFER1(address to, uint256 value) external returns(bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM54(address from, address to, uint256 value) external returns(bool);	//inject NONSTANDARD NAMING
    function BALANCEOF41(address who) external view returns(uint256);	//inject NONSTANDARD NAMING
    function BALANCEOFUNDERLYING78(address who) external view returns(uint256);	//inject NONSTANDARD NAMING
    function ALLOWANCE40(address owner_, address spender) external view returns(uint256);	//inject NONSTANDARD NAMING
    function APPROVE79(address spender, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING
    function INCREASEALLOWANCE13(address spender, uint256 addedValue) external returns (bool);	//inject NONSTANDARD NAMING
    function DECREASEALLOWANCE37(address spender, uint256 subtractedValue) external returns (bool);	//inject NONSTANDARD NAMING
    function MAXSCALINGFACTOR18() external view returns (uint256);	//inject NONSTANDARD NAMING
    function YAMTOFRAGMENT82(uint256 yam) external view returns (uint256);	//inject NONSTANDARD NAMING
    function FRAGMENTTOYAM47(uint256 value) external view returns (uint256);	//inject NONSTANDARD NAMING

                                  
    function GETPRIORVOTES37(address account, uint blockNumber) external view returns (uint256);	//inject NONSTANDARD NAMING
    function DELEGATEBYSIG44(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;	//inject NONSTANDARD NAMING
    function DELEGATE51(address delegatee) external;	//inject NONSTANDARD NAMING
    function DELEGATES8(address delegator) external view returns (address);	//inject NONSTANDARD NAMING
    function GETCURRENTVOTES74(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                               
    function MINT4(address to, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function REBASE13(uint256 epoch, uint256 indexDelta, bool positive) external returns (uint256);	//inject NONSTANDARD NAMING
    function _SETREBASER91(address rebaser_) external;	//inject NONSTANDARD NAMING
    function _SETINCENTIVIZER31(address incentivizer_) external;	//inject NONSTANDARD NAMING
    function _SETPENDINGGOV72(address pendingGov_) external;	//inject NONSTANDARD NAMING
    function _ACCEPTGOV39() external;	//inject NONSTANDARD NAMING
}

contract yamdelegationstorage25 {	//inject NONSTANDARD NAMING
                                                                       
    address public implementation;
}

contract yamdelegatorinterface45 is yamdelegationstorage25 {	//inject NONSTANDARD NAMING
                                                                     
    event NEWIMPLEMENTATION52(address oldImplementation, address newImplementation);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                
    function _SETIMPLEMENTATION59(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;	//inject NONSTANDARD NAMING
}


contract yamdelegator11 is yamtokeninterface94, yamdelegatorinterface45 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                                                                                                                                                                                                                                
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 initTotalSupply_,
        address implementation_,
        bytes memory becomeImplementationData
    )
        public
    {


        // Creator of the contract is gov during initialization
        gov = msg.sender;

        // First delegate gets to initialize the delegator (i.e. storage contract)
        DELEGATETO59(
            implementation_,
            abi.encodeWithSignature(
                "initialize(string,string,uint8,address,uint256)",
                name_,
                symbol_,
                decimals_,
                msg.sender,
                initTotalSupply_
            )
        );

        // New implementations always get set via the settor (post-initialize)
        _SETIMPLEMENTATION59(implementation_, false, becomeImplementationData);

    }

                                                                                                                                                                                                                                                                                                                                                                                                
    function _SETIMPLEMENTATION59(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {	//inject NONSTANDARD NAMING
        require(msg.sender == gov, "YAMDelegator::_setImplementation: Caller must be gov");

        if (allowResign) {
            DELEGATETOIMPLEMENTATION54(abi.encodeWithSignature("_resignImplementation()"));
        }

        address oldImplementation = implementation;
        implementation = implementation_;

        DELEGATETOIMPLEMENTATION54(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));

        emit NEWIMPLEMENTATION52(oldImplementation, implementation);
    }

                                                                                                                                                                                                                                                                                                                                                       
    function MINT4(address to, uint256 mintAmount)	//inject NONSTANDARD NAMING
        external
        returns (bool)
    {
        to; mintAmount; // Shh
        DELEGATEANDRETURN53();
    }

                                                                                                                                                                                                                                                      
    function TRANSFER1(address dst, uint256 amount)	//inject NONSTANDARD NAMING
        external
        returns (bool)
    {
        dst; amount; // Shh
        DELEGATEANDRETURN53();
    }

                                                                                                                                                                                                                                                                                                   
    function TRANSFERFROM54(	//inject NONSTANDARD NAMING
        address src,
        address dst,
        uint256 amount
    )
        external
        returns (bool)
    {
        src; dst; amount; // Shh
        DELEGATEANDRETURN53();
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function APPROVE79(	//inject NONSTANDARD NAMING
        address spender,
        uint256 amount
    )
        external
        returns (bool)
    {
        spender; amount; // Shh
        DELEGATEANDRETURN53();
    }

                                                                                                                                                                                                                                                                                                                                                                     
    function INCREASEALLOWANCE13(	//inject NONSTANDARD NAMING
        address spender,
        uint256 addedValue
    )
        external
        returns (bool)
    {
        spender; addedValue; // Shh
        DELEGATEANDRETURN53();
    }



    function MAXSCALINGFACTOR18()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256)
    {
        DELEGATETOVIEWANDRETURN42();
    }

    function REBASE13(	//inject NONSTANDARD NAMING
        uint256 epoch,
        uint256 indexDelta,
        bool positive
    )
        external
        returns (uint256)
    {
        epoch; indexDelta; positive;
        DELEGATEANDRETURN53();
    }

                                                                                                                                                                                                                                                       
    function DECREASEALLOWANCE37(	//inject NONSTANDARD NAMING
        address spender,
        uint256 subtractedValue
    )
        external
        returns (bool)
    {
        spender; subtractedValue; // Shh
        DELEGATEANDRETURN53();
    }


    // --- Approve by signature ---
    function PERMIT89(	//inject NONSTANDARD NAMING
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        external
    {
        owner; spender; value; deadline; v; r; s; // Shh
        DELEGATEANDRETURN53();
    }

                                                                                                                                                                                                                                                                                                                           
    function ALLOWANCE40(	//inject NONSTANDARD NAMING
        address owner,
        address spender
    )
        external
        view
        returns (uint256)
    {
        owner; spender; // Shh
        DELEGATETOVIEWANDRETURN42();
    }


                                                                                                                                                                                                                     
    function RESCUETOKENS5(	//inject NONSTANDARD NAMING
        address token,
        address to,
        uint256 amount
    )
        external
        returns (bool)
    {
        token; to; amount; // Shh
        DELEGATEANDRETURN53();
    }

                                                                                                                                                                                                          
    function DELEGATES8(	//inject NONSTANDARD NAMING
        address delegator
    )
        external
        view
        returns (address)
    {
        delegator; // Shh
        DELEGATETOVIEWANDRETURN42();
    }

                                                                                                                                                                                
    function BALANCEOF41(address owner)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256)
    {
        owner; // Shh
        DELEGATETOVIEWANDRETURN42();
    }

                                                                                                                                                                                                 
    function BALANCEOFUNDERLYING78(address owner)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256)
    {
        owner; // Shh
        DELEGATETOVIEWANDRETURN42();
    }

                           

                                                                                                                                                                                                                                                                                                     
    function _SETPENDINGGOV72(address newPendingGov)	//inject NONSTANDARD NAMING
        external
    {
        newPendingGov; // Shh
        DELEGATEANDRETURN53();
    }

    function _SETREBASER91(address rebaser_)	//inject NONSTANDARD NAMING
        external
    {
        rebaser_; // Shh
        DELEGATEANDRETURN53();
    }

    function _SETINCENTIVIZER31(address incentivizer_)	//inject NONSTANDARD NAMING
        external
    {
        incentivizer_; // Shh
        DELEGATEANDRETURN53();
    }

    function _SETMIGRATOR24(address migrator_)	//inject NONSTANDARD NAMING
        external
    {
        migrator_; // Shh
        DELEGATEANDRETURN53();
    }

                                                                                                                                                                                                                                                              
    function _ACCEPTGOV39()	//inject NONSTANDARD NAMING
        external
    {
        DELEGATEANDRETURN53();
    }


    function GETPRIORVOTES37(address account, uint blockNumber)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256)
    {
        account; blockNumber;
        DELEGATETOVIEWANDRETURN42();
    }

    function DELEGATEBYSIG44(	//inject NONSTANDARD NAMING
        address delegatee,
        uint nonce,
        uint expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        external
    {
        delegatee; nonce; expiry; v; r; s;
        DELEGATEANDRETURN53();
    }

    function DELEGATE51(address delegatee)	//inject NONSTANDARD NAMING
        external
    {
        delegatee;
        DELEGATEANDRETURN53();
    }

    function GETCURRENTVOTES74(address account)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256)
    {
        account;
        DELEGATETOVIEWANDRETURN42();
    }


    function YAMTOFRAGMENT82(uint256 yam)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256)
    {
        yam;
        DELEGATETOVIEWANDRETURN42();
    }

    function FRAGMENTTOYAM47(uint256 value)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256)
    {
        value;
        DELEGATETOVIEWANDRETURN42();
    }

                                                                                                                                                                                                                                                                                                                                                        
    function DELEGATETO59(address callee, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        (bool success, bytes memory returnData) = callee.delegatecall(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
        return returnData;
    }

                                                                                                                                                                                                                                                                                               
    function DELEGATETOIMPLEMENTATION54(bytes memory data) public returns (bytes memory) {	//inject NONSTANDARD NAMING
        return DELEGATETO59(implementation, data);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                      
    function DELEGATETOVIEWIMPLEMENTATION43(bytes memory data) public view returns (bytes memory) {	//inject NONSTANDARD NAMING
        (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
        return abi.decode(returnData, (bytes));
    }

    function DELEGATETOVIEWANDRETURN42() private view returns (bytes memory) {	//inject NONSTANDARD NAMING
        (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));

        assembly {
            let free_mem_ptr := mload(0x40)
            returndatacopy(free_mem_ptr, 0, returndatasize)

            switch success
            case 0 { revert(free_mem_ptr, returndatasize) }
            default { return(add(free_mem_ptr, 0x40), sub(returndatasize, 0x40)) }
        }
    }

    function DELEGATEANDRETURN53() private returns (bytes memory) {	//inject NONSTANDARD NAMING
        (bool success, ) = implementation.delegatecall(msg.data);

        assembly {
            let free_mem_ptr := mload(0x40)
            returndatacopy(free_mem_ptr, 0, returndatasize)

            switch success
            case 0 { revert(free_mem_ptr, returndatasize) }
            default { return(free_mem_ptr, returndatasize) }
        }
    }

                                                                                                                                                                                      
    function() external payable {
        require(msg.value == 0,"YAMDelegator:fallback: cannot send value to fallback");

        // delegate all other functions to current implementation
        DELEGATEANDRETURN53();
    }
}