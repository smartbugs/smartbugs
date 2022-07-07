/**
 *Submitted for verification at Etherscan.io on 2020-02-20
*/

pragma solidity ^0.5.11;

contract RsaBounty {

    struct Challenge {
        bytes modulus;
        bool redeemed;
        uint bounty;
    }

    uint constant CLAIM_DELAY = 1 days;

    address owner;

    mapping(uint => Challenge) internal challenges;
    uint internal challenges_length;

    mapping(bytes32 => uint256) internal claims;

    constructor () public payable {
        owner = msg.sender;

        challenges[0] = Challenge({
        modulus: hex"bdbbd27309fc78576ef48a2ed1fd835f9a35c4b23ab4191d476fc54245a04c588af1c7b600c5009bcc064b58afa126aa49eca0c7dc02a92b1750b833172e85226e88290494fc11f1fd3e78e788e5",
        redeemed: false,
        bounty: 1 ether
        });

        challenges[1] = Challenge({
        modulus: hex"7e50b8b8b973dd6422b77048168d24729c96c1144b4982a7871598af00fd908d48541594d47bc80ae03db5ca666f8ceff7d36bafeff7701d0de71a79b552fac7a431928761a42d818697920a0c8274100fe3950fd2591c50888432c685ac2d5f",
        redeemed: false,
        bounty: 4 ether
        });

        challenges[2] = Challenge({
        modulus: hex"a8046dd12415b1ccf11d841a39a39287bf2c761c7779e8bfef7fa7886793ea326b9ecc7c4cb600688595e64b26ee45685919473bc09862f8783d24fea6433decc2500f724f0c26b0007f76af9cda8f9b3576acfa3206c3432f03358184259dbbd813032cfb21634d6df7957a1bf1676aeb90750d85f6715c351c595a14fe373b",
        redeemed: false,
        bounty: 8 ether
        });

        challenges[3] = Challenge({
        modulus: hex"7efce54e174bb141d000b4375659f45ac1e3e9ccc1afcde85cc98b7b6ce626457361e90d1d9fe0af72ba63f3b0d20af8084bd6f981584af1e9197288811e72afaf488a1360e4d5d6f9b08220e16dd05860bd571e3171eb10dcc60241bf6f64cf03ddfb0556aa9a61e9850874e442564c020cf283813f5215d36281748b766ffa8a3486cd70686b5590d499a1a72d9baa87c0dc223c8f5b71d18fd24888b2872f0530be8cde0f7be8f591848bc210f2966dcaab6853d09bfd550ebdcd244c394cc83ac19ec75bf8b82774719555483cc2e3fbac3201c1aa518d25fdb37d50e56f3515ad5e4609d252fa7ded3b5123c0abc8a0ce137ef9989843d1452b87ccca6b",
        redeemed: false,
        bounty: 16 ether
        });

        challenges_length = 4;
    }


    // Expmod for small operands
    function expmod(uint base, uint e, uint m) public view returns (uint o) {
        assembly {
            // Get free memory pointer
            let p := mload(0x40)
            // Store parameters for the Expmod (0x05) precompile
            mstore(p, 0x20)             // Length of Base
            mstore(add(p, 0x20), 0x20)  // Length of Exponent
            mstore(add(p, 0x40), 0x20)  // Length of Modulus
            mstore(add(p, 0x60), base)  // Base
            mstore(add(p, 0x80), e)     // Exponent
            mstore(add(p, 0xa0), m)     // Modulus

            // Call 0x05 (EXPMOD) precompile
            if iszero(staticcall(sub(gas, 2000), 0x05, p, 0xc0, p, 0x20)) {
                revert(0, 0)
            }
            o := mload(p)
        }
    }

    // Expmod for bignum operands (encoded as bytes, only base and modulus)
    function bignum_expmod(bytes memory base, uint e, bytes memory m) public view returns (bytes memory o) {
        assembly {
            // Get free memory pointer
            let p := mload(0x40)

            // Get base length in bytes
            let bl := mload(base)
            // Get modulus length in bytes
            let ml := mload(m)

            // Store parameters for the Expmod (0x05) precompile
            mstore(p, bl)               // Length of Base
            mstore(add(p, 0x20), 0x20)  // Length of Exponent
            mstore(add(p, 0x40), ml)    // Length of Modulus
            // Use Identity (0x04) precompile to memcpy the base
            if iszero(staticcall(10000, 0x04, add(base, 0x20), bl, add(p, 0x60), bl)) {
                revert(0, 0)
            }
            mstore(add(p, add(0x60, bl)), e) // Exponent
            // Use Identity (0x04) precompile to memcpy the modulus
            if iszero(staticcall(10000, 0x04, add(m, 0x20), ml, add(add(p, 0x80), bl), ml)) {
                revert(0, 0)
            }
            
            // Call 0x05 (EXPMOD) precompile
            if iszero(staticcall(sub(gas, 2000), 0x05, p, add(add(0x80, bl), ml), add(p, 0x20), ml)) {
                revert(0, 0)
            }

            // Update free memory pointer
            mstore(0x40, add(add(p, ml), 0x20))

            // Store correct bytelength at p. This means that with the output
            // of the Expmod precompile (which is stored as p + 0x20)
            // there is now a bytes array at location p
            mstore(p, ml)

            // Return p
            o := p
        }
    }

    uint constant miller_rabin_checks = 28;

    // Use the Miller-Rabin test to check whether n>3, odd is a prime
    function miller_rabin_test(uint n) public view returns (bool) {
        require(n > 3);
        require(n & 0x1 == 1);
        uint d = n - 1;
        uint r = 0;
        while(d & 0x1 == 0) {
            d /= 2;
            r += 1;
        }
        for(uint i = 0; i < miller_rabin_checks; i++) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            // pick a random integer a in the range [2, n 1 2]
            uint a = (uint256(sha256(abi.encodePacked(n, i))) % (n - 3)) + 2;
            uint x = expmod(a, d, n);
            if(x == 1 || x == n - 1) {
                continue;
            }
            bool check_passed = false;
            for(uint j = 1; j < r; j++) {
                x = mulmod(x, x, n);
                if(x == n - 1) {
                    check_passed = true;
                    break;
                }
            }
            if(!check_passed) {
                return false;
            }
        }
        return true;
    }

    // Need to submit a "claim" for a bounty 24 hrs before redeeming
    // This prevents front-running attacks
    function claim_bounty(bytes32 claim_hash) public {
        require(claims[claim_hash] == 0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        claims[claim_hash] = block.timestamp + CLAIM_DELAY;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function max(uint a, uint b) private pure returns (uint) {
        return a > b ? a : b;
    }

    function bignum_getdigit(bytes memory x, uint i) private pure returns (uint8) {
        if(i >= x.length) {
            return 0;
        } else {
            return uint8(x[x.length - i - 1]);
        }
    }

    // Add two bignums encoded as bytes (very inefficient byte by byte method)
    function bignum_add(bytes memory x, bytes memory y) public pure returns (bytes memory) {
        uint newlength = max(x.length, y.length) + 1;
        bytes memory r = new bytes(newlength);
        uint carry = 0;
        for(uint i = 0; i < newlength; i++) {
            uint8 a = bignum_getdigit(x, i);
            uint8 b = bignum_getdigit(y, i);
            uint sum = uint(a) + uint(b) + carry;
            r[r.length - i - 1] = byte(uint8(sum));
            carry = sum >> 8;
            require(carry < 2);
        }
        return r;
    }

    // Compares two bignums encoded as bytes (very inefficient byte by byte method)
    function bignum_cmp(bytes memory x, bytes memory y) public pure returns (int) {
        int maxdigit = int(max(x.length, y.length)) - 1;
        for(int i = maxdigit; i >= 0; i--) {
            uint8 a = bignum_getdigit(x, uint(i));
            uint8 b = bignum_getdigit(y, uint(i));
            if(a > b) {
                return 1;
            }
            if(b > a) {
                return -1;
            }
        }
        return 0;
    }
    
    // Mask used for hash to prime
    // Prime has to be the same as sha256(x) where mask is 1
    uint constant prime_mask = 0x7fff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_f000;

    function redeem_bounty(uint challenge_no, bytes memory x, bytes memory y, uint p) public {
        require(challenge_no < challenges_length);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(!challenges[challenge_no].redeemed);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        // Check claim has been made for this challenge
        bytes32 claim_hash = sha256(abi.encodePacked(challenge_no, x, y, p, bytes32(uint256(msg.sender))));
        require(claims[claim_hash] > 0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(claims[claim_hash] < block.timestamp);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        // Check p is correct result for hash-to-prime
        require(p & prime_mask == uint(sha256(x)) & prime_mask);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(p > (1 << 255));
        require(miller_rabin_test(p));

        // Check 1 < x < m - 1
        require(bignum_cmp(x, hex"01") == 1);
        require(bignum_cmp(bignum_add(x, hex"01"), challenges[challenge_no].modulus) == -1);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        // Check y^p = x (mod m)
        bytes memory expmod_result = bignum_expmod(y, p, challenges[challenge_no].modulus);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(sha256(abi.encodePacked(expmod_result)) == sha256(abi.encodePacked(x)));
        
        challenges[challenge_no].redeemed = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        msg.sender.transfer(challenges[challenge_no].bounty);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    
    function terminate_contract() public {
        require(msg.sender == owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        selfdestruct(msg.sender);
    }

}