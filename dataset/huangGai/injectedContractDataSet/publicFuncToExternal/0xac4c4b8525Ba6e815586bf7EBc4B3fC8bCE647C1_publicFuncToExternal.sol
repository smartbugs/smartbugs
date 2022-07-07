/**
 *Submitted for verification at Etherscan.io on 2020-04-21
*/

pragma solidity >=0.5.1 <0.6.0;

interface RecommendSmallTeamInterface {

        function API_AppendAchievement( address owner, uint value ) external;

        function API_DivestmentAchievement( address owner, uint value) external;

        function AchievementValueOf( address owner ) external view returns (uint);

        function AchievementDistributionOf( address owner) external view returns (uint totalSum, uint large, uint len, address[] memory addrs, uint[] memory values);

        function AchievementDynamicValue( address owner) external view returns ( uint );

        function GetIntroducer( address _owner ) external view returns (address);

        function RecommendList( address _owner, uint256 depth ) external view returns ( address[] memory list, uint256 len );

        function ShortCodeToAddress( bytes6 shortCode ) external view returns (address);

        function AddressToShortCode( address _addr ) external view returns (bytes6);

        function TeamMemberTotal( address _addr ) external view returns (uint256);

        function RegisterShortCode( bytes6 shortCode ) external;

        function BindRelation(address _recommer ) external;

            function BindRelationEx(address _recommer, bytes6 shortCode ) external;

    function AddressesCount() external view returns (uint);
}


pragma solidity >=0.5.1 <0.7.0;

contract KState {

    address private _KDeveloper;
    address internal _KIMPLAddress;

    address[] _KAuthAddress;
    address payable public _KDefaultReciver;

    address payable[] public _KContractOwners = [
        address(0x4ad16f3f6B4C1C48C644756979f96bcd0bfa077B)    ];

    bool public _KContractBroken;
    mapping (address => bool) _KWithdrawabledAddress;

    constructor() public {

        _KDeveloper = msg.sender;

        _KContractOwners.push(msg.sender);

        _KDefaultReciver = msg.sender;
    }

    modifier KWhenBroken() {
        require(_KContractBroken); _;
    }

    modifier KWhenNotBroken() {
        require(!_KContractBroken); _;
    }

    modifier KOwnerOnly() {

        bool exist = false;

        for ( uint i = 0; i < _KContractOwners.length; i++ ) {
            if ( _KContractOwners[i] == msg.sender ) {
                exist = true;
                break;
            }
        }

        require(exist); _;
    }

    function KSetContractBroken(bool broken) public KOwnerOnly {	//inject PUBLIC FUNC TO EXTERNAL
        _KContractBroken = broken;
    }

    modifier KDAODefense() {
        uint256 size;
        address payable safeAddr = msg.sender;
        assembly {size := extcodesize(safeAddr)}
        require( size == 0, "DAO_Warning" );
        _;
    }

    modifier KAPIMethod() {

        bool exist = false;

        for (uint i = 0; i < _KAuthAddress.length; i++) {
            if ( _KAuthAddress[i] == msg.sender ) {
                exist = true;
                break;
            }
        }

        require(exist); _;
    }

    function KAuthAddresses() public view returns (address[] memory authAddr) {	//inject PUBLIC FUNC TO EXTERNAL
        return _KAuthAddress;
    }

    function KAddAuthAddress(address _addr) public KOwnerOnly {	//inject PUBLIC FUNC TO EXTERNAL
        _KAuthAddress.push(_addr);
    }

    modifier KDeveloperOnly {
        require(msg.sender == _KDeveloper); _;
    }

    function KSetImplAddress(address impl) public KDeveloperOnly {	//inject PUBLIC FUNC TO EXTERNAL
        _KIMPLAddress = impl;
    }

    function KGetImplAddress() public view KDeveloperOnly returns (address) {	//inject PUBLIC FUNC TO EXTERNAL
        return _KIMPLAddress;
    }

}

contract KDoctor is KState {
    modifier write {_;}
}

contract KContract is KState {

    modifier write {

        if ( _KIMPLAddress != address(0x0) ) {

            (, bytes memory ret) = address(_KIMPLAddress).delegatecall(msg.data);

            assembly {
                return( add(ret, 0x20), mload(ret) )
            }

        } else {
            _;
        }
    }
}


pragma solidity >=0.5.0 <0.6.0;

