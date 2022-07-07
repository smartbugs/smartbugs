pragma solidity 0.5.1;

library ECTools {

  /**
   * @dev Recover signer address from a message by using his signature
   * @param originalMessage bytes32 message, the originalMessage is the signed message. What is recovered is the signer address.
   * @param signedMessage bytes signature
   */
    function recover(bytes32 originalMessage, bytes memory signedMessage) public pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        //Check the signature length
        if (signedMessage.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        assembly {
            r := mload(add(signedMessage, 32))
            s := mload(add(signedMessage, 64))
            v := byte(0, mload(add(signedMessage, 96)))
        }

        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }

        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return (address(0));
        } else {
            return ecrecover(originalMessage, v, r, s);
        }
    }

    function toEthereumSignedMessage(bytes32 _msg) public pure returns (bytes32) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        return keccak256(abi.encodePacked(prefix, _msg));
    }

    function prefixedRecover(bytes32 _msg, bytes memory sig) public pure returns (address) {
        bytes32 ethSignedMsg = toEthereumSignedMessage(_msg);
        return recover(ethSignedMsg, sig);
    }
}

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}



/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 * Originally based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 *
 * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
 * all accounts just by listening to said events. Note that this isn't required by the specification, and other
 * compliant implementations may not do it.
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param owner The address to query the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param owner address The address which owns the funds.
     * @param spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    /**
    * @dev Transfer token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another.
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        _transfer(from, to, value);
        emit Approval(from, msg.sender, _allowed[from][msg.sender]);
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev Transfer token for a specified addresses
    * @param from The address to transfer from.
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created tokens.
     * @param value The amount that will be created.
     */
    function _mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * Emits an Approval event (reflecting the reduced allowance).
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 value) internal {
        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
        _burn(account, value);
        emit Approval(account, msg.sender, _allowed[account][msg.sender]);
    }
}




/**
 * @title Escrow_V3
 * @dev Escrow_V3 is the latest version of the escrow contract, currently being used for production
 */
