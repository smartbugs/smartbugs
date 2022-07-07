                                                                 

pragma solidity ^0.6.0;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
contract context31 {	//inject NONSTANDARD NAMING
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }

    function _MSGSENDER38() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA21() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                       
contract pausable4 is context31 {	//inject NONSTANDARD NAMING
                                                                             
    event PAUSED71(address account);	//inject NONSTANDARD NAMING

                                                                          
    event UNPAUSED80(address account);	//inject NONSTANDARD NAMING

    bool private _paused;

                                                                       
    constructor () internal {
        _paused = false;
    }

                                                                                        
    function PAUSED92() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _paused;
    }

                                                                                                                                                                                   
    modifier WHENNOTPAUSED64() {	//inject NONSTANDARD NAMING
        require(!_paused, "Pausable: paused");
        _;
    }

                                                                                                                                                                           
    modifier WHENPAUSED19() {	//inject NONSTANDARD NAMING
        require(_paused, "Pausable: not paused");
        _;
    }

                                                                                                                                
    function _PAUSE59() internal virtual WHENNOTPAUSED64 {	//inject NONSTANDARD NAMING
        _paused = true;
        emit PAUSED71(_MSGSENDER38());
    }

                                                                                                                             
    function _UNPAUSE68() internal virtual WHENPAUSED19 {	//inject NONSTANDARD NAMING
        _paused = false;
        emit UNPAUSED80(_MSGSENDER38());
    }
}




// SPDX-License-Identifier: MIT

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract ownable36 is context31 {	//inject NONSTANDARD NAMING
    address private _owner;

    event OWNERSHIPTRANSFERRED24(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        address msgSender = _MSGSENDER38();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED24(address(0), msgSender);
    }

                                                                     
    function OWNER63() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER91() {	//inject NONSTANDARD NAMING
        require(_owner == _MSGSENDER38(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP71() public virtual ONLYOWNER91 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED24(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP14(address newOwner) public virtual ONLYOWNER91 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED24(_owner, newOwner);
        _owner = newOwner;
    }
}


                                                                      
interface ierc2023 {	//inject NONSTANDARD NAMING
                                                                      
    function TOTALSUPPLY20() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF18(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER67(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE42(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE75(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM2(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER99(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL65(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}



                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library safemath20 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                             
    function ADD58(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB89(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB89(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                     
    function SUB89(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL82(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV80(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV80(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function DIV80(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD46(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD46(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function MOD46(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}


pragma solidity ^0.6.0;

                                                                   
library address74 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT62(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE71(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}



                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
contract erc2035 is context31, ierc2023, pausable4, ownable36 {	//inject NONSTANDARD NAMING
    using safemath20 for uint256;
    using address74 for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private constant _name1 = "Bifrost";	//inject NONSTANDARD NAMING
    string private constant _symbol95 = "BFC";	//inject NONSTANDARD NAMING
    uint8 private constant _decimals18 = 18;	//inject NONSTANDARD NAMING


                                                                                                                                                                                                                                                                                                                           


    constructor () public {
        _totalSupply = 4 * (10 ** 9) * (10 ** uint256(_decimals18));
        _balances[msg.sender] = _totalSupply;
    }

                                                          
    function NAME54() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name1;
    }

                                                                                                          
    function SYMBOL73() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol95;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function DECIMALS93() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals18;
    }

                                                     
    function TOTALSUPPLY20() public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                   
    function BALANCEOF18(address account) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER67(address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER17(_MSGSENDER38(), recipient, amount);
        return true;
    }

                                                   
    function ALLOWANCE42(address owner, address spender) public view virtual override returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                   
    function APPROVE75(address spender, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE4(_MSGSENDER38(), spender, amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM2(address sender, address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER17(sender, recipient, amount);
        _APPROVE4(sender, _MSGSENDER38(), _allowances[sender][_MSGSENDER38()].SUB89(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE96(address spender, uint256 addedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE4(_MSGSENDER38(), spender, _allowances[_MSGSENDER38()][spender].ADD58(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE46(address spender, uint256 subtractedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE4(_MSGSENDER38(), spender, _allowances[_MSGSENDER38()][spender].SUB89(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER17(address sender, address recipient, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _BEFORETOKENTRANSFER3(sender, recipient, amount);

        _balances[sender] = _balances[sender].SUB89(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD58(amount);
        emit TRANSFER99(sender, recipient, amount);
    }

                                                                                                                                                                                                                                                                                                                        
    function _BURN38(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _BEFORETOKENTRANSFER3(account, address(0), amount);

        _balances[account] = _balances[account].SUB89(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB89(amount);
        emit TRANSFER99(account, address(0), amount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function _APPROVE4(address owner, address spender, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL65(owner, spender, amount);
    }


                                                                                                      
    function BURN85(uint256 amount) public virtual {	//inject NONSTANDARD NAMING
        _BURN38(_MSGSENDER38(), amount);
    }


                                                                                                                                                                                                                                                                                                           
    function BURNFROM76(address account, uint256 amount) public virtual {	//inject NONSTANDARD NAMING
        uint256 decreasedAllowance = ALLOWANCE42(account, _MSGSENDER38()).SUB89(amount, "ERC20: burn amount exceeds allowance");

        _APPROVE4(account, _MSGSENDER38(), decreasedAllowance);
        _BURN38(account, amount);
    }



                                                                                                                                

    function PAUSE87() public ONLYOWNER91 {	//inject NONSTANDARD NAMING
        _PAUSE59();
    }


                                                                                                                             
    function UNPAUSE32() public ONLYOWNER91 {	//inject NONSTANDARD NAMING
        _UNPAUSE68();
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    function _BEFORETOKENTRANSFER3(address from, address to, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(!PAUSED92(), "ERC20Pausable: token transfer while paused");
    }
}