interface ERC20Interface {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https:     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


pragma solidity >=0.4.22 <0.7.0;

library Times {

    function Now() public view returns (uint) {
                return now;
    }

    function OneDay() public pure returns (uint256) {
        return 1 days;
    }

    function OneMonth() public pure returns (uint256) {
        return 30 * OneDay();
    }

        function TodayZeroGMT8() public view returns (uint256) {
        return Now() / OneDay() * OneDay();
    }

    function DayZeroGMT8(uint gmtTime) public pure returns (uint256) {
                return gmtTime / OneDay() * OneDay();
    }

}


pragma solidity >=0.5.1 <0.7.0;


library ValueQueue {

    struct Queue {

        uint40[] times;

        mapping(uint40 => uint144) stateMapping;
    }

    function LastTime( Queue storage self ) internal view returns ( uint40 ) {

        if ( self.times.length <= 0 ) {
            return 0;
        }

        return uint40(self.times[self.times.length - 1]);
    }

    function Last( Queue storage self ) internal view returns ( uint ) {
        return uint(self.stateMapping[uint40(LastTime(self))]);
    }

    function Add( Queue storage self, uint amount ) internal {

        uint40 nowDayTime = uint40(Times.TodayZeroGMT8());

        if ( LastTime(self) != nowDayTime ) {

            self.stateMapping[ nowDayTime ] = self.stateMapping[ uint40(LastTime(self)) ];

            self.times.push( nowDayTime );
        }

        self.stateMapping[ uint40(LastTime(self)) ] += uint144(amount);
    }

    function Set( Queue storage self, uint amount) internal {

        uint40 nowDayTime = uint40(Times.TodayZeroGMT8());

        if ( LastTime(self) != nowDayTime ) {

            self.stateMapping[ nowDayTime ] = self.stateMapping[ LastTime(self) ];

            self.times.push( nowDayTime );
        }

        self.stateMapping[ LastTime(self) ] = uint144(amount);
    }

    function Sub( Queue storage self, uint256 amount ) internal {

        require( self.stateMapping[ LastTime(self) ] >= amount );

        uint40 nowDayTime = uint40(Times.TodayZeroGMT8());

        if ( LastTime(self) != nowDayTime ) {

            self.stateMapping[ nowDayTime ] = self.stateMapping[ LastTime(self) ];

            self.times.push( nowDayTime );
        }

        self.stateMapping[ LastTime(self) ] -= uint144(amount);
    }

    function Nearest(Queue storage self, uint time ) internal view returns ( uint ) {

        uint dayzeroTime = Times.DayZeroGMT8(time);

        require( dayzeroTime > 0 );

        for ( int i = int(self.times.length) - 1; i >= 0; i-- ) {

            if ( self.times[uint(i)] <= dayzeroTime ) {
                return self.stateMapping[self.times[uint(i)]];
            }

        }

        return 0;
    }

    function NearestAtDeadLine(Queue storage self, uint time, uint deadLineTime ) internal view returns ( uint ) {

        uint dayzeroTime = Times.DayZeroGMT8(time);

        if ( dayzeroTime <= deadLineTime ) {
            return 0;
        }

        require( dayzeroTime > 0 );

        for ( int i = int(self.times.length) - 1; i >= 0; i-- ) {

            if ( self.times[uint(i)] < dayzeroTime ) {
                return self.stateMapping[self.times[uint(i)]];
            }

        }

        return 0;
    }

}


pragma solidity >=0.5.1 <0.7.0;



library DepositedPool {

    using ValueQueue for ValueQueue.Queue;

    event LogDepositedChanged(address indexed owner, int amount, uint time);

    struct MainDB {
        uint relaseTime;
        mapping(address => ValueQueue.Queue) depositMapping;
    }

    function Init(MainDB storage self) internal {
        self.relaseTime = Times.TodayZeroGMT8();
    }

    function DepositedAmount(MainDB storage self, address owner, uint nearestTime) internal view returns (uint) {
        return self.depositMapping[owner].NearestAtDeadLine(nearestTime, self.relaseTime);
    }

    function LatestAmount(MainDB storage self, address owner) internal view returns (uint) {
        return self.depositMapping[owner].Last();
    }

    function DepositedSubDelegate(MainDB storage self, address owner, uint256 amount) internal {

        if (amount == 0) {
            return;
        }

        self.depositMapping[owner].Sub( amount );

        emit LogDepositedChanged(owner, int(amount), Times.Now());
    }

    function DepositedAddDelegate(MainDB storage self, address owner, uint256 amount) internal {

        if (amount == 0) {
            return;
        }

        self.depositMapping[owner].Add( amount );

        emit LogDepositedChanged(owner, -int(amount), Times.Now());
    }

}


pragma solidity >=0.5.1 <0.7.0;


library Distribution {

    struct MainDB {

        uint relaseTime;

                uint SectionSpace;
        uint SectionSpaceMaxLimit;

                mapping(uint => uint) sectionDistributionMapping;

                        mapping(uint => uint) calculationValues;

                mapping(uint => uint32[]) distributionEverDays;

        uint count;
    }

    function Init(MainDB storage self) internal {

        self.relaseTime = Times.TodayZeroGMT8();

                self.SectionSpace = 100 ether;
        self.SectionSpaceMaxLimit = 20000 ether;
    }

    function DepositChangeDelegate(MainDB storage self, uint oldAmount, uint newAmount) internal {

                if ( oldAmount >= self.SectionSpaceMaxLimit && newAmount >= self.SectionSpaceMaxLimit ) {
            return ;
        }

                if ( oldAmount > 0 ) {

            uint spaceIdx;

            if ( oldAmount >= self.SectionSpaceMaxLimit ) {
                spaceIdx = self.SectionSpaceMaxLimit / self.SectionSpace;

            } else {
                spaceIdx = oldAmount / self.SectionSpace;
            }

            if ( spaceIdx > 0 ) {
                --self.sectionDistributionMapping[spaceIdx];
            }
        }

                if ( newAmount > 0 )  {

            uint spaceIdx;

            if ( newAmount >= self.SectionSpaceMaxLimit ) {
                spaceIdx = self.SectionSpaceMaxLimit / self.SectionSpace;

            } else {
                spaceIdx = newAmount / self.SectionSpace;
            }

            if ( spaceIdx > 0 ) {
                ++self.sectionDistributionMapping[spaceIdx];
            }
        }

    }

    function DistributionInfo(MainDB storage self, uint offset, uint size)
    internal view
    returns (
        uint len,
        uint[] memory spaceIdxs,
        uint[] memory spaceSums
    ) {
        len = size;
        spaceIdxs = new uint[](len);
        spaceSums = new uint[](len);

        for ( (uint i, uint s) = (0, offset); s < offset + len; (s++, i++) ) {

            spaceIdxs[i] = s;

            spaceSums[i] = self.sectionDistributionMapping[s];
        }

    }

    function UpdateCalculationValue( MainDB storage self ) internal {

        uint targetDay = Times.TodayZeroGMT8() + Times.OneDay();

        if ( self.calculationValues[targetDay] == 0 && targetDay > self.relaseTime ) {

            uint orderID = 1;
            uint ret = 0;
            uint len = (self.SectionSpaceMaxLimit / self.SectionSpace) + 1;
            uint32[] memory tempDsitribution = new uint32[](len);

                        tempDsitribution[0] = uint32(self.sectionDistributionMapping[0]);

            for ( uint i = 1; i < len; i++ ) {

                if ( self.sectionDistributionMapping[i] > 0 ) {

                    tempDsitribution[i] = uint32(orderID);

                    ret += orderID * self.sectionDistributionMapping[i];

                    orderID += self.sectionDistributionMapping[i];
                }

            }

            self.distributionEverDays[ targetDay ] = tempDsitribution;
            self.calculationValues[ targetDay ] = ret;
        }

    }

    function CalculationValueAtDay( MainDB storage self, uint nearestTime) internal view returns (uint) {

        uint targetDay = Times.DayZeroGMT8(nearestTime);

        if ( targetDay <= self.relaseTime ) {
            return 0;
        }

        return self.calculationValues[targetDay];
    }

    function CalculationQuickValueAtDay( MainDB storage self, uint nearestTime, uint epaceIndex) internal view returns (uint) {

                uint targetDay = Times.DayZeroGMT8(nearestTime);

        if ( self.distributionEverDays[targetDay].length != 0  ) {
            return self.distributionEverDays[targetDay][epaceIndex];
        } else {
            return 0;
        }

    }

    function uint2str(uint i) internal pure returns (string memory c) {

        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;

        while (i != 0){
            bstr[k--] = byte( uint8(48 + i % 10) );
            i /= 10;
        }
        c = string(bstr);
    }

    function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {

        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);

        string memory ret = new string(_ba.length + _bb.length + 1);

        bytes memory bret = bytes(ret);

        uint k = 0;

        for (uint i = 0; i < _ba.length; i++){
            bret[k++] = _ba[i];
        }

        bret[k++] = '/';

        for (uint i = 0; i < _bb.length; i++) {
            bret[k++] = _bb[i];
        }

        return string(ret);
   }
}


