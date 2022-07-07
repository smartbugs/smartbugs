pragma solidity ^0.5.8;

library SafeMath {

                                                                      
    function MUL82(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                               
    function DIV333(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                  
    function SUB919(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

                                                                
    function ADD318(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

                                                                                                                                       
    function MOD983(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}
                                                                                                                                                                                             
contract Ownable {
    address public owner;


    event OWNERSHIPTRANSFERRED638(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING


                                                                                                                           
    constructor() public {
        owner = msg.sender;
    }

                                                                                 
    modifier ONLYOWNER709() {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }

                                                                                                                                                                    
    function TRANSFEROWNERSHIP471(address newOwner) public ONLYOWNER709 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0));
        emit OWNERSHIPTRANSFERRED638(owner, newOwner);
        owner = newOwner;
    }

}

contract IERC721 {
    event TRANSFER256(address indexed from, address indexed to, uint256 indexed tokenId);	//inject NONSTANDARD NAMING
    event APPROVAL520(address indexed owner, address indexed approved, uint256 indexed tokenId);	//inject NONSTANDARD NAMING
    event APPROVALFORALL498(address indexed owner, address indexed operator, bool approved);	//inject NONSTANDARD NAMING

    function BALANCEOF96(address owner) public view returns (uint256 balance);	//inject NONSTANDARD NAMING

    function OWNEROF377(uint256 tokenId) public view returns (address owner);	//inject NONSTANDARD NAMING

    function APPROVE974(address to, uint256 tokenId) public;	//inject NONSTANDARD NAMING

    function GETAPPROVED821(uint256 tokenId) public view returns (address operator);	//inject NONSTANDARD NAMING

    function SETAPPROVALFORALL615(address operator, bool _approved) public;	//inject NONSTANDARD NAMING

    function ISAPPROVEDFORALL290(address owner, address operator) public view returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM785(address from, address to, uint256 tokenId) public;	//inject NONSTANDARD NAMING

    function SAFETRANSFERFROM749(address from, address to, uint256 tokenId) public;	//inject NONSTANDARD NAMING

    function SAFETRANSFERFROM749(address from, address to, uint256 tokenId, bytes memory data) public;	//inject NONSTANDARD NAMING
}
                                                                                                                               
contract ERC20BasicInterface {
    function TOTALSUPPLY885() public view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF96(address who) public view returns (uint256);	//inject NONSTANDARD NAMING

    function TRANSFER643(address to, uint256 value) public returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM785(address from, address to, uint256 value) public returns (bool);	//inject NONSTANDARD NAMING

    event TRANSFER256(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

    uint8 public decimals;
}

contract Bussiness is Ownable {

    using SafeMath for uint256;
    address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
    ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
    uint256 public Percen = 1000;
    uint256 public HBWALLETExchange = 21;
    // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
    // uint256 public hightLightFee = 30000000000000000;

    struct Price {
        address payable tokenOwner;
        uint256 price;
        uint256 fee;
        uint256 hbfee;
        bool isHightlight;
    }
    // new code =======================
    struct Game {
        mapping(uint256 => Price) tokenPrice;
        uint[] tokenIdSale;
        uint256 ETHFee;
        uint256 limitETHFee;
        uint256 limitHBWALLETFee;
        uint256 hightLightFee;
    }

    mapping(address => Game) public Games;
    address[] arrGames;
    constructor() public {
        Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].ETHFee = 0;
        Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].limitETHFee = 0;
        Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].limitHBWALLETFee = 0;
        Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].hightLightFee = 30000000000000000;
        arrGames.push(address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B));

        Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].ETHFee = 0;
        Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].limitETHFee = 0;
        Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].limitHBWALLETFee = 0;
        Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].hightLightFee = 30000000000000000;
        arrGames.push(address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea));

        Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].ETHFee = 0;
        Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].limitETHFee = 0;
        Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].limitHBWALLETFee = 0;
        Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].hightLightFee = 30000000000000000;
        arrGames.push(address(0x273f7F8E6489682Df756151F5525576E322d51A3));

        Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].ETHFee = 0;
        Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].limitETHFee = 0;
        Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].limitHBWALLETFee = 0;
        Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].hightLightFee = 30000000000000000;
        arrGames.push(address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d));

        Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].ETHFee = 0;
        Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].limitETHFee = 0;
        Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].limitHBWALLETFee = 0;
        Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].hightLightFee = 30000000000000000;
        arrGames.push(address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392));

        Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].ETHFee = 0;
        Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].limitETHFee = 0;
        Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].limitHBWALLETFee = 0;
        Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].hightLightFee = 30000000000000000;
        arrGames.push(address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f));

        Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].ETHFee = 0;
        Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].limitETHFee = 0;
        Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].limitHBWALLETFee = 0;
        Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].hightLightFee = 30000000000000000;
        arrGames.push(address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340));

        Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].ETHFee = 0;
        Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].limitETHFee = 0;
        Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].limitHBWALLETFee = 0;
        Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].hightLightFee = 30000000000000000;
        arrGames.push(address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b));

        Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].ETHFee = 0;
        Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].limitETHFee = 0;
        Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].limitHBWALLETFee = 0;
        Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].hightLightFee = 30000000000000000;
        arrGames.push(address(0xf26A23019b4699068bb54457f32dAFCF22A9D371));

        Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].ETHFee = 0;
        Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].limitETHFee = 0;
        Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].limitHBWALLETFee = 0;
        Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].hightLightFee = 30000000000000000;
        arrGames.push(address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099));
    }
    
    function GETTOKENPRICE622(address _game, uint256 _tokenId) public view returns (address, uint256, uint256, uint256, bool) {	//inject NONSTANDARD NAMING
        return (Games[_game].tokenPrice[_tokenId].tokenOwner, Games[_game].tokenPrice[_tokenId].price, Games[_game].tokenPrice[_tokenId].fee, Games[_game].tokenPrice[_tokenId].hbfee, Games[_game].tokenPrice[_tokenId].isHightlight);
    }
    // new code =======================
                                                                                       
    modifier ONLYCEOADDRESS723() {	//inject NONSTANDARD NAMING
        require(msg.sender == ceoAddress);
        _;
    }
    modifier ISOWNEROF699(address _game, uint256 _tokenId) {	//inject NONSTANDARD NAMING
        IERC721 erc721Address = IERC721(_game);
        require(erc721Address.OWNEROF377(_tokenId) == msg.sender);
        _;
    }
    
    function OWNEROF377(address _game, uint256 _tokenId) public view returns (address){	//inject NONSTANDARD NAMING
        IERC721 erc721Address = IERC721(_game);
        return erc721Address.OWNEROF377(_tokenId);
    }

    function BALANCEOF96() public view returns (uint256){	//inject NONSTANDARD NAMING
        return address(this).balance;
    }

    function GETAPPROVED821(address _game, uint256 _tokenId) public view returns (address){	//inject NONSTANDARD NAMING
        IERC721 erc721Address = IERC721(_game);
        return erc721Address.GETAPPROVED821(_tokenId);
    }

    function SETPRICE904(address _game, uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, bool _isHightLight) internal {	//inject NONSTANDARD NAMING
        Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
        Games[_game].tokenIdSale.push(_tokenId);
        bool flag = false;
        for(uint i = 0; i< arrGames.length; i++) {
            if(arrGames[i] == address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)) flag = true;
        }
        if(!flag) arrGames.push(address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099));
    }

    function CALPRICEFEEETH414(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {	//inject NONSTANDARD NAMING
        uint256 ethfee;
        uint256 _hightLightFee = 0;
        uint256 ethNeed;
        if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || !Games[_game].tokenPrice[_tokenId].isHightlight)) {
            _hightLightFee = Games[_game].hightLightFee;
        }
        if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
            ethfee = _ethPrice.SUB919(Games[_game].tokenPrice[_tokenId].price).MUL82(Games[_game].ETHFee).DIV333(Percen);
            if(Games[_game].tokenPrice[_tokenId].price == 0) {
                if (ethfee >= Games[_game].limitETHFee) {
                    ethNeed = ethfee.ADD318(_hightLightFee);
                } else {
                    ethNeed = Games[_game].limitETHFee.ADD318(_hightLightFee);
                }
            }

        }
        return (ethNeed, _hightLightFee);
    }
    function SETPRICEFEEETH180(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable ISOWNEROF699(_game, _tokenId) {	//inject NONSTANDARD NAMING
        require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
        uint256 ethfee;
        uint256 _hightLightFee = 0;
        if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || !Games[_game].tokenPrice[_tokenId].isHightlight)) {
            _hightLightFee = Games[_game].hightLightFee;
        }
        if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
            ethfee = _ethPrice.SUB919(Games[_game].tokenPrice[_tokenId].price).MUL82(Games[_game].ETHFee).DIV333(Percen);
            if(Games[_game].tokenPrice[_tokenId].price == 0) {
                if (ethfee >= Games[_game].limitETHFee) {
                    require(msg.value == ethfee.ADD318(_hightLightFee));
                } else {
                    require(msg.value == Games[_game].limitETHFee.ADD318(_hightLightFee));
                    ethfee = Games[_game].limitETHFee;
                }
            }
            ethfee = ethfee.ADD318(Games[_game].tokenPrice[_tokenId].fee);
        } else ethfee = _ethPrice.MUL82(Games[_game].ETHFee).DIV333(Percen);

        SETPRICE904(_game, _tokenId, _ethPrice, ethfee, 0, _isHightLight == 1);
    }
    function CALPRICEFEEHBWALLET212(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){	//inject NONSTANDARD NAMING
        uint fee;
        uint256 ethfee;
        uint _hightLightFee = 0;
        uint hbNeed;
        address local_game = _game;
        if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || !Games[_game].tokenPrice[_tokenId].isHightlight)) {
            // _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
            _hightLightFee = Games[local_game].hightLightFee.MUL82(HBWALLETExchange).DIV333(2).DIV333(10 ** 16);
        }
        if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
            ethfee = _ethPrice.SUB919(Games[local_game].tokenPrice[_tokenId].price).MUL82(Games[_game].ETHFee).DIV333(Percen);
            fee = ethfee.MUL82(HBWALLETExchange).DIV333(2).DIV333(10 ** 16);
            // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
            if(Games[_game].tokenPrice[_tokenId].price == 0) {
                if (fee >= Games[_game].limitHBWALLETFee) {
                    hbNeed = fee.ADD318(_hightLightFee);
                } else {
                    hbNeed = Games[_game].limitHBWALLETFee.ADD318(_hightLightFee);
                }
            }
        }
        return hbNeed;
    }
    function SETPRICEFEEHBWALLET903(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public ISOWNEROF699(_game, _tokenId) {	//inject NONSTANDARD NAMING
        require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
        uint fee;
        uint256 ethfee;
        uint _hightLightFee = 0;
        address local_game = _game;
        uint256 local_tokenId = _tokenId;
        if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || !Games[_game].tokenPrice[_tokenId].isHightlight)) {
            _hightLightFee = Games[local_game].hightLightFee.MUL82(HBWALLETExchange).DIV333(2).DIV333(10 ** 16);
        }
        if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
            ethfee = _ethPrice.SUB919(Games[local_game].tokenPrice[local_tokenId].price).MUL82(Games[local_game].ETHFee).DIV333(Percen);
            fee = ethfee.MUL82(HBWALLETExchange).DIV333(2).DIV333(10 ** 16);
            // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
            if(Games[_game].tokenPrice[_tokenId].price == 0) {
                if (fee >= Games[_game].limitHBWALLETFee) {
                    require(hbwalletToken.TRANSFERFROM785(msg.sender, address(this), fee.ADD318(_hightLightFee)));
                } else {
                    require(hbwalletToken.TRANSFERFROM785(msg.sender, address(this), Games[local_game].limitHBWALLETFee.ADD318(_hightLightFee)));
                    fee = Games[_game].limitHBWALLETFee;
                }
            }
            fee = fee.ADD318(Games[_game].tokenPrice[_tokenId].hbfee);
        } else {
            ethfee = _ethPrice.MUL82(Games[local_game].ETHFee).DIV333(Percen);
            fee = ethfee.MUL82(HBWALLETExchange).DIV333(2).DIV333(10 ** 16);
        }

        SETPRICE904(_game, _tokenId, _ethPrice, 0, fee, _isHightLight == 1);
    }

    function REMOVEPRICE825(address _game, uint256 _tokenId) public ISOWNEROF699(_game, _tokenId) returns (uint256){	//inject NONSTANDARD NAMING
        if (Games[_game].tokenPrice[_tokenId].fee > 0) msg.sender.transfer(Games[_game].tokenPrice[_tokenId].fee);
        else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) hbwalletToken.TRANSFER643(msg.sender, Games[_game].tokenPrice[_tokenId].hbfee);
        RESETPRICE982(_game, _tokenId);
        return Games[_game].tokenPrice[_tokenId].price;
    }

    function SETHBWALLETEXCHANGE486(uint _HBWALLETExchange) public ONLYOWNER709 returns (uint){	//inject NONSTANDARD NAMING
        require(_HBWALLETExchange >= 1);

        HBWALLETExchange = _HBWALLETExchange;

        return (HBWALLETExchange);
    }

    function SETLIMITFEE723(address _game, uint256 _ethFee, uint256 _ethlimitFee, uint _hbWalletlimitFee, uint256 _hightLightFee) public ONLYOWNER709 returns (uint256, uint256, uint256, uint256){	//inject NONSTANDARD NAMING
        require(_ethFee >= 0 && _ethlimitFee >= 0 && _hbWalletlimitFee >= 0 && _hightLightFee >= 0);
        Games[_game].ETHFee = _ethFee;
        Games[_game].limitETHFee = _ethlimitFee;
        Games[_game].limitHBWALLETFee = _hbWalletlimitFee;
        Games[_game].hightLightFee = _hightLightFee;
        return (Games[_game].ETHFee, Games[_game].limitETHFee, Games[_game].limitHBWALLETFee, Games[_game].hightLightFee);
    }

    function _WITHDRAW837(uint256 amount, uint256 _amountHB) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount && hbwalletToken.BALANCEOF96(address(this)) >= _amountHB);
        if(amount > 0) {
            msg.sender.transfer(amount);
        }
        if(_amountHB > 0) {
            hbwalletToken.TRANSFER643(msg.sender, _amountHB);
        }
    }
    function WITHDRAW508(uint256 amount, uint8 _amountHB) public ONLYCEOADDRESS723 {	//inject NONSTANDARD NAMING
        _WITHDRAW837(amount, _amountHB);
    }
    function CANCELBUSSINESSBYGAMEID574(address _game, uint256 _tokenId) private {	//inject NONSTANDARD NAMING
        IERC721 erc721Address = IERC721(_game);
        if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.OWNEROF377(_tokenId)) {
            if (Games[_game].tokenPrice[_tokenId].fee > 0) {
                uint256 eth = Games[_game].tokenPrice[_tokenId].fee;
                if(Games[_game].tokenPrice[_tokenId].isHightlight == true) eth = eth.ADD318(Games[_game].hightLightFee);
                if(address(this).balance >= eth) {
                    Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(eth);
                }
            }
            else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) {
                uint256 hb = Games[_game].tokenPrice[_tokenId].hbfee;
                if(Games[_game].tokenPrice[_tokenId].isHightlight == true) hb = hb.ADD318(Games[_game].hightLightFee.MUL82(HBWALLETExchange).DIV333(2).DIV333(10 ** 16));
                if(hbwalletToken.BALANCEOF96(address(this)) >= hb) {
                    hbwalletToken.TRANSFER643(Games[_game].tokenPrice[_tokenId].tokenOwner, hb);
                }
            }
        }
    }
    function CANCELBUSSINESSBYGAME945(address _game, uint isFirst) private ONLYCEOADDRESS723 {	//inject NONSTANDARD NAMING
        for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
            CANCELBUSSINESSBYGAMEID574(_game, Games[_game].tokenIdSale[i]);
        }
        RESETPRICEBYARR905(_game, Games[_game].tokenIdSale);
        if (_game == arrGames[arrGames.length-1] && isFirst == 0)
            _WITHDRAW837(address(this).balance, hbwalletToken.BALANCEOF96(address(this)));
    }
    function CANCELBUSSINESS269() public ONLYCEOADDRESS723 {	//inject NONSTANDARD NAMING
        CANCELBUSSINESSBYGAME945(arrGames[arrGames.length-1], 1);
        for(uint j = 0; j< arrGames.length; j++) {
            address _game = arrGames[j];
            CANCELBUSSINESSBYGAME945(_game, 0);
        }
    }

    function REVENUE337() public view returns (uint256, uint){	//inject NONSTANDARD NAMING

        uint256 ethfee = 0;
        uint256 hbfee = 0;
        for(uint j = 0; j< arrGames.length; j++) {

            address _game = arrGames[j];
            IERC721 erc721Address = IERC721(arrGames[j]);
            for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
                uint256 _tokenId = Games[_game].tokenIdSale[i];
                if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.OWNEROF377(_tokenId)) {
                    if (Games[_game].tokenPrice[_tokenId].fee > 0) {
                        ethfee = ethfee.ADD318(Games[_game].tokenPrice[_tokenId].fee);
                        if(Games[_game].tokenPrice[_tokenId].isHightlight == true) ethfee = ethfee.ADD318(Games[_game].hightLightFee);
                    }
                    else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) {
                        hbfee = hbfee.ADD318(Games[_game].tokenPrice[_tokenId].hbfee);
                        if(Games[_game].tokenPrice[_tokenId].isHightlight == true) hbfee = hbfee.ADD318(Games[_game].hightLightFee.MUL82(HBWALLETExchange).DIV333(2).DIV333(10 ** 16));
                    }
                }
            }
        }

        uint256 eth = address(this).balance.SUB919(ethfee);
        uint256 hb = hbwalletToken.BALANCEOF96(address(this)).SUB919(hbfee);
        return (eth, hb);
    }

    function CHANGECEO972(address _address) public ONLYCEOADDRESS723 {	//inject NONSTANDARD NAMING
        require(_address != address(0));
        ceoAddress = _address;

    }

    function BUY872(address _game, uint256 tokenId) public payable {	//inject NONSTANDARD NAMING
        IERC721 erc721Address = IERC721(_game);
        require(GETAPPROVED821(_game, tokenId) == address(this));
        require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
        erc721Address.TRANSFERFROM785(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
        Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
        RESETPRICE982(_game, tokenId);
    }

    function BUYWITHOUTCHECKAPPROVED604(address _game, uint256 tokenId) public payable {	//inject NONSTANDARD NAMING
        IERC721 erc721Address = IERC721(_game);
        require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
        erc721Address.TRANSFERFROM785(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
        Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
        RESETPRICE982(_game, tokenId);
    }
    // Move the last element to the deleted spot.
    // Delete the last element, then correct the length.
    function _BURNARRAYTOKENIDSALE36(address _game, uint8 index)  internal {	//inject NONSTANDARD NAMING
        if (index >= Games[_game].tokenIdSale.length) return;

        for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
            Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
        }
        delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
        Games[_game].tokenIdSale.length--;
    }
    function RESETPRICEBYARR905(address _game, uint256[] memory _arrTokenId) private {	//inject NONSTANDARD NAMING
        for (uint8 i = 0; i < _arrTokenId.length; i++) {
            Games[_game].tokenPrice[_arrTokenId[i]] = Price(address(0), 0, 0, 0, false);
            if (Games[_game].tokenIdSale[i] == _arrTokenId[i]) {
                _BURNARRAYTOKENIDSALE36(_game, i);
            }
        }
    }
    function RESETPRICE982(address _game, uint256 _tokenId) private {	//inject NONSTANDARD NAMING
        Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0, false);
        for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
            if (Games[_game].tokenIdSale[i] == _tokenId) {
                _BURNARRAYTOKENIDSALE36(_game, i);
            }
        }
    }
}