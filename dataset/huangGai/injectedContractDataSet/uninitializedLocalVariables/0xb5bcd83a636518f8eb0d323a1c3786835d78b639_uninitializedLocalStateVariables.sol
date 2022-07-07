/**
 *Submitted for verification at Etherscan.io on 2020-07-14
*/

pragma solidity 0.5.14;


contract ERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function decimals() public view returns(uint);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    function allowance(address owner, address spender) public view returns (uint256);
}

contract CERC20 is ERC20 {
    function mint(uint256) external returns (uint256);
    function exchangeRateStored() public view returns (uint256);
    function supplyRatePerBlock() external returns (uint256);
    function redeem(uint) external returns (uint);
    function redeemUnderlying(uint) external returns (uint);
    function underlying() external view returns (address);
    function isCToken() public view returns (bool);
}


contract Kyber {
    function getExpectedRate(address src, address dest, uint srcQty)
        public view returns (uint expectedRate, uint slippageRate);

    function trade(address src, uint srcAmount, address dst, address destAddress, uint maxDestAmount, uint minConversionRate, address walletId)
        public payable returns(uint);
}


contract AdminRole {

    mapping (address => bool) adminGroup;
    address payable owner;

    constructor () public {
        adminGroup[msg.sender] = true;
        owner = msg.sender;
    }
    
    modifier onlyAdmin() {
        require(
            isAdmin(msg.sender),
            "The caller is not Admin"
        );
        _;
    }

    modifier onlyOwner {
        require(
            owner == msg.sender,
            "The caller is not Owner"
        );
        _;
    }

    function addAdmin(address addr) external onlyAdmin {
        adminGroup[addr] = true;
    }
    function delAdmin(address addr) external onlyAdmin {
        adminGroup[addr] = false;
    }

    function isAdmin(address addr) public view returns(bool) {
        return adminGroup[addr];
    }

    function kill() external onlyOwner {
        selfdestruct(owner);
    }
}

contract Withdrawable is AdminRole {
    /*
     * External Function to withdraw founds -> Gas or Tokens
     */
    function withdrawTo (address payable dst, uint founds, address token) external onlyAdmin {
        if (token == address(0))
            require (address(this).balance >= founds);
        else {
            ERC20 erc20 ;	//inject UNINIT LOCAL/STATE VAR

            require (erc20.balanceOf(address(this)) >= founds);
        }
        sendFounds(dst,founds, token);
    }

    /*
     * Function to send founds -> Gas or Tokens
     */
    function sendFounds(address payable dst, uint amount, address token) internal returns(bool) {
        ERC20 erc20;
        if (token == address(0))
            require(address(dst).send(amount), "Impossible send founds");
        else {
            erc20 = ERC20(token);
            require(erc20.transfer(dst, amount), "Impossible send founds");
        }
    }
}

contract KyberProxy {
    Kyber proxy;

    constructor () public {
        proxy = Kyber(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);
    }

    function getSwapQuantity_internal(address src, address dst, uint256 srcQty) internal view returns(uint256) {
        uint256 rate ;	//inject UNINIT LOCAL/STATE VAR

        ERC20 srcToken ;	//inject UNINIT LOCAL/STATE VAR

        uint256 ret;

        ret = (srcQty * (10**(18-srcToken.decimals())) * rate) / (10 ** 18);
        return ret;
    }

    function getSwapRate_internal(address src, address dst, uint256 srcQty) internal view returns(uint256) {
        uint256 rate;

        (rate,) = proxy.getExpectedRate(src,dst,srcQty);
        return rate;
    }

    function executeSwap_internal(address srcToken, uint256 srcQty, address dstToken, address dstAddress) internal returns(bool) {
        uint256 rate;
        uint256 bought;
        ERC20 token ;	//inject UNINIT LOCAL/STATE VAR


        rate = getSwapRate_internal(srcToken,dstToken,srcQty);

        require(token.transferFrom(msg.sender, address(this), srcQty), "Unable to transferFrom()");

        // Set the spender's token allowance to tokenQty
        require(token.approve(address(proxy), srcQty), "Unable to appove()");

        bought = proxy.trade(
            srcToken,
            srcQty,
            dstToken,
            dstAddress,
            0x8000000000000000000000000000000000000000000000000000000000000000,
            rate,
            address(0)
        );

        require(bought != 0, "Unable to exchange tokens");

        return true;
    }
}

