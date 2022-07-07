                                                                 

                                                                 

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
pragma solidity ^0.5.17;


                                                                         
library Math {
                                                               
    function MAX540(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a >= b ? a : b;
    }

                                                                
    function MIN509(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a < b ? a : b;
    }

                                                                                                          
    function AVERAGE579(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: @openzeppelin/contracts/math/SafeMath.sol


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD537(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB533(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB533(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                                                             
    function SUB533(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL899(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV732(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV732(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function DIV732(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD804(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD804(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function MOD804(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/GSN/Context.sol


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER75() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA657() internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/ownership/Ownable.sol



                                                                                                                                                                                                                                                                                                                                                                        
contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED138(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        _owner = _MSGSENDER75();
        emit OWNERSHIPTRANSFERRED138(address(0), _owner);
    }

                                                                     
    function OWNER313() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER471() {	//inject NONSTANDARD NAMING
        require(ISOWNER999(), "Ownable: caller is not the owner");
        _;
    }

                                                                            
    function ISOWNER999() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _MSGSENDER75() == _owner;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP459() public ONLYOWNER471 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED138(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP87(address newOwner) public ONLYOWNER471 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP967(newOwner);
    }

                                                                                              
    function _TRANSFEROWNERSHIP967(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED138(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

                                                                                                                                                      
interface IERC20 {

    function MINT669(address account, uint amount) external;	//inject NONSTANDARD NAMING
                                                                      
    function TOTALSUPPLY186() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF689(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER213(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE163(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE444(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM175(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER653(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL189(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity ^0.5.5;

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT844(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                          
    function TOPAYABLE974(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function SENDVALUE557(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.5.0;




                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER881(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN468(token, abi.encodeWithSelector(token.TRANSFER213.selector, to, value));
    }

    function SAFETRANSFERFROM203(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN468(token, abi.encodeWithSelector(token.TRANSFERFROM175.selector, from, to, value));
    }

    function SAFEAPPROVE790(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE163(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN468(token, abi.encodeWithSelector(token.APPROVE444.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE320(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE163(address(this), spender).ADD537(value);
        CALLOPTIONALRETURN468(token, abi.encodeWithSelector(token.APPROVE444.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE576(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE163(address(this), spender).SUB533(value, "SafeERC20: decreased allowance below zero");
        CALLOPTIONALRETURN468(token, abi.encodeWithSelector(token.APPROVE444.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function CALLOPTIONALRETURN468(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).ISCONTRACT844(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts/IRewardDistributionRecipient.sol

pragma solidity ^0.5.0;



contract IRewardDistributionRecipient is Ownable {
    address rewardDistribution = 0x45a6b8BdfC1FAa745720165e0B172A3D6D4EC897;

    function NOTIFYREWARDAMOUNT985() external;	//inject NONSTANDARD NAMING

    modifier ONLYREWARDDISTRIBUTION252() {	//inject NONSTANDARD NAMING
        require(_MSGSENDER75() == rewardDistribution, "Caller is not reward distribution");
        _;
    }

    function SETREWARDDISTRIBUTION691(address _rewardDistribution)	//inject NONSTANDARD NAMING
        external
        ONLYOWNER471
    {
        rewardDistribution = _rewardDistribution;
    }
}

// File: contracts/CurveRewards.sol

pragma solidity ^0.5.0;






pragma solidity ^0.5.17;
contract LPTokenWrapper {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public vamp_lp = IERC20(0x7dd8f4ABF60b58CE989DB66aB1af1d11E893429D); //vamp_lp mainnet 

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    function TOTALSUPPLY186() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

    function BALANCEOF689(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

    function STAKE760(uint256 amount) public {	//inject NONSTANDARD NAMING
        _totalSupply = _totalSupply.ADD537(amount);
        _balances[msg.sender] = _balances[msg.sender].ADD537(amount);
        vamp_lp.SAFETRANSFERFROM203(msg.sender, address(this), amount);
    }

    function WITHDRAW940(uint256 amount) public {	//inject NONSTANDARD NAMING
        _totalSupply = _totalSupply.SUB533(amount);
        _balances[msg.sender] = _balances[msg.sender].SUB533(amount);
        vamp_lp.SAFETRANSFER881(msg.sender, amount);
    }
}

contract VMANAVAMPPool is LPTokenWrapper, IRewardDistributionRecipient {
    IERC20 public vamp = IERC20(0xb2C822a1b923E06Dbd193d2cFc7ad15388EA09DD); //vmana
    uint256 public DURATION = 7 days;
    uint256 public initreward = 801419450000000000000000;
    uint256 public starttime = 1603573200; //1 hour after vmana ends
    uint256 public periodFinish = 0;
    uint256 public rewardRate = 0;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;
    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    event REWARDADDED399(uint256 reward);	//inject NONSTANDARD NAMING
    event STAKED507(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event WITHDRAWN5(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event REWARDPAID848(address indexed user, uint256 reward);	//inject NONSTANDARD NAMING

    modifier UPDATEREWARD996(address account) {	//inject NONSTANDARD NAMING
        rewardPerTokenStored = REWARDPERTOKEN216();
        lastUpdateTime = LASTTIMEREWARDAPPLICABLE527();
        if (account != address(0)) {
            rewards[account] = EARNED802(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    function LASTTIMEREWARDAPPLICABLE527() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return Math.MIN509(block.timestamp, periodFinish);
    }

    function REWARDPERTOKEN216() public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (TOTALSUPPLY186() == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored.ADD537(
                LASTTIMEREWARDAPPLICABLE527()
                    .SUB533(lastUpdateTime)
                    .MUL899(rewardRate)
                    .MUL899(1e18)
                    .DIV732(TOTALSUPPLY186())
            );
    }

    function EARNED802(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return
            BALANCEOF689(account)
                .MUL899(REWARDPERTOKEN216().SUB533(userRewardPerTokenPaid[account]))
                .DIV732(1e18)
                .ADD537(rewards[account]);
    }

    // stake visibility is public as overriding LPTokenWrapper's stake() function
    function STAKE760(uint256 amount) public UPDATEREWARD996(msg.sender)  CHECKSTART317{	//inject NONSTANDARD NAMING
        require(amount > 0, "Cannot stake 0");
        super.STAKE760(amount);
        emit STAKED507(msg.sender, amount);
    }

    function WITHDRAW940(uint256 amount) public UPDATEREWARD996(msg.sender) {	//inject NONSTANDARD NAMING
        require(amount > 0, "Cannot withdraw 0");
        super.WITHDRAW940(amount);
        emit WITHDRAWN5(msg.sender, amount);
    }

    function EXIT850() external {	//inject NONSTANDARD NAMING
        WITHDRAW940(BALANCEOF689(msg.sender));
        GETREWARD327();
    }

    function GETREWARD327() public UPDATEREWARD996(msg.sender)  {	//inject NONSTANDARD NAMING
        uint256 reward = EARNED802(msg.sender);
        if (reward > 0) {
            rewards[msg.sender] = 0;
            vamp.SAFETRANSFER881(msg.sender, reward);
            emit REWARDPAID848(msg.sender, reward);
        }
    }

    function AFTEREND949() public ONLYREWARDDISTRIBUTION252 { //if any tokens left, transfer to contract owner for further distriubtion to community	//inject NONSTANDARD NAMING
        require(block.timestamp > periodFinish);
        vamp.SAFETRANSFER881(msg.sender,vamp.BALANCEOF689(address(this)));
    }

    
    modifier CHECKSTART317(){	//inject NONSTANDARD NAMING
        require(block.timestamp > starttime,"not start");
        _;
    }

    function NOTIFYREWARDAMOUNT985()	//inject NONSTANDARD NAMING
        external
        ONLYREWARDDISTRIBUTION252
        UPDATEREWARD996(address(0))
    {
        if (block.timestamp >= periodFinish) {
            rewardRate = initreward.DIV732(DURATION);
        } else {
            uint256 remaining = periodFinish.SUB533(block.timestamp);
            uint256 leftover = remaining.MUL899(rewardRate);
            rewardRate = initreward.ADD537(leftover).DIV732(DURATION);
        }
        //vamp.mint(address(this),initreward);
        lastUpdateTime = block.timestamp;
        periodFinish = starttime.ADD537(DURATION);
        emit REWARDADDED399(initreward);
    }
}