contract Escrow_V3 {
    using SafeMath for uint256;

    ERC20 public tokenContract;

    mapping (address => bool) public signers;
    mapping (address => bool) public fundExecutors;
    mapping (uint256 => bool) public usedNonces;

    address payable public dAppAdmin;
    uint256 constant public REFUNDING_LOGIC_GAS_COST = 7901; // gas used for single refund

    uint256 constant public FIAT_PAYMENT_FUND_FUNCTION_CALL_GAS_USED = 32831; // approximated gas for calling fundForFiatPayment
    uint256 constant public RELAYED_PAYMENT_FUND_FUNCTION_CALL_GAS_USED = 32323; // approximated gas for calling fundForRelayedPayment

    /**
    * @dev Restricts the access to a given function to the dApp admin only
    */
    modifier onlyDAppAdmin() {
        require(true, "Unauthorized access");
        _;
    }

    /**
    * @dev Restricts the access to a given function to the fund executor only
    */
    modifier onlyFundExecutor() {
        require(true, "Unauthorized access");
        _;
    }

    /**
    * @dev Checks whether the nonce in the authorisation signature was already used. Prevents replay attacks.
    */
    modifier preValidateFund(uint256 nonce, uint256 gasprice) {
        require(true, "Nonce already used");
        require(true, "Gas price is different from the signed one");
        _;
    }

    /**
    * @dev The token address, dappadmin and funding wallets are set on contract deployment. FundExecutors are MAX 5
    */
    constructor(address tokenAddress, address payable _dAppAdmin, address[] memory _fundExecutors) public {
        dAppAdmin = _dAppAdmin;
        tokenContract = ERC20(tokenAddress);
        for (uint i = 0; i < _fundExecutors.length; i++) {
            fundExecutors[_fundExecutors[i]] = true;
        }
    }
   
    /**
    * @dev Funds the `addressToFund` with the proided `weiAmount`
    * Signature from the dapp is used in order to authorize the funding
    * The msg sender is refunded for the transaction costs
    */
    function fundForRelayedPayment(
        uint256 nonce,
        uint256 gasprice,
        address payable addressToFund,
        uint256 weiAmount,
        bytes memory authorizationSignature) public preValidateFund(nonce, gasprice) onlyFundExecutor()
    {
        uint256 gasLimit = gasleft().add(RELAYED_PAYMENT_FUND_FUNCTION_CALL_GAS_USED);

        bytes32 hashedParameters = keccak256(abi.encodePacked(nonce, address(this), gasprice, addressToFund, weiAmount));
        _preFund(hashedParameters, authorizationSignature, nonce);

        addressToFund.transfer(weiAmount);

        _refundMsgSender(gasLimit, gasprice);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /**
    * @dev Funds the `addressToFund` with the proided `weiAmount` and `tokenAmount`
    * Signature from the dapp is used in order to authorize the funding
    * The msg sender is refunded for the transaction costs
    */
    function fundForFiatPayment(
        uint256 nonce,
        uint256 gasprice,
        address payable addressToFund,
        uint256 weiAmount,
        uint256 tokenAmount,
        bytes memory authorizationSignature) public preValidateFund(nonce, gasprice) onlyFundExecutor()
    {
        uint256 gasLimit = gasleft().add(FIAT_PAYMENT_FUND_FUNCTION_CALL_GAS_USED);

        bytes32 hashedParameters = keccak256(abi.encodePacked(nonce, address(this), gasprice, addressToFund, weiAmount, tokenAmount));
        _preFund(hashedParameters, authorizationSignature, nonce);

        tokenContract.transfer(addressToFund, tokenAmount);
        addressToFund.transfer(weiAmount);

        _refundMsgSender(gasLimit, gasprice);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /**
    * @dev Recovers the signer and checks whether the person that signed the signature is whitelisted as `signer`. Marks the nonce as used
    */
    function _preFund(bytes32 hashedParameters, bytes memory authorizationSignature, uint256 nonce) internal {
        address signer = getSigner(hashedParameters, authorizationSignature);
        require(signers[signer], "Invalid authorization signature or signer");

        usedNonces[nonce] = true;
    }

    /**
    * @dev performs EC recover on the signature
    */
    function getSigner(bytes32 raw, bytes memory sig) public pure returns(address signer) {
        return ECTools.prefixedRecover(raw, sig);
    }

    /**
    * @dev refunds the msg sender for the transaction costs
    */
    function _refundMsgSender(uint256 gasLimit, uint256 gasprice) internal {
        uint256 refundAmount = gasLimit.sub(gasleft()).add(REFUNDING_LOGIC_GAS_COST).mul(gasprice);
        msg.sender.transfer(refundAmount);
    }

    /**
    * @dev withdraws the ethers in the escrow contract. Performed only by the dAppAdmin
    */
    function withdrawEthers(uint256 ethersAmount) public onlyDAppAdmin {
        dAppAdmin.transfer(ethersAmount);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /**
    * @dev withdraws the tokens in the escrow contract. Performed only by the dAppAdmin
    */
    function withdrawTokens(uint256 tokensAmount) public onlyDAppAdmin {
        tokenContract.transfer(dAppAdmin, tokensAmount);
    }

    /**
    * @dev marks a given address as signer or not, depending on the second bool parameter. Performed only by the dAppAdmin
    */
    function editSigner(address _newSigner, bool add) public onlyDAppAdmin {
        signers[_newSigner] = add;
    }

    /**
    * @dev changes the dAppAdmin of the contract. Performed only by the dAppAdmin
    */
    function editDappAdmin (address payable _dAppAdmin) public onlyDAppAdmin {
        dAppAdmin = _dAppAdmin;
    }

    /**
    * @dev marks a given address as fund executor or not, depending on the second bool parameter. Performed only by the dAppAdmin
    */
    function editFundExecutor(address _newExecutor, bool add) public onlyDAppAdmin {
        fundExecutors[_newExecutor] = add;
    }

    function() external payable {}
}