                                                                 

// File: @openzeppelin/contracts/math/Math.sol

pragma solidity 0.5.16;

                                                                         
library Math {
                                                               
    function MAX818(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a >= b ? a : b;
    }

                                                                
    function MIN910(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a < b ? a : b;
    }

                                                                                                          
    function AVERAGE710(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity 0.5.16;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD553(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB354(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB354(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                                                             
    function SUB354(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL618(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV720(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV720(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function DIV720(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD811(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD811(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function MOD811(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/GSN/Context.sol

pragma solidity 0.5.16;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER101() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA729() internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/ownership/Ownable.sol

pragma solidity 0.5.16;

                                                                                                                                                                                                                                                                                                                                                                        
contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED297(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        _owner = _MSGSENDER101();
        emit OWNERSHIPTRANSFERRED297(address(0), _owner);
    }

                                                                     
    function OWNER579() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER471() {	//inject NONSTANDARD NAMING
        require(ISOWNER602(), "Ownable: caller is not the owner");
        _;
    }

                                                                            
    function ISOWNER602() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _MSGSENDER101() == _owner;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP987() public ONLYOWNER471 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED297(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP49(address newOwner) public ONLYOWNER471 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP728(newOwner);
    }

                                                                                              
    function _TRANSFEROWNERSHIP728(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED297(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity 0.5.16;

                                                                                                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY250() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF938(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER79(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function MINT2(address account, uint amount) external;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE644(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE576(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM482(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER160(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL369(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity 0.5.16;

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT625(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

                                                                                                                                                                                                          
    function TOPAYABLE310(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function SENDVALUE700(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

pragma solidity 0.5.16;




                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER546(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN509(token, abi.encodeWithSelector(token.TRANSFER79.selector, to, value));
    }

    function SAFETRANSFERFROM6(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN509(token, abi.encodeWithSelector(token.TRANSFERFROM482.selector, from, to, value));
    }

    function SAFEAPPROVE811(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE644(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN509(token, abi.encodeWithSelector(token.APPROVE576.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE917(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE644(address(this), spender).ADD553(value);
        CALLOPTIONALRETURN509(token, abi.encodeWithSelector(token.APPROVE576.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE400(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE644(address(this), spender).SUB354(value, "SafeERC20: decreased allowance below zero");
        CALLOPTIONALRETURN509(token, abi.encodeWithSelector(token.APPROVE576.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function CALLOPTIONALRETURN509(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).ISCONTRACT625(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

                                  
pragma solidity 0.5.16;

contract IRewardDistributionRecipient is Ownable {
    address rewardDistribution;

    function NOTIFYREWARDAMOUNT190(uint256 reward) external;	//inject NONSTANDARD NAMING

    modifier ONLYREWARDDISTRIBUTION587() {	//inject NONSTANDARD NAMING
        require(_MSGSENDER101() == rewardDistribution, "Caller is not reward distribution");
        _;
    }

    function SETREWARDDISTRIBUTION306(address _rewardDistribution)	//inject NONSTANDARD NAMING
        external
        ONLYOWNER471
    {
        rewardDistribution = _rewardDistribution;
    }
}

                                
pragma solidity 0.5.16;

contract GOFTokenWrapper {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public stakeToken = IERC20(0x514910771AF9Ca656af840dff83E8264EcF986CA);

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    function TOTALSUPPLY250() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

    function BALANCEOF938(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

    function STAKE102(uint256 amount) public {	//inject NONSTANDARD NAMING
        _totalSupply = _totalSupply.ADD553(amount);
        _balances[msg.sender] = _balances[msg.sender].ADD553(amount);
        stakeToken.SAFETRANSFERFROM6(msg.sender, address(this), amount);
    }

    function WITHDRAW201(uint256 amount) public {	//inject NONSTANDARD NAMING
        _totalSupply = _totalSupply.SUB354(amount);
        _balances[msg.sender] = _balances[msg.sender].SUB354(amount);
        stakeToken.SAFETRANSFER546(msg.sender, amount);
    }
}

                    
pragma solidity 0.5.16;

contract GOFLINKPool is GOFTokenWrapper, IRewardDistributionRecipient {
    IERC20 public gof = IERC20(0x488E0369f9BC5C40C002eA7c1fe4fd01A198801c);
    uint256 public constant duration144 = 7 days;	//inject NONSTANDARD NAMING

    uint256 public constant starttime308 = 1599652800; //utc+8 2020-09-09 20:00:00	//inject NONSTANDARD NAMING
    uint256 public periodFinish = 0;
    uint256 public rewardRate = 0;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored  = 0;
    bool private open = true;
    uint256 private constant _gunit942 = 1e18;	//inject NONSTANDARD NAMING
    mapping(address => uint256) public userRewardPerTokenPaid; 
    mapping(address => uint256) public rewards; // Unclaimed rewards

    event REWARDADDED578(uint256 reward);	//inject NONSTANDARD NAMING
    event STAKED569(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event WITHDRAWN869(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event REWARDPAID604(address indexed user, uint256 reward);	//inject NONSTANDARD NAMING
    event SETOPEN70(bool _open);	//inject NONSTANDARD NAMING

    modifier UPDATEREWARD304(address account) {	//inject NONSTANDARD NAMING
        rewardPerTokenStored = REWARDPERTOKEN70();
        lastUpdateTime = LASTTIMEREWARDAPPLICABLE508();
        if (account != address(0)) {
            rewards[account] = EARNED147(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    function LASTTIMEREWARDAPPLICABLE508() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return Math.MIN910(block.timestamp, periodFinish);
    }

                                                           
    function REWARDPERTOKEN70() public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (TOTALSUPPLY250() == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored.ADD553(
                LASTTIMEREWARDAPPLICABLE508()
                    .SUB354(lastUpdateTime)
                    .MUL618(rewardRate)
                    .MUL618(_gunit942)
                    .DIV720(TOTALSUPPLY250())
            );
    }

    function EARNED147(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return
            BALANCEOF938(account)
                .MUL618(REWARDPERTOKEN70().SUB354(userRewardPerTokenPaid[account]))
                .DIV720(_gunit942)
                .ADD553(rewards[account]);
    }

    function STAKE102(uint256 amount) public CHECKOPEN514 CHECKSTART795 UPDATEREWARD304(msg.sender){ 	//inject NONSTANDARD NAMING
        require(amount > 0, "Golff-Link-POOL: Cannot stake 0");
        super.STAKE102(amount);
        emit STAKED569(msg.sender, amount);
    }

    function WITHDRAW201(uint256 amount) public CHECKSTART795 UPDATEREWARD304(msg.sender){	//inject NONSTANDARD NAMING
        require(amount > 0, "Golff-Link-POOL: Cannot withdraw 0");
        super.WITHDRAW201(amount);
        emit WITHDRAWN869(msg.sender, amount);
    }

    function EXIT662() external {	//inject NONSTANDARD NAMING
        WITHDRAW201(BALANCEOF938(msg.sender));
        GETREWARD668();
    }

    function GETREWARD668() public CHECKSTART795 UPDATEREWARD304(msg.sender){	//inject NONSTANDARD NAMING
        uint256 reward = EARNED147(msg.sender);
        if (reward > 0) {
            rewards[msg.sender] = 0;
            gof.SAFETRANSFER546(msg.sender, reward);
            emit REWARDPAID604(msg.sender, reward);
        }
    }

    modifier CHECKSTART795(){	//inject NONSTANDARD NAMING
        require(block.timestamp > starttime308,"Golff-Link-POOL: Not start");
        _;
    }

    modifier CHECKOPEN514() {	//inject NONSTANDARD NAMING
        require(open, "Golff-Link-POOL: Pool is closed");
        _;
    }

    function GETPERIODFINISH470() external view returns (uint256) {	//inject NONSTANDARD NAMING
        return periodFinish;
    }

    function ISOPEN95() external view returns (bool) {	//inject NONSTANDARD NAMING
        return open;
    }

    function SETOPEN315(bool _open) external ONLYOWNER471 {	//inject NONSTANDARD NAMING
        open = _open;
        emit SETOPEN70(_open);
    }

    function NOTIFYREWARDAMOUNT190(uint256 reward)	//inject NONSTANDARD NAMING
        external
        ONLYREWARDDISTRIBUTION587
        CHECKOPEN514
        UPDATEREWARD304(address(0)){
        if (block.timestamp > starttime308){
            if (block.timestamp >= periodFinish) {
                uint256 period = block.timestamp.SUB354(starttime308).DIV720(duration144).ADD553(1);
                periodFinish = starttime308.ADD553(period.MUL618(duration144));
                rewardRate = reward.DIV720(periodFinish.SUB354(block.timestamp));
            } else {
                uint256 remaining = periodFinish.SUB354(block.timestamp);
                uint256 leftover = remaining.MUL618(rewardRate);
                rewardRate = reward.ADD553(leftover).DIV720(remaining);
            }
            lastUpdateTime = block.timestamp;
        }else {
          rewardRate = reward.DIV720(duration144);
          periodFinish = starttime308.ADD553(duration144);
          lastUpdateTime = starttime308;
        }

        gof.MINT2(address(this),reward);
        emit REWARDADDED578(reward);

        // avoid overflow to lock assets
        _CHECKREWARDRATE734();
    }
    
    function _CHECKREWARDRATE734() internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return duration144.MUL618(rewardRate).MUL618(_gunit942);
    }
}