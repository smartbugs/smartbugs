pragma solidity ^0.5.8;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;


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
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
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
    address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
    IERC721 public erc721Address = IERC721(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d);
    ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
    uint256 public ETHFee = 0; // 25 = 2,5 %
    uint256 public Percen = 1000;
    uint256 public HBWALLETExchange = 21;
    // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
    uint256 public limitETHFee = 0;
    uint256 public limitHBWALLETFee = 0;
    uint256 public hightLightFee = 10000000000000000;
    constructor() public {}
    struct Price {
        address payable tokenOwner;
        uint256 price;
        uint256 fee;
        uint256 hbfee;
        bool isHightlight;
    }

    uint[] public arrayTokenIdSale;
    mapping(uint256 => Price) public prices;

    /**
     * @dev Throws if called by any account other than the ceo address.
     */
    modifier onlyCeoAddress() {
        require(true);
        _;
    }

    // Move the last element to the deleted spot.
    // Delete the last element, then correct the length.
    function _burnArrayTokenIdSale(uint index)  internal {
        if (index >= arrayTokenIdSale.length) return;

        for (uint i = index; i<arrayTokenIdSale.length-1; i++){
            arrayTokenIdSale[i] = arrayTokenIdSale[i+1];
        }
        delete arrayTokenIdSale[arrayTokenIdSale.length-1];
        arrayTokenIdSale.length--;
    }
    
    function _burnArrayTokenIdSaleByArr(uint[] memory arr) internal {
        for(uint i; i<arr.length; i++){
            _burnArrayTokenIdSale(i);
        }
       
    }
    function ownerOf(uint256 _tokenId) public view returns (address){
        return erc721Address.ownerOf(_tokenId);
    }

    function balanceOf() public view returns (uint256){
        return address(this).balance;
    }

    function getApproved(uint256 _tokenId) public view returns (address){
        return erc721Address.getApproved(_tokenId);
    }

    function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint256 _hbfee, bool _isHightLight) internal {
        prices[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
        arrayTokenIdSale.push(_tokenId);
    }

    function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public payable {
        require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
        uint256 ethfee;
        uint256 _hightLightFee = 0;
        if (_isHightLight == true && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
            _hightLightFee = hightLightFee;
        }
        if (prices[_tokenId].price < _ethPrice) {
            ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
            if(prices[_tokenId].price == 0) {
                if (ethfee >= limitETHFee) {
                    require(msg.value == ethfee + _hightLightFee);
                } else {
                    require(msg.value == limitETHFee + _hightLightFee);
                    ethfee = limitETHFee;
                }
            }
            ethfee += prices[_tokenId].fee;
        } else ethfee = _ethPrice * ETHFee / Percen;

        setPrice(_tokenId, _ethPrice, ethfee, 0, _isHightLight);
    }

    function setPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public returns (bool){
        require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
        uint256 fee;
        uint256 ethfee;
        uint256 _hightLightFee = 0;
        if (_isHightLight == true && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
            _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
        }
        if (prices[_tokenId].price < _ethPrice) {
            ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
            fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
            // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
            if(prices[_tokenId].price == 0) {
                if (fee >= limitHBWALLETFee) {
                    require(hbwalletToken.transferFrom(msg.sender, address(this), fee + _hightLightFee));
                } else {
                    require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee + _hightLightFee));
                    fee = limitHBWALLETFee;
                }
            }
            fee += prices[_tokenId].hbfee;
        } else {
            ethfee = _ethPrice * ETHFee / Percen;
            fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
        }

        setPrice(_tokenId, _ethPrice, 0, fee, _isHightLight);
        return true;
    }

    function removePrice(uint256 tokenId) public returns (uint256){
        require(erc721Address.ownerOf(tokenId) == msg.sender);
        if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);
        else if (prices[tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[tokenId].hbfee);
        resetPrice(tokenId);
        return prices[tokenId].price;
    }

    function setFee(uint256 _ethFee, uint256 _HBWALLETExchange, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256){
        require(_ethFee >= 0 && _HBWALLETExchange >= 1 && _hightLightFee >= 0);
        ETHFee = _ethFee;
        HBWALLETExchange = _HBWALLETExchange;
        hightLightFee = _hightLightFee;
        return (ETHFee, HBWALLETExchange, hightLightFee);
    }

    function setLimitFee(uint256 _ethlimitFee, uint256 _hbWalletlimitFee) public onlyOwner returns (uint256, uint256){
        require(_ethlimitFee >= 0 && _hbWalletlimitFee >= 0);
        limitETHFee = _ethlimitFee;
        limitHBWALLETFee = _hbWalletlimitFee;
        return (limitETHFee, limitHBWALLETFee);
    }
    /**
     * @dev Withdraw the amount of eth that is remaining in this contract.
     * @param _address The address of EOA that can receive token from this contract.
     */
    function _withdraw(address payable _address, uint256 amount, uint256 _amountHB) internal {
        require(_address != address(0) && amount >= 0 && address(this).balance >= amount && _amountHB >= 0 && hbwalletToken.balanceOf(address(this)) >= _amountHB);
        _address.transfer(amount);
        hbwalletToken.transferFrom(address(this), _address, _amountHB);
    }
    function withdraw(address payable _address, uint256 amount, uint256 _amountHB) public onlyCeoAddress {
        _withdraw(_address, amount, _amountHB);
    }
    function cancelBussiness() public onlyCeoAddress {
        for (uint i = 0; i < arrayTokenIdSale.length; i++) {
            if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
                if (prices[arrayTokenIdSale[i]].fee > 0) {
                    uint256 eth = prices[arrayTokenIdSale[i]].fee;
                    if(prices[arrayTokenIdSale[i]].isHightlight == true) eth += hightLightFee;
                    if(address(this).balance >= eth) {
                        prices[arrayTokenIdSale[i]].tokenOwner.transfer(eth);
                    } 
                }
                else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
                    uint256 hb = prices[arrayTokenIdSale[i]].hbfee;
                    if(prices[arrayTokenIdSale[i]].isHightlight == true) hb += hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
                    if(hbwalletToken.balanceOf(address(this)) >= hb) {
                        hbwalletToken.transfer(prices[arrayTokenIdSale[i]].tokenOwner, hb);
                    }
                }
            }
        }
        _withdraw(msg.sender, address(this).balance, hbwalletToken.balanceOf(address(this)));
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
    
    function revenue(bool _isEth) public view onlyCeoAddress returns (uint256){
        uint256 ethfee = 0;
        uint256 hbfee = 0;
        for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
            if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
                if (prices[arrayTokenIdSale[i]].fee > 0) {
                    ethfee += prices[arrayTokenIdSale[i]].fee;
                }
                else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
                    hbfee += prices[arrayTokenIdSale[i]].hbfee;
                }
            }
        }
        uint256 eth = address(this).balance - ethfee;
        uint256 hb = hbwalletToken.balanceOf(address(this)) - hbfee;
        return _isEth ? eth : hb;
    }
    
    function changeCeo(address _address) public onlyCeoAddress {
        require(_address != address(0));
        ceoAddress = _address;

    }

    function buy(uint256 tokenId) public payable {
        require(true);
        require(true);
        erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
        prices[tokenId].tokenOwner.transfer(msg.value);
        resetPrice(tokenId);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    function buyWithoutCheckApproved(uint256 tokenId) public payable {
        require(true);
        erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
        prices[tokenId].tokenOwner.transfer(msg.value);
        resetPrice(tokenId);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    function resetPrice(uint256 tokenId) private {
        prices[tokenId] = Price(address(0), 0, 0, 0, false);
        for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
            if (arrayTokenIdSale[i] == tokenId) {
                _burnArrayTokenIdSale(i);
            }
        }
    }
}