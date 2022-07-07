                                                                 

pragma solidity 0.5.10;


contract Context {
    
    
    constructor () internal { }
    

    function _MSGSENDER793() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA330() internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; 
        return msg.data;
    }
}

interface IERC20 {
    
    function TOTALSUPPLY908() external view returns (uint256);	//inject NONSTANDARD NAMING

    
    function BALANCEOF227(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

    
    function TRANSFER744(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

    
    function ALLOWANCE643(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

    
    function APPROVE357(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

    
    function TRANSFERFROM570(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

    
    event TRANSFER432(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

    
    event APPROVAL431(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

library SafeMath {
    
    function ADD803(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    
    function SUB97(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB97(a, b, "SafeMath: subtraction overflow");
    }

    
    function SUB97(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    
    function MUL111(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        
        
        
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    
    function DIV358(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV358(a, b, "SafeMath: division by zero");
    }

    
    function DIV358(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        
        require(b > 0, errorMessage);
        uint256 c = a / b;
        

        return c;
    }

    
    function MOD464(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD464(a, b, "SafeMath: modulo by zero");
    }

    
    function MOD464(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    
    function TOTALSUPPLY908() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

    
    function BALANCEOF227(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

    
    function TRANSFER744(address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER927(_MSGSENDER793(), recipient, amount);
        return true;
    }

    
    function ALLOWANCE643(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

    
    function APPROVE357(address spender, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE171(_MSGSENDER793(), spender, amount);
        return true;
    }

    
    function TRANSFERFROM570(address sender, address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER927(sender, recipient, amount);
        _APPROVE171(sender, _MSGSENDER793(), _allowances[sender][_MSGSENDER793()].SUB97(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    
    function INCREASEALLOWANCE99(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE171(_MSGSENDER793(), spender, _allowances[_MSGSENDER793()][spender].ADD803(addedValue));
        return true;
    }

    
    function DECREASEALLOWANCE633(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE171(_MSGSENDER793(), spender, _allowances[_MSGSENDER793()][spender].SUB97(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    
    function _TRANSFER927(address sender, address recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB97(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD803(amount);
        emit TRANSFER432(sender, recipient, amount);
    }

    
    function _MINT736(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD803(amount);
        _balances[account] = _balances[account].ADD803(amount);
        emit TRANSFER432(address(0), account, amount);
    }

     
    function _BURN826(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].SUB97(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB97(amount);
        emit TRANSFER432(account, address(0), amount);
    }

    
    function _APPROVE171(address owner, address spender, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL431(owner, spender, amount);
    }

    
    function _BURNFROM936(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        _BURN826(account, amount);
        _APPROVE171(account, _MSGSENDER793(), _allowances[account][_MSGSENDER793()].SUB97(amount, "ERC20: burn amount exceeds allowance"));
    }
}

library BytesLib {
    function CONCAT636(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        bytes memory tempBytes;

        assembly {
            
            
            tempBytes := mload(0x40)

            
            
            let length := mload(_preBytes)
            mstore(tempBytes, length)

            
            
            
            let mc := add(tempBytes, 0x20)
            
            
            let end := add(mc, length)

            for {
                
                
                let cc := add(_preBytes, 0x20)
            } lt(mc, end) {
                
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } {
                
                
                mstore(mc, mload(cc))
            }

            
            
            
            length := mload(_postBytes)
            mstore(tempBytes, add(length, mload(tempBytes)))

            
            
            mc := end
            
            
            end := add(mc, length)

            for {
                let cc := add(_postBytes, 0x20)
            } lt(mc, end) {
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } {
                mstore(mc, mload(cc))
            }

            
            
            
            
            
            mstore(0x40, and(
                add(add(end, iszero(add(length, mload(_preBytes)))), 31),
                not(31) 
            ))
        }

        return tempBytes;
    }

    function CONCATSTORAGE846(bytes storage _preBytes, bytes memory _postBytes) internal {	//inject NONSTANDARD NAMING
        assembly {
            
            
            
            let fslot := sload(_preBytes_slot)
            
            
            
            
            
            
            
            let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
            let mlength := mload(_postBytes)
            let newlength := add(slength, mlength)
            
            
            
            switch add(lt(slength, 32), lt(newlength, 32))
            case 2 {
                
                
                
                sstore(
                    _preBytes_slot,
                    
                    
                    add(
                        
                        
                        fslot,
                        add(
                            mul(
                                div(
                                    
                                    mload(add(_postBytes, 0x20)),
                                    
                                    exp(0x100, sub(32, mlength))
                        ),
                        
                        
                        exp(0x100, sub(32, newlength))
                        ),
                        
                        
                        mul(mlength, 2)
                        )
                    )
                )
            }
            case 1 {
                
                
                
                mstore(0x0, _preBytes_slot)
                let sc := add(keccak256(0x0, 0x20), div(slength, 32))

                
                sstore(_preBytes_slot, add(mul(newlength, 2), 1))

                
                
                
                
                
                
                
                

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
                
                mstore(0x0, _preBytes_slot)
                
                let sc := add(keccak256(0x0, 0x20), div(slength, 32))

                
                sstore(_preBytes_slot, add(mul(newlength, 2), 1))

                
                
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

    function SLICE479(bytes memory _bytes, uint _start, uint _length) internal  pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(_bytes.length >= (_start + _length), "Slice out of bounds");

        bytes memory tempBytes;

        assembly {
            switch iszero(_length)
            case 0 {
                
                
                tempBytes := mload(0x40)

                
                
                
                
                
                
                
                
                let lengthmod := and(_length, 31)

                
                
                
                
                let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
                let end := add(mc, _length)

                for {
                    
                    
                    let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
                } lt(mc, end) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    mstore(mc, mload(cc))
                }

                mstore(tempBytes, _length)

                
                
                mstore(0x40, and(add(mc, 31), not(31)))
            }
            
            default {
                tempBytes := mload(0x40)

                mstore(0x40, add(tempBytes, 0x20))
            }
        }

        return tempBytes;
    }

    function TOADDRESS666(bytes memory _bytes, uint _start) internal  pure returns (address) {	//inject NONSTANDARD NAMING
        require(_bytes.length >= (_start + 20), "Address conversion out of bounds.");
        address tempAddress;

        assembly {
            tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
        }

        return tempAddress;
    }

    function TOUINT411(bytes memory _bytes, uint _start) internal  pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(_bytes.length >= (_start + 32), "Uint conversion out of bounds.");
        uint256 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x20), _start))
        }

        return tempUint;
    }

    function EQUAL334(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        bool success = true;

        assembly {
            let length := mload(_preBytes)

            
            switch eq(length, mload(_postBytes))
            case 1 {
                
                
                
                
                let cb := 1

                let mc := add(_preBytes, 0x20)
                let end := add(mc, length)

                for {
                    let cc := add(_postBytes, 0x20)
                    
                    
                } eq(add(lt(mc, end), cb), 2) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    
                    if iszero(eq(mload(mc), mload(cc))) {
                        
                        success := 0
                        cb := 0
                    }
                }
            }
            default {
                
                success := 0
            }
        }

        return success;
    }

    function EQUALSTORAGE265(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {	//inject NONSTANDARD NAMING
        bool success = true;

        assembly {
            
            let fslot := sload(_preBytes_slot)
            
            let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
            let mlength := mload(_postBytes)

            
            switch eq(slength, mlength)
            case 1 {
                
                
                
                if iszero(iszero(slength)) {
                    switch lt(slength, 32)
                    case 1 {
                        
                        fslot := mul(div(fslot, 0x100), 0x100)

                        if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
                            
                            success := 0
                        }
                    }
                    default {
                        
                        
                        
                        
                        let cb := 1

                        
                        mstore(0x0, _preBytes_slot)
                        let sc := keccak256(0x0, 0x20)

                        let mc := add(_postBytes, 0x20)
                        let end := add(mc, mlength)

                        
                        
                        for {} eq(add(lt(mc, end), cb), 2) {
                            sc := add(sc, 1)
                            mc := add(mc, 0x20)
                        } {
                            if iszero(eq(sload(sc), mload(mc))) {
                                
                                success := 0
                                cb := 0
                            }
                        }
                    }
                }
            }
            default {
                
                success := 0
            }
        }

        return success;
    }

    function TOBYTES32571(bytes memory _source) pure internal returns (bytes32 result) {	//inject NONSTANDARD NAMING
        bytes memory tempEmptyStringTest = bytes(_source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(_source, 32))
        }
    }
}

library BTCUtils {
    using BytesLib for bytes;
    using SafeMath for uint256;

    
    uint256 public constant diff1_target719 = 0xffff0000000000000000000000000000000000000000000000000000;	//inject NONSTANDARD NAMING

    uint256 public constant retarget_period820 = 2 * 7 * 24 * 60 * 60;  	//inject NONSTANDARD NAMING
    uint256 public constant retarget_period_blocks665 = 2016;  	//inject NONSTANDARD NAMING

    
    
    

    
    
    
    
    function DETERMINEVARINTDATALENGTH811(bytes memory _flag) internal pure returns (uint8) {	//inject NONSTANDARD NAMING
        if (uint8(_flag[0]) == 0xff) {
            return 8;  
        }
        if (uint8(_flag[0]) == 0xfe) {
            return 4;  
        }
        if (uint8(_flag[0]) == 0xfd) {
            return 2;  
        }

        return 0;  
    }

    
    
    
    
    function REVERSEENDIANNESS18(bytes memory _b) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        bytes memory _newValue = new bytes(_b.length);

        for (uint i = 0; i < _b.length; i++) {
            _newValue[_b.length - i - 1] = _b[i];
        }

        return _newValue;
    }

    
    
    
    
    function BYTESTOUINT790(bytes memory _b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 _number;

        for (uint i = 0; i < _b.length; i++) {
            _number = _number + uint8(_b[i]) * (2 ** (8 * (_b.length - (i + 1))));
        }

        return _number;
    }

    
    
    
    
    function LASTBYTES156(bytes memory _b, uint256 _num) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        uint256 _start = _b.length.SUB97(_num);

        return _b.SLICE479(_start, _num);
    }

    
    
    
    
    function HASH160454(bytes memory _b) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        return abi.encodePacked(ripemd160(abi.encodePacked(sha256(_b))));
    }

    
    
    
    
    function HASH256986(bytes memory _b) internal pure returns (bytes32) {	//inject NONSTANDARD NAMING
        return abi.encodePacked(sha256(abi.encodePacked(sha256(_b)))).TOBYTES32571();
    }

    
    
    

    
    
    
    
    
    function EXTRACTINPUTATINDEX738(bytes memory _vin, uint8 _index) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        uint256 _len;
        bytes memory _remaining;

        uint256 _offset = 1;

        for (uint8 _i = 0; _i < _index; _i ++) {
            _remaining = _vin.SLICE479(_offset, _vin.length - _offset);
            _len = DETERMINEINPUTLENGTH677(_remaining);
            _offset = _offset + _len;
        }

        _remaining = _vin.SLICE479(_offset, _vin.length - _offset);
        _len = DETERMINEINPUTLENGTH677(_remaining);
        return _vin.SLICE479(_offset, _len);
    }

    
    
    
    
    function ISLEGACYINPUT163(bytes memory _input) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        return keccak256(_input.SLICE479(36, 1)) != keccak256(hex"00");
    }

    
    
    
    
    function DETERMINEINPUTLENGTH677(bytes memory _input) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint8 _varIntDataLen;
        uint256 _scriptSigLen;
        (_varIntDataLen, _scriptSigLen) = EXTRACTSCRIPTSIGLEN905(_input);
        return 36 + 1 + _varIntDataLen + _scriptSigLen + 4;
    }

    
    
    
    
    function EXTRACTSEQUENCELELEGACY251(bytes memory _input) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        uint8 _varIntDataLen;
        uint256 _scriptSigLen;
        (_varIntDataLen, _scriptSigLen) = EXTRACTSCRIPTSIGLEN905(_input);
        return _input.SLICE479(36 + 1 + _varIntDataLen + _scriptSigLen, 4);
    }

    
    
    
    
    function EXTRACTSEQUENCELEGACY692(bytes memory _input) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
        bytes memory _leSeqence = EXTRACTSEQUENCELELEGACY251(_input);
        bytes memory _beSequence = REVERSEENDIANNESS18(_leSeqence);
        return uint32(BYTESTOUINT790(_beSequence));
    }
    
    
    
    
    function EXTRACTSCRIPTSIG435(bytes memory _input) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        uint8 _varIntDataLen;
        uint256 _scriptSigLen;
        (_varIntDataLen, _scriptSigLen) = EXTRACTSCRIPTSIGLEN905(_input);
        return _input.SLICE479(36, 1 + _varIntDataLen + _scriptSigLen);
    }

    
    
    
    
    function EXTRACTSCRIPTSIGLEN905(bytes memory _input) internal pure returns (uint8, uint256) {	//inject NONSTANDARD NAMING
        bytes memory _varIntTag = _input.SLICE479(36, 1);
        uint8 _varIntDataLen = DETERMINEVARINTDATALENGTH811(_varIntTag);
        uint256 _len;
        if (_varIntDataLen == 0) {
            _len = uint8(_varIntTag[0]);
        } else {
            _len = BYTESTOUINT790(REVERSEENDIANNESS18(_input.SLICE479(36 + 1, _varIntDataLen)));
        }
        return (_varIntDataLen, _len);
    }


    
    
    

    
    
    
    
    function EXTRACTSEQUENCELEWITNESS46(bytes memory _input) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _input.SLICE479(37, 4);
    }

    
    
    
    
    function EXTRACTSEQUENCEWITNESS1000(bytes memory _input) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
        bytes memory _leSeqence = EXTRACTSEQUENCELEWITNESS46(_input);
        bytes memory _inputeSequence = REVERSEENDIANNESS18(_leSeqence);
        return uint32(BYTESTOUINT790(_inputeSequence));
    }

    
    
    
    
    function EXTRACTOUTPOINT770(bytes memory _input) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _input.SLICE479(0, 36);
    }

    
    
    
    
    function EXTRACTINPUTTXIDLE232(bytes memory _input) internal pure returns (bytes32) {	//inject NONSTANDARD NAMING
        return _input.SLICE479(0, 32).TOBYTES32571();
    }

    
    
    
    
    function EXTRACTINPUTTXID926(bytes memory _input) internal pure returns (bytes32) {	//inject NONSTANDARD NAMING
        bytes memory _leId = abi.encodePacked(EXTRACTINPUTTXIDLE232(_input));
        bytes memory _beId = REVERSEENDIANNESS18(_leId);
        return _beId.TOBYTES32571();
    }

    
    
    
    
    function EXTRACTTXINDEXLE408(bytes memory _input) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _input.SLICE479(32, 4);
    }

    
    
    
    
    function EXTRACTTXINDEX998(bytes memory _input) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
        bytes memory _leIndex = EXTRACTTXINDEXLE408(_input);
        bytes memory _beIndex = REVERSEENDIANNESS18(_leIndex);
        return uint32(BYTESTOUINT790(_beIndex));
    }

    
    
    

    
    
    
    
    function DETERMINEOUTPUTLENGTH588(bytes memory _output) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint8 _len = uint8(_output.SLICE479(8, 1)[0]);
        require(_len < 0xfd, "Multi-byte VarInts not supported");

        return _len + 8 + 1; 
    }

    
    
    
    
    
    function EXTRACTOUTPUTATINDEX182(bytes memory _vout, uint8 _index) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        uint256 _len;
        bytes memory _remaining;

