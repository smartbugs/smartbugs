/*

 Copyright 2017-2019 RigoBlock, Rigo Investment Sagl.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

*/

pragma solidity 0.5.2;

contract Pool {
    
    address public owner;

    /*
     * CONSTANT PUBLIC FUNCTIONS
     */
    function balanceOf(address _who) external view returns (uint256);
    function totalSupply() external view returns (uint256 totaSupply);
    function getEventful() external view returns (address);
    function getData() external view returns (string memory name, string memory symbol, uint256 sellPrice, uint256 buyPrice);
    function calcSharePrice() external view returns (uint256);
    function getAdminData() external view returns (address, address feeCollector, address dragodAO, uint256 ratio, uint256 transactionFee, uint32 minPeriod);
}

contract SafeMath {

    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b > 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c>=a && c>=b);
        return c;
    }

    function max64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a < b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}

contract RigoToken {

    address public minter;
    uint256 public totalSupply;
    
    function balanceOf(address _who) external view returns (uint256);
}

interface DragoRegistry {

    //EVENTS

    event Registered(string name, string symbol, uint256 id, address indexed drago, address indexed owner, address indexed group);
    event Unregistered(string indexed name, string indexed symbol, uint256 indexed id);
    event MetaChanged(uint256 indexed id, bytes32 indexed key, bytes32 value);

    /*
     * CORE FUNCTIONS
     */
    function register(address _drago, string calldata _name, string calldata _symbol, uint256 _dragoId, address _owner) external payable returns (bool);
    function unregister(uint256 _id) external;
    function setMeta(uint256 _id, bytes32 _key, bytes32 _value) external;
    function addGroup(address _group) external;
    function setFee(uint256 _fee) external;
    function updateOwner(uint256 _id) external;
    function updateOwners(uint256[] calldata _id) external;
    function upgrade(address _newAddress) external payable; //payable as there is a transfer of value, otherwise opcode might throw an error
    function setUpgraded(uint256 _version) external;
    function drain() external;

    /*
     * CONSTANT PUBLIC FUNCTIONS
     */
    function dragoCount() external view returns (uint256);
    function fromId(uint256 _id) external view returns (address drago, string memory name, string memory symbol, uint256 dragoId, address owner, address group);
    function fromAddress(address _drago) external view returns (uint256 id, string memory name, string memory symbol, uint256 dragoId, address owner, address group);
    function fromName(string calldata _name) external view returns (uint256 id, address drago, string memory symbol, uint256 dragoId, address owner, address group);
    function getNameFromAddress(address _pool) external view returns (string memory);
    function getSymbolFromAddress(address _pool) external view returns (string memory);
    function meta(uint256 _id, bytes32 _key) external view returns (bytes32);
    function getGroups() external view returns (address[] memory);
    function getFee() external view returns (uint256);
}

interface Inflation {

    /*
     * CORE FUNCTIONS
     */
    function mintInflation(address _thePool, uint256 _reward) external returns (bool);
    function setInflationFactor(address _group, uint256 _inflationFactor) external;
    function setMinimumRigo(uint256 _minimum) external;
    function setRigoblock(address _newRigoblock) external;
    function setAuthority(address _authority) external;
    function setProofOfPerformance(address _pop) external;
    function setPeriod(uint256 _newPeriod) external;

    /*
     * CONSTANT PUBLIC FUNCTIONS
     */
    function canWithdraw(address _thePool) external view returns (bool);
    function getInflationFactor(address _group) external view returns (uint256);
}

contract ReentrancyGuard {

    // Locked state of mutex
    bool private locked = false;

    /// @dev Functions with this modifer cannot be reentered. The mutex will be locked
    ///      before function execution and unlocked after.
    modifier nonReentrant() {
        // Ensure mutex is unlocked
        require(
            !locked,
            "REENTRANCY_ILLEGAL"
        );

        // Lock mutex before function call
        locked = true;

        // Perform function call
        _;

        // Unlock mutex after function call
        locked = false;
    }
}

interface ProofOfPerformanceFace {

    /*
     * CORE FUNCTIONS
     */
    function claimPop(uint256 _ofPool) external;
    function setRegistry(address _dragoRegistry) external;
    function setRigoblockDao(address _rigoblockDao) external;
    function setRatio(address _ofGroup, uint256 _ratio) external;

