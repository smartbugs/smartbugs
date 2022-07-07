                                                                 

                                                    


pragma solidity ^0.5.2;

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

                                                                                   
interface ierc2023 {	//inject NONSTANDARD NAMING
    function TRANSFER24(address TO66, uint256 VALUE98) external returns (bool);	//inject NONSTANDARD NAMING

    function APPROVE68(address SPENDER23, uint256 VALUE98) external returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM78(address FROM2, address TO66, uint256 VALUE98) external returns (bool);	//inject NONSTANDARD NAMING

    function TOTALSUPPLY24() external view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF89(address WHO64) external view returns (uint256);	//inject NONSTANDARD NAMING

    function ALLOWANCE52(address OWNER65, address SPENDER23) external view returns (uint256);	//inject NONSTANDARD NAMING

    event TRANSFER5(address indexed FROM2, address indexed TO66, uint256 VALUE98);	//inject NONSTANDARD NAMING

    event APPROVAL89(address indexed OWNER65, address indexed SPENDER23, uint256 VALUE98);	//inject NONSTANDARD NAMING
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.2;

                                                                                                   
library safemath69 {	//inject NONSTANDARD NAMING
                                                                                  
    function MUL40(uint256 A83, uint256 B59) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (A83 == 0) {
            return 0;
        }

        uint256 C4 = A83 * B59;	//inject NONSTANDARD NAMING
        require(C4 / A83 == B59);

        return C4;
    }

                                                                                                                           
    function DIV25(uint256 A83, uint256 B59) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(B59 > 0);
        uint256 C4 = A83 / B59;	//inject NONSTANDARD NAMING
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return C4;
    }

                                                                                                                              
    function SUB60(uint256 A83, uint256 B59) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(B59 <= A83);
        uint256 C4 = A83 - B59;	//inject NONSTANDARD NAMING

        return C4;
    }

                                                                            
    function ADD47(uint256 A83, uint256 B59) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 C4 = A83 + B59;	//inject NONSTANDARD NAMING
        require(C4 >= A83);

        return C4;
    }

                                                                                                                                                    
    function MOD87(uint256 A83, uint256 B59) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(B59 != 0);
        return A83 % B59;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.5.2;

                                                                                                                                                                                                                                                                                                                                                                                                                            
