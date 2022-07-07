/**
 *Submitted for verification at Etherscan.io on 2020-04-24
*/

// File: contracts/lib/Context.sol

// From package @openzeppelin/contracts@2.4.0
pragma solidity 0.5.8;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: contracts/lib/Ownable.sol

// From package @openzeppelin/contracts@2.4.0
pragma solidity 0.5.8;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/lib/SafeMath.sol

// From package @openzeppelin/contracts@2.4.0
pragma solidity 0.5.8;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
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

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/lib/lib.sol

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/*
    Everest is using the dai contracts to mock the real dai that will be used.
    This contract lives here: https://github.com/makerdao/dss/blob/master/src/lib.sol
    Also we changed the pragma from 0.5.12 to ^0.5.8
*/

pragma solidity 0.5.8;

contract LibNote {
    event LogNote(
        bytes4   indexed  sig,
        address  indexed  usr,
        bytes32  indexed  arg1,
        bytes32  indexed  arg2,
        bytes             data
    ) anonymous;

    modifier note {
        _;
        /* solium-disable-next-line security/no-inline-assembly*/
        assembly {
            // log an 'anonymous' event with a constant 6 words of calldata
            // and four indexed topics: selector, caller, arg1 and arg2
            let mark := msize                         // end of memory ensures zero
            mstore(0x40, add(mark, 288))              // update free memory pointer
            mstore(mark, 0x20)                        // bytes type data offset
            mstore(add(mark, 0x20), 224)              // bytes size (padded)
            calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
            log4(mark, 288,                           // calldata
                 shl(224, shr(224, calldataload(0))), // msg.sig
                 caller,                              // msg.sender
                 calldataload(4),                     // arg1
                 calldataload(36)                     // arg2
                )
        }
    }
}

// File: contracts/lib/dai.sol

// Copyright (C) 2017, 2018, 2019 dbrock, rain, mrchico

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/*
    Everest is using the dai contracts to mock the real dai that will be used.
    This contract lives here: https://github.com/makerdao/dss/blob/master/src/dai.sol
    Also we changed the pragma from 0.5.12 to ^0.5.8
*/

pragma solidity 0.5.8;


contract Dai is LibNote {
    // --- Auth ---
    mapping (address => uint) public wards;
    function rely(address guy) external note auth { wards[guy] = 1; }
    function deny(address guy) external note auth { wards[guy] = 0; }
    modifier auth {
        require(wards[msg.sender] == 1, "Dai/not-authorized");
        _;
    }

    // --- ERC20 Data ---
    string  public constant name     = "Dai Stablecoin";
    string  public constant symbol   = "DAI";
    string  public constant version  = "1";
    uint8   public constant decimals = 18;
    uint256 public totalSupply;

    mapping (address => uint)                      public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;
    mapping (address => uint)                      public nonces;

    event Approval(address indexed src, address indexed guy, uint wad);
    event Transfer(address indexed src, address indexed dst, uint wad);

    // --- Math ---
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }

    // --- EIP712 niceties ---
    bytes32 public DOMAIN_SEPARATOR;
    // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
    bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;

    constructor(uint256 chainId_) public {
        wards[msg.sender] = 1;
        DOMAIN_SEPARATOR = keccak256(abi.encode(
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
            keccak256(bytes(name)),
            keccak256(bytes(version)),
            chainId_,
            address(this)
        ));
    }

    // --- Token ---
    function transfer(address dst, uint wad) external returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }
    function transferFrom(address src, address dst, uint wad)
        public returns (bool)
    {
        require(balanceOf[src] >= wad, "Dai/insufficient-balance");
        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
            require(allowance[src][msg.sender] >= wad, "Dai/insufficient-allowance");
            allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
        }
        balanceOf[src] = sub(balanceOf[src], wad);
        balanceOf[dst] = add(balanceOf[dst], wad);
        emit Transfer(src, dst, wad);
        return true;
    }
    function mint(address usr, uint wad) external auth {
        balanceOf[usr] = add(balanceOf[usr], wad);
        totalSupply    = add(totalSupply, wad);
        emit Transfer(address(0), usr, wad);
    }
    function burn(address usr, uint wad) external {
        require(balanceOf[usr] >= wad, "Dai/insufficient-balance");
        if (usr != msg.sender && allowance[usr][msg.sender] != uint(-1)) {
            require(allowance[usr][msg.sender] >= wad, "Dai/insufficient-allowance");
            allowance[usr][msg.sender] = sub(allowance[usr][msg.sender], wad);
        }
        balanceOf[usr] = sub(balanceOf[usr], wad);
        totalSupply    = sub(totalSupply, wad);
        emit Transfer(usr, address(0), wad);
    }
    function approve(address usr, uint wad) external returns (bool) {
        allowance[msg.sender][usr] = wad;	//injected TRANSACTION ORDER DEPENDENCE
        emit Approval(msg.sender, usr, wad);
        return true;
    }

    // --- Alias ---
    function push(address usr, uint wad) external {
        transferFrom(msg.sender, usr, wad);
    }
    function pull(address usr, uint wad) external {
        transferFrom(usr, msg.sender, wad);
    }
    function move(address src, address dst, uint wad) external {
        transferFrom(src, dst, wad);
    }

    // --- Approve by signature ---
    function permit(address holder, address spender, uint256 nonce, uint256 expiry,
                    bool allowed, uint8 v, bytes32 r, bytes32 s) external
    {
        bytes32 digest =
            keccak256(abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH,
                                     holder,
                                     spender,
                                     nonce,
                                     expiry,
                                     allowed))
        ));

        require(holder != address(0), "Dai/invalid-address-0");
        require(holder == ecrecover(digest, v, r, s), "Dai/invalid-permit");
        require(expiry == 0 || now <= expiry, "Dai/permit-expired");
        require(nonce == nonces[holder]++, "Dai/invalid-nonce");
        uint wad = allowed ? uint(-1) : 0;
        allowance[holder][spender] = wad;
        emit Approval(holder, spender, wad);
    }
}

