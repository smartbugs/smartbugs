pragma solidity ^0.5.8;

                                                                                                                                                                                             
contract Ownable {
    address public owner;


    event OWNERSHIPTRANSFERRED742(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING


                                                                                                                           
    constructor() public {
        owner = msg.sender;
    }

                                                                                 
    modifier ONLYOWNER252() {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }

                                                                                                                                                                    
    function TRANSFEROWNERSHIP351(address newOwner) public ONLYOWNER252 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0));
        emit OWNERSHIPTRANSFERRED742(owner, newOwner);
        owner = newOwner;
    }

}

contract IERC721 {
    event TRANSFER592(address indexed from, address indexed to, uint256 indexed tokenId);	//inject NONSTANDARD NAMING
    event APPROVAL116(address indexed owner, address indexed approved, uint256 indexed tokenId);	//inject NONSTANDARD NAMING
    event APPROVALFORALL761(address indexed owner, address indexed operator, bool approved);	//inject NONSTANDARD NAMING

    function BALANCEOF286(address owner) public view returns (uint256 balance);	//inject NONSTANDARD NAMING

    function OWNEROF883(uint256 tokenId) public view returns (address owner);	//inject NONSTANDARD NAMING

    function APPROVE279(address to, uint256 tokenId) public;	//inject NONSTANDARD NAMING

    function GETAPPROVED445(uint256 tokenId) public view returns (address operator);	//inject NONSTANDARD NAMING

    function SETAPPROVALFORALL429(address operator, bool _approved) public;	//inject NONSTANDARD NAMING

    function ISAPPROVEDFORALL922(address owner, address operator) public view returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM675(address from, address to, uint256 tokenId) public;	//inject NONSTANDARD NAMING

    function SAFETRANSFERFROM377(address from, address to, uint256 tokenId) public;	//inject NONSTANDARD NAMING

    function SAFETRANSFERFROM377(address from, address to, uint256 tokenId, bytes memory data) public;	//inject NONSTANDARD NAMING
}
                                                                                                                               
