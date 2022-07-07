                                                                 

// SPDX-License-Identifier: GPL-3.0-or-later

                                                                                                                                                                                               

pragma solidity 0.6.12;


// 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD864(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB868(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB868(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB868(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL988(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV926(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV926(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV926(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD713(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD713(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD713(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

// 
// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function SAFEAPPROVE567(address token, address to, uint value) internal {	//inject NONSTANDARD NAMING
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function SAFETRANSFER962(address token, address to, uint value) internal {	//inject NONSTANDARD NAMING
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function SAFETRANSFERFROM567(address token, address from, address to, uint value) internal {	//inject NONSTANDARD NAMING
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function SAFETRANSFERETH46(address to, uint value) internal {	//inject NONSTANDARD NAMING
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}

// 
                                                                         
library Math {
                                                               
    function MAX98(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a >= b ? a : b;
    }

                                                                
    function MIN757(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a < b ? a : b;
    }

                                                                                                          
    function AVERAGE252(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
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
    uint256 private constant _not_entered371 = 1;	//inject NONSTANDARD NAMING
    uint256 private constant _entered907 = 2;	//inject NONSTANDARD NAMING

    uint256 private _status;

    constructor () internal {
        _status = _not_entered371;
    }

                                                                                                                                                                                                                                                                                                                                                                                
    modifier NONREENTRANT361() {	//inject NONSTANDARD NAMING
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _entered907, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _entered907;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _not_entered371;
    }
}

// 
interface ICoFiXStakingRewards {
    // Views

                                                                       
                                         
    function REWARDSVAULT139() external view returns (address);	//inject NONSTANDARD NAMING

                                            
                                                        
    function LASTBLOCKREWARDAPPLICABLE573() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                          
    function REWARDPERTOKEN122() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                
                                          
                                                         
    function EARNED893(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                    
                                                            
    function ACCRUED168() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                     
                                      
    function REWARDRATE36() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                            
                                                                         
    function TOTALSUPPLY567() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                           
                                          
                                                                        
    function BALANCEOF980(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                     
                                         
    function STAKINGTOKEN641() external view returns (address);	//inject NONSTANDARD NAMING

                                                                     
                                         
    function REWARDSTOKEN657() external view returns (address);	//inject NONSTANDARD NAMING

    // Mutative

                                                             
                                        
    function STAKE225(uint256 amount) external;	//inject NONSTANDARD NAMING

                                                                               
                                        
                                        
    function STAKEFOROTHER357(address other, uint256 amount) external;	//inject NONSTANDARD NAMING

                                                                                      
                                        
    function WITHDRAW360(uint256 amount) external;	//inject NONSTANDARD NAMING

                                                                   
    function EMERGENCYWITHDRAW536() external;	//inject NONSTANDARD NAMING

                                             
    function GETREWARD438() external;	//inject NONSTANDARD NAMING

    function GETREWARDANDSTAKE43() external;	//inject NONSTANDARD NAMING

                                                                            
    function EXIT912() external;	//inject NONSTANDARD NAMING

                                          
    function ADDREWARD881(uint256 amount) external;	//inject NONSTANDARD NAMING

    // Events
    event REWARDADDED378(address sender, uint256 reward);	//inject NONSTANDARD NAMING
    event STAKED268(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event STAKEDFOROTHER964(address indexed user, address indexed other, uint256 amount);	//inject NONSTANDARD NAMING
    event WITHDRAWN805(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event EMERGENCYWITHDRAW7(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event REWARDPAID501(address indexed user, uint256 reward);	//inject NONSTANDARD NAMING
}

// 
interface ICoFiXVaultForLP {

    enum POOL_STATE {INVALID, ENABLED, DISABLED}

    event NEWPOOLADDED559(address pool, uint256 index);	//inject NONSTANDARD NAMING
    event POOLENABLED434(address pool);	//inject NONSTANDARD NAMING
    event POOLDISABLED539(address pool);	//inject NONSTANDARD NAMING

    function SETGOVERNANCE394(address _new) external;	//inject NONSTANDARD NAMING
    function SETINITCOFIRATE698(uint256 _new) external;	//inject NONSTANDARD NAMING
    function SETDECAYPERIOD166(uint256 _new) external;	//inject NONSTANDARD NAMING
    function SETDECAYRATE667(uint256 _new) external;	//inject NONSTANDARD NAMING

    function ADDPOOL220(address pool) external;	//inject NONSTANDARD NAMING
    function ENABLEPOOL504(address pool) external;	//inject NONSTANDARD NAMING
    function DISABLEPOOL836(address pool) external;	//inject NONSTANDARD NAMING
    function SETPOOLWEIGHT937(address pool, uint256 weight) external;	//inject NONSTANDARD NAMING
    function BATCHSETPOOLWEIGHT100(address[] memory pools, uint256[] memory weights) external;	//inject NONSTANDARD NAMING
    function DISTRIBUTEREWARD70(address to, uint256 amount) external;	//inject NONSTANDARD NAMING

    function GETPENDINGREWARDOFLP590(address pair) external view returns (uint256);	//inject NONSTANDARD NAMING
    function CURRENTPERIOD82() external view returns (uint256);	//inject NONSTANDARD NAMING
    function CURRENTCOFIRATE163() external view returns (uint256);	//inject NONSTANDARD NAMING
    function CURRENTPOOLRATE277(address pool) external view returns (uint256 poolRate);	//inject NONSTANDARD NAMING
    function CURRENTPOOLRATEBYPAIR255(address pair) external view returns (uint256 poolRate);	//inject NONSTANDARD NAMING

                                                                
                                                         
                                     
    function STAKINGPOOLFORPAIR714(address pair) external view returns (address pool);	//inject NONSTANDARD NAMING

    function GETPOOLINFO427(address pool) external view returns (POOL_STATE state, uint256 weight);	//inject NONSTANDARD NAMING
    function GETPOOLINFOBYPAIR166(address pair) external view returns (POOL_STATE state, uint256 weight);	//inject NONSTANDARD NAMING

    function GETENABLEDPOOLCNT412() external view returns (uint256);	//inject NONSTANDARD NAMING

    function GETCOFISTAKINGPOOL12() external view returns (address pool);	//inject NONSTANDARD NAMING

}

// 
                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY567() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF980(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER204(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE758(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE960(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM982(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER211(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL330(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// 
interface ICoFiStakingRewards {
    // Views

                                                          
    function REWARDPERTOKEN122() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                
                                          
                                                         
    function EARNED893(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                    
                                                            
    function ACCRUED168() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                             
                                                                          
    function TOTALSUPPLY567() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                           
                                          
                                                                         
    function BALANCEOF980(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                      
                                         
    function STAKINGTOKEN641() external view returns (address);	//inject NONSTANDARD NAMING

                                                                      
                                         
    function REWARDSTOKEN657() external view returns (address);	//inject NONSTANDARD NAMING

    // Mutative

                                                              
                                        
    function STAKE225(uint256 amount) external;	//inject NONSTANDARD NAMING

                                                                                
                                        
                                        
    function STAKEFOROTHER357(address other, uint256 amount) external;	//inject NONSTANDARD NAMING

                                                                                       
                                        
    function WITHDRAW360(uint256 amount) external;	//inject NONSTANDARD NAMING
    
                                                                   
    function EMERGENCYWITHDRAW536() external;	//inject NONSTANDARD NAMING

                                             
    function GETREWARD438() external;	//inject NONSTANDARD NAMING

                                               
    function ADDETHREWARD660() external payable;	//inject NONSTANDARD NAMING

                                                                            
    function EXIT912() external;	//inject NONSTANDARD NAMING

    // Events
    event STAKED268(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event STAKEDFOROTHER964(address indexed user, address indexed other, uint256 amount);	//inject NONSTANDARD NAMING
    event WITHDRAWN805(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event SAVINGWITHDRAWN125(address indexed to, uint256 amount);	//inject NONSTANDARD NAMING
    event EMERGENCYWITHDRAW7(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event REWARDPAID501(address indexed user, uint256 reward);	//inject NONSTANDARD NAMING
    
}

// 
interface ICoFiXFactory {
    // All pairs: {ETH <-> ERC20 Token}
    event PAIRCREATED889(address indexed token, address pair, uint256);	//inject NONSTANDARD NAMING
    event NEWGOVERNANCE470(address _new);	//inject NONSTANDARD NAMING
    event NEWCONTROLLER331(address _new);	//inject NONSTANDARD NAMING
    event NEWFEERECEIVER222(address _new);	//inject NONSTANDARD NAMING
    event NEWFEEVAULTFORLP508(address token, address feeVault);	//inject NONSTANDARD NAMING
    event NEWVAULTFORLP769(address _new);	//inject NONSTANDARD NAMING
    event NEWVAULTFORTRADER72(address _new);	//inject NONSTANDARD NAMING
    event NEWVAULTFORCNODE372(address _new);	//inject NONSTANDARD NAMING

                                                
                                                   
                                                  
    function CREATEPAIR976(	//inject NONSTANDARD NAMING
        address token
        )
        external
        returns (address pair);

    function GETPAIR599(address token) external view returns (address pair);	//inject NONSTANDARD NAMING
    function ALLPAIRS153(uint256) external view returns (address pair);	//inject NONSTANDARD NAMING
    function ALLPAIRSLENGTH789() external view returns (uint256);	//inject NONSTANDARD NAMING

    function GETTRADEMININGSTATUS473(address token) external view returns (bool status);	//inject NONSTANDARD NAMING
    function SETTRADEMININGSTATUS493(address token, bool status) external;	//inject NONSTANDARD NAMING
    function GETFEEVAULTFORLP473(address token) external view returns (address feeVault); // for LPs	//inject NONSTANDARD NAMING
    function SETFEEVAULTFORLP669(address token, address feeVault) external;	//inject NONSTANDARD NAMING

    function SETGOVERNANCE394(address _new) external;	//inject NONSTANDARD NAMING
    function SETCONTROLLER726(address _new) external;	//inject NONSTANDARD NAMING
    function SETFEERECEIVER908(address _new) external;	//inject NONSTANDARD NAMING
    function SETVAULTFORLP99(address _new) external;	//inject NONSTANDARD NAMING
    function SETVAULTFORTRADER40(address _new) external;	//inject NONSTANDARD NAMING
    function SETVAULTFORCNODE20(address _new) external;	//inject NONSTANDARD NAMING
    function GETCONTROLLER295() external view returns (address controller);	//inject NONSTANDARD NAMING
    function GETFEERECEIVER766() external view returns (address feeReceiver); // For CoFi Holders	//inject NONSTANDARD NAMING
    function GETVAULTFORLP604() external view returns (address vaultForLP);	//inject NONSTANDARD NAMING
    function GETVAULTFORTRADER901() external view returns (address vaultForTrader);	//inject NONSTANDARD NAMING
    function GETVAULTFORCNODE682() external view returns (address vaultForCNode);	//inject NONSTANDARD NAMING
}

// 
// Stake XToken to earn CoFi Token
contract CoFiXStakingRewards is ICoFiXStakingRewards, ReentrancyGuard {
    using SafeMath for uint256;

                                               

    address public override immutable rewardsToken; // CoFi
    address public override immutable stakingToken; // XToken or CNode

    address public immutable factory;

    uint256 public lastUpdateBlock;
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

                                           

    constructor(
        address _rewardsToken,
        address _stakingToken,
        address _factory
    ) public {
        rewardsToken = _rewardsToken;
        stakingToken = _stakingToken;
        require(ICoFiXFactory(_factory).GETVAULTFORLP604() != address(0), "VaultForLP not set yet"); // check
        factory = _factory;
        lastUpdateBlock = 11040688; // https://etherscan.io/block/countdown/11040688    
    }

                                     

    // replace cofixVault with rewardsVault, this could introduce more calls, but clear is more important 
    function REWARDSVAULT139() public virtual override view returns (address) {	//inject NONSTANDARD NAMING
        return ICoFiXFactory(factory).GETVAULTFORLP604();
    }

    function TOTALSUPPLY567() external override view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

    function BALANCEOF980(address account) external override view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

    function LASTBLOCKREWARDAPPLICABLE573() public override view returns (uint256) {	//inject NONSTANDARD NAMING
        return block.number;
    }

    function REWARDPERTOKEN122() public override view returns (uint256) {	//inject NONSTANDARD NAMING
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored.ADD864(
                ACCRUED168().MUL988(1e18).DIV926(_totalSupply)
            );
    }

    function _REWARDPERTOKENANDACCRUED426() internal view returns (uint256, uint256) {	//inject NONSTANDARD NAMING
        if (_totalSupply == 0) {
            // use the old rewardPerTokenStored, and accrued should be zero here
            // if not the new accrued amount will never be distributed to anyone
            return (rewardPerTokenStored, 0);
        }
        uint256 _accrued = ACCRUED168();
        uint256 _rewardPerToken = rewardPerTokenStored.ADD864(
                _accrued.MUL988(1e18).DIV926(_totalSupply)
            );
        return (_rewardPerToken, _accrued);
    }

    function REWARDRATE36() public virtual override view returns (uint256) {	//inject NONSTANDARD NAMING
        return ICoFiXVaultForLP(REWARDSVAULT139()).CURRENTPOOLRATE277(address(this));
    }

    function ACCRUED168() public virtual override view returns (uint256) {	//inject NONSTANDARD NAMING
        // calc block rewards
        uint256 blockReward = LASTBLOCKREWARDAPPLICABLE573().SUB868(lastUpdateBlock).MUL988(REWARDRATE36());
        // query pair trading rewards
        uint256 tradingReward = ICoFiXVaultForLP(REWARDSVAULT139()).GETPENDINGREWARDOFLP590(stakingToken);
        return blockReward.ADD864(tradingReward);
    }

    function EARNED893(address account) public override view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account].MUL988(REWARDPERTOKEN122().SUB868(userRewardPerTokenPaid[account])).DIV926(1e18).ADD864(rewards[account]);
    }

                                                  

    function STAKE225(uint256 amount) external override NONREENTRANT361 UPDATEREWARD178(msg.sender) {	//inject NONSTANDARD NAMING
        require(amount > 0, "Cannot stake 0");
        _totalSupply = _totalSupply.ADD864(amount);
        _balances[msg.sender] = _balances[msg.sender].ADD864(amount);
        TransferHelper.SAFETRANSFERFROM567(stakingToken, msg.sender, address(this), amount);
        emit STAKED268(msg.sender, amount);
    }

    function STAKEFOROTHER357(address other, uint256 amount) external override NONREENTRANT361 UPDATEREWARD178(other) {	//inject NONSTANDARD NAMING
        require(amount > 0, "Cannot stake 0");
        _totalSupply = _totalSupply.ADD864(amount);
        _balances[other] = _balances[other].ADD864(amount);
        TransferHelper.SAFETRANSFERFROM567(stakingToken, msg.sender, address(this), amount);
        emit STAKEDFOROTHER964(msg.sender, other, amount);
    }

    function WITHDRAW360(uint256 amount) public override NONREENTRANT361 UPDATEREWARD178(msg.sender) {	//inject NONSTANDARD NAMING
        require(amount > 0, "Cannot withdraw 0");
        _totalSupply = _totalSupply.SUB868(amount);
        _balances[msg.sender] = _balances[msg.sender].SUB868(amount);
        TransferHelper.SAFETRANSFER962(stakingToken, msg.sender, amount);
        emit WITHDRAWN805(msg.sender, amount);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function EMERGENCYWITHDRAW536() external override NONREENTRANT361 {	//inject NONSTANDARD NAMING
        uint256 amount = _balances[msg.sender];
        require(amount > 0, "Cannot withdraw 0");
        _totalSupply = _totalSupply.SUB868(amount);
        _balances[msg.sender] = 0;
        rewards[msg.sender] = 0;
        TransferHelper.SAFETRANSFER962(stakingToken, msg.sender, amount);
        emit EMERGENCYWITHDRAW7(msg.sender, amount);
    }

    function GETREWARD438() public override NONREENTRANT361 UPDATEREWARD178(msg.sender) {	//inject NONSTANDARD NAMING
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            // TransferHelper.safeTransfer(rewardsToken, msg.sender, reward);
            uint256 transferred = _SAFECOFITRANSFER191(msg.sender, reward);
            emit REWARDPAID501(msg.sender, transferred);
        }
    }

    // get CoFi rewards and staking into CoFiStakingRewards pool
    function GETREWARDANDSTAKE43() external override NONREENTRANT361 UPDATEREWARD178(msg.sender) {	//inject NONSTANDARD NAMING
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            address cofiStakingPool = ICoFiXVaultForLP(REWARDSVAULT139()).GETCOFISTAKINGPOOL12(); // also work for VaultForCNode
            require(cofiStakingPool != address(0), "cofiStakingPool not set");
            // approve to staking pool
            address _rewardsToken = rewardsToken;
            IERC20(_rewardsToken).APPROVE960(cofiStakingPool, reward);
            ICoFiStakingRewards(cofiStakingPool).STAKEFOROTHER357(msg.sender, reward);
            IERC20(_rewardsToken).APPROVE960(cofiStakingPool, 0); // ensure
            emit REWARDPAID501(msg.sender, reward);
        }
    }

    function EXIT912() external override {	//inject NONSTANDARD NAMING
        WITHDRAW360(_balances[msg.sender]);
        GETREWARD438();
    }

    // add reward from trading pool or anyone else
    function ADDREWARD881(uint256 amount) public override NONREENTRANT361 UPDATEREWARD178(address(0)) {	//inject NONSTANDARD NAMING
        // transfer from caller (router contract)
        TransferHelper.SAFETRANSFERFROM567(rewardsToken, msg.sender, address(this), amount);
        // update rewardPerTokenStored
        rewardPerTokenStored = rewardPerTokenStored.ADD864(amount.MUL988(1e18).DIV926(_totalSupply));
        emit REWARDADDED378(msg.sender, amount);
    }

    // Safe CoFi transfer function, just in case if rounding error or ending of mining causes pool to not have enough CoFis.
    function _SAFECOFITRANSFER191(address _to, uint256 _amount) internal returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 cofiBal = IERC20(rewardsToken).BALANCEOF980(address(this));
        if (_amount > cofiBal) {
            _amount = cofiBal;
        }
        TransferHelper.SAFETRANSFER962(rewardsToken, _to, _amount); // allow zero amount
        return _amount;
    }

                                         

    modifier UPDATEREWARD178(address account) virtual {	//inject NONSTANDARD NAMING
        // rewardPerTokenStored = rewardPerToken();
        // uint256 newAccrued = accrued();
        (uint256 newRewardPerToken, uint256 newAccrued) = _REWARDPERTOKENANDACCRUED426();
        rewardPerTokenStored = newRewardPerToken;
        if (newAccrued > 0) {
            // distributeReward could fail if CoFiXVaultForLP is not minter of CoFi anymore
            // Should set reward rate to zero first, and then do a settlement of pool reward by call getReward
            ICoFiXVaultForLP(REWARDSVAULT139()).DISTRIBUTEREWARD70(address(this), newAccrued);
        } 
        lastUpdateBlock = LASTBLOCKREWARDAPPLICABLE573();
        if (account != address(0)) {
            rewards[account] = EARNED893(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

                                      

    event REWARDADDED378(address sender, uint256 reward);	//inject NONSTANDARD NAMING
    event STAKED268(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event STAKEDFOROTHER964(address indexed user, address indexed other, uint256 amount);	//inject NONSTANDARD NAMING
    event WITHDRAWN805(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event EMERGENCYWITHDRAW7(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    event REWARDPAID501(address indexed user, uint256 reward);	//inject NONSTANDARD NAMING
}