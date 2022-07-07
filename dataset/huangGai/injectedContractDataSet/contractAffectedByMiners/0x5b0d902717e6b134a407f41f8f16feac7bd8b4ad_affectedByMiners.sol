/**
 *Submitted for verification at Etherscan.io on 2020-07-17
*/

/*
111     11111111111  111                         
111     1111111111111111                         
111     111111   111111                          
111     111111   111111                          
11111111111111111111 111                         
1111111111111111111  111                         
 1111111 111   111111111     1111111             
11111111 111   111111111     11111111            
111  1111111   111111111     111  111            
111   111111   111111111     111  111            
1111111111111111111111111111111111111            
 1111111  1111111 111111111111111111             
111      1111111  1111111111  111111111111111111 
111     11111111111111111111 11111111111111111111
111     111   111111     1111111 111111  11111111
111     111   111111     1111111 111111  11111111
1111111111111111111111111111  11111111111111  111
11111111 1111111  1111111111  11111111111111  111
DEAR MSG.SENDER(S):

/ LXGL is a project in beta.
// Please audit and use at your own risk.
/// Entry into LXGL shall not create an attorney/client relationship.
//// Likewise, LXGL should not be construed as legal advice or replacement for professional counsel.
///// STEAL THIS C0D3SL4W 

~presented by Open, ESQ || LexDAO LLC
*/

pragma solidity 0.5.17;

contract Context { // describes current contract execution context / openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library SafeMath { // wrappers over solidity arithmetic operations with added overflow checks
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;

        return c;
    }
}

library Address { // helper function for address type / openzeppelin-contracts/blob/master/contracts/utils/Address.sol
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }
}

interface IERC20 { // brief interface for erc20 token txs
    function balanceOf(address who) external view returns (uint256);
    
    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

library SafeERC20 { // wrappers around erc20 token txs that throw on failure (when the token contract returns false) / openzeppelin-contracts/blob/master/contracts/token/ERC20/SafeERC20.sol
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

   function _callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (block.timestamp > 0) { // return data is optional	//injected CONTRACT AFFECTED BY MINERS
            require(abi.decode(returndata, (bool)), "SafeERC20: erc20 operation did not succeed");
        }
    }
}

interface IWETH { // brief interface for ether wrapping contract 
    function deposit() payable external;
    function transfer(address dst, uint wad) external returns (bool);
}

contract LexGuildLocker is Context { // digital deal deposits w/ embedded arbitration tailored for guild raids
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    /** <$> LXGL <$> **/
    address private locker = address(this);
    address public wETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // wrapping contract for raw payable ether
    uint256 public lockerIndex;
    mapping(uint256 => Deposit) public deposits; 

    struct Deposit {  
        address client; 
        address provider;
        address resolver;
        address token;
        uint8 locked;
        uint256 amount;
        uint256 cap;
        uint256 released;
        uint256 termination;
        bytes32 details; 
    }
    	
    event DepositToken(address indexed client, address indexed provider, address indexed resolver, uint256 index);  
    event Release(uint256 indexed index, uint256 indexed milestone); 
    event Withdraw(uint256 indexed index, uint256 indexed remainder);
    event Lock(address indexed sender, uint256 indexed index, bytes32 indexed details);
    event Resolve(address indexed resolver, uint256 indexed clientAward, uint256 indexed providerAward, uint256 index, bytes32 details); 

    /***************
    LOCKER FUNCTIONS
    ***************/
    function depositToken( // register lexlocker and deposit token 
        address provider,
        address resolver,
        address token,
        uint256 amount, 
        uint256 cap,
        uint256 milestones,
        uint256 termination,
        bytes32 details) payable external {
        require(amount.mul(milestones) == cap, "deposit milestones mismatch");
        
        if (token == wETH && msg.value > 0) {
            require(msg.value == cap, "insufficient ETH");
            IWETH(wETH).deposit();
            (bool success, ) = wETH.call.value(msg.value)("");
            require(success, "transfer failed");
            IWETH(wETH).transfer(locker, msg.value);
        } else {
            IERC20(token).safeTransferFrom(msg.sender, locker, cap);
        }

        uint256 index = lockerIndex+1;
        lockerIndex = lockerIndex+1;
        
        deposits[index] = Deposit( 
            _msgSender(), 
            provider,
            resolver,
            token,
            0,
            amount,
            cap,
            0,
            termination,
            details);
        
        emit DepositToken(_msgSender(), provider, resolver, lockerIndex); 
    }

    function release(uint256 index) external { // client transfers deposit amount (milestone) to provider 
    	Deposit storage deposit = deposits[index];
	    
	    require(deposit.locked == 0, "deposit locked");
	    require(deposit.cap > deposit.released, "deposit released");
    	require(_msgSender() == deposit.client, "not deposit client"); 
        
        uint256 milestone = deposit.amount;  
        
        IERC20(deposit.token).safeTransfer(deposit.provider, milestone);
        
        deposit.released = deposit.released.add(milestone);
        
	    emit Release(index, milestone); 
    }
    
    function withdraw(uint256 index) external { // withdraw deposit remainder to client if termination time passes and no lock
    	Deposit storage deposit = deposits[index];
        
        require(deposit.locked == 0, "deposit locked");
        require(deposit.cap > deposit.released, "deposit released");
        require(now > deposit.termination, "termination time pending");
        
        uint256 remainder = deposit.cap.sub(deposit.released); 
        
        IERC20(deposit.token).safeTransfer(deposit.client, remainder);
        
        deposit.released = deposit.released.add(remainder); 
        
	    emit Withdraw(index, remainder); 
    }
    
    /************
    ADR FUNCTIONS
    ************/
    function lock(uint256 index, bytes32 details) external { // client or provider can lock deposit for resolution during locker period / update details
        Deposit storage deposit = deposits[index]; 
        
        require(deposit.cap > deposit.released, "deposit released");
        require(now < deposit.termination, "termination time passed"); 
        require(_msgSender() == deposit.client || _msgSender() == deposit.provider, "not deposit party"); 
        
	    deposit.locked = 1; 
	    
	    emit Lock(_msgSender(), index, details);
    }
    
    function resolve(uint256 index, uint256 clientAward, uint256 providerAward, bytes32 details) external { // selected resolver splits locked deposit remainder 
        Deposit storage deposit = deposits[index];
        
        uint256 remainder = deposit.cap.sub(deposit.released); 
	    uint256 resolutionFee = remainder.div(20); // calculates dispute resolution fee (5% of remainder)
	    
	    require(deposit.locked == 1, "deposit not locked"); 
	    require(deposit.cap > deposit.released, "cap released");
	    require(_msgSender() == deposit.resolver, "not deposit resolver");
	    require(_msgSender() != deposit.client, "cannot be deposit party");
	    require(_msgSender() != deposit.provider, "cannot be deposit party");
	    require(clientAward.add(providerAward) == remainder.sub(resolutionFee), "resolution must match deposit"); 
        
        IERC20(deposit.token).safeTransfer(deposit.client, clientAward);
        IERC20(deposit.token).safeTransfer(deposit.provider, providerAward);
        IERC20(deposit.token).safeTransfer(deposit.resolver, resolutionFee);
	    
	    deposit.released = deposit.released.add(remainder); 
	    
	    emit Resolve(_msgSender(), clientAward, providerAward, index, details);
    }
}