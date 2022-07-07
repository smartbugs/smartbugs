/**
 *Submitted for verification at Etherscan.io on 2020-07-28
*/

//Modified from the DAI contract https://etherscan.io/address/0x6b175474e89094c44da98b954eedeac495271d0f#contracts
//Date: 2020-07-22

// Copyright (C) 2017, 2018, 2019 dbrock, rain, mrchico

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity 0.5.12;


contract LibNote {
    event LogNote(
        bytes4   indexed  sig,
        address  indexed  usr,
        bytes32  indexed  arg1,
        bytes32  indexed  arg2,
        bytes             data
    ) anonymous;

    modifier note {
        _;
        assembly {
            // log an 'anonymous' event with a constant 6 words of calldata
            // and four indexed topics: selector, caller, arg1 and arg2
            let mark := msize                         // end of memory ensures zero
            mstore(0x40, add(mark, 288))              // update free memory pointer
            mstore(mark, 0x20)                        // bytes type data offset
            mstore(add(mark, 0x20), 224)              // bytes size (padded)
            calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
            log4(mark, 288,                           // calldata
                 shl(224, shr(224, calldataload(0))), // msg.sig
                 caller,                              // msg.sender
                 calldataload(4),                     // arg1
                 calldataload(36)                     // arg2
                )
        }
    }
}

contract Pitch is LibNote {
    // --- Auth ---
    mapping (address => uint) internal wards;
    function rely(address guy) external note auth { wards[guy] = 1; }	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    function deny(address guy) external note auth { wards[guy] = 0; }	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    modifier auth {
        require(wards[msg.sender] == 1, "Pitch/not-authorized");
        _;
    }

    // --- ERC20 Data ---
    string  public constant name     = "PITCH - v2";
    string  public constant symbol   = "PITCH";
    string  public constant version  = "2";
    uint8   public constant decimals = 18;
    uint256 internal totalSupply;

    mapping (address => uint)                      internal balanceOf;
    mapping (address => mapping (address => uint)) internal allowance;
    mapping (address => uint)                      internal nonces;

    event Approval(address indexed src, address indexed guy, uint wad);
    event Transfer(address indexed src, address indexed dst, uint wad);

    // --- Math ---
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }

    // --- EIP712 niceties ---
    bytes32 internal DOMAIN_SEPARATOR;
    // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
    bytes32 internal constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;

    constructor(uint256 chainId_) public {
        wards[msg.sender] = 1;
        DOMAIN_SEPARATOR = keccak256(abi.encode(
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
            keccak256(bytes(name)),
            keccak256(bytes(version)),
            chainId_,
            address(this)
        ));
    }

    // --- Token ---
    function transfer(address dst, uint wad) external returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }
    function transferFrom(address src, address dst, uint wad)
        public returns (bool)
    {
        require(balanceOf[src] >= wad, "Pitch/insufficient-balance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            require(allowance[src][msg.sender] >= wad, "Pitch/insufficient-allowance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        balanceOf[src] = sub(balanceOf[src], wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balanceOf[dst] = add(balanceOf[dst], wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(src, dst, wad);
        return true;
    }
    function mint(address usr, uint wad) external auth {
        balanceOf[usr] = add(balanceOf[usr], wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalSupply    = add(totalSupply, wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(address(0), usr, wad);
    }
    function burn(address usr, uint wad) external {
        require(balanceOf[usr] >= wad, "Pitch/insufficient-balance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if (usr != msg.sender && allowance[usr][msg.sender] != uint(-1)) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            require(allowance[usr][msg.sender] >= wad, "Pitch/insufficient-allowance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            allowance[usr][msg.sender] = sub(allowance[usr][msg.sender], wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        balanceOf[usr] = sub(balanceOf[usr], wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalSupply    = sub(totalSupply, wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(usr, address(0), wad);
    }
    function approve(address usr, uint wad) external returns (bool) {
        allowance[msg.sender][usr] = wad;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Approval(msg.sender, usr, wad);
        return true;
    }

    // --- Alias ---
    function push(address usr, uint wad) external {
        transferFrom(msg.sender, usr, wad);
    }
    function pull(address usr, uint wad) external {
        transferFrom(usr, msg.sender, wad);
    }
    function move(address src, address dst, uint wad) external {
        transferFrom(src, dst, wad);
    }

    // --- Approve by signature ---
    function permit(address holder, address spender, uint256 nonce, uint256 expiry,
                    bool allowed, uint8 v, bytes32 r, bytes32 s) external
    {
        bytes32 digest =
            keccak256(abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                keccak256(abi.encode(PERMIT_TYPEHASH,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                                     holder,
                                     spender,
                                     nonce,
                                     expiry,
                                     allowed))
        ));

        require(holder != address(0), "Pitch/invalid-address-0");
        require(holder == ecrecover(digest, v, r, s), "Pitch/invalid-permit");
        require(expiry == 0 || now <= expiry, "Pitch/permit-expired");
        require(nonce == nonces[holder]++, "Pitch/invalid-nonce");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint wad = allowed ? uint(-1) : 0;
        allowance[holder][spender] = wad;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Approval(holder, spender, wad);
    }
}