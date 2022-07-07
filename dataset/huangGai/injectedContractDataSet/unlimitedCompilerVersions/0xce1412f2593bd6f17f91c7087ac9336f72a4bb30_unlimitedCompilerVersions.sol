/**
 *Submitted for verification at Etherscan.io on 2020-08-19
*/

pragma solidity ^0.5.0;	//inject UNLIMITED COMPILER VERSIONS

contract DSMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }
}

contract SpaghettiToken is DSMath {
    uint256                                           public  totalSupply;
    mapping (address => uint256)                      public  balanceOf;
    mapping (address => mapping (address => uint256)) public  allowance;
    bytes32                                           public  symbol = "PASTA";
    uint256                                           public  decimals = 18;
    bytes32                                           public  name = "Spaghetti";

    constructor(address chef) public {
        totalSupply = 15000000000000000000000000;
        balanceOf[chef] = 15000000000000000000000000;
    }

    event Transfer(address indexed src, address indexed dst, uint wad);
    event Burn(uint wad);
    event Approval(address indexed src, address indexed guy, uint wad);
  
    function approve(address guy) external returns (bool) {
        return approve(guy, uint(-1));
    }

    function approve(address guy, uint wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;

        emit Approval(msg.sender, guy, wad);

        return true;
    }
    function burn(uint wad) internal {
        totalSupply = sub(totalSupply, wad);
        emit Burn(wad);
    }
    function transfer(address dst, uint wad) external returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad) public returns (bool) {
        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
            require(allowance[src][msg.sender] >= wad, "ds-token-insufficient-approval");
            allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
        }

        require(balanceOf[src] >= wad, "ds-token-insufficient-balance");
        balanceOf[src] = sub(balanceOf[src], wad);
        uint one = wad / 100;
        uint ninetynine = sub(wad, one);
        balanceOf[dst] = add(balanceOf[dst], ninetynine);
        burn(one);

        emit Transfer(src, dst, wad);

        return true;
    }
}