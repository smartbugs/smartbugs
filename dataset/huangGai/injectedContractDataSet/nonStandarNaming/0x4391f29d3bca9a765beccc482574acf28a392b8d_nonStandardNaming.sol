                                                                 

// File: @openzeppelin/contracts/GSN/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
abstract contract Context {
    function _MSGSENDER992() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA175() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol



pragma solidity ^0.7.0;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
abstract contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED997(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () {
        address msgSender = _MSGSENDER992();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED997(address(0), msgSender);
    }

                                                                     
    function OWNER339() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER550() {	//inject NONSTANDARD NAMING
        require(_owner == _MSGSENDER992(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP139() public virtual ONLYOWNER550 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED997(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP225(address newOwner) public virtual ONLYOWNER550 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED997(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol



pragma solidity ^0.7.0;

                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY922() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF652(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER63(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE433(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE424(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM684(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER2(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL660(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: @openzeppelin/contracts/math/SafeMath.sol



pragma solidity ^0.7.0;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD188(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB887(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB887(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB887(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL824(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV117(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV117(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV117(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD43(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD43(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD43(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/utils/Address.sol



pragma solidity ^0.7.0;

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT474(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE77(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL72(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL72(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL72(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE560(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE798(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE798(target, data, value, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE798(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE560(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE560(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT474(target), "Address: call to non-contract");

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

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol



pragma solidity ^0.7.0;





                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

                                                                                                                                                                                                                                                                                                                           
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

                                                          
    function NAME785() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                                                                          
    function SYMBOL27() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function DECIMALS635() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }

                                                     
    function TOTALSUPPLY922() public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                   
    function BALANCEOF652(address account) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER63(address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER915(_MSGSENDER992(), recipient, amount);
        return true;
    }

                                                   
    function ALLOWANCE433(address owner, address spender) public view virtual override returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                   
    function APPROVE424(address spender, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE360(_MSGSENDER992(), spender, amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM684(address sender, address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER915(sender, recipient, amount);
        _APPROVE360(sender, _MSGSENDER992(), _allowances[sender][_MSGSENDER992()].SUB887(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE518(address spender, uint256 addedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE360(_MSGSENDER992(), spender, _allowances[_MSGSENDER992()][spender].ADD188(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE831(address spender, uint256 subtractedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE360(_MSGSENDER992(), spender, _allowances[_MSGSENDER992()][spender].SUB887(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER915(address sender, address recipient, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _BEFORETOKENTRANSFER811(sender, recipient, amount);

        _balances[sender] = _balances[sender].SUB887(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD188(amount);
        emit TRANSFER2(sender, recipient, amount);
    }

                                                                                                                                                                                                                                                                       
    function _MINT943(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _BEFORETOKENTRANSFER811(address(0), account, amount);

        _totalSupply = _totalSupply.ADD188(amount);
        _balances[account] = _balances[account].ADD188(amount);
        emit TRANSFER2(address(0), account, amount);
    }

                                                                                                                                                                                                                                                                                                                        
    function _BURN600(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _BEFORETOKENTRANSFER811(account, address(0), amount);

        _balances[account] = _balances[account].SUB887(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB887(amount);
        emit TRANSFER2(account, address(0), amount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                
    function _APPROVE360(address owner, address spender, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL660(owner, spender, amount);
    }

                                                                                                                                                                                                                                                                                                                            
    function _SETUPDECIMALS497(uint8 decimals_) internal {	//inject NONSTANDARD NAMING
        _decimals = decimals_;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function _BEFORETOKENTRANSFER811(address from, address to, uint256 amount) internal virtual { }	//inject NONSTANDARD NAMING
}

// File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol



pragma solidity ^0.7.0;



                                                                                                                                                                                                                
abstract contract ERC20Burnable is Context, ERC20 {
    using SafeMath for uint256;

                                                                                                      
    function BURN436(uint256 amount) public virtual {	//inject NONSTANDARD NAMING
        _BURN600(_MSGSENDER992(), amount);
    }

                                                                                                                                                                                                                                                                                                           
    function BURNFROM809(address account, uint256 amount) public virtual {	//inject NONSTANDARD NAMING
        uint256 decreasedAllowance = ALLOWANCE433(account, _MSGSENDER992()).SUB887(amount, "ERC20: burn amount exceeds allowance");

        _APPROVE360(account, _MSGSENDER992(), decreasedAllowance);
        _BURN600(account, amount);
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol



pragma solidity ^0.7.0;


                                                                             
abstract contract ERC20Capped is ERC20 {
    using SafeMath for uint256;

    uint256 private _cap;

                                                                                                                                     
    constructor (uint256 cap_) {
        require(cap_ > 0, "ERC20Capped: cap is 0");
        _cap = cap_;
    }

                                                                        
    function CAP988() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _cap;
    }

                                                                                                                                                                           
    function _BEFORETOKENTRANSFER811(address from, address to, uint256 amount) internal virtual override {	//inject NONSTANDARD NAMING
        super._BEFORETOKENTRANSFER811(from, to, amount);

        if (from == address(0)) { // When minting tokens
            require(TOTALSUPPLY922().ADD188(amount) <= _cap, "ERC20Capped: cap exceeded");
        }
    }
}

// File: eth-token-recover/contracts/TokenRecover.sol



pragma solidity ^0.7.0;



                                                                                                  
contract TokenRecover is Ownable {

                                                                                                                                                                                                                                             
    function RECOVERERC20547(address tokenAddress, uint256 tokenAmount) public ONLYOWNER550 {	//inject NONSTANDARD NAMING
        IERC20(tokenAddress).TRANSFER63(OWNER339(), tokenAmount);
    }
}

// File: contracts/service/ServiceReceiver.sol



pragma solidity ^0.7.0;


                                                                               
contract ServiceReceiver is TokenRecover {

    mapping (bytes32 => uint256) private _prices;

    event CREATED286(string serviceName, address indexed serviceAddress);	//inject NONSTANDARD NAMING

    function PAY507(string memory serviceName) public payable {	//inject NONSTANDARD NAMING
        require(msg.value == _prices[_TOBYTES32816(serviceName)], "ServiceReceiver: incorrect price");

        emit CREATED286(serviceName, _MSGSENDER992());
    }

    function GETPRICE918(string memory serviceName) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _prices[_TOBYTES32816(serviceName)];
    }

    function SETPRICE38(string memory serviceName, uint256 amount) public ONLYOWNER550 {	//inject NONSTANDARD NAMING
        _prices[_TOBYTES32816(serviceName)] = amount;
    }

    function WITHDRAW870(uint256 amount) public ONLYOWNER550 {	//inject NONSTANDARD NAMING
        payable(OWNER339()).transfer(amount);
    }

    function _TOBYTES32816(string memory serviceName) private pure returns (bytes32) {	//inject NONSTANDARD NAMING
        return keccak256(abi.encode(serviceName));
    }
}

// File: contracts/service/ServicePayer.sol



pragma solidity ^0.7.0;


                                                                         
contract ServicePayer {

    constructor (address payable receiver, string memory serviceName) payable {
        ServiceReceiver(receiver).PAY507{value: msg.value}(serviceName);
    }
}

// File: contracts/token/ERC20/CommonERC20.sol



pragma solidity ^0.7.0;





                                                                       
contract CommonERC20 is ERC20Capped, ERC20Burnable, Ownable, ServicePayer {

    // indicates if minting is finished
    bool private _mintingFinished = false;

                                                         
    event MINTFINISHED365();	//inject NONSTANDARD NAMING

                                                                              
    modifier CANMINT575() {	//inject NONSTANDARD NAMING
        require(!_mintingFinished, "CommonERC20: minting is finished");
        _;
    }

    constructor (
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 cap,
        uint256 initialBalance,
        address payable feeReceiver
    ) ERC20(name, symbol) ERC20Capped(cap) ServicePayer(feeReceiver, "CommonERC20") payable {
        _SETUPDECIMALS497(decimals);

        _MINT943(_MSGSENDER992(), initialBalance);
    }

                                                             
    function MINTINGFINISHED194() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _mintingFinished;
    }

                                                                                                                                                                      
    function MINT11(address to, uint256 value) public CANMINT575 ONLYOWNER550 {	//inject NONSTANDARD NAMING
        _MINT943(to, value);
    }

                                                                
    function FINISHMINTING61() public CANMINT575 ONLYOWNER550 {	//inject NONSTANDARD NAMING
        _mintingFinished = true;

        emit MINTFINISHED365();
    }

                                                             
    function _BEFORETOKENTRANSFER811(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {	//inject NONSTANDARD NAMING
        super._BEFORETOKENTRANSFER811(from, to, amount);
    }
}