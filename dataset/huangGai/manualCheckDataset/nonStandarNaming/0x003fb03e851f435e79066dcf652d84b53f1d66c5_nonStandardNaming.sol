                                                                 

pragma solidity ^0.5.8;

interface ierc2068 {	//inject NONSTANDARD NAMING
    function TOTALSUPPLY3() external view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF80(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

    function TRANSFER74(address recipient, uint256 amount)external returns (bool);	//inject NONSTANDARD NAMING

    function ALLOWANCE0(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

    function APPROVE81(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM66(address sender,address recipient,uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

    event TRANSFER48(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL56(address indexed owner,address indexed spender,uint256 value);	//inject NONSTANDARD NAMING
}

contract context27 {	//inject NONSTANDARD NAMING
    constructor() internal {}

    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER71() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }
}

contract erc205 is context27, ierc2068 {	//inject NONSTANDARD NAMING
    using safemath98 for uint256;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    function TOTALSUPPLY3() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

    function BALANCEOF80(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

    function TRANSFER74(address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER57(_MSGSENDER71(), recipient, amount);
        return true;
    }

    function ALLOWANCE0(address owner, address spender)	//inject NONSTANDARD NAMING
        public
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function APPROVE81(address spender, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE12(_MSGSENDER71(), spender, amount);
        return true;
    }

    function TRANSFERFROM66(	//inject NONSTANDARD NAMING
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        _TRANSFER57(sender, recipient, amount);
        _APPROVE12(
            sender,
            _MSGSENDER71(),
            _allowances[sender][_MSGSENDER71()].SUB0(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function INCREASEALLOWANCE53(address spender, uint256 addedValue)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        _APPROVE12(
            _MSGSENDER71(),
            spender,
            _allowances[_MSGSENDER71()][spender].ADD95(addedValue)
        );
        return true;
    }

    function DECREASEALLOWANCE27(address spender, uint256 subtractedValue)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        _APPROVE12(
            _MSGSENDER71(),
            spender,
            _allowances[_MSGSENDER71()][spender].SUB0(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function _TRANSFER57(	//inject NONSTANDARD NAMING
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB0(
            amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balances[recipient] = _balances[recipient].ADD95(amount);
        emit TRANSFER48(sender, recipient, amount);
    }

    function _MINT16(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD95(amount);
        _balances[account] = _balances[account].ADD95(amount);
        emit TRANSFER48(address(0), account, amount);
    }

    function _BURN5(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].SUB0(
            amount,
            "ERC20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.SUB0(amount);
        emit TRANSFER48(account, address(0), amount);
    }

    function _APPROVE12(	//inject NONSTANDARD NAMING
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL56(owner, spender, amount);
    }
}

contract erc20detailed25 is ierc2068 {	//inject NONSTANDARD NAMING
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals
    ) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    function NAME49() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

    function SYMBOL36() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

    function DECIMALS29() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

library safemath98 {	//inject NONSTANDARD NAMING
    function ADD95(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function SUB0(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB0(a, b, "SafeMath: subtraction overflow");
    }

    function SUB0(	//inject NONSTANDARD NAMING
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function MUL35(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function DIV21(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV21(a, b, "SafeMath: division by zero");
    }

    function DIV21(	//inject NONSTANDARD NAMING
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
}

library address60 {	//inject NONSTANDARD NAMING
    function ISCONTRACT31(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        bytes32 codehash;

            bytes32 accountHash
         = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

library safeerc2024 {	//inject NONSTANDARD NAMING
    using safemath98 for uint256;
    using address60 for address;

    function SAFETRANSFER69(	//inject NONSTANDARD NAMING
        ierc2068 token,
        address to,
        uint256 value
    ) internal {
        CALLOPTIONALRETURN38(
            token,
            abi.encodeWithSelector(token.TRANSFER74.selector, to, value)
        );
    }

    function SAFETRANSFERFROM69(	//inject NONSTANDARD NAMING
        ierc2068 token,
        address from,
        address to,
        uint256 value
    ) internal {
        CALLOPTIONALRETURN38(
            token,
            abi.encodeWithSelector(token.TRANSFERFROM66.selector, from, to, value)
        );
    }

    function SAFEAPPROVE52(	//inject NONSTANDARD NAMING
        ierc2068 token,
        address spender,
        uint256 value
    ) internal {
        require(
            (value == 0) || (token.ALLOWANCE0(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN38(
            token,
            abi.encodeWithSelector(token.APPROVE81.selector, spender, value)
        );
    }

    function CALLOPTIONALRETURN38(ierc2068 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        require(address(token).ISCONTRACT31(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

contract gnb86 is erc205, erc20detailed25 {	//inject NONSTANDARD NAMING
    using safeerc2024 for ierc2068;
    using address60 for address;
    using safemath98 for uint256;

    constructor(address _winner) public erc20detailed25("Global Newmedia Bank", "GNB", 18) {
        _MINT16(_winner, 100000000000 * 1e18);
    }
}