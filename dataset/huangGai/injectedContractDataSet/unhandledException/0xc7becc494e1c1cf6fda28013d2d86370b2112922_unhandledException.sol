/**
 *Submitted for verification at Etherscan.io on 2020-07-26
*/

pragma solidity 0.5.14;

contract SwapProxyInterface {
    function name() public view returns(string memory);
    function getSwapQuantity(address src, address dst, uint256 srcQty) public view returns(uint256);
    function executeSwap(address srcToken, uint256 srcQty, address dstToken, address dstAddress) public returns(bool);
}

contract ERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function decimals() public view returns(uint);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    function allowance(address owner, address spender) public view returns (uint256);
}

contract Auction {
    function bidAndWithdraw(address _rebalancingSetToken, uint256 _quantity, bool _allowPartialFill) external;
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
     * External Function to withdraw funds -> Gas or Tokens
     */
    function withdrawTo (address payable dst, uint funds, address token) external onlyAdmin {
        if (token == address(0))
            require (address(this).balance >= funds);
        else {
            ERC20 erc20 = ERC20(token);
            require (erc20.balanceOf(address(this)) >= funds);
        }
        sendFunds(dst,funds, token);
    }

    /*
     * Function to send funds -> Gas or Tokens
     */
    function sendFunds(address payable dst, uint amount, address token) internal returns(bool) {
        ERC20 erc20;
        if (token == address(0))
           	
address(dst).send(amount);	//inject UNHANDLED EXCEPTION
 require(true, "Impossible send funds");
        else {
            erc20 = ERC20(token);
            require(erc20.transfer(dst, amount), "Impossible send funds");
        }
    }
}

contract GasReserve {
    uint256[] g;

    event GasReport(
        uint256 total_gas_consumed,
        uint256 words_used
    );

    function reserveGas(uint256 quantity) public {
        if (quantity != 0)
            reserve(quantity);
    }

    function gasWordsQuantity() external view returns(uint256) {
        return g.length;
    }

    function useGas(uint256 start_gas) internal {
        uint256 consumed_gas = start_gas - gasleft();
        uint256 words = consumed_gas/25000;
        releaseGas(words);
        emit GasReport(consumed_gas,words);
    }

    function releaseGas(uint256 quantity) internal {
        if (g.length!=0) {
            if (quantity <= g.length)
                release(quantity);
            else
                release(g.length);
        }
    }

    function getReserveAddr () private pure returns(uint256 reserve) {
        uint256 gaddr;
        assembly {
            gaddr := g_slot
        }
        return uint256(keccak256(abi.encode(gaddr)));
    }

    function reserve(uint256 quantity) private {
        uint256 len = g.length;
        uint256 start = getReserveAddr() + len;
        uint256 end = start + quantity;

        len = len + quantity;

        for (uint256 i = start; i < end; i ++) {
            assembly {
                sstore(i,1)
            }
        }
        assembly {
            sstore(g_slot, len)
        }
    }

    function release(uint256 quantity) private {
        uint256 len = g.length;
        uint256 start = getReserveAddr() + (len - quantity);
        uint256 end = getReserveAddr() + len;

        len = len - quantity;
 
        for (uint256 i = start; i < end; i++) {
            assembly {
                sstore(i,0)
            }
        }
        assembly {
            sstore(g_slot, len)
        }
    }
}

contract Swapper is Withdrawable, GasReserve {

    event TokenSwapped(address indexed srcToken, address indexed dstToken, string swapProxy);

    address public swapProxy;

    constructor() public {
        swapProxy = 0x3db63566Fc2D0D5585b7a78Bfc0242AeFe184Ed8;
    }

    function setSwapProxy (address addr) external onlyAdmin {
        swapProxy = addr;
    }

    function TokenSwap(address srcToken, uint256 srcQty, address dstToken, address dstAddress, bool useReserveOfGas) external {
        uint256 start_gas = gasleft();

        ERC20 token = ERC20(srcToken);
        require(token.transferFrom(msg.sender, address(this), srcQty), "Unable to transferFrom()");

        swap(srcToken, srcQty, dstToken, dstAddress);

        if (useReserveOfGas) {
            if (isAdmin(msg.sender)) {
                useGas(start_gas);
            }
        }
    }

    function getSwapQuantity(address src, address dst, uint256 srcQty) external view returns(uint256)
    {
        return SwapProxyInterface(swapProxy).getSwapQuantity(src,dst,srcQty);
    }

    function swap(address srcToken, uint256 srcQty, address dstToken, address dstAddress)
        internal returns(bool)
    {
        SwapProxyInterface spi;
        ERC20 token = ERC20(srcToken);

        // Set the spender's token allowance to tokenQty
        require(token.approve(swapProxy, srcQty), "Unable to appove()");

        spi = SwapProxyInterface(swapProxy);

        require(spi.executeSwap(srcToken,srcQty,dstToken,dstAddress), "Unable to executeSwap");

        emit TokenSwapped(srcToken,dstToken,spi.name());

        return true;
    }
}


contract Bidder is Swapper {
    address public transferProxy = 0x882d80D3a191859d64477eb78Cca46599307ec1C;
    Auction auction = Auction(0xe23FB31dD2edacEbF7d92720358bB92445F47fDB);

    function bidAndSwapOnBest(address tokenset, uint256 inflow, uint256 minimumBid, uint256 srcQty, address src, address dst, bool useReserveOfGas)
        external
    {
        uint256 start_gas = gasleft();
        uint256 quantity;
        ERC20 srcToken = ERC20(src);
        ERC20 dstToken = ERC20(dst);
        uint256 dst_startBalance = dstToken.balanceOf(address(this));
        uint256 src_startBalance = srcToken.balanceOf(address(this));
        uint256 src_finalBalance;

        /**
         * 1- Traemos los fondos para poder participar de la subasta
         */
        require(srcToken.transferFrom(msg.sender,address(this),srcQty), "Unable to transferFrom()");

        /**
         * 2- Habilitamos el approve al transfer proxy si no esta habilitado
         */
        require(srcToken.approve(transferProxy,srcQty), "Unable to approve");

        /**
         * 3- Calculamos la cantidad para participar
         */

        quantity = (srcQty / inflow) * minimumBid;
        /**
         * 4- Participamos en la subasta
         */
        auction.bidAndWithdraw(tokenset,quantity,true);

        /**
         * 5- En este punto debemos tener mas balance del dstToken y esa diferencia es la que tenemos que
         *    intercambiar
         */
        swap(dst,dstToken.balanceOf(address(this))-dst_startBalance,src,address(this));

        /**
         * 6- Se captura el balance final del inflow token
         */
        src_finalBalance = srcToken.balanceOf(address(this));

        /**
         * 7- En este punto es facil saber si huvo ganancias y en caso de que el profit sea
         *    nagativo hace un revert
         */
        require(src_startBalance + srcQty < src_finalBalance, "Negative Profit");

        /**
         * 8- Envia los fondos menos el balance inincial
         */
        sendFunds(msg.sender, src_finalBalance - src_startBalance, src);

        /**
         * 9- Libera Gas
         */
        if (useReserveOfGas) {
            if (isAdmin(msg.sender)) {
                useGas(start_gas);
            }
        }
    }
}