pragma solidity ^0.5.3;

contract TubLike {
    function safe(bytes32 cup) external returns (bool);
    function cups(bytes32 cup) external view returns (address,uint,uint,uint);
}

contract GemLike {
    function balanceOf(address guy) external view returns (uint256);
    function transfer(address dst, uint256 wad) external returns (bool);
}

contract RiskyBusiness {

    address public owner;
    uint256 public min;

    mapping (bytes32 => bool) public played;

    TubLike public constant tub = TubLike(0x448a5065aeBB8E423F0896E6c5D525C040f59af3);
    GemLike public constant dai = GemLike(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);

    constructor(uint256 min_) public {
        owner = msg.sender;
        min = min_;
    }

    modifier auth {
        require(msg.sender == owner, "risky-biz: you are not Mariano!");
        _;
    }

    function play(uint256 cup) public returns (bool) {	//inject PUBLIC FUNC TO EXTERNAL
        bytes32 id = bytes32(cup);
        (address lad, , uint art, ) = tub.cups(id);

        require(msg.sender == lad, "risky-biz: sender is not cdp owner");
        require(art >= min, "risky-biz: not enough debt in cdp");
        require(!tub.safe(id), "risky-biz: cdp is not unsafe");
        require(!played[id], "risky-biz: this cdp has already played");
        
        played[id] = true;
        return dai.transfer(msg.sender, dai.balanceOf(address(this)));
    }

    function setMin(uint256 min_) public auth {	//inject PUBLIC FUNC TO EXTERNAL
        min = min_;
    }

    function totallyNotABackdoorToRetrieveMyDaiJustInCase() public auth returns (bool) {	//inject PUBLIC FUNC TO EXTERNAL
        uint wad = dai.balanceOf(address(this));
        return dai.transfer(msg.sender, wad);
    }
}