        uint256 _offset = 1;

        for (uint8 _i = 0; _i < _index; _i ++) {
            _remaining = _vout.SLICE479(_offset, _vout.length - _offset);
            _len = DETERMINEOUTPUTLENGTH588(_remaining);
            _offset = _offset + _len;
        }

        _remaining = _vout.SLICE479(_offset, _vout.length - _offset);
        _len = DETERMINEOUTPUTLENGTH588(_remaining);
        return _vout.SLICE479(_offset, _len);
    }

    
    
    
    
    function EXTRACTOUTPUTSCRIPTLEN88(bytes memory _output) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _output.SLICE479(8, 1);
    }

    
    
    
    
    function EXTRACTVALUELE862(bytes memory _output) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _output.SLICE479(0, 8);
    }

    
    
    
    
    function EXTRACTVALUE239(bytes memory _output) internal pure returns (uint64) {	//inject NONSTANDARD NAMING
        bytes memory _leValue = EXTRACTVALUELE862(_output);
        bytes memory _beValue = REVERSEENDIANNESS18(_leValue);
        return uint64(BYTESTOUINT790(_beValue));
    }

    
    
    
    
    function EXTRACTOPRETURNDATA540(bytes memory _output) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        if (keccak256(_output.SLICE479(9, 1)) != keccak256(hex"6a")) {
            return hex"";
        }
        bytes memory _dataLen = _output.SLICE479(10, 1);
        return _output.SLICE479(11, BYTESTOUINT790(_dataLen));
    }

    
    
    
    
    function EXTRACTHASH570(bytes memory _output) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        if (uint8(_output.SLICE479(9, 1)[0]) == 0) {
            uint256 _len = uint8(EXTRACTOUTPUTSCRIPTLEN88(_output)[0]) - 2;
            
            if (uint8(_output.SLICE479(10, 1)[0]) != uint8(_len)) {
                return hex"";
            }
            return _output.SLICE479(11, _len);
        } else {
            bytes32 _tag = keccak256(_output.SLICE479(8, 3));
            
            if (_tag == keccak256(hex"1976a9")) {
                
                if (uint8(_output.SLICE479(11, 1)[0]) != 0x14 ||
                    keccak256(_output.SLICE479(_output.length - 2, 2)) != keccak256(hex"88ac")) {
                    return hex"";
                }
                return _output.SLICE479(12, 20);
            
            } else if (_tag == keccak256(hex"17a914")) {
                
                if (uint8(_output.SLICE479(_output.length - 1, 1)[0]) != 0x87) {
                    return hex"";
                }
                return _output.SLICE479(11, 20);
            }
        }
        return hex"";  
    }

    
    
    


    
    
    
    
    function VALIDATEVIN629(bytes memory _vin) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        uint256 _offset = 1;
        uint8 _nIns = uint8(_vin.SLICE479(0, 1)[0]);

        
        if (_nIns >= 0xfd || _nIns == 0) {
            return false;
        }

        for (uint8 i = 0; i < _nIns; i++) {
            
            
            _offset += DETERMINEINPUTLENGTH677(_vin.SLICE479(_offset, _vin.length - _offset));

            
            if (_offset > _vin.length) {
                return false;
            }
        }

        
        return _offset == _vin.length;
    }

    
    
    
    
    function VALIDATEVOUT976(bytes memory _vout) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        uint256 _offset = 1;
        uint8 _nOuts = uint8(_vout.SLICE479(0, 1)[0]);

        
        if (_nOuts >= 0xfd || _nOuts == 0) {
            return false;
        }

        for (uint8 i = 0; i < _nOuts; i++) {
            
            
            _offset += DETERMINEOUTPUTLENGTH588(_vout.SLICE479(_offset, _vout.length - _offset));

            
            if (_offset > _vout.length) {
                return false;
            }
        }

        
        return _offset == _vout.length;
    }



    
    
    

    
    
    
    
    function EXTRACTMERKLEROOTLE545(bytes memory _header) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _header.SLICE479(36, 32);
    }

    
    
    
    
    function EXTRACTMERKLEROOTBE364(bytes memory _header) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        return REVERSEENDIANNESS18(EXTRACTMERKLEROOTLE545(_header));
    }

    
    
    
    
    function EXTRACTTARGET28(bytes memory _header) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        bytes memory _m = _header.SLICE479(72, 3);
        uint8 _e = uint8(_header[75]);
        uint256 _mantissa = BYTESTOUINT790(REVERSEENDIANNESS18(_m));
        uint _exponent = _e - 3;

        return _mantissa * (256 ** _exponent);
    }

    
    
    
    
    
    function CALCULATEDIFFICULTY733(uint256 _target) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        
        return diff1_target719.DIV358(_target);
    }

    
    
    
    
    function EXTRACTPREVBLOCKLE989(bytes memory _header) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _header.SLICE479(4, 32);
    }

    
    
    
    
    function EXTRACTPREVBLOCKBE985(bytes memory _header) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        return REVERSEENDIANNESS18(EXTRACTPREVBLOCKLE989(_header));
    }

    
    
    
    
    function EXTRACTTIMESTAMPLE896(bytes memory _header) internal pure returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _header.SLICE479(68, 4);
    }

    
    
    
    
    function EXTRACTTIMESTAMP636(bytes memory _header) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
        return uint32(BYTESTOUINT790(REVERSEENDIANNESS18(EXTRACTTIMESTAMPLE896(_header))));
    }

    
    
    
    
    function EXTRACTDIFFICULTY209(bytes memory _header) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return CALCULATEDIFFICULTY733(EXTRACTTARGET28(_header));
    }

    
    
    
    
    function _HASH256MERKLESTEP183(bytes memory _a, bytes memory _b) internal pure returns (bytes32) {	//inject NONSTANDARD NAMING
        return HASH256986(abi.encodePacked(_a, _b));
    }

    
    
    
    
    
    function VERIFYHASH256MERKLE9(bytes memory _proof, uint _index) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        
        if (_proof.length % 32 != 0) {
            return false;
        }

        
        if (_proof.length == 32) {
            return true;
        }

        
        if (_proof.length == 64) {
            return false;
        }

        uint _idx = _index;
        bytes32 _root = _proof.SLICE479(_proof.length - 32, 32).TOBYTES32571();
        bytes32 _current = _proof.SLICE479(0, 32).TOBYTES32571();

        for (uint i = 1; i < (_proof.length.DIV358(32)) - 1; i++) {
            if (_idx % 2 == 1) {
                _current = _HASH256MERKLESTEP183(_proof.SLICE479(i * 32, 32), abi.encodePacked(_current));
            } else {
                _current = _HASH256MERKLESTEP183(abi.encodePacked(_current), _proof.SLICE479(i * 32, 32));
            }
            _idx = _idx >> 1;
        }
        return _current == _root;
    }

    
    
    
    
    
    
    
    function RETARGETALGORITHM78(	//inject NONSTANDARD NAMING
        uint256 _previousTarget,
        uint256 _firstTimestamp,
        uint256 _secondTimestamp
    ) internal pure returns (uint256) {
        uint256 _elapsedTime = _secondTimestamp.SUB97(_firstTimestamp);

        
        if (_elapsedTime < retarget_period820.DIV358(4)) {
            _elapsedTime = retarget_period820.DIV358(4);
        }
        if (_elapsedTime > retarget_period820.MUL111(4)) {
            _elapsedTime = retarget_period820.MUL111(4);
        }

        

        uint256 _adjusted = _previousTarget.DIV358(65536).MUL111(_elapsedTime);
        return _adjusted.DIV358(retarget_period820).MUL111(65536);
    }
}