contract CompoundProxy is AdminRole {
    mapping(address => bool) cTokens;


    constructor() public {
        cTokens[0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E] = true;
        cTokens[0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643] = true;
        cTokens[0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5] = true;
        cTokens[0x158079Ee67Fce2f58472A96584A73C7Ab9AC95c1] = true;
        cTokens[0xF5DCe57282A584D2746FaF1593d3121Fcac444dC] = true;
        cTokens[0x39AA39c021dfbaE8faC545936693aC917d5E7563] = true;
        cTokens[0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9] = true;
        cTokens[0xC11b1268C1A384e55C48c2391d8d480264A3A7F4] = true;
        cTokens[0xB3319f5D18Bc0D84dD1b4825Dcde5d5f7266d407] = true;
    }

    function addcToken(address _cToken) external onlyAdmin {
        cTokens[_cToken] = true;
    }

    function delcToken(address _cToken) external onlyAdmin {
        cTokens[_cToken] = false; 
    }

    function isCToken(address _token) internal view returns(bool) {
        return cTokens[_token];
    }

    function getUnderlying(address cToken) internal view returns(bool, address) {
        CERC20 token ;	//inject UNINIT LOCAL/STATE VAR


        if (token.isCToken()) {
            return (true, token.underlying());
        }
        return (false, address(0));
    }

    function supplyToCompound(address _erc20Contract, address _cErc20Contract, uint256 _numTokensToSupply) internal returns (uint) {
        // Create a reference to the underlying asset contract, like DAI.
        ERC20 underlying ;	//inject UNINIT LOCAL/STATE VAR


        // Create a reference to the corresponding cToken contract, like cDAI
        CERC20 cToken ;	//inject UNINIT LOCAL/STATE VAR


        // Approve transfer on the ERC20 contract
        underlying.approve(_cErc20Contract, _numTokensToSupply);

        // Mint cTokens
        uint mintResult ;	//inject UNINIT LOCAL/STATE VAR

        return mintResult;
    }

    function redeemFromCompound(uint256 amount, bool redeemType, address _cErc20Contract ) internal returns (bool) {
        // Create a reference to the corresponding cToken contract, like cDAI
        CERC20 cToken ;	//inject UNINIT LOCAL/STATE VAR


        // `amount` is scaled up by 1e18 to avoid decimals
        uint256 redeemResult;

        if (redeemType == true) {
            // Retrieve your asset based on a cToken amount
            redeemResult = cToken.redeem(amount);
        } else {
            // Retrieve your asset based on an amount of the asset
            redeemResult = cToken.redeemUnderlying(amount);
        }

        require(redeemResult == 0, "redeemResult error");

        return true;
    }

}


contract cTokenKyberBridge is KyberProxy, CompoundProxy, Withdrawable {
    string public name ;	//inject UNINIT LOCAL/STATE VAR



    function getTokens(address srcToken, uint256 qty) internal returns (bool){
        ERC20 token ;	//inject UNINIT LOCAL/STATE VAR


        return token.transferFrom(msg.sender, address(this), qty);
    }

    function tokenBalance(address src) internal view returns(uint256) {
        ERC20 token ;	//inject UNINIT LOCAL/STATE VAR

        return token.balanceOf(address(this));
    }

    function executeSwap(address src, address dst, uint256 srcQty) external {
        ERC20 token;
        bool ok;
        address srcToken;
        address dstToken;
        uint256 srcQuantity;


        require(getTokens(src,srcQty), "Unable to transferFrom()");

        /**
         * En este punto se verifica si el src es un cToken, en caso de que lo sea
         * se solicita a compound un reedem de los cToken por el token correspondiente
         */
        if (isCToken(src)) {
            (ok, srcToken) = getUnderlying(src);
            require(ok == true, "Maybe the src token is not cToken");
            require(redeemFromCompound(srcQty, true, src), "Unable to reedem from compound");
            srcQuantity = tokenBalance(srcToken);
        } else {
            srcToken = src;
            srcQuantity = srcQty;
        }

        /** 
         * Se aprueba al contrato exchenge a tomar los tokens
         */
        token = ERC20(srcToken);
        require(token.approve(address(proxy), srcQuantity), "Unable to appove()");


        /** 
         * Se verifica si el destino es un compound, en caso de que lo sea, se pide el underlying
         */
        if (isCToken(dst)) {
            (ok, dstToken) = getUnderlying(dst);
            require(ok == true, "Maybe the dst token is not cToken");
        } else {
            dstToken = dst;
        }

        /**
         * Ejecuta el swap
         */
        ok = executeSwap_internal(srcToken, srcQuantity, dstToken, address(this));
        require(ok == true, "Unable to execute swap");

        /**
         * Si el swap funciona y el destino era un token de compound lo intercambia
         */
        if (isCToken(dst)) {
            require(supplyToCompound(dstToken, dst, tokenBalance(dstToken)) == 0, "Unable to supply to Compound");
        }

        token = ERC20(dst);
        require(token.transfer(msg.sender,tokenBalance(dst)), "Unable to transfer dst token");
    }


    function getSwapQuantity(address src, address dst, uint256 srcQty) external view returns(uint256) {
        address srcToken;
        address dstToken;
        uint256 srcQuantity;
        uint256 dstQuantity;

        if (isCToken(src)) {
            // En este punto el souce es un cToken, hay que traer la direccion de su underlying
            // y ademas calcular de acuerdo a su rate la cantidad a pasarle al proxy
            srcToken = CERC20(src).underlying();
            srcQuantity = (srcQty * CERC20(src).exchangeRateStored()) / 10**18; 
        } else {
            srcToken = src;
            srcQuantity = srcQty;
        }

        if (isCToken(dst)) {
            // En este punto el destino es un cToken, hay que traer la direccion de su underlying
            dstToken = CERC20(dst).underlying();
        } else {
            dstToken = dst;
        }

        if (srcToken == dstToken) {
            // Un token es el underlying del otro 
            if (isCToken(dst)) {
                return (srcQuantity * 10**(36-ERC20(dst).decimals())) / CERC20(dst).exchangeRateStored();
            } else {
                return (srcQuantity * 10**(18-ERC20(dst).decimals()));
            }
        }

        dstQuantity = getSwapQuantity_internal(srcToken, dstToken, srcQuantity);

        if (isCToken(dst)) {
            dstQuantity = dstQuantity * 10**(18 + ERC20(dstToken).decimals() - ERC20(dst).decimals()) / CERC20(src).exchangeRateStored();
        }
        return dstQuantity;
    }
}