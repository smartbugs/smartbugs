/**
 *Submitted for verification at Etherscan.io on 2020-08-17
*/

pragma solidity 0.5.16;

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) 
            return 0;
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }

    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        if(a % b != 0)
            c = c + 1;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        //require(b <= a);
        uint256 c = a - b;
        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }

    int256 constant private INT256_MIN = -2^255;

    function mul(int256 a, int256 b) internal pure returns (int256) {
        if (a == 0) 
            return 0;
        int256 c = a * b;
        require(c / a == b && (a != -1 || b != INT256_MIN));
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != 0 && (b != -1 || a != INT256_MIN));
        int256 c = a / b;
        return c;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function sqrt(int256 x) internal pure returns (int256) {
        int256 z = add(x / 2, 1);
        int256 y = x;
        while (z < y)
        {
            y = z;
            z = ((add((x / z), z)) / 2);
        }
        return y;
    }
}


contract ERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balances;
    mapping (address => mapping (address => uint256)) internal _allowed;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    uint256 internal _totalSupply;

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param owner The address to query the balance of.
    * @return A uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    /**
    * @dev Function to check the amount of tokens that an owner allowed to a spender.
    * @param owner address The address which owns the funds.
    * @param spender address The address which will spend the funds.
    * @return A uint256 specifying the amount of tokens still available for the spender.
    */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    /**
    * @dev Transfer token to a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    * Beware that changing an allowance with this method brings the risk that someone may use both the old
    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    * @param spender The address which will spend the funds.
    * @param value The amount of tokens to be spent.
    */
    function approve(address spender, uint256 value) public returns (bool) {
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
    * @dev Transfer tokens from one address to another.
    * Note that while this function emits an Approval event, this is not required as per the specification,
    * and other compliant implementations may not emit the event.
    * @param from address The address which you want to send tokens from
    * @param to address The address which you want to transfer to
    * @param value uint256 the amount of tokens to be transferred
    */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        _transfer(from, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

}

contract ERC20Mintable is ERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;

    function _mint(address to, uint256 amount) internal {
        _balances[to] = _balances[to].add(amount);
        _totalSupply = _totalSupply.add(amount);
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        _balances[from] = _balances[from].sub(amount);
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(from, address(0), amount);
    }
}

contract CERC20 is ERC20 {
    function borrow(uint256) external returns (uint256);
    function borrowBalanceCurrent(address) external returns (uint256);
    function repayBorrow(uint256) external returns (uint256);
    function mint(uint256) external returns (uint256);
    function redeemUnderlying(uint256) external returns (uint256);
    function balanceOfUnderlying(address) external returns (uint256);
}


interface Comptroller {
    function enterMarkets(address[] calldata) external returns (uint256[] memory);
}

contract UniswapV2Router02 {
    function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
}

