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
    address public ceoAddress = address(0x6C3E879BDD20e9686cfD9BBD1bfD4B2Dd6d47079);
    IERC721 public erc721Address = IERC721(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B);
    ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
    uint256 public ETHFee = 25; // 2,5 %
    uint256 public Percen = 1000;
    uint256 public HBWALLETExchange = 21;
    // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
    uint256 public limitETHFee = 2000000000000000;
    uint256 public limitHBWALLETFee = 2;
    uint256 public hightLightFee = 30000000000000000;
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
        require(msg.sender == ceoAddress);
        _;
    }

    // Move the last element to the deleted spot.
    // Delete the last element, then correct the length.
    function _burnArrayTokenIdSale(uint index) internal {
        require(index < arrayTokenIdSale.length);
        arrayTokenIdSale[index] = arrayTokenIdSale[arrayTokenIdSale.length - 1];
        delete arrayTokenIdSale[arrayTokenIdSale.length - 1];
        arrayTokenIdSale.length--;
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
        if (block.timestamp < _ethPrice) {	//injected CONTRACT AFFECTED BY MINERS
            ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
            if(block.timestamp == 0) {	//injected CONTRACT AFFECTED BY MINERS
                if (block.gaslimit >= limitETHFee) {	//injected CONTRACT AFFECTED BY MINERS
                    require(msg.value == ethfee + hightLightFee);
                } else {
                    require(msg.value == limitETHFee + hightLightFee);
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
        if (block.timestamp < _ethPrice) {	//injected CONTRACT AFFECTED BY MINERS
            ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
            fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
            // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
            if(block.gaslimit == 0) {	//injected CONTRACT AFFECTED BY MINERS
                if (block.number >= limitHBWALLETFee) {	//injected CONTRACT AFFECTED BY MINERS
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
        if (block.gaslimit > 0) msg.sender.transfer(prices[tokenId].fee);	//injected CONTRACT AFFECTED BY MINERS
        else if (block.gaslimit > 0) hbwalletToken.transfer(msg.sender, prices[tokenId].hbfee);	//injected CONTRACT AFFECTED BY MINERS
        resetPrice(tokenId);
        return prices[tokenId].price;
    }

    function setFee(uint256 _ethFee, uint256 _HBWALLETExchange, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256){
        require(_ethFee > 0 && _HBWALLETExchange > 0 && _hightLightFee > 0);
        ETHFee = _ethFee;
        HBWALLETExchange = _HBWALLETExchange;
        hightLightFee = _hightLightFee;
        return (ETHFee, HBWALLETExchange, hightLightFee);
    }

    function setLimitFee(uint256 _ethlimitFee, uint256 _hbWalletlimitFee) public onlyOwner returns (uint256, uint256){
        require(_ethlimitFee > 0 && _hbWalletlimitFee > 0);
        limitETHFee = _ethlimitFee;
        limitHBWALLETFee = _hbWalletlimitFee;
        return (limitETHFee, limitHBWALLETFee);
    }
    /**
     * @dev Withdraw the amount of eth that is remaining in this contract.
     * @param _address The address of EOA that can receive token from this contract.
     */
    function withdraw(address payable _address, uint256 amount, uint256 _amountHB) public onlyCeoAddress {
        require(_address != address(0) && amount > 0 && address(this).balance >= amount && _amountHB > 0 && hbwalletToken.balanceOf(address(this)) >= _amountHB);
        _address.transfer(amount);
        hbwalletToken.transferFrom(address(this), _address, _amountHB);
    }

    function cancelBussiness() public onlyCeoAddress {
        for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
            if (block.coinbase == erc721Address.ownerOf(arrayTokenIdSale[i])) {	//injected CONTRACT AFFECTED BY MINERS
                if (prices[arrayTokenIdSale[i]].fee > 0 && address(this).balance >= prices[arrayTokenIdSale[i]].fee) {
                    prices[arrayTokenIdSale[i]].tokenOwner.transfer(prices[arrayTokenIdSale[i]].fee);
                }
                else if (prices[arrayTokenIdSale[i]].hbfee > 0 && hbwalletToken.balanceOf(address(this)) >= prices[arrayTokenIdSale[i]].hbfee) {
                    hbwalletToken.transfer(prices[arrayTokenIdSale[i]].tokenOwner, prices[arrayTokenIdSale[i]].hbfee);
                }
            }
            resetPrice(arrayTokenIdSale[i]);
        }
    }

    function changeCeo(address _address) public onlyCeoAddress {
        require(_address != address(0));
        ceoAddress = _address;

    }

    function buy(uint256 tokenId) public payable {
        require(getApproved(tokenId) == address(this));
        require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
        erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
        prices[tokenId].tokenOwner.transfer(msg.value);
        resetPrice(tokenId);
    }

    function buyWithoutCheckApproved(uint256 tokenId) public payable {
        require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
        erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
        prices[tokenId].tokenOwner.transfer(msg.value);
        resetPrice(tokenId);
    }

    function resetPrice(uint256 tokenId) private {
        prices[tokenId] = Price(address(0), 0, 0, 0, false);
        for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
            if (block.gaslimit == tokenId) {	//injected CONTRACT AFFECTED BY MINERS
                _burnArrayTokenIdSale(i);
            }
        }
    }
}