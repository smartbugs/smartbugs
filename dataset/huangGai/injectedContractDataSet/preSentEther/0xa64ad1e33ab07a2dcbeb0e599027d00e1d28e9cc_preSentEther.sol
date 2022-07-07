pragma solidity ^0.5.3;


/**
 * Copyright 1 2017-2019 Ramp Network sp. z o.o. All rights reserved (MIT License).
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
 * is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies
 * or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
 * BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
 * AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


/**
 * Abstract class for an asset adapter -- a class handling the binary asset description,
 * encapsulating the asset-specific transfer logic.
 * The `assetData` bytes consist of a 2-byte (uint16) asset type, followed by asset-specific data.
 * The asset type bytes must be equal to the `ASSET_TYPE` constant in each subclass.
 *
 * @dev Subclasses of this class are used as mixins to their respective main swap contract.
 *
 * @author Ramp Network sp. z o.o.
 */
contract AssetAdapter {

    uint16 public ASSET_TYPE;
    bytes32 internal EIP712_SWAP_TYPEHASH;
    bytes32 internal EIP712_ASSET_TYPEHASH;

    constructor(
        uint16 assetType,
        bytes32 swapTypehash,
        bytes32 assetTypehash
    ) internal {
        ASSET_TYPE = assetType;
        EIP712_SWAP_TYPEHASH = swapTypehash;
        EIP712_ASSET_TYPEHASH = assetTypehash;
    }

    /**
     * Ensure the described asset is sent to the given address.
     * Should revert if the transfer failed, but callers must also handle `false` being returned,
     * much like ERC20's `transfer`.
     */
    function sendAssetTo(bytes memory assetData, address payable _to) internal returns (bool success);

    /**
     * Ensure the described asset is sent to the contract (check `msg.value` for ether,
     * do a `transferFrom` for tokens, etc).
     * Should revert if the transfer failed, but callers must also handle `false` being returned,
     * much like ERC20's `transfer`.
     *
     * @dev subclasses that don't use ether should mark this with the `noEther` modifier, to make
     * sure no ether is sent -- because, to have one consistent interface, the `create` function
     * in `AbstractRampSwaps` is marked `payable`.
     */
    function lockAssetFrom(bytes memory assetData, address _from) internal returns (bool success);

    /**
     * Returns the EIP712 hash of the handled asset data struct.
     * See `getAssetTypedHash` in the subclasses for asset struct type description.
     */
    function getAssetTypedHash(bytes memory data) internal view returns (bytes32);

    /**
     * Verify that the passed asset data should be handled by this adapter.
     *
     * @dev it's sufficient to use this only when creating a new swap -- all the other swap
     * functions first check if the swap hash is valid, while a swap hash with invalid
     * asset type wouldn't be created at all.
     *
     * @dev asset type is 2 bytes long, and it's at offset 32 in `assetData`'s memory (the first 32
     * bytes are the data length). We load the word at offset 2 (it ends with the asset type bytes),
     * and retrieve its last 2 bytes into a `uint16` variable.
     */
    modifier checkAssetType(bytes memory assetData) {
        uint16 assetType;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            assetType := and(
                mload(add(assetData, 2)),
                0xffff
            )
        }
        require(assetType == ASSET_TYPE, "invalid asset type");
        _;
    }

    modifier noEther() {
        require(address(this).balance == 0, "this asset doesn't accept ether");	//inject PRESENT ETHER
        _;
    }

}


/**
 * @title partial ERC 20 Token interface according to official documentation:
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 */
interface Erc20Token {

    /**
     * Send `_value` of tokens from `msg.sender` to `_to`
     *
     * @param _to The recipient address
     * @param _value The amount of tokens to be transferred
     * @return Indication if the transfer was successful
     */
    function transfer(address _to, uint256 _value) external returns (bool success);

    /**
     * Approve `_spender` to withdraw from sender's account multiple times, up to `_value`
     * amount. If this function is called again it overwrites the current allowance with _value.
     *
     * @param _spender The address allowed to operate on sender's tokens
     * @param _value The amount of tokens allowed to be transferred
     * @return Indication if the approval was successful
     */
    function approve(address _spender, uint256 _value) external returns (bool success);

    /**
     * Transfer tokens on behalf of `_from`, provided it was previously approved.
     *
     * @param _from The transfer source address (tokens owner)
     * @param _to The transfer destination address
     * @param _value The amount of tokens to be transferred
     * @return Indication if the approval was successful
     */
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}


