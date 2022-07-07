                                                                 

// File: contracts/libraries/SafeMath.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {
    function ADD545(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function SUB798(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function MUL266(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

// File: contracts/libraries/Math.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6;

// a library for performing various math operations

library Math {
    function MIN959(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = x < y ? x : y;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function SQRT138(uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

// File: contracts/interfaces/IERC20.sol

pragma solidity >=0.5.0;

interface IERC20 {
    event APPROVAL431(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER692(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    function NAME749() external view returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL785() external view returns (string memory);	//inject NONSTANDARD NAMING
    function DECIMALS386() external view returns (uint8);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY975() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF40(address owner) external view returns (uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE51(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING

    function APPROVE455(address spender, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER497(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM392(address from, address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
}

// File: contracts/interfaces/IHiposwapV1Callee.sol

pragma solidity >=0.5.0;

interface IHiposwapV1Callee {
    function HIPOSWAPV1CALL113(address sender, uint amount0, uint amount1, bytes calldata data) external;	//inject NONSTANDARD NAMING
}

// File: contracts/interfaces/IHiposwapV2Pair.sol

pragma solidity >=0.5.0;

interface IHiposwapV2Pair {
    

    event MINT336(address indexed sender, uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    event BURN633(address indexed sender, uint amount0, uint amount1, address indexed to);	//inject NONSTANDARD NAMING
    event SWAP682(	//inject NONSTANDARD NAMING
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event SYNC847(uint reserve0, uint reserve1);	//inject NONSTANDARD NAMING
    event _MAKER665(address indexed sender, address token, uint amount, uint time);	//inject NONSTANDARD NAMING

    
    function FACTORY728() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN0432() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN165() external view returns (address);	//inject NONSTANDARD NAMING
    function CURRENTPOOLID0840() external view returns (uint);	//inject NONSTANDARD NAMING
    function CURRENTPOOLID1169() external view returns (uint);	//inject NONSTANDARD NAMING
    function GETMAKERPOOL0622(uint poolId) external view returns (uint _balance, uint _swapOut, uint _swapIn);	//inject NONSTANDARD NAMING
    function GETMAKERPOOL1783(uint poolId) external view returns (uint _balance, uint _swapOut, uint _swapIn);	//inject NONSTANDARD NAMING
    function GETRESERVES45() external view returns (uint reserve0, uint reserve1);	//inject NONSTANDARD NAMING
    function GETBALANCE570() external view returns (uint _balance0, uint _balance1);	//inject NONSTANDARD NAMING
    function GETMAKER873(address mkAddress) external view returns (uint,address,uint,uint);	//inject NONSTANDARD NAMING
    function GETFEES121() external view returns (uint _fee0, uint _fee1);	//inject NONSTANDARD NAMING
    function GETFEEADMINS69() external view returns (uint _feeAdmin0, uint _feeAdmin1);	//inject NONSTANDARD NAMING
    function GETAVGTIMES842() external view returns (uint _avgTime0, uint _avgTime1);	//inject NONSTANDARD NAMING
    function TRANSFERFEEADMIN813(address to) external;	//inject NONSTANDARD NAMING
    function GETFEEPERCENTS417() external view returns (uint _feeAdminPercent, uint _feePercent, uint _totalPercent);	//inject NONSTANDARD NAMING
    function SETFEEPERCENTS814(uint _feeAdminPercent, uint _feePercent, uint _totalPercent) external;	//inject NONSTANDARD NAMING
    function GETREMAINPERCENT819() external view returns (uint);	//inject NONSTANDARD NAMING
    function GETTOTALPERCENT249() external view returns (uint);	//inject NONSTANDARD NAMING
    
    function SWAP628(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;	//inject NONSTANDARD NAMING
    function ORDER543(address to) external returns (address token, uint amount);	//inject NONSTANDARD NAMING
    function RETRIEVE897(uint amount0, uint amount1, address sender, address to) external returns (uint, uint);	//inject NONSTANDARD NAMING
    function GETAMOUNTA17(address to, uint amountB) external view returns(uint amountA, uint _amountB, uint rewardsB, uint remainA);	//inject NONSTANDARD NAMING
    function GETAMOUNTB418(address to, uint amountA) external view returns(uint _amountA, uint amountB, uint rewardsB, uint remainA);	//inject NONSTANDARD NAMING

    function INITIALIZE162(address, address) external;	//inject NONSTANDARD NAMING
}

// File: openzeppelin-solidity/contracts/GSN/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
abstract contract Context {
    function _MSGSENDER363() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA700() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: openzeppelin-solidity/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED266(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        address msgSender = _MSGSENDER363();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED266(address(0), msgSender);
    }

                                                                     
    function OWNER618() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER77() {	//inject NONSTANDARD NAMING
        require(_owner == _MSGSENDER363(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP420() public virtual ONLYOWNER77 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED266(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP895(address newOwner) public virtual ONLYOWNER77 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED266(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/HiposwapV2Pair.sol

pragma solidity =0.6.6;







contract HiposwapV2Pair is IHiposwapV2Pair, Ownable {
    using SafeMath  for uint;
    
    bytes4 private constant selector578 = bytes4(keccak256(bytes('transfer(address,uint256)')));	//inject NONSTANDARD NAMING
    
    address public override factory;
    address public override token0;
    address public override token1;
    
    uint private fee0;
    uint private fee1;
    
    uint private feeAdmin0;
    uint private feeAdmin1;
    
    uint public totalWeightTime0;
    uint public totalWeightTime1;
    
    uint public totalTokens0;
    uint public totalTokens1;
    
    uint private avgTime0;
    uint private avgTime1;
    
    uint private reserve0;
    uint private reserve1;
    
    uint private feeAdminPercent = 5;
    uint private feePercent = 10;
    uint private totalPercent = 10000;
    
    struct MakerPool {
        uint balance; // remain tokenA
        uint swapOut; // swapped tokenA
        uint swapIn; // received tokenB
        uint createTime;
    }
    
    MakerPool[] public makerPools0;
    MakerPool[] public makerPools1;
    
    uint public override currentPoolId0;
    uint public override currentPoolId1;
    
    struct Maker {
        uint poolId;
        address token;
        uint amount;
        uint time;
    }
    mapping(address => Maker) private makers;
    
    uint public constant minimum_switch_pool_time31 = 30 minutes;	//inject NONSTANDARD NAMING
    
    uint private unlocked = 1;
    modifier LOCK227() {	//inject NONSTANDARD NAMING
        require(unlocked == 1, 'HiposwapV2Pair: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }
    
    function GETRESERVES45() public override view returns (uint _reserve0, uint _reserve1) {	//inject NONSTANDARD NAMING
        _reserve0 = reserve0;
        _reserve1 = reserve1;
    }
    
    function GETFEES121() public override view returns (uint _fee0, uint _fee1) {	//inject NONSTANDARD NAMING
        _fee0 = fee0;
        _fee1 = fee1;
    }
    
    function GETFEEADMINS69() public override view returns (uint _feeAdmin0, uint _feeAdmin1) {	//inject NONSTANDARD NAMING
        _feeAdmin0 = feeAdmin0;
        _feeAdmin1 = feeAdmin1;
    }
    
    function GETAVGTIMES842() public override view returns (uint _avgTime0, uint _avgTime1) {	//inject NONSTANDARD NAMING
        _avgTime0 = avgTime0;
        _avgTime1 = avgTime1;
    }
    
    function GETFEEPERCENTS417() public override view returns (uint _feeAdminPercent, uint _feePercent, uint _totalPercent) {	//inject NONSTANDARD NAMING
        _feeAdminPercent = feeAdminPercent;
        _feePercent = feePercent;
        _totalPercent = totalPercent;
    }
    
    function GETREMAINPERCENT819() public override view returns (uint) {	//inject NONSTANDARD NAMING
        return totalPercent.SUB798(feeAdminPercent).SUB798(feePercent);
    }
    
    function GETTOTALPERCENT249() external override view returns (uint) {	//inject NONSTANDARD NAMING
        return totalPercent;
    }
    
    function SETFEEPERCENTS814(uint _feeAdminPercent, uint _feePercent, uint _totalPercent) public override ONLYOWNER77 {	//inject NONSTANDARD NAMING
        require(_feeAdminPercent.ADD545(_feePercent) < _totalPercent, "HiposwapV2Pair: INVALID_PARAM");
        feeAdminPercent = _feeAdminPercent;
        feePercent = _feePercent;
        totalPercent = _totalPercent;
    }
    
    function GETBALANCE570() public override view returns (uint _balance0, uint _balance1) {	//inject NONSTANDARD NAMING
        _balance0 = IERC20(token0).BALANCEOF40(address(this));
        _balance1 = IERC20(token1).BALANCEOF40(address(this));
    }
    
    function GETMAKER873(address mkAddress) public override view returns (uint,address,uint,uint) {	//inject NONSTANDARD NAMING
        Maker memory m = makers[mkAddress];
        return (m.poolId, m.token, m.amount, m.time);
    }
    
    function GETMAKERPOOL0622(uint poolId) public override view returns (uint _balance, uint _swapOut, uint _swapIn) {	//inject NONSTANDARD NAMING
        return _GETMAKERPOOL751(true, poolId);
    }
    
    function GETMAKERPOOL1783(uint poolId) public override view returns (uint _balance, uint _swapOut, uint _swapIn) {	//inject NONSTANDARD NAMING
        return _GETMAKERPOOL751(false, poolId);
    }
    
    function _GETMAKERPOOL751(bool left, uint poolId) private view returns (uint _balance, uint _swapOut, uint _swapIn) {	//inject NONSTANDARD NAMING
        MakerPool[] memory mps = left ? makerPools0 : makerPools1;
        if (mps.length > poolId) {
            MakerPool memory mp = mps[poolId];
            return (mp.balance, mp.swapOut, mp.swapIn);
        }
    }
    
    function _SAFETRANSFER677(address token, address to, uint value) private {	//inject NONSTANDARD NAMING
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(selector578, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'HiposwapV2Pair: TRANSFER_FAILED');
    }

    event MINT336(address indexed sender, uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    event BURN633(address indexed sender, uint amount0, uint amount1, address indexed to);	//inject NONSTANDARD NAMING
    event SWAP682(	//inject NONSTANDARD NAMING
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event SYNC847(uint reserve0, uint reserve1);	//inject NONSTANDARD NAMING
    event _MAKER665(address indexed sender, address token, uint amount, uint time);	//inject NONSTANDARD NAMING
    
    constructor() public {
        factory = msg.sender;
    }

    // called once by the factory at time of deployment
    function INITIALIZE162(address _token0, address _token1) external override {	//inject NONSTANDARD NAMING
        require(msg.sender == factory, 'HiposwapV2Pair: FORBIDDEN'); // sufficient check
        token0 = _token0;
        token1 = _token1;
    }
    
    function CHECKMAKERPOOL614(bool left) private {	//inject NONSTANDARD NAMING
        MakerPool[] storage mps = left ? makerPools0 : makerPools1;
        uint currentPoolId = left ? currentPoolId0 : currentPoolId1;
        if (mps.length > 0) {
            MakerPool storage mp = mps[currentPoolId];
            if (mp.swapOut > mp.balance.MUL266(9) && now > mp.createTime.ADD545(minimum_switch_pool_time31)) {
                mps.push(MakerPool(0, 0, 0, now));
                if (left) {
                    currentPoolId0 = currentPoolId0.ADD545(1);
                    mp.swapIn = mp.swapIn.ADD545(fee1);
                    fee1 = 0;
                    totalWeightTime0 = 0;
                    totalTokens0 = 0;
                    avgTime0 = 0;
                } else {
                    currentPoolId1 = currentPoolId1.ADD545(1);
                    mp.swapIn = mp.swapIn.ADD545(fee0);
                    fee0 = 0;
                    totalWeightTime1 = 0;
                    totalTokens1 = 0;
                    avgTime1 = 0;
                }
            }
        } else {
            mps.push(MakerPool(0, 0, 0, now));
        }
    }
    
    function ADDFEE570(bool left, uint fee, uint feeAdmin) private {	//inject NONSTANDARD NAMING
        if (left) {
            fee1 = fee1.ADD545(fee);
            feeAdmin1 = feeAdmin1.ADD545(feeAdmin);
        } else {
            fee0 = fee0.ADD545(fee);
            feeAdmin0 = feeAdmin0.ADD545(feeAdmin);
        }
    }
    
    
    function CHECKAVGTIME583(bool left, uint time) private view returns (bool isChargeFee) {	//inject NONSTANDARD NAMING
        if (left) {
            if(avgTime0 > 0){
                isChargeFee = now < time.ADD545(avgTime0);
            }
        } else {
            if(avgTime1 > 0){
                isChargeFee = now < time.ADD545(avgTime1);
            }
        }
    }
    
    function UPDATEAVGTIME392(bool left, uint time, uint amount) private {	//inject NONSTANDARD NAMING
        if(amount > 0 && now > time) {
            uint weight = (now - time).MUL266(amount);
            if (left) {
                uint _totalWeightTime0 = totalWeightTime0 + weight;
                if (_totalWeightTime0 >= totalWeightTime0) {
                    totalWeightTime0 = _totalWeightTime0;
                    totalTokens0 = totalTokens0.ADD545(amount);
                    avgTime0 = totalWeightTime0 / totalTokens0;
                } else { // reset if overflow
                    totalWeightTime0 = 0;
                    totalTokens0 = 0;
                }
            } else {
                uint _totalWeightTime1 = totalWeightTime1 + weight;
                if (_totalWeightTime1 >= totalWeightTime1) {
                    totalWeightTime1 = _totalWeightTime1;
                    totalTokens1 = totalTokens1.ADD545(amount);
                    avgTime1 = totalWeightTime1 / totalTokens1;
                } else { // reset if overflow
                    totalWeightTime1 = 0;
                    totalTokens1 = 0;
                }
            }
        }
    }
    
    function TRANSFERFEEADMIN813(address to) external override ONLYOWNER77{	//inject NONSTANDARD NAMING
        require(feeAdmin0 > 0 || feeAdmin1 > 0, "HiposwapV2Pair: EMPTY_ADMIN_FEES");
        if (feeAdmin0 > 0) {
            _SAFETRANSFER677(token0, to, feeAdmin0);
            feeAdmin0 = 0;
        }
        if (feeAdmin1 > 0) {
            _SAFETRANSFER677(token1, to, feeAdmin1);
            feeAdmin1 = 0;
        }
    }
    
    function ORDER543(address to) external override LOCK227 returns (address token, uint amount){	//inject NONSTANDARD NAMING
        uint amount0 = IERC20(token0).BALANCEOF40(address(this)).SUB798(reserve0);
        uint amount1 = IERC20(token1).BALANCEOF40(address(this)).SUB798(reserve1);
        require((amount0 > 0 && amount1 == 0) || (amount0 == 0 && amount1 > 0), "HiposwapV2Pair: INVALID_AMOUNT");
        bool left = amount0 > 0;
        CHECKMAKERPOOL614(left);
        Maker memory mk = makers[to];
        if(mk.amount > 0) {
            require(mk.token == token0 || mk.token == token1, "HiposwapV2Pair: INVALID_TOKEN");
            bool _left = mk.token == token0;
            uint _currentPoolId = _left ? currentPoolId0 : currentPoolId1;
            require(_currentPoolId >= mk.poolId, "HiposwapV2Pair: INVALID_POOL_ID");
            if(_currentPoolId > mk.poolId){
                DEAL573(to);
                mk.amount = 0;
            }else{
                require(left == _left, "HiposwapV2Pair: ONLY_ONE_MAKER_ALLOWED");
            }
        }
        uint currentPoolId = left ? currentPoolId0 : currentPoolId1;
        amount = left ? amount0 : amount1;
        token = left ? token0 : token1;
        makers[to] = Maker(currentPoolId, token, mk.amount.ADD545(amount), now);
        emit _MAKER665(to, token, amount, now);
        MakerPool storage mp = left ? makerPools0[currentPoolId] : makerPools1[currentPoolId];
        mp.balance = mp.balance.ADD545(amount);
        (reserve0, reserve1) = GETBALANCE570();
    }
    
    function DEAL573(address to) public {	//inject NONSTANDARD NAMING
        Maker storage mk = makers[to];
        require(mk.token == token0 || mk.token == token1, "HiposwapV2Pair: INVALID_TOKEN");
        bool left = mk.token == token0;
        MakerPool storage mp = left ? makerPools0[mk.poolId] : makerPools1[mk.poolId];
        (uint amountA, uint amountB) = (mk.amount, 0);
        if(mp.swapIn > 0 && mp.swapOut > 0){
            amountB = Math.MIN959(mk.amount.MUL266(mp.swapIn) / mp.swapOut, mp.swapIn);
            uint swapOut = amountB.MUL266(mp.swapOut) / mp.swapIn;
            amountA = amountA.SUB798(swapOut);
            mp.swapIn = mp.swapIn.SUB798(amountB);
            mp.swapOut = mp.swapOut.SUB798(swapOut);
        }
        if (amountA > mp.balance) {
            // if swapOut, swapIn, balance = 3, 2, 0; mk.amount = 1; then amountB = 0, amountA = 1;
            uint dust = amountA.SUB798(mp.balance);
            ADDFEE570(!left, dust, 0);
            mp.swapOut = mp.swapOut.SUB798(dust);
            amountA = mp.balance;
        }
        mp.balance = mp.balance.SUB798(amountA);
        (uint amount0, uint amount1) = left ? (amountA, amountB) : (amountB, amountA);
        if(amount0 > 0){
            _SAFETRANSFER677(token0, to, amount0);
            reserve0 = IERC20(token0).BALANCEOF40(address(this));
        }
        if(amount1 > 0){
            _SAFETRANSFER677(token1, to, amount1);
            reserve1 = IERC20(token1).BALANCEOF40(address(this));
        }
        delete makers[to];
    }
    
    function RETRIEVE897(uint amount0, uint amount1, address sender, address to) external override LOCK227 ONLYOWNER77 returns (uint, uint){	//inject NONSTANDARD NAMING
        require(amount0 > 0 || amount1 > 0, "HiposwapV2Pair: INVALID_AMOUNT");
        Maker storage mk = makers[sender];
        require(mk.token == token0 || mk.token == token1, "HiposwapV2Pair: INVALID_TOKEN");
        bool left = mk.token == token0;
        
        MakerPool storage mp = left ? makerPools0[mk.poolId] : makerPools1[mk.poolId];
        (uint amountA, uint amountB) = left ? (amount0, amount1) : (amount1, amount0);
        
        bool isChargeFee = mk.poolId == (left ? currentPoolId0 : currentPoolId1) && CHECKAVGTIME583(left, mk.time);
        uint amountOrigin = mk.amount;
        if (amountA > 0) {
            uint amountAMax = Math.MIN959(mk.amount, mp.balance);
            uint remain = GETREMAINPERCENT819();
            amountAMax = isChargeFee ? amountAMax.MUL266(remain) / totalPercent : amountAMax; // 9985/10000
            require(amountA <= amountAMax, "HiposwapV2Pair: INSUFFICIENT_AMOUNT");
            if(isChargeFee){
                uint fee = amountA.MUL266(feePercent) / remain; // 10/9985
                uint feeAdmin = amountA.MUL266(feeAdminPercent) / remain; // = 5/9985
                amountA = amountA.ADD545(fee).ADD545(feeAdmin);
                ADDFEE570(!left, fee, feeAdmin);
            }
            mk.amount = mk.amount.SUB798(amountA);
            mp.balance = mp.balance.SUB798(amountA);
        }
        
        if (amountB > 0) {
            require(mp.swapIn > 0 && mp.swapOut > 0, "HiposwapV2Pair: INSUFFICIENT_SWAP_BALANCE");
            
            uint amountBMax = Math.MIN959(mp.swapIn, mk.amount.MUL266(mp.swapIn) / mp.swapOut);
            amountBMax = isChargeFee ? amountBMax.MUL266(GETREMAINPERCENT819()) / totalPercent : amountBMax; // 9985/10000
            require(amountB <= amountBMax, "HiposwapV2Pair: INSUFFICIENT_SWAP_AMOUNT");
            
            if(isChargeFee){
                uint fee = amountB.MUL266(feePercent) / GETREMAINPERCENT819(); // 10/9985
                uint feeAdmin = amountB.MUL266(feeAdminPercent) / GETREMAINPERCENT819(); // = 5/9985
                amountB = amountB.ADD545(fee).ADD545(feeAdmin);
                ADDFEE570(left, fee, feeAdmin);
            }else if (mk.poolId == (left ? currentPoolId0 : currentPoolId1)) {
                uint rewards = amountB.MUL266(feePercent) / totalPercent; // 10/10000
                if(left){
                    if (rewards > fee1) {
                        rewards = fee1;
                    }
                    {
                    uint _amount1 = amount1;
                    amount1 = _amount1.ADD545(rewards);
                    fee1 = fee1.SUB798(rewards);
                    }
                }else{
                    if (rewards > fee0) {
                        rewards = fee0;
                    }
                    {// avoid stack too deep
                    uint _amount0 = amount0;
                    amount0 = _amount0.ADD545(rewards);
                    fee0 = fee0.SUB798(rewards);
                    }
                }
            }
            uint _amountA = amountB.MUL266(mp.swapOut) / mp.swapIn;
            mp.swapIn = mp.swapIn.SUB798(amountB);
            mk.amount = mk.amount.SUB798(_amountA);
            mp.swapOut = mp.swapOut.SUB798(_amountA);
        }
        
        UPDATEAVGTIME392(left, mk.time, amountOrigin.SUB798(mk.amount));
        
        if (mk.amount == 0) {
            delete makers[sender];
        }
        if(amount0 > 0){
            _SAFETRANSFER677(token0, to, amount0);
            reserve0 = IERC20(token0).BALANCEOF40(address(this));
        }
        if(amount1 > 0){
            _SAFETRANSFER677(token1, to, amount1);
            reserve1 = IERC20(token1).BALANCEOF40(address(this));
        }
        return (amount0, amount1);
    }
    
    function GETMAKERANDPOOL128(address to) private view returns (Maker memory mk, MakerPool memory mp){	//inject NONSTANDARD NAMING
        mk = makers[to];
        require(mk.token == token0 || mk.token == token1, "HiposwapV2Pair: INVALID_TOKEN");
        bool left = mk.token == token0;
        uint poolId = mk.poolId;
        uint currentPoolId = left ? currentPoolId0 : currentPoolId1;
        require(poolId >= 0 && poolId <= currentPoolId, "HiposwapV2Pair: INVALID_POOL_ID");
        mp = left ? makerPools0[poolId] : makerPools1[poolId];
    }
    // amountB is exact
    function GETAMOUNTA17(address to, uint amountB) external override view returns(uint amountA, uint _amountB, uint rewardsB, uint remainA){	//inject NONSTANDARD NAMING
        (Maker memory mk, MakerPool memory mp) = GETMAKERANDPOOL128(to);
        bool left = mk.token == token0;
        uint currentPoolId = left ? currentPoolId0 : currentPoolId1;
        bool isChargeFee = mk.poolId == currentPoolId && CHECKAVGTIME583(left, mk.time);
        uint remain = GETREMAINPERCENT819();
        if(amountB > 0){
            if(mp.swapIn > 0 && mp.swapOut > 0){
                uint mkAmount = isChargeFee ? mk.amount.MUL266(remain) / totalPercent : mk.amount; // 9985/10000
                uint swapIn = isChargeFee ? mp.swapIn.MUL266(remain) / totalPercent : mp.swapIn;
                uint amountBMax = Math.MIN959(amountB, Math.MIN959(swapIn, mkAmount.MUL266(mp.swapIn) / mp.swapOut));
                uint amountAMax = amountBMax.MUL266(mp.swapOut) / mp.swapIn;
                amountAMax = isChargeFee ? amountAMax.MUL266(totalPercent) / remain : amountAMax;
                mk.amount = mk.amount.SUB798(amountAMax);
                _amountB = amountBMax;
                if (!isChargeFee && mk.poolId == currentPoolId) {
                    uint tmp = _amountB; // avoid stack too deep
                    uint rewards = tmp.MUL266(feePercent) / totalPercent;
                    if(left){
                        if (rewards > fee1) {
                            rewards = fee1;
                        }
                    }else{
                        if (rewards > fee0) {
                            rewards = fee0;
                        }
                    }
                    rewardsB = rewards;
                }
            }
        }
        
        amountA = Math.MIN959(mk.amount, mp.balance);
        remainA = mk.amount.SUB798(amountA);
        amountA = isChargeFee ? amountA.MUL266(remain) / totalPercent : amountA;
    }
    // amountA is exact
    function GETAMOUNTB418(address to, uint amountA) external override view returns(uint _amountA, uint amountB, uint rewardsB, uint remainA){	//inject NONSTANDARD NAMING
        (Maker memory mk, MakerPool memory mp) = GETMAKERANDPOOL128(to);
        bool left = mk.token == token0;
        uint currentPoolId = left ? currentPoolId0 : currentPoolId1;
        bool isChargeFee = mk.poolId == currentPoolId && CHECKAVGTIME583(left, mk.time);
        uint remain = GETREMAINPERCENT819();
        if(amountA > 0){
            uint mkAmount = isChargeFee ? mk.amount.MUL266(remain) / totalPercent : mk.amount;
            uint mpBalance = isChargeFee ? mp.balance.MUL266(remain) / totalPercent : mp.balance;
            _amountA = Math.MIN959(Math.MIN959(amountA, mkAmount), mpBalance);
            if (_amountA == mkAmount) {
                mk.amount = 0;
            } else {
                mk.amount = mk.amount.SUB798(isChargeFee ? _amountA.MUL266(totalPercent) / remain : _amountA);
            }
        }
        if(mp.swapIn > 0 && mp.swapOut > 0){
            amountB = Math.MIN959(mp.swapIn, mk.amount.MUL266(mp.swapIn) / mp.swapOut);
            mk.amount = mk.amount.SUB798(amountB.MUL266(mp.swapOut) / mp.swapIn);
            if (isChargeFee) {
                amountB = amountB.MUL266(remain) / totalPercent;
            } else if (mk.poolId == currentPoolId) {
                uint rewards = amountB.MUL266(feePercent) / totalPercent;
                if(left){
                    if (rewards > fee1) {
                        rewards = fee1;
                    }
                }else{
                    if (rewards > fee0) {
                        rewards = fee0;
                    }
                }
                rewardsB = rewards;
            }
        }
        remainA = mk.amount;
    }
    
    function _UPDATE379(uint balance0, uint balance1) private {	//inject NONSTANDARD NAMING
        require(balance0 <= uint(-1) && balance1 <= uint(-1), 'HiposwapV2Pair: OVERFLOW');
        reserve0 = balance0;
        reserve1 = balance1;
        emit SYNC847(reserve0, reserve1);
    }
    
    function SWAP628(uint amount0Out, uint amount1Out, address to, bytes calldata data) external override LOCK227 {	//inject NONSTANDARD NAMING
        require(amount0Out > 0 || amount1Out > 0, 'HiposwapV2Pair: INSUFFICIENT_OUTPUT_AMOUNT');
        (uint _reserve0, uint _reserve1) = GETRESERVES45(); // gas savings
        require(amount0Out <= _reserve0 && amount1Out <= _reserve1, 'HiposwapV2Pair: INSUFFICIENT_LIQUIDITY');

        uint balance0;
        uint balance1;
        { // scope for _token{0,1}, avoids stack too deep errors
        address _token0 = token0;
        address _token1 = token1;
        require(to != _token0 && to != _token1, 'HiposwapV2Pair: INVALID_TO');
        if (amount0Out > 0) _SAFETRANSFER677(_token0, to, amount0Out); // optimistically transfer tokens
        if (amount1Out > 0) _SAFETRANSFER677(_token1, to, amount1Out); // optimistically transfer tokens
        if (data.length > 0) IHiposwapV1Callee(to).HIPOSWAPV1CALL113(msg.sender, amount0Out, amount1Out, data);
        balance0 = IERC20(_token0).BALANCEOF40(address(this));
        balance1 = IERC20(_token1).BALANCEOF40(address(this));
        }
        uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
        uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
        require(amount0In > 0 || amount1In > 0, 'HiposwapV2Pair: INSUFFICIENT_INPUT_AMOUNT');
        
        if (amount0In > 0) {
            uint fee = amount0In.MUL266(feePercent) / totalPercent; //  = 10/10000
            uint feeAdmin = amount0In.MUL266(feeAdminPercent) / totalPercent; // = 5/10000
            uint swapIn = amount0In.SUB798(fee).SUB798(feeAdmin);
            MakerPool storage mp = makerPools1[currentPoolId1];
            mp.swapIn = mp.swapIn.ADD545(swapIn);
            mp.swapOut = mp.swapOut.ADD545(amount1Out);
            mp.balance = mp.balance.SUB798(amount1Out);
            ADDFEE570(false, fee, feeAdmin);
        }
        if (amount1In >0) {
            uint fee = amount1In.MUL266(feePercent) / totalPercent; //  = 10/10000
            uint feeAdmin = amount1In.MUL266(feeAdminPercent) / totalPercent; // = 5/10000
            uint swapIn = amount1In.SUB798(fee).SUB798(feeAdmin);
            MakerPool storage mp = makerPools0[currentPoolId0];
            mp.swapIn = mp.swapIn.ADD545(swapIn);
            mp.swapOut = mp.swapOut.ADD545(amount0Out);
            mp.balance = mp.balance.SUB798(amount0Out);
            ADDFEE570(true, fee, feeAdmin);
        }

        _UPDATE379(balance0, balance1);
        emit SWAP682(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
    }
    
}

// File: contracts/interfaces/IHiposwapV2Util.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6;

interface IHiposwapV2Util {
    function PAIRCREATIONCODE232() external returns (bytes memory bytecode);	//inject NONSTANDARD NAMING
}

// File: contracts/HiposwapV2Util.sol

// SPDX-License-Identifier: MIT
pragma solidity =0.6.6;



contract HiposwapV2Util is IHiposwapV2Util {
    function PAIRCREATIONCODE232() external override returns (bytes memory bytecode){	//inject NONSTANDARD NAMING
        bytecode = type(HiposwapV2Pair).creationCode;
    }
}