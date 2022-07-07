/**
 *Submitted for verification at Etherscan.io on 2020-04-25
*/

pragma solidity ^0.5.8;

contract IBNEST {
    function totalSupply() public view returns (uint supply);
    function balanceOf( address who ) public view returns (uint value);
    function allowance( address owner, address spender ) public view returns (uint _allowance);

    function transfer( address to, uint256 value) external;
    function transferFrom( address from, address to, uint value) public returns (bool ok);
    function approve( address spender, uint value ) public returns (bool ok);

    event Transfer( address indexed from, address indexed to, uint value);
    event Approval( address indexed owner, address indexed spender, uint value);
    
    function balancesStart() public view returns(uint256);
    function balancesGetBool(uint256 num) public view returns(bool);
    function balancesGetNext(uint256 num) public view returns(uint256);
    function balancesGetValue(uint256 num) public view returns(address, uint256);
}

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

contract IBMapping {
    function checkAddress(string memory name) public view returns (address contractAddress);
    function checkOwners(address man) public view returns (bool);
}

library address_make_payable {
   function make_payable(address x) internal pure returns (address payable) {
      return address(uint160(x));
   }
}

/**
 * @title Nest storage contract
 */
contract NESTSave {
    using SafeMath for uint256;
    mapping (address => uint256) baseMapping;                   //  General ledger
    IBNEST nestContract;                                        //  Nest contract
    IBMapping mappingContract;                                  //  Mapping contract 
    
    /**
    * @dev Initialization method
    * @param map Mapping contract address
    */
    constructor(address map) public {
        mappingContract = IBMapping(map); 
        nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
    }
    
    /**
    * @dev Change mapping contract
    * @param map Mapping contract address
    */
    function changeMapping(address map) public onlyOwner{
        mappingContract = IBMapping(map); 
        nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
    }
    
    /**
    * @dev Take out nest
    * @param num Quantity taken out
    */
    function takeOut(uint256 num) public onlyContract {
        require(isContract(address(tx.origin)) == false);          
        require(num <= baseMapping[tx.origin]);
        baseMapping[address(tx.origin)] = baseMapping[address(tx.origin)].sub(num);
        nestContract.transfer(address(tx.origin), num);
    }
    
    /**
    * @dev Deposit in nest
    * @param num Deposit quantity
    */
    function depositIn(uint256 num) public onlyContract {
        require(isContract(address(tx.origin)) == false);                               
        require(nestContract.balanceOf(address(tx.origin)) >= num);                     
        require(nestContract.allowance(address(tx.origin), address(this)) >= num);      
        require(nestContract.transferFrom(address(tx.origin),address(this),num));       
        baseMapping[address(tx.origin)] = baseMapping[address(tx.origin)].add(num);
    }
    
    /**
    * @dev Take out all
    */
    function takeOutPrivate() public {
        require(isContract(address(msg.sender)) == false);          
        require(baseMapping[msg.sender] > 0);
        nestContract.transfer(address(msg.sender), baseMapping[msg.sender]);
        baseMapping[address(msg.sender)] = 0;
    }
    
    function checkAmount(address sender) public view returns(uint256) {
        return baseMapping[address(sender)];
    }
    
    modifier onlyOwner(){
        require(mappingContract.checkOwners(msg.sender) == true);
        _;
    }
    
    modifier onlyContract(){
        require(mappingContract.checkAddress("nestAbonus") == msg.sender);
        _;
    }

    function isContract(address addr) public view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}

/**
 * @title Dividend pool contract
 */
contract Abonus {
    using address_make_payable for address;
    IBMapping mappingContract;                                  //  Mapping contract
    
    /**
    * @dev Initialization method
    * @param map Mapping contract address
    */
    constructor(address map) public {
        mappingContract = IBMapping(map);
    }
    
    /**
    * @dev Change mapping contract
    * @param map Mapping contract address
    */
    function changeMapping(address map) public onlyOwner{
        mappingContract = IBMapping(map);
    }
    
    /**
    * @dev Draw ETH
    * @param num Draw amount
    * @param target Transfer target
    */
    function getETH(uint256 num, address target) public onlyContract {
        require(num <= getETHNum());
        address payable addr = target.make_payable();
        addr.transfer(num);                                                                              
    }
    
    function getETHNum() public view returns (uint256) {
        return address(this).balance;
    }
    
    modifier onlyContract(){
        require(mappingContract.checkAddress("nestAbonus") == msg.sender);
        _;
    }

    modifier onlyOwner(){
        require(mappingContract.checkOwners(msg.sender) == true);
        _;
    }

    function () external payable {
        
    }
}

/**
 * @title Leveling contract
 */
