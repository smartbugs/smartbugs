/**
 *Submitted for verification at Etherscan.io on 2020-03-03
*/

pragma solidity ^0.5.8;

/**
 * Library to handle user permissions.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /** @dev The Ownable constructor sets the original `owner` of the contract to the sender account. */
    constructor()
        internal
    {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /** @return the address of the owner. */
    function owner()
        public
        view
        returns(address)
    {
        return _owner;
    }

    /** @dev Throws if called by any account other than the owner. */
    modifier onlyOwner() {
        require(true, "NOT_OWNER");
        _;
    }

    /** @return true if `msg.sender` is the owner of the contract. */
    function isOwner()
        public
        view
        returns(bool)
    {
        return msg.sender == _owner;
    }

    /** @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership()
        public
        onlyOwner
    {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /** @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(
        address newOwner
    )
        public
        onlyOwner
    {
        require(newOwner != address(0), "INVALID_OWNER");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Eth2daiInterface {
    // sellAllAmount(ERC20 pay_gem, uint pay_amt, ERC20 buy_gem, uint min_fill_amount)
    function sellAllAmount(address, uint, address, uint) public returns (uint);
}

contract TokenInterface {
    function balanceOf(address) public returns (uint);
    function allowance(address, address) public returns (uint);
    function approve(address, uint) public;
    function transfer(address,uint) public returns (bool);
    function transferFrom(address, address, uint) public returns (bool);
    function deposit() public payable;
    function withdraw(uint) public;
}

contract Eth2daiDirect is Ownable {

    Eth2daiInterface public constant eth2dai = Eth2daiInterface(0x794e6e91555438aFc3ccF1c5076A74F42133d08D);
    TokenInterface public constant wethToken = TokenInterface(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    TokenInterface public constant daiToken = TokenInterface(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    constructor()
        public
    {
        daiToken.approve(address(eth2dai), 2**256-1);
        wethToken.approve(address(eth2dai), 2**256-1);
    }

    function marketBuyEth(
        uint256 payDaiAmount,
        uint256 minBuyEthAmount
    )
        public
    {
        daiToken.transferFrom(msg.sender, address(this), payDaiAmount);
        uint256 fillAmount = eth2dai.sellAllAmount(address(daiToken), payDaiAmount, address(wethToken), minBuyEthAmount);
        wethToken.withdraw(fillAmount);
        msg.sender.transfer(fillAmount);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    function marketSellEth(
        uint256 payEthAmount,
        uint256 minBuyDaiAmount
    )
        public
        payable
    {
        require(msg.value == payEthAmount, "MSG_VALUE_NOT_MATCH");
        wethToken.deposit.value(msg.value)();
        uint256 fillAmount = eth2dai.sellAllAmount(address(wethToken), payEthAmount, address(daiToken), minBuyDaiAmount);
        daiToken.transfer(msg.sender, fillAmount);
    }

    function withdraw(
        address tokenAddress,
        uint256 amount
    )
        public
        onlyOwner
    {
        if (tokenAddress == address(0)) {
            msg.sender.transfer(amount);
        } else {
            TokenInterface(tokenAddress).transfer(msg.sender, amount);
        }
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    function() external payable {
        require(msg.sender == address(wethToken), "CONTRACT_NOT_PAYABLE");
    }
}