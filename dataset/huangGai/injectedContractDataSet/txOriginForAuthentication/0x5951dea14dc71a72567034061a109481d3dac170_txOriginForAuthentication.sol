pragma solidity ^0.5.4;

library SafeMath {
    
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
  
}

contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Crowdsale {
    
  using SafeMath for uint;    
    
  address public owner;
  
  address payable public wallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
  
  address public token = 0x42588776F50789AE5Ce2D9CE0c63F5dFE12F758c;
  
  uint public price; // coins per wei

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

    _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
  
  function setPrice(uint newPrice) public onlyOwner {
    price = newPrice;  
  }
  
  function setWallet(address payable newWallet) public onlyOwner {
    wallet = newWallet;
  }
  
  function setToken(address newToken) public onlyOwner {
    token = newToken;
  }
  
  function retrieveTokens(address to, address anotherToken) public onlyOwner {
    ERC20Basic alienToken = ERC20Basic(anotherToken);
    alienToken.transfer(to, alienToken.balanceOf(address(this)));
  }
  
  function () external payable {
    wallet.transfer(msg.value);  
    uint tokens = msg.value.mul(price).div(1000000000000000000);
    ERC20Basic(token).transfer(msg.sender, tokens);
  }

}