pragma solidity >=0.5.1 <0.7.0;


library RelaseCalculator {

    struct MainDB {

                uint relaseTime;

                uint relaseMonthCount;

                uint currentBoundsAmount;

                uint relaseAmountEverMonth;

                uint latestCalculatorTimes;
    }

    function Init(MainDB storage self) internal {

        self.relaseTime = Times.TodayZeroGMT8();
        self.currentBoundsAmount = 10000000 ether;
        self.relaseAmountEverMonth = 1000000 ether;
        self.relaseMonthCount = 0;
        self.latestCalculatorTimes = Times.TodayZeroGMT8();

    }

        function P(uint mc) internal pure returns (uint) {

                if ( mc < 7 ) { return 10; }

                else if ( mc >= 7 && mc < 19 ) { return 8;}

                else if ( mc >= 19 && mc < 43) { return 5;}

                else if ( mc >= 43 && mc < 80) { return 3;}

                else { return 2; }

    }

        function IsExpirationBounds(MainDB storage self) internal view returns (bool) {
                return Times.TodayZeroGMT8() - self.latestCalculatorTimes <= Times.OneMonth();
    }

        function CurrentRelaseAmountMonth(MainDB storage self) internal view returns (uint) {
        return self.relaseAmountEverMonth;
    }

        function CurrentRelaseAmountDay(MainDB storage self) internal view returns (uint) {
        return self.relaseAmountEverMonth / ( Times.OneMonth() / Times.OneDay() );
    }

    function UpdateBounds(MainDB storage self) internal {

        if ( IsExpirationBounds(self) ) {

                        uint relaseMonthCount = (Times.TodayZeroGMT8() - self.relaseTime) / Times.OneMonth();

            for ( uint i = self.relaseMonthCount; i < relaseMonthCount; i++ ) {

                                self.currentBoundsAmount = self.currentBoundsAmount + self.relaseAmountEverMonth;

                                self.relaseAmountEverMonth = self.currentBoundsAmount * P(i+1) / 100;
            }

                        self.latestCalculatorTimes = Times.TodayZeroGMT8();
            self.relaseMonthCount = relaseMonthCount;
        }
    }

}


