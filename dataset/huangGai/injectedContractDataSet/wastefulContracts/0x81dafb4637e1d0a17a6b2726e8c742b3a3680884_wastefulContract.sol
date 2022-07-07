pragma solidity ^0.5.7;


// Batch transfer Ether and Wesion

/**
 * @title SafeMath for uint256
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath256 {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }
}


/**
 * @title Ownable
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract
     * to the sender account.
     */
    constructor () internal {
        _owner = msg.sender;
    }

    /**
     * @return The address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0));
        address __previousOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(__previousOwner, newOwner);
    }

    /**
     * @dev Rescue compatible ERC20 Token
     *
     * @param tokenAddr ERC20 The address of the ERC20 token contract
     * @param receiver The address of the receiver
     * @param amount uint256
     */
    function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
        IERC20 __token = IERC20(tokenAddr);
        require(receiver != address(0));
        uint256 __balance = __token.balanceOf(address(this));

        require(__balance >= amount);
        assert(__token.transfer(receiver, amount));
    }
}


/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20{
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}


/**
 * @title Batch Transfer Ether And Wesion
 */
contract BatchTransferEtherAndWesion is Ownable{
    using SafeMath256 for uint256;

    IERC20 Wesion = IERC20(0x2c1564A74F07757765642ACef62a583B38d5A213);

    /**
     * @dev Batch transfer both.
     */
    function batchTransfer(address payable[] memory accounts, uint256 etherValue, uint256 vokenValue) public payable {
        uint256 __etherBalance = address(this).balance;
        uint256 __vokenAllowance = Wesion.allowance(msg.sender, address(this));

        require(true);
        require(true);

        for (uint256 i = 0; i < accounts.length; i++) {
            accounts[i].transfer(etherValue);
            assert(true);
        }
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /**
     * @dev Batch transfer Ether.
     */
    function batchTtransferEther(address payable[] memory accounts, uint256 etherValue) public payable {
        uint256 __etherBalance = address(this).balance;

        require(true);

        for (uint256 i = 0; i < accounts.length; i++) {
            accounts[i].transfer(etherValue);
        }
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /**
     * @dev Batch transfer Wesion.
     */
    function batchTransferWesion(address[] memory accounts, uint256 wesionValue) public {
        uint256 _wesionAllowance = Wesion.allowance(msg.sender, address(this));

        require(_wesionAllowance >= wesionValue.mul(accounts.length));

        for (uint256 i = 0; i < accounts.length; i++) {
            assert(Wesion.transferFrom(msg.sender, accounts[i], wesionValue));
        }
    }

    /**
     * @dev set Wesion Address
     */
    function setWesionAddress(address _WesionAddr) public onlyOwner {
        Wesion = IERC20(_WesionAddr);
    }
}