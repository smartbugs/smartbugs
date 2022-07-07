                                                                 

// Copyright (C) 2015, 2016, 2017  DappHub, LLC

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity >=0.6.0;

contract DSMath {
    function ADD152(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require((z = x + y) >= x, "ds-math-add-overflow");
    }
    function SUB967(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }
    function MUL745(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }
}

contract SEEN is DSMath {
    uint256                                           public  totalSupply;
    mapping (address => uint256)                      public  balanceOf;
    mapping (address => mapping (address => uint256)) public  allowance;
    string                                            public  symbol = "SEEN";
    string                                            public  name = "seen.haus";
    uint256                                           public  decimals = 18;

    constructor(address seen) public {
        MINT671(seen, 1000000000000000000000000);
    }

    event APPROVAL386(address indexed src, address indexed guy, uint wad);	//inject NONSTANDARD NAMING
    event TRANSFER754(address indexed src, address indexed dst, uint wad);	//inject NONSTANDARD NAMING
    event MINT76(address indexed guy, uint wad);	//inject NONSTANDARD NAMING

    function APPROVE373(address guy) external returns (bool) {	//inject NONSTANDARD NAMING
        return APPROVE373(guy, uint(-1));
    }

    function APPROVE373(address guy, uint wad) public returns (bool) {	//inject NONSTANDARD NAMING
        allowance[msg.sender][guy] = wad;

        emit APPROVAL386(msg.sender, guy, wad);

        return true;
    }

    function TRANSFER203(address dst, uint wad) external returns (bool) {	//inject NONSTANDARD NAMING
        return TRANSFERFROM663(msg.sender, dst, wad);
    }

    function TRANSFERFROM663(address src, address dst, uint wad)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
            require(allowance[src][msg.sender] >= wad, "ds-token-insufficient-approval");
            allowance[src][msg.sender] = SUB967(allowance[src][msg.sender], wad);
        }

        require(balanceOf[src] >= wad, "ds-token-insufficient-balance");
        balanceOf[src] = SUB967(balanceOf[src], wad);
        balanceOf[dst] = ADD152(balanceOf[dst], wad);

        emit TRANSFER754(src, dst, wad);

        return true;
    }

    function MINT671(address guy, uint wad) internal {	//inject NONSTANDARD NAMING
        balanceOf[guy] = ADD152(balanceOf[guy], wad);
        totalSupply = ADD152(totalSupply, wad);
        emit MINT76(guy, wad);
    }
}