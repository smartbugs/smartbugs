                                                                 

                                                                 

pragma solidity ^0.5.5;

library strings {
    struct slice {
        uint _len;
        uint _ptr;
    }

    function MEMCPY184(uint dest, uint src, uint len) private pure {	//inject NONSTANDARD NAMING
        // Copy word-length chunks while possible
        for(; len >= 32; len -= 32) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }

        // Copy remaining bytes
        uint mask = 256 ** (32 - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }

                                                                                                                                                                                                 
    function TOSLICE667(string memory self) internal pure returns (slice memory) {	//inject NONSTANDARD NAMING
        uint ptr;
        assembly {
            ptr := add(self, 0x20)
        }
        return slice(bytes(self).length, ptr);
    }

                                                                                                                                                                                             
    function LEN420(bytes32 self) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint ret;
        if (self == 0)
            return 0;
        if (uint(self) & 0xffffffffffffffffffffffffffffffff == 0) {
            ret += 16;
            self = bytes32(uint(self) / 0x100000000000000000000000000000000);
        }
        if (uint(self) & 0xffffffffffffffff == 0) {
            ret += 8;
            self = bytes32(uint(self) / 0x10000000000000000);
        }
        if (uint(self) & 0xffffffff == 0) {
            ret += 4;
            self = bytes32(uint(self) / 0x100000000);
        }
        if (uint(self) & 0xffff == 0) {
            ret += 2;
            self = bytes32(uint(self) / 0x10000);
        }
        if (uint(self) & 0xff == 0) {
            ret += 1;
        }
        return 32 - ret;
    }

                                                                                                                                                                                                                                                                                                           
    function TOSLICEB32242(bytes32 self) internal pure returns (slice memory ret) {	//inject NONSTANDARD NAMING
        // Allocate space for `self` in memory, copy it there, and point ret at it
        assembly {
            let ptr := mload(0x40)
            mstore(0x40, add(ptr, 0x20))
            mstore(ptr, self)
            mstore(add(ret, 0x20), ptr)
        }
        ret._len = LEN420(self);
    }

                                                                                                                                                                                                  
    function COPY737(slice memory self) internal pure returns (slice memory) {	//inject NONSTANDARD NAMING
        return slice(self._len, self._ptr);
    }

                                                                                                                                                                     
    function TOSTRING824(slice memory self) internal pure returns (string memory) {	//inject NONSTANDARD NAMING
        string memory ret = new string(self._len);
        uint retptr;
        assembly { retptr := add(ret, 32) }

        MEMCPY184(retptr, self._ptr, self._len);
        return ret;
    }

                                                                                                                                                                                                                                                                                                                                                                                                
    function LEN420(slice memory self) internal pure returns (uint l) {	//inject NONSTANDARD NAMING
        // Starting at ptr-31 means the LSB will be the byte we care about
        uint ptr = self._ptr - 31;
        uint end = ptr + self._len;
        for (l = 0; ptr < end; l++) {
            uint8 b;
            assembly { b := and(mload(ptr), 0xFF) }
            if (b < 0x80) {
                ptr += 1;
            } else if(b < 0xE0) {
                ptr += 2;
            } else if(b < 0xF0) {
                ptr += 3;
            } else if(b < 0xF8) {
                ptr += 4;
            } else if(b < 0xFC) {
                ptr += 5;
            } else {
                ptr += 6;
            }
        }
    }

                                                                                                                                                                                          
    function EMPTY246(slice memory self) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        return self._len == 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function COMPARE76(slice memory self, slice memory other) internal pure returns (int) {	//inject NONSTANDARD NAMING
        uint shortest = self._len;
        if (other._len < self._len)
            shortest = other._len;

        uint selfptr = self._ptr;
        uint otherptr = other._ptr;
        for (uint idx = 0; idx < shortest; idx += 32) {
            uint a;
            uint b;
            assembly {
                a := mload(selfptr)
                b := mload(otherptr)
            }
            if (a != b) {
                // Mask out irrelevant bytes and check again
                uint256 mask = uint256(-1); // 0xffff...
                if(shortest < 32) {
                  mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
                }
                uint256 diff = (a & mask) - (b & mask);
                if (diff != 0)
                    return int(diff);
            }
            selfptr += 32;
            otherptr += 32;
        }
        return int(self._len) - int(other._len);
    }

                                                                                                                                                                                                                                             
    function EQUALS848(slice memory self, slice memory other) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        return COMPARE76(self, other) == 0;
    }

                                                                                                                                                                                                                                                                                              
    function NEXTRUNE884(slice memory self, slice memory rune) internal pure returns (slice memory) {	//inject NONSTANDARD NAMING
        rune._ptr = self._ptr;

        if (self._len == 0) {
            rune._len = 0;
            return rune;
        }

        uint l;
        uint b;
        // Load the first byte of the rune into the LSBs of b
        assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
        if (b < 0x80) {
            l = 1;
        } else if(b < 0xE0) {
            l = 2;
        } else if(b < 0xF0) {
            l = 3;
        } else {
            l = 4;
        }

        // Check for truncated codepoints
        if (l > self._len) {
            rune._len = self._len;
            self._ptr += self._len;
            self._len = 0;
            return rune;
        }

        self._ptr += l;
        self._len -= l;
        rune._len = l;
        return rune;
    }

                                                                                                                                                                                                                                         
    function NEXTRUNE884(slice memory self) internal pure returns (slice memory ret) {	//inject NONSTANDARD NAMING
        NEXTRUNE884(self, ret);
    }

                                                                                                                                                                                             
    function ORD412(slice memory self) internal pure returns (uint ret) {	//inject NONSTANDARD NAMING
        if (self._len == 0) {
            return 0;
        }

        uint word;
        uint length;
        uint divisor = 2 ** 248;

        // Load the rune into the MSBs of b
        assembly { word:= mload(mload(add(self, 32))) }
        uint b = word / divisor;
        if (b < 0x80) {
            ret = b;
            length = 1;
        } else if(b < 0xE0) {
            ret = b & 0x1F;
            length = 2;
        } else if(b < 0xF0) {
            ret = b & 0x0F;
            length = 3;
        } else {
            ret = b & 0x07;
            length = 4;
        }

        // Check for truncated codepoints
        if (length > self._len) {
            return 0;
        }

        for (uint i = 1; i < length; i++) {
            divisor = divisor / 256;
            b = (word / divisor) & 0xFF;
            if (b & 0xC0 != 0x80) {
                // Invalid UTF-8 sequence
                return 0;
            }
            ret = (ret * 64) | (b & 0x3F);
        }

        return ret;
    }

                                                                                                                                                
    function KECCAK7(slice memory self) internal pure returns (bytes32 ret) {	//inject NONSTANDARD NAMING
        assembly {
            ret := keccak256(mload(add(self, 32)), mload(self))
        }
    }

                                                                                                                                                                                                                                                  
    function STARTSWITH158(slice memory self, slice memory needle) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        if (self._len < needle._len) {
            return false;
        }

        if (self._ptr == needle._ptr) {
            return true;
        }

        bool equal;
        assembly {
            let length := mload(needle)
            let selfptr := mload(add(self, 0x20))
            let needleptr := mload(add(needle, 0x20))
            equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
        }
        return equal;
    }

                                                                                                                                                                                                                                                                         
    function BEYOND684(slice memory self, slice memory needle) internal pure returns (slice memory) {	//inject NONSTANDARD NAMING
        if (self._len < needle._len) {
            return self;
        }

        bool equal = true;
        if (self._ptr != needle._ptr) {
            assembly {
                let length := mload(needle)
                let selfptr := mload(add(self, 0x20))
                let needleptr := mload(add(needle, 0x20))
                equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
            }
        }

        if (equal) {
            self._len -= needle._len;
            self._ptr += needle._len;
        }

        return self;
    }

                                                                                                                                                                                                                                                   
    function ENDSWITH884(slice memory self, slice memory needle) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        if (self._len < needle._len) {
            return false;
        }

        uint selfptr = self._ptr + self._len - needle._len;

        if (selfptr == needle._ptr) {
            return true;
        }

        bool equal;
        assembly {
            let length := mload(needle)
            let needleptr := mload(add(needle, 0x20))
            equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
        }

        return equal;
    }

                                                                                                                                                                                                                                                                 
    function UNTIL972(slice memory self, slice memory needle) internal pure returns (slice memory) {	//inject NONSTANDARD NAMING
        if (self._len < needle._len) {
            return self;
        }

        uint selfptr = self._ptr + self._len - needle._len;
        bool equal = true;
        if (selfptr != needle._ptr) {
            assembly {
                let length := mload(needle)
                let needleptr := mload(add(needle, 0x20))
                equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
            }
        }

        if (equal) {
            self._len -= needle._len;
        }

        return self;
    }

    // Returns the memory address of the first byte of the first occurrence of
    // `needle` in `self`, or the first byte after `self` if not found.
    function FINDPTR600(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {	//inject NONSTANDARD NAMING
        uint ptr = selfptr;
        uint idx;

        if (needlelen <= selflen) {
            if (needlelen <= 32) {
                bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));

                bytes32 needledata;
                assembly { needledata := and(mload(needleptr), mask) }

                uint end = selfptr + selflen - needlelen;
                bytes32 ptrdata;
                assembly { ptrdata := and(mload(ptr), mask) }

                while (ptrdata != needledata) {
                    if (ptr >= end)
                        return selfptr + selflen;
                    ptr++;
                    assembly { ptrdata := and(mload(ptr), mask) }
                }
                return ptr;
            } else {
                // For long needles, use hashing
                bytes32 hash;
                assembly { hash := keccak256(needleptr, needlelen) }

                for (idx = 0; idx <= selflen - needlelen; idx++) {
                    bytes32 testHash;
                    assembly { testHash := keccak256(ptr, needlelen) }
                    if (hash == testHash)
                        return ptr;
                    ptr += 1;
                }
            }
        }
        return selfptr + selflen;
    }

    // Returns the memory address of the first byte after the last occurrence of
    // `needle` in `self`, or the address of `self` if not found.
    function RFINDPTR373(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {	//inject NONSTANDARD NAMING
        uint ptr;

        if (needlelen <= selflen) {
            if (needlelen <= 32) {
                bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));

                bytes32 needledata;
                assembly { needledata := and(mload(needleptr), mask) }

                ptr = selfptr + selflen - needlelen;
                bytes32 ptrdata;
                assembly { ptrdata := and(mload(ptr), mask) }

                while (ptrdata != needledata) {
                    if (ptr <= selfptr)
                        return selfptr;
                    ptr--;
                    assembly { ptrdata := and(mload(ptr), mask) }
                }
                return ptr + needlelen;
            } else {
                // For long needles, use hashing
                bytes32 hash;
                assembly { hash := keccak256(needleptr, needlelen) }
                ptr = selfptr + (selflen - needlelen);
                while (ptr >= selfptr) {
                    bytes32 testHash;
                    assembly { testHash := keccak256(ptr, needlelen) }
                    if (hash == testHash)
                        return ptr + needlelen;
                    ptr -= 1;
                }
            }
        }
        return selfptr;
    }

                                                                                                                                                                                                                                                                                                                                         
    function FIND686(slice memory self, slice memory needle) internal pure returns (slice memory) {	//inject NONSTANDARD NAMING
        uint ptr = FINDPTR600(self._len, self._ptr, needle._len, needle._ptr);
        self._len -= ptr - self._ptr;
        self._ptr = ptr;
        return self;
    }

                                                                                                                                                                                                                                                                                                                                                                
    function RFIND966(slice memory self, slice memory needle) internal pure returns (slice memory) {	//inject NONSTANDARD NAMING
        uint ptr = RFINDPTR373(self._len, self._ptr, needle._len, needle._ptr);
        self._len = ptr - self._ptr;
        return self;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function SPLIT752(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {	//inject NONSTANDARD NAMING
        uint ptr = FINDPTR600(self._len, self._ptr, needle._len, needle._ptr);
        token._ptr = self._ptr;
        token._len = ptr - self._ptr;
        if (ptr == self._ptr + self._len) {
            // Not found
            self._len = 0;
        } else {
            self._len -= token._len + needle._len;
            self._ptr = ptr + needle._len;
        }
        return token;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function SPLIT752(slice memory self, slice memory needle) internal pure returns (slice memory token) {	//inject NONSTANDARD NAMING
        SPLIT752(self, needle, token);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function RSPLIT98(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {	//inject NONSTANDARD NAMING
        uint ptr = RFINDPTR373(self._len, self._ptr, needle._len, needle._ptr);
        token._ptr = ptr;
        token._len = self._len - (ptr - self._ptr);
        if (ptr == self._ptr) {
            // Not found
            self._len = 0;
        } else {
            self._len -= token._len + needle._len;
        }
        return token;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function RSPLIT98(slice memory self, slice memory needle) internal pure returns (slice memory token) {	//inject NONSTANDARD NAMING
        RSPLIT98(self, needle, token);
    }

                                                                                                                                                                                                                                                                      
    function COUNT317(slice memory self, slice memory needle) internal pure returns (uint cnt) {	//inject NONSTANDARD NAMING
        uint ptr = FINDPTR600(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
        while (ptr <= self._ptr + self._len) {
            cnt++;
            ptr = FINDPTR600(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
        }
    }

                                                                                                                                                                                                                                        
    function CONTAINS145(slice memory self, slice memory needle) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        return RFINDPTR373(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
    }

                                                                                                                                                                                                                                                                                        
    function CONCAT154(slice memory self, slice memory other) internal pure returns (string memory) {	//inject NONSTANDARD NAMING
        string memory ret = new string(self._len + other._len);
        uint retptr;
        assembly { retptr := add(ret, 32) }
        MEMCPY184(retptr, self._ptr, self._len);
        MEMCPY184(retptr + self._len, other._ptr, other._len);
        return ret;
    }

                                                                                                                                                                                                                                                                                                                                         
    function JOIN989(slice memory self, slice[] memory parts) internal pure returns (string memory) {	//inject NONSTANDARD NAMING
        if (parts.length == 0)
            return "";

        uint length = self._len * (parts.length - 1);
        for(uint i = 0; i < parts.length; i++)
            length += parts[i]._len;

        string memory ret = new string(length);
        uint retptr;
        assembly { retptr := add(ret, 32) }

        for(uint i = 0; i < parts.length; i++) {
            MEMCPY184(retptr, parts[i]._ptr, parts[i]._len);
            retptr += parts[i]._len;
            if (i < parts.length - 1) {
                MEMCPY184(retptr, self._ptr, self._len);
                retptr += self._len;
            }
        }

        return ret;
    }
}

                                                                                                                                                                                                                                                                                       
interface IERC165 {
                                                                                                                                                                                                                                                                                                                                                        
    function SUPPORTSINTERFACE706(bytes4 interfaceId) external view returns (bool);	//inject NONSTANDARD NAMING
}


                                                                   
contract IERC721 is IERC165 {
    event TRANSFER150(address indexed from, address indexed to, uint256 indexed tokenId);	//inject NONSTANDARD NAMING
    event APPROVAL578(address indexed owner, address indexed approved, uint256 indexed tokenId);	//inject NONSTANDARD NAMING
    event APPROVALFORALL29(address indexed owner, address indexed operator, bool approved);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF194(address owner) public view returns (uint256 balance);	//inject NONSTANDARD NAMING

                                                                                
    function OWNEROF501(uint256 tokenId) public view returns (address owner);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                       
    function SAFETRANSFERFROM763(address from, address to, uint256 tokenId) public;	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                                                              
    function TRANSFERFROM196(address from, address to, uint256 tokenId) public;	//inject NONSTANDARD NAMING
    function APPROVE594(address to, uint256 tokenId) public;	//inject NONSTANDARD NAMING
    function GETAPPROVED68(uint256 tokenId) public view returns (address operator);	//inject NONSTANDARD NAMING

    function SETAPPROVALFORALL944(address operator, bool _approved) public;	//inject NONSTANDARD NAMING
    function ISAPPROVEDFORALL189(address owner, address operator) public view returns (bool);	//inject NONSTANDARD NAMING


    function SAFETRANSFERFROM763(address from, address to, uint256 tokenId, bytes memory data) public;	//inject NONSTANDARD NAMING
}


                                                                                                                                     
contract IERC721Metadata is IERC721 {
    function NAME560() external view returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL235() external view returns (string memory);	//inject NONSTANDARD NAMING
    function TOKENURI443(uint256 tokenId) external view returns (string memory);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER492() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA8() internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

                                                                                                                                        
contract IERC721Enumerable is IERC721 {
    function TOTALSUPPLY60() public view returns (uint256);	//inject NONSTANDARD NAMING
    function TOKENOFOWNERBYINDEX536(address owner, uint256 index) public view returns (uint256 tokenId);	//inject NONSTANDARD NAMING

    function TOKENBYINDEX294(uint256 index) public view returns (uint256);	//inject NONSTANDARD NAMING
}

                                                                                                                                                        
contract IERC721Receiver {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function ONERC721RECEIVED434(address operator, address from, uint256 tokenId, bytes memory data)	//inject NONSTANDARD NAMING
    public returns (bytes4);
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD556(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB290(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB290(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                             
    function SUB290(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL948(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV752(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV752(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function DIV752(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD555(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD555(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function MOD555(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT48(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

                                                                                                                                                                                                                                                                                                                          
    function TOPAYABLE256(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
library Counters {
    using SafeMath for uint256;

    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function CURRENT546(Counter storage counter) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return counter._value;
    }

    function INCREMENT933(Counter storage counter) internal {	//inject NONSTANDARD NAMING
        // The {SafeMath} overflow check can be skipped here, see the comment at the top
        counter._value += 1;
    }

    function DECREMENT749(Counter storage counter) internal {	//inject NONSTANDARD NAMING
        counter._value = counter._value.SUB290(1);
    }
}

                                                                                                                                                                           
contract ERC165 is IERC165 {
                                                                                  
    bytes4 private constant _interface_id_erc165217 = 0x01ffc9a7;	//inject NONSTANDARD NAMING

                                                                                      
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () internal {
        // Derived contracts need only register support for their own interfaces,
        // we register support for ERC165 itself here
        _REGISTERINTERFACE617(_interface_id_erc165217);
    }

                                                                                                                                               
    function SUPPORTSINTERFACE706(bytes4 interfaceId) external view returns (bool) {	//inject NONSTANDARD NAMING
        return _supportedInterfaces[interfaceId];
    }

                                                                                                                                                                                                                                                                                                                                                                                                   
    function _REGISTERINTERFACE617(bytes4 interfaceId) internal {	//inject NONSTANDARD NAMING
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}

                                                                                                                            
contract ERC721 is Context, ERC165, IERC721 {
    using SafeMath for uint256;
    using Address for address;
    using Counters for Counters.Counter;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _erc721_received995 = 0x150b7a02;	//inject NONSTANDARD NAMING

    // Mapping from token ID to owner
    mapping (uint256 => address) private _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => Counters.Counter) private _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    bytes4 private constant _interface_id_erc721781 = 0x80ac58cd;	//inject NONSTANDARD NAMING

    constructor () public {
        // register the supported interfaces to conform to ERC721 via ERC165
        _REGISTERINTERFACE617(_interface_id_erc721781);
    }

                                                                                                                                                                                                     
    function BALANCEOF194(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC721: balance query for the zero address");

        return _ownedTokensCount[owner].CURRENT546();
    }

                                                                                                                                                                                                                    
    function OWNEROF501(uint256 tokenId) public view returns (address) {	//inject NONSTANDARD NAMING
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");

        return owner;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                              
    function APPROVE594(address to, uint256 tokenId) public {	//inject NONSTANDARD NAMING
        address owner = OWNEROF501(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(_MSGSENDER492() == owner || ISAPPROVEDFORALL189(owner, _MSGSENDER492()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _tokenApprovals[tokenId] = to;
        emit APPROVAL578(owner, to, tokenId);
    }

                                                                                                                                                                                                                                                                                      
    function GETAPPROVED68(uint256 tokenId) public view returns (address) {	//inject NONSTANDARD NAMING
        require(_EXISTS310(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

                                                                                                                                                                                                                                                                                              
    function SETAPPROVALFORALL944(address to, bool approved) public {	//inject NONSTANDARD NAMING
        require(to != _MSGSENDER492(), "ERC721: approve to caller");

        _operatorApprovals[_MSGSENDER492()][to] = approved;
        emit APPROVALFORALL29(_MSGSENDER492(), to, approved);
    }

                                                                                                                                                                                                                                                                                                                           
    function ISAPPROVEDFORALL189(address owner, address operator) public view returns (bool) {	//inject NONSTANDARD NAMING
        return _operatorApprovals[owner][operator];
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function TRANSFERFROM196(address from, address to, uint256 tokenId) public {	//inject NONSTANDARD NAMING
        //solhint-disable-next-line max-line-length
        require(_ISAPPROVEDOROWNER717(_MSGSENDER492(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _TRANSFERFROM267(from, to, tokenId);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function SAFETRANSFERFROM763(address from, address to, uint256 tokenId) public {	//inject NONSTANDARD NAMING
        SAFETRANSFERFROM763(from, to, tokenId, "");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function SAFETRANSFERFROM763(address from, address to, uint256 tokenId, bytes memory _data) public {	//inject NONSTANDARD NAMING
        require(_ISAPPROVEDOROWNER717(_MSGSENDER492(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _SAFETRANSFERFROM629(from, to, tokenId, _data);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function _SAFETRANSFERFROM629(address from, address to, uint256 tokenId, bytes memory _data) internal {	//inject NONSTANDARD NAMING
        _TRANSFERFROM267(from, to, tokenId);
        require(_CHECKONERC721RECEIVED542(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

                                                                                                                                                                                            
    function _EXISTS310(uint256 tokenId) internal view returns (bool) {	//inject NONSTANDARD NAMING
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

                                                                                                                                                                                                                                                                                                                                                                  
    function _ISAPPROVEDOROWNER717(address spender, uint256 tokenId) internal view returns (bool) {	//inject NONSTANDARD NAMING
        require(_EXISTS310(tokenId), "ERC721: operator query for nonexistent token");
        address owner = OWNEROF501(tokenId);
        return (spender == owner || GETAPPROVED68(tokenId) == spender || ISAPPROVEDFORALL189(owner, spender));
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function _SAFEMINT616(address to, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        _SAFEMINT616(to, tokenId, "");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function _SAFEMINT616(address to, uint256 tokenId, bytes memory _data) internal {	//inject NONSTANDARD NAMING
        _MINT975(to, tokenId);
        require(_CHECKONERC721RECEIVED542(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

                                                                                                                                                                                                                                              
    function _MINT975(address to, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_EXISTS310(tokenId), "ERC721: token already minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].INCREMENT933();

        emit TRANSFER150(address(0), to, tokenId);
    }

                                                                                                                                                                                                                                                                     
    function _BURN381(address owner, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        require(OWNEROF501(tokenId) == owner, "ERC721: burn of token that is not own");

        _CLEARAPPROVAL18(tokenId);

        _ownedTokensCount[owner].DECREMENT749();
        _tokenOwner[tokenId] = address(0);

        emit TRANSFER150(owner, address(0), tokenId);
    }

                                                                                                                                                                              
    function _BURN381(uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        _BURN381(OWNEROF501(tokenId), tokenId);
    }

                                                                                                                                                                                                                                                                                                                                                                                  
    function _TRANSFERFROM267(address from, address to, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        require(OWNEROF501(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _CLEARAPPROVAL18(tokenId);

        _ownedTokensCount[from].DECREMENT749();
        _ownedTokensCount[to].INCREMENT933();

        _tokenOwner[tokenId] = to;

        emit TRANSFER150(from, to, tokenId);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function _CHECKONERC721RECEIVED542(address from, address to, uint256 tokenId, bytes memory _data)	//inject NONSTANDARD NAMING
        internal returns (bool)
    {
        if (!to.ISCONTRACT48()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).ONERC721RECEIVED434(_MSGSENDER492(), from, tokenId, _data);
        return (retval == _erc721_received995);
    }

                                                                                                                                                           
    function _CLEARAPPROVAL18(uint256 tokenId) private {	//inject NONSTANDARD NAMING
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }
}

                                                                                                                                         
contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
    // Mapping from owner to list of owned token IDs
    mapping(address => uint256[]) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

                                                                                                                                                                                                                                                                                                         
    bytes4 private constant _interface_id_erc721_enumerable707 = 0x780e9d63;	//inject NONSTANDARD NAMING

                                                 
    constructor () public {
        // register the supported interface to conform to ERC721Enumerable via ERC165
        _REGISTERINTERFACE617(_interface_id_erc721_enumerable707);
    }

                                                                                                                                                                                                                                                                                                                                                                               
    function TOKENOFOWNERBYINDEX536(address owner, uint256 index) public view returns (uint256) {	//inject NONSTANDARD NAMING
        require(index < BALANCEOF194(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }

                                                                                                                                                  
    function TOTALSUPPLY60() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allTokens.length;
    }

                                                                                                                                                                                                                                                                                                                                           
    function TOKENBYINDEX294(uint256 index) public view returns (uint256) {	//inject NONSTANDARD NAMING
        require(index < TOTALSUPPLY60(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
    }

                                                                                                                                                                                                                                                                                                                                                                                
    function _TRANSFERFROM267(address from, address to, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        super._TRANSFERFROM267(from, to, tokenId);

        _REMOVETOKENFROMOWNERENUMERATION42(from, tokenId);

        _ADDTOKENTOOWNERENUMERATION485(to, tokenId);
    }

                                                                                                                                                                                                                                                          
    function _MINT975(address to, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        super._MINT975(to, tokenId);

        _ADDTOKENTOOWNERENUMERATION485(to, tokenId);

        _ADDTOKENTOALLTOKENSENUMERATION66(tokenId);
    }

                                                                                                                                                                                                                                                                            
    function _BURN381(address owner, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        super._BURN381(owner, tokenId);

        _REMOVETOKENFROMOWNERENUMERATION42(owner, tokenId);
        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
        _ownedTokensIndex[tokenId] = 0;

        _REMOVETOKENFROMALLTOKENSENUMERATION970(tokenId);
    }

                                                                                                                                                                                                      
    function _TOKENSOFOWNER469(address owner) internal view returns (uint256[] storage) {	//inject NONSTANDARD NAMING
        return _ownedTokens[owner];
    }

                                                                                                                                                                                                                                                                                               
    function _ADDTOKENTOOWNERENUMERATION485(address to, uint256 tokenId) private {	//inject NONSTANDARD NAMING
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

                                                                                                                                                                                            
    function _ADDTOKENTOALLTOKENSENUMERATION66(uint256 tokenId) private {	//inject NONSTANDARD NAMING
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function _REMOVETOKENFROMOWNERENUMERATION42(address from, uint256 tokenId) private {	//inject NONSTANDARD NAMING
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _ownedTokens[from].length.SUB290(1);
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        _ownedTokens[from].length--;

        // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
        // lastTokenId, or just over the end of the array if the token was the last one).
    }

                                                                                                                                                                                                                                                                                         
    function _REMOVETOKENFROMALLTOKENSENUMERATION970(uint256 tokenId) private {	//inject NONSTANDARD NAMING
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length.SUB290(1);
        uint256 tokenIndex = _allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        _allTokens.length--;
        _allTokensIndex[tokenId] = 0;
    }
}

                                                                                                                                                                                                                                                                                                                                                                        
contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED55(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        address msgSender = _MSGSENDER492();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED55(address(0), msgSender);
    }

                                                                     
    function OWNER824() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER845() {	//inject NONSTANDARD NAMING
        require(ISOWNER804(), "Ownable: caller is not the owner");
        _;
    }

                                                                            
    function ISOWNER804() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _MSGSENDER492() == _owner;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP585() public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED55(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP274(address newOwner) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP356(newOwner);
    }

                                                                                              
    function _TRANSFEROWNERSHIP356(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED55(_owner, newOwner);
        _owner = newOwner;
    }
}

                                                                                                                                                                                                                                                                                                                         
contract NoMintERC721 is Context, ERC165, IERC721 {
    using SafeMath for uint256;
    using Address for address;
    using Counters for Counters.Counter;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _erc721_received995 = 0x150b7a02;	//inject NONSTANDARD NAMING

    // Mapping from token ID to owner
    mapping (uint256 => address) private _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => Counters.Counter) private _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    bytes4 private constant _interface_id_erc721781 = 0x80ac58cd;	//inject NONSTANDARD NAMING

    constructor () public {
        // register the supported interfaces to conform to ERC721 via ERC165
        _REGISTERINTERFACE617(_interface_id_erc721781);
    }

                                                                                                                                                                                                     
    function BALANCEOF194(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC721: balance query for the zero address");

        return _ownedTokensCount[owner].CURRENT546();
    }

                                                                                                                                                                                                                    
    function OWNEROF501(uint256 tokenId) public view returns (address) {	//inject NONSTANDARD NAMING
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");

        return owner;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                              
    function APPROVE594(address to, uint256 tokenId) public {	//inject NONSTANDARD NAMING
        address owner = OWNEROF501(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(_MSGSENDER492() == owner || ISAPPROVEDFORALL189(owner, _MSGSENDER492()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _tokenApprovals[tokenId] = to;
        emit APPROVAL578(owner, to, tokenId);
    }

                                                                                                                                                                                                                                                                                      
    function GETAPPROVED68(uint256 tokenId) public view returns (address) {	//inject NONSTANDARD NAMING
        require(_EXISTS310(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

                                                                                                                                                                                                                                                                                              
    function SETAPPROVALFORALL944(address to, bool approved) public {	//inject NONSTANDARD NAMING
        require(to != _MSGSENDER492(), "ERC721: approve to caller");

        _operatorApprovals[_MSGSENDER492()][to] = approved;
        emit APPROVALFORALL29(_MSGSENDER492(), to, approved);
    }

                                                                                                                                                                                                                                                                                                                           
    function ISAPPROVEDFORALL189(address owner, address operator) public view returns (bool) {	//inject NONSTANDARD NAMING
        return _operatorApprovals[owner][operator];
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function TRANSFERFROM196(address from, address to, uint256 tokenId) public {	//inject NONSTANDARD NAMING
        //solhint-disable-next-line max-line-length
        require(_ISAPPROVEDOROWNER717(_MSGSENDER492(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _TRANSFERFROM267(from, to, tokenId);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function SAFETRANSFERFROM763(address from, address to, uint256 tokenId) public {	//inject NONSTANDARD NAMING
        SAFETRANSFERFROM763(from, to, tokenId, "");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function SAFETRANSFERFROM763(address from, address to, uint256 tokenId, bytes memory _data) public {	//inject NONSTANDARD NAMING
        require(_ISAPPROVEDOROWNER717(_MSGSENDER492(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _SAFETRANSFERFROM629(from, to, tokenId, _data);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function _SAFETRANSFERFROM629(address from, address to, uint256 tokenId, bytes memory _data) internal {	//inject NONSTANDARD NAMING
        _TRANSFERFROM267(from, to, tokenId);
        require(_CHECKONERC721RECEIVED542(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

                                                                                                                                                                                            
    function _EXISTS310(uint256 tokenId) internal view returns (bool) {	//inject NONSTANDARD NAMING
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

                                                                                                                                                                                                                                                                                                                                                                  
    function _ISAPPROVEDOROWNER717(address spender, uint256 tokenId) internal view returns (bool) {	//inject NONSTANDARD NAMING
        require(_EXISTS310(tokenId), "ERC721: operator query for nonexistent token");
        address owner = OWNEROF501(tokenId);
        return (spender == owner || GETAPPROVED68(tokenId) == spender || ISAPPROVEDFORALL189(owner, spender));
    }

                                                                                                                                                                                                                                              
    function _ADDTOKENTO735(address to, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_EXISTS310(tokenId), "ERC721: token already minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].INCREMENT933();
    }

                                                                                                                                                                                                                                                                     
    function _BURN381(address owner, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        require(OWNEROF501(tokenId) == owner, "ERC721: burn of token that is not own");

        _CLEARAPPROVAL18(tokenId);

        _ownedTokensCount[owner].DECREMENT749();
        _tokenOwner[tokenId] = address(0);

        emit TRANSFER150(owner, address(0), tokenId);
    }

                                                                                                                                                                              
    function _BURN381(uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        _BURN381(OWNEROF501(tokenId), tokenId);
    }

                                                                                                                                                                                                                                                                                                                                                                                  
    function _TRANSFERFROM267(address from, address to, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        require(OWNEROF501(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _CLEARAPPROVAL18(tokenId);

        _ownedTokensCount[from].DECREMENT749();
        _ownedTokensCount[to].INCREMENT933();

        _tokenOwner[tokenId] = to;

        emit TRANSFER150(from, to, tokenId);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function _CHECKONERC721RECEIVED542(address from, address to, uint256 tokenId, bytes memory _data)	//inject NONSTANDARD NAMING
        internal returns (bool)
    {
        if (!to.ISCONTRACT48()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).ONERC721RECEIVED434(_MSGSENDER492(), from, tokenId, _data);
        return (retval == _erc721_received995);
    }

                                                                                                                                                           
    function _CLEARAPPROVAL18(uint256 tokenId) private {	//inject NONSTANDARD NAMING
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }
}

                                                                                                                                                                                            
contract NoMintERC721Enumerable is Context, ERC165, NoMintERC721, IERC721Enumerable {
    // Mapping from owner to list of owned token IDs
    mapping(address => uint256[]) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

                                                                                                                                                                                                                                                                                                         
    bytes4 private constant _interface_id_erc721_enumerable707 = 0x780e9d63;	//inject NONSTANDARD NAMING

                                                 
    constructor () public {
        // register the supported interface to conform to ERC721Enumerable via ERC165
        _REGISTERINTERFACE617(_interface_id_erc721_enumerable707);
    }

                                                                                                                                                                                                                                                                                                                                                                               
    function TOKENOFOWNERBYINDEX536(address owner, uint256 index) public view returns (uint256) {	//inject NONSTANDARD NAMING
        require(index < BALANCEOF194(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }

                                                                                                                                                  
    function TOTALSUPPLY60() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allTokens.length;
    }

                                                                                                                                                                                                                                                                                                                                           
    function TOKENBYINDEX294(uint256 index) public view returns (uint256) {	//inject NONSTANDARD NAMING
        require(index < TOTALSUPPLY60(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
    }

                                                                                                                                                                                                                                                                                                                                                                                
    function _TRANSFERFROM267(address from, address to, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        super._TRANSFERFROM267(from, to, tokenId);

        _REMOVETOKENFROMOWNERENUMERATION42(from, tokenId);

        _ADDTOKENTOOWNERENUMERATION485(to, tokenId);
    }

                                                                                                                                                                                                                                                          
    function _ADDTOKENTO735(address to, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        super._ADDTOKENTO735(to, tokenId);

        _ADDTOKENTOOWNERENUMERATION485(to, tokenId);

        _ADDTOKENTOALLTOKENSENUMERATION66(tokenId);
    }

                                                                                                                                                                                                                                                                            
    function _BURN381(address owner, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        super._BURN381(owner, tokenId);

        _REMOVETOKENFROMOWNERENUMERATION42(owner, tokenId);
        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
        _ownedTokensIndex[tokenId] = 0;

        _REMOVETOKENFROMALLTOKENSENUMERATION970(tokenId);
    }

                                                                                                                                                                                                      
    function _TOKENSOFOWNER469(address owner) internal view returns (uint256[] storage) {	//inject NONSTANDARD NAMING
        return _ownedTokens[owner];
    }

                                                                                                                                                                                                                                                                                               
    function _ADDTOKENTOOWNERENUMERATION485(address to, uint256 tokenId) private {	//inject NONSTANDARD NAMING
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

                                                                                                                                                                                            
    function _ADDTOKENTOALLTOKENSENUMERATION66(uint256 tokenId) private {	//inject NONSTANDARD NAMING
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function _REMOVETOKENFROMOWNERENUMERATION42(address from, uint256 tokenId) private {	//inject NONSTANDARD NAMING
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _ownedTokens[from].length.SUB290(1);
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        _ownedTokens[from].length--;

        // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
        // lastTokenId, or just over the end of the array if the token was the last one).
    }

                                                                                                                                                                                                                                                                                         
    function _REMOVETOKENFROMALLTOKENSENUMERATION970(uint256 tokenId) private {	//inject NONSTANDARD NAMING
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length.SUB290(1);
        uint256 tokenIndex = _allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        _allTokens.length--;
        _allTokensIndex[tokenId] = 0;
    }
}

                                                                                                                                                                                                                                                                                                                         
contract OveridableERC721Metadata is Context, ERC165, NoMintERC721, IERC721Metadata {
    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

                                                                                                                                                                                                                                                                  
    bytes4 private constant _interface_id_erc721_metadata259 = 0x5b5e139f;	//inject NONSTANDARD NAMING

                                                
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;

        // register the supported interfaces to conform to ERC721 via ERC165
        _REGISTERINTERFACE617(_interface_id_erc721_metadata259);
    }

                                                                                                  
    function NAME560() external view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                                                                      
    function SYMBOL235() external view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                                                                                                                                                 
    function TOKENURI443(uint256 tokenId) public view returns (string memory) {	//inject NONSTANDARD NAMING
        require(_EXISTS310(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

                                                                                                                                                                                                                                        
    function _SETTOKENURI639(uint256 tokenId, string memory uri) internal {	//inject NONSTANDARD NAMING
        require(_EXISTS310(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = uri;
    }

                                                                                                                                                                                                                                                                                              
    function _BURN381(address owner, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        super._BURN381(owner, tokenId);

        // Clear metadata (if any)
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}

                                                                                                                                                                                                                                       
contract GunToken is NoMintERC721, NoMintERC721Enumerable, OveridableERC721Metadata, Ownable {
    using strings for *;
    
    address internal factory;
    
    uint16 public constant maxallocation33 = 4000;	//inject NONSTANDARD NAMING
    uint256 public lastAllocation = 0;
    
    event BATCHTRANSFER76(address indexed from, address indexed to, uint256 indexed batchIndex);	//inject NONSTANDARD NAMING
    
    struct Batch {
        address owner;
        uint16 size;
        uint8 category;
        uint256 startId;
        uint256 startTokenId;
    }
    
    Batch[] public allBatches;
    mapping(address => uint256) unactivatedBalance;
    mapping(uint256 => bool) isActivated;
    mapping(uint256 => bool) public outOfBatch;
    
    //Used for enumeration
    mapping(address => Batch[]) public batchesOwned;
    //Batch index to owner batch index
    mapping(uint256 => uint256) public ownedBatchIndex;
    
    mapping(uint8 => uint256) internal totalGunsMintedByCategory;
    uint256 internal _totalSupply;

    modifier ONLYFACTORY168 {	//inject NONSTANDARD NAMING
        require(msg.sender == factory, "Not authorized");
        _;
    }

    constructor(address factoryAddress) public OveridableERC721Metadata("WarRiders Gun", "WRG") {
        factory = factoryAddress;
    }
    
    function CATEGORYTYPETOID957(uint8 category, uint256 categoryId) public view returns (uint256) {	//inject NONSTANDARD NAMING
        for (uint i = 0; i < allBatches.length; i++) {
            Batch memory a = allBatches[i];
            if (a.category != category)
                continue;
            
            uint256 endId = a.startId + a.size;
            if (categoryId >= a.startId && categoryId < endId) {
                uint256 dif = categoryId - a.startId;
                
                return a.startTokenId + dif;
            }
        }
        
        revert();
    }
    
    function FALLBACKCOUNT353(address __owner) public view returns (uint256) { 	//inject NONSTANDARD NAMING
        
    }

    function FALLBACKINDEX7(address __owner, uint256 index) public view returns (uint256) {	//inject NONSTANDARD NAMING
        
    }
    
    function MIGRATE859(uint256 count) public ONLYOWNER845 returns (uint256) {	//inject NONSTANDARD NAMING
        //Empty for interface
    }
    
    function MIGRATESINGLE765() public ONLYOWNER845 returns (uint256) {	//inject NONSTANDARD NAMING
        //Empty for interface
    }
    
    function RECOVERBATCH2175(uint256 index, uint256 tokenStart, uint256 tokenEnd) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        
    }
    
    function MIGRATEBATCH628(uint256 index) public ONLYOWNER845 returns (uint256) {	//inject NONSTANDARD NAMING
        
    }
    
    function RECOVERBATCH1434(uint256 index) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        
    }
    
                                                                                                                                                                                                                                                                                                                                                                               
    function TOKENOFOWNERBYINDEX536(address owner, uint256 index) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return TOKENOFOWNER723(owner)[index];
    }
    
    function GETBATCHCOUNT927(address owner) public view returns(uint256) {	//inject NONSTANDARD NAMING
        return batchesOwned[owner].length;
    }
    
    function UPDATEGUNFACTORY282(address _factory) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        
    }
    
    function GETTOKENSINBATCH347(address owner, uint256 index) public view returns (uint256[] memory) {	//inject NONSTANDARD NAMING
        Batch memory a = batchesOwned[owner][index];
        uint256[] memory result = new uint256[](a.size);
        
        uint256 pos = 0;
        uint end = a.startTokenId + a.size;
        for (uint i = a.startTokenId; i < end; i++) {
            if (isActivated[i] && super.OWNEROF501(i) != owner) {
                continue;
            }
            
            result[pos] = i;
            pos++;
        }
        
        require(pos > 0);
        
        uint256 subAmount = a.size - pos;
        
        assembly { mstore(result, sub(mload(result), subAmount)) }
        
        return result;
    }
    
    function TOKENBYINDEX294(uint256 index) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return ALLTOKENS936()[index];
    }
    
    function ALLTOKENS936() public view returns (uint256[] memory) {	//inject NONSTANDARD NAMING
        uint256[] memory result = new uint256[](TOTALSUPPLY60());
        
        uint pos = 0;
        for (uint i = 0; i < allBatches.length; i++) {
            Batch memory a = allBatches[i];
            uint end = a.startTokenId + a.size;
            for (uint j = a.startTokenId; j < end; j++) {
                result[pos] = j;
                pos++;
            }
        }
        
        return result;
    }
    
    function TOKENOFOWNER723(address owner) public view returns (uint256[] memory) {	//inject NONSTANDARD NAMING
        uint256[] memory result = new uint256[](BALANCEOF194(owner));
        
        uint pos = 0;
        for (uint i = 0; i < batchesOwned[owner].length; i++) {
            Batch memory a = batchesOwned[owner][i];
            uint end = a.startTokenId + a.size;
            for (uint j = a.startTokenId; j < end; j++) {
                if (isActivated[j] && super.OWNEROF501(j) != owner) {
                    continue;
                }
                
                result[pos] = j;
                pos++;
            }
        }
        
        uint256[] memory fallbackOwned = _TOKENSOFOWNER469(owner);
        for (uint i = 0; i < fallbackOwned.length; i++) {
            result[pos] = fallbackOwned[i];
            pos++;
        }
        
        return result;
    }
    
    function BALANCEOF194(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC721: balance query for the zero address");

        return super.BALANCEOF194(owner) + unactivatedBalance[owner];
    }
    
     function OWNEROF501(uint256 tokenId) public view returns (address) {	//inject NONSTANDARD NAMING
         require(EXISTS127(tokenId), "Token doesn't exist!");
         
         if (isActivated[tokenId]) {
             return super.OWNEROF501(tokenId);
         }
         uint256 index = GETBATCHINDEX786(tokenId);
         require(index < allBatches.length, "Token batch doesn't exist");
         Batch memory a = allBatches[index];
         require(tokenId < a.startTokenId + a.size);
         return a.owner;
     }
    
    function EXISTS127(uint256 _tokenId) public view returns (bool) {	//inject NONSTANDARD NAMING
        if (isActivated[_tokenId]) {
            return super._EXISTS310(_tokenId);
        } else {
            uint256 index = GETBATCHINDEX786(_tokenId);
            if (index < allBatches.length) {
                Batch memory a = allBatches[index];
                uint end = a.startTokenId + a.size;
                
                return _tokenId < end;
            }
            return false;
        }
    }
    
    function TOTALSUPPLY60() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }
    
    function CLAIMALLOCATION316(address to, uint16 size, uint8 category) public ONLYFACTORY168 returns (uint) {	//inject NONSTANDARD NAMING
        require(size < maxallocation33, "Size must be smaller than maxAllocation");
        
        allBatches.push(Batch({
            owner: to,
            size: size,
            category: category,
            startId: totalGunsMintedByCategory[category],
            startTokenId: lastAllocation
        }));
        
        uint end = lastAllocation + size;
        for (uint i = lastAllocation; i < end; i++) {
            emit TRANSFER150(address(0), to, i);
        }
        
        lastAllocation += maxallocation33;
        
        unactivatedBalance[to] += size;
        totalGunsMintedByCategory[category] += size;
        
        _ADDBATCHTOOWNER461(to, allBatches[allBatches.length - 1]);
        
        _totalSupply += size;
        return lastAllocation;
    }
    
    function TRANSFERFROM196(address from, address to, uint256 tokenId) public {	//inject NONSTANDARD NAMING
        if (!isActivated[tokenId]) {
            ACTIVATE8(tokenId);
        }
        super.TRANSFERFROM196(from, to, tokenId);
    }
    
    function ACTIVATE8(uint256 tokenId) public {	//inject NONSTANDARD NAMING
        require(!isActivated[tokenId], "Token already activated");
        uint256 index = GETBATCHINDEX786(tokenId);
        require(index < allBatches.length, "Token batch doesn't exist");
        Batch memory a = allBatches[index];
        require(tokenId < a.startTokenId + a.size);
        isActivated[tokenId] = true;
        ADDTOKENTO758(a.owner, tokenId);
        unactivatedBalance[a.owner]--;
    }
    
    function GETBATCHINDEX786(uint256 tokenId) public pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 index = (tokenId / maxallocation33);
        
        return index;
    }
    
    function CATEGORYFORTOKEN792(uint256 tokenId) public view returns (uint8) {	//inject NONSTANDARD NAMING
        uint256 index = GETBATCHINDEX786(tokenId);
        require(index < allBatches.length, "Token batch doesn't exist");
        
        Batch memory a = allBatches[index];
        
        return a.category;
    }
    
    function CATEGORYIDFORTOKEN949(uint256 tokenId) public view returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 index = GETBATCHINDEX786(tokenId);
        require(index < allBatches.length, "Token batch doesn't exist");
        
        Batch memory a = allBatches[index];
        
        uint256 categoryId = (tokenId % maxallocation33) + a.startId;
        
        return categoryId;
    }
    
    function UINTTOSTRING328(uint v) internal pure returns (string memory) {	//inject NONSTANDARD NAMING
        if (v == 0) {
            return "0";
        }
        uint j = v;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (v != 0) {
            bstr[k--] = byte(uint8(48 + v % 10));
            v /= 10;
        }
        
        return string(bstr);
    }
    
    function TOKENURI443(uint256 tokenId) public view returns (string memory) {	//inject NONSTANDARD NAMING
        require(EXISTS127(tokenId), "Token doesn't exist!");
        if (isActivated[tokenId]) {
            return super.TOKENURI443(tokenId);
        } else {
            //Predict the token URI
            uint8 category = CATEGORYFORTOKEN792(tokenId);
            uint256 _categoryId = CATEGORYIDFORTOKEN949(tokenId);
            
            string memory id = UINTTOSTRING328(category).TOSLICE667().CONCAT154("/".TOSLICE667()).TOSLICE667().CONCAT154(UINTTOSTRING328(_categoryId).TOSLICE667().CONCAT154(".json".TOSLICE667()).TOSLICE667());
            string memory _base = "https://vault.warriders.com/guns/";
            
            //Final URL: https://vault.warriders.com/guns/<category>/<category_id>.json
            string memory _metadata = _base.TOSLICE667().CONCAT154(id.TOSLICE667());
            
            return _metadata;
        }
    }
    
    function ADDTOKENTO758(address _to, uint256 _tokenId) internal {	//inject NONSTANDARD NAMING
        //Predict the token URI
        uint8 category = CATEGORYFORTOKEN792(_tokenId);
        uint256 _categoryId = CATEGORYIDFORTOKEN949(_tokenId);
            
        string memory id = UINTTOSTRING328(category).TOSLICE667().CONCAT154("/".TOSLICE667()).TOSLICE667().CONCAT154(UINTTOSTRING328(_categoryId).TOSLICE667().CONCAT154(".json".TOSLICE667()).TOSLICE667());
        string memory _base = "https://vault.warriders.com/guns/";
            
        //Final URL: https://vault.warriders.com/guns/<category>/<category_id>.json
        string memory _metadata = _base.TOSLICE667().CONCAT154(id.TOSLICE667());
        
        super._ADDTOKENTO735(_to, _tokenId);
        super._SETTOKENURI639(_tokenId, _metadata);
    }
    
    function CEIL247(uint a, uint m) internal pure returns (uint ) {	//inject NONSTANDARD NAMING
        return ((a + m - 1) / m) * m;
    }
    
    function _REMOVEBATCHFROMOWNER136(address from, Batch memory batch) private {	//inject NONSTANDARD NAMING
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).
        
        uint256 globalIndex = GETBATCHINDEX786(batch.startTokenId);

        uint256 lastBatchIndex = batchesOwned[from].length.SUB290(1);
        uint256 batchIndex = ownedBatchIndex[globalIndex];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (batchIndex != lastBatchIndex) {
            Batch memory lastBatch = batchesOwned[from][lastBatchIndex];
            uint256 lastGlobalIndex = GETBATCHINDEX786(lastBatch.startTokenId);

            batchesOwned[from][batchIndex] = lastBatch; // Move the last batch to the slot of the to-delete batch
            ownedBatchIndex[lastGlobalIndex] = batchIndex; // Update the moved batch's index
        }

        // This also deletes the contents at the last position of the array
        batchesOwned[from].length--;

        // Note that ownedBatchIndex[batch] hasn't been cleared: it still points to the old slot (now occupied by
        // lastBatch, or just over the end of the array if the batch was the last one).
    }
    
    function _ADDBATCHTOOWNER461(address to, Batch memory batch) private {	//inject NONSTANDARD NAMING
        uint256 globalIndex = GETBATCHINDEX786(batch.startTokenId);
        
        ownedBatchIndex[globalIndex] = batchesOwned[to].length;
        batchesOwned[to].push(batch);
    }
    
    function BATCHTRANSFER268(uint256 batchIndex, address to) public {	//inject NONSTANDARD NAMING
        Batch storage a = allBatches[batchIndex];
        
        address previousOwner = a.owner;
        
        require(a.owner == msg.sender);
        
        _REMOVEBATCHFROMOWNER136(previousOwner, a);
        
        a.owner = to;
        
        _ADDBATCHTOOWNER461(to, a);
        
        emit BATCHTRANSFER76(previousOwner, to, batchIndex);
        
        //Now to need to emit a bunch of transfer events
        uint end = a.startTokenId + a.size;
        uint256 unActivated = 0;
        for (uint i = a.startTokenId; i < end; i++) {
            if (isActivated[i]) {
                if (OWNEROF501(i) != previousOwner)
                    continue; //The previous owner didn't own this token, don't emit an event
            } else {
                unActivated++;
            }
            emit TRANSFER150(previousOwner, to, i);
        }
        
        unactivatedBalance[to] += unActivated;
        unactivatedBalance[previousOwner] -= unActivated;
    }
}

contract ApproveAndCallFallBack {
    function RECEIVEAPPROVAL438(address from, uint256 tokens, address token, bytes memory data) public payable returns (bool);	//inject NONSTANDARD NAMING
}

                                                                                                                               
contract ERC20Basic {
  function TOTALSUPPLY60() public view returns (uint256);	//inject NONSTANDARD NAMING
  function BALANCEOF194(address who) public view returns (uint256);	//inject NONSTANDARD NAMING
  function TRANSFER702(address to, uint256 value) public returns (bool);	//inject NONSTANDARD NAMING
  event TRANSFER150(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
}

contract ERC20 is ERC20Basic {
  function ALLOWANCE798(address owner, address spender)	//inject NONSTANDARD NAMING
    public view returns (uint256);

  function TRANSFERFROM196(address from, address to, uint256 value)	//inject NONSTANDARD NAMING
    public returns (bool);

  function APPROVE594(address spender, uint256 value) public returns (bool);	//inject NONSTANDARD NAMING
  event APPROVAL578(	//inject NONSTANDARD NAMING
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

contract BurnableToken is ERC20 {
  event BURN595(address indexed burner, uint256 value);	//inject NONSTANDARD NAMING
  function BURN840(uint256 _value) public;	//inject NONSTANDARD NAMING
}

contract StandardBurnableToken is BurnableToken {
  function BURNFROM813(address _from, uint256 _value) public;	//inject NONSTANDARD NAMING
}

interface BZNFeed {
                                                      
    function CONVERT77(uint256 usd) external view returns (uint256);	//inject NONSTANDARD NAMING
}

contract SimpleBZNFeed is BZNFeed, Ownable {
    
    uint256 private conversion;
    
    function UPDATECONVERSION150(uint256 conversionRate) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        conversion = conversionRate;
    }
    
    function CONVERT77(uint256 usd) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return usd * conversion;
    }
}

interface IDSValue {
   
    function PEEK123() external view returns (bytes32, bool);	//inject NONSTANDARD NAMING
    function READ988() external view returns (bytes32);	//inject NONSTANDARD NAMING
    function POKE435(bytes32 wut) external;	//inject NONSTANDARD NAMING
    function VOID212() external;	//inject NONSTANDARD NAMING
}

library BytesLib {
    function CONCAT154(	//inject NONSTANDARD NAMING
        bytes memory _preBytes,
        bytes memory _postBytes
    )
        internal
        pure
        returns (bytes memory)
    {
        bytes memory tempBytes;

        assembly {
            // Get a location of some free memory and store it in tempBytes as
            // Solidity does for memory variables.
            tempBytes := mload(0x40)

            // Store the length of the first bytes array at the beginning of
            // the memory for tempBytes.
            let length := mload(_preBytes)
            mstore(tempBytes, length)

            // Maintain a memory counter for the current write location in the
            // temp bytes array by adding the 32 bytes for the array length to
            // the starting location.
            let mc := add(tempBytes, 0x20)
            // Stop copying when the memory counter reaches the length of the
            // first bytes array.
            let end := add(mc, length)

            for {
                // Initialize a copy counter to the start of the _preBytes data,
                // 32 bytes into its memory.
                let cc := add(_preBytes, 0x20)
            } lt(mc, end) {
                // Increase both counters by 32 bytes each iteration.
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } {
                // Write the _preBytes data into the tempBytes memory 32 bytes
                // at a time.
                mstore(mc, mload(cc))
            }

            // Add the length of _postBytes to the current length of tempBytes
            // and store it as the new length in the first 32 bytes of the
            // tempBytes memory.
            length := mload(_postBytes)
            mstore(tempBytes, add(length, mload(tempBytes)))

            // Move the memory counter back from a multiple of 0x20 to the
            // actual end of the _preBytes data.
            mc := end
            // Stop copying when the memory counter reaches the new combined
            // length of the arrays.
            end := add(mc, length)

            for {
                let cc := add(_postBytes, 0x20)
            } lt(mc, end) {
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } {
                mstore(mc, mload(cc))
            }

            // Update the free-memory pointer by padding our last write location
            // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
            // next 32 byte block, then round down to the nearest multiple of
            // 32. If the sum of the length of the two arrays is zero then add 
            // one before rounding down to leave a blank 32 bytes (the length block with 0).
            mstore(0x40, and(
              add(add(end, iszero(add(length, mload(_preBytes)))), 31),
              not(31) // Round down to the nearest 32 bytes.
            ))
        }

        return tempBytes;
    }

    function CONCATSTORAGE572(bytes storage _preBytes, bytes memory _postBytes) internal {	//inject NONSTANDARD NAMING
        assembly {
            // Read the first 32 bytes of _preBytes storage, which is the length
            // of the array. (We don't need to use the offset into the slot
            // because arrays use the entire slot.)
            let fslot := sload(_preBytes_slot)
            // Arrays of 31 bytes or less have an even value in their slot,
            // while longer arrays have an odd value. The actual length is
            // the slot divided by two for odd values, and the lowest order
            // byte divided by two for even values.
            // If the slot is even, bitwise and the slot with 255 and divide by
            // two to get the length. If the slot is odd, bitwise and the slot
            // with -1 and divide by two.
            let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
            let mlength := mload(_postBytes)
            let newlength := add(slength, mlength)
            // slength can contain both the length and contents of the array
            // if length < 32 bytes so let's prepare for that
            // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
            switch add(lt(slength, 32), lt(newlength, 32))
            case 2 {
                // Since the new array still fits in the slot, we just need to
                // update the contents of the slot.
                // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
                sstore(
                    _preBytes_slot,
                    // all the modifications to the slot are inside this
                    // next block
                    add(
                        // we can just add to the slot contents because the
                        // bytes we want to change are the LSBs
                        fslot,
                        add(
                            mul(
                                div(
                                    // load the bytes from memory
                                    mload(add(_postBytes, 0x20)),
                                    // zero all bytes to the right
                                    exp(0x100, sub(32, mlength))
                                ),
                                // and now shift left the number of bytes to
                                // leave space for the length in the slot
                                exp(0x100, sub(32, newlength))
                            ),
                            // increase length by the double of the memory
                            // bytes length
                            mul(mlength, 2)
                        )
                    )
                )
            }
            case 1 {
                // The stored value fits in the slot, but the combined value
                // will exceed it.
                // get the keccak hash to get the contents of the array
                mstore(0x0, _preBytes_slot)
                let sc := add(keccak256(0x0, 0x20), div(slength, 32))

                // save new length
                sstore(_preBytes_slot, add(mul(newlength, 2), 1))

                // The contents of the _postBytes array start 32 bytes into
                // the structure. Our first read should obtain the `submod`
                // bytes that can fit into the unused space in the last word
                // of the stored array. To get this, we read 32 bytes starting
                // from `submod`, so the data we read overlaps with the array
                // contents by `submod` bytes. Masking the lowest-order
                // `submod` bytes allows us to add that value directly to the
                // stored value.

                let submod := sub(32, slength)
                let mc := add(_postBytes, submod)
                let end := add(_postBytes, mlength)
                let mask := sub(exp(0x100, submod), 1)

                sstore(
                    sc,
                    add(
                        and(
                            fslot,
                            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
                        ),
                        and(mload(mc), mask)
                    )
                )

                for {
                    mc := add(mc, 0x20)
                    sc := add(sc, 1)
                } lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } {
                    sstore(sc, mload(mc))
                }

                mask := exp(0x100, sub(mc, end))

                sstore(sc, mul(div(mload(mc), mask), mask))
            }
            default {
                // get the keccak hash to get the contents of the array
                mstore(0x0, _preBytes_slot)
                // Start copying to the last used word of the stored array.
                let sc := add(keccak256(0x0, 0x20), div(slength, 32))

                // save new length
                sstore(_preBytes_slot, add(mul(newlength, 2), 1))

                // Copy over the first `submod` bytes of the new data as in
                // case 1 above.
                let slengthmod := mod(slength, 32)
                let mlengthmod := mod(mlength, 32)
                let submod := sub(32, slengthmod)
                let mc := add(_postBytes, submod)
                let end := add(_postBytes, mlength)
                let mask := sub(exp(0x100, submod), 1)

                sstore(sc, add(sload(sc), and(mload(mc), mask)))
                
                for { 
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } {
                    sstore(sc, mload(mc))
                }

                mask := exp(0x100, sub(mc, end))

                sstore(sc, mul(div(mload(mc), mask), mask))
            }
        }
    }

    function SLICE625(	//inject NONSTANDARD NAMING
        bytes memory _bytes,
        uint _start,
        uint _length
    )
        internal
        pure
        returns (bytes memory)
    {
        require(_bytes.length >= (_start + _length));

        bytes memory tempBytes;

        assembly {
            switch iszero(_length)
            case 0 {
                // Get a location of some free memory and store it in tempBytes as
                // Solidity does for memory variables.
                tempBytes := mload(0x40)

                // The first word of the slice result is potentially a partial
                // word read from the original array. To read it, we calculate
                // the length of that partial word and start copying that many
                // bytes into the array. The first word we copy will start with
                // data we don't care about, but the last `lengthmod` bytes will
                // land at the beginning of the contents of the new array. When
                // we're done copying, we overwrite the full first word with
                // the actual length of the slice.
                let lengthmod := and(_length, 31)

                // The multiplication in the next line is necessary
                // because when slicing multiples of 32 bytes (lengthmod == 0)
                // the following copy loop was copying the origin's length
                // and then ending prematurely not copying everything it should.
                let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
                let end := add(mc, _length)

                for {
                    // The multiplication in the next line has the same exact purpose
                    // as the one above.
                    let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
                } lt(mc, end) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    mstore(mc, mload(cc))
                }

                mstore(tempBytes, _length)

                //update free-memory pointer
                //allocating the array padded to 32 bytes like the compiler does now
                mstore(0x40, and(add(mc, 31), not(31)))
            }
            //if we want a zero-length slice let's just return a zero-length array
            default {
                tempBytes := mload(0x40)

                mstore(0x40, add(tempBytes, 0x20))
            }
        }

        return tempBytes;
    }

    function TOADDRESS210(bytes memory _bytes, uint _start) internal  pure returns (address) {	//inject NONSTANDARD NAMING
        require(_bytes.length >= (_start + 20));
        address tempAddress;

        assembly {
            tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
        }

        return tempAddress;
    }

    function TOUINT8119(bytes memory _bytes, uint _start) internal  pure returns (uint8) {	//inject NONSTANDARD NAMING
        require(_bytes.length >= (_start + 1));
        uint8 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1), _start))
        }

        return tempUint;
    }

    function TOUINT16152(bytes memory _bytes, uint _start) internal  pure returns (uint16) {	//inject NONSTANDARD NAMING
        require(_bytes.length >= (_start + 2));
        uint16 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x2), _start))
        }

        return tempUint;
    }

    function TOUINT32393(bytes memory _bytes, uint _start) internal  pure returns (uint32) {	//inject NONSTANDARD NAMING
        require(_bytes.length >= (_start + 4));
        uint32 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x4), _start))
        }

        return tempUint;
    }

    function TOUINT64646(bytes memory _bytes, uint _start) internal  pure returns (uint64) {	//inject NONSTANDARD NAMING
        require(_bytes.length >= (_start + 8));
        uint64 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x8), _start))
        }

        return tempUint;
    }

    function TOUINT96427(bytes memory _bytes, uint _start) internal  pure returns (uint96) {	//inject NONSTANDARD NAMING
        require(_bytes.length >= (_start + 12));
        uint96 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0xc), _start))
        }

        return tempUint;
    }

    function TOUINT12878(bytes memory _bytes, uint _start) internal  pure returns (uint128) {	//inject NONSTANDARD NAMING
        require(_bytes.length >= (_start + 16));
        uint128 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x10), _start))
        }

        return tempUint;
    }

    function TOUINT505(bytes memory _bytes, uint _start) internal  pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(_bytes.length >= (_start + 32));
        uint256 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x20), _start))
        }

        return tempUint;
    }

    function TOBYTES32154(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {	//inject NONSTANDARD NAMING
        require(_bytes.length >= (_start + 32));
        bytes32 tempBytes32;

        assembly {
            tempBytes32 := mload(add(add(_bytes, 0x20), _start))
        }

        return tempBytes32;
    }

    function EQUAL770(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        bool success = true;

        assembly {
            let length := mload(_preBytes)

            // if lengths don't match the arrays are not equal
            switch eq(length, mload(_postBytes))
            case 1 {
                // cb is a circuit breaker in the for loop since there's
                //  no said feature for inline assembly loops
                // cb = 1 - don't breaker
                // cb = 0 - break
                let cb := 1

                let mc := add(_preBytes, 0x20)
                let end := add(mc, length)

                for {
                    let cc := add(_postBytes, 0x20)
                // the next line is the loop condition:
                // while(uint(mc < end) + cb == 2)
                } eq(add(lt(mc, end), cb), 2) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    // if any of these checks fails then arrays are not equal
                    if iszero(eq(mload(mc), mload(cc))) {
                        // unsuccess:
                        success := 0
                        cb := 0
                    }
                }
            }
            default {
                // unsuccess:
                success := 0
            }
        }

        return success;
    }

    function EQUALSTORAGE902(	//inject NONSTANDARD NAMING
        bytes storage _preBytes,
        bytes memory _postBytes
    )
        internal
        view
        returns (bool)
    {
        bool success = true;

        assembly {
            // we know _preBytes_offset is 0
            let fslot := sload(_preBytes_slot)
            // Decode the length of the stored array like in concatStorage().
            let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
            let mlength := mload(_postBytes)

            // if lengths don't match the arrays are not equal
            switch eq(slength, mlength)
            case 1 {
                // slength can contain both the length and contents of the array
                // if length < 32 bytes so let's prepare for that
                // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
                if iszero(iszero(slength)) {
                    switch lt(slength, 32)
                    case 1 {
                        // blank the last byte which is the length
                        fslot := mul(div(fslot, 0x100), 0x100)

                        if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
                            // unsuccess:
                            success := 0
                        }
                    }
                    default {
                        // cb is a circuit breaker in the for loop since there's
                        //  no said feature for inline assembly loops
                        // cb = 1 - don't breaker
                        // cb = 0 - break
                        let cb := 1

                        // get the keccak hash to get the contents of the array
                        mstore(0x0, _preBytes_slot)
                        let sc := keccak256(0x0, 0x20)

                        let mc := add(_postBytes, 0x20)
                        let end := add(mc, mlength)

                        // the next line is the loop condition:
                        // while(uint(mc < end) + cb == 2)
                        for {} eq(add(lt(mc, end), cb), 2) {
                            sc := add(sc, 1)
                            mc := add(mc, 0x20)
                        } {
                            if iszero(eq(sload(sc), mload(mc))) {
                                // unsuccess:
                                success := 0
                                cb := 0
                            }
                        }
                    }
                }
            }
            default {
                // unsuccess:
                success := 0
            }
        }

        return success;
    }
}

contract GunPreOrder is Ownable, ApproveAndCallFallBack {
    using BytesLib for bytes;
    using SafeMath for uint256;
    
    //Event for when a bulk buy order has been placed
    event CONSUMERBULKBUY355(uint8 category, uint256 quanity, address reserver);	//inject NONSTANDARD NAMING
    //Event for when a gun has been bought
    event GUNSBOUGHT917(uint256 gunId, address owner, uint8 category);	//inject NONSTANDARD NAMING
    //Event for when ether is taken out of this contract
    event WITHDRAWAL910(uint256 amount);	//inject NONSTANDARD NAMING

    //Default referal commision percent
    uint256 public constant commission_percent82 = 5;	//inject NONSTANDARD NAMING
    
    //Whether category is open
    mapping(uint8 => bool) public categoryExists;
    mapping(uint8 => bool) public categoryOpen;
    mapping(uint8 => bool) public categoryKilled;
    
    //The additional referal commision percent for any given referal address (default is 0)
    mapping(address => uint256) internal commissionRate;
    
    //How many guns in a given category an address has reserved
    mapping(uint8 => mapping(address => uint256)) public categoryReserveAmount;
    
    //Opensea buy address
    address internal constant opensea308 = 0x5b3256965e7C3cF26E11FCAf296DfC8807C01073;	//inject NONSTANDARD NAMING

    //The percent increase and percent base for a given category
    mapping(uint8 => uint256) public categoryPercentIncrease;
    mapping(uint8 => uint256) public categoryPercentBase;

    //Price of a givevn category in USD WEI
    mapping(uint8 => uint256) public categoryPrice;
    
    //The percent of ether required for buying in BZN
    mapping(uint8 => uint256) public requiredEtherPercent;
    mapping(uint8 => uint256) public requiredEtherPercentBase;
    bool public allowCreateCategory = true;

    //The gun token contract
    GunToken public token;
    //The gun factory contract
    GunFactory internal factory;
    //The BZN contract
    StandardBurnableToken internal bzn;
    //The Maker ETH/USD price feed
    IDSValue public ethFeed;
    BZNFeed public bznFeed;
    //The gamepool address
    address internal gamePool;
    
    //Require the skinned/regular shop to be opened
    modifier ENSURESHOPOPEN328(uint8 category) {	//inject NONSTANDARD NAMING
        require(categoryExists[category], "Category doesn't exist!");
        require(categoryOpen[category], "Category is not open!");
        _;
    }
    
    //Allow a function to accept ETH payment
    modifier PAYINETH352(address referal, uint8 category, address new_owner, uint16 quanity) {	//inject NONSTANDARD NAMING
        uint256 usdPrice;
        uint256 totalPrice;
        (usdPrice, totalPrice) = PRICEFOR73(category, quanity);
        require(usdPrice > 0, "Price not yet set");
        
        categoryPrice[category] = usdPrice; //Save last price
        
        uint256 price = CONVERT77(totalPrice, false);
        
        require(msg.value >= price, "Not enough Ether sent!");
        
        _;
        
        if (msg.value > price) {
            uint256 change = msg.value - price;

            msg.sender.transfer(change);
        }
        
        if (referal != address(0)) {
            require(referal != msg.sender, "The referal cannot be the sender");
            require(referal != tx.origin, "The referal cannot be the tranaction origin");
            require(referal != new_owner, "The referal cannot be the new owner");

            //The commissionRate map adds any partner bonuses, or 0 if a normal user referral
            uint256 totalCommision = commission_percent82 + commissionRate[referal];

            uint256 commision = (price * totalCommision) / 100;
            
            address payable _referal = address(uint160(referal));

            _referal.transfer(commision);
        }

    }
    
    //Allow function to accept BZN payment
    modifier PAYINBZN388(address referal, uint8 category, address payable new_owner, uint16 quanity) {	//inject NONSTANDARD NAMING
        uint256[] memory prices = new uint256[](4); //Hack to work around local var limit (usdPrice, bznPrice, commision, totalPrice)
        (prices[0], prices[3]) = PRICEFOR73(category, quanity);
        require(prices[0] > 0, "Price not yet set");
            
        categoryPrice[category] = prices[0];
        
        prices[1] = CONVERT77(prices[3], true); //Convert the totalPrice to BZN

        //The commissionRate map adds any partner bonuses, or 0 if a normal user referral
        if (referal != address(0)) {
            prices[2] = (prices[1] * (commission_percent82 + commissionRate[referal])) / 100;
        }
        
        uint256 requiredEther = (CONVERT77(prices[3], false) * requiredEtherPercent[category]) / requiredEtherPercentBase[category];
        
        require(msg.value >= requiredEther, "Buying with BZN requires some Ether!");
        
        bzn.BURNFROM813(new_owner, (((prices[1] - prices[2]) * 30) / 100));
        bzn.TRANSFERFROM196(new_owner, gamePool, prices[1] - prices[2] - (((prices[1] - prices[2]) * 30) / 100));
        
        _;
        
        if (msg.value > requiredEther) {
            new_owner.transfer(msg.value - requiredEther);
        }
        
        if (referal != address(0)) {
            require(referal != msg.sender, "The referal cannot be the sender");
            require(referal != tx.origin, "The referal cannot be the tranaction origin");
            require(referal != new_owner, "The referal cannot be the new owner");
            
            bzn.TRANSFERFROM196(new_owner, referal, prices[2]);
            
            prices[2] = (requiredEther * (commission_percent82 + commissionRate[referal])) / 100;
            
            address payable _referal = address(uint160(referal));

            _referal.transfer(prices[2]);
        }
    }

    //Constructor
    constructor(
        address tokenAddress,
        address tokenFactory,
        address gp,
        address isd,
        address bzn_address
    ) public {
        token = GunToken(tokenAddress);

        factory = GunFactory(tokenFactory);
        
        ethFeed = IDSValue(isd);
        bzn = StandardBurnableToken(bzn_address);

        gamePool = gp;

        //Set percent increases
        categoryPercentIncrease[1] = 100035;
        categoryPercentBase[1] = 100000;
        
        categoryPercentIncrease[2] = 100025;
        categoryPercentBase[2] = 100000;
        
        categoryPercentIncrease[3] = 100015;
        categoryPercentBase[3] = 100000;
        
        commissionRate[opensea308] = 10;
    }
    
    function CREATECATEGORY817(uint8 category) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        require(allowCreateCategory);
        
        categoryExists[category] = true;
    }
    
    function DISABLECREATECATEGORIES112() public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        allowCreateCategory = false;
    }
    
    //Set the referal commision rate for an address
    function SETCOMMISSION914(address referral, uint256 percent) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        require(percent > commission_percent82);
        require(percent < 95);
        percent = percent - commission_percent82;
        
        commissionRate[referral] = percent;
    }
    
    //Set the price increase/base for skinned or regular guns
    function SETPERCENTINCREASE775(uint256 increase, uint256 base, uint8 category) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        require(increase > base);
        
        categoryPercentIncrease[category] = increase;
        categoryPercentBase[category] = base;
    }
    
    function SETETHERPERCENT411(uint256 percent, uint256 base, uint8 category) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        requiredEtherPercent[category] = percent;
        requiredEtherPercentBase[category] = base;
    }
    
    function KILLCATEGORY428(uint8 category) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        require(!categoryKilled[category]);
        
        categoryOpen[category] = false;
        categoryKilled[category] = true;
    }

    //Open/Close the skinned or regular guns shop
    function SETSHOPSTATE191(uint8 category, bool open) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        require(category == 1 || category == 2 || category == 3);
        require(!categoryKilled[category]);
        require(categoryExists[category]);
        
        categoryOpen[category] = open;
    }

                                                                   
    function SETPRICE360(uint8 category, uint256 price, bool inWei) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        uint256 multiply = 1e18;
        if (inWei) {
            multiply = 1;
        }
        
        categoryPrice[category] = price * multiply;
    }

                                                                                                                     
    function WITHDRAW154(uint256 amount) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        uint256 balance = address(this).balance;

        require(amount <= balance, "Requested to much");
        
        address payable _owner = address(uint160(OWNER824()));
        
        _owner.transfer(amount);

        emit WITHDRAWAL910(amount);
    }
    
    function SETBZNFEEDCONTRACT654(address new_bzn_feed) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        bznFeed = BZNFeed(new_bzn_feed);
    }
    
    //Buy many skinned or regular guns with BZN. This will reserve the amount of guns and allows the new_owner to invoke claimGuns for free
    function BUYWITHBZN846(address referal, uint8 category, address payable new_owner, uint16 quanity) ENSURESHOPOPEN328(category) PAYINBZN388(referal, category, new_owner, quanity) public payable returns (bool) {	//inject NONSTANDARD NAMING
        factory.MINTFOR528(new_owner, quanity, category);
            
        return true;
    }
    
    //Buy many skinned or regular guns with ETH. This will reserve the amount of guns and allows the new_owner to invoke claimGuns for free
    function BUYWITHETHER108(address referal, uint8 category, address new_owner, uint16 quanity) ENSURESHOPOPEN328(category) PAYINETH352(referal, category, new_owner, quanity) public payable returns (bool) {	//inject NONSTANDARD NAMING
        factory.MINTFOR528(new_owner, quanity, category);
        
        return true;
    }
    
    function CONVERT77(uint256 usdValue, bool isBZN) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (isBZN) {
            return bznFeed.CONVERT77(usdValue);
        } else {
            bool temp;
            bytes32 aaa;
            (aaa, temp) = ethFeed.PEEK123();
                
            uint256 priceForEtherInUsdWei = uint256(aaa);
            
            return usdValue / (priceForEtherInUsdWei / 1e18);
        }
    }
    
                                                                         
    function PRICEFOR73(uint8 category, uint16 quanity) public view returns (uint256, uint256) {	//inject NONSTANDARD NAMING
        require(quanity > 0);
        uint256 percent = categoryPercentIncrease[category];
        uint256 base = categoryPercentBase[category];

        uint256 currentPrice = categoryPrice[category];
        uint256 nextPrice = currentPrice;
        uint256 totalPrice = 0;
        //We can't use exponents because we'll overflow quickly
        //Only for loop :(
        for (uint i = 0; i < quanity; i++) {
            nextPrice = (currentPrice * percent) / base;
            
            currentPrice = nextPrice;
            
            totalPrice += nextPrice;
        }

        //Return the next price, as this is the true price
        return (nextPrice, totalPrice);
    }

    //Determine if a tokenId exists (has been sold)
    function SOLD957(uint256 _tokenId) public view returns (bool) {	//inject NONSTANDARD NAMING
        return token.EXISTS127(_tokenId);
    }
    
    function RECEIVEAPPROVAL438(address from, uint256 tokenAmount, address tokenContract, bytes memory data) public payable returns (bool) {	//inject NONSTANDARD NAMING
        address referal;
        uint8 category;
        uint16 quanity;
        
        (referal, category, quanity) = abi.decode(data, (address, uint8, uint16));
        
        require(quanity >= 1);
        
        address payable _from = address(uint160(from)); 
        
        BUYWITHBZN846(referal, category, _from, quanity);
        
        return true;
    }
}

contract GunFactory is Ownable {
    using strings for *;
    
    uint8 public constant premium_category760 = 1;	//inject NONSTANDARD NAMING
    uint8 public constant midgrade_category818 = 2;	//inject NONSTANDARD NAMING
    uint8 public constant regular_category63 = 3;	//inject NONSTANDARD NAMING
    uint256 public constant one_month568 = 2628000;	//inject NONSTANDARD NAMING
    
    uint256 public mintedGuns = 0;
    address preOrderAddress;
    GunToken token;
    
    mapping(uint8 => uint256) internal gunsMintedByCategory;
    mapping(uint8 => uint256) internal totalGunsMintedByCategory;
    
    mapping(uint8 => uint256) internal firstMonthLimit;
    mapping(uint8 => uint256) internal secondMonthLimit;
    mapping(uint8 => uint256) internal thirdMonthLimit;
    
    uint256 internal startTime;
    mapping(uint8 => uint256) internal currentMonthEnd;
    uint256 internal monthOneEnd;
    uint256 internal monthTwoEnd;

    modifier ONLYPREORDER406 {	//inject NONSTANDARD NAMING
        require(msg.sender == preOrderAddress, "Not authorized");
        _;
    }

    modifier ISINITIALIZED13 {	//inject NONSTANDARD NAMING
        require(preOrderAddress != address(0), "No linked preorder");
        require(address(token) != address(0), "No linked token");
        _;
    }
    
    constructor() public {
        firstMonthLimit[premium_category760] = 5000;
        firstMonthLimit[midgrade_category818] = 20000;
        firstMonthLimit[regular_category63] = 30000;
        
        secondMonthLimit[premium_category760] = 2500;
        secondMonthLimit[midgrade_category818] = 10000;
        secondMonthLimit[regular_category63] = 15000;
        
        thirdMonthLimit[premium_category760] = 600;
        thirdMonthLimit[midgrade_category818] = 3000;
        thirdMonthLimit[regular_category63] = 6000;
        
        startTime = block.timestamp;
        monthOneEnd = startTime + one_month568;
        monthTwoEnd = startTime + one_month568 + one_month568;
        
        currentMonthEnd[premium_category760] = monthOneEnd;
        currentMonthEnd[midgrade_category818] = monthOneEnd;
        currentMonthEnd[regular_category63] = monthOneEnd;
    }

    function UINTTOSTRING328(uint v) internal pure returns (string memory) {	//inject NONSTANDARD NAMING
        if (v == 0) {
            return "0";
        }
        uint j = v;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (v != 0) {
            bstr[k--] = byte(uint8(48 + v % 10));
            v /= 10;
        }
        
        return string(bstr);
    }

    function MINTFOR528(address newOwner, uint16 size, uint8 category) public ONLYPREORDER406 ISINITIALIZED13 returns (uint256) {	//inject NONSTANDARD NAMING
        GunPreOrder preOrder = GunPreOrder(preOrderAddress);
        require(preOrder.categoryExists(category), "Invalid category");
        
        require(!HASREACHEDLIMIT199(category), "The monthly limit has been reached");
        
        token.CLAIMALLOCATION316(newOwner, size, category);
        
        mintedGuns++;
        
        gunsMintedByCategory[category] = gunsMintedByCategory[category] + 1;
        totalGunsMintedByCategory[category] = totalGunsMintedByCategory[category] + 1;
    }
    
    function HASREACHEDLIMIT199(uint8 category) internal returns (bool) {	//inject NONSTANDARD NAMING
        uint256 currentTime = block.timestamp;
        uint256 limit = CURRENTLIMIT394(category);
        
        uint256 monthEnd = currentMonthEnd[category];
        
        //If the current block time is greater than or equal to the end of the month
        if (currentTime >= monthEnd) {
            //It's a new month, reset all limits
            //gunsMintedByCategory[PREMIUM_CATEGORY] = 0;
            //gunsMintedByCategory[MIDGRADE_CATEGORY] = 0;
            //gunsMintedByCategory[REGULAR_CATEGORY] = 0;
            gunsMintedByCategory[category] = 0;
            
            //Set next month end to be equal one month in advance
            //do this while the current time is greater than the next month end
            while (currentTime >= monthEnd) {
                monthEnd = monthEnd + one_month568;
            }
            
            //Finally, update the limit
            limit = CURRENTLIMIT394(category);
            currentMonthEnd[category] = monthEnd;
        }
        
        //Check if the limit has been reached
        return gunsMintedByCategory[category] >= limit;
    }
    
    function REACHEDLIMIT389(uint8 category) public view returns (bool) {	//inject NONSTANDARD NAMING
        uint256 limit = CURRENTLIMIT394(category);
        
        return gunsMintedByCategory[category] >= limit;
    }
    
    function CURRENTLIMIT394(uint8 category) public view returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 currentTime = block.timestamp;
        uint256 limit;
        if (currentTime < monthOneEnd) {
            limit = firstMonthLimit[category];
        } else if (currentTime < monthTwoEnd) {
            limit = secondMonthLimit[category];
        } else {
            limit = thirdMonthLimit[category];
        }
        
        return limit;
    }
    
    function SETCATEGORYLIMIT220(uint8 category, uint256 firstLimit, uint256 secondLimit, uint256 thirdLimit) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        require(firstMonthLimit[category] == 0);
        require(secondMonthLimit[category] == 0);
        require(thirdMonthLimit[category] == 0);
        
        firstMonthLimit[category] = firstLimit;
        secondMonthLimit[category] = secondLimit;
        thirdMonthLimit[category] = thirdLimit;
    }
    
                                                                                                                      
    function ATTACHPREORDER925(address dst) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        require(preOrderAddress == address(0));
        require(dst != address(0));

        //Enforce that address is indeed a preorder
        GunPreOrder preOrder = GunPreOrder(dst);

        preOrderAddress = address(preOrder);
    }

                                                         
    function ATTACHTOKEN953(address dst) public ONLYOWNER845 {	//inject NONSTANDARD NAMING
        require(address(token) == address(0));
        require(dst != address(0));

        //Enforce that address is indeed a preorder
        GunToken ct = GunToken(dst);

        token = ct;
    }
}