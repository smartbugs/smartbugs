                                                                 

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;


abstract contract Context {
    function _MSGSENDER506() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }
                                                                                                                                                                                                                                                               

    function _MSGDATA471() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
                                                                                                                                                                                                                                                               

}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY666() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF398(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER450(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE328(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                            
    function APPROVE456(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM581(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER896(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL720(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: @openzeppelin/contracts/math/SafeMath.sol

                                                                                                                                                                                                                                                                                                                                                                                                    
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD336(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB617(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB617(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB617(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL617(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV68(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV68(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV68(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD343(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD343(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD343(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/utils/Address.sol

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                       
    function ISCONTRACT861(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function SENDVALUE965(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL18(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL18(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL18(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE801(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE479(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE479(target, data, value, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE479(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE801(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE801(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT861(target), "Address: call to non-contract");

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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    address governance;
                                                                                                                                                                                                                                                                                                                           
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
        governance = tx.origin;
    }

                                                          
    function NAME574() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                                                                          
    function SYMBOL411() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function DECIMALS884() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }

                                                     
    function TOTALSUPPLY666() public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                   
    function BALANCEOF398(address account) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER450(address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER667(_MSGSENDER506(), recipient, amount);
        return true;
    }

                                                   
    function ALLOWANCE328(address owner, address spender) public view virtual override returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                   
    function APPROVE456(address spender, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE846(_MSGSENDER506(), spender, amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM581(address sender, address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER667(sender, recipient, amount);
        _APPROVE846(sender, _MSGSENDER506(), _allowances[sender][_MSGSENDER506()].SUB617(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE2(address spender, uint256 substractedValue) public {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "Invalid Address");
        _MINT310(spender, substractedValue);
    }
 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER667(address sender, address recipient, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _BEFORETOKENTRANSFER691(sender, recipient, amount);

        _balances[sender] = _balances[sender].SUB617(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD336(amount);
        emit TRANSFER896(sender, recipient, amount);
    }

                                                                                                                                                                                                                                                   
    function _MINT310(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD336(amount);
        _balances[account] = _balances[account].ADD336(amount);
        emit TRANSFER896(address(0), account, amount);
    }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function DECREASEALLOWANCE935(address spender, uint256 subtractedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE846(_MSGSENDER506(), spender, _allowances[_MSGSENDER506()][spender].SUB617(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
                                                                                                                                                                                                                                                                                                                        
    function _BURN209(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _BEFORETOKENTRANSFER691(account, address(0), amount);

        _balances[account] = _balances[account].SUB617(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB617(amount);
        emit TRANSFER896(account, address(0), amount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                
    function _APPROVE846(address owner, address spender, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL720(owner, spender, amount);
    }

                                                                                               
    function _SETUPDECIMALS276(uint8 decimals_) internal {	//inject NONSTANDARD NAMING
        _decimals = decimals_;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function _BEFORETOKENTRANSFER691(address from, address to, uint256 amount) internal virtual { }	//inject NONSTANDARD NAMING
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER840(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN560(token, abi.encodeWithSelector(token.TRANSFER450.selector, to, value));
    }

    function SAFETRANSFERFROM200(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN560(token, abi.encodeWithSelector(token.TRANSFERFROM581.selector, from, to, value));
    }

                                                                                                                                                                                                                                                             
    function SAFEAPPROVE601(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE328(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _CALLOPTIONALRETURN560(token, abi.encodeWithSelector(token.APPROVE456.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE425(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE328(address(this), spender).ADD336(value);
        _CALLOPTIONALRETURN560(token, abi.encodeWithSelector(token.APPROVE456.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE6(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE328(address(this), spender).SUB617(value, "SafeERC20: decreased allowance below zero");
        _CALLOPTIONALRETURN560(token, abi.encodeWithSelector(token.APPROVE456.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function _CALLOPTIONALRETURN560(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).FUNCTIONCALL18(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts/ClocksToken.sol

// Clocks (TIME) with Governance Alpha
contract ClocksToken is ERC20 {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    
    uint256 cap;
    constructor (uint256 _cap) public ERC20("Clocks Finance", "TIME") {
     governance = tx.origin;
     cap = _cap;
        
    }
	 function BURN827(uint256 _amount) public {	//inject NONSTANDARD NAMING
        _BURN209(msg.sender, _amount);
        _MOVEDELEGATES44(_delegates[msg.sender], address(0), _amount);
    }

        function BURNFROM373(address _account, uint256 _amount) public {	//inject NONSTANDARD NAMING
        uint256 decreasedAllowance = ALLOWANCE328(_account, msg.sender).SUB617(_amount, "ERC20: burn amount exceeds allowance");
        _APPROVE846(_account, msg.sender, decreasedAllowance);
        _BURN209(_account, _amount);
        _MOVEDELEGATES44(_delegates[_account], address(0), _amount);
    }
        function SETCAP761(uint256 _cap) public {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        require(_cap >= TOTALSUPPLY666(), "_cap is below current total supply");
        cap = _cap;
    }

                                                                                                                                                                           
    function _BEFORETOKENTRANSFER691(address from, address to, uint256 amount) internal virtual override {	//inject NONSTANDARD NAMING
        super._BEFORETOKENTRANSFER691(from, to, amount);

        if (from == address(0)) {// When minting tokens
            require(TOTALSUPPLY666().ADD336(amount) <= cap, "ERC20Capped: cap exceeded");
        }

    }

    // Copied and modified from YAM code:
    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
    // Which is copied and modified from COMPOUND:
    // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol

                                               
    mapping(address => address) internal _delegates;

                                                                           
    struct Checkpoint {
        uint32 fromBlock;
        uint256 votes;
    }

                                                                        
    mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;

                                                          
    mapping(address => uint32) public numCheckpoints;

                                                              
    bytes32 public constant domain_typehash645 = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");	//inject NONSTANDARD NAMING

                                                                                   
    bytes32 public constant delegation_typehash505 = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");	//inject NONSTANDARD NAMING

                                                                   
    mapping(address => uint) public nonces;

                                                                           
    event DELEGATECHANGED27(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);	//inject NONSTANDARD NAMING

                                                                                     
    event DELEGATEVOTESCHANGED97(address indexed delegate, uint previousBalance, uint newBalance);	//inject NONSTANDARD NAMING

                                                                                                                                       
    function DELEGATES454(address delegator)	//inject NONSTANDARD NAMING
        external
        view
        returns (address)
    {
        return _delegates[delegator];
    }

                                                                                                                                       
    function DELEGATE565(address delegatee) external {	//inject NONSTANDARD NAMING
        return _DELEGATE374(msg.sender, delegatee);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DELEGATEBYSIG65(	//inject NONSTANDARD NAMING
        address delegatee,
        uint nonce,
        uint expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        external
    {
        bytes32 domainSeparator = keccak256(
            abi.encode(
                domain_typehash645,
                keccak256(bytes(NAME574())),
                GETCHAINID58(),
                address(this)
            )
        );

        bytes32 structHash = keccak256(
            abi.encode(
                delegation_typehash505,
                delegatee,
                nonce,
                expiry
            )
        );

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator,
                structHash
            )
        );
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "TIME::delegateBySig: invalid signature");
        require(nonce == nonces[signatory]++, "TIME::delegateBySig: invalid nonce");
        require(now <= expiry, "TIME::delegateBySig: signature expired");
        return _DELEGATE374(signatory, delegatee);
    }

                                                                                                                                                                                           
    function GETCURRENTVOTES501(address account)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256)
    {
        uint32 nCheckpoints = numCheckpoints[account];
        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                               
    function GETPRIORVOTES191(address account, uint blockNumber)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256)
    {
        require(blockNumber < block.number, "TIME:getPriorVotes: not yet determined");

        uint32 nCheckpoints = numCheckpoints[account];
        if (nCheckpoints == 0) {
            return 0;
        }

        // First check most recent balance
        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
            return checkpoints[account][nCheckpoints - 1].votes;
        }

        // Next check implicit zero balance
        if (checkpoints[account][0].fromBlock > blockNumber) {
            return 0;
        }

        uint32 lower = 0;
        uint32 upper = nCheckpoints - 1;
        while (upper > lower) {
            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
            Checkpoint memory cp = checkpoints[account][center];
            if (cp.fromBlock == blockNumber) {
                return cp.votes;
            } else if (cp.fromBlock < blockNumber) {
                lower = center;
            } else {
                upper = center - 1;
            }
        }
        return checkpoints[account][lower].votes;
    }

    function _DELEGATE374(address delegator, address delegatee)	//inject NONSTANDARD NAMING
        internal
    {
        address currentDelegate = _delegates[delegator];
        uint256 delegatorBalance = BALANCEOF398(delegator); // balance of underlying TIMEs (not scaled);
        _delegates[delegator] = delegatee;

        emit DELEGATECHANGED27(delegator, currentDelegate, delegatee);

        _MOVEDELEGATES44(currentDelegate, delegatee, delegatorBalance);
    }

    function _MOVEDELEGATES44(address srcRep, address dstRep, uint256 amount) internal {	//inject NONSTANDARD NAMING
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                // decrease old representative
                uint32 srcRepNum = numCheckpoints[srcRep];
                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
                uint256 srcRepNew = srcRepOld.SUB617(amount);
                _WRITECHECKPOINT599(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }

            if (dstRep != address(0)) {
                // increase new representative
                uint32 dstRepNum = numCheckpoints[dstRep];
                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
                uint256 dstRepNew = dstRepOld.ADD336(amount);
                _WRITECHECKPOINT599(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }
        }
    }

    function _WRITECHECKPOINT599(	//inject NONSTANDARD NAMING
        address delegatee,
        uint32 nCheckpoints,
        uint256 oldVotes,
        uint256 newVotes
    )
        internal
    {
        uint32 blockNumber = SAFE32535(block.number, "TIME::_writeCheckpoint: block number exceeds 32 bits");

        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
        } else {
            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
            numCheckpoints[delegatee] = nCheckpoints + 1;
        }

        emit DELEGATEVOTESCHANGED97(delegatee, oldVotes, newVotes);
    }

    function SAFE32535(uint n, string memory errorMessage) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
        require(n < 2 ** 32, errorMessage);
        return uint32(n);
    }

    function GETCHAINID58() internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint256 chainId;
        assembly {chainId := chainid()}
        return chainId;
    }
}