interface FundsInterface {
    function LENDER92(bytes32) external view returns (address);	//inject NONSTANDARD NAMING
    function CUSTOM642(bytes32) external view returns (bool);	//inject NONSTANDARD NAMING
    function DEPOSIT909(bytes32, uint256) external;	//inject NONSTANDARD NAMING
    function DECREASETOTALBORROW522(uint256) external;	//inject NONSTANDARD NAMING
    function CALCGLOBALINTEREST773() external;	//inject NONSTANDARD NAMING
}

interface SalesInterface {
    function SALEINDEXBYLOAN897(bytes32, uint256) external returns(bytes32);	//inject NONSTANDARD NAMING
    function SETTLEMENTEXPIRATION526(bytes32) external view returns (uint256);	//inject NONSTANDARD NAMING
    function ACCEPTED582(bytes32) external view returns (bool);	//inject NONSTANDARD NAMING
    function NEXT199(bytes32) external view returns (uint256);	//inject NONSTANDARD NAMING
    function CREATE943(bytes32, address, address, address, address, bytes32, bytes32, bytes32, bytes32, bytes20) external returns(bytes32);	//inject NONSTANDARD NAMING
}

interface CollateralInterface {
    function ONDEMANDSPV389() external view returns(address);	//inject NONSTANDARD NAMING
    function COLLATERAL382(bytes32 loan) external view returns (uint256);	//inject NONSTANDARD NAMING
    function REFUNDABLECOLLATERAL879(bytes32 loan) external view returns (uint256);	//inject NONSTANDARD NAMING
    function SEIZABLECOLLATERAL368(bytes32 loan) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TEMPORARYREFUNDABLECOLLATERAL760(bytes32 loan) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TEMPORARYSEIZABLECOLLATERAL228(bytes32 loan) external view returns (uint256);	//inject NONSTANDARD NAMING
    function SETCOLLATERAL164(bytes32 loan, uint256 refundableCollateral_, uint256 seizableCollateral_) external;	//inject NONSTANDARD NAMING
    function REQUESTSPV477(bytes32 loan) external;	//inject NONSTANDARD NAMING
    function CANCELSPV463(bytes32 loan) external;	//inject NONSTANDARD NAMING
}

contract DSMath {
    function ADD803(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require((z = x + y) >= x);
    }
    function SUB97(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require((z = x - y) <= x);
    }
    function MUL111(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require(y == 0 || (z = x * y) / y == x);
    }
    function DIV358(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
        require(b > 0);
        c = a / b;
    }

    function MIN456(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        return x <= y ? x : y;
    }
    function MAX638(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        return x >= y ? x : y;
    }
    function IMIN865(int x, int y) internal pure returns (int z) {	//inject NONSTANDARD NAMING
        return x <= y ? x : y;
    }
    function IMAX990(int x, int y) internal pure returns (int z) {	//inject NONSTANDARD NAMING
        return x >= y ? x : y;
    }

    uint constant col735  = 10 ** 8;	//inject NONSTANDARD NAMING
    uint constant wad510  = 10 ** 18;	//inject NONSTANDARD NAMING
    uint constant ray271  = 10 ** 27;	//inject NONSTANDARD NAMING

    function CMUL87(uint x, uint y) public pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = ADD803(MUL111(x, y), col735 / 2) / col735;
    }
    function WMUL533(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = ADD803(MUL111(x, y), wad510 / 2) / wad510;
    }
    function RMUL965(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = ADD803(MUL111(x, y), ray271 / 2) / ray271;
    }
    function CDIV416(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = ADD803(MUL111(x, col735), y / 2) / y;
    }
    function WDIV128(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = ADD803(MUL111(x, wad510), y / 2) / y;
    }
    function RDIV519(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = ADD803(MUL111(x, ray271), y / 2) / y;
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    function RPOW933(uint x, uint n) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = n % 2 != 0 ? x : ray271;

        for (n /= 2; n != 0; n /= 2) {
            x = RMUL965(x, x);

            if (n % 2 != 0) {
                z = RMUL965(z, x);
            }
        }
    }
}

contract Medianizer {
    function PEEK685() external view returns (bytes32, bool);	//inject NONSTANDARD NAMING
    function READ913() external returns (bytes32);	//inject NONSTANDARD NAMING
    function POKE561() external;	//inject NONSTANDARD NAMING
    function POKE561(bytes32) external;	//inject NONSTANDARD NAMING
    function FUND172 (uint256 amount, ERC20 token) external;	//inject NONSTANDARD NAMING
}