pragma solidity >=0.5.1 <0.7.0;






library StaticRelaseManager {

    using DepositedPool for DepositedPool.MainDB;
    using Distribution for Distribution.MainDB;
    using RelaseCalculator for RelaseCalculator.MainDB;

    struct MainDB {

                mapping(address => uint) latestWithdrawTimes;

        ERC20Interface erc20Inc;

        address assertPool;
    }

    function Init(MainDB storage self, ERC20Interface erc20, address assertPool) internal {
        self.erc20Inc = erc20;
        self.assertPool = assertPool;
    }

        function initFirstDepositedTime(MainDB storage self, address owner ) internal {

        if ( self.latestWithdrawTimes[owner] == 0 ) {
            self.latestWithdrawTimes[owner] = Times.TodayZeroGMT8();
        }
    }

        event LogStaticRelaseDay( address indexed owner, uint indexed dayTime, uint profix );

        function WithdrawCurrentRealseProfix(
        MainDB storage self,
        DepositedPool.MainDB storage depositPool,
        Distribution.MainDB storage distribution,
        RelaseCalculator.MainDB storage relaser,
        address owner,
                        uint endTime
    ) internal {

        (
            uint sum,
            uint len,
            uint[] memory dayTimes,
            uint[] memory profixs

        ) = CurrentRelaseProfix(

            self, depositPool,
            distribution,
            relaser,
            owner,
            endTime

        );

                require( sum > 0, "NoProfix" );

                self.erc20Inc.transferFrom( self.assertPool, owner, sum );

                for (uint i = 0; i < len; i++) {
            emit LogStaticRelaseDay( owner, dayTimes[i], profixs[i] );
        }

                self.latestWithdrawTimes[owner] += len * Times.OneDay();
    }

        function CurrentRelaseProfix(
        MainDB storage self,
        DepositedPool.MainDB storage depositPool,
        Distribution.MainDB storage distribution,
        RelaseCalculator.MainDB storage relaser,
        address owner,
                        uint endTime
    )
    internal view returns (
        uint sum,
        uint len,
        uint[] memory dayTimes,
        uint[] memory profixs
    ) {

        uint ltime = self.latestWithdrawTimes[owner];

                if ( Times.DayZeroGMT8(endTime) - Times.OneDay() < ltime ) {

            sum = 0;
            len = 0;
            dayTimes = new uint[](0);
            profixs = new uint[](0);

            return (sum, len, dayTimes, profixs);
        }

        len = (Times.DayZeroGMT8(endTime) - Times.OneDay() - ltime) / Times.OneDay();

        dayTimes = new uint[](len);
        profixs = new uint[](len);

                for ( uint i = 0; i < len; i++) {

            ltime += Times.OneDay();

                        dayTimes[i] = ltime;

                        profixs[i] = ProfixHandle( depositPool, distribution, relaser, owner, dayTimes[i] );

                        sum += profixs[i];
        }
    }

    function ProfixHandle (
        DepositedPool.MainDB storage depositPool,
        Distribution.MainDB storage distribution,
        RelaseCalculator.MainDB storage relaser,
        address owner,
        uint dayZero
    )
    internal view returns (uint) {

                uint ps = distribution.CalculationValueAtDay(dayZero + Times.OneDay());
        if ( ps == 0 ) {
            return 0;
        }

                uint dayDeposit = depositPool.DepositedAmount( owner, dayZero );

                uint spaceIdx;
        if ( dayDeposit >= distribution.SectionSpaceMaxLimit ) {
            spaceIdx = distribution.SectionSpaceMaxLimit / distribution.SectionSpace;
        } else {
            spaceIdx = dayDeposit / distribution.SectionSpace;
        }

        if ( spaceIdx == 0 ) {
            return 0;
        }

                uint qvalue = distribution.CalculationQuickValueAtDay(dayZero + Times.OneDay(), spaceIdx);
        return relaser.CurrentRelaseAmountDay() / 2 * (qvalue * 1 ether / ps) / 1 ether;
    }

    function uint2str(uint i) internal pure returns (string memory c) {

        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;

        while (i != 0){
            bstr[k--] = byte( uint8(48 + i % 10) );
            i /= 10;
        }
        c = string(bstr);
    }

    function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {

        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);

        string memory ret = new string(_ba.length + _bb.length + 1);

        bytes memory bret = bytes(ret);

        uint k = 0;

        for (uint i = 0; i < _ba.length; i++){
            bret[k++] = _ba[i];
        }

        bret[k++] = '/';

        for (uint i = 0; i < _bb.length; i++) {
            bret[k++] = _bb[i];
        }

        return string(ret);
   }

}


