/**
 *Submitted for verification at Etherscan.io on 2020-07-22
*/

/// flip.sol -- Collateral auction

// Copyright (C) 2018 Rain <rainbreak@riseup.net>
//
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

pragma solidity >=0.5.12;

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
            let mark := msize()                       // end of memory ensures zero
            mstore(0x40, add(mark, 288))              // update free memory pointer
            mstore(mark, 0x20)                        // bytes type data offset
            mstore(add(mark, 0x20), 224)              // bytes size (padded)
            calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
            log4(mark, 288,                           // calldata
                 shl(224, shr(224, calldataload(0))), // msg.sig
                 caller(),                            // msg.sender
                 calldataload(4),                     // arg1
                 calldataload(36)                     // arg2
                )
        }
    }
}

interface VatLike {
    function move(address,address,uint) external;
    function flux(bytes32,address,address,uint) external;
}

/*
   This thing lets you flip some gems for a given amount of dai.
   Once the given amount of dai is raised, gems are forgone instead.

 - `lot` gems in return for bid
 - `tab` total dai wanted
 - `bid` dai paid
 - `gal` receives dai income
 - `usr` receives gem forgone
 - `ttl` single bid lifetime
 - `beg` minimum bid increase
 - `end` max auction duration
*/

contract Flipper is LibNote {
    // --- Auth ---
    mapping (address => uint) internal wards;
    function rely(address usr) external note auth { wards[usr] = 1; }	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    function deny(address usr) external note auth { wards[usr] = 0; }	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    modifier auth {
        require(wards[msg.sender] == 1, "Flipper/not-authorized");
        _;
    }

    // --- Data ---
    struct Bid {
        uint256 bid;  // dai paid                 [rad]
        uint256 lot;  // gems in return for bid   [wad]
        address guy;  // high bidder
        uint48  tic;  // bid expiry time          [unix epoch time]
        uint48  end;  // auction expiry time      [unix epoch time]
        address usr;
        address gal;
        uint256 tab;  // total dai wanted    [rad]
    }

    mapping (uint => Bid) internal bids;

    VatLike internal   vat;
    bytes32 internal   ilk;

    uint256 constant ONE = 1.00E18;
    uint256 internal   beg = 1.05E18;  // 5% minimum bid increase
    uint48  internal   ttl = 3 hours;  // 3 hours bid duration         [seconds]
    uint48  internal   tau = 2 days;   // 2 days total auction length  [seconds]
    uint256 internal kicks = 0;

    // --- Events ---
    event Kick(
      uint256 id,
      uint256 lot,
      uint256 bid,
      uint256 tab,
      address indexed usr,
      address indexed gal
    );

    // --- Init ---
    constructor(address vat_, bytes32 ilk_) public {
        vat = VatLike(vat_);
        ilk = ilk_;
        wards[msg.sender] = 1;
    }

    // --- Math ---
    function add(uint48 x, uint48 y) internal pure returns (uint48 z) {
        require((z = x + y) >= x);
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    // --- Admin ---
    function file(bytes32 what, uint data) external note auth {
        if (what == "beg") beg = data;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        else if (what == "ttl") ttl = uint48(data);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        else if (what == "tau") tau = uint48(data);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        else revert("Flipper/file-unrecognized-param");
    }

    // --- Auction ---
    function kick(address usr, address gal, uint tab, uint lot, uint bid)
        public auth returns (uint id)
    {
        require(kicks < uint(-1), "Flipper/overflow");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        id = ++kicks;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        bids[id].bid = bid;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bids[id].lot = lot;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bids[id].guy = msg.sender;  // configurable??	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bids[id].end = add(uint48(now), tau);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bids[id].usr = usr;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bids[id].gal = gal;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bids[id].tab = tab;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        vat.flux(ilk, msg.sender, address(this), lot);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        emit Kick(id, lot, bid, tab, usr, gal);
    }
    function tick(uint id) external note {
        require(bids[id].end < now, "Flipper/not-finished");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(bids[id].tic == 0, "Flipper/bid-already-placed");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bids[id].end = add(uint48(now), tau);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    function tend(uint id, uint lot, uint bid) external note {
        require(bids[id].guy != address(0), "Flipper/guy-not-set");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(bids[id].tic > now || bids[id].tic == 0, "Flipper/already-finished-tic");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(bids[id].end > now, "Flipper/already-finished-end");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        require(lot == bids[id].lot, "Flipper/lot-not-matching");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(bid <= bids[id].tab, "Flipper/higher-than-tab");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(bid >  bids[id].bid, "Flipper/bid-not-higher");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(mul(bid, ONE) >= mul(beg, bids[id].bid) || bid == bids[id].tab, "Flipper/insufficient-increase");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        if (msg.sender != bids[id].guy) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            vat.move(msg.sender, bids[id].guy, bids[id].bid);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            bids[id].guy = msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        vat.move(msg.sender, bids[id].gal, bid - bids[id].bid);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        bids[id].bid = bid;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bids[id].tic = add(uint48(now), ttl);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    function dent(uint id, uint lot, uint bid) external note {
        require(bids[id].guy != address(0), "Flipper/guy-not-set");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(bids[id].tic > now || bids[id].tic == 0, "Flipper/already-finished-tic");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(bids[id].end > now, "Flipper/already-finished-end");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        require(bid == bids[id].bid, "Flipper/not-matching-bid");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(bid == bids[id].tab, "Flipper/tend-not-finished");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(lot < bids[id].lot, "Flipper/lot-not-lower");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(mul(beg, lot) <= mul(bids[id].lot, ONE), "Flipper/insufficient-decrease");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        if (msg.sender != bids[id].guy) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            vat.move(msg.sender, bids[id].guy, bid);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            bids[id].guy = msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        vat.flux(ilk, address(this), bids[id].usr, bids[id].lot - lot);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        bids[id].lot = lot;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bids[id].tic = add(uint48(now), ttl);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    function deal(uint id) external note {
        require(bids[id].tic != 0 && (bids[id].tic < now || bids[id].end < now), "Flipper/not-finished");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        vat.flux(ilk, address(this), bids[id].guy, bids[id].lot);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        delete bids[id];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function yank(uint id) external note auth {
        require(bids[id].guy != address(0), "Flipper/guy-not-set");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(bids[id].bid < bids[id].tab, "Flipper/already-dent-phase");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        vat.flux(ilk, address(this), msg.sender, bids[id].lot);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        vat.move(msg.sender, bids[id].guy, bids[id].bid);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        delete bids[id];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}