pragma solidity ^0.5.10;

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD174(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB458(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL842(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV712(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD1000(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

                                                                                                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY713() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF597(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER875(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE411(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    function APPROVE183(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM17(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER72(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL424(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

                                                                                                                                                                                                                                                                                                                                                                       
contract Ownable {
    address private _owner;

    event OWNERSHIPTRANSFERRED585(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        _owner = msg.sender;
        emit OWNERSHIPTRANSFERRED585(address(0), _owner);
    }

                                                                     
    function OWNER749() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER904() {	//inject NONSTANDARD NAMING
        require(ISOWNER531(), "Ownable: caller is not the owner");
        _;
    }

                                                                            
    function ISOWNER531() public view returns (bool) {	//inject NONSTANDARD NAMING
        return msg.sender == _owner;
    }

                                                                                                                                                                                                                                                                                                                                                 
    function RENOUNCEOWNERSHIP876() public ONLYOWNER904 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED585(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP672(address newOwner) public ONLYOWNER904 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP705(newOwner);
    }

                                                                                              
    function _TRANSFEROWNERSHIP705(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED585(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: eth-token-recover/contracts/TokenRecover.sol

                                                                                                                                                                  
contract TokenRecover is Ownable {

                                                                                                                                                                                                                                             
    function RECOVERERC20610(address tokenAddress, uint256 tokenAmount) public ONLYOWNER904 {	//inject NONSTANDARD NAMING
        IERC20(tokenAddress).TRANSFER875(OWNER749(), tokenAmount);
    }
}

// File: openzeppelin-solidity/contracts/access/Roles.sol

                                                                                  
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

                                                                
    function ADD174(Role storage role, address account) internal {	//inject NONSTANDARD NAMING
        require(!HAS393(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

                                                                    
    function REMOVE440(Role storage role, address account) internal {	//inject NONSTANDARD NAMING
        require(HAS393(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

                                                                                  
    function HAS393(Role storage role, address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

// File: contracts/access/roles/OperatorRole.sol

contract OperatorRole {
    using Roles for Roles.Role;

    event OPERATORADDED296(address indexed account);	//inject NONSTANDARD NAMING
    event OPERATORREMOVED455(address indexed account);	//inject NONSTANDARD NAMING

    Roles.Role private _operators;

    constructor() internal {
        _ADDOPERATOR180(msg.sender);
    }

    modifier ONLYOPERATOR220() {	//inject NONSTANDARD NAMING
        require(ISOPERATOR589(msg.sender));
        _;
    }

    function ISOPERATOR589(address account) public view returns (bool) {	//inject NONSTANDARD NAMING
        return _operators.HAS393(account);
    }

    function ADDOPERATOR496(address account) public ONLYOPERATOR220 {	//inject NONSTANDARD NAMING
        _ADDOPERATOR180(account);
    }

    function RENOUNCEOPERATOR579() public {	//inject NONSTANDARD NAMING
        _REMOVEOPERATOR220(msg.sender);
    }

    function _ADDOPERATOR180(address account) internal {	//inject NONSTANDARD NAMING
        _operators.ADD174(account);
        emit OPERATORADDED296(account);
    }

    function _REMOVEOPERATOR220(address account) internal {	//inject NONSTANDARD NAMING
        _operators.REMOVE440(account);
        emit OPERATORREMOVED455(account);
    }
}

// File: contracts/utils/Contributions.sol

                                                                                                                                                                                    
contract Contributions is OperatorRole, TokenRecover {
    using SafeMath for uint256;

    struct Contributor {
        uint256 weiAmount;
        uint256 tokenAmount;
        bool exists;
    }

    // the number of sold tokens
    uint256 private _totalSoldTokens;

    // the number of wei raised
    uint256 private _totalWeiRaised;

    // list of addresses who contributed in crowdsales
    address[] private _addresses;

    // map of contributors
    mapping(address => Contributor) private _contributors;

    constructor() public {} // solhint-disable-line no-empty-blocks

                                                        
    function TOTALSOLDTOKENS700() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSoldTokens;
    }

                                                       
    function TOTALWEIRAISED967() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalWeiRaised;
    }

                                                                     
    function GETCONTRIBUTORADDRESS38(uint256 index) public view returns (address) {	//inject NONSTANDARD NAMING
        return _addresses[index];
    }

                                                                                                                
    function GETCONTRIBUTORSLENGTH778() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _addresses.length;
    }

                                                                                                                                           
    function WEICONTRIBUTION247(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _contributors[account].weiAmount;
    }

                                                                                                                                        
    function TOKENBALANCE103(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _contributors[account].tokenAmount;
    }

                                                                                                                        
    function CONTRIBUTOREXISTS747(address account) public view returns (bool) {	//inject NONSTANDARD NAMING
        return _contributors[account].exists;
    }

                                                                                                                                                                                                                               
    function ADDBALANCE147(address account, uint256 weiAmount, uint256 tokenAmount) public ONLYOPERATOR220 {	//inject NONSTANDARD NAMING
        if (!_contributors[account].exists) {
            _addresses.push(account);
            _contributors[account].exists = true;
        }

        _contributors[account].weiAmount = _contributors[account].weiAmount.ADD174(weiAmount);
        _contributors[account].tokenAmount = _contributors[account].tokenAmount.ADD174(tokenAmount);

        _totalWeiRaised = _totalWeiRaised.ADD174(weiAmount);
        _totalSoldTokens = _totalSoldTokens.ADD174(tokenAmount);
    }

                                                                                                                         
    function REMOVEOPERATOR69(address account) public ONLYOWNER904 {	//inject NONSTANDARD NAMING
        _REMOVEOPERATOR220(account);
    }
}