    /*
     * CONSTANT PUBLIC FUNCTIONS
     */
    function getPoolData(uint256 _ofPool)
        external view
        returns (
            bool active,
            address thePoolAddress,
            address thePoolGroup,
            uint256 thePoolPrice,
            uint256 thePoolSupply,
            uint256 poolValue,
            uint256 epochReward,
            uint256 ratio,
            uint256 pop
        );

    function getHwm(uint256 _ofPool) external view returns (uint256);
}

/// @title Proof of Performance - Controls parameters of inflation.
/// @author Gabriele Rigo - <gab@rigoblock.com>
// solhint-disable-next-line
contract ProofOfPerformance is
    SafeMath,
    ReentrancyGuard,
    ProofOfPerformanceFace
{
    address public RIGOTOKENADDRESS;

    address public dragoRegistry;
    address public rigoblockDao;

    mapping (uint256 => PoolPrice) poolPrice;
    mapping (address => Group) groups;

    struct PoolPrice {
        uint256 highwatermark;
    }

    struct Group {
        uint256 rewardRatio;
    }

    modifier onlyRigoblockDao() {
        require(
            tx.origin == rigoblockDao,	//inject USING TX ORIGIN FOR AUTHENTICATION

            "ONLY_RIGOBLOCK_DAO"
        );
        _;
    }

    constructor(
        address _rigoTokenAddress,
        address _rigoblockDao,
        address _dragoRegistry)
        public
    {
        RIGOTOKENADDRESS = _rigoTokenAddress;
        rigoblockDao = _rigoblockDao;
        dragoRegistry = _dragoRegistry;
    }

    /*
     * CORE FUNCTIONS
     */
    /// @dev Allows anyone to allocate the pop reward to pool wizards.
    /// @param _ofPool Number of pool id in registry.
    function claimPop(uint256 _ofPool)
        external
        nonReentrant
    {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        address poolAddress;
        (poolAddress, , , , , ) = registry.fromId(_ofPool);
        uint256 pop = proofOfPerformanceInternal(_ofPool);
        require(
            pop > 0,
            "POP_REWARD_IS_NULL"
        );
        (uint256 price, ) = getPoolPriceInternal(_ofPool);
        poolPrice[_ofPool].highwatermark = price;
        require(
            Inflation(getMinter()).mintInflation(poolAddress, pop),
            "MINT_INFLATION_ERROR"
        );
    }

    /// @dev Allows RigoBlock Dao to update the pools registry.
    /// @param _dragoRegistry Address of new registry.
    function setRegistry(address _dragoRegistry)
        external
        onlyRigoblockDao
    {
        dragoRegistry = _dragoRegistry;
    }

    /// @dev Allows RigoBlock Dao to update its address.
    /// @param _rigoblockDao Address of new dao.
    function setRigoblockDao(address _rigoblockDao)
        external
        onlyRigoblockDao
    {
        rigoblockDao = _rigoblockDao;
    }

    /// @dev Allows RigoBlock Dao to set the ratio between assets and performance reward for a group.
    /// @param _ofGroup Id of the pool.
    /// @param _ratio Id of the pool.
    /// @notice onlyRigoblockDao can set ratio.
    function setRatio(
        address _ofGroup,
        uint256 _ratio)
        external
        onlyRigoblockDao
    {
        require(
            _ratio <= 10000,
            "RATIO_BIGGER_THAN_10000"
        ); //(from 0 to 10000)
        groups[_ofGroup].rewardRatio = _ratio;
    }

    /*
     * CONSTANT PUBLIC FUNCTIONS
     */
    /// @dev Gets data of a pool.
    /// @param _ofPool Id of the pool.
    /// @return Bool the pool is active.
    /// @return address of the pool.
    /// @return address of the pool factory.
    /// @return price of the pool in wei.
    /// @return total supply of the pool in units.
    /// @return total value of the pool in wei.
    /// @return value of the reward factor or said pool.
    /// @return ratio of assets/performance reward (from 0 to 10000).
    /// @return value of the pop reward to be claimed in GRGs.
    function getPoolData(uint256 _ofPool)
        external
        view
        returns (
            bool active,
            address thePoolAddress,
            address thePoolGroup,
            uint256 thePoolPrice,
            uint256 thePoolSupply,
            uint256 poolValue,
            uint256 epochReward,
            uint256 ratio,
            uint256 pop
        )
    {
        active = isActiveInternal(_ofPool);
        (thePoolAddress, thePoolGroup) = addressFromIdInternal(_ofPool);
        (thePoolPrice, thePoolSupply) = getPoolPriceInternal(_ofPool);
        (poolValue, ) = calcPoolValueInternal(_ofPool);
        epochReward = getEpochRewardInternal(_ofPool);
        ratio = getRatioInternal(_ofPool);
        pop = proofOfPerformanceInternal(_ofPool);
        return(
            active,
            thePoolAddress,
            thePoolGroup,
            thePoolPrice,
            thePoolSupply,
            poolValue,
            epochReward,
            ratio,
            pop
        );
    }

    /// @dev Returns the highwatermark of a pool.
    /// @param _ofPool Id of the pool.
    /// @return Value of the all-time-high pool nav.
    function getHwm(uint256 _ofPool)
        external
        view
        returns (uint256)
    {
        return poolPrice[_ofPool].highwatermark;
    }
    
    /// @dev Returns the reward factor for a pool.
    /// @param _ofPool Id of the pool.
    /// @return Value of the reward factor.
    function getEpochReward(uint256 _ofPool)
        external
        view
        returns (uint256)
    {
        return getEpochRewardInternal(_ofPool);
    }

    /// @dev Returns the split ratio of asset and performance reward.
    /// @param _ofPool Id of the pool.
    /// @return Value of the ratio from 1 to 100.
    function getRatio(uint256 _ofPool)
        external
        view
        returns (uint256)
    {
        return getRatioInternal(_ofPool);
    }
    
    /// @dev Returns the proof of performance reward for a pool.
    /// @param _ofPool Id of the pool.
    /// @return Value of the reward in Rigo tokens.
    /// @notice epoch reward should be big enough that it.
    /// @notice can be decreased if number of funds increases.
    /// @notice should be at least 10^6 (just as pool base) to start with.
    /// @notice rigo token has 10^18 decimals.
    function proofOfPerformance(uint256 _ofPool)
        external
        view
        returns (uint256)
    {
        return proofOfPerformanceInternal(_ofPool);
    }
    
    /// @dev Checks whether a pool is registered and active.
    /// @param _ofPool Id of the pool.
    /// @return Bool the pool is active.
    function isActive(uint256 _ofPool)
        external
        view
        returns (bool)
    {
        return isActiveInternal(_ofPool);
    }

    /// @dev Returns the address and the group of a pool from its id.
    /// @param _ofPool Id of the pool.
    /// @return Address of the target pool.
    /// @return Address of the pool's group.
    function addressFromId(uint256 _ofPool)
        external
        view
        returns (
            address pool,
            address group
        )
    {
        return (addressFromIdInternal(_ofPool));
    }

    /// @dev Returns the price a pool from its id.
    /// @param _ofPool Id of the pool.
    /// @return Price of the pool in wei.
    /// @return Number of tokens of a pool (totalSupply).
    function getPoolPrice(uint256 _ofPool)
        external
        view
        returns (
            uint256 thePoolPrice,
            uint256 totalTokens
        )
    {
        return (getPoolPriceInternal(_ofPool));
    }

    /// @dev Returns the address and the group of a pool from its id.
    /// @param _ofPool Id of the pool.
    /// @return Address of the target pool.
    /// @return Address of the pool's group.
    function calcPoolValue(uint256 _ofPool)
        external
        view
        returns (
            uint256 aum,
            bool success
        )
    {
        return (calcPoolValueInternal(_ofPool));
    }

    /*
     * INTERNAL FUNCTIONS
     */
    /// @dev Returns the reward factor for a pool.
    /// @param _ofPool Id of the pool.
    /// @return Value of the reward factor.
    function getEpochRewardInternal(uint256 _ofPool)
        internal
        view
        returns (uint256)
    {
        ( , address group) = addressFromIdInternal(_ofPool);
        return Inflation(getMinter()).getInflationFactor(group);
    }

    /// @dev Returns the split ratio of asset and performance reward.
    /// @param _ofPool Id of the pool.
    /// @return Value of the ratio from 1 to 100.
    function getRatioInternal(uint256 _ofPool)
        internal
        view
        returns (uint256)
    {
        ( , address group) = addressFromIdInternal(_ofPool);
        return groups[group].rewardRatio;
    }

    /// @dev Returns the address of the Inflation contract.
    /// @return Address of the minter/inflation.
    function getMinter()
        internal
        view
        returns (address)
    {
        RigoToken token = RigoToken(RIGOTOKENADDRESS);
        return token.minter();
    }

    /// @dev Returns the proof of performance reward for a pool.
    /// @param _ofPool Id of the pool.
    /// @return Value of the reward in Rigo tokens.
    /// @notice epoch reward should be big enough that it.
    /// @notice can be decreased if number of funds increases.
    /// @notice should be at least 10^6 (just as pool base) to start with.
    /// @notice rigo token has 10^18 decimals.
    function proofOfPerformanceInternal(uint256 _ofPool)
        internal
        view
        returns (uint256)
    {
        uint256 highwatermark = 1000 ether; //initialize variable with arbitrarily high value
        if (poolPrice[_ofPool].highwatermark == 0) {
            highwatermark = 1 ether;
        } else {
            highwatermark = poolPrice[_ofPool].highwatermark;
        }
        (uint256 poolValue, ) = calcPoolValueInternal(_ofPool);
        require(
            poolValue != 0,
            "POOL_VALUE_NULL"
        );
        (uint256 newPrice, uint256 tokenSupply) = getPoolPriceInternal(_ofPool);
        require (
            newPrice >= highwatermark,
            "PRICE_LOWER_THAN_HWM"
        );
        require (
            tokenSupply > 0,
            "TOKEN_SUPPLY_NULL"
        );

        uint256 epochReward = 0;
        (address thePoolAddress, ) = addressFromIdInternal(_ofPool);
        uint256 grgBalance = 
            RigoToken(RIGOTOKENADDRESS)
            .balanceOf(
                Pool(thePoolAddress)
                .owner()
        );
        if (grgBalance >= 1 * 10 ** 18) {
            epochReward = safeMul(getEpochRewardInternal(_ofPool), 10); // 10x reward if wizard holds 1 GRG
        } else {
            epochReward = getEpochRewardInternal(_ofPool);
        }

        uint256 rewardRatio = getRatioInternal(_ofPool);
        uint256 prevPrice = highwatermark;
        uint256 priceDiff = safeSub(newPrice, prevPrice);
        uint256 performanceComponent = safeMul(safeMul(priceDiff, tokenSupply), epochReward);
        uint256 performanceReward = safeDiv(safeMul(performanceComponent, rewardRatio), 10000 ether);
        uint256 assetsComponent = safeMul(poolValue, epochReward);
        uint256 assetsReward = safeDiv(safeMul(assetsComponent, safeSub(10000, rewardRatio)), 10000 ether);
        uint256 popReward = safeAdd(performanceReward, assetsReward);
        if (popReward >= safeDiv(RigoToken(RIGOTOKENADDRESS).totalSupply(), 10000)) {
            return (safeDiv(RigoToken(RIGOTOKENADDRESS).totalSupply(), 10000));
        } else {
            return (popReward);
        }
    }

    /// @dev Checks whether a pool is registered and active.
    /// @param _ofPool Id of the pool.
    /// @return Bool the pool is active.
    function isActiveInternal(uint256 _ofPool)
        internal view
        returns (bool)
    {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        (address thePool, , , , , ) = registry.fromId(_ofPool);
        if (thePool != address(0)) {
            return true;
        }
    }

    /// @dev Returns the address and the group of a pool from its id.
    /// @param _ofPool Id of the pool.
    /// @return Address of the target pool.
    /// @return Address of the pool's group.
    function addressFromIdInternal(uint256 _ofPool)
        internal
        view
        returns (
            address pool,
            address group
        )
    {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        (pool, , , , , group) = registry.fromId(_ofPool);
        return (pool, group);
    }

    /// @dev Returns the price a pool from its id.
    /// @param _ofPool Id of the pool.
    /// @return Price of the pool in wei.
    /// @return Number of tokens of a pool (totalSupply).
    function getPoolPriceInternal(uint256 _ofPool)
        internal
        view
        returns (
            uint256 thePoolPrice,
            uint256 totalTokens
        )
    {
        (address poolAddress, ) = addressFromIdInternal(_ofPool);
        Pool pool = Pool(poolAddress);
        thePoolPrice = pool.calcSharePrice();
        totalTokens = pool.totalSupply();
    }

    /// @dev Returns the address and the group of a pool from its id.
    /// @param _ofPool Id of the pool.
    /// @return Address of the target pool.
    /// @return Address of the pool's group.
    function calcPoolValueInternal(uint256 _ofPool)
        internal
        view
        returns (
            uint256 aum,
            bool success
        )
    {
        (uint256 price, uint256 supply) = getPoolPriceInternal(_ofPool);
        return ((aum = (price * supply / 1000000)), true); //1000000 is the base (decimals)
    }
}