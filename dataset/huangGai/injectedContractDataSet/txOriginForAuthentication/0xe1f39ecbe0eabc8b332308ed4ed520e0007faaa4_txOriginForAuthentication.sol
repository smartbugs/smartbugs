pragma solidity 0.5.9;

contract DistributedEnergyCoinBase {
    uint256                                            _supply;
    mapping (address => uint256)                       _balances;
    
    event Transfer( address indexed from, address indexed to, uint256 value);

    constructor() public {}
    
    function totalSupply() public view returns (uint256) {
        return _supply;
    }
    function balanceOf(address src) public view returns (uint256) {
        return _balances[src];
    }
    
    function transfer(address dst, uint256 wad) public returns (bool) {
        require(_balances[msg.sender] >= wad);
        
        _balances[msg.sender] = sub(_balances[msg.sender], wad);
        _balances[dst] = add(_balances[dst], wad);
        
        emit Transfer(msg.sender, dst, wad);
        
        return true;
    }
    
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 z = x + y;
        require(z >= x && z>=y);
        return z;
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 z = x - y;
        require(x >= y && z <= x);
        return z;
    }
}

contract DistributedEnergyCoin is DistributedEnergyCoinBase {

    string  public  symbol = "EDC";
    string  public name = "EDC Coin";
    uint256  public  decimals = 8; 
    uint256 public freezedValue = 38280000*(10**8);
    uint256 public releaseTime = 1560902400; 
    uint256 public latestReleaseTime = 1560902400; // 2019-06-19
    address public owner;
    address public freezeOwner = address(0x01);

    struct FreezeStruct {
        uint256 unfreezeTime;   //11
        uint256 unfreezeValue;  //11
        bool freezed;
    }

    FreezeStruct[] public unfreezeTimeMap;
    
    constructor() public{
        _supply = 319000000*(10**8);
        _balances[freezeOwner] = freezedValue;
        _balances[msg.sender] = sub(_supply,freezedValue);
        owner = msg.sender;

        unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1586995200, unfreezeValue:9570000*(10**8), freezed: true})); // 2020-04-16
        unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1618531200, unfreezeValue:14355000*(10**8), freezed: true})); // 2021-04-16
        unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1650067200, unfreezeValue:14355000*(10**8), freezed: true})); // 2022-04-16
    }

    function transfer(address dst, uint256 wad) public returns (bool) {
        require (now >= releaseTime || now >= latestReleaseTime);

        return super.transfer(dst, wad);
    }

    function distribute(address dst, uint256 wad) public returns (bool) {
        require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION


        return super.transfer(dst, wad);
    }

    function setRelease(uint256 _release) public {
        require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        require(_release <= latestReleaseTime);

        releaseTime = _release;
    }

    function unfreeze(uint256 i) public {
        require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        require(i>=0 && i<unfreezeTimeMap.length);
        require(now >= unfreezeTimeMap[i].unfreezeTime && unfreezeTimeMap[i].freezed);
        require(_balances[freezeOwner] >= unfreezeTimeMap[i].unfreezeValue);

        _balances[freezeOwner] = sub(_balances[freezeOwner], unfreezeTimeMap[i].unfreezeValue);
        _balances[owner] = add(_balances[owner], unfreezeTimeMap[i].unfreezeValue);

        freezedValue = sub(freezedValue, unfreezeTimeMap[i].unfreezeValue);
        unfreezeTimeMap[i].freezed = false;

        emit Transfer(freezeOwner, owner, unfreezeTimeMap[i].unfreezeValue);
    }
}