                                                                 

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

// From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
// Subject to the MIT license.

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                      
    function ADD750(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint c = a + b;
        require(c >= a, "add: +");

        return c;
    }

                                                                                                                                                                                                                                          
    function ADD750(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint c = a + b;
        require(c >= a, errorMessage);

        return c;
    }

                                                                                                                                                                                                                                                            
    function SUB186(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return SUB186(a, b, "sub: -");
    }

                                                                                                                                                                                                                                                                                
    function SUB186(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }

                                                                                                                                                                                                                                  
    function MUL249(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "mul: *");

        return c;
    }

                                                                                                                                                                                                                                  
    function MUL249(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, errorMessage);

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV270(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return DIV270(a, b, "div: /");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function DIV270(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD552(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return MOD552(a, b, "mod: %");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function MOD552(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _not_entered410 = 1;	//inject NONSTANDARD NAMING
    uint256 private constant _entered581 = 2;	//inject NONSTANDARD NAMING

    uint256 private _status;

    constructor () internal {
        _status = _not_entered410;
    }

                                                                                                                                                                                                                                                                                                                                                                                
    modifier NONREENTRANT577() {	//inject NONSTANDARD NAMING
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _entered581, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _entered581;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _not_entered410;
    }
}

                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY402() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF653(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER134(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE619(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE305(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM0(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER881(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL173(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT661(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

                                                                                                                                                                                                          
    function TOPAYABLE190(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function SENDVALUE489(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call{value:amount}("");
        require(success, "Address: reverted");
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER297(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN600(token, abi.encodeWithSelector(token.TRANSFER134.selector, to, value));
    }

    function SAFETRANSFERFROM429(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN600(token, abi.encodeWithSelector(token.TRANSFERFROM0.selector, from, to, value));
    }

    function SAFEAPPROVE484(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE619(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN600(token, abi.encodeWithSelector(token.APPROVE305.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE405(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE619(address(this), spender).ADD750(value);
        CALLOPTIONALRETURN600(token, abi.encodeWithSelector(token.APPROVE305.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE743(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE619(address(this), spender).SUB186(value, "SafeERC20: < 0");
        CALLOPTIONALRETURN600(token, abi.encodeWithSelector(token.APPROVE305.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function CALLOPTIONALRETURN600(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).ISCONTRACT661(), "SafeERC20: !contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: !succeed");
        }
    }
}

library KperNetworkLibrary {
    function GETRESERVE107(address pair, address reserve) external view returns (uint) {	//inject NONSTANDARD NAMING
        (uint _r0, uint _r1,) = IUniswapV2Pair(pair).GETRESERVES90();
        if (IUniswapV2Pair(pair).TOKEN0518() == reserve) {
            return _r0;
        } else if (IUniswapV2Pair(pair).TOKEN1343() == reserve) {
            return _r1;
        } else {
            return 0;
        }
    }
}

interface IUniswapV2Pair {
    event APPROVAL173(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER881(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    function NAME679() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL555() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function DECIMALS187() external pure returns (uint8);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY402() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF653(address owner) external view returns (uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE619(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING

    function APPROVE305(address spender, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER134(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM0(address from, address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING

    function DOMAIN_SEPARATOR360() external view returns (bytes32);	//inject NONSTANDARD NAMING
    function PERMIT_TYPEHASH617() external pure returns (bytes32);	//inject NONSTANDARD NAMING
    function NONCES5(address owner) external view returns (uint);	//inject NONSTANDARD NAMING

    function PERMIT744(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;	//inject NONSTANDARD NAMING

    event MINT880(address indexed sender, uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    event BURN642(address indexed sender, uint amount0, uint amount1, address indexed to);	//inject NONSTANDARD NAMING
    event SWAP530(	//inject NONSTANDARD NAMING
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event SYNC504(uint112 reserve0, uint112 reserve1);	//inject NONSTANDARD NAMING

    function MINIMUM_LIQUIDITY128() external pure returns (uint);	//inject NONSTANDARD NAMING
    function FACTORY30() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN0518() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN1343() external view returns (address);	//inject NONSTANDARD NAMING
    function GETRESERVES90() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);	//inject NONSTANDARD NAMING
    function PRICE0CUMULATIVELAST484() external view returns (uint);	//inject NONSTANDARD NAMING
    function PRICE1CUMULATIVELAST567() external view returns (uint);	//inject NONSTANDARD NAMING
    function KLAST695() external view returns (uint);	//inject NONSTANDARD NAMING

    function MINT553(address to) external returns (uint liquidity);	//inject NONSTANDARD NAMING
    function BURN246(address to) external returns (uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    function SWAP955(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;	//inject NONSTANDARD NAMING
    function SKIM112(address to) external;	//inject NONSTANDARD NAMING
    function SYNC19() external;	//inject NONSTANDARD NAMING

    function INITIALIZE501(address, address) external;	//inject NONSTANDARD NAMING
}

interface IGovernance {
    function PROPOSEJOB67(address job) external;	//inject NONSTANDARD NAMING
}

interface IKperNetworkHelper {
    function GETQUOTELIMIT193(uint gasUsed) external view returns (uint);	//inject NONSTANDARD NAMING
}

contract KperNetwork is ReentrancyGuard {
    using SafeMath for uint;
    using SafeERC20 for IERC20;

                                                               
    IKperNetworkHelper public KPRH;

                                                
    string public constant name59 = "Kper.Network";	//inject NONSTANDARD NAMING

                                                  
    string public constant symbol586 = "KPER";	//inject NONSTANDARD NAMING

                                                    
    uint8 public constant decimals310 = 18;	//inject NONSTANDARD NAMING

                                                     
    uint public totalSupply = 0; // Initial 0

                                                  
    mapping (address => address) public delegates;

                                                                        
    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;

                                                          
    mapping (address => uint32) public numCheckpoints;

    mapping (address => mapping (address => uint)) internal allowances;
    mapping (address => uint) internal balances;

                                                              
    bytes32 public constant domain_typehash648 = keccak256("EIP712Domain(string name,uint chainId,address verifyingContract)");	//inject NONSTANDARD NAMING
    bytes32 public immutable DOMAINSEPARATOR;

                                                                                   
    bytes32 public constant delegation_typehash691 = keccak256("Delegation(address delegatee,uint nonce,uint expiry)");	//inject NONSTANDARD NAMING

                                                                               
    bytes32 public constant permit_typehash982 = keccak256("Permit(address owner,address spender,uint value,uint nonce,uint deadline)");	//inject NONSTANDARD NAMING


                                                                      
    mapping (address => uint) public nonces;

                                                                           
    event DELEGATECHANGED7(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);	//inject NONSTANDARD NAMING

                                                                                     
    event DELEGATEVOTESCHANGED30(address indexed delegate, uint previousBalance, uint newBalance);	//inject NONSTANDARD NAMING

                                                                           
    struct Checkpoint {
        uint32 fromBlock;
        uint votes;
    }

                                                                                                                                       
    function DELEGATE839(address delegatee) public {	//inject NONSTANDARD NAMING
        _DELEGATE446(msg.sender, delegatee);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DELEGATEBYSIG540(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {	//inject NONSTANDARD NAMING
        bytes32 structHash = keccak256(abi.encode(delegation_typehash691, delegatee, nonce, expiry));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "delegateBySig: sig");
        require(nonce == nonces[signatory]++, "delegateBySig: nonce");
        require(now <= expiry, "delegateBySig: expired");
        _DELEGATE446(signatory, delegatee);
    }

                                                                                                                                                                                           
    function GETCURRENTVOTES464(address account) external view returns (uint) {	//inject NONSTANDARD NAMING
        uint32 nCheckpoints = numCheckpoints[account];
        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                               
    function GETPRIORVOTES822(address account, uint blockNumber) public view returns (uint) {	//inject NONSTANDARD NAMING
        require(blockNumber < block.number, "getPriorVotes:");

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

    function _DELEGATE446(address delegator, address delegatee) internal {	//inject NONSTANDARD NAMING
        address currentDelegate = delegates[delegator];
        uint delegatorBalance = votes[delegator].ADD750(bonds[delegator][address(this)]);
        delegates[delegator] = delegatee;

        emit DELEGATECHANGED7(delegator, currentDelegate, delegatee);

        _MOVEDELEGATES153(currentDelegate, delegatee, delegatorBalance);
    }

    function _MOVEDELEGATES153(address srcRep, address dstRep, uint amount) internal {	//inject NONSTANDARD NAMING
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                uint32 srcRepNum = numCheckpoints[srcRep];
                uint srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
                uint srcRepNew = srcRepOld.SUB186(amount, "_moveVotes: underflows");
                _WRITECHECKPOINT898(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }

            if (dstRep != address(0)) {
                uint32 dstRepNum = numCheckpoints[dstRep];
                uint dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
                uint dstRepNew = dstRepOld.ADD750(amount);
                _WRITECHECKPOINT898(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }
        }
    }

    function _WRITECHECKPOINT898(address delegatee, uint32 nCheckpoints, uint oldVotes, uint newVotes) internal {	//inject NONSTANDARD NAMING
      uint32 blockNumber = SAFE32446(block.number, "_writeCheckpoint: 32 bits");

      if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
          checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
      } else {
          checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
          numCheckpoints[delegatee] = nCheckpoints + 1;
      }

      emit DELEGATEVOTESCHANGED30(delegatee, oldVotes, newVotes);
    }

    function SAFE32446(uint n, string memory errorMessage) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
        require(n < 2**32, errorMessage);
        return uint32(n);
    }

                                                  
    event TRANSFER881(address indexed from, address indexed to, uint amount);	//inject NONSTANDARD NAMING

                                                  
    event APPROVAL173(address indexed owner, address indexed spender, uint amount);	//inject NONSTANDARD NAMING

                            
    event SUBMITJOB626(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);	//inject NONSTANDARD NAMING

                                     
    event APPLYCREDIT477(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);	//inject NONSTANDARD NAMING

                                       
    event REMOVEJOB82(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);	//inject NONSTANDARD NAMING

                                       
    event UNBONDJOB739(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);	//inject NONSTANDARD NAMING

                           
    event JOBADDED910(address indexed job, uint block, address governance);	//inject NONSTANDARD NAMING

                             
    event JOBREMOVED937(address indexed job, uint block, address governance);	//inject NONSTANDARD NAMING

                            
    event KEEPERWORKED480(address indexed credit, address indexed job, address indexed keeper, uint block, uint amount);	//inject NONSTANDARD NAMING

                              
    event KEEPERBONDING674(address indexed keeper, uint block, uint active, uint bond);	//inject NONSTANDARD NAMING

                             
    event KEEPERBONDED647(address indexed keeper, uint block, uint activated, uint bond);	//inject NONSTANDARD NAMING

                                
    event KEEPERUNBONDING556(address indexed keeper, uint block, uint deactive, uint bond);	//inject NONSTANDARD NAMING

                              
    event KEEPERUNBOUND602(address indexed keeper, uint block, uint deactivated, uint bond);	//inject NONSTANDARD NAMING

                              
    event KEEPERSLASHED412(address indexed keeper, address indexed slasher, uint block, uint slash);	//inject NONSTANDARD NAMING

                               
    event KEEPERDISPUTE615(address indexed keeper, uint block);	//inject NONSTANDARD NAMING

                               
    event KEEPERRESOLVED375(address indexed keeper, uint block);	//inject NONSTANDARD NAMING

    event ADDCREDIT188(address indexed credit, address indexed job, address indexed creditor, uint block, uint amount);	//inject NONSTANDARD NAMING

                                                
    uint constant public bond875 = 3 days;	//inject NONSTANDARD NAMING
                                                                     
    uint constant public unbond293 = 14 days;	//inject NONSTANDARD NAMING
                                                  
    uint constant public liquiditybond59 = 3 days;	//inject NONSTANDARD NAMING

                                         
    uint constant public fee898 = 30;	//inject NONSTANDARD NAMING
    uint constant public base419 = 10000;	//inject NONSTANDARD NAMING

                                              
    address constant public eth194 = address(0xE);	//inject NONSTANDARD NAMING

                                                  
    mapping(address => mapping(address => uint)) public bondings;
                                                    
    mapping(address => mapping(address => uint)) public unbondings;
                                            
    mapping(address => mapping(address => uint)) public partialUnbonding;
                                                         
    mapping(address => mapping(address => uint)) public pendingbonds;
                                                   
    mapping(address => mapping(address => uint)) public bonds;
                                                              
    mapping(address => uint) public votes;

                                                    
    uint public totalBonded = 0;
                                                         
    mapping(address => uint) public firstSeen;

                                                        
    mapping(address => bool) public disputes;

                                                      
    mapping(address => uint) public lastJob;
                                                            
    mapping(address => uint) public workCompleted;
                                                                 
    mapping(address => bool) public jobs;
                                                      
    mapping(address => mapping(address => uint)) public credits;
                                                        
    mapping(address => mapping(address => mapping(address => uint))) public liquidityProvided;
                                        
    mapping(address => mapping(address => mapping(address => uint))) public liquidityUnbonding;
                                           
    mapping(address => mapping(address => mapping(address => uint))) public liquidityAmountsUnbonding;
                                  
    mapping(address => uint) public jobProposalDelay;
                                    
    mapping(address => mapping(address => mapping(address => uint))) public liquidityApplied;
                                         
    mapping(address => mapping(address => mapping(address => uint))) public liquidityAmount;

                                           
    mapping(address => bool) public keepers;
                                                               
    mapping(address => bool) public blacklist;

                                                                               
    address[] public keeperList;
                                                                            
    address[] public jobList;

                                                              
    address public governance;
    address public pendingGovernance;

                                                                     
    mapping(address => bool) public liquidityAccepted;

    address[] public liquidityPairs;

    uint internal _gasUsed;

    constructor(address _kph) public {
        // Set governance for this token
        governance = msg.sender;
        DOMAINSEPARATOR = keccak256(abi.encode(domain_typehash648, keccak256(bytes(name59)), _GETCHAINID109(), address(this)));
        KPRH = IKperNetworkHelper(_kph);
    }

                                                                                                                       
    function ADDCREDITETH565(address job) external payable {	//inject NONSTANDARD NAMING
        require(jobs[job], "addCreditETH: !job");
        uint _fee = msg.value.MUL249(fee898).DIV270(base419);
        credits[job][eth194] = credits[job][eth194].ADD750(msg.value.SUB186(_fee));
        payable(governance).transfer(_fee);

        emit ADDCREDIT188(eth194, job, msg.sender, block.number, msg.value);
    }

                                                                                                                                                                                                                                              
    function ADDCREDIT18(address credit, address job, uint amount) external NONREENTRANT577 {	//inject NONSTANDARD NAMING
        require(jobs[job], "addCreditETH: !job");
        uint _before = IERC20(credit).BALANCEOF653(address(this));
        IERC20(credit).SAFETRANSFERFROM429(msg.sender, address(this), amount);
        uint _received = IERC20(credit).BALANCEOF653(address(this)).SUB186(_before);
        uint _fee = _received.MUL249(fee898).DIV270(base419);
        credits[job][credit] = credits[job][credit].ADD750(_received.SUB186(_fee));
        IERC20(credit).SAFETRANSFER297(governance, _fee);

        emit ADDCREDIT188(credit, job, msg.sender, block.number, _received);
    }

                                                                                                                                                     
    function ADDVOTES465(address voter, uint amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "addVotes: !gov");
        _ACTIVATE236(voter, address(this));
        votes[voter] = votes[voter].ADD750(amount);
        totalBonded = totalBonded.ADD750(amount);
        _MOVEDELEGATES153(address(0), delegates[voter], amount);
    }

                                                                                                                                                             
    function REMOVEVOTES245(address voter, uint amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "addVotes: !gov");
        votes[voter] = votes[voter].SUB186(amount);
        totalBonded = totalBonded.SUB186(amount);
        _MOVEDELEGATES153(delegates[voter], address(0), amount);
    }

                                                                                                                                                                                    
    function ADDKPRCREDIT8(address job, uint amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "addKPRCredit: !gov");
        require(jobs[job], "addKPRCredit: !job");
        credits[job][address(this)] = credits[job][address(this)].ADD750(amount);
        _MINT726(address(this), amount);
        emit ADDCREDIT188(address(this), job, msg.sender, block.number, amount);
    }

                                                                                                                                             
    function APPROVELIQUIDITY363(address liquidity) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "approveLiquidity: !gov");
        require(!liquidityAccepted[liquidity], "approveLiquidity: !pair");
        liquidityAccepted[liquidity] = true;
        liquidityPairs.push(liquidity);
    }

                                                                                                                                             
    function REVOKELIQUIDITY704(address liquidity) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "revokeLiquidity: !gov");
        liquidityAccepted[liquidity] = false;
    }

                                                                    
    function PAIRS99() external view returns (address[] memory) {	//inject NONSTANDARD NAMING
        return liquidityPairs;
    }

                                                                                                                                                                                                                                   
    function ADDLIQUIDITYTOJOB689(address liquidity, address job, uint amount) external NONREENTRANT577 {	//inject NONSTANDARD NAMING
        require(liquidityAccepted[liquidity], "addLiquidityToJob: !pair");
        IERC20(liquidity).SAFETRANSFERFROM429(msg.sender, address(this), amount);
        liquidityProvided[msg.sender][liquidity][job] = liquidityProvided[msg.sender][liquidity][job].ADD750(amount);

        liquidityApplied[msg.sender][liquidity][job] = now.ADD750(liquiditybond59);
        liquidityAmount[msg.sender][liquidity][job] = liquidityAmount[msg.sender][liquidity][job].ADD750(amount);

        if (!jobs[job] && jobProposalDelay[job] < now) {
            IGovernance(governance).PROPOSEJOB67(job);
            jobProposalDelay[job] = now.ADD750(unbond293);
        }
        emit SUBMITJOB626(job, liquidity, msg.sender, block.number, amount);
    }

                                                                                                                                                                                                                                                         
    function APPLYCREDITTOJOB508(address provider, address liquidity, address job) external {	//inject NONSTANDARD NAMING
        require(liquidityAccepted[liquidity], "addLiquidityToJob: !pair");
        require(liquidityApplied[provider][liquidity][job] != 0, "credit: no bond");
        require(liquidityApplied[provider][liquidity][job] < now, "credit: bonding");
        uint _liquidity = KperNetworkLibrary.GETRESERVE107(liquidity, address(this));
        uint _credit = _liquidity.MUL249(liquidityAmount[provider][liquidity][job]).DIV270(IERC20(liquidity).TOTALSUPPLY402());
        _MINT726(address(this), _credit);
        credits[job][address(this)] = credits[job][address(this)].ADD750(_credit);
        liquidityAmount[provider][liquidity][job] = 0;

        emit APPLYCREDIT477(job, liquidity, provider, block.number, _credit);
    }

                                                                                                                                                                                                                
    function UNBONDLIQUIDITYFROMJOB746(address liquidity, address job, uint amount) external {	//inject NONSTANDARD NAMING
        require(liquidityAmount[msg.sender][liquidity][job] == 0, "credit: pending credit");
        liquidityUnbonding[msg.sender][liquidity][job] = now.ADD750(unbond293);
        liquidityAmountsUnbonding[msg.sender][liquidity][job] = liquidityAmountsUnbonding[msg.sender][liquidity][job].ADD750(amount);
        require(liquidityAmountsUnbonding[msg.sender][liquidity][job] <= liquidityProvided[msg.sender][liquidity][job], "unbondLiquidityFromJob: insufficient funds");

        uint _liquidity = KperNetworkLibrary.GETRESERVE107(liquidity, address(this));
        uint _credit = _liquidity.MUL249(amount).DIV270(IERC20(liquidity).TOTALSUPPLY402());
        if (_credit > credits[job][address(this)]) {
            _BURN941(address(this), credits[job][address(this)]);
            credits[job][address(this)] = 0;
        } else {
            _BURN941(address(this), _credit);
            credits[job][address(this)] = credits[job][address(this)].SUB186(_credit);
        }

        emit UNBONDJOB739(job, liquidity, msg.sender, block.number, amount);
    }

                                                                                                                                                                         
    function REMOVELIQUIDITYFROMJOB500(address liquidity, address job) external {	//inject NONSTANDARD NAMING
        require(liquidityUnbonding[msg.sender][liquidity][job] != 0, "removeJob: unbond");
        require(liquidityUnbonding[msg.sender][liquidity][job] < now, "removeJob: unbonding");
        uint _amount = liquidityAmountsUnbonding[msg.sender][liquidity][job];
        liquidityProvided[msg.sender][liquidity][job] = liquidityProvided[msg.sender][liquidity][job].SUB186(_amount);
        liquidityAmountsUnbonding[msg.sender][liquidity][job] = 0;
        IERC20(liquidity).SAFETRANSFER297(msg.sender, _amount);

        emit REMOVEJOB82(job, liquidity, msg.sender, block.number, _amount);
    }

                                                                                                                                             
    function MINT553(uint amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "mint: !gov");
        _MINT726(governance, amount);
    }

                                                                                                  
    function BURN246(uint amount) external {	//inject NONSTANDARD NAMING
        _BURN941(msg.sender, amount);
    }

    function _MINT726(address dst, uint amount) internal {	//inject NONSTANDARD NAMING
        // mint the amount
        totalSupply = totalSupply.ADD750(amount);
        // transfer the amount to the recipient
        balances[dst] = balances[dst].ADD750(amount);
        emit TRANSFER881(address(0), dst, amount);
    }

    function _BURN941(address dst, uint amount) internal {	//inject NONSTANDARD NAMING
        require(dst != address(0), "_burn: zero address");
        balances[dst] = balances[dst].SUB186(amount, "_burn: exceeds balance");
        totalSupply = totalSupply.SUB186(amount);
        emit TRANSFER881(dst, address(0), amount);
    }

                                                                                                                                                          
    function WORKED503(address keeper) external {	//inject NONSTANDARD NAMING
        WORKRECEIPT237(keeper, KPRH.GETQUOTELIMIT193(_gasUsed.SUB186(gasleft())));
    }

                                                                                                                                                                                                                   
    function WORKRECEIPT237(address keeper, uint amount) public {	//inject NONSTANDARD NAMING
        require(jobs[msg.sender], "workReceipt: !job");
        require(amount <= KPRH.GETQUOTELIMIT193(_gasUsed.SUB186(gasleft())), "workReceipt: max limit");
        credits[msg.sender][address(this)] = credits[msg.sender][address(this)].SUB186(amount, "workReceipt: insuffient funds");
        lastJob[keeper] = now;
        _REWARD950(keeper, amount);
        workCompleted[keeper] = workCompleted[keeper].ADD750(amount);
        emit KEEPERWORKED480(address(this), msg.sender, keeper, block.number, amount);
    }

                                                                                                                                                                                                                                                                              
    function RECEIPT523(address credit, address keeper, uint amount) external {	//inject NONSTANDARD NAMING
        require(jobs[msg.sender], "receipt: !job");
        credits[msg.sender][credit] = credits[msg.sender][credit].SUB186(amount, "workReceipt: insuffient funds");
        lastJob[keeper] = now;
        IERC20(credit).SAFETRANSFER297(keeper, amount);
        emit KEEPERWORKED480(credit, msg.sender, keeper, block.number, amount);
    }

                                                                                                                                                                                                                    
    function RECEIPTETH18(address keeper, uint amount) external {	//inject NONSTANDARD NAMING
        require(jobs[msg.sender], "receipt: !job");
        credits[msg.sender][eth194] = credits[msg.sender][eth194].SUB186(amount, "workReceipt: insuffient funds");
        lastJob[keeper] = now;
        payable(keeper).transfer(amount);
        emit KEEPERWORKED480(eth194, msg.sender, keeper, block.number, amount);
    }

    function _REWARD950(address _from, uint _amount) internal {	//inject NONSTANDARD NAMING
        bonds[_from][address(this)] = bonds[_from][address(this)].ADD750(_amount);
        totalBonded = totalBonded.ADD750(_amount);
        _MOVEDELEGATES153(address(0), delegates[_from], _amount);
        emit TRANSFER881(msg.sender, _from, _amount);
    }

    function _BOND529(address bonding, address _from, uint _amount) internal {	//inject NONSTANDARD NAMING
        bonds[_from][bonding] = bonds[_from][bonding].ADD750(_amount);
        if (bonding == address(this)) {
            totalBonded = totalBonded.ADD750(_amount);
            _MOVEDELEGATES153(address(0), delegates[_from], _amount);
        }
    }

    function _UNBOND647(address bonding, address _from, uint _amount) internal {	//inject NONSTANDARD NAMING
        bonds[_from][bonding] = bonds[_from][bonding].SUB186(_amount);
        if (bonding == address(this)) {
            totalBonded = totalBonded.SUB186(_amount);
            _MOVEDELEGATES153(delegates[_from], address(0), _amount);
        }

    }

                                                                                                                                                    
    function ADDJOB840(address job) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "addJob: !gov");
        require(!jobs[job], "addJob: job known");
        jobs[job] = true;
        jobList.push(job);
        emit JOBADDED910(job, block.number, msg.sender);
    }

                                                                                            
    function GETJOBS254() external view returns (address[] memory) {	//inject NONSTANDARD NAMING
        return jobList;
    }

                                                                                                                                                              
    function REMOVEJOB380(address job) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "removeJob: !gov");
        jobs[job] = false;
        emit JOBREMOVED937(job, block.number, msg.sender);
    }

                                                                                                                                     
    function SETKPERNETWORKHELPER865(IKperNetworkHelper _kprh) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "setKperNetworkHelper: !gov");
        KPRH = _kprh;
    }

                                                                                                                                                        
    function SETGOVERNANCE939(address _governance) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "setGovernance: !gov");
        pendingGovernance = _governance;
    }

                                                                                                               
    function ACCEPTGOVERNANCE630() external {	//inject NONSTANDARD NAMING
        require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
        governance = pendingGovernance;
    }

                                                                                                                                                                                                                                     
    function ISKEEPER927(address keeper) external returns (bool) {	//inject NONSTANDARD NAMING
        _gasUsed = gasleft();
        return keepers[keeper];
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function ISMINKEEPER163(address keeper, uint minBond, uint earned, uint age) external returns (bool) {	//inject NONSTANDARD NAMING
        _gasUsed = gasleft();
        return keepers[keeper]
                && bonds[keeper][address(this)].ADD750(votes[keeper]) >= minBond
                && workCompleted[keeper] >= earned
                && now.SUB186(firstSeen[keeper]) >= age;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function ISBONDEDKEEPER241(address keeper, address bond, uint minBond, uint earned, uint age) external returns (bool) {	//inject NONSTANDARD NAMING
        _gasUsed = gasleft();
        return keepers[keeper]
                && bonds[keeper][bond] >= minBond
                && workCompleted[keeper] >= earned
                && now.SUB186(firstSeen[keeper]) >= age;
    }

                                                                                                                                                                                  
    function BOND260(address bonding, uint amount) external NONREENTRANT577 {	//inject NONSTANDARD NAMING
        require(!blacklist[msg.sender], "bond: blacklisted");
        bondings[msg.sender][bonding] = now.ADD750(bond875);
        if (bonding == address(this)) {
            _TRANSFERTOKENS224(msg.sender, address(this), amount);
        } else {
            uint _before = IERC20(bonding).BALANCEOF653(address(this));
            IERC20(bonding).SAFETRANSFERFROM429(msg.sender, address(this), amount);
            amount = IERC20(bonding).BALANCEOF653(address(this)).SUB186(_before);
        }
        pendingbonds[msg.sender][bonding] = pendingbonds[msg.sender][bonding].ADD750(amount);
        emit KEEPERBONDING674(msg.sender, block.number, bondings[msg.sender][bonding], amount);
    }

                                                                     
    function GETKEEPERS116() external view returns (address[] memory) {	//inject NONSTANDARD NAMING
        return keeperList;
    }

                                                                                                                                                               
    function ACTIVATE41(address bonding) external {	//inject NONSTANDARD NAMING
        require(!blacklist[msg.sender], "activate: blacklisted");
        require(bondings[msg.sender][bonding] != 0 && bondings[msg.sender][bonding] < now, "activate: bonding");
        _ACTIVATE236(msg.sender, bonding);
    }
    
    function _ACTIVATE236(address keeper, address bonding) internal {	//inject NONSTANDARD NAMING
        if (firstSeen[keeper] == 0) {
          firstSeen[keeper] = now;
          keeperList.push(keeper);
          lastJob[keeper] = now;
        }
        keepers[keeper] = true;
        _BOND529(bonding, keeper, pendingbonds[keeper][bonding]);
        pendingbonds[keeper][bonding] = 0;
        emit KEEPERBONDED647(keeper, block.number, block.timestamp, bonds[keeper][bonding]);
    }

                                                                                                                                                                                 
    function UNBOND442(address bonding, uint amount) external {	//inject NONSTANDARD NAMING
        unbondings[msg.sender][bonding] = now.ADD750(unbond293);
        _UNBOND647(bonding, msg.sender, amount);
        partialUnbonding[msg.sender][bonding] = partialUnbonding[msg.sender][bonding].ADD750(amount);
        emit KEEPERUNBONDING556(msg.sender, block.number, unbondings[msg.sender][bonding], amount);
    }

                                                                                                                                            
    function WITHDRAW592(address bonding) external NONREENTRANT577 {	//inject NONSTANDARD NAMING
        require(unbondings[msg.sender][bonding] != 0 && unbondings[msg.sender][bonding] < now, "withdraw: unbonding");
        require(!disputes[msg.sender], "withdraw: disputes");

        if (bonding == address(this)) {
            _TRANSFERTOKENS224(address(this), msg.sender, partialUnbonding[msg.sender][bonding]);
        } else {
            IERC20(bonding).SAFETRANSFER297(msg.sender, partialUnbonding[msg.sender][bonding]);
        }
        emit KEEPERUNBOUND602(msg.sender, block.number, block.timestamp, partialUnbonding[msg.sender][bonding]);
        partialUnbonding[msg.sender][bonding] = 0;
    }

                                                                                                                                   
    function DISPUTE590(address keeper) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "dispute: !gov");
        disputes[keeper] = true;
        emit KEEPERDISPUTE615(keeper, block.number);
    }

                                                                                                                                                                                                                               
    function SLASH39(address bonded, address keeper, uint amount) public NONREENTRANT577 {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "slash: !gov");
        if (bonded == address(this)) {
            _TRANSFERTOKENS224(address(this), governance, amount);
        } else {
            IERC20(bonded).SAFETRANSFER297(governance, amount);
        }
        _UNBOND647(bonded, keeper, amount);
        disputes[keeper] = false;
        emit KEEPERSLASHED412(keeper, msg.sender, block.number, amount);
    }

                                                                                                                                   
    function REVOKE253(address keeper) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "slash: !gov");
        keepers[keeper] = false;
        blacklist[keeper] = true;
        SLASH39(address(this), keeper, bonds[keeper][address(this)]);
    }

                                                                                                                          
    function RESOLVE476(address keeper) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "resolve: !gov");
        disputes[keeper] = false;
        emit KEEPERRESOLVED375(keeper, block.number);
    }

                                                                                                                                                                                                                                                                                                 
    function ALLOWANCE619(address account, address spender) external view returns (uint) {	//inject NONSTANDARD NAMING
        return allowances[account][spender];
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function APPROVE305(address spender, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        allowances[msg.sender][spender] = amount;

        emit APPROVAL173(msg.sender, spender, amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function PERMIT744(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {	//inject NONSTANDARD NAMING
        bytes32 structHash = keccak256(abi.encode(permit_typehash982, owner, spender, amount, nonces[owner]++, deadline));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "permit: signature");
        require(signatory == owner, "permit: unauthorized");
        require(now <= deadline, "permit: expired");

        allowances[owner][spender] = amount;

        emit APPROVAL173(owner, spender, amount);
    }

                                                                                                                                                                                             
    function BALANCEOF653(address account) external view returns (uint) {	//inject NONSTANDARD NAMING
        return balances[account];
    }

                                                                                                                                                                                                                                                      
    function TRANSFER134(address dst, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFERTOKENS224(msg.sender, dst, amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                   
    function TRANSFERFROM0(address src, address dst, uint amount) external returns (bool) {	//inject NONSTANDARD NAMING
        address spender = msg.sender;
        uint spenderAllowance = allowances[src][spender];

        if (spender != src && spenderAllowance != uint(-1)) {
            uint newAllowance = spenderAllowance.SUB186(amount, "transferFrom: exceeds spender allowance");
            allowances[src][spender] = newAllowance;

            emit APPROVAL173(src, spender, newAllowance);
        }

        _TRANSFERTOKENS224(src, dst, amount);
        return true;
    }

    function _TRANSFERTOKENS224(address src, address dst, uint amount) internal {	//inject NONSTANDARD NAMING
        require(src != address(0), "_transferTokens: zero address");
        require(dst != address(0), "_transferTokens: zero address");

        balances[src] = balances[src].SUB186(amount, "_transferTokens: exceeds balance");
        balances[dst] = balances[dst].ADD750(amount, "_transferTokens: overflows");
        emit TRANSFER881(src, dst, amount);
    }

    function _GETCHAINID109() internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint chainId;
        assembly { chainId := chainid() }
        return chainId;
    }
}