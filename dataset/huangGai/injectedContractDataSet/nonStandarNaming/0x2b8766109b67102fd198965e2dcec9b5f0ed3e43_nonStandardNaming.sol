                                                                 

pragma solidity 0.5.11;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD640(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB596(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB596(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                                                             
    function SUB596(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL119(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV27(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV27(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function DIV27(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD463(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD463(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function MOD463(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}


contract InscribableToken {

    mapping(bytes32 => bytes32) public properties;

    event CLASSPROPERTYSET751(	//inject NONSTANDARD NAMING
        bytes32 indexed key,
        bytes32 value
    );

    event TOKENPROPERTYSET338(	//inject NONSTANDARD NAMING
        uint indexed id,
        bytes32 indexed key,
        bytes32 value
    );

    function _SETPROPERTY292(	//inject NONSTANDARD NAMING
        uint _id,
        bytes32 _key,
        bytes32 _value
    )
        internal
    {
        properties[GETTOKENKEY33(_id, _key)] = _value;
        emit TOKENPROPERTYSET338(_id, _key, _value);
    }

    function GETPROPERTY470(	//inject NONSTANDARD NAMING
        uint _id,
        bytes32 _key
    )
        public
        view
        returns (bytes32 _value)
    {
        return properties[GETTOKENKEY33(_id, _key)];
    }

    function _SETCLASSPROPERTY718(	//inject NONSTANDARD NAMING
        bytes32 _key,
        bytes32 _value
    )
        internal
    {
        emit CLASSPROPERTYSET751(_key, _value);
        properties[GETCLASSKEY628(_key)] = _value;
    }

    function GETTOKENKEY33(	//inject NONSTANDARD NAMING
        uint _tokenId,
        bytes32 _key
    )
        public
        pure
        returns (bytes32)
    {
        // one prefix to prevent collisions
        return keccak256(abi.encodePacked(uint(1), _tokenId, _key));
    }

    function GETCLASSKEY628(bytes32 _key)	//inject NONSTANDARD NAMING
        public
        pure
        returns (bytes32)
    {
        // zero prefix to prevent collisions
        return keccak256(abi.encodePacked(uint(0), _key));
    }

    function GETCLASSPROPERTY691(bytes32 _key)	//inject NONSTANDARD NAMING
        public
        view
        returns (bytes32)
    {
        return properties[GETCLASSKEY628(_key)];
    }

}



library String {

                                                                                                                                                                                                                         
    function FROMUINT947(uint256 value) internal pure returns (string memory) {	//inject NONSTANDARD NAMING
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        uint256 index = digits - 1;
        temp = value;
        while (temp != 0) {
            buffer[index--] = byte(uint8(48 + temp % 10));
            temp /= 10;
        }
        return string(buffer);
    }

    bytes constant alphabet572 = "0123456789abcdef";	//inject NONSTANDARD NAMING

    function FROMADDRESS777(address _addr) internal pure returns(string memory) {	//inject NONSTANDARD NAMING
        bytes32 value = bytes32(uint256(_addr));
        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[2+i*2] = alphabet572[uint(uint8(value[i + 12] >> 4))];
            str[3+i*2] = alphabet572[uint(uint8(value[i + 12] & 0x0F))];
        }
        return string(str);
    }

}

// solium-disable security/no-inline-assembly


library StorageWrite {

    using SafeMath for uint256;

    function _GETSTORAGEARRAYSLOT595(uint _dest, uint _index) internal view returns (uint result) {	//inject NONSTANDARD NAMING
        uint slot = _GETARRAYSLOT364(_dest, _index);
        assembly { result := sload(slot) }
    }

    function _GETARRAYSLOT364(uint _dest, uint _index) internal pure returns (uint slot) {	//inject NONSTANDARD NAMING
        assembly {
            let free := mload(0x40)
            mstore(free, _dest)
            slot := add(keccak256(free, 32), _index)
        }
    }

    function _SETARRAYSLOT66(uint _dest, uint _index, uint _value) internal {	//inject NONSTANDARD NAMING
        uint slot = _GETARRAYSLOT364(_dest, _index);
        assembly { sstore(slot, _value) }
    }

    function _LOADSLOTS761(	//inject NONSTANDARD NAMING
        uint _slot,
        uint _offset,
        uint _perSlot,
        uint _length
    )
        internal
        view
        returns (uint[] memory slots)
    {
        uint slotCount = _SLOTCOUNT226(_offset, _perSlot, _length);
        slots = new uint[](slotCount);
        // top and tail the slots
        uint firstPos = _POS762(_offset, _perSlot); // _offset.div(_perSlot);
        slots[0] = _GETSTORAGEARRAYSLOT595(_slot, firstPos);
        if (slotCount > 1) {
            uint lastPos = _POS762(_offset.ADD640(_length), _perSlot); // .div(_perSlot);
            slots[slotCount-1] = _GETSTORAGEARRAYSLOT595(_slot, lastPos);
        }
    }

    function _POS762(uint items, uint perPage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return items / perPage;
    }

    function _SLOTCOUNT226(uint _offset, uint _perSlot, uint _length) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint start = _offset / _perSlot;
        uint end = (_offset + _length) / _perSlot;
        return (end - start) + 1;
    }

    function _SAVESLOTS992(uint _slot, uint _offset, uint _size, uint[] memory _slots) internal {	//inject NONSTANDARD NAMING
        uint offset = _offset.DIV27((256/_size));
        for (uint i = 0; i < _slots.length; i++) {
            _SETARRAYSLOT66(_slot, offset + i, _slots[i]);
        }
    }

    function _WRITE724(uint[] memory _slots, uint _offset, uint _size, uint _index, uint _value) internal pure {	//inject NONSTANDARD NAMING
        uint perSlot = 256 / _size;
        uint initialOffset = _offset % perSlot;
        uint slotPosition = (initialOffset + _index) / perSlot;
        uint withinSlot = ((_index + _offset) % perSlot) * _size;
        // evil bit shifting magic
        for (uint q = 0; q < _size; q += 8) {
            _slots[slotPosition] |= ((_value >> q) & 0xFF) << (withinSlot + q);
        }
    }

    function REPEATUINT16794(uint _slot, uint _offset, uint _length, uint16 _item) internal {	//inject NONSTANDARD NAMING
        uint[] memory slots = _LOADSLOTS761(_slot, _offset, 16, _length);
        for (uint i = 0; i < _length; i++) {
            _WRITE724(slots, _offset, 16, i, _item);
        }
        _SAVESLOTS992(_slot, _offset, 16, slots);
    }

    function UINT16S436(uint _slot, uint _offset, uint16[] memory _items) internal {	//inject NONSTANDARD NAMING
        uint[] memory slots = _LOADSLOTS761(_slot, _offset, 16, _items.length);
        for (uint i = 0; i < _items.length; i++) {
            _WRITE724(slots, _offset, 16, i, _items[i]);
        }
        _SAVESLOTS992(_slot, _offset, 16, slots);
    }

    function UINT8S318(uint _slot, uint _offset, uint8[] memory _items) internal {	//inject NONSTANDARD NAMING
        uint[] memory slots = _LOADSLOTS761(_slot, _offset, 32, _items.length);
        for (uint i = 0; i < _items.length; i++) {
            _WRITE724(slots, _offset, 8, i, _items[i]);
        }
        _SAVESLOTS992(_slot, _offset, 8, slots);
    }

}

contract ImmutableToken {

    string public constant baseuri257 = "https://api.immutable.com/asset/";	//inject NONSTANDARD NAMING

    function TOKENURI642(uint256 tokenId) external view returns (string memory) {	//inject NONSTANDARD NAMING
        return string(abi.encodePacked(
            baseuri257,
            String.FROMADDRESS777(address(this)),
            "/",
            String.FROMUINT947(tokenId)
        ));
    }

}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER48() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA774() internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


                                                                                                                                                                                                                                                                                       
interface IERC165 {
                                                                                                                                                                                                                                                                                                                                                        
    function SUPPORTSINTERFACE367(bytes4 interfaceId) external view returns (bool);	//inject NONSTANDARD NAMING
}


                                                                                                                                                                           
contract ERC165 is IERC165 {
                                                                                  
    bytes4 private constant _interface_id_erc165383 = 0x01ffc9a7;	//inject NONSTANDARD NAMING

                                                                                      
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () internal {
        // Derived contracts need only register support for their own interfaces,
        // we register support for ERC165 itself here
        _REGISTERINTERFACE770(_interface_id_erc165383);
    }

                                                                                                                                               
    function SUPPORTSINTERFACE367(bytes4 interfaceId) external view returns (bool) {	//inject NONSTANDARD NAMING
        return _supportedInterfaces[interfaceId];
    }

                                                                                                                                                                                                                                                                                                                                                                                                   
    function _REGISTERINTERFACE770(bytes4 interfaceId) internal {	//inject NONSTANDARD NAMING
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}


                                                                                                                                                        
contract IERC721Receiver {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function ONERC721RECEIVED640(address operator, address from, uint256 tokenId, bytes memory data)	//inject NONSTANDARD NAMING
    public returns (bytes4);
}


                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT794(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                          
    function TOPAYABLE665(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function SENDVALUE550(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
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

    function CURRENT711(Counter storage counter) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return counter._value;
    }

    function INCREMENT113(Counter storage counter) internal {	//inject NONSTANDARD NAMING
        counter._value += 1;
    }

    function DECREMENT390(Counter storage counter) internal {	//inject NONSTANDARD NAMING
        counter._value = counter._value.SUB596(1);
    }
}

                                                                                                                                                                                                                                                                                                                                                                        
contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED114(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        _owner = _MSGSENDER48();
        emit OWNERSHIPTRANSFERRED114(address(0), _owner);
    }

                                                                     
    function OWNER177() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER453() {	//inject NONSTANDARD NAMING
        require(ISOWNER434(), "Ownable: caller is not the owner");
        _;
    }

                                                                            
    function ISOWNER434() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _MSGSENDER48() == _owner;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP876() public ONLYOWNER453 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED114(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP194(address newOwner) public ONLYOWNER453 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP3(newOwner);
    }

                                                                                              
    function _TRANSFEROWNERSHIP3(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED114(_owner, newOwner);
        _owner = newOwner;
    }
}


                                                                   
contract IERC721 is IERC165 {
    event TRANSFER336(address indexed from, address indexed to, uint256 indexed tokenId);	//inject NONSTANDARD NAMING
    event APPROVAL97(address indexed owner, address indexed approved, uint256 indexed tokenId);	//inject NONSTANDARD NAMING
    event APPROVALFORALL640(address indexed owner, address indexed operator, bool approved);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF188(address owner) public view returns (uint256 balance);	//inject NONSTANDARD NAMING

                                                                                
    function OWNEROF127(uint256 tokenId) public view returns (address owner);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                       
    function SAFETRANSFERFROM19(address from, address to, uint256 tokenId) public;	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                                                              
    function TRANSFERFROM301(address from, address to, uint256 tokenId) public;	//inject NONSTANDARD NAMING
    function APPROVE921(address to, uint256 tokenId) public;	//inject NONSTANDARD NAMING
    function GETAPPROVED252(uint256 tokenId) public view returns (address operator);	//inject NONSTANDARD NAMING

    function SETAPPROVALFORALL542(address operator, bool _approved) public;	//inject NONSTANDARD NAMING
    function ISAPPROVEDFORALL999(address owner, address operator) public view returns (bool);	//inject NONSTANDARD NAMING


    function SAFETRANSFERFROM19(address from, address to, uint256 tokenId, bytes memory data) public;	//inject NONSTANDARD NAMING
}








                                                                                                                            
contract ERC721 is Context, ERC165, IERC721 {
    using SafeMath for uint256;
    using Address for address;
    using Counters for Counters.Counter;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _erc721_received341 = 0x150b7a02;	//inject NONSTANDARD NAMING

    // Mapping from token ID to owner
    mapping (uint256 => address) private _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => Counters.Counter) private _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    bytes4 private constant _interface_id_erc721248 = 0x80ac58cd;	//inject NONSTANDARD NAMING

    constructor () public {
        // register the supported interfaces to conform to ERC721 via ERC165
        _REGISTERINTERFACE770(_interface_id_erc721248);
    }

                                                                                                                                                                                                     
    function BALANCEOF188(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC721: balance query for the zero address");

        return _ownedTokensCount[owner].CURRENT711();
    }

                                                                                                                                                                                                                    
    function OWNEROF127(uint256 tokenId) public view returns (address) {	//inject NONSTANDARD NAMING
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");

        return owner;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                              
    function APPROVE921(address to, uint256 tokenId) public {	//inject NONSTANDARD NAMING
        address owner = OWNEROF127(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(_MSGSENDER48() == owner || ISAPPROVEDFORALL999(owner, _MSGSENDER48()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _tokenApprovals[tokenId] = to;
        emit APPROVAL97(owner, to, tokenId);
    }

                                                                                                                                                                                                                                                                                      
    function GETAPPROVED252(uint256 tokenId) public view returns (address) {	//inject NONSTANDARD NAMING
        require(_EXISTS289(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

                                                                                                                                                                                                                                                                                              
    function SETAPPROVALFORALL542(address to, bool approved) public {	//inject NONSTANDARD NAMING
        require(to != _MSGSENDER48(), "ERC721: approve to caller");

        _operatorApprovals[_MSGSENDER48()][to] = approved;
        emit APPROVALFORALL640(_MSGSENDER48(), to, approved);
    }

                                                                                                                                                                                                                                                                                                                           
    function ISAPPROVEDFORALL999(address owner, address operator) public view returns (bool) {	//inject NONSTANDARD NAMING
        return _operatorApprovals[owner][operator];
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function TRANSFERFROM301(address from, address to, uint256 tokenId) public {	//inject NONSTANDARD NAMING
        //solhint-disable-next-line max-line-length
        require(_ISAPPROVEDOROWNER149(_MSGSENDER48(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _TRANSFERFROM539(from, to, tokenId);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function SAFETRANSFERFROM19(address from, address to, uint256 tokenId) public {	//inject NONSTANDARD NAMING
        SAFETRANSFERFROM19(from, to, tokenId, "");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function SAFETRANSFERFROM19(address from, address to, uint256 tokenId, bytes memory _data) public {	//inject NONSTANDARD NAMING
        require(_ISAPPROVEDOROWNER149(_MSGSENDER48(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _SAFETRANSFERFROM254(from, to, tokenId, _data);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function _SAFETRANSFERFROM254(address from, address to, uint256 tokenId, bytes memory _data) internal {	//inject NONSTANDARD NAMING
        _TRANSFERFROM539(from, to, tokenId);
        require(_CHECKONERC721RECEIVED206(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

                                                                                                                                                                                            
    function _EXISTS289(uint256 tokenId) internal view returns (bool) {	//inject NONSTANDARD NAMING
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

                                                                                                                                                                                                                                                                                                                                                                  
    function _ISAPPROVEDOROWNER149(address spender, uint256 tokenId) internal view returns (bool) {	//inject NONSTANDARD NAMING
        require(_EXISTS289(tokenId), "ERC721: operator query for nonexistent token");
        address owner = OWNEROF127(tokenId);
        return (spender == owner || GETAPPROVED252(tokenId) == spender || ISAPPROVEDFORALL999(owner, spender));
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function _SAFEMINT5(address to, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        _SAFEMINT5(to, tokenId, "");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function _SAFEMINT5(address to, uint256 tokenId, bytes memory _data) internal {	//inject NONSTANDARD NAMING
        _MINT330(to, tokenId);
        require(_CHECKONERC721RECEIVED206(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

                                                                                                                                                                                                                                              
    function _MINT330(address to, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_EXISTS289(tokenId), "ERC721: token already minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].INCREMENT113();

        emit TRANSFER336(address(0), to, tokenId);
    }

                                                                                                                                                                                                                                                                     
    function _BURN121(address owner, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        require(OWNEROF127(tokenId) == owner, "ERC721: burn of token that is not own");

        _CLEARAPPROVAL340(tokenId);

        _ownedTokensCount[owner].DECREMENT390();
        _tokenOwner[tokenId] = address(0);

        emit TRANSFER336(owner, address(0), tokenId);
    }

                                                                                                                                                                              
    function _BURN121(uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        _BURN121(OWNEROF127(tokenId), tokenId);
    }

                                                                                                                                                                                                                                                                                                                                                                                  
    function _TRANSFERFROM539(address from, address to, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        require(OWNEROF127(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _CLEARAPPROVAL340(tokenId);

        _ownedTokensCount[from].DECREMENT390();
        _ownedTokensCount[to].INCREMENT113();

        _tokenOwner[tokenId] = to;

        emit TRANSFER336(from, to, tokenId);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function _CHECKONERC721RECEIVED206(address from, address to, uint256 tokenId, bytes memory _data)	//inject NONSTANDARD NAMING
        internal returns (bool)
    {
        if (!to.ISCONTRACT794()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).ONERC721RECEIVED640(_MSGSENDER48(), from, tokenId, _data);
        return (retval == _erc721_received341);
    }

                                                                                                                                                           
    function _CLEARAPPROVAL340(uint256 tokenId) private {	//inject NONSTANDARD NAMING
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }
}


                                                                                                                                     
contract IERC721Metadata is IERC721 {
    function NAME105() external view returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL26() external view returns (string memory);	//inject NONSTANDARD NAMING
    function TOKENURI642(uint256 tokenId) external view returns (string memory);	//inject NONSTANDARD NAMING
}


contract MultiTransfer is IERC721 {

    function TRANSFERBATCH764(	//inject NONSTANDARD NAMING
        address from,
        address to,
        uint256 start,
        uint256 end
    )
        public
    {
        for (uint i = start; i < end; i++) {
            TRANSFERFROM301(from, to, i);
        }
    }

    function TRANSFERALLFROM512(	//inject NONSTANDARD NAMING
        address from,
        address to,
        uint256[] memory tokenIDs
    )
        public
    {
        for (uint i = 0; i < tokenIDs.length; i++) {
            TRANSFERFROM301(from, to, tokenIDs[i]);
        }
    }

    function SAFETRANSFERBATCH319(	//inject NONSTANDARD NAMING
        address from,
        address to,
        uint256 start,
        uint256 end
    )
        public
    {
        for (uint i = start; i < end; i++) {
            SAFETRANSFERFROM19(from, to, i);
        }
    }

    function SAFETRANSFERALLFROM526(	//inject NONSTANDARD NAMING
        address from,
        address to,
        uint256[] memory tokenIDs
    )
        public
    {
        for (uint i = 0; i < tokenIDs.length; i++) {
            SAFETRANSFERFROM19(from, to, tokenIDs[i]);
        }
    }

}

contract ICards is IERC721 {

    struct Batch {
        uint48 userID;
        uint16 size;
    }

    function BATCHES528(uint index) public view returns (uint48 userID, uint16 size);	//inject NONSTANDARD NAMING

    function USERIDTOADDRESS44(uint48 id) public view returns (address);	//inject NONSTANDARD NAMING

    function GETDETAILS612(	//inject NONSTANDARD NAMING
        uint tokenId
    )
        public
        view
        returns (
        uint16 proto,
        uint8 quality
    );

    function SETQUALITY366(	//inject NONSTANDARD NAMING
        uint tokenId,
        uint8 quality
    ) public;

    function MINTCARDS596(	//inject NONSTANDARD NAMING
        address to,
        uint16[] memory _protos,
        uint8[] memory _qualities
    )
        public
        returns (uint);

    function MINTCARD737(	//inject NONSTANDARD NAMING
        address to,
        uint16 _proto,
        uint8 _quality
    )
        public
        returns (uint);

    function BURN6(uint tokenId) public;	//inject NONSTANDARD NAMING

    function BATCHSIZE292()	//inject NONSTANDARD NAMING
        public
        view
        returns (uint);
}




contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

                                                                                                                                                                                                                                                                  
    bytes4 private constant _interface_id_erc721_metadata499 = 0x5b5e139f;	//inject NONSTANDARD NAMING

                                                
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;

        // register the supported interfaces to conform to ERC721 via ERC165
        _REGISTERINTERFACE770(_interface_id_erc721_metadata499);
    }

                                                                                                  
    function NAME105() external view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                                                                      
    function SYMBOL26() external view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                                                                                                                                                 
    function TOKENURI642(uint256 tokenId) external view returns (string memory) {	//inject NONSTANDARD NAMING
        require(_EXISTS289(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

                                                                                                                                                                                                                                        
    function _SETTOKENURI974(uint256 tokenId, string memory uri) internal {	//inject NONSTANDARD NAMING
        require(_EXISTS289(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = uri;
    }

                                                                                                                                                                                                                                                                                              
    function _BURN121(address owner, uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        super._BURN121(owner, tokenId);

        // Clear metadata (if any)
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}



contract BatchToken is ERC721Metadata {

    using SafeMath for uint256;

    struct Batch {
        uint48 userID;
        uint16 size;
    }

    mapping(uint48 => address) public userIDToAddress;
    mapping(address => uint48) public addressToUserID;

    uint256 public batchSize;
    uint256 public nextBatch;
    uint256 public tokenCount;

    uint48[] internal ownerIDs;
    uint48[] internal approvedIDs;

    mapping(uint => Batch) public batches;

    uint48 internal userCount = 1;

    mapping(address => uint) internal _balances;

    uint256 internal constant max_length549 = uint(2**256 - 1);	//inject NONSTANDARD NAMING

    constructor(
        uint256 _batchSize,
        string memory name,
        string memory symbol
    )
        public
        ERC721Metadata(name, symbol)
    {
        batchSize = _batchSize;
        ownerIDs.length = max_length549;
        approvedIDs.length = max_length549;
    }

    function _GETUSERID7(address to)	//inject NONSTANDARD NAMING
        internal
        returns (uint48)
    {
        if (to == address(0)) {
            return 0;
        }
        uint48 uID = addressToUserID[to];
        if (uID == 0) {
            require(
                userCount + 1 > userCount,
                "BT: must not overflow"
            );
            uID = userCount++;
            userIDToAddress[uID] = to;
            addressToUserID[to] = uID;
        }
        return uID;
    }

    function _BATCHMINT199(	//inject NONSTANDARD NAMING
        address to,
        uint16 size
    )
        internal
        returns (uint)
    {
        require(
            to != address(0),
            "BT: must not be null"
        );

        require(
            size > 0 && size <= batchSize,
            "BT: size must be within limits"
        );

        uint256 start = nextBatch;
        uint48 uID = _GETUSERID7(to);
        batches[start] = Batch({
            userID: uID,
            size: size
        });
        uint256 end = start.ADD640(size);
        for (uint256 i = start; i < end; i++) {
            emit TRANSFER336(address(0), to, i);
        }
        nextBatch = nextBatch.ADD640(batchSize);
        _balances[to] = _balances[to].ADD640(size);
        tokenCount = tokenCount.ADD640(size);
        return start;
    }

    function GETBATCHSTART864(uint256 tokenId) public view returns (uint) {	//inject NONSTANDARD NAMING
        return tokenId.DIV27(batchSize).MUL119(batchSize);
    }

    function GETBATCH853(uint256 index) public view returns (uint48 userID, uint16 size) {	//inject NONSTANDARD NAMING
        return (batches[index].userID, batches[index].size);
    }

    // Overridden ERC721 functions
    // @OZ: please stop making variables/functions private

    function OWNEROF127(uint256 tokenId)	//inject NONSTANDARD NAMING
        public
        view
        returns (address)
    {
        uint48 uID = ownerIDs[tokenId];
        if (uID == 0) {
            uint256 start = GETBATCHSTART864(tokenId);
            Batch memory b = batches[start];

            require(
                start + b.size > tokenId,
                "BT: token does not exist"
            );

            uID = b.userID;
            require(
                uID != 0,
                "BT: bad batch owner"
            );
        }
        return userIDToAddress[uID];
    }

    function _TRANSFERFROM539(	//inject NONSTANDARD NAMING
        address from,
        address to,
        uint256 tokenId
    )
        internal
    {
        require(
            OWNEROF127(tokenId) == from,
            "BT: transfer of token that is not own"
        );

        require(
            to != address(0),
            "BT: transfer to the zero address"
        );

        require(
            _ISAPPROVEDOROWNER149(msg.sender, tokenId),
            "BT: caller is not owner nor approved"
        );

        _CANCELAPPROVAL409(tokenId);
        _balances[from] = _balances[from].SUB596(1);
        _balances[to] = _balances[to].ADD640(1);
        ownerIDs[tokenId] = _GETUSERID7(to);
        emit TRANSFER336(from, to, tokenId);
    }

    function _BURN121(uint256 tokenId) internal {	//inject NONSTANDARD NAMING

        require(
            _ISAPPROVEDOROWNER149(msg.sender, tokenId),
            "BT: caller is not owner nor approved"
        );

        _CANCELAPPROVAL409(tokenId);
        address owner = OWNEROF127(tokenId);
        _balances[owner] = _balances[owner].SUB596(1);
        ownerIDs[tokenId] = 0;
        tokenCount = tokenCount.SUB596(1);
        emit TRANSFER336(owner, address(0), tokenId);
    }

    function _CANCELAPPROVAL409(uint256 tokenId) internal {	//inject NONSTANDARD NAMING
        if (approvedIDs[tokenId] != 0) {
            approvedIDs[tokenId] = 0;
        }
    }

    function APPROVE921(address to, uint256 tokenId) public {	//inject NONSTANDARD NAMING
        address owner = OWNEROF127(tokenId);

        require(
            to != owner,
            "BT: approval to current owner"
        );

        require(
            msg.sender == owner || ISAPPROVEDFORALL999(owner, msg.sender),
            "BT: approve caller is not owner nor approved for all"
        );

        approvedIDs[tokenId] = _GETUSERID7(to);
        emit APPROVAL97(owner, to, tokenId);
    }

    function _EXISTS289(uint256 tokenId)	//inject NONSTANDARD NAMING
        internal
        view
        returns (bool)
    {
        return OWNEROF127(tokenId) != address(0);
    }

    function GETAPPROVED252(uint256 tokenId)	//inject NONSTANDARD NAMING
        public
        view
        returns (address)
    {
        require(
            _EXISTS289(tokenId),
            "BT: approved query for nonexistent token"
        );

        return userIDToAddress[approvedIDs[tokenId]];
    }

    function TOTALSUPPLY762()	//inject NONSTANDARD NAMING
        public
        view
        returns (uint)
    {
        return tokenCount;
    }

    function BALANCEOF188(address _owner)	//inject NONSTANDARD NAMING
        public
        view
        returns (uint256)
    {
        return _balances[_owner];
    }

}

// solium-disable security/no-inline-assembly









contract NewCards is Ownable, MultiTransfer, BatchToken, InscribableToken {

    uint16 private constant max_uint16315 = 2**16 - 1;	//inject NONSTANDARD NAMING

    uint16[] internal cardProtos;
    uint8[] internal cardQualities;

    struct Season {
        uint16 high;
        uint16 low;
    }

    struct Proto {
        bool locked;
        bool exists;
        uint8 god;
        uint8 cardType;
        uint8 rarity;
        uint8 mana;
        uint8 attack;
        uint8 health;
        uint8 tribe;
    }

    event PROTOUPDATED864(	//inject NONSTANDARD NAMING
        uint16 indexed id
    );

    event SEASONSTARTED899(	//inject NONSTANDARD NAMING
        uint16 indexed id,
        string name,
        uint16 indexed low,
        uint16 indexed high
    );

    event QUALITYCHANGED816(	//inject NONSTANDARD NAMING
        uint256 indexed tokenId,
        uint8 quality,
        address factory
    );

    event CARDSMINTED263(	//inject NONSTANDARD NAMING
        uint256 indexed start,
        address to,
        uint16[] protos,
        uint8[] qualities
    );

    // Value of index proto = season
    uint16[] public protoToSeason;

    address public propertyManager;

    // Array containing all protos
    Proto[] public protos;

    // Array containing all seasons
    Season[] public seasons;

    // Map whether a season is tradeable or not
    mapping(uint256 => bool) public seasonTradable;

    // Map whether a factory has been authorised or not
    mapping(address => mapping(uint256 => bool)) public factoryApproved;

    // Whether a factory is approved to create a particular mythic
    mapping(uint16 => mapping(address => bool)) public mythicApproved;

    // Whether a mythic is tradable
    mapping(uint16 => bool) public mythicTradable;

    // Map whether a mythic exists or not
    mapping(uint16 => bool) public mythicCreated;

    uint16 public constant mythic_threshold683 = 65000;	//inject NONSTANDARD NAMING

    constructor(
        uint256 _batchSize,
        string memory _name,
        string memory _symbol
    )
        public
        BatchToken(_batchSize, _name, _symbol)
    {
        cardProtos.length = max_length549;
        cardQualities.length = max_length549;
        protoToSeason.length = max_length549;
        protos.length = max_length549;
        propertyManager = msg.sender;
    }

    function GETDETAILS612(	//inject NONSTANDARD NAMING
        uint256 tokenId
    )
        public
        view
        returns (uint16 proto, uint8 quality)
    {
        return (cardProtos[tokenId], cardQualities[tokenId]);
    }

    function MINTCARD737(	//inject NONSTANDARD NAMING
        address to,
        uint16 _proto,
        uint8 _quality
    )
        public
        returns (uint id)
    {
        id = _BATCHMINT199(to, 1);
        _VALIDATEPROTO247(_proto);
        cardProtos[id] = _proto;
        cardQualities[id] = _quality;

        uint16[] memory ps = new uint16[](1);
        ps[0] = _proto;

        uint8[] memory qs = new uint8[](1);
        qs[0] = _quality;

        emit CARDSMINTED263(id, to, ps, qs);
        return id;
    }

    function MINTCARDS596(	//inject NONSTANDARD NAMING
        address to,
        uint16[] memory _protos,
        uint8[] memory _qualities
    )
        public
        returns (uint)
    {
        require(
            _protos.length > 0,
            "Core: must be some protos"
        );

        require(
            _protos.length == _qualities.length,
            "Core: must be the same number of protos/qualities"
        );

        uint256 start = _BATCHMINT199(to, uint16(_protos.length));
        _VALIDATEANDSAVEDETAILS366(start, _protos, _qualities);

        emit CARDSMINTED263(start, to, _protos, _qualities);

        return start;
    }

    function ADDFACTORY224(	//inject NONSTANDARD NAMING
        address _factory,
        uint256 _season
    )
        public
        ONLYOWNER453
    {
        require(
            seasons.length >= _season,
            "Core: season must exist"
        );

        require(
            _season > 0,
            "Core: season must not be 0"
        );

        require(
            !factoryApproved[_factory][_season],
            "Core: this factory is already approved"
        );

        require(
            !seasonTradable[_season],
            "Core: season must not be tradable"
        );

        factoryApproved[_factory][_season] = true;
    }

    function APPROVEFORMYTHIC801(	//inject NONSTANDARD NAMING
        address _factory,
        uint16 _mythic
    )
        public
        ONLYOWNER453
    {
        require(
            _mythic >= mythic_threshold683,
            "not a mythic"
        );

        require(
            !mythicApproved[_mythic][_factory],
            "Core: this factory is already approved for this mythic"
        );

        mythicApproved[_mythic][_factory] = true;
    }

    function MAKEMYTHICTRADABLE762(	//inject NONSTANDARD NAMING
        uint16 _mythic
    )
        public
        ONLYOWNER453
    {
        require(
            _mythic >= mythic_threshold683,
            "Core: not a mythic"
        );

        require(
            !mythicTradable[_mythic],
            "Core: must not be tradable already"
        );

        mythicTradable[_mythic] = true;
    }

    function UNLOCKTRADING32(	//inject NONSTANDARD NAMING
        uint256 _season
    )
        public
        ONLYOWNER453
    {
        require(
            _season > 0 && _season <= seasons.length,
            "Core: must be a current season"
        );

        require(
            !seasonTradable[_season],
            "Core: season must not be tradable"
        );

        seasonTradable[_season] = true;
    }

    function _TRANSFERFROM539(	//inject NONSTANDARD NAMING
        address from,
        address to,
        uint256 tokenId
    )
        internal
    {
        require(
            ISTRADABLE528(tokenId),
            "Core: not yet tradable"
        );

        super._TRANSFERFROM539(from, to, tokenId);
    }

    function BURN6(uint256 _tokenId) public {	//inject NONSTANDARD NAMING
        require(
            ISTRADABLE528(_tokenId),
            "Core: not yet tradable"
        );

        super._BURN121(_tokenId);
    }

    function BURNALL763(uint256[] memory tokenIDs) public {	//inject NONSTANDARD NAMING
        for (uint256 i = 0; i < tokenIDs.length; i++) {
            BURN6(tokenIDs[i]);
        }
    }

    function ISTRADABLE528(uint256 _tokenId) public view returns (bool) {	//inject NONSTANDARD NAMING
        uint16 proto = cardProtos[_tokenId];
        if (proto >= mythic_threshold683) {
            return mythicTradable[proto];
        }
        return seasonTradable[protoToSeason[proto]];
    }

    function STARTSEASON259(	//inject NONSTANDARD NAMING
        string memory name,
        uint16 low,
        uint16 high
    )
        public
        ONLYOWNER453
        returns (uint)
    {
        require(
            low > 0,
            "Core: must not be zero proto"
        );

        require(
            high > low,
            "Core: must be a valid range"
        );

        require(
            seasons.length == 0 || low > seasons[seasons.length - 1].high,
            "Core: seasons cannot overlap"
        );

        require(
            mythic_threshold683 > high,
            "Core: cannot go into mythic territory"
        );

        // seasons start at 1
        uint16 id = uint16(seasons.push(Season({ high: high, low: low })));

        uint256 cp;
        assembly { cp := protoToSeason_slot }
        StorageWrite.REPEATUINT16794(cp, low, (high - low) + 1, id);

        emit SEASONSTARTED899(id, name, low, high);

        return id;
    }

    function UPDATEPROTOS359(	//inject NONSTANDARD NAMING
        uint16[] memory _ids,
        uint8[] memory _gods,
        uint8[] memory _cardTypes,
        uint8[] memory _rarities,
        uint8[] memory _manas,
        uint8[] memory _attacks,
        uint8[] memory _healths,
        uint8[] memory _tribes
    ) public ONLYOWNER453 {
        for (uint256 i = 0; i < _ids.length; i++) {
            uint16 id = _ids[i];

            require(
                id > 0,
                "Core: proto must not be zero"
            );

            Proto memory proto = protos[id];
            require(
                !proto.locked,
                "Core: proto is locked"
            );

            protos[id] = Proto({
                locked: false,
                exists: true,
                god: _gods[i],
                cardType: _cardTypes[i],
                rarity: _rarities[i],
                mana: _manas[i],
                attack: _attacks[i],
                health: _healths[i],
                tribe: _tribes[i]
            });
            emit PROTOUPDATED864(id);
        }
    }

    function LOCKPROTOS122(uint16[] memory _ids) public ONLYOWNER453 {	//inject NONSTANDARD NAMING
        require(
            _ids.length > 0,
            "must lock some"
        );

        for (uint256 i = 0; i < _ids.length; i++) {
            uint16 id = _ids[i];
            require(
                id > 0,
                "proto must not be zero"
            );

            Proto storage proto = protos[id];

            require(
                !proto.locked,
                "proto is locked"
            );

            require(
                proto.exists,
                "proto must exist"
            );

            proto.locked = true;
            emit PROTOUPDATED864(id);
        }
    }

    function _VALIDATEANDSAVEDETAILS366(	//inject NONSTANDARD NAMING
        uint256 start,
        uint16[] memory _protos,
        uint8[] memory _qualities
    )
        internal
    {
        _VALIDATEPROTOS731(_protos);

        uint256 cp;
        assembly { cp := cardProtos_slot }
        StorageWrite.UINT16S436(cp, start, _protos);
        uint256 cq;
        assembly { cq := cardQualities_slot }
        StorageWrite.UINT8S318(cq, start, _qualities);
    }

    function _VALIDATEPROTO247(uint16 proto) internal {	//inject NONSTANDARD NAMING
        if (proto >= mythic_threshold683) {
            _CHECKCANCREATEMYTHIC255(proto);
        } else {

            uint256 season = protoToSeason[proto];

            require(
                season != 0,
                "Core: must have season set"
            );

            require(
                factoryApproved[msg.sender][season],
                "Core: must be approved factory for this season"
            );
        }
    }

    function _VALIDATEPROTOS731(uint16[] memory _protos) internal {	//inject NONSTANDARD NAMING
        uint16 maxProto = 0;
        uint16 minProto = max_uint16315;
        for (uint256 i = 0; i < _protos.length; i++) {
            uint16 proto = _protos[i];
            if (proto >= mythic_threshold683) {
                _CHECKCANCREATEMYTHIC255(proto);
            } else {
                if (proto > maxProto) {
                    maxProto = proto;
                }
                if (minProto > proto) {
                    minProto = proto;
                }
            }
        }

        if (maxProto != 0) {
            uint256 season = protoToSeason[maxProto];
            // cards must be from the same season
            require(
                season != 0,
                "Core: must have season set"
            );

            require(
                season == protoToSeason[minProto],
                "Core: can only create cards from the same season"
            );

            require(
                factoryApproved[msg.sender][season],
                "Core: must be approved factory for this season"
            );
        }
    }

    function _CHECKCANCREATEMYTHIC255(uint16 proto) internal {	//inject NONSTANDARD NAMING

        require(
            mythicApproved[proto][msg.sender],
            "Core: not approved to create this mythic"
        );

        require(
            !mythicCreated[proto],
            "Core: mythic has already been created"
        );

        mythicCreated[proto] = true;
    }

    function SETQUALITY366(	//inject NONSTANDARD NAMING
        uint256 _tokenId,
        uint8 _quality
    )
        public
    {
        uint16 proto = cardProtos[_tokenId];
        // wont' be able to change mythic season
        uint256 season = protoToSeason[proto];

        require(
            factoryApproved[msg.sender][season],
            "Core: factory can't change quality of this season"
        );

        cardQualities[_tokenId] = _quality;
        emit QUALITYCHANGED816(_tokenId, _quality, msg.sender);
    }

    function SETPROPERTYMANAGER70(address _manager) public ONLYOWNER453 {	//inject NONSTANDARD NAMING
        propertyManager = _manager;
    }

    function SETPROPERTY942(uint256 _id, bytes32 _key, bytes32 _value) public {	//inject NONSTANDARD NAMING
        require(
            msg.sender == propertyManager,
            "Core: must be property manager"
        );

        _SETPROPERTY292(_id, _key, _value);
    }

    function SETCLASSPROPERTY520(bytes32 _key, bytes32 _value) public {	//inject NONSTANDARD NAMING
        require(
            msg.sender == propertyManager,
            "Core: must be property manager"
        );

        _SETCLASSPROPERTY718(_key, _value);
    }

    string public baseURI = "https://api.immutable.com/asset/";

    function SETBASEURI249(string memory uri) public ONLYOWNER453 {	//inject NONSTANDARD NAMING
        baseURI = uri;
    }

    function TOKENURI642(uint256 tokenId) external view returns (string memory) {	//inject NONSTANDARD NAMING
        return string(abi.encodePacked(
            baseURI,
            String.FROMADDRESS777(address(this)),
            "/",
            String.FROMUINT947(tokenId)
        ));
    }

}


// solium-disable security/no-inline-assembly









contract Cards is Ownable, MultiTransfer, BatchToken, ImmutableToken, InscribableToken {

    uint16 private constant max_uint16315 = 2**16 - 1;	//inject NONSTANDARD NAMING

    uint16[] public cardProtos;
    uint8[] public cardQualities;

    struct Season {
        uint16 high;
        uint16 low;
    }

    struct Proto {
        bool locked;
        bool exists;
        uint8 god;
        uint8 cardType;
        uint8 rarity;
        uint8 mana;
        uint8 attack;
        uint8 health;
        uint8 tribe;
    }

    event PROTOUPDATED864(	//inject NONSTANDARD NAMING
        uint16 indexed id
    );

    event SEASONSTARTED899(	//inject NONSTANDARD NAMING
        uint16 indexed id,
        string name,
        uint16 indexed low,
        uint16 indexed high
    );

    event QUALITYCHANGED816(	//inject NONSTANDARD NAMING
        uint256 indexed tokenId,
        uint8 quality,
        address factory
    );

    event CARDSMINTED263(	//inject NONSTANDARD NAMING
        uint256 indexed start,
        address to,
        uint16[] protos,
        uint8[] qualities
    );

    // Value of index proto = season
    uint16[] public protoToSeason;

    address public propertyManager;

    // Array containing all protos
    Proto[] public protos;

    // Array containing all seasons
    Season[] public seasons;

    // Map whether a season is tradeable or not
    mapping(uint256 => bool) public seasonTradable;

    // Map whether a factory has been authorised or not
    mapping(address => mapping(uint256 => bool)) public factoryApproved;

    // Whether a factory is approved to create a particular mythic
    mapping(uint16 => mapping(address => bool)) public mythicApproved;

    // Whether a mythic is tradable
    mapping(uint16 => bool) public mythicTradable;

    // Map whether a mythic exists or not
    mapping(uint16 => bool) public mythicCreated;

    uint16 public constant mythic_threshold683 = 65000;	//inject NONSTANDARD NAMING

    constructor(
        uint256 _batchSize,
        string memory _name,
        string memory _symbol
    )
        public
        BatchToken(_batchSize, _name, _symbol)
    {
        cardProtos.length = max_length549;
        cardQualities.length = max_length549;
        protoToSeason.length = max_length549;
        protos.length = max_length549;
        propertyManager = msg.sender;
    }

    function GETDETAILS612(	//inject NONSTANDARD NAMING
        uint256 tokenId
    )
        public
        view
        returns (uint16 proto, uint8 quality)
    {
        return (cardProtos[tokenId], cardQualities[tokenId]);
    }

    function MINTCARD737(	//inject NONSTANDARD NAMING
        address to,
        uint16 _proto,
        uint8 _quality
    )
        external
        returns (uint id)
    {
        id = _BATCHMINT199(to, 1);
        _VALIDATEPROTO247(_proto);
        cardProtos[id] = _proto;
        cardQualities[id] = _quality;

        uint16[] memory ps = new uint16[](1);
        ps[0] = _proto;

        uint8[] memory qs = new uint8[](1);
        qs[0] = _quality;

        emit CARDSMINTED263(id, to, ps, qs);
        return id;
    }

    function MINTCARDS596(	//inject NONSTANDARD NAMING
        address to,
        uint16[] calldata _protos,
        uint8[] calldata _qualities
    )
        external
        returns (uint)
    {
        require(
            _protos.length > 0,
            "Core: must be some protos"
        );

        require(
            _protos.length == _qualities.length,
            "Core: must be the same number of protos/qualities"
        );

        uint256 start = _BATCHMINT199(to, uint16(_protos.length));
        _VALIDATEANDSAVEDETAILS366(start, _protos, _qualities);

        emit CARDSMINTED263(start, to, _protos, _qualities);

        return start;
    }

    function ADDFACTORY224(	//inject NONSTANDARD NAMING
        address _factory,
        uint256 _season
    )
        public
        ONLYOWNER453
    {
        require(
            seasons.length >= _season,
            "Core: season must exist"
        );

        require(
            _season > 0,
            "Core: season must not be 0"
        );

        require(
            !factoryApproved[_factory][_season],
            "Core: this factory is already approved"
        );

        require(
            !seasonTradable[_season],
            "Core: season must not be tradable"
        );

        factoryApproved[_factory][_season] = true;
    }

    function APPROVEFORMYTHIC801(	//inject NONSTANDARD NAMING
        address _factory,
        uint16 _mythic
    )
        public
        ONLYOWNER453
    {
        require(
            _mythic >= mythic_threshold683,
            "not a mythic"
        );

        require(
            !mythicApproved[_mythic][_factory],
            "Core: this factory is already approved for this mythic"
        );

        mythicApproved[_mythic][_factory] = true;
    }

    function MAKEMYTHICTRADABLE762(	//inject NONSTANDARD NAMING
        uint16 _mythic
    )
        public
        ONLYOWNER453
    {
        require(
            _mythic >= mythic_threshold683,
            "Core: not a mythic"
        );

        require(
            !mythicTradable[_mythic],
            "Core: must not be tradable already"
        );

        mythicTradable[_mythic] = true;
    }

    function UNLOCKTRADING32(	//inject NONSTANDARD NAMING
        uint256 _season
    )
        public
        ONLYOWNER453
    {
        require(
            _season > 0 && _season <= seasons.length,
            "Core: must be a current season"
        );

        require(
            !seasonTradable[_season],
            "Core: season must not be tradable"
        );

        seasonTradable[_season] = true;
    }

    function TRANSFERFROM301(	//inject NONSTANDARD NAMING
        address from,
        address to,
        uint256 tokenId
    )
        public
    {
        require(
            ISTRADABLE528(tokenId),
            "Core: not yet tradable"
        );

        super.TRANSFERFROM301(from, to, tokenId);
    }

    function BURN6(uint256 _tokenId) public {	//inject NONSTANDARD NAMING
        require(
            ISTRADABLE528(_tokenId),
            "Core: not yet tradable"
        );

        super._BURN121(_tokenId);
    }

    function BURNALL763(uint256[] memory tokenIDs) public {	//inject NONSTANDARD NAMING
        for (uint256 i = 0; i < tokenIDs.length; i++) {
            BURN6(tokenIDs[i]);
        }
    }

    function ISTRADABLE528(uint256 _tokenId) public view returns (bool) {	//inject NONSTANDARD NAMING
        uint16 proto = cardProtos[_tokenId];
        if (proto >= mythic_threshold683) {
            return mythicTradable[proto];
        }
        return seasonTradable[protoToSeason[proto]];
    }

    function STARTSEASON259(	//inject NONSTANDARD NAMING
        string memory name,
        uint16 low,
        uint16 high
    )
        public
        ONLYOWNER453
        returns (uint)
    {
        require(
            low > 0,
            "Core: must not be zero proto"
        );

        require(
            high > low,
            "Core: must be a valid range"
        );

        require(
            seasons.length == 0 || low > seasons[seasons.length - 1].high,
            "Core: seasons cannot overlap"
        );

        require(
            mythic_threshold683 > high,
            "Core: cannot go into mythic territory"
        );

        // seasons start at 1
        uint16 id = uint16(seasons.push(Season({ high: high, low: low })));

        uint256 cp;
        assembly { cp := protoToSeason_slot }
        StorageWrite.REPEATUINT16794(cp, low, (high - low) + 1, id);

        emit SEASONSTARTED899(id, name, low, high);

        return id;
    }

    function UPDATEPROTOS359(	//inject NONSTANDARD NAMING
        uint16[] memory _ids,
        uint8[] memory _gods,
        uint8[] memory _cardTypes,
        uint8[] memory _rarities,
        uint8[] memory _manas,
        uint8[] memory _attacks,
        uint8[] memory _healths,
        uint8[] memory _tribes
    ) public ONLYOWNER453 {
        for (uint256 i = 0; i < _ids.length; i++) {
            uint16 id = _ids[i];

            require(
                id > 0,
                "Core: proto must not be zero"
            );

            Proto memory proto = protos[id];
            require(
                !proto.locked,
                "Core: proto is locked"
            );

            protos[id] = Proto({
                locked: false,
                exists: true,
                god: _gods[i],
                cardType: _cardTypes[i],
                rarity: _rarities[i],
                mana: _manas[i],
                attack: _attacks[i],
                health: _healths[i],
                tribe: _tribes[i]
            });
            emit PROTOUPDATED864(id);
        }
    }

    function LOCKPROTOS122(uint16[] memory _ids) public ONLYOWNER453 {	//inject NONSTANDARD NAMING
        require(
            _ids.length > 0,
            "must lock some"
        );

        for (uint256 i = 0; i < _ids.length; i++) {
            uint16 id = _ids[i];
            require(
                id > 0,
                "proto must not be zero"
            );

            Proto storage proto = protos[id];

            require(
                !proto.locked,
                "proto is locked"
            );

            require(
                proto.exists,
                "proto must exist"
            );

            proto.locked = true;
            emit PROTOUPDATED864(id);
        }
    }

    function _VALIDATEANDSAVEDETAILS366(	//inject NONSTANDARD NAMING
        uint256 start,
        uint16[] memory _protos,
        uint8[] memory _qualities
    )
        internal
    {
        _VALIDATEPROTOS731(_protos);

        uint256 cp;
        assembly { cp := cardProtos_slot }
        StorageWrite.UINT16S436(cp, start, _protos);
        uint256 cq;
        assembly { cq := cardQualities_slot }
        StorageWrite.UINT8S318(cq, start, _qualities);
    }

    function _VALIDATEPROTO247(uint16 proto) internal {	//inject NONSTANDARD NAMING
        if (proto >= mythic_threshold683) {
            _CHECKCANCREATEMYTHIC255(proto);
        } else {

            uint256 season = protoToSeason[proto];

            require(
                season != 0,
                "Core: must have season set"
            );

            require(
                factoryApproved[msg.sender][season],
                "Core: must be approved factory for this season"
            );
        }
    }

    function _VALIDATEPROTOS731(uint16[] memory _protos) internal {	//inject NONSTANDARD NAMING
        uint16 maxProto = 0;
        uint16 minProto = max_uint16315;
        for (uint256 i = 0; i < _protos.length; i++) {
            uint16 proto = _protos[i];
            if (proto >= mythic_threshold683) {
                _CHECKCANCREATEMYTHIC255(proto);
            } else {
                if (proto > maxProto) {
                    maxProto = proto;
                }
                if (minProto > proto) {
                    minProto = proto;
                }
            }
        }

        if (maxProto != 0) {
            uint256 season = protoToSeason[maxProto];
            // cards must be from the same season
            require(
                season != 0,
                "Core: must have season set"
            );

            require(
                season == protoToSeason[minProto],
                "Core: can only create cards from the same season"
            );

            require(
                factoryApproved[msg.sender][season],
                "Core: must be approved factory for this season"
            );
        }
    }

    function _CHECKCANCREATEMYTHIC255(uint16 proto) internal {	//inject NONSTANDARD NAMING

        require(
            mythicApproved[proto][msg.sender],
            "Core: not approved to create this mythic"
        );

        require(
            !mythicCreated[proto],
            "Core: mythic has already been created"
        );

        mythicCreated[proto] = true;
    }

    function SETQUALITY366(	//inject NONSTANDARD NAMING
        uint256 _tokenId,
        uint8 _quality
    )
        public
    {
        uint16 proto = cardProtos[_tokenId];
        // wont' be able to change mythic season
        uint256 season = protoToSeason[proto];

        require(
            factoryApproved[msg.sender][season],
            "Core: factory can't change quality of this season"
        );

        cardQualities[_tokenId] = _quality;
        emit QUALITYCHANGED816(_tokenId, _quality, msg.sender);
    }

    function SETPROPERTYMANAGER70(address _manager) public ONLYOWNER453 {	//inject NONSTANDARD NAMING
        propertyManager = _manager;
    }

    function SETPROPERTY942(uint256 _id, bytes32 _key, bytes32 _value) public {	//inject NONSTANDARD NAMING
        require(
            msg.sender == propertyManager,
            "Core: must be property manager"
        );

        _SETPROPERTY292(_id, _key, _value);
    }

    function SETCLASSPROPERTY520(bytes32 _key, bytes32 _value) public {	//inject NONSTANDARD NAMING
        require(
            msg.sender == propertyManager,
            "Core: must be property manager"
        );

        _SETCLASSPROPERTY718(_key, _value);
    }

}



contract BatchWrapper is NewCards {

    uint16 private constant max_uint16315 = 2**16 - 1;	//inject NONSTANDARD NAMING
    Cards public old;
    bool public migrating;

    constructor(
        Cards _old,
        uint256 _batchSize,
        string memory _name,
        string memory _symbol
    ) public NewCards(_batchSize, _name, _symbol) {
        old = _old;
    }

    function SETMIGRATING202(bool _migrating) public ONLYOWNER453 {	//inject NONSTANDARD NAMING
        migrating = _migrating;
    }

    function COPYUNTIL891(uint gasThreshold) public {	//inject NONSTANDARD NAMING
        while (gasleft() > gasThreshold) {
            COPYNEXTBATCH144();
        }
    }

    function MINTCARDS596(address _to, uint16[] memory _protos, uint8[] memory _qualities) public returns (uint id) {	//inject NONSTANDARD NAMING
        require(!migrating, "must not be migrating");
        super.MINTCARDS596(_to, _protos, _qualities);
    }

    function MINTCARD737(address _to, uint16 _proto, uint8 _quality) public returns (uint id) {	//inject NONSTANDARD NAMING
        require(!migrating, "must not be migrating");
        super.MINTCARD737(_to, _proto, _quality);
    }

    // copy all batches from the old contracts
    // leave ids intact
    function COPYNEXTBATCH144() public {	//inject NONSTANDARD NAMING
        require(migrating, "must be migrating");
        uint256 start = nextBatch;
        (uint48 userID, uint16 size) = old.batches(start);
        require(size > 0 && userID > 0, "incorrect batch or limit reached");
        if (old.cardProtos(start) != 0) {
            address to = old.userIDToAddress(userID);
            uint48 uID = _GETUSERID7(to);
            batches[start] = Batch({
                userID: uID,
                size: size
            });
            uint256 end = start.ADD640(size);
            for (uint256 i = start; i < end; i++) {
                emit TRANSFER336(address(0), to, i);
            }
            _balances[to] = _balances[to].ADD640(size);
            tokenCount = tokenCount.ADD640(size);
        }
        nextBatch = nextBatch.ADD640(batchSize);
    }

    function ISOLD374(uint _tokenId) public view returns (bool) {	//inject NONSTANDARD NAMING
        require(_EXISTS289(_tokenId), "card does not exist");
        return cardProtos[_tokenId] == 0;
    }

    function GETPROTO912(uint _tokenId) public view returns (uint16) {	//inject NONSTANDARD NAMING
        return ISOLD374(_tokenId) ? old.cardProtos(_tokenId) : cardProtos[_tokenId];
    }

    function GETQUALITY41(uint _tokenId) public view returns (uint8) {	//inject NONSTANDARD NAMING
        return ISOLD374(_tokenId) ? old.cardQualities(_tokenId) : cardQualities[_tokenId];
    }

    function GETDETAILS612(uint256 tokenId) public view returns (uint16 proto, uint8 quality) {	//inject NONSTANDARD NAMING
        return ISOLD374(tokenId) ? old.GETDETAILS612(tokenId) : (cardProtos[tokenId], cardQualities[tokenId]);
    }

    function ISTRADABLE528(uint256 _tokenId) public view returns (bool) {	//inject NONSTANDARD NAMING
        uint16 proto = GETPROTO912(_tokenId);
        if (proto >= mythic_threshold683) {
            return mythicTradable[proto];
        }
        return seasonTradable[protoToSeason[proto]];
    }

    function _TRANSFERFROM539(address from, address to, uint tokenId) internal {	//inject NONSTANDARD NAMING
        require(
            ISTRADABLE528(tokenId),
            "BW: not yet tradable"
        );
        super._TRANSFERFROM539(from, to, tokenId);
    }

    // update validate protos to check if a proto is 0
    // prevent untradable cards
    function _VALIDATEPROTOS731(uint16[] memory _protos) internal {	//inject NONSTANDARD NAMING

        uint16 maxProto = 0;
        uint16 minProto = max_uint16315;
        for (uint256 i = 0; i < _protos.length; i++) {
            uint16 proto = _protos[i];
            if (proto >= mythic_threshold683) {
                _CHECKCANCREATEMYTHIC255(proto);
            } else {
                require(proto != 0, "proto is zero");
                if (proto > maxProto) {
                    maxProto = proto;
                }
                if (minProto > proto) {
                    minProto = proto;
                }
            }
        }

        if (maxProto != 0) {
            uint256 season = protoToSeason[maxProto];
            // cards must be from the same season
            require(
                season != 0,
                "Core: must have season set"
            );

            require(
                season == protoToSeason[minProto],
                "Core: can only create cards from the same season"
            );

            require(
                factoryApproved[msg.sender][season],
                "Core: must be approved factory for this season"
            );
        }
    }

}