contract blackholeswap is ERC20Mintable {
    using SafeMath for *;

    /***********************************|
    |        Variables && Events        |
    |__________________________________*/

    Comptroller constant comptroller = Comptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
    UniswapV2Router02 constant uniswap = UniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    ERC20 constant Comp = ERC20(0xc00e94Cb662C3520282E6f5717214004A7f26888);
    ERC20 constant Dai = ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    ERC20 constant USDC = ERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    CERC20 constant cDai = CERC20(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    CERC20 constant cUSDC = CERC20(0x39AA39c021dfbaE8faC545936693aC917d5E7563);

    event Purchases(address indexed buyer, address indexed sell_token, uint256 inputs, address indexed buy_token, uint256 outputs);
    event AddLiquidity(address indexed provider, uint256 share, int256 DAIAmount, int256 USDCAmount);
    event RemoveLiquidity(address indexed provider, uint256 share, int256 DAIAmount, int256 USDCAmount);

    /***********************************|
    |            Constsructor           |
    |__________________________________*/

    constructor() public {
        symbol = "BHSc$";
        name = "BlackHoleSwap-Compound DAI/USDC v1";
        decimals = 18;

        Dai.approve(address(cDai), uint256(-1));
        USDC.approve(address(cUSDC), uint256(-1));
        Comp.approve(address(uniswap), uint256(-1));

        address[] memory cTokens = new address[](2);
        cTokens[0] = address(cDai);
        cTokens[1] = address(cUSDC);
        uint256[] memory errors = comptroller.enterMarkets(cTokens);
        require(errors[0] == 0 && errors[1] == 0, "Comptroller.enterMarkets failed.");

        admin = msg.sender;
    }

    /***********************************|
    |        Governmence & Params       |
    |__________________________________*/

    uint256 public fee = 0.99985e18;
    uint256 public protocolFee = 0;
    uint256 public constant amplifier = 0.75e18;

    address private admin;
    address private vault;

    function setAdmin(address _admin) external {
        require(msg.sender == admin);
        admin = _admin;
    }

    function setParams(uint256 _fee, uint256 _protocolFee) external {
        require(msg.sender == admin);
        require(_fee < 1e18 && _fee >= 0.99e18); //0 < fee <= 1%
        if(_protocolFee > 0)
            require(uint256(1e18).sub(_fee).div(_protocolFee) >= 3); //protocolFee < 33.3% fee
        fee = _fee;
        protocolFee = _protocolFee;
    }

    function setVault(address _vault) external {
        require(msg.sender == admin);
        vault = _vault;
    }

    /***********************************|
    |         Getter Functions          |
    |__________________________________*/

    function getDaiBalance() public returns (uint256, uint256) {
        if (cDai.balanceOf(address(this)) <= 10)
            return (0, cDai.borrowBalanceCurrent(address(this)));
        else
            return (cDai.balanceOfUnderlying(address(this)), cDai.borrowBalanceCurrent(address(this)));
    }

    function getUSDCBalance() public returns (uint256, uint256) {
        if (cUSDC.balanceOf(address(this)) <= 10)
            return (0, cUSDC.borrowBalanceCurrent(address(this)).mul(rate()) );
        else
            return (cUSDC.balanceOfUnderlying(address(this)).mul(rate()), cUSDC.borrowBalanceCurrent(address(this)).mul(rate()));
    }

    // DAI + USDC
    function S() external returns (uint256) {
        (uint256 a, uint256 b) = getDaiBalance();
        (uint256 c, uint256 d) = getUSDCBalance();
        return(a.add(c).sub(b).sub(d));
    }

    function F(int256 _x, int256 x, int256 y) internal pure returns (int256 _y) {
        int256 k;
        int256 c;
        {
            // u = x + ay, v = y + ax
            int256 u = x.add(y.mul(int256(amplifier)).div(1e18));
            int256 v = y.add(x.mul(int256(amplifier)).div(1e18));
            k = u.mul(v); // k = u * v
            c = _x.mul(_x).sub( k.mul(1e18).div(int256(amplifier)) ); // c = x^2 - k/a
        }
        
        int256 cst = int256(amplifier).add(1e36.div(int256(amplifier))); // a + 1/a
        int256 b = _x.mul(cst).div(1e18); 

        // y^2 + by + c = 0
        // D = b^2 - 4c
        // _y = (-b + sqrt(D)) / 2

        int256 D = b.mul(b).sub(c.mul(4));

        require(D >= 0, "no root");

        _y = (-b).add(D.sqrt()).div(2);

    }

    function getInputPrice(uint256 input, uint256 a, uint256 b, uint256 c, uint256 d) public pure returns (uint256) {
        int256 x = int256(a).sub(int256(b));
        int256 y = int256(c).sub(int256(d));
        int256 _x = x.add(int256(input));

        int256 _y = F(_x, x, y);

        return uint256(y.sub(_y));
    }

    function getOutputPrice(uint256 output, uint256 a, uint256 b, uint256 c, uint256 d) public pure returns (uint256) {
        int256 x = int256(a).sub(int256(b));
        int256 y = int256(c).sub(int256(d));
        int256 _y = y.sub(int256(output));

        int256 _x = F(_y, y, x);

        return uint256(_x.sub(x));
    }

    function rate() public pure returns (uint256) {
        return 1e12;
    }

    /***********************************|
    |        Exchange Functions         |
    |__________________________________*/
    
    function calcFee(uint256 input, uint256 a, uint256 b, uint256 c, uint256 d) internal {
        if(protocolFee > 0) {
            uint256 _fee = input.mul(protocolFee).mul(_totalSupply).div(1e18).div( a.add(c).sub(b).sub(d) );
            _mint(vault, _fee);
        }
    }

    function dai2usdcIn(uint256 input, uint256 min_output, uint256 deadline) external returns (uint256) {
        require(block.timestamp <= deadline, "EXPIRED");
        (uint256 a, uint256 b) = getDaiBalance();
        (uint256 c, uint256 d) = getUSDCBalance();

        uint256 output = getInputPrice(input.mul(fee).div(1e18), a, b, c, d);
        securityCheck(input, output, a, b, c, d);
        output = output.div(rate());
        require(output >= min_output, "SLIPPAGE_DETECTED");

        calcFee(input, a, b, c, d);

        doTransferIn(Dai, cDai, b, msg.sender, input);
        doTransferOut(USDC, cUSDC, c.div(rate()), msg.sender, output);

        emit Purchases(msg.sender, address(Dai), input, address(USDC), output);

        return output;
    }
    
    function usdc2daiIn(uint256 input, uint256 min_output, uint256 deadline) external returns (uint256) {
        require(block.timestamp <= deadline, "EXPIRED");
        (uint256 a, uint256 b) = getDaiBalance();
        (uint256 c, uint256 d) = getUSDCBalance();

        uint256 output = getInputPrice(input.mul(fee).div(1e6), c, d, a, b); // input * rate() * fee / 1e18
        securityCheck(input.mul(rate()), output, c, d, a, b);
        require(output >= min_output, "SLIPPAGE_DETECTED");
        
        calcFee(input.mul(rate()), a, b, c, d);
        
        doTransferIn(USDC, cUSDC, d.div(rate()), msg.sender, input);
        doTransferOut(Dai, cDai, a, msg.sender, output);

        emit Purchases(msg.sender, address(USDC), input, address(Dai), output);

        return output;
    }

    function dai2usdcOut(uint256 max_input, uint256 output, uint256 deadline) external returns (uint256) {
        require(block.timestamp <= deadline, "EXPIRED");
        (uint256 a, uint256 b) = getDaiBalance();
        (uint256 c, uint256 d) = getUSDCBalance();

        uint256 input = getOutputPrice(output.mul(rate()), a, b, c, d);
        securityCheck(input, output.mul(rate()), a, b, c, d);
        input = input.mul(1e18).divCeil(fee);
        require(input <= max_input, "SLIPPAGE_DETECTED");

        calcFee(input, a, b, c, d);

        doTransferIn(Dai, cDai, b, msg.sender, input);
        doTransferOut(USDC, cUSDC, c.div(rate()), msg.sender, output);

        emit Purchases(msg.sender, address(Dai), input, address(USDC), output);

        return input;
    }
    
    function usdc2daiOut(uint256 max_input, uint256 output, uint256 deadline) external returns (uint256) {
        require(block.timestamp <= deadline, "EXPIRED");
        (uint256 a, uint256 b) = getDaiBalance();
        (uint256 c, uint256 d) = getUSDCBalance();

        uint256 input = getOutputPrice(output, c, d, a, b);
        securityCheck(input, output, c, d, a, b);
        input = input.mul(1e6).divCeil(fee); // input * 1e18 / fee / 1e12
        require(input <= max_input, "SLIPPAGE_DETECTED");

        calcFee(input.mul(rate()), a, b, c, d);

        doTransferIn(USDC, cUSDC, d.div(rate()), msg.sender, input);
        doTransferOut(Dai, cDai, a, msg.sender, output);

        emit Purchases(msg.sender, address(USDC), input, address(Dai), output);

        return input;
    }
    
    function doTransferIn(ERC20 token, CERC20 ctoken, uint256 debt, address from, uint256 amount) internal {
        require(token.transferFrom(from, address(this), amount));

        if(debt > 0) {
            if(debt >= amount) {
                require(ctoken.repayBorrow(amount) == 0, "ctoken.repayBorrow failed");
            }
            else {
                require(ctoken.repayBorrow(debt) == 0, "ctoken.repayBorrow failed");
                require(ctoken.mint(amount.sub(debt)) == 0, "ctoken.mint failed");
            }
        }
        else {
            require(ctoken.mint(amount) == 0, "ctoken.mint failed");
        }
    }

    function doTransferOut(ERC20 token, CERC20 ctoken, uint256 balance, address to, uint256 amount) internal {
        if(balance >= amount) {
            require(ctoken.redeemUnderlying(amount) == 0, "ctoken.redeemUnderlying failed");
        }
        else {
            if(balance == 0) {
                require(ctoken.borrow(amount) == 0, "ctoken.borrow failed");
            }
            else {
                require(ctoken.redeemUnderlying(balance) == 0, "ctoken.redeemUnderlying failed");
                require(ctoken.borrow(amount.sub(balance)) == 0, "ctoken.borrow failed");
            }
        }

        require(token.transfer(to, amount));
    }

    function securityCheck(uint256 input, uint256 output, uint256 a, uint256 b, uint256 c, uint256 d) internal pure {
        if(c < output.add(d))
            require(output.add(d).sub(c).mul(100) < input.add(a).sub(b).mul(62), "DEBT_TOO_MUCH"); // debt/collateral < 62%
    }

    /***********************************|
    |        Liquidity Functions        |
    |__________________________________*/

    function addLiquidity(uint256 share, uint256[4] calldata tokens) external returns (uint256 dai_in, uint256 dai_out, uint256 usdc_in, uint256 usdc_out) {
        require(share >= 1e15, 'INVALID_ARGUMENT'); // 1000 * rate()

        collectComp();

        if (_totalSupply > 0) {
            (uint256 a, uint256 b) = getDaiBalance();
            (uint256 c, uint256 d) = getUSDCBalance();

            dai_in = share.mul(a).divCeil(_totalSupply);
            dai_out = share.mul(b).div(_totalSupply);
            usdc_in = share.mul(c).divCeil(_totalSupply.mul(rate()));
            usdc_out = share.mul(d).div(_totalSupply.mul(rate()));
            require(dai_in <= tokens[0] && dai_out >= tokens[1] && usdc_in <= tokens[2] && usdc_out >= tokens[3], "SLIPPAGE_DETECTED");
            
            _mint(msg.sender, share);

            if(dai_in > 0)
                doTransferIn(Dai, cDai, b, msg.sender, dai_in);
            if(usdc_in > 0)
                doTransferIn(USDC, cUSDC, d.div(rate()), msg.sender, usdc_in);
            if(dai_out > 0)
                doTransferOut(Dai, cDai, a, msg.sender, dai_out);
            if(usdc_out > 0)
                doTransferOut(USDC, cUSDC, c.div(rate()), msg.sender, usdc_out);

            int256 dai_amount = int256(dai_in).sub(int256(dai_out));
            int256 usdc_amount = int256(usdc_in).sub(int256(usdc_out));

            emit AddLiquidity(msg.sender, share, dai_amount, usdc_amount);
            return (dai_in, dai_out, usdc_in, usdc_out);
        } else {
            uint256 dai_amount = share.divCeil(2);
            uint256 usdc_amount = share.divCeil(rate().mul(2));

            _mint(msg.sender, share);
            doTransferIn(Dai, cDai, 0, msg.sender, dai_amount);
            doTransferIn(USDC, cUSDC, 0, msg.sender, usdc_amount);
            
            emit AddLiquidity(msg.sender, share, int256(dai_amount), int256(usdc_amount));
            return (dai_amount, 0, usdc_amount, 0);
        }
    }

    function removeLiquidity(uint256 share, uint256[4] calldata tokens) external returns (uint256 dai_in, uint256 dai_out, uint256 usdc_in, uint256 usdc_out) {
        require(share > 0, 'INVALID_ARGUMENT');

        collectComp();

        (uint256 a, uint256 b) = getDaiBalance();
        (uint256 c, uint256 d) = getUSDCBalance();

        dai_out = share.mul(a).div(_totalSupply);
        dai_in = share.mul(b).divCeil(_totalSupply);
        usdc_out = share.mul(c).div(_totalSupply.mul(rate()));
        usdc_in = share.mul(d).divCeil(_totalSupply.mul(rate()));
        require(dai_in <= tokens[0] && dai_out >= tokens[1] && usdc_in <= tokens[2] && usdc_out >= tokens[3], "SLIPPAGE_DETECTED");

        _burn(msg.sender, share);

        if(dai_in > 0)
            doTransferIn(Dai, cDai, b, msg.sender, dai_in);
        if(usdc_in > 0)
            doTransferIn(USDC, cUSDC, d.div(rate()), msg.sender, usdc_in);
        if(dai_out > 0)
            doTransferOut(Dai, cDai, a, msg.sender, dai_out);
        if(usdc_out > 0)
            doTransferOut(USDC, cUSDC, c.div(rate()), msg.sender, usdc_out);

        int256 dai_amount = int256(dai_out).sub(int256(dai_in));
        int256 usdc_amount = int256(usdc_out).sub(int256(usdc_in));

        emit RemoveLiquidity(msg.sender, share, dai_amount, usdc_amount);

        return(dai_in, dai_out, usdc_in, usdc_out);
    }

    /***********************************|
    |           Collect Comp            |
    |__________________________________*/

    function collectComp() public {
        uint256 _comp = Comp.balanceOf(address(this));
        if(_comp == 0) return;

        (uint256 a, uint256 b) = getDaiBalance();
        (uint256 c, uint256 d) = getUSDCBalance();

        bool isDai = a.add(d) > c.add(b);

        address[] memory path = new address[](3);
        path[0] = address(Comp);
        path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; //weth
        path[2] = isDai ? address(Dai) : address(USDC);
        uint256[] memory amounts = uniswap.swapExactTokensForTokens(_comp, 0, path, address(this), now);

        if(isDai)
            require(cDai.mint(amounts[2]) == 0, "ctoken.mint failed");
        else
            require(cUSDC.mint(amounts[2]) == 0, "ctoken.mint failed");

    }

}