contract Loans is DSMath {
    FundsInterface funds;
    Medianizer med;
    SalesInterface sales;
    CollateralInterface col;

    uint256 public constant approve_exp_threshold840 = 2 hours;    	//inject NONSTANDARD NAMING
    uint256 public constant accept_exp_threshold947 = 2 days;      	//inject NONSTANDARD NAMING
    uint256 public constant liquidation_exp_threshold443 = 7 days; 	//inject NONSTANDARD NAMING
    uint256 public constant seizure_exp_threshold699 = 2 days;     	//inject NONSTANDARD NAMING
    uint256 public constant liquidation_discount317 = 930000000000000000; 	//inject NONSTANDARD NAMING
    uint256 public constant max_num_liquidations552 = 3; 	//inject NONSTANDARD NAMING
    uint256 public constant max_uint_256251 = 2**256-1;	//inject NONSTANDARD NAMING

    mapping (bytes32 => Loan)                     public loans;
    mapping (bytes32 => PubKeys)                  public pubKeys;             
    mapping (bytes32 => SecretHashes)             public secretHashes;        
    mapping (bytes32 => Bools)                    public bools;               
    mapping (bytes32 => bytes32)                  public fundIndex;           
    mapping (bytes32 => uint256)                  public repayments;          
    mapping (address => bytes32[])                public borrowerLoans;
    mapping (address => bytes32[])                public lenderLoans;
    mapping (address => mapping(uint256 => bool)) public addressToTimestamp;
    uint256                                       public loanIndex;           

    ERC20 public token; 
    uint256 public decimals;

    address deployer;

    
    struct Loan {
        address borrower;
        address lender;
        address arbiter;
        uint256 createdAt;
        uint256 loanExpiration;
        uint256 requestTimestamp;
        uint256 closedTimestamp;
        uint256 principal;
        uint256 interest;
        uint256 penalty;
        uint256 fee;
        uint256 liquidationRatio;
    }

    
    struct PubKeys {
        bytes   borrowerPubKey;
        bytes   lenderPubKey;
        bytes   arbiterPubKey;
    }

    
    struct SecretHashes {
        bytes32    secretHashA1;
        bytes32[3] secretHashAs;
        bytes32    secretHashB1;
        bytes32[3] secretHashBs;
        bytes32    secretHashC1;
        bytes32[3] secretHashCs;
        bytes32    withdrawSecret;
        bytes32    acceptSecret;
        bool       set;
    }

    
    struct Bools {
        bool funded;
        bool approved;
        bool withdrawn;
        bool sale;
        bool paid;
        bool off;
    }

    event CREATE22(bytes32 loan);	//inject NONSTANDARD NAMING

    event SETSECRETHASHES818(bytes32 loan);	//inject NONSTANDARD NAMING

    event FUNDLOAN50(bytes32 loan);	//inject NONSTANDARD NAMING

    event APPROVE490(bytes32 loan);	//inject NONSTANDARD NAMING

    event WITHDRAW160(bytes32 loan, bytes32 secretA1);	//inject NONSTANDARD NAMING

    event REPAY404(bytes32 loan, uint256 amount);	//inject NONSTANDARD NAMING

    event REFUND289(bytes32 loan);	//inject NONSTANDARD NAMING

    event CANCEL833(bytes32 loan, bytes32 secret);	//inject NONSTANDARD NAMING

    event ACCEPT489(bytes32 loan, bytes32 secret);	//inject NONSTANDARD NAMING

    event LIQUIDATE130(bytes32 loan, bytes32 secretHash, bytes20 pubKeyHash);	//inject NONSTANDARD NAMING

    
    function BORROWER75(bytes32 loan) external view returns (address) {	//inject NONSTANDARD NAMING
        return loans[loan].borrower;
    }

    
    function LENDER92(bytes32 loan) external view returns (address) {	//inject NONSTANDARD NAMING
        return loans[loan].lender;
    }

    
    function ARBITER4(bytes32 loan) external view returns (address) {	//inject NONSTANDARD NAMING
        return loans[loan].arbiter;
    }

    
    function APPROVEEXPIRATION234(bytes32 loan) public view returns (uint256) { 	//inject NONSTANDARD NAMING
        return ADD803(loans[loan].createdAt, approve_exp_threshold840);
    }

    
    function ACCEPTEXPIRATION879(bytes32 loan) public view returns (uint256) { 	//inject NONSTANDARD NAMING
        return ADD803(loans[loan].loanExpiration, accept_exp_threshold947);
    }

    
    function LIQUIDATIONEXPIRATION442(bytes32 loan) public view returns (uint256) { 	//inject NONSTANDARD NAMING
        return ADD803(loans[loan].loanExpiration, liquidation_exp_threshold443);
    }

    
    function SEIZUREEXPIRATION523(bytes32 loan) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return ADD803(LIQUIDATIONEXPIRATION442(loan), seizure_exp_threshold699);
    }

    
    function PRINCIPAL566(bytes32 loan) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return loans[loan].principal;
    }

    
    function INTEREST523(bytes32 loan) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return loans[loan].interest;
    }

    
    function FEE426(bytes32 loan) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return loans[loan].fee;
    }

    
    function PENALTY434(bytes32 loan) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return loans[loan].penalty;
    }

    
    function COLLATERAL382(bytes32 loan) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return col.COLLATERAL382(loan);
    }

    
    function REFUNDABLECOLLATERAL879(bytes32 loan) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return col.REFUNDABLECOLLATERAL879(loan);
    }

    
    function SEIZABLECOLLATERAL368(bytes32 loan) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return col.SEIZABLECOLLATERAL368(loan);
    }

    
    function TEMPORARYREFUNDABLECOLLATERAL760(bytes32 loan) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return col.TEMPORARYREFUNDABLECOLLATERAL760(loan);
    }

    
    function TEMPORARYSEIZABLECOLLATERAL228(bytes32 loan) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return col.TEMPORARYSEIZABLECOLLATERAL228(loan);
    }

    
    function REPAID307(bytes32 loan) public view returns (uint256) { 	//inject NONSTANDARD NAMING
        return repayments[loan];
    }

    
    function LIQUIDATIONRATIO684(bytes32 loan) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return loans[loan].liquidationRatio;
    }

    
    function OWEDTOLENDER7(bytes32 loan) public view returns (uint256) { 	//inject NONSTANDARD NAMING
        return ADD803(PRINCIPAL566(loan), INTEREST523(loan));
    }

    
    function OWEDFORLOAN262(bytes32 loan) public view returns (uint256) { 	//inject NONSTANDARD NAMING
        return ADD803(OWEDTOLENDER7(loan), FEE426(loan));
    }

    
    function OWEDFORLIQUIDATION588(bytes32 loan) external view returns (uint256) { 	//inject NONSTANDARD NAMING
        return ADD803(OWEDFORLOAN262(loan), PENALTY434(loan));
    }

    
    function OWING794(bytes32 loan) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB97(OWEDFORLOAN262(loan), REPAID307(loan));
    }

    
    function FUNDED74(bytes32 loan) external view returns (bool) {	//inject NONSTANDARD NAMING
        return bools[loan].funded;
    }

    
    function APPROVED714(bytes32 loan) external view returns (bool) {	//inject NONSTANDARD NAMING
        return bools[loan].approved;
    }

    
    function WITHDRAWN418(bytes32 loan) external view returns (bool) {	//inject NONSTANDARD NAMING
        return bools[loan].withdrawn;
    }

    
    function SALE305(bytes32 loan) public view returns (bool) {	//inject NONSTANDARD NAMING
        return bools[loan].sale;
    }

    
    function PAID214(bytes32 loan) external view returns (bool) {	//inject NONSTANDARD NAMING
        return bools[loan].paid;
    }

    
    function OFF578(bytes32 loan) public view returns (bool) {	//inject NONSTANDARD NAMING
        return bools[loan].off;
    }

    
    function DMUL562(uint x) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return MUL111(x, (10 ** SUB97(18, decimals)));
    }

    
    function DDIV45(uint x) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV358(x, (10 ** SUB97(18, decimals)));
    }

    
    function BORROWERLOANCOUNT920(address borrower_) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return borrowerLoans[borrower_].length;
    }

    
    function LENDERLOANCOUNT648(address lender_) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return lenderLoans[lender_].length;
    }

    
    function MINSEIZABLECOLLATERAL886(bytes32 loan) public view returns (uint256) {	//inject NONSTANDARD NAMING
        (bytes32 val, bool set) = med.PEEK685();
        require(set, "Loans.minSeizableCollateral: Medianizer must be set");
        uint256 price = uint(val);
        return DIV358(WDIV128(DMUL562(SUB97(OWEDFORLOAN262(loan), REPAID307(loan))), price), DIV358(wad510, col735));
    }

    
    function COLLATERALVALUE260(bytes32 loan) public view returns (uint256) {	//inject NONSTANDARD NAMING
        (bytes32 val, bool set) = med.PEEK685();
        require(set, "Loans.collateralValue: Medianizer must be set");
        uint256 price = uint(val);
        return CMUL87(price, COLLATERAL382(loan));
    }

    
    function MINCOLLATERALVALUE408(bytes32 loan) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return RMUL965(DMUL562(SUB97(OWEDFORLOAN262(loan), REPAID307(loan))), LIQUIDATIONRATIO684(loan));
    }

    
    function DISCOUNTCOLLATERALVALUE221(bytes32 loan) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return WMUL533(COLLATERALVALUE260(loan), liquidation_discount317);
    }

    
    function SAFE528(bytes32 loan) public view returns (bool) {	//inject NONSTANDARD NAMING
        return COLLATERALVALUE260(loan) >= MINCOLLATERALVALUE408(loan);
    }

    
    constructor (FundsInterface funds_, Medianizer med_, ERC20 token_, uint256 decimals_) public {
        require(address(funds_) != address(0), "Funds address must be non-zero");
        require(address(med_) != address(0), "Medianizer address must be non-zero");
        require(address(token_) != address(0), "Token address must be non-zero");

        deployer = msg.sender;
        funds = funds_;
        med = med_;
        token = token_;
        decimals = decimals_;
        require(token.APPROVE357(address(funds), max_uint_256251), "Token approve failed");
    }

    
    
    
    
    
    

    
    function SETSALES924(SalesInterface sales_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == deployer, "Loans.setSales: Only the deployer can perform this");
        require(address(sales) == address(0), "Loans.setSales: The Sales address has already been set");
        require(address(sales_) != address(0), "Loans.setSales: Sales address must be non-zero");
        sales = sales_;
    }

    
    function SETCOLLATERAL164(CollateralInterface col_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == deployer, "Loans.setCollateral: Only the deployer can perform this");
        require(address(col) == address(0), "Loans.setCollateral: The Collateral address has already been set");
        require(address(col_) != address(0), "Loans.setCollateral: Collateral address must be non-zero");
        col = col_;
    }
    

    
    function CREATE943(	//inject NONSTANDARD NAMING
        uint256             loanExpiration_,
        address[3] calldata usrs_,
        uint256[7] calldata vals_,
        bytes32             fund
    ) external returns (bytes32 loan) {
        if (fund != bytes32(0)) {
            require(funds.LENDER92(fund) == usrs_[1], "Loans.create: Lender of Fund not in args");
        }
        require(!addressToTimestamp[usrs_[0]][vals_[6]], "Loans.create: Duplicate request timestamps are not allowed");
        require(loanExpiration_ > now, "Loans.create: loanExpiration must be greater than `now`");
        require(usrs_[0] != address(0) && usrs_[1] != address(0), "Loans.create: Borrower and Lender address must be non-zero");
        require(vals_[0] != 0 && vals_[4] != 0, "Loans.create: Principal and Collateral must be non-zero");
        require(vals_[5] != 0 && vals_[6] != 0, "Loans.create: Liquidation ratio and Request timestamp must be non-zero");

        loanIndex = ADD803(loanIndex, 1);
        loan = bytes32(loanIndex);
        loans[loan].createdAt = now;
        loans[loan].loanExpiration = loanExpiration_;
        loans[loan].borrower = usrs_[0];
        loans[loan].lender = usrs_[1];
        loans[loan].arbiter = usrs_[2];
        loans[loan].principal = vals_[0];
        loans[loan].interest = vals_[1];
        loans[loan].penalty = vals_[2];
        loans[loan].fee = vals_[3];
        uint256 minSeizableCol = MINSEIZABLECOLLATERAL886(loan);
        col.SETCOLLATERAL164(loan, SUB97(vals_[4], minSeizableCol), minSeizableCol);
        loans[loan].liquidationRatio = vals_[5];
        loans[loan].requestTimestamp = vals_[6];
        fundIndex[loan] = fund;
        secretHashes[loan].set = false;
        borrowerLoans[usrs_[0]].push(bytes32(loanIndex));
        lenderLoans[usrs_[1]].push(bytes32(loanIndex));
        addressToTimestamp[usrs_[0]][vals_[6]] = true;

        emit CREATE22(loan);
    }

    
    function SETSECRETHASHES742(	//inject NONSTANDARD NAMING
        bytes32             loan,
        bytes32[4] calldata borrowerSecretHashes,
        bytes32[4] calldata lenderSecretHashes,
        bytes32[4] calldata arbiterSecretHashes,
        bytes      calldata borrowerPubKey_,
        bytes      calldata lenderPubKey_,
        bytes      calldata arbiterPubKey_
    ) external {
        require(!secretHashes[loan].set, "Loans.setSecretHashes: Secret hashes must not already be set");
        require(
            msg.sender == loans[loan].borrower || msg.sender == loans[loan].lender || msg.sender == address(funds),
            "Loans.setSecretHashes: msg.sender must be Borrower, Lender or Funds Address"
        );
        secretHashes[loan].secretHashA1 = borrowerSecretHashes[0];
        secretHashes[loan].secretHashAs = [ borrowerSecretHashes[1], borrowerSecretHashes[2], borrowerSecretHashes[3] ];
        secretHashes[loan].secretHashB1 = lenderSecretHashes[0];
        secretHashes[loan].secretHashBs = [ lenderSecretHashes[1], lenderSecretHashes[2], lenderSecretHashes[3] ];
        secretHashes[loan].secretHashC1 = arbiterSecretHashes[0];
        secretHashes[loan].secretHashCs = [ arbiterSecretHashes[1], arbiterSecretHashes[2], arbiterSecretHashes[3] ];
        pubKeys[loan].borrowerPubKey = borrowerPubKey_;
        pubKeys[loan].lenderPubKey = lenderPubKey_;
        pubKeys[loan].arbiterPubKey = arbiterPubKey_;
        secretHashes[loan].set = true;
    }

    
    function FUND172(bytes32 loan) external {	//inject NONSTANDARD NAMING
        require(secretHashes[loan].set, "Loans.fund: Secret hashes must be set");
        require(bools[loan].funded == false, "Loans.fund: Loan is already funded");
        bools[loan].funded = true;
        require(token.TRANSFERFROM570(msg.sender, address(this), PRINCIPAL566(loan)), "Loans.fund: Failed to transfer tokens");

        emit FUNDLOAN50(loan);
    }

    
    function APPROVE357(bytes32 loan) external { 	//inject NONSTANDARD NAMING
    	require(bools[loan].funded == true, "Loans.approve: Loan must be funded");
    	require(loans[loan].lender == msg.sender, "Loans.approve: Only the lender can approve the loan");
        require(now <= APPROVEEXPIRATION234(loan), "Loans.approve: Loan is past the approve deadline");
    	bools[loan].approved = true;

        emit APPROVE490(loan);
    }

    
    function WITHDRAW186(bytes32 loan, bytes32 secretA1) external {	//inject NONSTANDARD NAMING
        require(!OFF578(loan), "Loans.withdraw: Loan cannot be inactive");
        require(bools[loan].funded == true, "Loans.withdraw: Loan must be funded");
        require(bools[loan].approved == true, "Loans.withdraw: Loan must be approved");
        require(bools[loan].withdrawn == false, "Loans.withdraw: Loan principal has already been withdrawn");
        require(sha256(abi.encodePacked(secretA1)) == secretHashes[loan].secretHashA1, "Loans.withdraw: Secret does not match");
        bools[loan].withdrawn = true;
        require(token.TRANSFER744(loans[loan].borrower, PRINCIPAL566(loan)), "Loans.withdraw: Failed to transfer tokens");

        secretHashes[loan].withdrawSecret = secretA1;
        if (address(col.ONDEMANDSPV389()) != address(0)) {col.REQUESTSPV477(loan);}

        emit WITHDRAW160(loan, secretA1);
    }

    
    function REPAY242(bytes32 loan, uint256 amount) external {	//inject NONSTANDARD NAMING
        require(!OFF578(loan), "Loans.repay: Loan cannot be inactive");
        require(!SALE305(loan), "Loans.repay: Loan cannot be undergoing a liquidation");
        require(bools[loan].withdrawn == true, "Loans.repay: Loan principal must be withdrawn");
        require(now <= loans[loan].loanExpiration, "Loans.repay: Loan cannot have expired");
        require(ADD803(amount, REPAID307(loan)) <= OWEDFORLOAN262(loan), "Loans.repay: Cannot repay more than the owed amount");
        require(token.TRANSFERFROM570(msg.sender, address(this), amount), "Loans.repay: Failed to transfer tokens");
        repayments[loan] = ADD803(amount, repayments[loan]);
        if (REPAID307(loan) == OWEDFORLOAN262(loan)) {
            bools[loan].paid = true;
            if (address(col.ONDEMANDSPV389()) != address(0)) {col.CANCELSPV463(loan);}
        }

        emit REPAY404(loan, amount);
    }

    
    function REFUND497(bytes32 loan) external {	//inject NONSTANDARD NAMING
        require(!OFF578(loan), "Loans.refund: Loan cannot be inactive");
        require(!SALE305(loan), "Loans.refund: Loan cannot be undergoing a liquidation");
        require(now > ACCEPTEXPIRATION879(loan), "Loans.refund: Cannot request refund until after acceptExpiration");
        require(bools[loan].paid == true, "Loans.refund: The loan must be repaid");
        require(msg.sender == loans[loan].borrower, "Loans.refund: Only the borrower can request a refund");
        bools[loan].off = true;
        loans[loan].closedTimestamp = now;
        if (funds.CUSTOM642(fundIndex[loan]) == false) {
            funds.DECREASETOTALBORROW522(loans[loan].principal);
            funds.CALCGLOBALINTEREST773();
        }
        require(token.TRANSFER744(loans[loan].borrower, OWEDFORLOAN262(loan)), "Loans.refund: Failed to transfer tokens");

        emit REFUND289(loan);
    }

    
    function CANCEL391(bytes32 loan, bytes32 secret) external {	//inject NONSTANDARD NAMING
        ACCEPT922(loan, secret);

        emit CANCEL833(loan, secret);
    }

    
    function CANCEL391(bytes32 loan) external {	//inject NONSTANDARD NAMING
        require(!OFF578(loan), "Loans.cancel: Loan must not be inactive");
        require(bools[loan].withdrawn == false, "Loans.cancel: Loan principal must not be withdrawn");
        require(now >= SEIZUREEXPIRATION523(loan), "Loans.cancel: Seizure deadline has not been reached");
        require(bools[loan].sale == false, "Loans.cancel: Loan must not be undergoing liquidation");
        CLOSE691(loan);

        emit CANCEL833(loan, bytes32(0));
    }

    
    function ACCEPT922(bytes32 loan, bytes32 secret) public {	//inject NONSTANDARD NAMING
        require(!OFF578(loan), "Loans.accept: Loan must not be inactive");
        require(bools[loan].withdrawn == false || bools[loan].paid == true, "Loans.accept: Loan must be either not withdrawn or repaid");
        require(msg.sender == loans[loan].lender || msg.sender == loans[loan].arbiter, "Loans.accept: msg.sender must be lender or arbiter");
        require(now <= ACCEPTEXPIRATION879(loan), "Loans.accept: Acceptance deadline has past");
        require(bools[loan].sale == false, "Loans.accept: Loan must not be going under liquidation");
        require(
            sha256(abi.encodePacked(secret)) == secretHashes[loan].secretHashB1 || sha256(abi.encodePacked(secret)) == secretHashes[loan].secretHashC1,
            "Loans.accept: Invalid secret"
        );
        secretHashes[loan].acceptSecret = secret;
        CLOSE691(loan);

        emit ACCEPT489(loan, secret);
    }

    
    function CLOSE691(bytes32 loan) private {	//inject NONSTANDARD NAMING
        bools[loan].off = true;
        loans[loan].closedTimestamp = now;
        
        if (bools[loan].withdrawn == false) {
            if (fundIndex[loan] == bytes32(0)) {
                require(token.TRANSFER744(loans[loan].lender, loans[loan].principal), "Loans.close: Failed to transfer principal to Lender");
            } else {
                if (funds.CUSTOM642(fundIndex[loan]) == false) {
                    funds.DECREASETOTALBORROW522(loans[loan].principal);
                }
                funds.DEPOSIT909(fundIndex[loan], loans[loan].principal);
            }
        }
        
        else {
            if (fundIndex[loan] == bytes32(0)) {
                require(token.TRANSFER744(loans[loan].lender, OWEDTOLENDER7(loan)), "Loans.close: Failed to transfer owedToLender to Lender");
            } else {
                if (funds.CUSTOM642(fundIndex[loan]) == false) {
                    funds.DECREASETOTALBORROW522(loans[loan].principal);
                }
                funds.DEPOSIT909(fundIndex[loan], OWEDTOLENDER7(loan));
            }
            require(token.TRANSFER744(loans[loan].arbiter, FEE426(loan)), "Loans.close: Failed to transfer fee to Arbiter");
        }
    }

    
    function LIQUIDATE339(bytes32 loan, bytes32 secretHash, bytes20 pubKeyHash) external returns (bytes32 sale_) {	//inject NONSTANDARD NAMING
        require(!OFF578(loan), "Loans.liquidate: Loan must not be inactive");
        require(bools[loan].withdrawn == true, "Loans.liquidate: Loan principal must be withdrawn");
        require(msg.sender != loans[loan].borrower && msg.sender != loans[loan].lender, "Loans.liquidate: Liquidator must be a third-party");
        require(secretHash != bytes32(0) && pubKeyHash != bytes20(0), "Loans.liquidate: secretHash and pubKeyHash must be non-zero");
        
        if (sales.NEXT199(loan) == 0) {
            
            if (now > loans[loan].loanExpiration) {
                require(bools[loan].paid == false, "Loans.liquidate: loan must not have already been repaid");
            } else {
                require(!SAFE528(loan), "Loans.liquidate: collateralization must be below min-collateralization ratio");
            }
            
            if (funds.CUSTOM642(fundIndex[loan]) == false) {
                funds.DECREASETOTALBORROW522(loans[loan].principal);
                funds.CALCGLOBALINTEREST773();
            }
        } else {
            
            require(sales.NEXT199(loan) < max_num_liquidations552, "Loans.liquidate: Max number of liquidations reached");
            require(!sales.ACCEPTED582(sales.SALEINDEXBYLOAN897(loan, sales.NEXT199(loan) - 1)), "Loans.liquidate: Previous liquidation already accepted");
            require(
                now > sales.SETTLEMENTEXPIRATION526(sales.SALEINDEXBYLOAN897(loan, sales.NEXT199(loan) - 1)),
                "Loans.liquidate: Previous liquidation settlement expiration hasn't expired"
            );
        }
        require(token.BALANCEOF227(msg.sender) >= DDIV45(DISCOUNTCOLLATERALVALUE221(loan)), "Loans.liquidate: insufficient balance to liquidate");
        require(token.TRANSFERFROM570(msg.sender, address(sales), DDIV45(DISCOUNTCOLLATERALVALUE221(loan))), "Loans.liquidate: Token transfer failed");
        SecretHashes storage h = secretHashes[loan];
        uint256 i = sales.NEXT199(loan);
        
        sale_ = sales.CREATE943(
            loan, loans[loan].borrower, loans[loan].lender, loans[loan].arbiter, msg.sender,
            h.secretHashAs[i], h.secretHashBs[i], h.secretHashCs[i], secretHash, pubKeyHash
        );
        if (bools[loan].sale == false) {
            bools[loan].sale = true;
            require(token.TRANSFER744(address(sales), REPAID307(loan)), "Loans.liquidate: Token transfer to Sales contract failed");
        }
        
        if (address(col.ONDEMANDSPV389()) != address(0)) {col.CANCELSPV463(loan);}

        emit LIQUIDATE130(loan, secretHash, pubKeyHash);
    }
}