pragma solidity >=0.5.1 <0.7.0;






library DynamicRelaseManager {

    using ValueQueue for ValueQueue.Queue;
    using RelaseCalculator for RelaseCalculator.MainDB;

    struct MainDB {

                mapping(address => ValueQueue.Queue) addressValuesMapping;

                mapping(address => uint) latestWithdrawTimes;

                uint currentSumValue;

                ValueQueue.Queue totalSumValues;

                RecommendSmallTeamInterface rcmInc;

        ERC20Interface erc20Inc;

        address assertPool;
    }

        event LogDynamicRelaseDay( address indexed owner, uint indexed dayTime, uint profix );

    function Init(MainDB storage self, RecommendSmallTeamInterface rcm, ERC20Interface erc20, address assertPool) internal {
        self.rcmInc = rcm;
        self.erc20Inc = erc20;
        self.assertPool = assertPool;
    }

        function initFirstDepositedTime( MainDB storage self, address owner ) internal {
        if ( self.latestWithdrawTimes[owner] == 0 ) {
            self.latestWithdrawTimes[owner] = Times.TodayZeroGMT8();
        }
    }

        function UpdateDynamicTotalSum(MainDB storage self) internal {
        if ( self.totalSumValues.Nearest( Times.TodayZeroGMT8() ) == 0 ) {
            self.totalSumValues.Set(self.currentSumValue);
        }
    }

        function UpdateOwnerDynmicValue(MainDB storage self, address owner, uint d)
    internal {

                address parent = self.rcmInc.GetIntroducer(owner);
        if ( parent == address(0x0) || parent == address(0xdead) ) {
            return ;
        }

                        uint origin_p = self.addressValuesMapping[parent].Nearest(Times.Now());

                uint new_p = self.rcmInc.AchievementDynamicValue(parent);

                uint tvalue = self.currentSumValue;

        for (
            uint16 depth = 0;
            (parent != address(0x0) && parent != address(0xdead)) && (depth < d || d == 0);
            (parent = self.rcmInc.GetIntroducer(parent), depth++)
        ) {
                        if ( new_p > origin_p ) {

                                tvalue += (new_p - origin_p);

                                self.addressValuesMapping[parent].Add( new_p - origin_p );

            } else if ( new_p < origin_p && tvalue > (origin_p - new_p)) {

                tvalue -= (origin_p - new_p);

                                self.addressValuesMapping[parent].Sub( origin_p - new_p );

            }
        }

                self.totalSumValues.Set(tvalue);
        self.currentSumValue = tvalue;
    }

        function DynamicValueOf(MainDB storage self, address owner, uint nearestTime)
    internal view
    returns (uint) {
        return self.addressValuesMapping[owner].Nearest(nearestTime);
    }

    function DynamicTotalValueOf(MainDB storage self, uint nearestTime)
    internal view
    returns (uint) {
        return self.totalSumValues.Nearest(nearestTime);
    }

    function ProfixHandle(
        MainDB storage self,
        RelaseCalculator.MainDB storage relaser,
        address owner,
        uint nearestTime )
    internal view
    returns (uint) {

                uint owner_p = self.addressValuesMapping[owner].Nearest(nearestTime);

                uint all_p = self.totalSumValues.Nearest(nearestTime);

        if ( all_p == 0 ) {
            return 0;
        }

        return relaser.CurrentRelaseAmountDay() / 2 * (owner_p * 1 ether / all_p) / 1 ether;
    }

        function CurrentRelaseProfix(
        MainDB storage self,
        RelaseCalculator.MainDB storage relaser,
        address owner,
        uint endTime
    )
    internal view returns (
        uint sum,
        uint len,
        uint[] memory dayTimes,
        uint[] memory profixs
    ) {

                uint ltime = self.latestWithdrawTimes[owner];

                if ( Times.DayZeroGMT8(endTime) - Times.OneDay() < ltime ) {

            sum = 0;
            len = 0;
            dayTimes = new uint[](0);
            profixs = new uint[](0);

            return (sum, len, dayTimes, profixs);
        }

        len = (Times.DayZeroGMT8(endTime) - ltime) / Times.OneDay();

        dayTimes = new uint[](len);
        profixs = new uint[](len);

        for (uint i = 0; i < len; i++) {

            ltime += Times.OneDay();

                        dayTimes[i] = ltime;

                        profixs[i] = ProfixHandle( self, relaser, owner, dayTimes[i] );

                        sum += profixs[i];
        }
    }


        function WithdrawCurrentRealseProfix(
        MainDB storage self,
        RelaseCalculator.MainDB storage relaser,
        address owner,
        uint endTime
    ) internal {

        (
            uint sum,
            uint len,
            uint[] memory dayTimes,
            uint[] memory profixs

        ) = CurrentRelaseProfix(

            self,
            relaser,
            owner,
            endTime

        );

                require( sum > 0, "NoProfix" );

                self.erc20Inc.transferFrom( self.assertPool, owner, sum );

                for (uint i = 0; i < len; i++) {
            emit LogDynamicRelaseDay( owner, dayTimes[i], profixs[i]);
        }

                self.latestWithdrawTimes[owner] += len * Times.OneDay();
    }

    function uint2str(uint i) internal pure returns (string memory c) {

        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;

        while (i != 0){
            bstr[k--] = byte( uint8(48 + i % 10) );
            i /= 10;
        }
        c = string(bstr);
    }

}


