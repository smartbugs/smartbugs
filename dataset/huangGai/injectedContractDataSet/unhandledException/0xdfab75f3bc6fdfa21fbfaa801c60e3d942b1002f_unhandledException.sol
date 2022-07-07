/**
 *Submitted for verification at Etherscan.io on 2020-10-12
*/

pragma solidity ^0.5.16;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }
}

contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }
    function name() public view returns (string memory) {
        return _name;
    }
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

library SafeERC20 {
    using SafeMath for uint;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = (false, bytes(msg.data));
	 address(token).call(data);	//inject UNHANDLED EXCEPTION

        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract Ownable {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () public {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract YFIRv2 is ERC20Detailed, Ownable {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint;

    address public governance;
    uint256 _totalSupply = 15000*(10**18);
    
    mapping (address => uint256) internal YFIRBalances;
    mapping (address => mapping (address => uint256)) public _allowed;
    uint256 YFIRBurned;
    uint256 public burnPercent = 0;
    uint256 public devPercent = 0;
    uint256 public poolPercent = 0;
    address public poolAddress = 0x5398ed9e0292599300357D1871244Cb8704aECF9;
    address public devAddress = 0xAc03B69a99D945EDd1ffF21AB5a77C000Eb7B72a;

    constructor () public ERC20Detailed("Yearn Recovery", "YFIR", 18) {
        governance = msg.sender;
        _mint(msg.sender, _totalSupply);
    }

    function setGovernance(address _governance) public {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }
    
    function setBurnPercent(uint256 _burnPercent) public {
        require(msg.sender == governance, "!governance");
        burnPercent = _burnPercent;
    }
    
    function setPoolPercent(uint256 _poolPercent) public {
        require(msg.sender == governance, "!governance");
        poolPercent = _poolPercent;
    }
    
    function setDevPercent(uint256 _devPercent) public onlyOwner{
        require(devPercent <= 10, "devPercent cannot be bigger than 1%");
        devPercent = _devPercent;
    }
    
    function setDevAddress(address _devAddress) public onlyOwner {
        devAddress = _devAddress;
    }
    
    function setPoolAddress(address _poolAddress) public {
        require(msg.sender == governance, "!governance");
        poolAddress = _poolAddress;
    }
    
    function transfer(address to, uint256 value) public returns (bool) {
        require(value <= YFIRBalances[msg.sender]);
        require(to != address(0));

        uint256 burnValue = value.mul(burnPercent).div(1000);
        uint256 devValue = value.mul(devPercent).div(1000);
        uint256 poolValue = value.mul(poolPercent).div(1000);
        uint256 tokensToTransfer = value.sub(burnValue).sub(devValue).sub(poolValue);

        YFIRBalances[msg.sender] = YFIRBalances[msg.sender].sub(value);
        YFIRBalances[to] = YFIRBalances[to].add(tokensToTransfer);
        YFIRBalances[poolAddress] = YFIRBalances[poolAddress].add(poolValue);
        YFIRBalances[devAddress] = YFIRBalances[devAddress].add(devValue);
        
        _totalSupply = _totalSupply.sub(burnValue);
        YFIRBurned = YFIRBurned.add(burnValue);

        emit Transfer(msg.sender, to, tokensToTransfer);
        if (poolValue > 0) emit Transfer(msg.sender, poolAddress, poolValue);
        if (devValue > 0) emit Transfer(msg.sender, devAddress, devValue);
        if (burnValue > 0) emit Transfer(msg.sender, address(0), burnValue);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(value <= YFIRBalances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));

        YFIRBalances[from] = YFIRBalances[from].sub(value);

       
        uint256 burnValue = value.mul(burnPercent).div(1000);
        uint256 devValue = value.mul(devPercent).div(1000);
        uint256 poolValue = value.mul(poolPercent).div(1000);
        uint256 tokensToTransfer = value.sub(burnValue).sub(devValue).sub(poolValue);

        YFIRBalances[to] = YFIRBalances[to].add(tokensToTransfer);
        YFIRBalances[poolAddress] = YFIRBalances[poolAddress].add(poolValue);
        YFIRBalances[devAddress] = YFIRBalances[devAddress].add(devValue);
        
        _totalSupply = _totalSupply.sub(burnValue);
        YFIRBurned = YFIRBurned.add(burnValue);

        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
  
        emit Transfer(from, to, tokensToTransfer);
        if (poolValue > 0) emit Transfer(from, poolAddress, poolValue);
        if (devValue > 0) emit Transfer(from, devAddress, devValue);
        if (burnValue > 0) emit Transfer(from, address(0), burnValue);

        return true;
    }
    
    function getBurned() public view returns(uint){
        return YFIRBurned;
    }
    
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address owner) public view returns (uint256) {
        return YFIRBalances[owner];
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0));
        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(spender != address(0));
        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }
    
    function _mint(address account, uint256 amount) internal {
        require(amount != 0);
        YFIRBalances[account] = YFIRBalances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
  
  

}