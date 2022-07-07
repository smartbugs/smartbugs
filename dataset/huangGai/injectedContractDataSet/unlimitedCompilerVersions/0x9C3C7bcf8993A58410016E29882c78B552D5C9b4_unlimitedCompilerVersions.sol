/**
 *Submitted for verification at Etherscan.io on 2020-04-25
*/

pragma solidity ^0.5.12;	//inject UNLIMITED COMPILER VERSIONS

/**
 * @title Mining logic
 * @dev Calculation of mining quantity
 */
contract NEST_3_OrePoolLogic {
    using address_make_payable for address;
    using SafeMath for uint256;
    uint256 blockAttenuation = 2400000;                         //  Block attenuation interval
    uint256 attenuationTop = 90;                                //  Attenuation coefficient
    uint256 attenuationBottom = 100;                            //  Attenuation coefficient
    mapping(uint256 => mapping(address => uint256)) blockEth;   //  Total service charge of quotation block. block No. = > token address = > total service charge
    mapping(uint256 => uint256) blockTokenNum;                  //  Block currency quantity. block number = > currency quantity
    mapping(uint256 => uint256) blockMining;                    //  Ore yield of quotation block. Block No. = > ore yield
    uint256 latestMining;                                       //  Latest quotation block
    NEST_2_Mapping mappingContract;                             //  Mapping contract
    NEST_3_MiningSave miningSave;                               //  Ore pool contract
    address abonusAddress;                                      //  Address of dividend pool
    address offerFactoryAddress;                                //  Offer factory contract address
    mapping(uint256 => uint256) blockAmountList;                //  Attenuation list. block number = > attenuation coefficient
    uint256 latestBlock;                                        //  Latest attenuation block

    //  Current block, last quoted block, current block ore yield, current handling fee, token address
    event oreDrawingLog(uint256 nowBlock, uint256 frontBlock, uint256 blockAmount, uint256 miningEth, address tokenAddress);
    //  Quotation block, token address, all handling charges of token, my handling charges, number of tokens
    event miningLog(uint256 blockNum, address tokenAddress, uint256 miningEthAll, uint256 miningEthSelf, uint256 tokenNum);

    /**
    * @dev Initialization method
    * @param map Mapping contract address
    */
    constructor(address map) public {
        mappingContract = NEST_2_Mapping(address(map));                  
        miningSave = NEST_3_MiningSave(mappingContract.checkAddress("miningSave"));
        abonusAddress = address(mappingContract.checkAddress("abonus"));
        offerFactoryAddress = address(mappingContract.checkAddress("offerFactory"));
        latestBlock = block.number.sub(388888);
        latestMining = block.number;
        blockAmountList[block.number.sub(2788888)] = 400 ether;
        blockAmountList[block.number.sub(388888)] = blockAmountList[block.number.sub(2788888)].mul(attenuationTop).div(attenuationBottom);
    }
    
    /**
    * @dev Change mapping contract
    * @param map Mapping contract address
    */
    function changeMapping(address map) public onlyOwner {
        mappingContract = NEST_2_Mapping(address(map));                 
        miningSave = NEST_3_MiningSave(mappingContract.checkAddress("miningSave"));
        abonusAddress = address(mappingContract.checkAddress("abonus"));
        offerFactoryAddress = address(mappingContract.checkAddress("offerFactory"));
    }
    
    /**
    * @dev Calculation of mining volume
    * @param token Offer token address
    */
    function oreDrawing(address token) public payable {
        require(address(msg.sender) == offerFactoryAddress);
        uint256 frontBlock = latestMining;
        changeBlockAmountList();
        if (blockEth[block.number][token] == 0) {
            blockTokenNum[block.number] = blockTokenNum[block.number].add(1);
        }
        blockEth[block.number][token] = blockEth[block.number][token].add(msg.value);
        repayEth(msg.value);
        emit oreDrawingLog(block.number, frontBlock,blockAmountList[latestBlock],msg.value,token);
    }
    
    /**
    * @dev Mining
    * @param amount Number of handling charges
    * @param blockNum Offer block number
    * @param target Transfer target
    * @param token Token address
    * @return Ore yield
    */
    function mining(uint256 amount, uint256 blockNum, address target, address token) public returns(uint256) {
        require(address(msg.sender) == offerFactoryAddress);
        uint256 miningAmount = amount.mul(blockMining[blockNum]).div(blockEth[blockNum][token].mul(blockTokenNum[blockNum]));
        uint256 realAmount = miningSave.turnOut(miningAmount, target);
        emit miningLog(blockNum, token,blockEth[blockNum][token],amount,blockTokenNum[blockNum]);
        return realAmount;
    }
    
    function changeBlockAmountList() private {
        uint256 subBlock = block.number.sub(latestBlock);
        if (subBlock >= blockAttenuation) {
            uint256 subBlockTimes = subBlock.div(blockAttenuation);
            for (uint256 i = 1; i < subBlockTimes.add(1); i++) {
                uint256 newBlockAmount = blockAmountList[latestBlock].mul(attenuationTop).div(attenuationBottom);
                latestBlock = latestBlock.add(blockAttenuation);
                if (latestMining < latestBlock) {
                    blockMining[block.number] = blockMining[block.number].add((blockAmountList[latestBlock.sub(blockAttenuation)]).mul(latestBlock.sub(latestMining).sub(1)));
                    latestMining = latestBlock.sub(1);
                }
                blockAmountList[latestBlock] = newBlockAmount;
            }
        }
        blockMining[block.number] = blockMining[block.number].add(blockAmountList[latestBlock].mul(block.number.sub(latestMining)));
        latestMining = block.number;
    }
    
    function repayEth(uint256 asset) private {
        address payable addr = abonusAddress.make_payable();
        addr.transfer(asset);
    }

    //  View block falloff interval
    function checkBlockAttenuation() public view returns(uint256) {
        return blockAttenuation;
    }

    //  View attenuation factor
    function checkAttenuation() public view returns(uint256 top, uint256 bottom) {
        return (attenuationTop, attenuationBottom);
    }

    //  View the total service charge of quotation block
    function checkBlockEth(uint256 blockNum, address token) public view returns(uint256) {
        return blockEth[blockNum][token];
    }

    //  View block currency quantity
    function checkBlockTokenNum(uint256 blockNum) public view returns(uint256) {
        return blockTokenNum[blockNum];
    }

    //  View the ore yield of quotation block
    function checkBlockMining(uint256 blockNum) public view returns(uint256) {
        return blockMining[blockNum];
    }

    //  View the latest quotation block
    function checkLatestMining() public view returns(uint256) {
        return latestMining;
    }

    //  View falloff list
    function checkBlockAmountList(uint256 blockNum) public view returns(uint256) {
        return blockAmountList[blockNum];
    }

    //  View current ore output
    function checkBlockAmountListLatest() public view returns(uint256) {
        return blockAmountList[latestBlock];
    }

    //  View the latest falloff block
    function checkLatestBlock() public view returns(uint256) {
        return latestBlock;
    }

    //  View the output of quotation contract
    function checkBlockRealAmount(uint256 amount, uint256 blockNum, address token) public view returns(uint256) {
        return amount.mul(blockMining[blockNum]).div(blockEth[blockNum][token].mul(blockTokenNum[blockNum]));
    }

    function changeBlockAttenuation(uint256 blockNum) public onlyOwner {
        require(blockNum > 0);
        blockAttenuation = blockNum;
    }
    
    function changeAttenuation(uint256 top, uint256 bottom) public onlyOwner {
        require(top > 0);
        require(bottom > 0);
        attenuationTop = top;
        attenuationBottom = bottom;
    }
    
    modifier onlyOwner(){
        require(mappingContract.checkOwners(msg.sender) == true);
        _;
    }
}

contract NEST_3_MiningSave {
    function turnOut(uint256 amount, address target) public returns(uint256);
    function checkBalance() public view returns(uint256);
}

contract NEST_2_Mapping {
	function checkAddress(string memory name) public view returns (address contractAddress);
	function checkOwners(address man) public view returns (bool);
}

contract ERC20 {
    function totalSupply() public view returns (uint supply);
    function balanceOf( address who ) public view returns (uint value);
    function allowance( address owner, address spender ) public view returns (uint _allowance);

    function transfer( address to, uint256 value) external;
    function transferFrom( address from, address to, uint value) public returns (bool ok);
    function approve( address spender, uint value ) public returns (bool ok);

    event Transfer( address indexed from, address indexed to, uint value);
    event Approval( address indexed owner, address indexed spender, uint value);
}

library address_make_payable {
   function make_payable(address x) internal pure returns (address payable) {
      return address(uint160(x));
   }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_a == 0) {
      return 0;
    }

    c = _a * _b;
    assert(c / _a == _b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    assert(_b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = _a / _b;
    assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
    return _a / _b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    assert(_b <= _a);
    return _a - _b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    c = _a + _b;
    assert(c >= _a);
    return c;
  }
}