interface CTokenInterface {
    function REDEEM46(uint redeemTokens) external returns (uint);	//inject NONSTANDARD NAMING
    function REDEEMUNDERLYING614(uint redeemAmount) external returns (uint);	//inject NONSTANDARD NAMING
    function BORROW254(uint borrowAmount) external returns (uint);	//inject NONSTANDARD NAMING
    function LIQUIDATEBORROW888(address borrower, uint repayAmount, address cTokenCollateral) external returns (uint);	//inject NONSTANDARD NAMING
    function LIQUIDATEBORROW888(address borrower, address cTokenCollateral) external payable;	//inject NONSTANDARD NAMING
    function EXCHANGERATECURRENT666() external returns (uint);	//inject NONSTANDARD NAMING
    function GETCASH889() external view returns (uint);	//inject NONSTANDARD NAMING
    function TOTALBORROWSCURRENT914() external returns (uint);	//inject NONSTANDARD NAMING
    function BORROWRATEPERBLOCK907() external view returns (uint);	//inject NONSTANDARD NAMING
    function SUPPLYRATEPERBLOCK507() external view returns (uint);	//inject NONSTANDARD NAMING
    function TOTALRESERVES190() external view returns (uint);	//inject NONSTANDARD NAMING
    function RESERVEFACTORMANTISSA247() external view returns (uint);	//inject NONSTANDARD NAMING

    function TOTALSUPPLY908() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF227(address owner) external view returns (uint256 balance);	//inject NONSTANDARD NAMING
    function ALLOWANCE643(address, address) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE357(address, uint) external;	//inject NONSTANDARD NAMING
    function TRANSFER744(address, uint) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM570(address, address, uint) external returns (bool);	//inject NONSTANDARD NAMING
}

interface CERC20Interface {
    function MINT386(uint mintAmount) external returns (uint); 	//inject NONSTANDARD NAMING
    function REPAYBORROW556(uint repayAmount) external returns (uint); 	//inject NONSTANDARD NAMING
    function REPAYBORROWBEHALF985(address borrower, uint repayAmount) external returns (uint); 	//inject NONSTANDARD NAMING
    function BORROWBALANCECURRENT604(address account) external returns (uint);	//inject NONSTANDARD NAMING
}

interface ERC20Interface {
    function ALLOWANCE643(address, address) external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF227(address) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE357(address, uint) external;	//inject NONSTANDARD NAMING
    function TRANSFER744(address, uint) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM570(address, address, uint) external returns (bool);	//inject NONSTANDARD NAMING
}

interface TrollerInterface {
    function ENTERMARKETS395(address[] calldata cTokens) external returns (uint[] memory);	//inject NONSTANDARD NAMING
    function EXITMARKET275(address cTokenAddress) external returns (uint);	//inject NONSTANDARD NAMING
    function GETASSETSIN764(address account) external view returns (address[] memory);	//inject NONSTANDARD NAMING
    function GETACCOUNTLIQUIDITY185(address account) external view returns (uint, uint, uint);	//inject NONSTANDARD NAMING
}