contract erc2052 is ierc2023 {	//inject NONSTANDARD NAMING
    using safemath69 for uint256;

    mapping (address => uint256) private _BALANCES88;	//inject NONSTANDARD NAMING

    mapping (address => mapping (address => uint256)) private _ALLOWED42;	//inject NONSTANDARD NAMING

    uint256 private _TOTALSUPPLY11;	//inject NONSTANDARD NAMING

                                                               
    function TOTALSUPPLY24() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _TOTALSUPPLY11;
    }

                                                                                                                                                                                                             
    function BALANCEOF89(address OWNER65) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _BALANCES88[OWNER65];
    }

                                                                                                                                                                                                                                                                                                                                    
    function ALLOWANCE52(address OWNER65, address SPENDER23) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _ALLOWED42[OWNER65][SPENDER23];
    }

                                                                                                                                                                
    function TRANSFER24(address TO66, uint256 VALUE98) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER56(msg.sender, TO66, VALUE98);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function APPROVE68(address SPENDER23, uint256 VALUE98) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE80(msg.sender, SPENDER23, VALUE98);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function TRANSFERFROM78(address FROM2, address TO66, uint256 VALUE98) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER56(FROM2, TO66, VALUE98);
        _APPROVE80(FROM2, msg.sender, _ALLOWED42[FROM2][msg.sender].SUB60(VALUE98));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function INCREASEALLOWANCE93(address SPENDER23, uint256 ADDEDVALUE55) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE80(msg.sender, SPENDER23, _ALLOWED42[msg.sender][SPENDER23].ADD47(ADDEDVALUE55));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE55(address SPENDER23, uint256 SUBTRACTEDVALUE25) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE80(msg.sender, SPENDER23, _ALLOWED42[msg.sender][SPENDER23].SUB60(SUBTRACTEDVALUE25));
        return true;
    }

                                                                                                                                                                                                                    
    function _TRANSFER56(address FROM2, address TO66, uint256 VALUE98) internal {	//inject NONSTANDARD NAMING
        require(TO66 != address(0));

        _BALANCES88[FROM2] = _BALANCES88[FROM2].SUB60(VALUE98);
        _BALANCES88[TO66] = _BALANCES88[TO66].ADD47(VALUE98);
        emit TRANSFER5(FROM2, TO66, VALUE98);
    }

                                                                                                                                                                                                                                                                                                                                                
    function _MINT69(address ACCOUNT65, uint256 VALUE98) internal {	//inject NONSTANDARD NAMING
        require(ACCOUNT65 != address(0));

        _TOTALSUPPLY11 = _TOTALSUPPLY11.ADD47(VALUE98);
        _BALANCES88[ACCOUNT65] = _BALANCES88[ACCOUNT65].ADD47(VALUE98);
        emit TRANSFER5(address(0), ACCOUNT65, VALUE98);
    }

                                                                                                                                                                                                                           
    function _BURN95(address ACCOUNT65, uint256 VALUE98) internal {	//inject NONSTANDARD NAMING
        require(ACCOUNT65 != address(0));

        _TOTALSUPPLY11 = _TOTALSUPPLY11.SUB60(VALUE98);
        _BALANCES88[ACCOUNT65] = _BALANCES88[ACCOUNT65].SUB60(VALUE98);
        emit TRANSFER5(ACCOUNT65, address(0), VALUE98);
    }

                                                                                                                                                                                                                                                                  
    function _APPROVE80(address OWNER65, address SPENDER23, uint256 VALUE98) internal {	//inject NONSTANDARD NAMING
        require(SPENDER23 != address(0));
        require(OWNER65 != address(0));

        _ALLOWED42[OWNER65][SPENDER23] = VALUE98;
        emit APPROVAL89(OWNER65, SPENDER23, VALUE98);
    }

                                                                                                                                                                                                                                                                                                                                                                                              
    function _BURNFROM68(address ACCOUNT65, uint256 VALUE98) internal {	//inject NONSTANDARD NAMING
        _BURN95(ACCOUNT65, VALUE98);
        _APPROVE80(ACCOUNT65, msg.sender, _ALLOWED42[ACCOUNT65][msg.sender].SUB60(VALUE98));
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol

pragma solidity ^0.5.2;


                                                                                                                                                                                                                                        
contract erc20detailed12 is ierc2023 {	//inject NONSTANDARD NAMING
    string private _NAME95;	//inject NONSTANDARD NAMING
    string private _SYMBOL37;	//inject NONSTANDARD NAMING
    uint8 private _DECIMALS2;	//inject NONSTANDARD NAMING

    constructor (string memory NAME93, string memory SYMBOL43, uint8 DECIMALS83) public {	//inject NONSTANDARD NAMING
        _NAME95 = NAME93;
        _SYMBOL37 = SYMBOL43;
        _DECIMALS2 = DECIMALS83;
    }

                                                     
    function NAME100() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _NAME95;
    }

                                                       
    function SYMBOL95() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _SYMBOL37;
    }

                                                                   
    function DECIMALS41() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _DECIMALS2;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol

pragma solidity ^0.5.2;


                                                                                           
contract erc20burnable39 is erc2052 {	//inject NONSTANDARD NAMING
                                                                                                                    
    function BURN93(uint256 VALUE98) public {	//inject NONSTANDARD NAMING
        _BURN95(msg.sender, VALUE98);
    }

                                                                                                                                                                                                                                                
    function BURNFROM19(address FROM2, uint256 VALUE98) public {	//inject NONSTANDARD NAMING
        _BURNFROM68(FROM2, VALUE98);
    }
}

// File: contracts/AVEC.sol

pragma solidity ^0.5.0;

contract avec56 is erc2052, erc20detailed12, erc20burnable39 {	//inject NONSTANDARD NAMING
    constructor() erc20detailed12('Alternate Virtual Equity Credit', 'AVEC', 18) public {
        _MINT69(msg.sender, 1440000000 * 10 ** 18);
    }
}