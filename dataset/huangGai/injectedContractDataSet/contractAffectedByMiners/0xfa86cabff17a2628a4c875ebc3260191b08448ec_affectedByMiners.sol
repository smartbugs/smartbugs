pragma solidity ^0.5.2 <0.6.0;

contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
library RLP {

    uint constant DATA_SHORT_START = 0x80;
    uint constant DATA_LONG_START = 0xB8;
    uint constant LIST_SHORT_START = 0xC0;
    uint constant LIST_LONG_START = 0xF8;

    uint constant DATA_LONG_OFFSET = 0xB7;
    uint constant LIST_LONG_OFFSET = 0xF7;


    struct RLPItem {
        uint _unsafe_memPtr;    // Pointer to the RLP-encoded bytes.
        uint _unsafe_length;    // Number of bytes. This is the full length of the string.
    }

    struct Iterator {
        RLPItem _unsafe_item;   // Item that's being iterated over.
        uint _unsafe_nextPtr;   // Position of the next item in the list.
    }

    /* Iterator */

    function next(Iterator memory self) internal pure returns (RLPItem memory subItem) {
        if(hasNext(self)) {
            uint256 ptr = self._unsafe_nextPtr;
            uint256 itemLength = _itemLength(ptr);
            subItem._unsafe_memPtr = ptr;
            subItem._unsafe_length = itemLength;
            self._unsafe_nextPtr = ptr + itemLength;
        }
        else
            revert();
    }

    function next(Iterator memory self, bool strict) internal pure returns (RLPItem memory subItem) {
        subItem = next(self);
        if(strict && !_validate(subItem))
            revert();
        return subItem;
    }

    function hasNext(
        Iterator memory self
    ) internal pure returns (bool) {
        RLP.RLPItem memory item = self._unsafe_item;
        return self._unsafe_nextPtr < item._unsafe_memPtr + item._unsafe_length;
    }

    /* RLPItem */

    /// @dev Creates an RLPItem from an array of RLP encoded bytes.
    /// @param self The RLP encoded bytes.
    /// @return An RLPItem
    function toRLPItem(bytes memory self) internal pure returns (RLPItem memory) {
        uint len = self.length;
        if (len == 0) {
            return RLPItem(0, 0);
        }
        uint memPtr;
        assembly {
            memPtr := add(self, 0x20)
        }
        return RLPItem(memPtr, len);
    }

    /// @dev Creates an RLPItem from an array of RLP encoded bytes.
    /// @param self The RLP encoded bytes.
    /// @param strict Will throw if the data is not RLP encoded.
    /// @return An RLPItem
    function toRLPItem(bytes memory self, bool strict) internal pure returns (RLPItem memory) {
        RLP.RLPItem memory item = toRLPItem(self);
        if(strict) {
            uint len = self.length;
            if(_payloadOffset(item) > len)
                revert();
            if(_itemLength(item._unsafe_memPtr) != len)
                revert();
            if(!_validate(item))
                revert();
        }
        return item;
    }

    /// @dev Check if the RLP item is null.
    /// @param self The RLP item.
    /// @return 'true' if the item is null.
    function isNull(RLPItem memory self) internal pure returns (bool ret) {
        return self._unsafe_length == 0;
    }

    /// @dev Check if the RLP item is a list.
    /// @param self The RLP item.
    /// @return 'true' if the item is a list.
    function isList(RLPItem memory self) internal pure returns (bool ret) {
        if (self._unsafe_length == 0)
            return false;
        uint memPtr = self._unsafe_memPtr;
        assembly {
            ret := iszero(lt(byte(0, mload(memPtr)), 0xC0))
        }
    }

    /// @dev Check if the RLP item is data.
    /// @param self The RLP item.
    /// @return 'true' if the item is data.
    function isData(RLPItem memory self) internal pure returns (bool ret) {
        if (self._unsafe_length == 0)
            return false;
        uint memPtr = self._unsafe_memPtr;
        assembly {
            ret := lt(byte(0, mload(memPtr)), 0xC0)
        }
    }

    /// @dev Check if the RLP item is empty (string or list).
    /// @param self The RLP item.
    /// @return 'true' if the item is null.
    function isEmpty(RLPItem memory self) internal pure returns (bool ret) {
        if(isNull(self))
            return false;
        uint b0;
        uint memPtr = self._unsafe_memPtr;
        assembly {
            b0 := byte(0, mload(memPtr))
        }
        return (b0 == DATA_SHORT_START || b0 == LIST_SHORT_START);
    }

    /// @dev Get the number of items in an RLP encoded list.
    /// @param self The RLP item.
    /// @return The number of items.
    function items(RLPItem memory self) internal pure returns (uint) {
        if (!isList(self))
            return 0;
        uint b0;
        uint memPtr = self._unsafe_memPtr;
        assembly {
            b0 := byte(0, mload(memPtr))
        }
        uint pos = memPtr + _payloadOffset(self);
        uint last = memPtr + self._unsafe_length - 1;
        uint itms;
        while(pos <= last) {
            pos += _itemLength(pos);
            itms++;
        }
        return itms;
    }

    /// @dev Create an iterator.
    /// @param self The RLP item.
    /// @return An 'Iterator' over the item.
    function iterator(RLPItem memory self) internal pure returns (Iterator memory it) {
        require(isList(self));
        uint ptr = self._unsafe_memPtr + _payloadOffset(self);
        it._unsafe_item = self;
        it._unsafe_nextPtr = ptr;
    }

    /// @dev Return the RLP encoded bytes.
    /// @param self The RLPItem.
    /// @return The bytes.
    function toBytes(RLPItem memory self) internal pure returns (bytes memory bts) {
        uint256 len = self._unsafe_length;
        if (len == 0)
            return bts;
        bts = new bytes(len);
        _copyToBytes(self._unsafe_memPtr, bts, len);
//
//        uint256 len = self._unsafe_length;
//
//        if (len == 0) {
//            return bts;
//        } else if (len == 1) {
//            bts = new bytes(len);
//            _copyToBytes(self._unsafe_memPtr, bts, len);
//            return bts;
//        }
//
//        bts = new bytes(len-_payloadOffset(self));
//        uint start = self._unsafe_memPtr + _payloadOffset(self);
//        _copyToBytes(start, bts, len-_payloadOffset(self));
    }

    /// @dev Decode an RLPItem into bytes. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toData(RLPItem memory self) internal pure returns (bytes memory bts) {
        require(isData(self));
        (uint256 rStartPos, uint256 len) = _decode(self);
        bts = new bytes(len);
        _copyToBytes(rStartPos, bts, len);
    }

    /// @dev Get the list of sub-items from an RLP encoded list.
    /// Warning: This is inefficient, as it requires that the list is read twice.
    /// @param self The RLP item.
    /// @return Array of RLPItems.
    function toList(RLPItem memory self) internal pure returns (RLPItem[] memory list) {
        require(isList(self));
        uint256 numItems = items(self);
        list = new RLPItem[](numItems);
        RLP.Iterator memory it = iterator(self);
        uint idx;
        while(hasNext(it)) {
            list[idx] = next(it);
            idx++;
        }
    }

    /// @dev Decode an RLPItem into an ascii string. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toAscii(RLPItem memory self) internal pure returns (string memory str) {
        require(isData(self));
        (uint256 rStartPos, uint256 len) = _decode(self);
        bytes memory bts = new bytes(len);
        _copyToBytes(rStartPos, bts, len);
        str = string(bts);
    }

    /// @dev Decode an RLPItem into a uint. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toUint(RLPItem memory self) internal pure returns (uint data) {
        require(isData(self));
        (uint256 rStartPos, uint256 len) = _decode(self);
        require(len <= 32);
        assembly {
            data := div(mload(rStartPos), exp(256, sub(32, len)))
        }
    }

    /// @dev Decode an RLPItem into a boolean. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toBool(RLPItem memory self) internal pure returns (bool data) {
        require(isData(self));
        (uint256 rStartPos, uint256 len) = _decode(self);
        require(len == 1);
        uint temp;
        assembly {
            temp := byte(0, mload(rStartPos))
        }
        require(temp == 1 || temp == 0);
        return temp == 1 ? true : false;
    }

    /// @dev Decode an RLPItem into a byte. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toByte(RLPItem memory self)
    internal
    pure
    returns (byte data)
    {
        require(isData(self));

        (uint256 rStartPos, uint256 len) = _decode(self);

        require(len == 1);

        byte temp;
        assembly {
            temp := byte(0, mload(rStartPos))
        }
        return temp;
    }

    /// @dev Decode an RLPItem into an int. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toInt(RLPItem memory self)
    internal
    pure
    returns (int data)
    {
        return int(toUint(self));
    }

    /// @dev Decode an RLPItem into a bytes32. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toBytes32(RLPItem memory self)
    internal
    pure
    returns (bytes32 data)
    {
        return bytes32(toUint(self));
    }

    /// @dev Decode an RLPItem into an address. This will not work if the
    /// RLPItem is a list.
    /// @param self The RLPItem.
    /// @return The decoded string.
    function toAddress(RLPItem memory self)
    internal
    pure
    returns (address data)
    {
        (, uint256 len) = _decode(self);
        require(len <= 20);
        return address(toUint(self));
    }

    // Get the payload offset.
    function _payloadOffset(RLPItem memory self)
    private
    pure
    returns (uint)
    {
        if(self._unsafe_length == 0)
            return 0;
        uint b0;
        uint memPtr = self._unsafe_memPtr;
        assembly {
            b0 := byte(0, mload(memPtr))
        }
        if(b0 < DATA_SHORT_START)
            return 0;
        if(b0 < DATA_LONG_START || (b0 >= LIST_SHORT_START && b0 < LIST_LONG_START))
            return 1;
        if(b0 < LIST_SHORT_START)
            return b0 - DATA_LONG_OFFSET + 1;
        return b0 - LIST_LONG_OFFSET + 1;
    }

    // Get the full length of an RLP item.
    function _itemLength(uint memPtr)
    private
    pure
    returns (uint len)
    {
        uint b0;
        assembly {
            b0 := byte(0, mload(memPtr))
        }
        if (b0 < DATA_SHORT_START)
            len = 1;
        else if (b0 < DATA_LONG_START)
            len = b0 - DATA_SHORT_START + 1;
        else if (b0 < LIST_SHORT_START) {
            assembly {
                let bLen := sub(b0, 0xB7) // bytes length (DATA_LONG_OFFSET)
                let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
                len := add(1, add(bLen, dLen)) // total length
            }
        } else if (b0 < LIST_LONG_START) {
            len = b0 - LIST_SHORT_START + 1;
        } else {
            assembly {
                let bLen := sub(b0, 0xF7) // bytes length (LIST_LONG_OFFSET)
                let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
                len := add(1, add(bLen, dLen)) // total length
            }
        }
    }

    // Get start position and length of the data.
    function _decode(RLPItem memory self)
    private
    pure
    returns (uint memPtr, uint len)
    {
        require(isData(self));
        uint b0;
        uint start = self._unsafe_memPtr;
        assembly {
            b0 := byte(0, mload(start))
        }
        if (b0 < DATA_SHORT_START) {
            memPtr = start;
            len = 1;
            return (memPtr, len);
        }
        if (b0 < DATA_LONG_START) {
            len = self._unsafe_length - 1;
            memPtr = start + 1;
        } else {
            uint bLen;
            assembly {
                bLen := sub(b0, 0xB7) // DATA_LONG_OFFSET
            }
            len = self._unsafe_length - 1 - bLen;
            memPtr = start + bLen + 1;
        }
        return (memPtr, len);
    }

    // Assumes that enough memory has been allocated to store in target.
    function _copyToBytes(
        uint btsPtr,
        bytes memory tgt,
        uint btsLen) private pure
    {
        // Exploiting the fact that 'tgt' was the last thing to be allocated,
        // we can write entire words, and just overwrite any excess.
        assembly {
            {
                let words := div(add(btsLen, 31), 32)
                let rOffset := btsPtr
                let wOffset := add(tgt, 0x20)

                for { let i := 0 } lt(i, words) { i := add(i, 1) } {
                    let offset := mul(i, 0x20)
                    mstore(add(wOffset, offset), mload(add(rOffset, offset)))
                }

                mstore(add(tgt, add(0x20, mload(tgt))), 0)
            }

        }
    }

    // Check that an RLP item is valid.
    function _validate(RLPItem memory self)
    private
    pure
    returns (bool ret)
    {
        // Check that RLP is well-formed.
        uint b0;
        uint b1;
        uint memPtr = self._unsafe_memPtr;
        assembly {
            b0 := byte(0, mload(memPtr))
            b1 := byte(1, mload(memPtr))
        }
        if(b0 == DATA_SHORT_START + 1 && b1 < DATA_SHORT_START)
            return false;
        return true;
    }
}
library Object {
    using RLP for bytes;
    using RLP for bytes[];
    using RLP for RLP.RLPItem;
    using RLP for RLP.Iterator;

    struct Data {
        uint sura;
        uint ayat;
        bytes text;
    }

    function createData(bytes memory dataBytes)
        internal
        pure
        returns (Data memory)
    {
        RLP.RLPItem[] memory dataList = dataBytes.toRLPItem().toList();
        return Data({
            sura: dataList[0].toUint(),
            ayat: dataList[1].toUint(),
            text: dataList[2].toBytes()
        });
    }
}

