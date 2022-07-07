/**
 *Submitted for verification at Etherscan.io on 2020-07-28
*/

pragma solidity ^0.6.0;	//inject UNLIMITED COMPILER VERSIONS

/**
 * @title Mining contract
 * @dev Mining pool + mining logic
 */
contract Nest_3_MiningContract {
    
    using address_make_payable for address;
    using SafeMath for uint256;
    
    uint256 _blockAttenuation = 2400000;                 //  Block decay time interval
    uint256[10] _attenuationAmount;                      //  Mining decay amount
    uint256 _afterMiningAmount = 40 ether;               //  Stable period mining amount
    uint256 _firstBlockNum;                              //  Starting mining block
    uint256 _latestMining;                               //  Latest offering block
    Nest_3_VoteFactory _voteFactory;                     //  Voting contract
    ERC20 _nestContract;                                 //  NEST contract address
    address _offerFactoryAddress;                        //  Offering contract address
    
    // Current block, current block mining amount
    event OreDrawingLog(uint256 nowBlock, uint256 blockAmount);
    
    /**
    * @dev Initialization method
    * @param voteFactory  voting contract address
    */
    constructor(address voteFactory) public {
        _voteFactory = Nest_3_VoteFactory(address(voteFactory));                  
        _offerFactoryAddress = address(_voteFactory.checkAddress("nest.v3.offerMain"));
        _nestContract = ERC20(address(_voteFactory.checkAddress("nest")));
        // Initiate mining parameters
        _firstBlockNum = 6236588;
        _latestMining = block.number;
        uint256 blockAmount = 400 ether;
        for (uint256 i = 0; i < 10; i ++) {
            _attenuationAmount[i] = blockAmount;
            blockAmount = blockAmount.mul(8).div(10);
        }
    }
    
    /**
    * @dev Reset voting contract
    * @param voteFactory Voting contract address
    */
    function changeMapping(address voteFactory) public onlyOwner {
        _voteFactory = Nest_3_VoteFactory(address(voteFactory));                  
        _offerFactoryAddress = address(_voteFactory.checkAddress("nest.v3.offerMain"));
        _nestContract = ERC20(address(_voteFactory.checkAddress("nest")));
    }
    
    /**
    * @dev Offering mining
    * @return Current block mining amount
    */
    function oreDrawing() public returns (uint256) {
        require(address(msg.sender) == _offerFactoryAddress, "No authority");
        //  Update mining amount list
        uint256 miningAmount = changeBlockAmountList();
        //  Transfer NEST
        if (_nestContract.balanceOf(address(this)) < miningAmount){
            miningAmount = _nestContract.balanceOf(address(this));
        }
        if (miningAmount > 0) {
            _nestContract.transfer(address(msg.sender), miningAmount);
            emit OreDrawingLog(block.number,miningAmount);
        }
        return miningAmount;
    }
    
    /**
    * @dev Update mining amount list
    */
    function changeBlockAmountList() private returns (uint256) {
        uint256 createBlock = _firstBlockNum;
        uint256 recentlyUsedBlock = _latestMining;
        uint256 attenuationPointNow = block.number.sub(createBlock).div(_blockAttenuation);
        uint256 miningAmount = 0;
        uint256 attenuation;
        if (attenuationPointNow > 9) {
            attenuation = _afterMiningAmount;
        } else {
            attenuation = _attenuationAmount[attenuationPointNow];
        }
        miningAmount = attenuation.mul(block.number.sub(recentlyUsedBlock));
        _latestMining = block.number;
        return miningAmount;
    }
    
    /**
    * @dev Transfer all NEST
    * @param target Transfer target address
    */
    function takeOutNest(address target) public onlyOwner {
        _nestContract.transfer(address(target),_nestContract.balanceOf(address(this)));
    }

    // Check block decay time interval
    function checkBlockAttenuation() public view returns(uint256) {
        return _blockAttenuation;
    }
    
    // Check latest offering block
    function checkLatestMining() public view returns(uint256) {
        return _latestMining;
    }
    
    // Check mining amount decay
    function checkAttenuationAmount(uint256 num) public view returns(uint256) {
        return _attenuationAmount[num];
    }
    
    // Check NEST balance
    function checkNestBalance() public view returns(uint256) {
        return _nestContract.balanceOf(address(this));
    }
    
    // Modify block decay time interval
    function changeBlockAttenuation(uint256 blockNum) public onlyOwner {
        require(blockNum > 0);
        _blockAttenuation = blockNum;
    }
    
    // Modify mining amount decay
    function changeAttenuationAmount(uint256 firstAmount, uint256 top, uint256 bottom) public onlyOwner {
        uint256 blockAmount = firstAmount;
        for (uint256 i = 0; i < 10; i ++) {
            _attenuationAmount[i] = blockAmount;
            blockAmount = blockAmount.mul(top).div(bottom);
        }
    }
    
    // Administrator only
    modifier onlyOwner(){
        require(_voteFactory.checkOwners(msg.sender), "No authority");
        _;
    }
}

// Voting contract
interface Nest_3_VoteFactory {
    // Check address
	function checkAddress(string calldata name) external view returns (address contractAddress);
	// Check whether administrator
	function checkOwners(address man) external view returns (bool);
}

// EC20
interface ERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library address_make_payable {
   function make_payable(address x) internal pure returns (address payable) {
      return address(uint160(x));
   }
}