/**
 * An adapter for handling ERC20-based token swaps.
 *
 * @author Ramp Network sp. z o.o.
 */
contract TokenAdapter is AssetAdapter {

    uint16 internal constant TOKEN_TYPE_ID = 2;
    
    // the hashes are generated using `genTypeHashes` from `eip712.swaps`
    constructor() internal AssetAdapter(
        TOKEN_TYPE_ID,
        0xacdf4bfc42db1ef8f283505784fc4d04c30ee19cc3ff6ae81e0a8e522ddcc950,
        0x36cb415f6a5e783824a0cf6e4d040975f6b49a9b971f3362c7a48e4ebe338f28
    ) {}

    /**
    * @dev byte offsets, byte length & contents for token asset data:
    * +00  32  uint256  data length (== 0x36 == 54 bytes)
    * +32   2  uint16   asset type  (== 2)
    * +34  32  uint256  token amount in units
    * +66  20  address  token contract address
    */
    function getAmount(bytes memory assetData) internal pure returns (uint256 amount) {
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            amount := mload(add(assetData, 34))
        }
    }

    /**
     * @dev To retrieve the address at offset 66, get the word at offset 54 and return its last
     * 20 bytes. See `getAmount` for byte offsets table.
     */
    function getTokenAddress(bytes memory assetData) internal pure returns (address tokenAddress) {
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            tokenAddress := and(
                mload(add(assetData, 54)),
                0xffffffffffffffffffffffffffffffffffffffff
            )
        }
    }

    function sendAssetTo(
        bytes memory assetData, address payable _to
    ) internal returns (bool success) {
        Erc20Token token = Erc20Token(getTokenAddress(assetData));
        return token.transfer(_to, getAmount(assetData));
    }

    function lockAssetFrom(
        bytes memory assetData, address _from
    ) internal noEther returns (bool success) {
        Erc20Token token = Erc20Token(getTokenAddress(assetData));
        return token.transferFrom(_from, address(this), getAmount(assetData));
    }

    /**
     * Returns the EIP712 hash of the token asset data struct:
     * EIP712TokenAsset {
     *    amount: uint256;
     *    tokenAddress: address;
     * }
     */
    function getAssetTypedHash(bytes memory data) internal view returns (bytes32) {
        return keccak256(
            abi.encode(
                EIP712_ASSET_TYPEHASH,
                getAmount(data),
                getTokenAddress(data)
            )
        );
    }
}


contract Ownable {

    address public owner;

    constructor() internal {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only the owner can call this");
        _;
    }

}


/**
 * An extended version of the standard `Pausable` contract, with more possible statuses:
 *  * STOPPED: all swap actions cannot be executed until the status is changed,
 *  * RETURN_ONLY: the existing swaps can only be returned, no new swaps can be created;
 *  * FINALIZE_ONLY: the existing swaps can be released or returned, no new swaps can be created;
 *  * ACTIVE: all swap actions can be executed.
 *
 * @dev the status enum is strictly monotonic, and the default 0 is mapped to STOPPED for safety.
 */
contract WithStatus is Ownable {

    enum Status {
        STOPPED,
        RETURN_ONLY,
        FINALIZE_ONLY,
        ACTIVE
    }

    event StatusChanged(Status oldStatus, Status newStatus);

    Status public status = Status.ACTIVE;

    constructor() internal {}

    function setStatus(Status _status) external onlyOwner {
        emit StatusChanged(status, _status);
        status = _status;
    }

    modifier statusAtLeast(Status _status) {
        require(status >= _status, "invalid contract status");
        _;
    }

}


/**
 * An owner-managed list of oracles, that are allowed to claim, release or return swaps.
 */
contract WithOracles is Ownable {

    mapping (address => bool) oracles;

    /**
     * The deployer is the default oracle.
     */
    constructor() internal {
        oracles[msg.sender] = true;
    }

    function approveOracle(address _oracle) external onlyOwner {
        oracles[_oracle] = true;
    }

    function revokeOracle(address _oracle) external onlyOwner {
        oracles[_oracle] = false;
    }

    modifier isOracle(address _oracle) {
        require(oracles[_oracle], "invalid oracle address");
        _;
    }

    modifier onlyOracle(address _oracle) {
        require(
            msg.sender == _oracle && oracles[msg.sender],
            "only the oracle can call this"
        );
        _;
    }

    modifier onlyOracleOrSender(address _sender, address _oracle) {
        require(
            msg.sender == _sender || (msg.sender == _oracle && oracles[msg.sender]),
            "only the oracle or the sender can call this"
        );
        _;
    }

    modifier onlySender(address _sender) {
        require(msg.sender == _sender, "only the sender can call this");
        _;
    }

}


