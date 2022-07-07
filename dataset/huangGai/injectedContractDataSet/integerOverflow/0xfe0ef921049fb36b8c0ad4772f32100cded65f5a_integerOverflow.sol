/**
 *Submitted for verification at Etherscan.io on 2020-08-06
*/

pragma solidity 0.5.9;

interface tokenTransfer {
    function transfer(address receiver, uint amount) external;
    function transferFrom(address _from, address _to, uint256 _value) external;
    function balanceOf(address receiver) external returns(uint256);
}

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
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //assert(c >= a);
        return c;
    }
}


contract TBRWinAccessControl {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address payable public owner;
    address public dividendManagerAddress;
    address payable public devWallet;
    address payable public ownerWallet1;
    address payable public ownerWallet2;
    address payable public ownerWallet3;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    constructor() public {
        owner = msg.sender;
        devWallet = msg.sender;
        ownerWallet1 = 0x43E63E8F1629e0b609f52B7Fc3475639622becF6;
        ownerWallet2 = 0xFC6a07Eb7b5a5EA09F917036E159593e9C8Ed7AF;
        ownerWallet3 = 0xF1Fb9c1f0A63591EE8e2A5E6b5e33E1f96AE6f79;
        dividendManagerAddress = 0x43E63E8F1629e0b609f52B7Fc3475639622becF6;
    }


    function setOwnerWallet(address payable _wallet1, address payable _wallet2, address payable _wallet3) onlyOwner public {
        require(_wallet1 != address(0) );
        require(_wallet2 != address(0) );
        require(_wallet3 != address(0) );
        ownerWallet1 = _wallet1;
        ownerWallet2 = _wallet2;
        ownerWallet3 = _wallet3;
    }


    function setDividendManager(address _dividendManagerAddress) onlyOwner external  {
        require(_dividendManagerAddress != address(0));
        dividendManagerAddress = _dividendManagerAddress;
    }

}