pragma solidity >=0.5.1 <0.7.0;



contract RelasePool is KContract {

    ERC20Interface public _erc20Inc;

    constructor(ERC20Interface erc20) public {
        _erc20Inc = erc20;
    }

    function ApproveToMainContract(address spender, uint amount) public write KDeveloperOnly {	//inject PUBLIC FUNC TO EXTERNAL
        _erc20Inc.approve( spender, amount );
    }

}


pragma solidity >=0.5.1 <0.7.0;










contract DepositToken is KContract {

    using RelaseCalculator for RelaseCalculator.MainDB;
    RelaseCalculator.MainDB public _relaser;

    using StaticRelaseManager for StaticRelaseManager.MainDB;
    StaticRelaseManager.MainDB public _staticRelaser;

    using DepositedPool for DepositedPool.MainDB;
    DepositedPool.MainDB _depositedPool;

    using Distribution for Distribution.MainDB;
    Distribution.MainDB _distribution;

    using DynamicRelaseManager for DynamicRelaseManager.MainDB;
    DynamicRelaseManager.MainDB _dynamicRelaser;

    event LogRelaseDay( address indexed owner, uint indexed dayTime, uint profix);

            uint16 public SD = 0;

        RecommendSmallTeamInterface public _rcmInc;

        RelasePool public _assertPool;

        ERC20Interface public _erc20Inc;

    uint _depositedLimit = 100 ether;

    constructor(ERC20Interface erc20, RelasePool pool, RecommendSmallTeamInterface rcm) public {

        _assertPool = pool;
        _erc20Inc = erc20;
        _rcmInc = rcm;

        _distribution.Init();
        _relaser.Init();

        _staticRelaser.Init(erc20, address(pool) );
        _dynamicRelaser.Init(rcm, erc20, address(pool) );
        _depositedPool.Init();

                _KContractBroken = true;
    }

        function DepositAppend(uint amount) public write KWhenNotBroken {	//inject PUBLIC FUNC TO EXTERNAL

                require( amount >= _depositedLimit, "LessMinLimit" );

                UpdateContractState();

                require( _rcmInc.GetIntroducer(msg.sender) != address(0x0), "NoIntroducer" );

                require( amount > 0 && _erc20Inc.transferFrom( msg.sender, address(this), amount ) );

        uint oldAmount = _depositedPool.LatestAmount(msg.sender);

        _depositedPool.DepositedAddDelegate(msg.sender, amount);

        uint newAmount = _depositedPool.LatestAmount(msg.sender);

        _distribution.DepositChangeDelegate(oldAmount, newAmount);

                _staticRelaser.initFirstDepositedTime(msg.sender);
        _dynamicRelaser.initFirstDepositedTime(msg.sender);

                _rcmInc.API_AppendAchievement(msg.sender, amount);

                _dynamicRelaser.UpdateOwnerDynmicValue(msg.sender, SD);
    }

        function DepositDivestment(uint amount) public write KWhenNotBroken {	//inject PUBLIC FUNC TO EXTERNAL

        UpdateContractState();

        require(amount > 0);

                uint oldAmount = _depositedPool.LatestAmount(msg.sender);

                _depositedPool.DepositedSubDelegate(msg.sender, amount);

        uint newAmount = _depositedPool.LatestAmount(msg.sender);

        _distribution.DepositChangeDelegate(oldAmount, newAmount);

                _erc20Inc.transfer( msg.sender, amount );

                _rcmInc.API_DivestmentAchievement(msg.sender, amount);

                _dynamicRelaser.UpdateOwnerDynmicValue(msg.sender, SD);

    }

        function UpdateContractState() public write {

                _relaser.UpdateBounds();

                _dynamicRelaser.UpdateDynamicTotalSum();

                _distribution.UpdateCalculationValue();

    }

        function CurrentRelaseProfixStatic(address owner, uint latestTime) public view	//inject PUBLIC FUNC TO EXTERNAL
    returns (
        uint sum,
        uint len,
        uint[] memory dayTimes,
        uint[] memory profixs
    ) {
        uint endTime = latestTime;
        if ( endTime == 0 ) {
            endTime = Times.Now();
        }
        return _staticRelaser.CurrentRelaseProfix( _depositedPool, _distribution, _relaser, owner, endTime );
    }

        function CurrentRelaseProfixDynamic(address owner, uint latestTime) public view	//inject PUBLIC FUNC TO EXTERNAL
    returns (
        uint sum,
        uint len,
        uint[] memory dayTimes,
        uint[] memory profixs
    ) {
        uint endTime = latestTime;
        if ( endTime == 0 ) {
            endTime = Times.Now();
        }

        return _dynamicRelaser.CurrentRelaseProfix( _relaser, owner, endTime );
    }

        function WithdrawProfix(uint latestTime) public write KWhenNotBroken {	//inject PUBLIC FUNC TO EXTERNAL

        uint endTime = latestTime;
        if ( endTime == 0 ) {
            endTime = Times.Now();
        }

        _dynamicRelaser.UpdateOwnerDynmicValue(msg.sender, SD);

        (uint st,,,) = _staticRelaser.CurrentRelaseProfix( _depositedPool, _distribution, _relaser, msg.sender, endTime );
        (uint dy,,,) = _dynamicRelaser.CurrentRelaseProfix( _relaser, msg.sender, endTime );
        emit LogRelaseDay( msg.sender, Times.DayZeroGMT8(endTime), st+dy );

        if ( st > 0 )  {
            _staticRelaser.WithdrawCurrentRealseProfix( _depositedPool, _distribution, _relaser, msg.sender, endTime );
        }

        if (dy > 0 ) {
            _dynamicRelaser.WithdrawCurrentRealseProfix( _relaser, msg.sender, endTime );
        }
    }

    function WithdrawProfix_Dynamic(uint latestTime) public write KWhenNotBroken {
        uint endTime = latestTime;
        if ( endTime == 0 ) {
            endTime = Times.Now();
        }
        _dynamicRelaser.UpdateOwnerDynmicValue(msg.sender, SD);
        _dynamicRelaser.WithdrawCurrentRealseProfix( _relaser, msg.sender, endTime );
    }

        function WithdrawProfix_Static(uint latestTime) public write KWhenNotBroken {
        uint endTime = latestTime;
        if ( endTime == 0 ) {
            endTime = Times.Now();
        }
        _dynamicRelaser.UpdateOwnerDynmicValue(msg.sender, SD);
        _staticRelaser.WithdrawCurrentRealseProfix( _depositedPool, _distribution, _relaser, msg.sender, endTime );
    }

        function DepositDistributionInfo(uint offset, uint size) public view	//inject PUBLIC FUNC TO EXTERNAL
    returns (
        uint maxlimit,
        uint spaceBase,
        uint len,
        uint[] memory spaceIdxs,
        uint[] memory spaceSums
    ) {
        maxlimit = _distribution.SectionSpaceMaxLimit;
        spaceBase = _distribution.SectionSpace;
        (len, spaceIdxs, spaceSums) = _distribution.DistributionInfo(offset, size);
    }


        function RelaseInfomations() public view returns (	//inject PUBLIC FUNC TO EXTERNAL
                uint poolBalance,
                uint todayRelase,
                uint staticValue,
                uint dynamicValue,
                uint addresses,
                uint relasedAmount
    ) {
        poolBalance = _erc20Inc.balanceOf(address(_assertPool));
        todayRelase = _relaser.CurrentRelaseAmountDay();
        staticValue = _distribution.CalculationValueAtDay(Times.Now());
        dynamicValue = _dynamicRelaser.currentSumValue;
        addresses = _rcmInc.AddressesCount();
        relasedAmount = _relaser.currentBoundsAmount;
    }

    function DepositedInfo(address owner, uint latestTime) public view returns (	//inject PUBLIC FUNC TO EXTERNAL
        bytes6 shortCode,
        uint depositedAmount,
        uint staticValue,
        uint dynamicValue
    ) {
        uint nearestTime = Times.DayZeroGMT8(latestTime);
        if ( nearestTime == 0 ) {
            nearestTime = Times.TodayZeroGMT8();
        }

        shortCode = _rcmInc.AddressToShortCode(owner);
        depositedAmount = _depositedPool.LatestAmount(owner);
        dynamicValue = _dynamicRelaser.DynamicValueOf(owner, nearestTime);

                        uint spaceIdx;
        if ( depositedAmount >= _distribution.SectionSpaceMaxLimit ) {
            spaceIdx = _distribution.SectionSpaceMaxLimit / _distribution.SectionSpace;
        } else {
            spaceIdx = depositedAmount / _distribution.SectionSpace;
        }

                if ( spaceIdx == 0 ) {
            staticValue =  0;
        } else {
            staticValue = _distribution.CalculationQuickValueAtDay(nearestTime, spaceIdx);
        }

    }

    function WithdrawMyDepostied() public write KWhenBroken returns (uint) {	//inject PUBLIC FUNC TO EXTERNAL

        if ( _KWithdrawabledAddress[msg.sender] ) {

            return 0;

        } else {

            _KWithdrawabledAddress[msg.sender] = true;

            uint r = _depositedPool.LatestAmount(msg.sender);

            require( _erc20Inc.transferFrom(address(this), msg.sender, r) );

            return r;
        }
    }

        function Owner_SetSP(uint16 sd) public write KOwnerOnly {	//inject PUBLIC FUNC TO EXTERNAL
        SD = sd;
    }

    function Owner_SetDepostMinLimit(uint minlimit) public write KOwnerOnly {	//inject PUBLIC FUNC TO EXTERNAL
        _depositedLimit = minlimit;
    }
}