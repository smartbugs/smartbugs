pragma solidity ^0.5.8;

library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address internal owner;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        owner = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

}

contract IERC721 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) public view returns (uint256 balance);

    function ownerOf(uint256 tokenId) public view returns (address owner);

    function approve(address to, uint256 tokenId) public;

    function getApproved(uint256 tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;

    function isApprovedForAll(address owner, address operator) public view returns (bool);

    function transferFrom(address from, address to, uint256 tokenId) public;

    function safeTransferFrom(address from, address to, uint256 tokenId) public;

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}
/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20BasicInterface {
    function totalSupply() public view returns (uint256);

    function balanceOf(address who) public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    function transferFrom(address from, address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    uint8 public decimals;
}

contract Bussiness is Ownable {
    
    using SafeMath for uint256;
    address internal ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
    IERC721 internal erc721Address = IERC721(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B);
    ERC20BasicInterface internal hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
    uint256 internal ETHFee = 0; // 25 = 2,5 %
    uint256 internal Percen = 1000;
    uint256 internal HBWALLETExchange = 21;
    // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
    uint256 internal limitETHFee = 0;
    uint256 internal limitHBWALLETFee = 0;
    uint256 internal hightLightFee = 30000000000000000;
    constructor() public {}
    struct Price {
        address payable tokenOwner;
        uint256 price;
        uint256 fee;
        uint256 hbfee;
        bool isHightlight;
    }

    uint8[] internal arrayTokenIdSale;
    mapping(uint8 => Price) internal prices;

    /**
     * @dev Throws if called by any account other than the ceo address.
     */
    modifier onlyCeoAddress() {
        require(msg.sender == ceoAddress);
        _;
    }
    modifier isOwnerOf(uint8 _tokenId) {
        require(erc721Address.ownerOf(_tokenId) == msg.sender);
        _;
    }
    // Move the last element to the deleted spot.
    // Delete the last element, then correct the length.
    function _burnArrayTokenIdSale(uint8 index)  internal {
        if (index >= arrayTokenIdSale.length) return;

        for (uint i = index; i<arrayTokenIdSale.length-1; i++){
            arrayTokenIdSale[i] = arrayTokenIdSale[i+1];
        }
        delete arrayTokenIdSale[arrayTokenIdSale.length-1];
        arrayTokenIdSale.length--;
    }

    function _burnArrayTokenIdSaleByArr(uint8[] memory arr) internal {
        for(uint8 i; i<arr.length; i++){
            _burnArrayTokenIdSale(i);
        }

    }
    function ownerOf(uint256 _tokenId) public view returns (address){
        return erc721Address.ownerOf(_tokenId);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function balanceOf() public view returns (uint256){
        return address(this).balance;
    }

    function getApproved(uint256 _tokenId) public view returns (address){
        return erc721Address.getApproved(_tokenId);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setPrice(uint8 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, bool _isHightLight) internal {
        prices[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
        arrayTokenIdSale.push(_tokenId);
    }

    function calPriceFeeEth(uint8 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {
        uint256 ethfee;
        uint256 _hightLightFee = 0;
        uint256 ethNeed;
        if (_isHightLight == 1 && (prices[_tokenId].price == 0 || !prices[_tokenId].isHightlight)) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            _hightLightFee = hightLightFee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        if (prices[_tokenId].price < _ethPrice) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            ethfee = _ethPrice.sub(prices[_tokenId].price).mul(ETHFee).div(Percen);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            if(prices[_tokenId].price == 0) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if (ethfee >= limitETHFee) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    ethNeed = ethfee.add(_hightLightFee);
                } else {
                    ethNeed = limitETHFee.add(_hightLightFee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
            }

        }
        return (ethNeed, _hightLightFee);
    }
    function setPriceFeeEth(uint8 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable isOwnerOf(_tokenId) {
        require(prices[_tokenId].price != _ethPrice);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 ethfee;
        uint256 _hightLightFee = 0;
        if (_isHightLight == 1 && (prices[_tokenId].price == 0 || !prices[_tokenId].isHightlight)) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            _hightLightFee = hightLightFee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        if (prices[_tokenId].price < _ethPrice) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            ethfee = _ethPrice.sub(prices[_tokenId].price).mul(ETHFee).div(Percen);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            if(prices[_tokenId].price == 0) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if (ethfee >= limitETHFee) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    require(msg.value == ethfee.add(_hightLightFee));
                } else {
                    require(msg.value == limitETHFee.add(_hightLightFee));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    ethfee = limitETHFee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
            }
            ethfee = ethfee.add(prices[_tokenId].fee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        } else ethfee = _ethPrice.mul(ETHFee).div(Percen);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        setPrice(_tokenId, _ethPrice, ethfee, 0, _isHightLight == 1);
    }
    function calPriceFeeHBWALLET(uint8 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
        uint fee;
        uint256 ethfee;
        uint _hightLightFee = 0;
        uint hbNeed;
        if (_isHightLight == 1 && (prices[_tokenId].price == 0 || !prices[_tokenId].isHightlight)) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            // _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
            _hightLightFee = hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        if (prices[_tokenId].price < _ethPrice) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            ethfee = _ethPrice.sub(prices[_tokenId].price).mul(ETHFee).div(Percen);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
            if(prices[_tokenId].price == 0) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if (fee >= limitHBWALLETFee) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    hbNeed = fee.add(_hightLightFee);
                } else {
                    hbNeed = limitHBWALLETFee.add(_hightLightFee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
            }
        }
        return hbNeed;
    }
    function setPriceFeeHBWALLET(uint8 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_tokenId) {
        require(prices[_tokenId].price != _ethPrice);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint fee;
        uint256 ethfee;
        uint _hightLightFee = 0;
        if (_isHightLight == 1 && (prices[_tokenId].price == 0 || !prices[_tokenId].isHightlight)) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            _hightLightFee = hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        if (prices[_tokenId].price < _ethPrice) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            ethfee = _ethPrice.sub(prices[_tokenId].price).mul(ETHFee).div(Percen);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
            if(prices[_tokenId].price == 0) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if (fee >= limitHBWALLETFee) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                } else {
                    require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee.add(_hightLightFee)));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    fee = limitHBWALLETFee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
            }
            fee = fee.add(prices[_tokenId].hbfee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        } else {
            ethfee = _ethPrice.mul(ETHFee).div(Percen);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }

        setPrice(_tokenId, _ethPrice, 0, fee, _isHightLight == 1);
    }

    function removePrice(uint8 _tokenId) public isOwnerOf(_tokenId) returns (uint256){
        if (prices[_tokenId].fee > 0) msg.sender.transfer(prices[_tokenId].fee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        else if (prices[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[_tokenId].hbfee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        resetPrice(_tokenId);
        return prices[_tokenId].price;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setFee(uint256 _ethFee, uint _HBWALLETExchange, uint256 _hightLightFee) public onlyOwner returns (uint256, uint, uint256){
        require(_ethFee >= 0 && _HBWALLETExchange >= 1 && _hightLightFee >= 0);
        ETHFee = _ethFee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        HBWALLETExchange = _HBWALLETExchange;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        hightLightFee = _hightLightFee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return (ETHFee, HBWALLETExchange, hightLightFee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setLimitFee(uint256 _ethlimitFee, uint _hbWalletlimitFee) public onlyOwner returns (uint256, uint){
        require(_ethlimitFee >= 0 && _hbWalletlimitFee >= 0);
        limitETHFee = _ethlimitFee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        limitHBWALLETFee = _hbWalletlimitFee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return (limitETHFee, limitHBWALLETFee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function _withdraw(uint256 amount, uint256 _amountHB) internal {
        require(address(this).balance >= amount && hbwalletToken.balanceOf(address(this)) >= _amountHB);
        if(amount > 0) {
            msg.sender.transfer(amount);
        }
        if(_amountHB > 0) {
            hbwalletToken.transfer(msg.sender, _amountHB);
        }
    }
    function withdraw(uint256 amount, uint8 _amountHB) public onlyCeoAddress {
        _withdraw(amount, _amountHB);
    }
    function cancelBussiness() public onlyCeoAddress {
        uint8[] memory arr = arrayTokenIdSale;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint length = arrayTokenIdSale.length;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        for (uint i = 0; i < length; i++) {
            if (prices[arr[i]].tokenOwner == erc721Address.ownerOf(arr[i])) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if (prices[arr[i]].fee > 0) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    uint256 eth = prices[arr[i]].fee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    if(prices[arr[i]].isHightlight) eth = eth.add(hightLightFee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    if(address(this).balance >= eth) {
                        prices[arr[i]].tokenOwner.transfer(eth);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    }
                }
                else if (prices[arr[i]].hbfee > 0) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    uint hb = prices[arr[i]].hbfee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    if(prices[arr[i]].isHightlight) hb = hb.add(hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    if(hbwalletToken.balanceOf(address(this)) >= hb) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                        hbwalletToken.transfer(prices[arr[i]].tokenOwner, hb);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    }
                }
                resetPrice(arr[i]);
            }
        }
        _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function revenue() public view returns (uint256, uint){
        uint256 ethfee = 0;
        uint hbfee = 0;
        for (uint i = 0; i < arrayTokenIdSale.length; i++) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                if (prices[arrayTokenIdSale[i]].fee > 0) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    ethfee = ethfee.add(prices[arrayTokenIdSale[i]].fee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
                else if (prices[arrayTokenIdSale[i]].hbfee > 0) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    hbfee = hbfee.add(prices[arrayTokenIdSale[i]].hbfee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                }
            }
        }
        uint256 eth = address(this).balance.sub(ethfee);
        uint hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return (eth, hb);
    }

    function changeCeo(address _address) public onlyCeoAddress {
        require(_address != address(0));
        ceoAddress = _address;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    }

    function buy(uint8 tokenId) public payable {
        require(getApproved(tokenId) == address(this));
        require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        prices[tokenId].tokenOwner.transfer(msg.value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        resetPrice(tokenId);
    }

    function buyWithoutCheckApproved(uint8 tokenId) public payable {
        require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        prices[tokenId].tokenOwner.transfer(msg.value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        resetPrice(tokenId);
    }

    function resetPrice(uint8 tokenId) private {
        prices[tokenId] = Price(address(0), 0, 0, 0, false);
        for (uint8 i = 0; i < arrayTokenIdSale.length; i++) {
            if (arrayTokenIdSale[i] == tokenId) {
                _burnArrayTokenIdSale(i);
            }
        }
    }
}