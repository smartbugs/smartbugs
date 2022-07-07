pragma solidity ^0.5.9;

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

    function transfer(address to, uint256 tokenId) public;

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
    address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
    ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
    // address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
    // ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0x91013928b1C4dbd0D5cB21BA5b052BfD840A7a7F);
    uint256 public Percen = 1000;
    uint256 public HBWALLETExchange = 21;

    struct Price {
        address payable tokenOwner;
        uint256 price;
        uint256 fee;
        uint256 hbfee;
        uint isHightlight;
        uint isHightlightByHb;
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
    address[] public arrGames;
    constructor() public {
        arrGames = [
        0x5D00d312e171Be5342067c09BaE883f9Bcb2003B,
        0xdceaf1652a131F32a821468Dc03A92df0edd86Ea,
        0x273f7F8E6489682Df756151F5525576E322d51A3,
        0x06012c8cf97BEaD5deAe237070F9587f8E7A266d,
        0x1276dce965ADA590E42d62B3953dDc1DDCeB0392,
        0xE60D2325f996e197EEdDed8964227a0c6CA82D0f,
        0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340,
        0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b,
        0xf26A23019b4699068bb54457f32dAFCF22A9D371,
        0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099,
        0x6EbeAf8e8E946F0716E6533A6f2cefc83f60e8Ab,
        0x5D00d312e171Be5342067c09BaE883f9Bcb2003B,
        0xBfdE6246Df72d3ca86419628CaC46a9d2B60393C,
        0x71C118B00759B0851785642541Ceb0F4CEea0BD5,
        0xF5b0A3eFB8e8E4c201e2A935F110eAaF3FFEcb8d,
        0xbc5370374FE08d699cf7fcd2e625A93BF393cCC4,
        0x31AF195dB332bc9203d758C74dF5A5C5e597cDb7,
        0x1a94fce7ef36Bc90959E206bA569a12AFBC91ca1
        ];
        for(uint i = 0; i< arrGames.length; i++) {
            if(arrGames[i] == address(0xF5b0A3eFB8e8E4c201e2A935F110eAaF3FFEcb8d)
            || arrGames[i] == address(0xbc5370374FE08d699cf7fcd2e625A93BF393cCC4)) {
                Games[arrGames[i]].ETHFee = 10;
                Games[arrGames[i]].limitETHFee = 1000000000000000;
                Games[arrGames[i]].limitHBWALLETFee = 1;
                Games[arrGames[i]].hightLightFee = 100000000000000;
            } else {
                Games[arrGames[i]].ETHFee = 0;
                Games[arrGames[i]].limitETHFee = 0;
                Games[arrGames[i]].limitHBWALLETFee = 0;
                Games[arrGames[i]].hightLightFee = 30000000000000000;
            }

        }

        // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].ETHFee = 10;
        // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitETHFee = 1000000000000000;
        // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitHBWALLETFee = 1;
        // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].hightLightFee = 10000000000000000;
        // arrGames.push(address(0xac9D8D6dB95828259069226456DDe98d8E296c5f));
    }

    function getTokenPrice(address _game, uint256 _tokenId) public returns (address owner, uint256 price, uint256 fee, uint256 hbfee, uint isHightlight, uint isHBHightlight) {
        IERC721 erc721Address = IERC721(_game);
        if(erc721Address.ownerOf(_tokenId) != Games[_game].tokenPrice[_tokenId].tokenOwner
        && erc721Address.ownerOf(_tokenId) != address(this)) resetPrice(_game, _tokenId);
        return (Games[_game].tokenPrice[_tokenId].tokenOwner,
        Games[_game].tokenPrice[_tokenId].price, Games[_game].tokenPrice[_tokenId].fee,
        Games[_game].tokenPrice[_tokenId].hbfee, Games[_game].tokenPrice[_tokenId].isHightlight,
        Games[_game].tokenPrice[_tokenId].isHightlightByHb);
    }
    // new code =======================
    /**
     * @dev Throws if called by any account other than the ceo address.
     */
    modifier onlyCeoAddress() {
        require(msg.sender == ceoAddress);
        _;
    }
    modifier isOwnerOf(address _game, uint256 _tokenId) {
        IERC721 erc721Address = IERC721(_game);
        require(erc721Address.ownerOf(_tokenId) == msg.sender);
        _;
    }
    event _setPrice(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight, uint8 _type);
    event _resetPrice(address _game, uint256 _tokenId);
    function ownerOf(address _game, uint256 _tokenId) public view returns (address){
        IERC721 erc721Address = IERC721(_game);
        return erc721Address.ownerOf(_tokenId);
    }

    function balanceOf() public view returns (uint256){
        return address(this).balance;
    }

    function getApproved(address _game, uint256 _tokenId) public view returns (address){
        IERC721 erc721Address = IERC721(_game);
        return erc721Address.getApproved(_tokenId);
    }

    function setPrice(address _game, uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, uint _isHightLight, uint _isHightLightByHb) internal {
        Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight, _isHightLightByHb);
        Games[_game].tokenIdSale.push(_tokenId);
        bool flag = false;
        for(uint i = 0; i< arrGames.length; i++) {
            if(arrGames[i] == _game) flag = true;
        }
        if(!flag) arrGames.push(_game);
    }
    function calFeeHB(address _game, uint256 _ethPrice) public view returns (uint256){
        uint256 ethfee = _ethPrice.mul(Games[_game].ETHFee).div(Percen);
        uint256 fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
        return fee;
    }
    function calFee(address _game, uint256 _ethPrice) public view returns (uint256){
        return _ethPrice.mul(Games[_game].ETHFee).div(Percen);
    }
    function calPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view
    returns(uint256 _ethNeed, uint256 hightLightFee, uint256 _totalFee) {
        uint256 ethfee;
        uint256 _hightLightFee = 0;
        uint256 ethNeed;
        uint256 totalFee;
        if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
            _hightLightFee = Games[_game].hightLightFee;
        }
        if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
            ethfee = calFee(_game, _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price));
            totalFee = calFee(_game, _ethPrice);
            if(Games[_game].tokenPrice[_tokenId].price == 0 && ethfee < Games[_game].limitETHFee) {
                ethNeed = Games[_game].limitETHFee.add(_hightLightFee);
            } else if(Games[_game].tokenPrice[_tokenId].price > 0 && totalFee < Games[_game].limitETHFee) {
                ethNeed = _hightLightFee;
            } else ethNeed = totalFee.add(_hightLightFee).sub(Games[_game].tokenPrice[_tokenId].fee);

        } else {
            ethNeed = _hightLightFee;
        }
        return (ethNeed, _hightLightFee, totalFee);
    }
    function setPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable isOwnerOf(_game, _tokenId) {	//injected LOCKED ETHER
        require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
        uint256 ethfee;
        uint256 _hightLightFee = 0;
        if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
            _hightLightFee = Games[_game].hightLightFee;
        }
        if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
            ethfee = calFee(_game, _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price));
            uint256 totalFee = calFee(_game, _ethPrice);
            if(Games[_game].tokenPrice[_tokenId].price == 0 && ethfee < Games[_game].limitETHFee) {
                require(msg.value <= Games[_game].limitETHFee.add(_hightLightFee));
                ethfee = Games[_game].limitETHFee;
            } else if(Games[_game].tokenPrice[_tokenId].price > 0 && totalFee < Games[_game].limitETHFee) {
                ethfee = _hightLightFee;
                require(msg.value <= ethfee);
            } else {
                ethfee = totalFee.sub(Games[_game].tokenPrice[_tokenId].fee);
                require(msg.value <= ethfee.add(_hightLightFee));
            }
            ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
        } else ethfee = Games[_game].tokenPrice[_tokenId].fee.add(_hightLightFee);

        setPrice(_game, _tokenId, _ethPrice, ethfee, 0, _isHightLight, 0);
        emit _setPrice(_game, _tokenId, _ethPrice, _isHightLight, 1);
    }

    function calPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
        uint256 fee;
        uint256 _hightLightFee = 0;
        uint256 hbNeed;
        address local_game = _game;
        uint256 local_tokenId = _tokenId;
        if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlightByHb != 1)) {
            _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
        }
        if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
            fee = calFeeHB(_game, _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price));
            uint256 totalFeeHB = calFeeHB(_game, _ethPrice);
            if(fee < Games[local_game].limitHBWALLETFee && Games[local_game].tokenPrice[_tokenId].price == 0) {
                hbNeed = Games[local_game].limitHBWALLETFee.add(_hightLightFee);
            } else if(Games[local_game].tokenPrice[_tokenId].price > 0 && totalFeeHB < Games[_game].limitHBWALLETFee) {
                hbNeed = _hightLightFee;
            } else hbNeed = totalFeeHB.add(_hightLightFee).sub(Games[_game].tokenPrice[_tokenId].hbfee);
        } else {
            hbNeed = _hightLightFee;
        }
        return hbNeed;
    }

    function setPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_game, _tokenId) {
        require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
        uint fee;
        uint _hightLightFee = 0;
        address local_game = _game;
        uint256 local_tokenId = _tokenId;
        if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlightByHb != 1)) {
            _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
        }
        if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
            fee = calFeeHB(_game, _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price));
            uint256 totalFeeHB = calFeeHB(_game, _ethPrice);
            if(fee < Games[local_game].limitHBWALLETFee && Games[local_game].tokenPrice[_tokenId].price == 0) {
                require(hbwalletToken.transferFrom(msg.sender, address(this), Games[local_game].limitHBWALLETFee.add(_hightLightFee)));
                fee = Games[_game].limitHBWALLETFee;
            } else if(Games[local_game].tokenPrice[_tokenId].price > 0 && totalFeeHB < Games[_game].limitHBWALLETFee) {
                fee = _hightLightFee;
                require(hbwalletToken.transferFrom(msg.sender, address(this), fee));
            } else {
                fee = totalFeeHB.sub(Games[_game].tokenPrice[_tokenId].hbfee);
                require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));
            }
            fee = fee.add(Games[local_game].tokenPrice[_tokenId].hbfee);
        } else {
            fee = Games[_game].tokenPrice[_tokenId].hbfee.add(_hightLightFee);
        }

        setPrice(_game, _tokenId, _ethPrice, 0, fee, 0, _isHightLight);
        emit _setPrice(_game, _tokenId, _ethPrice, _isHightLight, 2);
    }

    function removePrice(address _game, uint256 _tokenId) public isOwnerOf(_game, _tokenId){
        if (Games[_game].tokenPrice[_tokenId].fee > 0) msg.sender.transfer(0);
        else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, Games[_game].tokenPrice[_tokenId].hbfee);
        if(Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) {
            IERC721 erc721Address = IERC721(_game);
            erc721Address.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, _tokenId);
        }
        resetPrice(_game, _tokenId);
    }

    function setHBWALLETExchange(uint _HBWALLETExchange) public onlyOwner{
        require(_HBWALLETExchange >= 1);

        HBWALLETExchange = _HBWALLETExchange;
    }

    function setLimitFee(address _game, uint256 _ethFee, uint256 _ethlimitFee, uint _hbWalletlimitFee, uint256 _hightLightFee) public onlyOwner {
        require(_ethFee >= 0 && _ethlimitFee >= 0 && _hbWalletlimitFee >= 0 && _hightLightFee >= 0);
        Games[_game].ETHFee = _ethFee;
        Games[_game].limitETHFee = _ethlimitFee;
        Games[_game].limitHBWALLETFee = _hbWalletlimitFee;
        Games[_game].hightLightFee = _hightLightFee;
    }

    function _withdraw(uint256 amount, uint256 _amountHB) internal {
        require(address(this).balance >= amount && hbwalletToken.balanceOf(address(this)) >= _amountHB);
        if(amount > 0) {
            msg.sender.transfer(0);
        }
        if(_amountHB > 0) {
            hbwalletToken.transfer(msg.sender, _amountHB);
        }
    }
    function withdraw(uint256 amount, uint8 _amountHB) public onlyCeoAddress {
        _withdraw(amount, _amountHB);
    }
    function cancelBussinessByGameId(address _game, uint256 _tokenId) private {
        IERC721 erc721Address = IERC721(_game);
        if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)
        || Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) {

            uint256 eth = Games[_game].tokenPrice[_tokenId].fee;
            if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) eth = eth.add(Games[_game].hightLightFee);
            if(eth > 0 && address(this).balance >= eth) {
                Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(0);
            }

            uint256 hb = Games[_game].tokenPrice[_tokenId].hbfee;
            if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hb = hb.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
            if(hb > 0 && hbwalletToken.balanceOf(address(this)) >= hb) {
                hbwalletToken.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, hb);
            }
            if(Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) erc721Address.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, _tokenId);
            resetPrice(_game, _tokenId);
        }
    }

    function cancelBussinessByGame(address _game) private onlyCeoAddress {
        uint256[] memory _arrTokenId = Games[_game].tokenIdSale;
        for (uint i = 0; i < _arrTokenId.length; i++) {
            cancelBussinessByGameId(_game, _arrTokenId[i]);
        }

    }
    function cancelBussiness() public onlyCeoAddress {
        for(uint j = 0; j< arrGames.length; j++) {
            address _game = arrGames[j];
            cancelBussinessByGame(_game);
        }
        _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));
    }

    function revenue() public view returns (uint256, uint){

        uint256 ethfee;
        uint256 hbfee;
        for(uint j = 0; j< arrGames.length; j++) {

            address _game = arrGames[j];
            IERC721 erc721Address = IERC721(arrGames[j]);
            for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
                uint256 _tokenId = Games[_game].tokenIdSale[i];
                if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {

                    ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
                    if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) ethfee = ethfee.add(Games[_game].hightLightFee);

                    hbfee = hbfee.add(Games[_game].tokenPrice[_tokenId].hbfee);
                    if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hbfee = hbfee.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));

                }
            }
        }

        uint256 eth = address(this).balance.sub(ethfee);
        uint256 hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);
        return (eth, hb);
    }

    function changeCeo(address _address) public onlyCeoAddress {
        require(_address != address(0));
        ceoAddress = _address;

    }

    function buy(address _game, uint256 tokenId) public payable {	//injected LOCKED ETHER
        IERC721 erc721Address = IERC721(_game);
        require(getApproved(_game, tokenId) == address(this));
        require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
        erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
        Games[_game].tokenPrice[tokenId].tokenOwner.transfer(0);
        resetPrice(_game, tokenId);
    }

    function buyWithoutCheckApproved(address _game, uint256 tokenId) public payable {	//injected LOCKED ETHER
        IERC721 erc721Address = IERC721(_game);
        require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
        erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
        Games[_game].tokenPrice[tokenId].tokenOwner.transfer(0);
        resetPrice(_game, tokenId);
    }

    // function buyFromSmartcontract(address _game, uint256 _tokenId) public payable {
    //     IERC721 erc721Address = IERC721(_game);
    //     require(Games[_game].tokenPrice[_tokenId].price == msg.value);
    //     require(erc721Address.ownerOf(_tokenId) == address(this));
    //     erc721Address.transfer(msg.sender, _tokenId);
    //     Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(msg.value);
    //     resetPrice(_game, _tokenId);
    // }
    function buyFromSmartcontractViaTransfer(address _game, uint256 _tokenId) public payable {	//injected LOCKED ETHER
        IERC721 erc721Address = IERC721(_game);
        require(Games[_game].tokenPrice[_tokenId].price == msg.value);
        require(erc721Address.ownerOf(_tokenId) == address(this));
        erc721Address.transfer(msg.sender, _tokenId);
        Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(0);
        resetPrice(_game, _tokenId);
    }
    // Move the last element to the deleted spot.
    // Delete the last element, then correct the length.
    function _burnArrayTokenIdSale(address _game, uint256 index)  internal {
        if (index >= Games[_game].tokenIdSale.length) return;

        for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
            Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
        }
        delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
        Games[_game].tokenIdSale.length--;
    }

    function resetPrice(address _game, uint256 _tokenId) private {
        Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0, 0, 0);
        for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
            if (Games[_game].tokenIdSale[i] == _tokenId) {
                _burnArrayTokenIdSale(_game, i);
            }
        }
        emit _resetPrice(_game, _tokenId);
    }
}