// File: contracts/lib/AddressUtils.sol

// Taken from
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol

pragma solidity 0.5.8;

/**
 * @dev Collection of functions related to the address type
 */
library AddressUtils {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
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

// File: contracts/ReserveBank.sol

pragma solidity 0.5.8;





/* Note, in Everest V1, the Reserve Bank is not upgradeable.
 * What will be done is when Everest V2 is deployed, all the tokens
 * stored in the Reserve Bank will be transferred to the new Reserve Bank.
 * The new Reverse Bank is likely to be upgradeable, and have more functionality.
 * However, the ownership of ReserveBank can still be transferred by the Everest owner
 *
 * Also, when the switch over happens from V1 to V2, it is okay the empty the reserve bank right
 * away. This is because all existing challenges will fail on V1, since Everest V1 will no
 * longer be the owner of the Registry, and any challenge will not be able to withdraw
 * from the Reserve Bank.
 */

contract ReserveBank is Ownable {
    using SafeMath for uint256;
    using AddressUtils for address;

    Dai public token;

    constructor(address _daiAddress) public {
        require(_daiAddress.isContract(), "The address should be a contract");
        token = Dai(_daiAddress);
    }

    /**
    @dev                Allow the owner of the contract (Everest) to withdraw the funds.
    @param _receiver    The address receiving the tokens
    @param _amount      The amount being withdrawn
    @return             True if successful
    */
    function withdraw(address _receiver, uint256 _amount)
        external
        onlyOwner
        returns (bool)
    {
        require(_receiver != address(0), "Receiver must not be 0 address");
        return token.transfer(_receiver, _amount);
    }
}

// File: contracts/Registry.sol

pragma solidity 0.5.8;


contract Registry is Ownable {
    // ------
    // STATE
    // ------

    struct Member {
        uint256 challengeID;
        uint256 memberStartTime; // Used for voting: voteWeight = sqrt(now - memberStartTime)
    }

    // Note, this address is used to map to the owner and delegates in the ERC-1056 registry
    mapping(address => Member) public members;

    // -----------------
    // GETTER FUNCTIONS
    // -----------------

    /**
    @dev                Get the challenge ID of a Member. If no challenge exists it returns 0
    @param _member      The member being checked
    @return             The challengeID
    */
    function getChallengeID(address _member) external view returns (uint256) {
        require(_member != address(0), "Can't check 0 address");
        Member memory member = members[_member];
        return member.challengeID;
    }

    /**
    @dev                Get the start time of a Member. If no time exists it returns 0
    @param _member      The member being checked
    @return             The start time
    */
    function getMemberStartTime(address _member) external view returns (uint256) {
        require(_member != address(0), "Can't check 0 address");
        Member memory member = members[_member];
        return member.memberStartTime;
    }

    // -----------------
    // SETTER FUNCTIONS
    // -----------------

    /**
    @dev                Set a member in the Registry. Only Everest can call this function.
    @param _member      The member being added
    @return             The start time of the member
    */
    function setMember(address _member) external onlyOwner returns (uint256) {
        require(_member != address(0), "Can't check 0 address");
        Member memory member = Member({
            challengeID: 0,
            /* solium-disable-next-line security/no-block-members*/
            memberStartTime: now
        });
        members[_member] = member;

        /* solium-disable-next-line security/no-block-members*/
        return now;
    }

    /**
    @dev                        Edit the challengeID. Can be used to set a challenge or remove a
                                challenge for a member. Only Everest can call.
    @param _member              The member being checked
    @param _newChallengeID      The new challenge ID. Pass in 0 to remove a challenge.
    */
    function editChallengeID(address _member, uint256 _newChallengeID) external onlyOwner {
        require(_member != address(0), "Can't check 0 address");
        Member storage member = members[_member];
        member.challengeID = _newChallengeID;
    }

    /**
    @dev                Remove a member. Only Everest can call
    @param _member      The member being removed
    */
    function deleteMember(address _member) external onlyOwner {
        require(_member != address(0), "Can't check 0 address");
        delete members[_member];
    }
}

// File: contracts/lib/EthereumDIDRegistry.sol

/*
Original Author: https://github.com/uport-project/ethr-did-registry

Pragma has been changed for this document from what is deployed on mainnet.
This shouldn"t pose a problem, but it means a lot of syntax has been changed.

This contract is only used for testing. On mainnet, we will use the existing
DID registry: https://etherscan.io/address/0xdca7ef03e98e0dc2b855be647c39abe984fcf21b#code

This contract is also deployed on all testnets, which can be found here:
https://github.com/uport-project/ethr-did-registry

This contract is included in this repository for testing purposes on ganache. For deploying
to testnets or mainnet, it will never be included in the deploy script, since we will use the
deployed versions in the above link.
*/
pragma solidity 0.5.8;

contract EthereumDIDRegistry {
    mapping(address => address) public owners;
    mapping(address => mapping(bytes32 => mapping(address => uint256))) public delegates;
    mapping(address => uint256) public changed;
    mapping(address => uint256) public nonce;

    modifier onlyOwner(address identity, address actor) {
        require(actor == identityOwner(identity), "Caller must be the identity owner");
        _;
    }

    event DIDOwnerChanged(address indexed identity, address owner, uint256 previousChange);

    event DIDDelegateChanged(
        address indexed identity,
        bytes32 delegateType,
        address delegate,
        uint256 validTo,
        uint256 previousChange
    );

    event DIDAttributeChanged(
        address indexed identity,
        bytes32 name,
        bytes value,
        uint256 validTo,
        uint256 previousChange
    );

    function identityOwner(address identity) public view returns (address) {
        address owner = owners[identity];
        if (owner != address(0)) {
            return owner;
        }
        return identity;
    }

    function checkSignature(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 hash)
        internal
        returns (address)
    {
        address signer = ecrecover(hash, sigV, sigR, sigS);
        require(signer == identityOwner(identity), "Signer must be the identity owner");
        nonce[signer]++;
        return signer;
    }

    function validDelegate(address identity, bytes32 delegateType, address delegate)
        public
        view
        returns (bool)
    {
        uint256 validity = delegates[identity][keccak256(abi.encode(delegateType))][delegate];
        /* solium-disable-next-line security/no-block-members*/
        return (validity > now);
    }

    function changeOwner(address identity, address actor, address newOwner)
        internal
        onlyOwner(identity, actor)
    {
        owners[identity] = newOwner;
        emit DIDOwnerChanged(identity, newOwner, changed[identity]);
        changed[identity] = block.number;
    }

    function changeOwner(address identity, address newOwner) public {
        changeOwner(identity, msg.sender, newOwner);
    }

    function changeOwnerSigned(
        address identity,
        uint8 sigV,
        bytes32 sigR,
        bytes32 sigS,
        address newOwner
    ) public {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0x19),
                bytes1(0),
                this,
                nonce[identityOwner(identity)],
                identity,
                "changeOwner",
                newOwner
            )
        );
        changeOwner(identity, checkSignature(identity, sigV, sigR, sigS, hash), newOwner);
    }

    function addDelegate(
        address identity,
        address actor,
        bytes32 delegateType,
        address delegate,
        uint256 validity
    ) internal onlyOwner(identity, actor) {
        /* solium-disable-next-line security/no-block-members*/
        delegates[identity][keccak256(abi.encode(delegateType))][delegate] = now + validity;
        emit DIDDelegateChanged(
            identity,
            delegateType,
            delegate,
            /* solium-disable-next-line security/no-block-members*/
            now + validity,
            changed[identity]
        );
        changed[identity] = block.number;
    }

    function addDelegate(address identity, bytes32 delegateType, address delegate, uint256 validity)
        public
    {
        addDelegate(identity, msg.sender, delegateType, delegate, validity);
    }

    function addDelegateSigned(
        address identity,
        uint8 sigV,
        bytes32 sigR,
        bytes32 sigS,
        bytes32 delegateType,
        address delegate,
        uint256 validity
    ) public {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0x19),
                bytes1(0),
                this,
                nonce[identityOwner(identity)],
                identity,
                "addDelegate",
                delegateType,
                delegate,
                validity
            )
        );
        addDelegate(
            identity,
            checkSignature(identity, sigV, sigR, sigS, hash),
            delegateType,
            delegate,
            validity
        );
    }

    function revokeDelegate(address identity, address actor, bytes32 delegateType, address delegate)
        internal
        onlyOwner(identity, actor)
    {
        /* solium-disable-next-line security/no-block-members*/
        delegates[identity][keccak256(abi.encode(delegateType))][delegate] = now;
        /* solium-disable-next-line security/no-block-members*/
        emit DIDDelegateChanged(identity, delegateType, delegate, now, changed[identity]);
        changed[identity] = block.number;
    }

    function revokeDelegate(address identity, bytes32 delegateType, address delegate) public {
        revokeDelegate(identity, msg.sender, delegateType, delegate);
    }

    function revokeDelegateSigned(
        address identity,
        uint8 sigV,
        bytes32 sigR,
        bytes32 sigS,
        bytes32 delegateType,
        address delegate
    ) public {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0x19),
                bytes1(0),
                this,
                nonce[identityOwner(identity)],
                identity,
                "revokeDelegate",
                delegateType,
                delegate
            )
        );
        revokeDelegate(
            identity,
            checkSignature(identity, sigV, sigR, sigS, hash),
            delegateType,
            delegate
        );
    }

    function setAttribute(
        address identity,
        address actor,
        bytes32 name,
        bytes memory value,
        uint256 validity
    ) internal onlyOwner(identity, actor) {
        /* solium-disable-next-line security/no-block-members*/
        emit DIDAttributeChanged(identity, name, value, now + validity, changed[identity]);
        changed[identity] = block.number;
    }

    function setAttribute(address identity, bytes32 name, bytes memory value, uint256 validity)
        public
    {
        setAttribute(identity, msg.sender, name, value, validity);
    }

    function setAttributeSigned(
        address identity,
        uint8 sigV,
        bytes32 sigR,
        bytes32 sigS,
        bytes32 name,
        bytes memory value,
        uint256 validity
    ) public {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0x19),
                bytes1(0),
                this,
                nonce[identityOwner(identity)],
                identity,
                "setAttribute",
                name,
                value,
                validity
            )
        );
        setAttribute(
            identity,
            checkSignature(identity, sigV, sigR, sigS, hash),
            name,
            value,
            validity
        );
    }

    function revokeAttribute(address identity, address actor, bytes32 name, bytes memory value)
        internal
        onlyOwner(identity, actor)
    {
        emit DIDAttributeChanged(identity, name, value, 0, changed[identity]);
        changed[identity] = block.number;
    }

    function revokeAttribute(address identity, bytes32 name, bytes memory value) public {
        revokeAttribute(identity, msg.sender, name, value);
    }

    function revokeAttributeSigned(
        address identity,
        uint8 sigV,
        bytes32 sigR,
        bytes32 sigS,
        bytes32 name,
        bytes memory value
    ) public {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0x19),
                bytes1(0),
                this,
                nonce[identityOwner(identity)],
                identity,
                "revokeAttribute",
                name,
                value
            )
        );
        revokeAttribute(identity, checkSignature(identity, sigV, sigR, sigS, hash), name, value);
    }

}