contract Helpers is DSMath {

    address public comptroller;

    
    function GETCOMPTROLLERADDRESS117() public view returns (address) {	//inject NONSTANDARD NAMING
        
        
        
        return comptroller;
    }

    function ENTERMARKET780(address cErc20) internal {	//inject NONSTANDARD NAMING
        TrollerInterface troller = TrollerInterface(GETCOMPTROLLERADDRESS117());
        address[] memory markets = troller.GETASSETSIN764(address(this));
        bool isEntered = false;
        for (uint i = 0; i < markets.length; i++) {
            if (markets[i] == cErc20) {
                isEntered = true;
            }
        }
        if (!isEntered) {
            address[] memory toEnter = new address[](1);
            toEnter[0] = cErc20;
            troller.ENTERMARKETS395(toEnter);
        }
    }

    
    function SETAPPROVAL391(address erc20, uint srcAmt, address to) internal {	//inject NONSTANDARD NAMING
        ERC20Interface erc20Contract = ERC20Interface(erc20);
        uint tokenAllowance = erc20Contract.ALLOWANCE643(address(this), to);
        if (srcAmt > tokenAllowance) {
            erc20Contract.APPROVE357(to, 2**255);
        }
    }

}

contract ALCompound is Helpers {
    
    function MINTCTOKEN703(address erc20, address cErc20, uint tokenAmt) internal {	//inject NONSTANDARD NAMING
        ENTERMARKET780(cErc20);
        ERC20Interface token = ERC20Interface(erc20);
        uint toDeposit = token.BALANCEOF227(address(this));
        if (toDeposit > tokenAmt) {
            toDeposit = tokenAmt;
        }
        CERC20Interface cToken = CERC20Interface(cErc20);
        SETAPPROVAL391(erc20, toDeposit, cErc20);
        assert(cToken.MINT386(toDeposit) == 0);
    }

    
    function REDEEMUNDERLYING614(address cErc20, uint tokenAmt) internal {	//inject NONSTANDARD NAMING
        CTokenInterface cToken = CTokenInterface(cErc20);
        SETAPPROVAL391(cErc20, 10**50, cErc20);
        uint toBurn = cToken.BALANCEOF227(address(this));
        uint tokenToReturn = WMUL533(toBurn, cToken.EXCHANGERATECURRENT666());
        if (tokenToReturn > tokenAmt) {
            tokenToReturn = tokenAmt;
        }
        require(cToken.REDEEMUNDERLYING614(tokenToReturn) == 0, "something went wrong");
    }

    
    function REDEEMCTOKEN224(address cErc20, uint cTokenAmt) internal {	//inject NONSTANDARD NAMING
        CTokenInterface cToken = CTokenInterface(cErc20);
        uint toBurn = cToken.BALANCEOF227(address(this));
        if (toBurn > cTokenAmt) {
            toBurn = cTokenAmt;
        }
        SETAPPROVAL391(cErc20, toBurn, cErc20);
        require(cToken.REDEEM46(toBurn) == 0, "something went wrong");
    }
}

