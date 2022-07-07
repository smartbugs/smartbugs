                                                                 

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

pragma solidity ^0.5.12;

contract LibNote {
    event LOGNOTE625(	//inject NONSTANDARD NAMING
        bytes4   indexed  sig,
        address  indexed  usr,
        bytes32  indexed  arg1,
        bytes32  indexed  arg2,
        bytes             data
    ) anonymous;

    modifier NOTE96 {	//inject NONSTANDARD NAMING
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

                     

// Copyright (C) 2018-2020 Maker Ecosystem Growth Holdings, INC.

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

//pragma solidity ^0.5.12;

//import { LibNote } from "dss/lib.sol";

contract VatLike {
    function URNS742(bytes32, address) public view returns (uint, uint);	//inject NONSTANDARD NAMING
    function HOPE954(address) public;	//inject NONSTANDARD NAMING
    function FLUX111(bytes32, address, address, uint) public;	//inject NONSTANDARD NAMING
    function MOVE24(address, address, uint) public;	//inject NONSTANDARD NAMING
    function FROB530(bytes32, address, address, address, int, int) public;	//inject NONSTANDARD NAMING
    function FORK185(bytes32, address, address, int, int) public;	//inject NONSTANDARD NAMING
}

contract UrnHandler {
    constructor(address vat) public {
        VatLike(vat).HOPE954(msg.sender);
    }
}

contract DssCdpManager is LibNote {
    address                   public vat;
    uint                      public cdpi;      // Auto incremental
    mapping (uint => address) public urns;      // CDPId => UrnHandler
    mapping (uint => List)    public list;      // CDPId => Prev & Next CDPIds (double linked list)
    mapping (uint => address) public owns;      // CDPId => Owner
    mapping (uint => bytes32) public ilks;      // CDPId => Ilk

    mapping (address => uint) public first;     // Owner => First CDPId
    mapping (address => uint) public last;      // Owner => Last CDPId
    mapping (address => uint) public count;     // Owner => Amount of CDPs

    mapping (
        address => mapping (
            uint => mapping (
                address => uint
            )
        )
    ) public cdpCan;                            // Owner => CDPId => Allowed Addr => True/False

    mapping (
        address => mapping (
            address => uint
        )
    ) public urnCan;                            // Urn => Allowed Addr => True/False

    struct List {
        uint prev;
        uint next;
    }

    event NEWCDP119(address indexed usr, address indexed own, uint indexed cdp);	//inject NONSTANDARD NAMING

    modifier CDPALLOWED275(	//inject NONSTANDARD NAMING
        uint cdp
    ) {
        require(msg.sender == owns[cdp] || cdpCan[owns[cdp]][cdp][msg.sender] == 1, "cdp-not-allowed");
        _;
    }

    modifier URNALLOWED615(	//inject NONSTANDARD NAMING
        address urn
    ) {
        require(msg.sender == urn || urnCan[urn][msg.sender] == 1, "urn-not-allowed");
        _;
    }

    constructor(address vat_) public {
        vat = vat_;
    }

    function ADD152(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require((z = x + y) >= x);
    }

    function SUB613(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require((z = x - y) <= x);
    }

    function TOINT291(uint x) internal pure returns (int y) {	//inject NONSTANDARD NAMING
        y = int(x);
        require(y >= 0);
    }

    // Allow/disallow a usr address to manage the cdp.
    function CDPALLOW117(	//inject NONSTANDARD NAMING
        uint cdp,
        address usr,
        uint ok
    ) public CDPALLOWED275(cdp) {
        cdpCan[owns[cdp]][cdp][usr] = ok;
    }

    // Allow/disallow a usr address to quit to the the sender urn.
    function URNALLOW963(	//inject NONSTANDARD NAMING
        address usr,
        uint ok
    ) public {
        urnCan[msg.sender][usr] = ok;
    }

    // Open a new cdp for a given usr address.
    function OPEN788(	//inject NONSTANDARD NAMING
        bytes32 ilk,
        address usr
    ) public NOTE96 returns (uint) {
        require(usr != address(0), "usr-address-0");

        cdpi = ADD152(cdpi, 1);
        urns[cdpi] = address(new UrnHandler(vat));
        owns[cdpi] = usr;
        ilks[cdpi] = ilk;

        // Add new CDP to double linked list and pointers
        if (first[usr] == 0) {
            first[usr] = cdpi;
        }
        if (last[usr] != 0) {
            list[cdpi].prev = last[usr];
            list[last[usr]].next = cdpi;
        }
        last[usr] = cdpi;
        count[usr] = ADD152(count[usr], 1);

        emit NEWCDP119(msg.sender, usr, cdpi);
        return cdpi;
    }

    // Give the cdp ownership to a dst address.
    function GIVE491(	//inject NONSTANDARD NAMING
        uint cdp,
        address dst
    ) public NOTE96 CDPALLOWED275(cdp) {
        require(dst != address(0), "dst-address-0");
        require(dst != owns[cdp], "dst-already-owner");

        // Remove transferred CDP from double linked list of origin user and pointers
        if (list[cdp].prev != 0) {
            list[list[cdp].prev].next = list[cdp].next;         // Set the next pointer of the prev cdp (if exists) to the next of the transferred one
        }
        if (list[cdp].next != 0) {                              // If wasn't the last one
            list[list[cdp].next].prev = list[cdp].prev;         // Set the prev pointer of the next cdp to the prev of the transferred one
        } else {                                                // If was the last one
            last[owns[cdp]] = list[cdp].prev;                   // Update last pointer of the owner
        }
        if (first[owns[cdp]] == cdp) {                          // If was the first one
            first[owns[cdp]] = list[cdp].next;                  // Update first pointer of the owner
        }
        count[owns[cdp]] = SUB613(count[owns[cdp]], 1);

        // Transfer ownership
        owns[cdp] = dst;

        // Add transferred CDP to double linked list of destiny user and pointers
        list[cdp].prev = last[dst];
        list[cdp].next = 0;
        if (last[dst] != 0) {
            list[last[dst]].next = cdp;
        }
        if (first[dst] == 0) {
            first[dst] = cdp;
        }
        last[dst] = cdp;
        count[dst] = ADD152(count[dst], 1);
    }

    // Frob the cdp keeping the generated DAI or collateral freed in the cdp urn address.
    function FROB530(	//inject NONSTANDARD NAMING
        uint cdp,
        int dink,
        int dart
    ) public NOTE96 CDPALLOWED275(cdp) {
        address urn = urns[cdp];
        VatLike(vat).FROB530(
            ilks[cdp],
            urn,
            urn,
            urn,
            dink,
            dart
        );
    }

    // Transfer wad amount of cdp collateral from the cdp address to a dst address.
    function FLUX111(	//inject NONSTANDARD NAMING
        uint cdp,
        address dst,
        uint wad
    ) public NOTE96 CDPALLOWED275(cdp) {
        VatLike(vat).FLUX111(ilks[cdp], urns[cdp], dst, wad);
    }

    // Transfer wad amount of any type of collateral (ilk) from the cdp address to a dst address.
    // This function has the purpose to take away collateral from the system that doesn't correspond to the cdp but was sent there wrongly.
    function FLUX111(	//inject NONSTANDARD NAMING
        bytes32 ilk,
        uint cdp,
        address dst,
        uint wad
    ) public NOTE96 CDPALLOWED275(cdp) {
        VatLike(vat).FLUX111(ilk, urns[cdp], dst, wad);
    }

    // Transfer wad amount of DAI from the cdp address to a dst address.
    function MOVE24(	//inject NONSTANDARD NAMING
        uint cdp,
        address dst,
        uint rad
    ) public NOTE96 CDPALLOWED275(cdp) {
        VatLike(vat).MOVE24(urns[cdp], dst, rad);
    }

    // Quit the system, migrating the cdp (ink, art) to a different dst urn
    function QUIT635(	//inject NONSTANDARD NAMING
        uint cdp,
        address dst
    ) public NOTE96 CDPALLOWED275(cdp) URNALLOWED615(dst) {
        (uint ink, uint art) = VatLike(vat).URNS742(ilks[cdp], urns[cdp]);
        VatLike(vat).FORK185(
            ilks[cdp],
            urns[cdp],
            dst,
            TOINT291(ink),
            TOINT291(art)
        );
    }

    // Import a position from src urn to the urn owned by cdp
    function ENTER294(	//inject NONSTANDARD NAMING
        address src,
        uint cdp
    ) public NOTE96 URNALLOWED615(src) CDPALLOWED275(cdp) {
        (uint ink, uint art) = VatLike(vat).URNS742(ilks[cdp], src);
        VatLike(vat).FORK185(
            ilks[cdp],
            src,
            urns[cdp],
            TOINT291(ink),
            TOINT291(art)
        );
    }

    // Move a position from cdpSrc urn to the cdpDst urn
    function SHIFT262(	//inject NONSTANDARD NAMING
        uint cdpSrc,
        uint cdpDst
    ) public NOTE96 CDPALLOWED275(cdpSrc) CDPALLOWED275(cdpDst) {
        require(ilks[cdpSrc] == ilks[cdpDst], "non-matching-cdps");
        (uint ink, uint art) = VatLike(vat).URNS742(ilks[cdpSrc], urns[cdpSrc]);
        VatLike(vat).FORK185(
            ilks[cdpSrc],
            urns[cdpSrc],
            urns[cdpDst],
            TOINT291(ink),
            TOINT291(art)
        );
    }
}