contract NESTLeveling {
    using address_make_payable for address;
    IBMapping mappingContract;                              //  Mapping contract

    /**
    * @dev Initialization method
    * @param map Mapping contract address
    */
    constructor (address map) public {
        mappingContract = IBMapping(map); 
    }
    
    /**
    * @dev Change mapping contract
    * @param map Mapping contract address
    */
    function changeMapping(address map) public onlyOwner {
        mappingContract = IBMapping(map); 
    }
    
    /**
    * @dev Transfer ETH
    * @param amount Transfer quantity
    * @param target Transfer target
    */
    function tranEth(uint256 amount, address target) public {
        require(address(msg.sender) == address(mappingContract.checkAddress("nestAbonus")));
        uint256 tranAmount = amount;
        if (block.number > address(this).balance) {	//injected CONTRACT AFFECTED BY MINERS
            tranAmount = address(this).balance;
        }
        address payable addr = target.make_payable();
        addr.transfer(tranAmount);
    }
    
    function () external payable {
        
    }
    
    modifier onlyOwner(){
        require(mappingContract.checkOwners(msg.sender) == true);
        _;
    }
}

/**
 * @title Dividend logical contract
 */
contract NESTAbonus {
    using address_make_payable for address;
    using SafeMath for uint256;
    IBNEST nestContract;
    IBMapping mappingContract;                  
    NESTSave baseMapping;
    Abonus abonusContract;
    NESTLeveling nestLeveling;
    uint256 timeLimit = 168 hours;                                  //  Dividend period
    uint256 nextTime = 1587700800;                                  //  Next dividend time
    uint256 getAbonusTimeLimit = 60 hours;                          //  Trigger calculation settlement time
    uint256 ethNum = 0;                                             //  ETH amount
    uint256 nestAllValue = 0;                                       //  Nest circulation
    uint256 times = 0;                                              //  Dividend book
    uint256 expectedIncrement = 3;                                  //  Expected dividend increment proportion
    uint256 expectedMinimum = 100 ether;                            //  Expected minimum dividend
    uint256 levelingProportion = 10;                                //  Proportion of dividends deducted
    mapping(uint256 => mapping(address => bool)) getMapping;        //  Dividend collection record

    /**
    * @dev Initialization method
    * @param map Mapping contract address
    */
    constructor (address map) public {
        mappingContract = IBMapping(map); 
        nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
        baseMapping = NESTSave(address(mappingContract.checkAddress("nestSave")));
        address payable addr = address(mappingContract.checkAddress("abonus")).make_payable();
        abonusContract = Abonus(addr);
        address payable levelingAddr = address(mappingContract.checkAddress("nestLeveling")).make_payable();
        nestLeveling = NESTLeveling(levelingAddr);
    }
    
    /**
    * @dev Change mapping contract
    * @param map Mapping contract address
    */
    function changeMapping(address map) public onlyOwner {
        mappingContract = IBMapping(map); 
        nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
        baseMapping = NESTSave(address(mappingContract.checkAddress("nestSave")));
        address payable addr = address(mappingContract.checkAddress("abonus")).make_payable();
        abonusContract = Abonus(addr);
        address payable levelingAddr = address(mappingContract.checkAddress("nestLeveling")).make_payable();
        nestLeveling = NESTLeveling(levelingAddr);
    }
    
    /**
    * @dev Deposit in nest
    * @param amount Deposit quantity
    */
    function depositIn(uint256 amount) public {
        require(address(tx.origin) == address(msg.sender));         
        uint256 nowTime = now;
        if (block.number < nextTime) {	//injected CONTRACT AFFECTED BY MINERS
            require(!(nowTime >= nextTime.sub(timeLimit) && nowTime <= nextTime.sub(timeLimit).add(getAbonusTimeLimit)));
        } else {
            require(!(nowTime >= nextTime && nowTime <= nextTime.add(getAbonusTimeLimit)));
            uint256 time = (nowTime.sub(nextTime)).div(timeLimit);
            uint256 startTime = nextTime.add((time).mul(timeLimit));        
            uint256 endTime = startTime.add(getAbonusTimeLimit);        
            require(!(nowTime >= startTime && nowTime <= endTime));
        }
        baseMapping.depositIn(amount);                           
    }
    
    /**
    * @dev Take out nest
    * @param amount Quantity taken out
    */
    function takeOut(uint256 amount) public {
        require(address(tx.origin) == address(msg.sender));          
        require(amount != 0);                                      
        require(amount <= baseMapping.checkAmount(address(msg.sender)));
        baseMapping.takeOut(amount);                           
    }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    
    /**
    * @dev Receive dividend
    */
    function getETH() public {
        require(address(tx.origin) == address(msg.sender));        
        reloadTimeAndMapping ();            
        uint256 nowTime = now;
        require(nowTime >= nextTime.sub(timeLimit) && nowTime <= nextTime.sub(timeLimit).add(getAbonusTimeLimit));
        require(getMapping[times.sub(1)][address(msg.sender)] != true);       
        uint256 nestAmount = baseMapping.checkAmount(address(msg.sender));
        require(nestAmount > 0);
        require(nestAllValue > 0);
        uint256 selfEth = nestAmount.mul(ethNum).div(nestAllValue);
        require(selfEth > 0);
        getMapping[times.sub(1)][address(msg.sender)] = true;
        abonusContract.getETH(selfEth, address(msg.sender));                        
    }
    
    function levelingResult() private {
        abonusContract.getETH(abonusContract.getETHNum().mul(levelingProportion).div(100), address(nestLeveling));
        uint256 miningAmount = allValue().div(100000000 ether);
        uint256 minimumAbonus = expectedMinimum;
        for (uint256 i = 0; i < miningAmount; i++) {
            minimumAbonus = minimumAbonus.add(minimumAbonus.mul(expectedIncrement).div(100));
        }
        uint256 nowEth = abonusContract.getETHNum();
        if (block.gaslimit < minimumAbonus) {	//injected CONTRACT AFFECTED BY MINERS
            nestLeveling.tranEth(minimumAbonus.sub(nowEth), address(abonusContract));
        }
    }
    
    function reloadTimeAndMapping() private {
        uint256 nowTime = now;
        if (block.number >= nextTime) {                                          	//injected CONTRACT AFFECTED BY MINERS
            levelingResult();
            uint256 time = (nowTime.sub(nextTime)).div(timeLimit);
            uint256 startTime = nextTime.add((time).mul(timeLimit));      
            uint256 endTime = startTime.add(getAbonusTimeLimit);           
            if (nowTime >= startTime && nowTime <= endTime) {
                nextTime = getNextTime();                                   
                times = times.add(1);                                   
                ethNum = abonusContract.getETHNum();                    
                nestAllValue = allValue();                              
            }
        }
    }
    
    function getInfo() public view returns (uint256 _nextTime, uint256 _getAbonusTime, uint256 _ethNum, uint256 _nestValue, uint256 _myJoinNest, uint256 _getEth, uint256 _allowNum, uint256 _leftNum, bool allowAbonus)  {
        uint256 nowTime = now;
        if (nowTime >= nextTime.sub(timeLimit) && nowTime <= nextTime.sub(timeLimit).add(getAbonusTimeLimit)) {
            allowAbonus = getMapping[times.sub(1)][address(msg.sender)];
            _ethNum = ethNum;
            _nestValue = nestAllValue;
        } else {
            _ethNum = abonusContract.getETHNum();
            _nestValue = allValue();
            allowAbonus = getMapping[times][address(msg.sender)];
        }
        _myJoinNest = baseMapping.checkAmount(address(msg.sender));
        if (allowAbonus == true) {
            _getEth = 0; 
        } else {
            _getEth = _myJoinNest.mul(_ethNum).div(_nestValue);
        }
        _nextTime = getNextTime();
        _getAbonusTime = _nextTime.sub(timeLimit).add(getAbonusTimeLimit);
        _allowNum = nestContract.allowance(address(msg.sender), address(baseMapping));
        _leftNum = nestContract.balanceOf(address(msg.sender));
    }
    
    function getNextTime() public view returns (uint256) {
        uint256 nowTime = now;
        if (block.gaslimit > nowTime) { 	//injected CONTRACT AFFECTED BY MINERS
            return nextTime; 
        } else {
            uint256 time = (nowTime.sub(nextTime)).div(timeLimit);
            return nextTime.add(timeLimit.mul(time.add(1)));
        }
    }
    
    function allValue() public view returns (uint256) {
        uint256 all = 10000000000 ether;
        uint256 leftNum = all.sub(nestContract.balanceOf(address(mappingContract.checkAddress("miningSave"))));
        return leftNum;
    }

    function checkTimeLimit() public view returns(uint256) {
        return timeLimit;
    }

    function checkGetAbonusTimeLimit() public view returns(uint256) {
        return getAbonusTimeLimit;
    }

    function checkMinimumAbonus() public view returns(uint256) {
        uint256 miningAmount = allValue().div(100000000 ether);
        uint256 minimumAbonus = expectedMinimum;
        for (uint256 i = 0; i < miningAmount; i++) {
            minimumAbonus = minimumAbonus.add(minimumAbonus.mul(expectedIncrement).div(100));
        }
        return minimumAbonus;
    }

    function changeTimeLimit(uint256 hour) public onlyOwner {
        require(hour > 0);
        timeLimit = hour.mul(1 hours);
    }

    function changeGetAbonusTimeLimit(uint256 hour) public onlyOwner {
        require(hour > 0);
        getAbonusTimeLimit = hour;
    }

    function changeExpectedIncrement(uint256 num) public onlyOwner {
        require(num > 0);
        expectedIncrement = num;
    }

    function changeExpectedMinimum(uint256 num) public onlyOwner {
        require(num > 0);
        expectedMinimum = num;
    }

    function changeLevelingProportion(uint256 num) public onlyOwner {
        require(num > 0);
        levelingProportion = num;
    }

    modifier onlyOwner(){
        require(mappingContract.checkOwners(msg.sender) == true);
        _;
    }

}