contract Funds is DSMath, ALCompound {
    Loans loans;

    uint256 public constant default_liquidation_ratio475 = 1400000000000000000000000000;   	//inject NONSTANDARD NAMING
    uint256 public constant default_liquidation_penalty756 = 1000000000937303470807876289; 	//inject NONSTANDARD NAMING
    uint256 public constant default_min_loan_amt427 = 25 ether; 	//inject NONSTANDARD NAMING
    uint256 public constant default_max_loan_amt507 = 2**256-1; 	//inject NONSTANDARD NAMING
    uint256 public constant default_min_loan_dur981 = 6 hours;  	//inject NONSTANDARD NAMING
    uint256 public constant num_seconds_in_year521 = 365 days;	//inject NONSTANDARD NAMING
    uint256 public constant max_loan_length66 = 10 * num_seconds_in_year521;	//inject NONSTANDARD NAMING
    uint256 public constant max_uint_256251 = 2**256-1;	//inject NONSTANDARD NAMING

    mapping (address => bytes32[]) public secretHashes;    
    mapping (address => uint256)   public secretHashIndex; 

    mapping (address => bytes)     public pubKeys;  

    mapping (bytes32 => Fund)      public funds;
    mapping (address => bytes32)   public fundOwner;
    mapping (bytes32 => Bools)     public bools;
    uint256                        public fundIndex;

    uint256 public lastGlobalInterestUpdated;
    uint256 public tokenMarketLiquidity;
    uint256 public cTokenMarketLiquidity;
    uint256 public marketLiquidity;
    uint256 public totalBorrow;
    uint256 public globalInterestRateNumerator;
    uint256 public lastUtilizationRatio;
    uint256 public globalInterestRate;
    uint256 public maxUtilizationDelta;
    uint256 public utilizationInterestDivisor;
    uint256 public maxInterestRateNumerator;
    uint256 public minInterestRateNumerator;
    uint256 public interestUpdateDelay;
    uint256 public defaultArbiterFee;

    ERC20 public token;
    uint256 public decimals;
    CTokenInterface public cToken;
    bool compoundSet;

    address deployer;

    
    struct Fund {
        address  lender;
        uint256  minLoanAmt;
        uint256  maxLoanAmt;
        uint256  minLoanDur;
        uint256  maxLoanDur;
        uint256  fundExpiry;
        uint256  interest;
        uint256  penalty;
        uint256  fee;
        uint256  liquidationRatio;
        address  arbiter;
        uint256  balance;
        uint256  cBalance;
    }

    
    struct Bools {
        bool     custom;
        bool     compoundEnabled;
    }

    event CREATE22(bytes32 fund);	//inject NONSTANDARD NAMING

    event DEPOSIT856(bytes32 fund, uint256 amount_);	//inject NONSTANDARD NAMING

    event UPDATE341(bytes32  fund, uint256  maxLoanDur_, uint256  fundExpiry_, address  arbiter_);	//inject NONSTANDARD NAMING

    event REQUEST101(bytes32 fund, address borrower_, uint256 amount_, uint256 collateral_, uint256 loanDur_, uint256 requestTimestamp_);	//inject NONSTANDARD NAMING

    event WITHDRAW160(bytes32 fund, uint256 amount_, address recipient_);	//inject NONSTANDARD NAMING

    event ENABLECOMPOUND170(bytes32 fund);	//inject NONSTANDARD NAMING

    event DISABLECOMPOUND118(bytes32 fund);	//inject NONSTANDARD NAMING

    
    
    constructor(
        ERC20   token_,
        uint256 decimals_
    ) public {
        require(address(token_) != address(0), "Funds.constructor: Token address must be non-zero");
        require(decimals_ != 0, "Funds.constructor: Decimals must be non-zero");

        deployer = msg.sender;
        token = token_;
        decimals = decimals_;
        utilizationInterestDivisor = 10531702972595856680093239305; 
        maxUtilizationDelta = 95310179948351216961192521; 
        globalInterestRateNumerator = 95310179948351216961192521; 
        maxInterestRateNumerator = 182321557320989604265864303; 
        minInterestRateNumerator = 24692612600038629323181834; 
        interestUpdateDelay = 86400; 
        defaultArbiterFee = 1000000000236936036262880196; 
        globalInterestRate = ADD803(ray271, DIV358(globalInterestRateNumerator, num_seconds_in_year521)); 
    }

    
    
    
    
    
    

    
    function SETLOANS600(Loans loans_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == deployer, "Funds.setLoans: Only the deployer can perform this");
        require(address(loans) == address(0), "Funds.setLoans: Loans address has already been set");
        require(address(loans_) != address(0), "Funds.setLoans: Loans address must be non-zero");
        loans = loans_;
        require(token.APPROVE357(address(loans_), max_uint_256251), "Funds.setLoans: Tokens cannot be approved");
    }

    
    function SETCOMPOUND395(CTokenInterface cToken_, address comptroller_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == deployer, "Funds.setCompound: Only the deployer can enable Compound lending");
        require(!compoundSet, "Funds.setCompound: Compound address has already been set");
        require(address(cToken_) != address(0), "Funds.setCompound: cToken address must be non-zero");
        require(comptroller_ != address(0), "Funds.setCompound: comptroller address must be non-zero");
        cToken = cToken_;
        comptroller = comptroller_;
        compoundSet = true;
    }
    

    
    
    
    
    
    
    

    
    function SETUTILIZATIONINTERESTDIVISOR326(uint256 utilizationInterestDivisor_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == deployer, "Funds.setUtilizationInterestDivisor: Only the deployer can perform this");
        require(utilizationInterestDivisor_ != 0, "Funds.setUtilizationInterestDivisor: utilizationInterestDivisor is zero");
        utilizationInterestDivisor = utilizationInterestDivisor_;
    }

    
    function SETMAXUTILIZATIONDELTA889(uint256 maxUtilizationDelta_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == deployer, "Funds.setMaxUtilizationDelta: Only the deployer can perform this");
        require(maxUtilizationDelta_ != 0, "Funds.setMaxUtilizationDelta: maxUtilizationDelta is zero");
        maxUtilizationDelta = maxUtilizationDelta_;
    }

    
    function SETGLOBALINTERESTRATENUMERATOR552(uint256 globalInterestRateNumerator_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == deployer, "Funds.setGlobalInterestRateNumerator: Only the deployer can perform this");
        require(globalInterestRateNumerator_ != 0, "Funds.setGlobalInterestRateNumerator: globalInterestRateNumerator is zero");
        globalInterestRateNumerator = globalInterestRateNumerator_;
    }

    
    function SETGLOBALINTERESTRATE215(uint256 globalInterestRate_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == deployer, "Funds.setGlobalInterestRate: Only the deployer can perform this");
        require(globalInterestRate_ != 0, "Funds.setGlobalInterestRate: globalInterestRate is zero");
        globalInterestRate = globalInterestRate_;
    }

    
    function SETMAXINTERESTRATENUMERATOR833(uint256 maxInterestRateNumerator_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == deployer, "Funds.setMaxInterestRateNumerator: Only the deployer can perform this");
        require(maxInterestRateNumerator_ != 0, "Funds.setMaxInterestRateNumerator: maxInterestRateNumerator is zero");
        maxInterestRateNumerator = maxInterestRateNumerator_;
    }

    
    function SETMININTERESTRATENUMERATOR870(uint256 minInterestRateNumerator_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == deployer, "Funds.setMinInterestRateNumerator: Only the deployer can perform this");
        require(minInterestRateNumerator_ != 0, "Funds.setMinInterestRateNumerator: minInterestRateNumerator is zero");
        minInterestRateNumerator = minInterestRateNumerator_;
    }

    
    function SETINTERESTUPDATEDELAY704(uint256 interestUpdateDelay_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == deployer, "Funds.setInterestUpdateDelay: Only the deployer can perform this");
        require(interestUpdateDelay_ != 0, "Funds.setInterestUpdateDelay: interestUpdateDelay is zero");
        interestUpdateDelay = interestUpdateDelay_;
    }

    
    function SETDEFAULTARBITERFEE996(uint256 defaultArbiterFee_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == deployer, "Funds.setDefaultArbiterFee: Only the deployer can perform this");
        require(defaultArbiterFee_ <= 1000000000315522921573372069, "Funds.setDefaultArbiterFee: defaultArbiterFee cannot be less than -1%"); 
        defaultArbiterFee = defaultArbiterFee_;
    }
    

    
    function LENDER92(bytes32 fund) public view returns (address) {	//inject NONSTANDARD NAMING
        return funds[fund].lender;
    }

    
    function MINLOANAMT516(bytes32 fund) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (bools[fund].custom) {return funds[fund].minLoanAmt;}
        else                    {return DIV358(default_min_loan_amt427, (10 ** SUB97(18, decimals)));}
    }

    
    function MAXLOANAMT810(bytes32 fund) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (bools[fund].custom) {return funds[fund].maxLoanAmt;}
        else                    {return default_max_loan_amt507;}
    }

    
    function MINLOANDUR238(bytes32 fund) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (bools[fund].custom) {return funds[fund].minLoanDur;}
        else                    {return default_min_loan_dur981;}
    }

    
    function MAXLOANDUR299(bytes32 fund) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return funds[fund].maxLoanDur;
    }

    
    function FUNDEXPIRY174(bytes32 fund) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return funds[fund].fundExpiry;
    }

    
    function INTEREST523(bytes32 fund) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (bools[fund].custom) {return funds[fund].interest;}
        else                    {return globalInterestRate;}
    }

    
    function PENALTY434(bytes32 fund) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (bools[fund].custom) {return funds[fund].penalty;}
        else                    {return default_liquidation_penalty756;}
    }

    
    function FEE426(bytes32 fund) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (bools[fund].custom) {return funds[fund].fee;}
        else                    {return defaultArbiterFee;}
    }

    
    function LIQUIDATIONRATIO684(bytes32 fund) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (bools[fund].custom) {return funds[fund].liquidationRatio;}
        else                    {return default_liquidation_ratio475;}
    }

    
    function ARBITER4(bytes32 fund) public view returns (address) {	//inject NONSTANDARD NAMING
        return funds[fund].arbiter;
    }

    
    function BALANCE334(bytes32 fund) public returns (uint256) {	//inject NONSTANDARD NAMING
        if (bools[fund].compoundEnabled) {
            return WMUL533(funds[fund].cBalance, cToken.EXCHANGERATECURRENT666());
        } else {
            return funds[fund].balance;
        }
    }

    function CTOKENEXCHANGERATE725() public returns (uint256) {	//inject NONSTANDARD NAMING
        if (compoundSet) {
            return cToken.EXCHANGERATECURRENT666();
        } else {
            return 0;
        }
    }

    
    function CUSTOM642(bytes32 fund) public view returns (bool) {	//inject NONSTANDARD NAMING
        return bools[fund].custom;
    }

    
    function SECRETHASHESCOUNT698(address addr_) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return secretHashes[addr_].length;
    }

    
    function CREATE943(	//inject NONSTANDARD NAMING
        uint256  maxLoanDur_,
        uint256  fundExpiry_,
        address  arbiter_,
        bool     compoundEnabled_,
        uint256  amount_
    ) external returns (bytes32 fund) {
        
        
        
        require(funds[fundOwner[msg.sender]].lender != msg.sender, "Funds.create: Only one loan fund allowed per address"); 
        
        require(
            ENSURENOTZERO255(maxLoanDur_, false) < max_loan_length66 && ENSURENOTZERO255(fundExpiry_, true) < now + max_loan_length66,
            "Funds.create: fundExpiry and maxLoanDur cannot exceed 10 years"
        ); 
        if (!compoundSet) {require(compoundEnabled_ == false, "Funds.create: Cannot enable Compound as it has not been configured");}
        fundIndex = ADD803(fundIndex, 1);
        fund = bytes32(fundIndex);
        funds[fund].lender = msg.sender;
        funds[fund].maxLoanDur = ENSURENOTZERO255(maxLoanDur_, false);
        funds[fund].fundExpiry = ENSURENOTZERO255(fundExpiry_, true);
        funds[fund].arbiter = arbiter_;
        bools[fund].custom = false;
        bools[fund].compoundEnabled = compoundEnabled_;
        fundOwner[msg.sender] = bytes32(fundIndex);
        if (amount_ > 0) {DEPOSIT909(fund, amount_);}

        emit CREATE22(fund);
    }

    
    function CREATECUSTOM959(	//inject NONSTANDARD NAMING
        uint256  minLoanAmt_,
        uint256  maxLoanAmt_,
        uint256  minLoanDur_,
        uint256  maxLoanDur_,
        uint256  fundExpiry_,
        uint256  liquidationRatio_,
        uint256  interest_,
        uint256  penalty_,
        uint256  fee_,
        address  arbiter_,
        bool     compoundEnabled_,
        uint256  amount_
    ) external returns (bytes32 fund) {
        
        
        
        require(funds[fundOwner[msg.sender]].lender != msg.sender, "Funds.create: Only one loan fund allowed per address"); 
        
        require(
            ENSURENOTZERO255(maxLoanDur_, false) < max_loan_length66 && ENSURENOTZERO255(fundExpiry_, true) < now + max_loan_length66,
            "Funds.createCustom: fundExpiry and maxLoanDur cannot exceed 10 years"
        ); 
        require(maxLoanAmt_ >= minLoanAmt_, "Funds.createCustom: maxLoanAmt must be greater than or equal to minLoanAmt");
        require(ENSURENOTZERO255(maxLoanDur_, false) >= minLoanDur_, "Funds.createCustom: maxLoanDur must be greater than or equal to minLoanDur");

        if (!compoundSet) {require(compoundEnabled_ == false, "Funds.createCustom: Cannot enable Compound as it has not been configured");}
        fundIndex = ADD803(fundIndex, 1);
        fund = bytes32(fundIndex);
        funds[fund].lender = msg.sender;
        funds[fund].minLoanAmt = minLoanAmt_;
        funds[fund].maxLoanAmt = maxLoanAmt_;
        funds[fund].minLoanDur = minLoanDur_;
        funds[fund].maxLoanDur = ENSURENOTZERO255(maxLoanDur_, false);
        funds[fund].fundExpiry = ENSURENOTZERO255(fundExpiry_, true);
        funds[fund].interest = interest_;
        funds[fund].penalty = penalty_;
        funds[fund].fee = fee_;
        funds[fund].liquidationRatio = liquidationRatio_;
        funds[fund].arbiter = arbiter_;
        bools[fund].custom = true;
        bools[fund].compoundEnabled = compoundEnabled_;
        fundOwner[msg.sender] = bytes32(fundIndex);
        if (amount_ > 0) {DEPOSIT909(fund, amount_);}

        emit CREATE22(fund);
    }

    
    function DEPOSIT909(bytes32 fund, uint256 amount_) public {	//inject NONSTANDARD NAMING
        require(token.TRANSFERFROM570(msg.sender, address(this), amount_), "Funds.deposit: Failed to transfer tokens");
        if (bools[fund].compoundEnabled) {
            MINTCTOKEN703(address(token), address(cToken), amount_);
            uint256 cTokenToAdd = DIV358(MUL111(amount_, wad510), cToken.EXCHANGERATECURRENT666());
            funds[fund].cBalance = ADD803(funds[fund].cBalance, cTokenToAdd);
            if (!CUSTOM642(fund)) {cTokenMarketLiquidity = ADD803(cTokenMarketLiquidity, cTokenToAdd);}
        } else {
            funds[fund].balance = ADD803(funds[fund].balance, amount_);
            if (!CUSTOM642(fund)) {tokenMarketLiquidity = ADD803(tokenMarketLiquidity, amount_);}
        }
        if (!CUSTOM642(fund)) {CALCGLOBALINTEREST773();}

        emit DEPOSIT856(fund, amount_);
    }

    
    function UPDATE438(	//inject NONSTANDARD NAMING
        bytes32  fund,
        uint256  maxLoanDur_,
        uint256  fundExpiry_,
        address  arbiter_
    ) public {
        require(msg.sender == LENDER92(fund), "Funds.update: Only the lender can update the fund");
        require(
            ENSURENOTZERO255(maxLoanDur_, false) <= max_loan_length66 && ENSURENOTZERO255(fundExpiry_, true) <= now + max_loan_length66,
            "Funds.update: fundExpiry and maxLoanDur cannot exceed 10 years"
        );  
        funds[fund].maxLoanDur = maxLoanDur_;
        funds[fund].fundExpiry = fundExpiry_;
        funds[fund].arbiter = arbiter_;

        emit UPDATE341(fund, maxLoanDur_, fundExpiry_, arbiter_);
    }

    
    function UPDATECUSTOM705(	//inject NONSTANDARD NAMING
        bytes32  fund,
        uint256  minLoanAmt_,
        uint256  maxLoanAmt_,
        uint256  minLoanDur_,
        uint256  maxLoanDur_,
        uint256  fundExpiry_,
        uint256  interest_,
        uint256  penalty_,
        uint256  fee_,
        uint256  liquidationRatio_,
        address  arbiter_
    ) external {
        require(bools[fund].custom, "Funds.updateCustom: Fund must be a custom fund");
        require(maxLoanAmt_ >= minLoanAmt_, "Funds.updateCustom: maxLoanAmt must be greater than or equal to minLoanAmt");
        require(ENSURENOTZERO255(maxLoanDur_, false) >= minLoanDur_, "Funds.updateCustom: maxLoanDur must be greater than or equal to minLoanDur");
        UPDATE438(fund, maxLoanDur_, fundExpiry_, arbiter_);
        funds[fund].minLoanAmt = minLoanAmt_;
        funds[fund].maxLoanAmt = maxLoanAmt_;
        funds[fund].minLoanDur = minLoanDur_;
        funds[fund].interest = interest_;
        funds[fund].penalty = penalty_;
        funds[fund].fee = fee_;
        funds[fund].liquidationRatio = liquidationRatio_;
    }

    
    function REQUEST711(	//inject NONSTANDARD NAMING
        bytes32             fund,
        address             borrower_,
        uint256             amount_,
        uint256             collateral_,
        uint256             loanDur_,
        uint256             requestTimestamp_,
        bytes32[8] calldata secretHashes_,
        bytes      calldata pubKeyA_,
        bytes      calldata pubKeyB_
    ) external returns (bytes32 loanIndex) {
        require(msg.sender == LENDER92(fund), "Funds.request: Only the lender can fulfill a loan request");
        require(amount_ <= BALANCE334(fund), "Funds.request: Insufficient balance");
        require(amount_ >= MINLOANAMT516(fund), "Funds.request: Amount requested must be greater than minLoanAmt");
        require(amount_ <= MAXLOANAMT810(fund), "Funds.request: Amount requested must be less than maxLoanAmt");
        require(loanDur_ >= MINLOANDUR238(fund), "Funds.request: Loan duration must be greater than minLoanDur");
        require(loanDur_ <= SUB97(FUNDEXPIRY174(fund), now) && loanDur_ <= MAXLOANDUR299(fund), "Funds.request: Loan duration must be less than maxLoanDur and expiry");
        require(borrower_ != address(0), "Funds.request: Borrower address must be non-zero");
        require(secretHashes_[0] != bytes32(0) && secretHashes_[1] != bytes32(0), "Funds.request: SecretHash1 & SecretHash2 should be non-zero");
        require(secretHashes_[2] != bytes32(0) && secretHashes_[3] != bytes32(0), "Funds.request: SecretHash3 & SecretHash4 should be non-zero");
        require(secretHashes_[4] != bytes32(0) && secretHashes_[5] != bytes32(0), "Funds.request: SecretHash5 & SecretHash6 should be non-zero");
        require(secretHashes_[6] != bytes32(0) && secretHashes_[7] != bytes32(0), "Funds.request: SecretHash7 & SecretHash8 should be non-zero");

        loanIndex = CREATELOAN338(fund, borrower_, amount_, collateral_, loanDur_, requestTimestamp_);
        LOANSETSECRETHASHES310(fund, loanIndex, secretHashes_, pubKeyA_, pubKeyB_);
        LOANUPDATEMARKETLIQUIDITY912(fund, amount_);
        loans.FUND172(loanIndex);

        emit REQUEST101(fund, borrower_, amount_, collateral_, loanDur_, requestTimestamp_);
    }

    
    function WITHDRAW186(bytes32 fund, uint256 amount_) external {	//inject NONSTANDARD NAMING
        WITHDRAWTO298(fund, amount_, msg.sender);
    }

    
    function WITHDRAWTO298(bytes32 fund, uint256 amount_, address recipient_) public {	//inject NONSTANDARD NAMING
        require(msg.sender == LENDER92(fund), "Funds.withdrawTo: Only the lender can withdraw tokens");
        require(BALANCE334(fund) >= amount_, "Funds.withdrawTo: Insufficient balance");
        if (bools[fund].compoundEnabled) {
            uint256 cBalanceBefore = cToken.BALANCEOF227(address(this));
            REDEEMUNDERLYING614(address(cToken), amount_);
            uint256 cBalanceAfter = cToken.BALANCEOF227(address(this));
            uint256 cTokenToRemove = SUB97(cBalanceBefore, cBalanceAfter);
            funds[fund].cBalance = SUB97(funds[fund].cBalance, cTokenToRemove);
            require(token.TRANSFER744(recipient_, amount_), "Funds.withdrawTo: Token transfer failed");
            if (!CUSTOM642(fund)) {cTokenMarketLiquidity = SUB97(cTokenMarketLiquidity, cTokenToRemove);}
        } else {
            funds[fund].balance = SUB97(funds[fund].balance, amount_);
            require(token.TRANSFER744(recipient_, amount_), "Funds.withdrawTo: Token transfer failed");
            if (!CUSTOM642(fund)) {tokenMarketLiquidity = SUB97(tokenMarketLiquidity, amount_);}
        }
        if (!CUSTOM642(fund)) {CALCGLOBALINTEREST773();}

        emit WITHDRAW160(fund, amount_, recipient_);
    }

    
    function GENERATE494(bytes32[] calldata secretHashes_) external {	//inject NONSTANDARD NAMING
        for (uint i = 0; i < secretHashes_.length; i++) {
            secretHashes[msg.sender].push(secretHashes_[i]);
        }
    }

    
    function SETPUBKEY352(bytes calldata pubKey_) external { 	//inject NONSTANDARD NAMING
        pubKeys[msg.sender] = pubKey_;
    }

    
    function ENABLECOMPOUND230(bytes32 fund) external {	//inject NONSTANDARD NAMING
        require(compoundSet, "Funds.enableCompound: Cannot enable Compound as it has not been configured");
        require(bools[fund].compoundEnabled == false, "Funds.enableCompound: Compound is already enabled");
        require(msg.sender == LENDER92(fund), "Funds.enableCompound: Only the lender can enable Compound");
        uint256 cBalanceBefore = cToken.BALANCEOF227(address(this));
        MINTCTOKEN703(address(token), address(cToken), funds[fund].balance);
        uint256 cBalanceAfter = cToken.BALANCEOF227(address(this));
        uint256 cTokenToReturn = SUB97(cBalanceAfter, cBalanceBefore);
        tokenMarketLiquidity = SUB97(tokenMarketLiquidity, funds[fund].balance);
        cTokenMarketLiquidity = ADD803(cTokenMarketLiquidity, cTokenToReturn);
        bools[fund].compoundEnabled = true;
        funds[fund].balance = 0;
        funds[fund].cBalance = cTokenToReturn;

        emit ENABLECOMPOUND170(fund);
    }

    
    function DISABLECOMPOUND481(bytes32 fund) external {	//inject NONSTANDARD NAMING
        require(bools[fund].compoundEnabled, "Funds.disableCompound: Compound is already disabled");
        require(msg.sender == LENDER92(fund), "Funds.disableCompound: Only the lender can disable Compound");
        uint256 balanceBefore = token.BALANCEOF227(address(this));
        REDEEMCTOKEN224(address(cToken), funds[fund].cBalance);
        uint256 balanceAfter = token.BALANCEOF227(address(this));
        uint256 tokenToReturn = SUB97(balanceAfter, balanceBefore);
        tokenMarketLiquidity = ADD803(tokenMarketLiquidity, tokenToReturn);
        cTokenMarketLiquidity = SUB97(cTokenMarketLiquidity, funds[fund].cBalance);
        bools[fund].compoundEnabled = false;
        funds[fund].cBalance = 0;
        funds[fund].balance = tokenToReturn;

        emit DISABLECOMPOUND118(fund);
    }

    
    function DECREASETOTALBORROW522(uint256 amount_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == address(loans), "Funds.decreaseTotalBorrow: Only the Loans contract can perform this");
        totalBorrow = SUB97(totalBorrow, amount_);
    }

    
    function CALCGLOBALINTEREST773() public {	//inject NONSTANDARD NAMING
        marketLiquidity = ADD803(tokenMarketLiquidity, WMUL533(cTokenMarketLiquidity, CTOKENEXCHANGERATE725()));

        if (now > (ADD803(lastGlobalInterestUpdated, interestUpdateDelay))) {
            uint256 utilizationRatio;
            if (totalBorrow != 0) {utilizationRatio = RDIV519(totalBorrow, ADD803(marketLiquidity, totalBorrow));}

            if (utilizationRatio > lastUtilizationRatio) {
                uint256 changeUtilizationRatio = SUB97(utilizationRatio, lastUtilizationRatio);
                globalInterestRateNumerator = MIN456(maxInterestRateNumerator, ADD803(globalInterestRateNumerator, RDIV519(MIN456(maxUtilizationDelta, changeUtilizationRatio), utilizationInterestDivisor)));
            } else {
                uint256 changeUtilizationRatio = SUB97(lastUtilizationRatio, utilizationRatio);
                globalInterestRateNumerator = MAX638(minInterestRateNumerator, SUB97(globalInterestRateNumerator, RDIV519(MIN456(maxUtilizationDelta, changeUtilizationRatio), utilizationInterestDivisor)));
            }

            globalInterestRate = ADD803(ray271, DIV358(globalInterestRateNumerator, num_seconds_in_year521));

            lastGlobalInterestUpdated = now;
            lastUtilizationRatio = utilizationRatio;
        }
    }

    
    function CALCINTEREST818(uint256 amount_, uint256 rate_, uint256 loanDur_) public pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB97(RMUL965(amount_, RPOW933(rate_, loanDur_)), amount_);
    }

    
    function ENSURENOTZERO255(uint256 value, bool addNow) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (value == 0) {
            if (addNow) {
                return now + max_loan_length66;
            }
            return max_loan_length66;
        }
        return value;
    }

    
    function CREATELOAN338(	//inject NONSTANDARD NAMING
        bytes32  fund,
        address  borrower_,
        uint256  amount_,
        uint256  collateral_,
        uint256  loanDur_,
        uint256  requestTimestamp_
    ) private returns (bytes32 loanIndex) {
        loanIndex = loans.CREATE943(
            now + loanDur_,
            [borrower_, LENDER92(fund), funds[fund].arbiter],
            [
                amount_,
                CALCINTEREST818(amount_, INTEREST523(fund), loanDur_),
                CALCINTEREST818(amount_, PENALTY434(fund), loanDur_),
                CALCINTEREST818(amount_, FEE426(fund), loanDur_),
                collateral_,
                LIQUIDATIONRATIO684(fund),
                requestTimestamp_
            ],
            fund
        );
    }

    
    function LOANSETSECRETHASHES310(	//inject NONSTANDARD NAMING
        bytes32           fund,
        bytes32           loan,
        bytes32[8] memory secretHashes_,
        bytes      memory pubKeyA_,
        bytes      memory pubKeyB_
    ) private {
        loans.SETSECRETHASHES742(
            loan,
            [ secretHashes_[0], secretHashes_[1], secretHashes_[2], secretHashes_[3] ],
            [ secretHashes_[4], secretHashes_[5], secretHashes_[6], secretHashes_[7] ],
            GETSECRETHASHESFORLOAN447(ARBITER4(fund)),
            pubKeyA_,
            pubKeyB_,
            pubKeys[ARBITER4(fund)]
        );
    }

    
    function LOANUPDATEMARKETLIQUIDITY912(bytes32 fund, uint256 amount_) private {	//inject NONSTANDARD NAMING
        if (bools[fund].compoundEnabled) {
            uint256 cBalanceBefore = cToken.BALANCEOF227(address(this));
            REDEEMUNDERLYING614(address(cToken), amount_);
            uint256 cBalanceAfter = cToken.BALANCEOF227(address(this));
            uint256 cTokenToRemove = SUB97(cBalanceBefore, cBalanceAfter);
            funds[fund].cBalance = SUB97(funds[fund].cBalance, cTokenToRemove);
            if (!CUSTOM642(fund)) {cTokenMarketLiquidity = SUB97(cTokenMarketLiquidity, cTokenToRemove);}
        } else {
            funds[fund].balance = SUB97(funds[fund].balance, amount_);
            if (!CUSTOM642(fund)) {tokenMarketLiquidity = SUB97(tokenMarketLiquidity, amount_);}
        }
        if (!CUSTOM642(fund)) {
            totalBorrow = ADD803(totalBorrow, amount_);
            CALCGLOBALINTEREST773();
        }
    }

    
    function GETSECRETHASHESFORLOAN447(address addr_) private returns (bytes32[4] memory) {	//inject NONSTANDARD NAMING
        secretHashIndex[addr_] = ADD803(secretHashIndex[addr_], 4);
        require(SECRETHASHESCOUNT698(addr_) >= secretHashIndex[addr_], "Funds.getSecretHashesForLoan: Not enough secrets generated");
        return [
            secretHashes[addr_][SUB97(secretHashIndex[addr_], 4)],
            secretHashes[addr_][SUB97(secretHashIndex[addr_], 3)],
            secretHashes[addr_][SUB97(secretHashIndex[addr_], 2)],
            secretHashes[addr_][SUB97(secretHashIndex[addr_], 1)]
        ];
    }
}