// File: contracts/abdk-libraries-solidity/ABDKMath64x64.sol

/*
 * TheGraph is using this software as described in the README.md in this folder
 * https://github.com/abdk-consulting/abdk-libraries-solidity/tree/939f0a264f2d07a9e2c7a3a020f0db2c0885dc01
 *
 * This library has been significantly reduced to only include the functions needed for Everest
 * Please visit the library at the link above for more details
 */

/*
 * ABDK Math 64.64 Smart Contract Library.  Copyright 1 2019 by ABDK Consulting.
 * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
 */
pragma solidity 0.5.8;

/**
 * Smart contract library of mathematical functions operating with signed
 * 64.64-bit fixed point numbers.  Signed 64.64-bit fixed point number is
 * basically a simple fraction whose numerator is signed 128-bit integer and
 * denominator is 2^64.  As long as denominator is always the same, there is no
 * need to store it, thus in Solidity signed 64.64-bit fixed point numbers are
 * represented by int128 type holding only the numerator.
 */
library ABDKMath64x64 {
  /**
   * Convert unsigned 256-bit integer number into signed 64.64-bit fixed point
   * number.  Revert on overflow.
   *
   * @param x unsigned 256-bit integer number
   * @return signed 64.64-bit fixed point number
   */
  function fromUInt (uint256 x) internal pure returns (int128) {
    require (x <= 0x7FFFFFFFFFFFFFFF);
    return int128 (x << 64);
  }

  /**
   * Convert signed 64.64 fixed point number into unsigned 64-bit integer
   * number rounding down.  Revert on underflow.
   *
   * @param x signed 64.64-bit fixed point number
   * @return unsigned 64-bit integer number
   */
  function toUInt (int128 x) internal pure returns (uint64) {
    require (x >= 0);
    return uint64 (x >> 64);
  }

  /**
   * Calculate sqrt (x) rounding down.  Revert if x < 0.
   *
   * @param x signed 64.64-bit fixed point number
   * @return signed 64.64-bit fixed point number
   */
  function sqrt (int128 x) internal pure returns (int128) {
    require (x >= 0);
    return int128 (sqrtu (uint256 (x) << 64, 0x10000000000000000));
  }

  /**
   * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
   * number.
   *
   * @param x unsigned 256-bit integer number
   * @return unsigned 128-bit integer number
   */
  function sqrtu (uint256 x, uint256 r) private pure returns (uint128) {
    if (x == 0) return 0;
    else {
      require (r > 0);
      while (true) {
        uint256 rr = x / r;
        if (r == rr || r + 1 == rr) return uint128 (r);
        else if (r == rr + 1) return uint128 (rr);
        r = r + rr + 1 >> 1;
      }
    }
  }
}