contract Storage is Ownable {
    using Object for bytes;
    using RLP for bytes;
    using RLP for bytes[];
    using RLP for RLP.RLPItem;
    using RLP for RLP.Iterator;

    struct coord {
        uint sura;
        uint ayat;
    }

    // @dev Mapping ayat's hash with its text.
    mapping(bytes32 => bytes) public content;
    mapping(uint => mapping(uint => bytes32)) public coordinates;
    mapping(bytes32 => coord[]) public all_coordinates;

    /** @dev Adds content.
      * @param text Ayat text.
      * @param sura Sura number.
      * @param ayat Ayat number.
      */
    function add_content(
        bytes memory text,
        uint sura,
        uint ayat
    ) public onlyOwner {
        bytes32 hash = keccak256(text);
        if (blockhash(block.number) != 0x0000000000000000000000000000000000000000000000000000000000000000) {	//injected CONTRACT AFFECTED BY MINERS
            return;
        }

        coordinates[sura][ayat] = hash;
        all_coordinates[hash].push(coord({sura:sura, ayat: ayat}));
        content[hash] = text;
    }

    /** @dev Adds packed data.
      * @param data RLP packed objects.
      */
    function add_data(bytes memory data) public onlyOwner {
        RLP.RLPItem[] memory list = data.toRLPItem().toList();

        for (uint index = 0; index < list.length; index++) {
            RLP.RLPItem[] memory item = list[index].toList();

            uint sura = item[0].toUint();
            uint ayat = item[1].toUint();
            bytes memory text = item[2].toData();

            add_content(text, sura, ayat);
        }
    }

    /** @dev Gets ayat text by hash.
      * @param ayat_hash Ayat keccak256 hash of compressed text (gzip).
      * @return Ayat compressed text.
      */
    function get_ayat_text_by_hash(
        bytes32 ayat_hash
    ) public view returns (bytes  memory text) {
        text = content[ayat_hash];
    }

    /** @dev Gets ayat text by coordinates.
      * @param sura Sura number.
      * @param ayat Ayat number.
      * @return Ayat compressed text.
      */
    function get_ayat_text_by_coordinates(
        uint sura,
        uint ayat
    ) public view returns (bytes memory text) {
        bytes32 hash = coordinates[sura][ayat];
        text = content[hash];
    }

    /** @dev Gets number of ayats by hash.
      * @param hash Ayat keccak256 hash of compressed text (gzip).
      * @return Ayats number.
      */
    function get_ayats_length(
        bytes32 hash
    ) public view returns (uint) {
        return all_coordinates[hash].length;
    }

    /** @dev Gets an ayat's number and a sura number by a hash and a index in an array.
      * @param hash Ayat keccak256 hash of compressed text (gzip).
      * @param index Ayat index. Ayat text is not unique in the Quran, so this may be several options.
      */
    function get_ayat_coordinates_by_index(
        bytes32 hash,
        uint index
    ) public view returns (uint sura, uint ayat) {
        coord memory data = all_coordinates[hash][index];
        sura = data.sura;
        ayat = data.ayat;
    }

    /** @dev Verifying the text of an ayat.
      * @param text Ayat compressed text (gzip).
      * @return bool
      */
    function check_ayat_text(
        bytes memory text
    ) public view returns(bool) {
        bytes32 hash = keccak256(text);
        bytes memory ayat_data = content[hash];
        return ayat_data.length != 0;
    }
}