/**
 * The main contract managing Ramp Swaps escrows lifecycle: create, claim, release and return.
 * Uses an abstract AssetAdapter to carry out the transfers and handle the particular asset data.
 * With a corresponding off-chain protocol allows for atomic-swap-like transfer between
 * fiat currencies and crypto assets.
 *
 * @dev an active swap is represented by a hash of its details, mapped to its escrow expiration
 * timestamp. When the swap is created, but not yet claimed, its end time is set to SWAP_UNCLAIMED.
 * The hashed swap details are:
 *  * address sender: the swap's creator, that sells the crypto asset;
 *  * address receiver: the user that buys the crypto asset, `0x0` until the swap is claimed;
 *  * address oracle: address of the oracle that handles this particular swap;
 *  * bytes assetData: description of the crypto asset, handled by an AssetAdapter;
 *  * bytes32 paymentDetailsHash: hash of the fiat payment details: account numbers, fiat value
 *    and currency, and the transfer reference (title), that can be verified off-chain.
 *
 * @author Ramp Network sp. z o.o.
 */
contract AbstractRampSwaps is Ownable, WithStatus, WithOracles, AssetAdapter {

    /// @dev contract version, defined in semver
    string public constant VERSION = "0.3.1";

    /// @dev used as a special swap endTime value, to denote a yet unclaimed swap
    uint32 internal constant SWAP_UNCLAIMED = 1;
    uint32 internal constant MIN_ACTUAL_TIMESTAMP = 1000000000;

    /// @notice how long are sender's funds locked from a claim until he can cancel the swap
    uint32 internal constant SWAP_LOCK_TIME_S = 3600 * 24 * 7;

    event Created(bytes32 indexed swapHash);
    event BuyerSet(bytes32 indexed oldSwapHash, bytes32 indexed newSwapHash);
    event Claimed(bytes32 indexed oldSwapHash, bytes32 indexed newSwapHash);
    event Released(bytes32 indexed swapHash);
    event SenderReleased(bytes32 indexed swapHash);
    event Returned(bytes32 indexed swapHash);
    event SenderReturned(bytes32 indexed swapHash);

    /**
     * @notice Mapping from swap details hash to its end time (as a unix timestamp).
     * After the end time the swap can be cancelled, and the funds will be returned to the sender.
     * Value `(SWAP_UNCLAIMED)` is used to denote that a swap exists, but has not yet been claimed
     * by any receiver, and can also be cancelled until that.
     */
    mapping (bytes32 => uint32) internal swaps;

    /**
     * @dev EIP712 type hash for the struct:
     * EIP712Domain {
     *   name: string;
     *   version: string;
     *   chainId: uint256;
     *   verifyingContract: address;
     * }
     */
    bytes32 internal constant EIP712_DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
    bytes32 internal EIP712_DOMAIN_HASH;

    constructor(uint256 _chainId) internal {
        EIP712_DOMAIN_HASH = keccak256(
            abi.encode(
                EIP712_DOMAIN_TYPEHASH,
                keccak256(bytes("RampSwaps")),
                keccak256(bytes(VERSION)),
                _chainId,
                address(this)
            )
        );
    }

    /**
     * Swap creation, called by the crypto sender. Checks swap parameters and ensures the crypto
     * asset is locked on this contract.
     * Additionally to the swap details, this function takes params v, r, s, which is checked to be
     * an ECDSA signature of the swap hash made by the oracle -- to prevent users from creating
     * swaps outside Ramp Network.
     *
     * Emits a `Created` event with the swap hash.
     */
    function create(
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        external
        payable
        statusAtLeast(Status.ACTIVE)
        isOracle(_oracle)
        checkAssetType(_assetData)
        returns
        (bool success)
    {
        bytes32 swapHash = getSwapHash(
            msg.sender, address(0), _oracle, keccak256(_assetData), _paymentDetailsHash
        );
        requireSwapNotExists(swapHash);
        require(ecrecover(swapHash, v, r, s) == _oracle, "invalid swap oracle signature");
        // Set up swap status before transfer, to avoid reentrancy attacks.
        // Even if a malicious token is somehow passed to this function (despite the oracle
        // signature of its details), the state of this contract is already fully updated,
        // so it will behave correctly (as it would be a separate call).
        swaps[swapHash] = SWAP_UNCLAIMED;
        require(
            lockAssetFrom(_assetData, msg.sender),
            "failed to lock asset on escrow"
        );
        emit Created(swapHash);
        return true;
    }

    /**
     * Swap claim, called by the swap's oracle on behalf of the receiver, to confirm his interest
     * in buying the crypto asset.
     * Additional v, r, s parameters are checked to be the receiver's EIP712 typed data signature
     * of the swap's details and a 'claim this swap' action -- which verifies the receiver's address
     * and the authenthicity of his claim request. See `getClaimTypedHash` for description of the
     * signed swap struct.
     *
     * Emits a `Claimed` event with the current swap hash and the new swap hash, updated with
     * receiver's address. The current swap hash equal to the hash emitted in `create`, unless
     * `setBuyer` was called in the meantime -- then the current swap hash is equal to the new
     * swap hash, because the receiver's address was already set.
     */
    function claim(
        address _sender,
        address _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external statusAtLeast(Status.ACTIVE) onlyOracle(_oracle) {
        // Verify claim signature
        bytes32 claimTypedHash = getClaimTypedHash(
            _sender,
            _receiver,
            _assetData,
            _paymentDetailsHash
        );
        require(ecrecover(claimTypedHash, v, r, s) == _receiver, "invalid claim receiver signature");
        // Verify swap hashes
        bytes32 oldSwapHash = getSwapHash(
            _sender, address(0), _oracle, keccak256(_assetData), _paymentDetailsHash
        );
        bytes32 newSwapHash = getSwapHash(
            _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
        );
        bytes32 claimFromHash;
        // We want this function to be universal, regardless of whether `setBuyer` was called before.
        // If it was, the hash is already changed
        if (swaps[oldSwapHash] == 0) {
            claimFromHash = newSwapHash;
            requireSwapUnclaimed(newSwapHash);
        } else {
            claimFromHash = oldSwapHash;
            requireSwapUnclaimed(oldSwapHash);
            requireSwapNotExists(newSwapHash);
            swaps[oldSwapHash] = 0;
        }
        // any overflow security warnings can be safely ignored -- SWAP_LOCK_TIME_S is a small
        // constant, so this won't overflow an uint32 until year 2106
        // solium-disable-next-line security/no-block-members
        swaps[newSwapHash] = uint32(block.timestamp) + SWAP_LOCK_TIME_S;
        emit Claimed(claimFromHash, newSwapHash);
    }

    /**
     * Swap release, which transfers the crypto asset to the receiver and removes the swap from
     * the active swap mapping. Normally called by the swap's oracle after it confirms a matching
     * wire transfer on sender's bank account. Can be also called by the sender, for example in case
     * of a dispute, when the parties reach an agreement off-chain.
     *
     * Emits a `Released` event with the swap's hash.
     */
    function release(
        address _sender,
        address payable _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash
    ) external statusAtLeast(Status.FINALIZE_ONLY) onlyOracleOrSender(_sender, _oracle) {
        bytes32 swapHash = getSwapHash(
            _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
        );
        requireSwapClaimed(swapHash);
        // Delete the swap status before transfer, to avoid reentrancy attacks.
        swaps[swapHash] = 0;
        require(
            sendAssetTo(_assetData, _receiver),
            "failed to send asset to receiver"
        );
        if (msg.sender == _sender) {
            emit SenderReleased(swapHash);
        } else {
            emit Released(swapHash);
        }
    }

    /**
     * Swap return, which transfers the crypto asset back to the sender and removes the swap from
     * the active swap mapping. Can be called by the sender or the swap's oracle, but only if the
     * swap is not claimed, or was claimed but the escrow lock time expired.
     *
     * Emits a `Returned` event with the swap's hash.
     */
    function returnFunds(
        address payable _sender,
        address _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash
    ) external statusAtLeast(Status.RETURN_ONLY) onlyOracleOrSender(_sender, _oracle) {
        bytes32 swapHash = getSwapHash(
            _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
        );
        requireSwapUnclaimedOrExpired(swapHash);
        // Delete the swap status before transfer, to avoid reentrancy attacks.
        swaps[swapHash] = 0;
        require(
            sendAssetTo(_assetData, _sender),
            "failed to send asset to sender"
        );
        if (msg.sender == _sender) {
            emit SenderReturned(swapHash);
        } else {
            emit Returned(swapHash);
        }
    }

    /**
     * After the sender creates a swap, he can optionally call this function to restrict the swap
     * to a particular receiver address. The swap can't then be claimed by any other receiver.
     *
     * Emits a `BuyerSet` event with the created swap hash and new swap hash, updated with
     * receiver's address.
     */
    function setBuyer(
        address _sender,
        address _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash
    ) external statusAtLeast(Status.ACTIVE) onlySender(_sender) {
        bytes32 assetHash = keccak256(_assetData);
        bytes32 oldSwapHash = getSwapHash(
            _sender, address(0), _oracle, assetHash, _paymentDetailsHash
        );
        requireSwapUnclaimed(oldSwapHash);
        bytes32 newSwapHash = getSwapHash(
            _sender, _receiver, _oracle, assetHash, _paymentDetailsHash
        );
        requireSwapNotExists(newSwapHash);
        swaps[oldSwapHash] = 0;
        swaps[newSwapHash] = SWAP_UNCLAIMED;
        emit BuyerSet(oldSwapHash, newSwapHash);
    }

    /**
     * Given all valid swap details, returns its status. To check a swap with unset buyer,
     * use `0x0` as the `_receiver` address. The return can be:
     * 0: the swap details are invalid, swap doesn't exist, or was already released/returned.
     * 1: the swap was created, and is not claimed yet.
     * >1: the swap was claimed, and the value is a timestamp indicating end of its lock time.
     */
    function getSwapStatus(
        address _sender,
        address _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash
    ) external view returns (uint32 status) {
        bytes32 swapHash = getSwapHash(
            _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
        );
        return swaps[swapHash];
    }

    /**
     * Calculates the swap hash used to reference the swap in this contract's storage.
     */
    function getSwapHash(
        address _sender,
        address _receiver,
        address _oracle,
        bytes32 assetHash,
        bytes32 _paymentDetailsHash
    ) internal pure returns (bytes32 hash) {
        return keccak256(
            abi.encodePacked(
                _sender, _receiver, _oracle, assetHash, _paymentDetailsHash
            )
        );
    }

    /**
     * Returns the EIP712 typed hash for the struct:
     * EIP712<Type>Swap {
     *   action: bytes32;
     *   sender: address;
     *   receiver: address;
     *   asset: asset data struct, see `getAssetTypedHash` in specific AssetAdapter contracts
     *   paymentDetailsHash: bytes32;
     * }
     */
    function getClaimTypedHash(
        address _sender,
        address _receiver,
        bytes memory _assetData,
        bytes32 _paymentDetailsHash
    ) internal view returns(bytes32 msgHash) {
        bytes32 dataHash = keccak256(
            abi.encode(
                EIP712_SWAP_TYPEHASH,
                bytes32("claim this swap"),
                _sender,
                _receiver,
                getAssetTypedHash(_assetData),
                _paymentDetailsHash
            )
        );
        return keccak256(abi.encodePacked(bytes2(0x1901), EIP712_DOMAIN_HASH, dataHash));
    }

    function requireSwapNotExists(bytes32 swapHash) internal view {
        require(swaps[swapHash] == 0, "swap already exists");
    }

    function requireSwapUnclaimed(bytes32 swapHash) internal view {
        require(swaps[swapHash] == SWAP_UNCLAIMED, "swap already claimed or invalid");
    }

    function requireSwapClaimed(bytes32 swapHash) internal view {
        require(swaps[swapHash] > MIN_ACTUAL_TIMESTAMP, "swap unclaimed or invalid");
    }

    function requireSwapUnclaimedOrExpired(bytes32 swapHash) internal view {
        require(
            // solium-disable-next-line security/no-block-members
            (swaps[swapHash] > MIN_ACTUAL_TIMESTAMP && block.timestamp > swaps[swapHash]) ||
                swaps[swapHash] == SWAP_UNCLAIMED,
            "swap not expired or invalid"
        );
    }

}


/**
 * Ramp Swaps contract with the ERC20 token asset adapter.
 *
 * @author Ramp Network sp. z o.o.
 */
contract TokenRampSwaps is AbstractRampSwaps, TokenAdapter {
    constructor(uint256 _chainId) public AbstractRampSwaps(_chainId) {}
}