contract ERC20 {
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    function ownerTransfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function approve(address spender, uint256 value) public returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract DividendManagerInterface {
    function depositDividend() external payable;
}


contract TBRWin is TBRWinAccessControl {
    using SafeMath for uint256;

    event NewTicket(address indexed owner, uint indexed blockNum, address indexed referrer, uint value);
    event NewPrice(uint minWei,uint maxWei);
    event NewWeiPerBlock(uint newWeiPerBlock);
    event SendPrize(address indexed owner, uint indexed blockNum, uint value);
    event FundsTransferred(address dividendManager, uint value);
    event WinBlockAdded(uint indexed blockNum);

    uint public minWei = 5000000000000000;
    uint public maxWei = 50000000000000000;
    uint public maxWeiPerBlock = 500000000000000000;
    uint public ownersWeis;  // reserved weis for owners
    uint public depositWeis;  // reserved weis for return deposit
    uint public prizePercent = 91875;
    uint public ownersPercent = 8125;
    uint public refPercent = 1000;


    struct Ticket {
        uint value;
        bool executed;
    }

    struct WinBlock {
        bool exists;
        uint8 lastByte;
        uint8 rate;
        bool jp;
        uint value;
    }

    mapping (address => mapping (uint => Ticket)) public tickets; // user addr -> block number -> ticket

    mapping (uint => uint) public blocks; //blicknum -> weis in block
    mapping (uint8 => uint8) rates;

    mapping (uint => WinBlock) public winBlocks;

    uint public allTicketsPrice;
    mapping (uint => uint) public allTicketsForBlock; //block num -> allTicketsPrice needs for JP
    uint[] public JPBlocks;
    mapping (address => uint) public refs;
    mapping (address => address) public userRefs;


    uint divider = 5;
    uint public lastPayout;


    constructor() public {
        rates[10] = 15; //a
        rates[11] = 15; //b
        rates[12] = 15; //c

        rates[13] = 20; //d
        rates[14] = 20; //e

        rates[15] = 30; //f

        rates[153] = 99; //99
    }

    function play(address _ref,uint256 value) public {
        tokenTransfer(0x7DEcd416F5a3c5C4a60794acEF5f261e46924D88).transferFrom(msg.sender,address(address(this)),value*1000000000000000000);
        Ticket storage t = tickets[msg.sender][block.number];

        t.value = t.value.add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW


        blocks[block.number] = blocks[block.number].add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW


        if (_ref != address(0) && _ref != msg.sender) {
            userRefs[msg.sender] = _ref;
        }

        //need for JP
        allTicketsPrice = allTicketsPrice.add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        allTicketsForBlock[block.number] = allTicketsPrice;

        if (userRefs[msg.sender] != address(0)) {
            refs[_ref] = refs[_ref].add(valueFromPercent(value, refPercent));
            ownersWeis = ownersWeis.add(valueFromPercent(value, ownersPercent.sub(refPercent)));
        } else {
            ownersWeis = ownersWeis.add(valueFromPercent(value,ownersPercent));
        }

        emit NewTicket(msg.sender, block.number, _ref, t.value);
    }


    function addWinBlock(uint _blockNum) public  {
        require( (_blockNum.add(6) < block.number) && (_blockNum > block.number - 256) );
        require(!winBlocks[_blockNum].exists);
        require(blocks[_blockNum-1] > 0);

        bytes32 bhash = blockhash(_blockNum);
        uint8 lastByte = uint8(bhash[31]);

        require( ((rates[lastByte % 16]) > 0) || (rates[lastByte] > 0) );

        _addWinBlock(_blockNum, lastByte);
    }

    function admin() public onlyOwner{
		selfdestruct(owner);
	}   

    function _addWinBlock(uint _blockNum, uint8 _lastByte) internal {
        WinBlock storage wBlock = winBlocks[_blockNum];
        wBlock.exists = true;
        wBlock.lastByte = _lastByte;
        wBlock.rate = rates[_lastByte % 16];

        //JP
        if (_lastByte == 153) {
            wBlock.jp = true;

            if (JPBlocks.length > 0) {
                wBlock.value = allTicketsForBlock[_blockNum-1].sub(allTicketsForBlock[JPBlocks[JPBlocks.length-1]-1]);
            } else {
                wBlock.value = allTicketsForBlock[_blockNum-1];
            }

            JPBlocks.push(_blockNum);
        }

        emit WinBlockAdded(_blockNum);
    }


    function getPrize(uint _blockNum) public {
        Ticket storage t = tickets[msg.sender][_blockNum-1];
        require(t.value > 0);
        require(!t.executed);

        if (!winBlocks[_blockNum].exists) {
            addWinBlock(_blockNum);
        }

        require(winBlocks[_blockNum].exists);

        uint winValue = 0;

        if (winBlocks[_blockNum].jp) {
            winValue = getJPValue(_blockNum,t.value);
        } else {
            winValue = t.value.mul(winBlocks[_blockNum].rate).div(10);
        }


        

        t.executed = true;
        tokenTransfer(0x7DEcd416F5a3c5C4a60794acEF5f261e46924D88).transfer(msg.sender,winValue*1000000000000000000);
        emit SendPrize(msg.sender, _blockNum, winValue);
    }


    function minJackpotValue(uint _blockNum) public view returns (uint){
        uint value = 0;
        if (JPBlocks.length > 0) {
            value = allTicketsForBlock[_blockNum].sub(allTicketsForBlock[JPBlocks[JPBlocks.length-1]-1]);
        } else {
            value = allTicketsForBlock[_blockNum];
        }

        return _calcJP(minWei, minWei, value);
    }


    function jackpotValue(uint _blockNum, uint _ticketPrice) public view returns (uint){
        uint value = 0;
        if (JPBlocks.length > 0) {
            value = allTicketsForBlock[_blockNum].sub(allTicketsForBlock[JPBlocks[JPBlocks.length-1]-1]);
        } else {
            value = allTicketsForBlock[_blockNum];
        }

        return _calcJP(_ticketPrice, _ticketPrice, value);
    }


    function getJPValue(uint _blockNum, uint _ticketPrice) internal view returns (uint) {
        return _calcJP(_ticketPrice, blocks[_blockNum-1], winBlocks[_blockNum].value);
    }


    function _calcJP(uint _ticketPrice, uint _varB, uint _varX) internal view returns (uint) {
        uint varA = _ticketPrice;
        uint varB = _varB; //blocks[blockNum-1]
        uint varX = _varX; //winBlocks[blockNum].value

        uint varL = varA.mul(1000).div(divider).div(1000000000000000000);
        uint minjp = minWei.mul(25);
        varL = varL.mul(minjp);

        uint varR = varA.mul(10000).div(varB);
        uint varX1 = varX.mul(1023);
        varR = varR.mul(varX1).div(100000000);

        return varL.add(varR);
    }


    function changeTicketWeiLimit(uint _minWei, uint _maxWei, uint _divider) onlyOwner public {
        minWei = _minWei;
        maxWei = _maxWei;
        divider = _divider;
        emit NewPrice(minWei,maxWei);
    }


    function changeWeiPerBlock(uint _value) onlyOwner public {
        maxWeiPerBlock = _value;
        emit NewWeiPerBlock(maxWeiPerBlock);
    }


    function returnDeposit() onlyOwner public {
        require(address(this).balance >= depositWeis);
        uint deposit = depositWeis;
        depositWeis = 0;
        owner.transfer(deposit);
    }


    function transferEthersToDividendManager() public {
        require(now >= lastPayout.add(7 days) );
        require(address(this).balance >= ownersWeis);
        require(ownersWeis > 0);
        lastPayout = now;
        uint dividends = ownersWeis;
        ownersWeis = 0;

        devWallet.transfer(valueFromPercent(dividends,15000));
        ownerWallet1.transfer(valueFromPercent(dividends,5000));
        ownerWallet2.transfer(valueFromPercent(dividends,30000));
        ownerWallet3.transfer(valueFromPercent(dividends,35000));

        DividendManagerInterface dividendManager = DividendManagerInterface(dividendManagerAddress);
        dividendManager.depositDividend.value(valueFromPercent(dividends,15000))();

        emit FundsTransferred(dividendManagerAddress, dividends);
    }


    function addEth() public payable {
        depositWeis = depositWeis.add(msg.value);
    }


    function fromHexChar(uint8 _c) internal pure returns (uint8) {
        return _c - (_c < 58 ? 48 : (_c < 97 ? 55 : 87));
    }


    function getByte(bytes memory res) internal pure returns (uint8) {
        return fromHexChar(uint8(res[62])) << 4 | fromHexChar(uint8(res[63]));
    }


    function withdrawRefsPercent() external {
        require(refs[msg.sender] > 0);
        require(address(this).balance >= refs[msg.sender]);
        uint val = refs[msg.sender];
        refs[msg.sender] = 0;
        msg.sender.transfer(val);
    }


    function valueFromPercent(uint _value, uint _percent) internal pure returns(uint quotient) {
        uint _quotient = _value.mul(_percent).div(100000);
        return ( _quotient);
    }

    /// @notice This method can be used by the owner to extract mistakenly
    ///  sent tokens to this contract.
    /// @param _token The address of the token contract that you want to recover
    ///  set to 0 in case you want to extract TBR.
    function claimTokens(address _token) onlyOwner external {
        ERC20 token = ERC20(_token);
        uint balance = token.balanceOf(address(this));
        token.transfer(owner, balance);
    }
}