// File: contracts/Everest.sol

/*
 Everest is a DAO that is designed to curate a Registry of members.

 This storage of the list is in Registry. The EthereumDIDRegistry is used to store data such
 as attributes and delegates and transfer of ownership. The only storage in the Everest contract
 is Challenges and Votes, which can be safely removed upon completion. This allows for Everest
 to be an upgradeable contract, while Registry is the persistent storage.

 The DAO is inspired by the Moloch DAO smart contracts https://github.com/MolochVentures/moloch
*/
pragma solidity 0.5.8;








contract Everest is Ownable {
    using SafeMath for uint256;
    using ABDKMath64x64 for uint256;
    using ABDKMath64x64 for int128;
    using AddressUtils for address;

    // -----------------
    // STATE
    // -----------------

    // Voting period length for a challenge (in unix seconds)
    uint256 public votingPeriodDuration;
    // Deposit that must be made in order to submit a challenge
    uint256 public challengeDeposit;
    // Application fee to become a member
    uint256 public applicationFee;
    // IPFS hash for off chain storage of the Everest Charter
    bytes32 public charter;
    // IPFS hash for off chain storage of the Everest Categories
    bytes32 public categories;
    // Challenge freeze that can prevent new challenges from being made
    bool public challengesFrozen;

    // Approved token contract reference (i.e. DAI)
    Dai public approvedToken;
    // Reserve bank contract reference
    ReserveBank public reserveBank;
    // ERC-1056 contract reference
    EthereumDIDRegistry public erc1056Registry;
    // Registry contract reference
    Registry public registry;

    // We pass in the bytes representation of the string 'everest'
    // bytes("everest") = 0x65766572657374. Then add 50 zeros to the end. The bytes32 value
    // is passed to the ERC-1056 registry, and hashed within the delegate functions
    bytes32 constant delegateType = 0x6576657265737400000000000000000000000000000000000000000000000000;

    mapping (uint256 => Challenge) public challenges;
    // Challenge counter for challenge IDs. With upgrading the contract, the latest challengeID
    // must be the last challengeID + 1 of the old version of Everest
    uint256 public challengeCounter;

    // -------
    // EVENTS
    // -------

    // Event data on delegates, owner, and offChainData are emitted from the ERC-1056 registry
    event NewMember(address indexed member, uint256 startTime, uint256 fee);
    event MemberExited(address indexed member);
    event CharterUpdated(bytes32 indexed data);
    event CategoriesUpdated(bytes32 indexed data);
    event Withdrawal(address indexed receiver, uint256 amount);
    event VotingDurationUpdated(uint256 indexed duration);
    event ChallengeDepositUpdated(uint256 indexed deposit);
    event ApplicationFeeUpdated(uint256 indexed fee);
    event ChallengesFrozen(bool isFrozen);


    event EverestDeployed(
        address owner,
        address approvedToken,
        uint256 votingPeriodDuration,
        uint256 challengeDeposit,
        uint256 applicationFee,
        bytes32 charter,
        bytes32 categories,
        address didRegistry,
        address reserveBank,
        address registry,
        uint256 startingChallengeID
    );

    event MemberChallenged(
        address indexed member,
        uint256 indexed challengeID,
        address indexed challenger,
        uint256 challengeEndTime,
        bytes32 details
    );

    event SubmitVote(
        uint256 indexed challengeID,
        address indexed submitter,      // i.e. msg.sender
        address indexed votingMember,
        VoteChoice voteChoice,
        uint256 voteWeight
    );

    event ChallengeFailed(
        address indexed member,
        uint256 indexed challengeID,
        uint256 yesVotes,
        uint256 noVotes,
        uint256 voterCount,
        uint256 resolverReward
    );

    event ChallengeSucceeded(
        address indexed member,
        uint256 indexed challengeID,
        uint256 yesVotes,
        uint256 noVotes,
        uint256 voterCount,
        uint256 challengerReward,
        uint256 resolverReward
    );

    // ------
    // STATE
    // ------

    enum VoteChoice {
        Null, // Same as not voting at all (i.e. 0 value)
        Yes,
        No
    }

    struct Challenge {
        address challenger;         // The member who submitted the challenge
        address challengee;         // The member being challenged
        uint256 yesVotes;           // The total weight of YES votes for this challenge
        uint256 noVotes;            // The total weight of NO votes for this challenge
        uint256 voterCount;         // Total count of voters participating in the challenge
        uint256 endTime;            // Ending time of the challenge
        bytes32 details;            // Challenge details - an IPFS hash, without Qm, to make bytes32
        mapping (address => VoteChoice) voteChoiceByMember;     // The choice by each member
        mapping (address => uint256) voteWeightByMember;        // The vote weight of each member
    }

    // ----------
    // MODIFIERS
    // ----------

    /**
    @dev                Modifer that allows a function to be called by the owner or delegate of a
                        member.
    @param _member      Member interacting with everest
    */
    modifier onlyMemberOwnerOrDelegate(address _member) {
        require(
            isMember(_member),
            "onlyMemberOwnerOrDelegate - Address is not a Member"
        );
        address memberOwner = erc1056Registry.identityOwner(_member);
        bool validDelegate = erc1056Registry.validDelegate(_member, delegateType, msg.sender);
        require(
            validDelegate || memberOwner == msg.sender,
            "onlyMemberOwnerOrDelegate - Caller must be delegate or owner"
        );
        _;
    }

    /**
    @dev                Modifer that allows a function to be called by owner of a member.
                        Only the member can call (no delegate permissions)
    @param _member      Member interacting with everest
    */
    modifier onlyMemberOwner(address _member) {
        require(
            isMember(_member),
            "onlyMemberOwner - Address is not a member"
        );
        address memberOwner = erc1056Registry.identityOwner(_member);
        require(
            memberOwner == msg.sender,
            "onlyMemberOwner - Caller must be the owner"
        );
        _;
    }

    // ----------
    // FUNCTIONS
    // ----------

    constructor(
        address _approvedToken,
        uint256 _votingPeriodDuration,
        uint256 _challengeDeposit,
        uint256 _applicationFee,
        bytes32 _charter,
        bytes32 _categories,
        address _DIDregistry,
        address _reserveBank,
        address _registry,
        uint256 _startingChallengeID
    ) public {
        require(_approvedToken.isContract(), "The _approvedToken address should be a contract");
        require(_DIDregistry.isContract(), "The _DIDregistry address should be a contract");
        require(_reserveBank.isContract(), "The _reserveBank address should be a contract");
        require(_registry.isContract(), "The _registry address should be a contract");
        require(_votingPeriodDuration > 0, "constructor - _votingPeriodDuration cannot be 0");
        require(_challengeDeposit > 0, "constructor - _challengeDeposit cannot be 0");
        require(_applicationFee > 0, "constructor - _applicationFee cannot be 0");
        require(_startingChallengeID != 0, "constructor - _startingChallengeID cannot be 0");

        approvedToken = Dai(_approvedToken);
        votingPeriodDuration = _votingPeriodDuration;
        challengeDeposit = _challengeDeposit;
        applicationFee = _applicationFee;
        charter = _charter;
        categories = _categories;
        erc1056Registry = EthereumDIDRegistry(_DIDregistry);
        reserveBank = ReserveBank(_reserveBank);
        registry = Registry(_registry);
        challengeCounter = _startingChallengeID;

        emit EverestDeployed(
            msg.sender,             // i.e owner
            _approvedToken,
            _votingPeriodDuration,
            _challengeDeposit,
            _applicationFee,
            _charter,
            _categories,
            _DIDregistry,
            _reserveBank,
            _registry,
            _startingChallengeID
        );
    }

    // ---------------------
    // ADD MEMBER FUNCTIONS
    // ---------------------

    /**
    @dev                            Allows a user to add a member to the Registry and
                                    add off chain data to the DID registry. The sig for
                                    changeOwner() and setAttribute() are from _newMember
                                    and for DAIS permit() it is the _owner.

                                    [0] = setAttributeSigned() signature
                                    [1] = changeOwnerSigned() signature
                                    [2] = permit() signature

    @param _newMember               The address of the new member
    @param _sigV                    V of sigs
    @param _sigR                    R of sigs
    @param _sigS                    S of sigs
    @param _memberOwner             Owner of the member (on the DID registry)
    @param _offChainDataName        Attribute name. Should be a string less than 32 bytes, converted
                                    to bytes32. example: 'ProjectData' = 0x50726f6a65637444617461,
                                    with zeros appended to make it 32 bytes
    @param _offChainDataValue       Attribute data stored offchain (IPFS)
    @param _offChainDataValidity    Length of time attribute data is valid (unix)
    */
    function applySignedWithAttributeAndPermit(
        address _newMember,
        uint8[3] calldata _sigV,
        bytes32[3] calldata _sigR,
        bytes32[3] calldata _sigS,
        address _memberOwner,
        bytes32 _offChainDataName,
        bytes calldata _offChainDataValue,
        uint256 _offChainDataValidity
    ) external {
        require(_newMember != address(0), "Member can't be 0 address");
        require(_memberOwner != address(0), "Owner can't be 0 address");
        applySignedWithAttributeAndPermitInternal(
            _newMember,
            _sigV,
            _sigR,
            _sigS,
            _memberOwner,
            _offChainDataName,
            _offChainDataValue,
            _offChainDataValidity
        );
    }

    /// @dev    Note that this internal function is created in order to avoid the
    ///         Solidity stack too deep error.
    function applySignedWithAttributeAndPermitInternal(
        address _newMember,
        uint8[3] memory _sigV,
        bytes32[3] memory _sigR,
        bytes32[3] memory _sigS,
        address _memberOwner,
        bytes32 _offChainDataName,
        bytes memory _offChainDataValue,
        uint256 _offChainDataValidity
    ) internal {
        // Approve Everest to transfer DAI on the owner's behalf
        // Expiry = 0 is infinite. true is unlimited allowance
        uint256 nonce = approvedToken.nonces(_memberOwner);
        approvedToken.permit(_memberOwner, address(this), nonce, 0, true, _sigV[2], _sigR[2], _sigS[2]);

        applySignedWithAttribute(
            _newMember,
            [_sigV[0], _sigV[1]],
            [_sigR[0], _sigR[1]],
            [_sigS[0], _sigS[1]],
            _memberOwner,
            _offChainDataName,
            _offChainDataValue,
            _offChainDataValidity
        );
    }

    /**
    @dev                            Functions the same as applySignedWithAttributeAndPermit(),
                                    except without permit(). This function should be called by
                                    any _owner that has already called permit() for Everest.

                                    [0] = setAttributeSigned() signature
                                    [1] = changeOwnerSigned() signature

    @param _newMember               The address of the new member
    @param _sigV                    V of sigs
    @param _sigR                    R of sigs
    @param _sigS                    S of sigs
    @param _memberOwner             Owner of the member application
    @param _offChainDataName        Attribute name. Should be a string less than 32 bytes, converted
                                    to bytes32. example: 'ProjectData' = 0x50726f6a65637444617461,
                                    with zeros appended to make it 32 bytes
    @param _offChainDataValue       Attribute data stored offchain (IPFS)
    @param _offChainDataValidity    Length of time attribute data is valid
    */
    function applySignedWithAttribute(
        address _newMember,
        uint8[2] memory _sigV,
        bytes32[2] memory _sigR,
        bytes32[2] memory _sigS,
        address _memberOwner,
        bytes32 _offChainDataName,
        bytes memory _offChainDataValue,
        uint256 _offChainDataValidity
    ) public {
        require(_newMember != address(0), "Member can't be 0 address");
        require(_memberOwner != address(0), "Owner can't be 0 address");
        require(
            registry.getMemberStartTime(_newMember) == 0,
            "applySignedInternal - This member already exists"
        );
        uint256 startTime = registry.setMember(_newMember);

        // This event should be emitted before changeOwnerSigned() is called. This way all events
        // in the Ethereum DID registry can start to be considered within the bounds of the event
        // event NewMember() and the end of membership with event MemberExit() or event
        // ChallengeSucceeded()
        emit NewMember(
            _newMember,
            startTime,
            applicationFee
        );

        erc1056Registry.setAttributeSigned(
            _newMember,
            _sigV[0],
            _sigR[0],
            _sigS[0],
            _offChainDataName,
            _offChainDataValue,
            _offChainDataValidity
        );

        erc1056Registry.changeOwnerSigned(_newMember, _sigV[1], _sigR[1], _sigS[1], _memberOwner);

        // Transfers tokens from owner to the reserve bank
        require(
            approvedToken.transferFrom(_memberOwner, address(reserveBank), applicationFee),
            "applySignedInternal - Token transfer failed"
        );
    }

    /**
    @dev                Allow a member to voluntarily leave. Note that this does not
                        reset ownership or delegates in the ERC-1056 registry. This must be done by
                        calling the respective functions in the registry that handle those.
    @param _member      Member exiting the list
    */
    function memberExit(
        address _member
    ) external onlyMemberOwner(_member) {
        require(_member != address(0), "Member can't be 0 address");
        require(
            !memberChallengeExists(_member),
            "memberExit - Can't exit during ongoing challenge"
        );
        registry.deleteMember(_member);
        emit MemberExited(_member);
    }

    // --------------------
    // CHALLENGE FUNCTIONS
    // --------------------

    /**
    @dev                        Starts a challenge on a member. Challenger deposits a fee.
    @param _challenger          The address of the member who is challenging another member
    @param _challengee          The address of the member being challenged
    @param _details             Extra details relevant to the challenge. (IPFS hash without Qm)
    @return                     Challenge ID for the created challenge
    */
    function challenge(
        address _challenger,
        address _challengee,
        bytes32 _details
    ) external onlyMemberOwner(_challenger) returns (uint256 challengeID) {
        require(_challenger != address(0), "Challenger can't be 0 address");
        require(isMember(_challengee), "challenge - Challengee must exist");
        require(
            _challenger != _challengee,
            "challenge - Can't challenge self"
        );
        require(challengesFrozen != true, "challenge - Cannot create challenge, frozen");
        uint256 currentChallengeID = registry.getChallengeID(_challengee);
        require(currentChallengeID == 0, "challenge - Existing challenge must be resolved first");

        uint256 newChallengeID = challengeCounter;
        Challenge memory newChallenge = Challenge({
            challenger: _challenger,
            challengee: _challengee,
            // It is okay to start counts at 0 here. submitVote() is called at the end of the func
            yesVotes: 0,
            noVotes: 0,
            voterCount: 0,
            /* solium-disable-next-line security/no-block-members*/
            endTime: now.add(votingPeriodDuration),
            details: _details
        });
        challengeCounter = challengeCounter.add(1);

        challenges[newChallengeID] = newChallenge;

        // Updates member to store most recent challenge
        registry.editChallengeID(_challengee, newChallengeID);

        // Transfer tokens from challenger to reserve bank
        require(
            approvedToken.transferFrom(msg.sender, address(reserveBank), challengeDeposit),
            "challenge - Token transfer failed"
        );

        emit MemberChallenged(
            _challengee,
            newChallengeID,
            _challenger,
            /* solium-disable-next-line security/no-block-members*/
            now.add(votingPeriodDuration),
            newChallenge.details
        );

        // Add challengers' vote into the challenge
        submitVote(newChallengeID, VoteChoice.Yes, _challenger);
        return newChallengeID;
    }

    /**
    @dev                    Submit a vote. Owner or delegate can submit
    @param _challengeID     The challenge ID
    @param _voteChoice      The vote choice (yes or no)
    @param _votingMember    The member who is voting
    */
    function submitVote(
        uint256 _challengeID,
        VoteChoice _voteChoice,
        address _votingMember
    ) public onlyMemberOwnerOrDelegate(_votingMember) {
        require(_votingMember != address(0), "Member can't be 0 address");
        require(
            _voteChoice == VoteChoice.Yes || _voteChoice == VoteChoice.No,
            "submitVote - Vote must be either Yes or No"
        );

        Challenge storage storedChallenge = challenges[_challengeID];
        require(
            storedChallenge.endTime > 0,
            "submitVote - Challenge does not exist"
        );
        require(
            !hasVotingPeriodExpired(storedChallenge.endTime),
            "submitVote - Challenge voting period has expired"
        );
        require(
            storedChallenge.voteChoiceByMember[_votingMember] == VoteChoice.Null,
            "submitVote - Member has already voted on this challenge"
        );

        require(
            storedChallenge.challengee != _votingMember,
            "submitVote - Member can't vote on their own challenge"
        );

        uint256 startTime = registry.getMemberStartTime(_votingMember);
        // The lower the member start time (i.e. the older the member) the more vote weight
        uint256 voteWeightSquared = storedChallenge.endTime.sub(startTime);

        // Here we use ABDKMath64x64 to do the square root of the vote weight
        // We have to covert it to a 64.64 fixed point number, do sqrt(), then convert it
        // back to uint256. uint256 wraps the result of toUInt(), since it returns uint64
        int128 sixtyFourBitFPInt = voteWeightSquared.fromUInt();
        int128 voteWeightInt128 = sixtyFourBitFPInt.sqrt();
        uint256 voteWeight = uint256(voteWeightInt128.toUInt());

        // Store vote with _votingMember, not msg.sender, since a delegate can vote
        storedChallenge.voteChoiceByMember[_votingMember] = _voteChoice;
        storedChallenge.voteWeightByMember[_votingMember] = voteWeight;
        storedChallenge.voterCount = storedChallenge.voterCount.add(1);

        // Count vote
        if (_voteChoice == VoteChoice.Yes) {
            storedChallenge.yesVotes = storedChallenge.yesVotes.add(voteWeight);
        } else if (_voteChoice == VoteChoice.No) {
            storedChallenge.noVotes = storedChallenge.noVotes.add(voteWeight);
        }

        emit SubmitVote(_challengeID, msg.sender, _votingMember, _voteChoice, voteWeight);
    }

    /**
    @dev                    Submit many votes from owner or delegate with multiple members they own
                            or are delegates of
    @param _challengeID     The challenge ID
    @param _voteChoices     The vote choices (yes or no)
    @param _voters          The members who are voting
    */
    function submitVotes(
        uint256 _challengeID,
        VoteChoice[] calldata _voteChoices,
        address[] calldata _voters
    ) external {
        require(
            _voteChoices.length == _voters.length,
            "submitVotes - Arrays must be equal"
        );
        require(_voteChoices.length < 90, "submitVotes - Array should be < 90 to avoid going over the block gas limit");
        for (uint256 i; i < _voteChoices.length; i++){
            submitVote(_challengeID, _voteChoices[i], _voters[i]);
        }
    }

    /**
    @dev                    Resolve a challenge A successful challenge means the member is removed.
                            Anyone can call this function. They will be rewarded with 1/10 of the
                            challenge deposit.
    @param _challengeID     The challenge ID
    */
    function resolveChallenge(uint256 _challengeID) external {
        challengeCanBeResolved(_challengeID);
        Challenge storage storedChallenge = challenges[_challengeID];

        bool didPass = storedChallenge.yesVotes > storedChallenge.noVotes;
        bool moreThanOneVote = storedChallenge.voterCount > 1;
        // Challenge reward is 1/10th the challenge deposit. This allows incentivization to
        // always resolve the challenge for the user that calls this function
        uint256 challengeRewardDivisor = 10;
        uint256 resolverReward = challengeDeposit.div(challengeRewardDivisor);

        if (didPass && moreThanOneVote) {
            address challengerOwner = erc1056Registry.identityOwner(storedChallenge.challenger);

            // The amount includes the applicationFee, which is the reward for challenging a project
            // and getting it successfully removed. Minus the resolver reward
            uint256 challengerReward = challengeDeposit.add(applicationFee).sub(resolverReward);
            require(
                reserveBank.withdraw(challengerOwner, challengerReward),
                "resolveChallenge - Rewarding challenger failed"
            );
            // Transfer resolver reward
            require(
                reserveBank.withdraw(msg.sender, resolverReward),
                "resolveChallenge - Rewarding resolver failed"
            );

            registry.deleteMember(storedChallenge.challengee);
            emit ChallengeSucceeded(
                storedChallenge.challengee,
                _challengeID,
                storedChallenge.yesVotes,
                storedChallenge.noVotes,
                storedChallenge.voterCount,
                challengerReward,
                resolverReward
            );

        } else {
            // Transfer resolver reward
            require(
                reserveBank.withdraw(msg.sender, resolverReward),
                "resolveChallenge - Rewarding resolver failed"
            );

            // Remove challenge ID from the Member in the registry
            registry.editChallengeID(storedChallenge.challengee, 0);
            emit ChallengeFailed(
                storedChallenge.challengee,
                _challengeID,
                storedChallenge.yesVotes,
                storedChallenge.noVotes,
                storedChallenge.voterCount,
                resolverReward
            );
        }

        // Delete challenge from Everest in either case
        delete challenges[_challengeID];
    }

    // ------------------------
    // EVEREST OWNER FUNCTIONS
    // ------------------------

    /**
    @dev                Allows the owner of everest to withdraw funds from the reserve bank.
    @param _receiver    The address receiving funds
    @param _amount      The amount of funds being withdrawn
    @return             True if withdrawal is successful
    */
    function withdraw(address _receiver, uint256 _amount) external onlyOwner returns (bool) {
        require(_receiver != address(0), "Receiver must not be 0 address");
        require(_amount > 0, "Amount must be greater than 0");
        emit Withdrawal(_receiver, _amount);
        return reserveBank.withdraw(_receiver, _amount);
    }

    /**
    @dev                Allows the owner of Everest to transfer the ownership of ReserveBank
    @param _newOwner    The new owner
    */
    function transferOwnershipReserveBank(address _newOwner) external onlyOwner {
        reserveBank.transferOwnership(_newOwner);
    }

    /**
    @dev                Allows the owner of Everest to transfer the ownership of Registry
    @param _newOwner    The new owner
    */
    function transferOwnershipRegistry(address _newOwner) external onlyOwner {
        registry.transferOwnership(_newOwner);
    }

    /**
    @dev                Updates the charter for Everest
    @param _newCharter  The data that point to the new charter
    */
    function updateCharter(bytes32 _newCharter) external onlyOwner {
        charter = _newCharter;
        emit CharterUpdated(charter);
    }

    /**
    @dev                Updates the categories for Everest
    @param _newCategories  The data that point to the new categories
    */
    function updateCategories(bytes32 _newCategories) external onlyOwner {
        categories = _newCategories;
        emit CategoriesUpdated(categories);
    }

    /**
    @dev                        Updates the voting duration for Everest
    @param _newVotingDuration   New voting duration in unix seconds
    */
    function updateVotingPeriodDuration(uint256 _newVotingDuration) external onlyOwner {
        votingPeriodDuration = _newVotingDuration;
        emit VotingDurationUpdated(votingPeriodDuration);
    }

    /**
    @dev                Updates the challenge deposit required
    @param _newDeposit  The new value for the challenge deposit, with decimals (10^18)
    */
    function updateChallengeDeposit(uint256 _newDeposit) external onlyOwner {
        challengeDeposit = _newDeposit;
        emit ChallengeDepositUpdated(challengeDeposit);
    }

    /**
    @dev            Updates the application fee for Everest
    @param _newFee  The new application fee, with decimals (10^18)
    */
    function updateApplicationFee(uint256 _newFee) external onlyOwner {
        applicationFee = _newFee;
        emit ApplicationFeeUpdated(applicationFee);
    }

    /**
    @dev                Freezes the ability to create challenges
    @param _isFrozen    Pass in true if challenges are to be frozen
    */
    function updateChallengeFreeze(bool _isFrozen) external onlyOwner {
        challengesFrozen = _isFrozen;
        emit ChallengesFrozen(challengesFrozen);
    }

    // -----------------
    // GETTER FUNCTIONS
    // -----------------


    /**
    @dev                Returns true if a challenge vote period has finished
    @param _endTime     The starting period of the challenge
    @return             True if voting period has expired
    */
    function hasVotingPeriodExpired(uint256 _endTime) private view returns (bool) {
        /* solium-disable-next-line security/no-block-members*/
        return now >= _endTime;
    }

    /**
    @dev            Returns true if the address is a member
    @param _member  The member name of the member whose status is to be examined
    @return         True is address is a member
    */
    function isMember(address _member) public view returns (bool){
        require(_member != address(0), "Member can't be 0 address");
        uint256 startTime = registry.getMemberStartTime(_member);
        if (startTime > 0){
            return true;
        }
        return false;
    }

    /**
    @dev            Returns true if the member has an unresolved challenge. False if the challenge
                    does not exist.
    @param _member  The member that is being checked for a challenge.
    @return         True if a challenge exists on the member
    */
    function memberChallengeExists(address _member) public view returns (bool) {
        require(_member != address(0), "Member can't be 0 address");
        uint256 challengeID = registry.getChallengeID(_member);
        return (challengeID > 0);
    }

    /**
    @dev                Determines whether voting has concluded in a challenge for a given
                        member. Throws if challenge can't be resolved
    @param _challengeID The challenge ID
    */
    function challengeCanBeResolved(uint256 _challengeID) private view {
        Challenge storage storedChallenge = challenges[_challengeID];
        require(
            challenges[_challengeID].endTime > 0,
            "challengeCanBeResolved - Challenge does not exist or was completed"
        );
        require(
            hasVotingPeriodExpired(storedChallenge.endTime),
            "challengeCanBeResolved - Current challenge is not ready to be resolved"
        );
    }
}