contract ERC20BasicInterface {
    function TOTALSUPPLY614() public view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF286(address who) public view returns (uint256);	//inject NONSTANDARD NAMING

    function TRANSFER601(address to, uint256 value) public returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM675(address from, address to, uint256 value) public returns (bool);	//inject NONSTANDARD NAMING

    event TRANSFER592(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

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

                                                                                       
    modifier ONLYCEOADDRESS253() {	//inject NONSTANDARD NAMING
        require(msg.sender == ceoAddress);
        _;
    }

    // Move the last element to the deleted spot.
    // Delete the last element, then correct the length.
    function _BURNARRAYTOKENIDSALE680(uint index) internal {	//inject NONSTANDARD NAMING
        require(index < arrayTokenIdSale.length);
        arrayTokenIdSale[index] = arrayTokenIdSale[arrayTokenIdSale.length - 1];
        delete arrayTokenIdSale[arrayTokenIdSale.length - 1];
        arrayTokenIdSale.length--;
    }

    function OWNEROF883(uint256 _tokenId) public view returns (address){	//inject NONSTANDARD NAMING
        return erc721Address.OWNEROF883(_tokenId);
    }

    function BALANCEOF286() public view returns (uint256){	//inject NONSTANDARD NAMING
        return address(this).balance;
    }

    function GETAPPROVED445(uint256 _tokenId) public view returns (address){	//inject NONSTANDARD NAMING
        return erc721Address.GETAPPROVED445(_tokenId);
    }

    function SETPRICE924(uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint256 _hbfee, bool _isHightLight) internal {	//inject NONSTANDARD NAMING
        prices[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
        arrayTokenIdSale.push(_tokenId);
    }

    function SETPRICEFEEETH967(uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public payable {	//inject NONSTANDARD NAMING
        require(erc721Address.OWNEROF883(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
        uint256 ethfee;
        uint256 _hightLightFee = 0;
        if (_isHightLight == true && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
            _hightLightFee = hightLightFee;
        }
        if (prices[_tokenId].price < _ethPrice) {
            ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
            if(prices[_tokenId].price == 0) {
                if (ethfee >= limitETHFee) {
                    require(msg.value == ethfee + hightLightFee);
                } else {
                    require(msg.value == limitETHFee + hightLightFee);
                    ethfee = limitETHFee;
                }
            }
            ethfee += prices[_tokenId].fee;
        } else ethfee = _ethPrice * ETHFee / Percen;

        SETPRICE924(_tokenId, _ethPrice, ethfee, 0, _isHightLight);
    }

    function SETPRICEFEEHBWALLET897(uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public returns (bool){	//inject NONSTANDARD NAMING
        require(erc721Address.OWNEROF883(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
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
                    require(hbwalletToken.TRANSFERFROM675(msg.sender, address(this), fee + _hightLightFee));
                } else {
                    require(hbwalletToken.TRANSFERFROM675(msg.sender, address(this), limitHBWALLETFee + _hightLightFee));
                    fee = limitHBWALLETFee;
                }
            }
            fee += prices[_tokenId].hbfee;
        } else {
            ethfee = _ethPrice * ETHFee / Percen;
            fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
        }

        SETPRICE924(_tokenId, _ethPrice, 0, fee, _isHightLight);
        return true;
    }

    function REMOVEPRICE927(uint256 tokenId) public returns (uint256){	//inject NONSTANDARD NAMING
        require(erc721Address.OWNEROF883(tokenId) == msg.sender);
        if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);
        else if (prices[tokenId].hbfee > 0) hbwalletToken.TRANSFER601(msg.sender, prices[tokenId].hbfee);
        RESETPRICE775(tokenId);
        return prices[tokenId].price;
    }

    function SETFEE284(uint256 _ethFee, uint256 _HBWALLETExchange, uint256 _hightLightFee) public ONLYOWNER252 returns (uint256, uint256, uint256){	//inject NONSTANDARD NAMING
        require(_ethFee > 0 && _HBWALLETExchange > 0 && _hightLightFee > 0);
        ETHFee = _ethFee;
        HBWALLETExchange = _HBWALLETExchange;
        hightLightFee = _hightLightFee;
        return (ETHFee, HBWALLETExchange, hightLightFee);
    }

    function SETLIMITFEE654(uint256 _ethlimitFee, uint256 _hbWalletlimitFee) public ONLYOWNER252 returns (uint256, uint256){	//inject NONSTANDARD NAMING
        require(_ethlimitFee > 0 && _hbWalletlimitFee > 0);
        limitETHFee = _ethlimitFee;
        limitHBWALLETFee = _hbWalletlimitFee;
        return (limitETHFee, limitHBWALLETFee);
    }
                                                                                                                                                                               
    function WITHDRAW821(address payable _address, uint256 amount, uint256 _amountHB) public ONLYCEOADDRESS253 {	//inject NONSTANDARD NAMING
        require(_address != address(0) && amount > 0 && address(this).balance >= amount && _amountHB > 0 && hbwalletToken.BALANCEOF286(address(this)) >= _amountHB);
        _address.transfer(amount);
        hbwalletToken.TRANSFERFROM675(address(this), _address, _amountHB);
    }

    function CANCELBUSSINESS265() public ONLYCEOADDRESS253 {	//inject NONSTANDARD NAMING
        for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
            if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.OWNEROF883(arrayTokenIdSale[i])) {
                if (prices[arrayTokenIdSale[i]].fee > 0 && address(this).balance >= prices[arrayTokenIdSale[i]].fee) {
                    prices[arrayTokenIdSale[i]].tokenOwner.transfer(prices[arrayTokenIdSale[i]].fee);
                }
                else if (prices[arrayTokenIdSale[i]].hbfee > 0 && hbwalletToken.BALANCEOF286(address(this)) >= prices[arrayTokenIdSale[i]].hbfee) {
                    hbwalletToken.TRANSFER601(prices[arrayTokenIdSale[i]].tokenOwner, prices[arrayTokenIdSale[i]].hbfee);
                }
            }
            RESETPRICE775(arrayTokenIdSale[i]);
        }
    }

    function CHANGECEO557(address _address) public ONLYCEOADDRESS253 {	//inject NONSTANDARD NAMING
        require(_address != address(0));
        ceoAddress = _address;

    }

    function BUY787(uint256 tokenId) public payable {	//inject NONSTANDARD NAMING
        require(GETAPPROVED445(tokenId) == address(this));
        require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
        erc721Address.TRANSFERFROM675(prices[tokenId].tokenOwner, msg.sender, tokenId);
        prices[tokenId].tokenOwner.transfer(msg.value);
        RESETPRICE775(tokenId);
    }

    function BUYWITHOUTCHECKAPPROVED538(uint256 tokenId) public payable {	//inject NONSTANDARD NAMING
        require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
        erc721Address.TRANSFERFROM675(prices[tokenId].tokenOwner, msg.sender, tokenId);
        prices[tokenId].tokenOwner.transfer(msg.value);
        RESETPRICE775(tokenId);
    }

    function RESETPRICE775(uint256 tokenId) private {	//inject NONSTANDARD NAMING
        prices[tokenId] = Price(address(0), 0, 0, 0, false);
        for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
            if (arrayTokenIdSale[i] == tokenId) {
                _BURNARRAYTOKENIDSALE680(i);
            }
        }
    }
}