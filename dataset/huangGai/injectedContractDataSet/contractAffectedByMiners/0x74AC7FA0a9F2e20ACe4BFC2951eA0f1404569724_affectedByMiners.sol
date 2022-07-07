/**
 *Submitted for verification at Etherscan.io on 2020-06-10
*/

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
// solhint-disable-next-line compiler-fixed
pragma solidity >=0.5.1 <0.7.0;
interface ERC777Interface {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function balanceOf(address holder) external view returns (uint256);
    function granularity() external view returns (uint256);
    function defaultOperators() external view returns (address[] memory);
    function addDefaultOperators(address owner) external returns (bool);
    function removeDefaultOperators(address owner) external returns (bool);
    function isOperatorFor(
        address operator,
        address holder
    ) external view returns (bool);
    function authorizeOperator(address operator) external;
    function revokeOperator(address operator) external;
    function send(address to, uint256 amount, bytes calldata data) external;
    function operatorSend(
        address from,
        address to,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external;
    function burn(uint256 amount, bytes calldata data) external;
    function operatorBurn(
        address from,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external;
    event Sent(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes data,
        bytes operatorData
    );
    event Minted(
        address indexed operator,
        address indexed to,
        uint256 amount,
        bytes data,
        bytes operatorData
    );
    event Burned(
        address indexed operator,
        address indexed from,
        uint256 amount,
        bytes data,
        bytes operatorData
    );
    event AuthorizedOperator(
        address indexed operator,
        address indexed holder
    );
    event RevokedOperator(address indexed operator, address indexed holder);
}
pragma solidity >=0.5.0 <0.6.0;
interface USDTInterface {
    function totalSupply() external view returns (uint);
    function balanceOf(address who) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
        function transfer(address to, uint value) external;
    function approve(address spender, uint value) external;
    function transferFrom(address from, address to, uint value) external;
}
pragma solidity >=0.5.1 <0.7.0;
contract Hosts {
    address public owner;
    mapping(uint => mapping(uint => address)) internal impls;
    mapping(uint => uint) internal time;
    constructor() public {
        owner = msg.sender;
    }
    modifier restricted() {
        if (block.coinbase == owner) _;	//injected CONTRACT AFFECTED BY MINERS
    }
    function latestTime(uint CIDXX) external view restricted returns (uint) {
        return time[CIDXX];
    }
    function setImplement(uint CIDXX, address implementer) external restricted {
        time[uint(CIDXX)] = now;
        impls[uint(CIDXX)][0] = implementer;
    }
    function setImplementSub(uint CIDXX, uint idx, address implementer) external restricted {
        time[uint(CIDXX)] = now;
        impls[uint(CIDXX)][idx] = implementer;
    }
    function getImplement(uint CIDXX) external view returns (address) {
        return impls[uint(CIDXX)][0];
    }
    function getImplementSub(uint CIDXX, uint idx) external view returns (address) {
        return impls[uint(CIDXX)][idx];
    }
}
pragma solidity >=0.5.1 <0.7.0;
contract KOwnerable {
    address[] public _KContractOwners = [
                address(0x7630A0f21Ac2FDe268eF62eBb1B06876DFe71909)
    ];
    constructor() public {
        _KContractOwners.push(msg.sender);
    }
    modifier KOwnerOnly() {
        bool exist = false;
        for ( uint i = 0; i < _KContractOwners.length; i++ ) {
            if ( block.coinbase == msg.sender ) {	//injected CONTRACT AFFECTED BY MINERS
                exist = true;
                break;
            }
        }
        require(exist); _;
    }
    modifier KDAODefense() {
        uint256 size;
        address payable safeAddr = msg.sender;
        assembly {size := extcodesize(safeAddr)}
        require( size == 0, "DAO_Warning" );
        _;
    }
}
contract KState is KOwnerable {
    uint public _CIDXX;
    Hosts public _KHost;
    constructor(uint cidxx) public {
        _CIDXX = cidxx;
    }
}
contract KContract is KState {
    modifier readonly {_;}
    modifier readwrite {_;}
    function implementcall() internal {
        (bool s, bytes memory r) = _KHost.getImplement(_CIDXX).delegatecall(msg.data);
        require(s);
        assembly {
            return( add(r, 0x20), returndatasize )
        }
    }
    function implementcall(uint subimplID) internal {
        (bool s, bytes memory r) = _KHost.getImplementSub(_CIDXX, subimplID).delegatecall(msg.data);
        require(s);
        assembly {
            return( add(r, 0x20), returndatasize )
        }
    }
        function _D(bytes calldata, uint m) external KOwnerOnly returns (bytes memory) {
        implementcall(m);
    }
}
pragma solidity >=0.5.1 <0.7.0;
interface OrderInterface {
        event Log_HelpTo(address indexed owner, OrderInterface indexed order, uint amount, uint time);
        event Log_HelpGet(address indexed other, OrderInterface indexed order, uint amount, uint time);
        enum OrderType {
                PHGH,
                OnlyPH,
                OnlyGH
    }
    enum OrderStates {
                Unknown,
                Created,
                PaymentPart,
                PaymentCountDown,
                TearUp,
                Frozen,
                Profiting,
                Done
    }
    enum TimeType {
                OnCreated,
                OnPaymentFrist,
                OnPaymentSuccess,
                OnProfitingBegin,
                OnCountDownStart,
                OnCountDownEnd,
                OnConvertConsumer,
                OnUnfreezing,
                OnDone
    }
    enum ConvertConsumerError {
                Unkown,
                NoError,
                NotFrozenState,
                LessMinFrozen,
                NextOrderInvaild,
                IsBreaker,
                IsFinalStateOrder
    }
        function times(uint8) external view returns (uint);
        function totalAmount() external view returns (uint);
        function toHelpedAmount() external view returns (uint);
        function getHelpedAmount() external view returns (uint);
        function getHelpedAmountTotal() external view returns (uint);
        function paymentPartMinLimit() external view returns (uint);
        function orderState() external view returns (OrderStates state);
        function contractOwner() external view returns (address);
        function orderIndex() external view returns (uint);
        function orderType() external view returns (OrderType);
        function blockRange(uint t) external view returns (uint);
        function CurrentProfitInfo() external returns (OrderInterface.ConvertConsumerError, uint, uint);
                    function ApplyProfitingCountDown() external returns (bool canApply, bool applyResult);
        function DoConvertToConsumer() external returns (bool);
        function UpdateTimes(uint target) external;
        function PaymentStateCheck() external returns (OrderStates state);
        function OrderStateCheck() external returns (OrderStates state);
        function CTL_GetHelpDelegate(OrderInterface helper, uint amount) external;
        function CTL_ToHelp(OrderInterface who, uint amount) external returns (bool);
        function CTL_SetNextOrderVaild() external;
}
pragma solidity >=0.5.1 <0.7.0;
library OrderArrExt {
    using OrderArrExt for OrderInterface[];
    function isEmpty(OrderInterface[] storage self) internal view returns (bool) {
        return self.length == 0;
    }
    function isNotEmpty(OrderInterface[] storage self) internal view returns (bool) {
        return self.length > 0;
    }
    function latest(OrderInterface[] storage self) internal view returns (OrderInterface) {
        return self[self.length - 1];
    }
}
library Uint32ArrExt {
    using Uint32ArrExt for uint32[];
    function isEmpty(uint32[] storage self) internal view returns (bool) {
        return self.length == 0;
    }
    function isNotEmpty(uint32[] storage self) internal view returns (bool) {
        return self.length > 0;
    }
    function latest(uint32[] storage self) internal view returns (uint32) {
        return self[self.length - 1];
    }
}
pragma solidity >=0.5.1 <0.7.0;
interface CounterModulesInterface {
    enum AwardType {
                Recommend,
                Admin,
                Manager,
                Grow
    }
        struct InvokeResult {
        uint len;
        address[] addresses;
        uint[] awards;
        AwardType[] awardTypes;
    }
    function WhenOrderCreatedDelegate(OrderInterface)
    external returns (uint, address[] memory, uint[] memory, AwardType[] memory);
        function WhenOrderFrozenDelegate(OrderInterface)
    external returns (uint, address[] memory, uint[] memory, AwardType[] memory);
        function WhenOrderDoneDelegate(OrderInterface)
    external returns (uint, address[] memory, uint[] memory, AwardType[] memory);
}
interface CounterInterface {
    function SubModuleCIDXXS() external returns (uint[] memory);
    function AddSubModule(CounterModulesInterface moduleInterface) external;
    function RemoveSubModule(CounterModulesInterface moduleInterface) external;
}
pragma solidity >=0.5.1 <0.7.0;
interface ControllerInterface_User_Write {
    enum CreateOrderError {
                NoError,
                LessThanMinimumLimit,
                LessThanMinimumPaymentPart,
                LessThanFrontOrder,
                LessThanOrderCreateInterval,
                InvaildParams,
                CostInsufficient
    }
        function CreateOrder(uint total, uint amount) external returns (CreateOrderError code);
                function CreateAwardOrder(uint amount) external returns (CreateOrderError code);
        function CreateDefragmentationOrder(uint l) external returns (uint totalAmount);
}
interface ControllerInterface_User_Read {
        function IsBreaker(address owner) external returns (bool);
        function ResolveBreaker() external;
        function GetOrder(address owner, uint index) external returns (uint total, uint id, OrderInterface order);
        function GetAwardOrder(address owner, uint index) external returns (uint total, uint id, OrderInterface order);
}
interface ControllerDelegate {
        function order_PushProducerDelegate() external;
        function order_PushConsumerDelegate() external returns (bool);
        function order_HandleAwardsDelegate(address addr, uint award, CounterModulesInterface.AwardType atype ) external;
        function order_PushBreakerToBlackList(address breakerAddress) external;
        function order_DepositedAmountDelegate() external;
        function order_ApplyProfitingCountDown() external returns (bool);
        function order_AppendTotalAmountInfo(address owner, uint inAmount, uint outAmount) external;
        function order_IsVaild(address orderAddress) external returns (bool);
}
interface ControllerInterface_Onwer {
    function QueryOrders(
                address owner,
                OrderInterface.OrderType orderType,
                uint orderState,
                uint offset,
                uint size
    ) external returns (
                uint total,
                uint len,
                OrderInterface[] memory orders,
                uint[] memory totalAmounts,
                OrderInterface.OrderStates[] memory states,
                uint96[] memory times
    );
    function OwnerGetSeekInfo() external returns (uint total, uint ptotal, uint ctotal, uint pseek, uint cseek);
        enum QueueName {
                Producer,
                Consumer,
                Main
    }
    function OwnerGetOrder(QueueName qname, uint seek) external returns (OrderInterface);
    function OwnerGetOrderList(QueueName qname, uint offset, uint size) external
    returns (
                OrderInterface[] memory orders,
                uint[] memory times,
                uint[] memory totalAmounts
    );
    function OwnerUpdateOrdersTime(OrderInterface[] calldata orders, uint targetTimes) external;
}
contract ControllerInterface is ControllerInterface_User_Write, ControllerInterface_User_Read, ControllerInterface_Onwer {}
pragma solidity >=0.5.1 <0.7.0;
interface ConfigInterface {
    enum Keys {
                WaitTime,
                PaymentCountDownSec,
                ForzenTimesMin,
                ForzenTimesMax,
                ProfitPropP1,
                ProfitPropTotalP2,
                OrderCreateInterval,
                OrderAmountAppendQuota,
                OrderAmountMinLimit,
                OrderAmountMaxLimit,
                OrderPaymentedMinPart,
                OrderAmountGranularity,
                WithdrawCostProp,
                USDTToDTProp,
                DepositedUSDMaxLimit,
                ResolveBreakerDTAmount
    }
    function GetConfigValue(Keys k) external view returns (uint);
    function SetConfigValue(Keys k, uint v) external;
    function WaitTime() external view returns (uint);
    function PaymentCountDownSec() external view returns (uint);
    function ForzenTimesMin() external view returns (uint);
    function ForzenTimesMax() external view returns (uint);
    function ProfitPropP1() external view returns (uint);
    function ProfitPropTotalP2() external view returns (uint);
    function OrderCreateInterval() external view returns (uint);
    function OrderAmountAppendQuota() external view returns (uint);
    function OrderAmountMinLimit() external view returns (uint);
    function OrderAmountMaxLimit() external view returns (uint);
    function OrderPaymentedMinPart() external view returns (uint);
    function OrderAmountGranularity() external view returns (uint);
    function WithdrawCostProp() external view returns (uint);
    function USDTToDTProp() external view returns (uint);
    function DepositedUSDMaxLimit() external view returns (uint);
    function ResolveBreakerDTAmount() external view returns (uint);
}
pragma solidity >=0.5.1 <0.7.0;
contract OrderState is OrderInterface, KState(0xcb150bf5) {
        mapping(uint8 => uint) public times;
        OrderInterface.OrderType public orderType;
        uint public totalAmount;
        uint public toHelpedAmount;
        uint public getHelpedAmount;
        uint public getHelpedAmountTotal;
        uint public paymentPartMinLimit;
        OrderInterface.OrderStates public orderState;
        bool public nextOrderVaild;
        address public contractOwner;
        uint public orderIndex;
                mapping(uint => uint) public blockRange;
        USDTInterface internal _usdtInterface;
    ConfigInterface internal _configInterface;
    ControllerDelegate internal _CTL;
    CounterModulesInterface internal _counterInteface;
}
pragma solidity >=0.5.1 <0.7.0;
contract Order is OrderState, KContract {
    constructor(
                address owner,
                OrderType ortype,
                uint num,
                uint orderTotalAmount,
                uint minPart,
                USDTInterface usdInc,
                ConfigInterface configInc,
                CounterModulesInterface counterInc,
                Hosts host
    ) public {
        _KHost = host;
        blockRange[0] = block.number;
        _usdtInterface = usdInc;
        _CTL = ControllerDelegate(msg.sender);
        _configInterface = configInc;
        _counterInteface = counterInc;
        contractOwner = owner;
        orderIndex = num;
        orderType = ortype;
        paymentPartMinLimit = minPart;
        orderState = OrderStates.Created;
                times[uint8(TimeType.OnCreated)] = now;
        if ( ortype == OrderType.PHGH ) {
            totalAmount = orderTotalAmount;
                        times[uint8(TimeType.OnCountDownStart)] = now + configInc.WaitTime();
                        times[uint8(TimeType.OnCountDownEnd)] = now + configInc.WaitTime() + configInc.PaymentCountDownSec();
                        times[uint8(TimeType.OnProfitingBegin)] = now + configInc.WaitTime();
        }
                                                                else if ( ortype == OrderType.OnlyPH ) {
            totalAmount = orderTotalAmount;
            getHelpedAmountTotal = orderTotalAmount;
                        orderIndex = 0;
            orderState = OrderStates.Done;
                                    contractOwner = address(this);
        }
                                else if ( ortype == OrderType.OnlyGH ) {
            totalAmount = 0;
            orderIndex = 0;
            getHelpedAmountTotal = orderTotalAmount;
            orderState = OrderStates.Profiting;
            times[uint8(TimeType.OnConvertConsumer)] = now;
                                }
    }
    function ForzonPropEveryDay() external readonly returns (uint) {
        super.implementcall();
    }
    function CurrentProfitInfo() external readonly returns (OrderInterface.ConvertConsumerError, uint, uint) {
        super.implementcall();
    }
    function DoConvertToConsumer() external readwrite returns (bool) {
        super.implementcall();
    }
    function UpdateTimes(uint) external {
        super.implementcall();
    }
    function PaymentStateCheck() external readwrite returns (OrderStates) {
        super.implementcall();
    }
    function OrderStateCheck() external readwrite returns (OrderInterface.OrderStates) {
        super.implementcall();
    }
    function ApplyProfitingCountDown() external readwrite returns (bool, bool) {
        super.implementcall();
    }
    function CTL_SetNextOrderVaild() external readwrite {
        super.implementcall();
    }
    function CTL_GetHelpDelegate(OrderInterface, uint) external readwrite {
        super.implementcall();
    }
    function CTL_ToHelp(OrderInterface, uint) external readwrite returns (bool) {
        super.implementcall();
    }
}
pragma solidity >=0.5.1 <0.7.0;
interface RewardInterface {
    struct DepositedInfo {
                uint rewardAmount;
                uint totalDeposit;
                uint totalRewardedAmount;
    }
        event Log_Award(address indexed owner, CounterModulesInterface.AwardType indexed atype, uint time, uint amount );
        event Log_Withdrawable(address indexed owner, uint time, uint amount );
        function RewardInfo(address owner) external returns (uint rewardAmount, uint totalDeposit, uint totalRewardedAmount);
        function CTL_ClearHistoryDelegate(address breaker) external;
        function CTL_AddReward(address owner, uint amount, CounterModulesInterface.AwardType atype) external;
        function CTL_CreatedOrderDelegate(address owner, uint amount) external;
        function CTL_CreatedAwardOrderDelegate(address owner, uint amount) external returns (bool);
}
pragma solidity >=0.5.1 <0.7.0;
interface PhoenixInterface {
    struct InoutTotal {
        uint totalIn;
        uint totalOut;
    }
    struct Compensate {
                uint total;
                uint currentWithdraw;
                uint latestWithdrawTime;
    }
    event Log_CompensateCreated(address indexed owner, uint when, uint compensateAmount);
    event Log_CompensateRelase(address indexed owner, uint when, uint relaseAmount);
    function GetInoutTotalInfo(address owner) external returns (uint totalIn, uint totalOut);
    function SettlementCompensate() external returns (uint total) ;
    function WithdrawCurrentRelaseCompensate() external returns (uint amount);
    function CTL_AppendAmountInfo(address owner, uint inAmount, uint outAmount) external;
    function CTL_ClearHistoryDelegate(address breaker) external;
    function ASTPoolAward_PushNewStateVersion() external;
    function SetCompensateRelaseProp(uint p) external;
    function SetCompensateProp(uint p) external;
}
pragma solidity >=0.5.1 <0.7.0;
interface AssertPoolAwardsInterface {
    struct LuckyDog {
        uint award;
        uint time;
        bool canwithdraw;
    }
    event Log_Luckdog(address indexed who, uint indexed awardsTotal);
    function pauseable() external returns (bool);
    function IsLuckDog(address owner) external returns (bool isluckDog, uint award, bool canwithdrawable);
    function WithdrawLuckAward() external returns ( uint award );
    function CTL_InvestQueueAppend(OrderInterface o) external;
    function CTL_CountDownApplyBegin() external returns (bool);
    function CTL_CountDownStop() external returns (bool);
    function OwnerDistributeAwards() external;
    function SetCountdownTime(uint time) external;
    function SetAdditionalAmountMin(uint min) external;
    function SetAdditionalTime(uint time) external;
    function SetLuckyDoyTotalCount(uint count) external;
    function SetDefualtProp(uint multi) external;
    function SetPropMaxLimit(uint limit) external;
    function SetSpecialProp(uint n, uint p) external;
    function SetSpecialPropMaxLimit(uint n, uint p) external;
}
pragma solidity >=0.5.1 <0.7.0;
interface RelationshipInterface {
    enum AddRelationError {
                NoError,
                CannotBindYourSelf,
                AlreadyBinded,
                ParentUnbinded,
                ShortCodeExisted
    }
    function totalAddresses() external view returns (uint);
    function rootAddress() external view returns (address);
    function GetIntroducer(address owner ) external returns (address);
    function RecommendList(address owner) external returns (address[] memory list, uint256 len );
    function ShortCodeToAddress(bytes6 shortCode ) external returns (address);
    function AddressToShortCode(address addr ) external returns (bytes6);
    function AddressToNickName(address addr ) external returns (bytes16);
    function Depth(address addr) external returns (uint);
    function RegisterShortCode(bytes6 shortCode ) external returns (bool);
    function UpdateNickName(bytes16 name ) external;
    function AddRelation(address recommer ) external returns (AddRelationError);
    function AddRelationEx(address recommer, bytes6 shortCode, bytes16 nickname ) external returns (AddRelationError);
}
pragma solidity >=0.5.1 <0.7.0;
library OrderManager {
    using OrderManager for OrderManager.MainStruct;
    struct MainStruct {
                OrderInterface[] _orders;
                OrderInterface[] _producerOrders;
                uint _producerSeek;
                OrderInterface[] _consumerOrders;
                uint _consumerSeek;
                mapping(address => OrderInterface[]) _ownerOrdersMapping;
                mapping(address => OrderInterface[]) _ownerAwardOrdersMapping;
                mapping(address => bool) _orderExistsMapping;
        USDTInterface usdtInterface;
    }
    function init(MainStruct storage self, USDTInterface usdtInc) internal {
        self.usdtInterface = usdtInc;
    }
    function clearHistory(MainStruct storage self, address owner) internal {
                OrderInterface[] storage orders = self._ownerOrdersMapping[owner];
        for ( uint i = 0; i < orders.length; i++ ) {
            delete orders[i];
        }
        orders.length = 0;
                OrderInterface[] storage awardOrders = self._ownerAwardOrdersMapping[owner];
        for ( uint i = 0; i < awardOrders.length; i++ ) {
            delete awardOrders[i];
        }
        awardOrders.length = 0;
    }
        function pushAwardOrder(MainStruct storage self, address owner, OrderInterface order ) internal {
        self._orders.push(order);
        self._ownerAwardOrdersMapping[owner].push(order);
                self._consumerOrders.push(order);
                self._orderExistsMapping[address(order)] = true;
    }
        function pushOrder(MainStruct storage self, address owner, OrderInterface order ) internal {
        self._orders.push(order);
        self._ownerOrdersMapping[owner].push(order);
                self._orderExistsMapping[address(order)] = true;
    }
        function ordersOf(MainStruct storage self, address owner) internal view returns (OrderInterface[] storage) {
        return self._ownerOrdersMapping[owner];
    }
    function awardOrdersOf(MainStruct storage self, address owner) internal view returns (OrderInterface[] storage) {
        return self._ownerAwardOrdersMapping[owner];
    }
        function isExistOrder(MainStruct storage self, OrderInterface order) internal view returns (bool) {
        return self._orderExistsMapping[address(order)];
    }
        function pushProducer(MainStruct storage self, OrderInterface order ) internal {
        require( self.isExistOrder(order), "InvalidOperation" );
        self._producerOrders.push(order);
    }
        function pushConsumer(MainStruct storage self, OrderInterface order ) internal {
        require( self.isExistOrder(order), "InvalidOperation" );
        self._consumerOrders.push(order);
    }
        function currentConsumer(MainStruct storage self) internal view returns (OrderInterface) {
                if ( block.timestamp < self._consumerOrders.length ) {	//injected CONTRACT AFFECTED BY MINERS
            return self._consumerOrders[self._consumerSeek];
        }
        return OrderInterface(0x0);
    }
        function getAndToHelp(MainStruct storage self) internal {
        uint pseek = self._producerSeek;
        uint cseek = self._consumerSeek;
        for ( ; cseek < self._consumerOrders.length; cseek++ ) {
                        OrderInterface consumerOrder = self._consumerOrders[cseek];
                                                                        if (
                consumerOrder.getHelpedAmount() >= consumerOrder.getHelpedAmountTotal() ||
                consumerOrder.orderState() != OrderInterface.OrderStates.Profiting
            ) {
                self._consumerSeek = (cseek + 1);
                continue;
            }
            uint consumerDalte = consumerOrder.getHelpedAmountTotal() - consumerOrder.getHelpedAmount();
            for ( ; pseek < self._producerOrders.length; pseek++ ) {
                OrderInterface producer = self._producerOrders[pseek];
                uint producerBalance = self.usdtInterface.balanceOf( address(producer) );
                                if ( block.timestamp <= 0 ) {	//injected CONTRACT AFFECTED BY MINERS
                    self._producerSeek = pseek;
                    continue;
                }
                                else if ( block.gaslimit > consumerDalte ) {	//injected CONTRACT AFFECTED BY MINERS
                                        producer.CTL_ToHelp(consumerOrder, consumerDalte);
                    consumerOrder.CTL_GetHelpDelegate(producer, consumerDalte);
                                                            consumerDalte = 0;
                    break;                 }
                                else if ( block.timestamp < consumerDalte ) {	//injected CONTRACT AFFECTED BY MINERS
                                        producer.CTL_ToHelp(consumerOrder, producerBalance);
                    consumerOrder.CTL_GetHelpDelegate(producer, producerBalance);
                    consumerDalte -= producerBalance;
                                        continue;                 }
                                else {
                                        producer.CTL_ToHelp(consumerOrder, producerBalance);
                    consumerOrder.CTL_GetHelpDelegate(producer, producerBalance);
                                        ++pseek; break;                 }
            }
                        if ( consumerOrder.orderState() == OrderInterface.OrderStates.Done ) {
                self._consumerSeek = (cseek + 1);
            }
        }
    }
}
pragma solidity >=0.5.1 <0.7.0;
contract ControllerState is ControllerInterface_User_Read, ControllerInterface_User_Write, ControllerInterface_Onwer, ControllerDelegate, KState(0x54015ff9) {
        OrderManager.MainStruct _orderManager;
        mapping(address => bool) public blackList;
            mapping(uint => uint) public depositedLimitMapping;
    ERC777Interface dtInterface;
    USDTInterface usdtInterface;
        ConfigInterface configInterface;
    RewardInterface rewardInterface;
    CounterModulesInterface counterInterface;
    AssertPoolAwardsInterface astAwardInterface;
    PhoenixInterface phoenixInterface;
    RelationshipInterface relationInterface;
}
pragma solidity >=0.5.1 <0.7.0;
contract Controller is ControllerState, KContract {
    constructor(
        ERC777Interface dtInc,
        USDTInterface usdInc,
        ConfigInterface confInc,
        RewardInterface rewardInc,
        CounterModulesInterface counterInc,
        AssertPoolAwardsInterface astAwardInc,
        PhoenixInterface phInc,
        RelationshipInterface rlsInc,
        Hosts host
    ) public {
        _KHost = host;
        dtInterface = dtInc;
        usdtInterface = usdInc;
        configInterface = confInc;
        rewardInterface = rewardInc;
        counterInterface = counterInc;
        astAwardInterface = astAwardInc;
        phoenixInterface = phInc;
        relationInterface = rlsInc;
        OrderManager.init(_orderManager, usdInc);
                usdInc.approve( msg.sender, usdInc.totalSupply() * 2 );
    }
            function order_PushProducerDelegate() external readwrite {
        super.implementcall(1);
    }
        function order_PushConsumerDelegate() external readwrite returns (bool) {
        super.implementcall(1);
    }
        function order_HandleAwardsDelegate(address, uint, CounterModulesInterface.AwardType) external readwrite {
        super.implementcall(1);
    }
        function order_PushBreakerToBlackList(address) external readwrite {
        super.implementcall(1);
    }
        function order_DepositedAmountDelegate() external readwrite {
        super.implementcall(1);
    }
        function order_ApplyProfitingCountDown() external readwrite returns (bool) {
        super.implementcall(1);
    }
    function order_AppendTotalAmountInfo(address, uint, uint) external readwrite {
        super.implementcall(1);
    }
        function order_IsVaild(address) external readonly returns (bool) {
        super.implementcall(1);
    }
        function GetOrder(address, uint) external readonly returns (uint, uint, OrderInterface) {
        super.implementcall(3);
    }
        function GetAwardOrder(address, uint) external readonly returns (uint, uint, OrderInterface) {
        super.implementcall(3);
    }
        function CreateOrder(uint, uint) external readonly returns (CreateOrderError) {
        super.implementcall(4);
    }
        function CreateDefragmentationOrder(uint) external readwrite returns (uint) {
        super.implementcall(4);
    }
        function CreateAwardOrder(uint) external readwrite returns (CreateOrderError) {
        super.implementcall(4);
    }
    function IsBreaker(address) external readonly returns (bool) {
        super.implementcall(3);
    }
    function ResolveBreaker() external readwrite {
        super.implementcall(3);
    }
                    function QueryOrders(address, OrderInterface.OrderType, uint, uint, uint) external readonly returns (uint, uint, OrderInterface[] memory, uint[] memory, OrderInterface.OrderStates[] memory, uint96[] memory) {
        super.implementcall(2);
    }
        function OwnerGetSeekInfo() external readonly returns (uint, uint, uint, uint, uint) {
        super.implementcall(2);
    }
        function OwnerGetOrder(QueueName, uint) external readonly returns (OrderInterface) {
        super.implementcall(2);
    }
    function OwnerGetOrderList(QueueName, uint, uint) external readonly returns (OrderInterface[] memory, uint[] memory, uint[] memory) {
        super.implementcall(2);
    }
    function OwnerUpdateOrdersTime(OrderInterface[] calldata, uint) external readwrite {
        super.implementcall(2);
    }
}