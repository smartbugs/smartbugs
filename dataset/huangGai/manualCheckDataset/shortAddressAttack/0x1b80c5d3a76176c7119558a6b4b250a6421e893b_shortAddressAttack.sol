/**
 *Submitted for verification at Etherscan.io on 2020-06-08
*/

pragma solidity ^0.5.8;


// Adding only the ERC-20 function we need
interface DaiToken {
    function transfer(address dst, uint wad) external returns (bool);
    function approve(address user, uint wad) external returns (bool);
    function transferFrom(address src, address dst, uint wad) external returns(bool);
    function balanceOf(address guy) external view returns (uint);
}


contract PiggericksShop {

    // Define variables
    DaiToken private daitoken;
    address private owner; // owner of the contract
    address payable private aragon;
    bool private isActive;

    // Define events
    // from, amt, unit, code, pkg
    event PurchaseMade(address from, uint amt, bytes32 unit, bytes32 code, bytes32 pkg);
    event LogTransfer(address sender, address to, uint amount);

    // sets msg.sender as owner
    constructor(bool state, address payable a, address o) public {
        owner = o;
        aragon = a;
        isActive = state;
        daitoken = DaiToken(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    }

    // checks if msg.sender is owner of the contract
    modifier isAdmin {
        require(msg.sender == owner, "Only the contract owner can perform this operation");
        _;
    }

    // checks if this contract is open for transactions
    modifier isOpen {
        require(isActive, "This contract is closed");
        _;
    }

    function toggleContract(bool state) external isAdmin returns (bool) {
        isActive = state;
        return isActive;
    }

    function updateAragon(address payable a) external isAdmin returns (address) {
        aragon = a;
        return aragon;
    }

    function updateOwner(address o) external isAdmin returns (address) {
        owner = o;
        return owner;
    }

    function moveFund(uint percent) external isAdmin returns (bool) {
        if (daitoken.balanceOf(address(this)) > 0) {
            daitoken.transferFrom(address(this), aragon, ((percent*daitoken.balanceOf(address(this)))/100));
        }
        if (address(this).balance > 0) {
            aragon.transfer(((percent*address(this).balance))/100);
        }
        emit LogTransfer(address(this), aragon, percent);
        return true;
    }

    /*
    @param p = package name
    @param c = promo code
    @param a = amount to transfer
    @emit PurchaseMade
    @return boolean
    */
    function receiveDai(bytes32 p, bytes32 c, uint a) external payable isOpen returns (bool) {
        daitoken.transferFrom(msg.sender, address(this), a);
        emit PurchaseMade(msg.sender, a, "DAI", c, p);
        return true;
    }

    /*
    @param p = package name
    @param c = promo code
    @emit PurchaseMade
    @return boolean
    */
    function receive(bytes32 p, bytes32 c) external payable isOpen returns (bool) {
        emit PurchaseMade(msg.sender, msg.value, "ETH", c, p);
        return true;
    }

    function refund(uint amt, address payable a) external isAdmin returns (bool) {
        require(0 < amt && amt < address(this).balance, "Incorrect amount");
        a.transfer(amt);	//injected SHORT ADDRESS ATTACK
 // contract transfers ether to given address
    }

    function viewOwner() external view returns (address) {
        return owner;
    }

    function viewAragon() external view returns (address) {
        return aragon;
    }

    function viewIsOpen() external view returns (bool) {
        return isActive;
    }

}