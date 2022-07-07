/**
 *Submitted for verification at Etherscan.io on 2020-11-12
*/

pragma solidity ^0.5.16;

library Math {

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
    }
}

library SafeMath {
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub( uint256 a, uint256 b, string memory errorMessage ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
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

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div( uint256 a, uint256 b, string memory errorMessage ) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod( uint256 a, uint256 b, string memory errorMessage ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor() internal {}

    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _owner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library Address {
    
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != 0x0 && codehash != accountHash);
    }

    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require( address(this).balance >= amount, "Address: insufficient balance" );

        (bool success, ) = recipient.call.value(amount)("");
        require( success, "Address: unable to send value, recipient may have reverted" );
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function mint(address account, uint256 amount) external;
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval( address indexed owner, address indexed spender, uint256 value );
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer( IERC20 token, address to, uint256 value ) internal { callOptionalReturn( token, abi.encodeWithSelector(token.transfer.selector, to, value) ); }

    function safeTransferFrom( IERC20 token, address from, address to, uint256 value ) internal {
        callOptionalReturn( token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value) );
    }

    function safeApprove( IERC20 token, address spender, uint256 value ) internal {
        require( (value == 0) || (token.allowance(address(this), spender) == 0), "SafeERC20: approve from non-zero to non-zero allowance" );
        callOptionalReturn( token, abi.encodeWithSelector(token.approve.selector, spender, value) );
    }

    function safeIncreaseAllowance( IERC20 token, address spender, uint256 value ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add( value );
        callOptionalReturn( token, abi.encodeWithSelector( token.approve.selector, spender, newAllowance ) );
    }

    function safeDecreaseAllowance( IERC20 token, address spender, uint256 value ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub( value, "SafeERC20: decreased allowance below zero" );
        callOptionalReturn( token, abi.encodeWithSelector( token.approve.selector, spender, newAllowance ) );
    }

    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {
            require( abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed" );
        }
    }
}

contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor( string memory name, string memory symbol, uint8 decimals ) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    function name() public view returns (string memory) {
        return _name;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function symbol() public view returns (string memory) {
        return _symbol;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function decimals() public view returns (uint8) {
        return _decimals;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}

/**
 * Vault Strategy Interface
 */
interface IGOFStrategy {
    function want() external view returns (address);
    function deposit() external;
    function withdraw(address) external;
    function withdraw(uint) external;
    function withdrawAll() external returns (uint);
    function balanceOf() external view returns (uint);
}

/**
 * 
 */
interface Converter {
    function convert(address) external returns (uint);
}

/**
 *
 */
interface OneSplitAudit {
    function swap(
        address fromToken,
        address destToken,
        uint256 amount,
        uint256 minReturn,
        uint256[] calldata distribution,
        uint256 flags
    )
        external
        payable
        returns(uint256 returnAmount);
    
    function getExpectedReturn(
        address fromToken,
        address destToken,
        uint256 amount,
        uint256 parts,
        uint256 flags // See constants in IOneSplit.sol
    )
        external
        view
        returns(
            uint256 returnAmount,
            uint256[] memory distribution
        );
}

/**
 *  @dev
 *  The controller of Strategy
 *  Distribute different strategies according to different tokens
 */
contract GOFStrategyControllerV2 {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;
    
    address internal governance;
    address internal strategist;

    address internal onesplit;
    address internal rewards;
    address internal factory;
    mapping(address => address) internal vaults;
    mapping(address => address) internal strategies;
    mapping(address => mapping(address => address)) internal converters;
    
    mapping(address => mapping(address => bool)) internal approvedStrategies;

    uint internal split = 500;
    uint internal constant max = 10000;
    
    constructor(address _rewards) public {
        governance = tx.origin;
        strategist = tx.origin;

        onesplit = address(0x50FDA034C0Ce7a8f7EFDAebDA7Aa7cA21CC1267e);
        rewards = _rewards;
    }
    
    function setFactory(address _factory) public {
        require(msg.sender == governance, "Golff:!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        factory = _factory;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function setSplit(uint _split) public {
        require(msg.sender == governance, "Golff:!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        split = _split;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function setOneSplit(address _onesplit) public {
        require(msg.sender == governance, "Golff:!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        onesplit = _onesplit;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function setGovernance(address _governance) public {
        require(msg.sender == governance, "Golff:!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        governance = _governance;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setRewards(address _rewards) public {
        require(msg.sender == governance, "Golff:!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        rewards = _rewards;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function setVault(address _token, address _vault) public {
        require(msg.sender == strategist || msg.sender == governance, "Golff:!strategist");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(vaults[_token] == address(0), "Golff:vault");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        vaults[_token] = _vault;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
     function approveStrategy(address _token, address _strategy) public {
        require(msg.sender == governance, "Golff:!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        approvedStrategies[_token][_strategy] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function revokeStrategy(address _token, address _strategy) public {
        require(msg.sender == governance, "Golff:!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        approvedStrategies[_token][_strategy] = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setConverter(address _input, address _output, address _converter) public {
        require(msg.sender == strategist || msg.sender == governance, "Golff:!strategist");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        converters[_input][_output] = _converter;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function setStrategy(address _token, address _strategy) public {
        require(msg.sender == strategist || msg.sender == governance, "Golff:!strategist");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(approvedStrategies[_token][_strategy] == true, "Golff:!approved");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        address _current = strategies[_token];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        //111111,111111111111
        if (_current != address(0)) {
           IGOFStrategy(_current).withdrawAll();
        }
        strategies[_token] = _strategy;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    /**
     * 1111
     * @param _token staking token
     * @param _amount staking amount
     */
    function earn(address _token, uint _amount) public {
        address _strategy = strategies[_token]; //111111111	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        address _want = IGOFStrategy(_strategy).want();//11111token11
        if (_want != _token) {//11111111111111,11111
            address converter = converters[_token][_want];//1111111.	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            IERC20(_token).safeTransfer(converter, _amount);//111111
            _amount = Converter(converter).convert(_strategy);//1111...
            IERC20(_want).safeTransfer(_strategy, _amount);
        } else {
            IERC20(_token).safeTransfer(_strategy, _amount);
        }
        IGOFStrategy(_strategy).deposit();//11
    }
    
    /**
     * 11token111
     * @param _token staking token
     */
    function balanceOf(address _token) external view returns (uint) {
        return IGOFStrategy(strategies[_token]).balanceOf();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    /**
     * 1111
     * @param _token staking token
     */
    function withdrawAll(address _token) public {
        require(msg.sender == strategist || msg.sender == governance, "Golff:!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        IGOFStrategy(strategies[_token]).withdrawAll();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    /**
     *
     */
    function inCaseTokensGetStuck(address _token, uint _amount) public {
        require(msg.sender == strategist || msg.sender == governance, "Golff:!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        IERC20(_token).safeTransfer(governance, _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    /**
     *
     */
    function getExpectedReturn(address _strategy, address _token, uint parts) public view returns (uint expected) {
        uint _balance = IERC20(_token).balanceOf(_strategy);//11111 1111111
        address _want = IGOFStrategy(_strategy).want();//11111111.
        (expected,) = OneSplitAudit(onesplit).getExpectedReturn(_token, _want, _balance, parts, 0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    // Only allows to withdraw non-core strategy tokens ~ this is over and above normal yield
    function yearn(address _strategy, address _token, uint parts) public {
        require(msg.sender == strategist || msg.sender == governance, "Golff:!governance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        // This contract should never have value in it, but just incase since this is a public call
        uint _before = IERC20(_token).balanceOf(address(this));
        IGOFStrategy(_strategy).withdraw(_token);
        uint _after =  IERC20(_token).balanceOf(address(this));
        if (_after > _before) {
            uint _amount = _after.sub(_before);
            address _want = IGOFStrategy(_strategy).want();
            uint[] memory _distribution;
            uint _expected;
            _before = IERC20(_want).balanceOf(address(this));
            IERC20(_token).safeApprove(onesplit, 0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            IERC20(_token).safeApprove(onesplit, _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            (_expected, _distribution) = OneSplitAudit(onesplit).getExpectedReturn(_token, _want, _amount, parts, 0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            OneSplitAudit(onesplit).swap(_token, _want, _amount, _expected, _distribution, 0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            _after = IERC20(_want).balanceOf(address(this));
            if (_after > _before) {
                _amount = _after.sub(_before);
                uint _reward = _amount.mul(split).div(max);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                earn(_want, _amount.sub(_reward));
                IERC20(_want).safeTransfer(rewards, _reward);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }
        }
    }
    
    /**
     * 11
     * @param _token token to ben withdraw
     * @param _amount amount
     */
    function withdraw(address _token, uint _amount) public {
        require(msg.sender == vaults[_token], "Golff:!vault");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        IGOFStrategy(strategies[_token]).withdraw(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}