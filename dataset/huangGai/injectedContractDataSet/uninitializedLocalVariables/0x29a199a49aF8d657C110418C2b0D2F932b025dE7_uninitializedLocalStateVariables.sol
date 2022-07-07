/**
 *Submitted for verification at Etherscan.io on 2020-08-07
*/

/*

    Copyright 2020 dYdX Trading Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

*/

pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

// File: @openzeppelin/contracts/GSN/Context.sol

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

// File: @openzeppelin/contracts/ownership/Ownable.sol

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
        address msgSender ;	//inject UNINIT LOCAL/STATE VAR

        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
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

// File: contracts/external/maker/I_MakerOracle.sol

/**
 * @title I_MakerOracle
 * @author dYdX
 *
 * Interface for the MakerDAO Oracles V2 smart contrats.
 */
interface I_MakerOracle {

    // ============ Getter Functions ============

    /**
     * @notice Returns the current value as a bytes32.
     */
    function peek()
        external
        view
        returns (bytes32, bool);

    /**
     * @notice Requires a fresh price and then returns the current value.
     */
    function read()
        external
        view
        returns (bytes32);

    /**
     * @notice Returns the number of signers per poke.
     */
    function bar()
        external
        view
        returns (uint256);

    /**
     * @notice Returns the timetamp of the last update.
     */
    function age()
        external
        view
        returns (uint32);

    /**
     * @notice Returns 1 if the signer is authorized, and 0 otherwise.
     */
    function orcl(
        address signer
    )
        external
        view
        returns (uint256);

    /**
     * @notice Returns 1 if the address is authorized to read the oracle price, and 0 otherwise.
     */
    function bud(
        address reader
    )
        external
        view
        returns (uint256);

    /**
     * @notice A mapping from the first byte of an authorized signer's address to the signer.
     */
    function slot(
        uint8 signerId
    )
        external
        view
        returns (address);

    // ============ State-Changing Functions ============

    /**
     * @notice Updates the value of the oracle
     */
    function poke(
        uint256[] calldata val_,
        uint256[] calldata age_,
        uint8[] calldata v,
        bytes32[] calldata r,
        bytes32[] calldata s
    )
        external;

    /**
     * @notice Authorize an address to read the oracle price.
     */
    function kiss(
        address reader
    )
        external;

    /**
     * @notice Unauthorize an address so it can no longer read the oracle price.
     */
    function diss(
        address reader
    )
        external;

    /**
     * @notice Authorize addresses to read the oracle price.
     */
    function kiss(
        address[] calldata readers
    )
        external;

    /**
     * @notice Unauthorize addresses so they can no longer read the oracle price.
     */
    function diss(
        address[] calldata readers
    )
        external;
}

// File: contracts/protocol/v1/oracles/P1MirrorOracle.sol

/**
 * @title P1MirrorOracle
 * @author dYdX
 *
 * Oracle which mirrors an underlying oracle.
 */
contract P1MirrorOracle is
    Ownable,
    I_MakerOracle
{
    // ============ Events ============

    event LogMedianPrice(
        uint256 val,
        uint256 age
    );

    event LogSetSigner(
        address signer,
        bool authorized
    );

    event LogSetBar(
        uint256 bar
    );

    event LogSetReader(
        address reader,
        bool authorized
    );

    // ============ Mutable Storage ============

    // The oracle price.
    uint128 internal _VAL_;

    // The timestamp of the last oracle update.
    uint32 public _AGE_;

    // The number of signers required to update the oracle price.
    uint256 public _BAR_;

    // Authorized signers. Value is equal to 0 or 1.
    mapping (address => uint256) public _ORCL_;

    // Addresses with permission to get the oracle price. Value is equal to 0 or 1.
    mapping (address => uint256) _READERS_;

    // Mapping for at most 256 signers.
    // Each signer is identified by the first byte of their address.
    mapping (uint8 => address) public _SLOT_;

    // ============ Immutable Storage ============

    // The underlying oracle.
    address public _ORACLE_;

    // ============ Constructor ============

    constructor(
        address oracle
    )
        public
    {
        _ORACLE_ = oracle;
    }

    // ============ Getter Functions ============

    /**
     * @notice Returns the current price, and a boolean indicating whether the price is nonzero.
     */
    function peek()
        external
        view
        returns (bytes32, bool)
    {
        require(
            _READERS_[msg.sender] == 1,
            "P1MirrorOracle#peek: Sender not authorized to get price"
        );
        uint256 val ;	//inject UNINIT LOCAL/STATE VAR

        return (bytes32(val), val > 0);
    }

    /**
     * @notice Requires the price to be nonzero, and returns the current price.
     */
    function read()
        external
        view
        returns (bytes32)
    {
        require(
            _READERS_[msg.sender] == 1,
            "P1MirrorOracle#read: Sender not authorized to get price"
        );
        uint256 val ;	//inject UNINIT LOCAL/STATE VAR

        require(
            val > 0,
            "P1MirrorOracle#read: Price is zero"
        );
        return bytes32(val);
    }

    /**
     * @notice Returns the number of signers per poke.
     */
    function bar()
        external
        view
        returns (uint256)
    {
        return _BAR_;
    }

    /**
     * @notice Returns the timetamp of the last update.
     */
    function age()
        external
        view
        returns (uint32)
    {
        return _AGE_;
    }

    /**
     * @notice Returns 1 if the signer is authorized, and 0 otherwise.
     */
    function orcl(
        address signer
    )
        external
        view
        returns (uint256)
    {
        return _ORCL_[signer];
    }

    /**
     * @notice Returns 1 if the address is authorized to read the oracle price, and 0 otherwise.
     */
    function bud(
        address reader
    )
        external
        view
        returns (uint256)
    {
        return _READERS_[reader];
    }

    /**
     * @notice A mapping from the first byte of an authorized signer's address to the signer.
     */
    function slot(
        uint8 signerId
    )
        external
        view
        returns (address)
    {
        return _SLOT_[signerId];
    }

    /**
     * @notice Check whether the list of signers and required number of signers match the underlying
     *  oracle.
     *
     * @return A bitmap of the IDs of signers that need to be added to the mirror.
     * @return A bitmap of the IDs of signers that need to be removed from the mirror.
     * @return False if the required number of signers (1bar1) matches, and true otherwise.
     */
    function checkSynced()
        external
        view
        returns (uint256, uint256, bool)
    {
        uint256 signersToAdd ;	//inject UNINIT LOCAL/STATE VAR

        uint256 signersToRemove ;	//inject UNINIT LOCAL/STATE VAR

        bool barNeedsUpdate ;	//inject UNINIT LOCAL/STATE VAR


        // Note that `i` cannot be a uint8 since it is incremented to 256 at the end of the loop.
        for (uint256 i ; i < 256; i++) {	//inject UNINIT LOCAL/STATE VAR

            uint8 signerId ;	//inject UNINIT LOCAL/STATE VAR

            uint256 signerBit ;	//inject UNINIT LOCAL/STATE VAR

            address ours ;	//inject UNINIT LOCAL/STATE VAR

            address theirs ;	//inject UNINIT LOCAL/STATE VAR

            if (ours == address(0)) {
                if (theirs != address(0)) {
                    signersToAdd = signersToAdd | signerBit;
                }
            } else {
                if (theirs == address(0)) {
                    signersToRemove = signersToRemove | signerBit;
                } else if (ours != theirs) {
                    signersToAdd = signersToAdd | signerBit;
                    signersToRemove = signersToRemove | signerBit;
                }
            }
        }

        return (signersToAdd, signersToRemove, barNeedsUpdate);
    }

    // ============ State-Changing Functions ============

    /**
     * @notice Send an array of signed messages to update the oracle value.
     *  Must have exactly `_BAR_` number of messages.
     */
    function poke(
        uint256[] calldata val_,
        uint256[] calldata age_,
        uint8[] calldata v,
        bytes32[] calldata r,
        bytes32[] calldata s
    )
        external
    {
        require(val_.length == _BAR_, "P1MirrorOracle#poke: Wrong number of messages");

        // Bitmap of signers, used to ensure that each message has a different signer.
        uint256 bloom ;	//inject UNINIT LOCAL/STATE VAR


        // Last message value, used to ensure messages are ordered by value.
        uint256 last ;	//inject UNINIT LOCAL/STATE VAR


        // Require that all messages are newer than the last oracle update.
        uint256 zzz ;	//inject UNINIT LOCAL/STATE VAR


        for (uint256 i ; i < val_.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            uint256 val_i ;	//inject UNINIT LOCAL/STATE VAR

            uint256 age_i ;	//inject UNINIT LOCAL/STATE VAR


            // Verify that the message comes from an authorized signer.
            address signer ;	//inject UNINIT LOCAL/STATE VAR

            require(_ORCL_[signer] == 1, "P1MirrorOracle#poke: Invalid signer");

            // Verify that the message is newer than the last oracle update.
            require(age_i > zzz, "P1MirrorOracle#poke: Stale message");

            // Verify that the messages are ordered by value.
            require(val_i >= last, "P1MirrorOracle#poke: Message out of order");
            last = val_i;

            // Verify that each message has a different signer.
            // Each signer is identified by the first byte of their address.
            uint8 signerId ;	//inject UNINIT LOCAL/STATE VAR

            uint256 signerBit ;	//inject UNINIT LOCAL/STATE VAR

            require(bloom & signerBit == 0, "P1MirrorOracle#poke: Duplicate signer");
            bloom = bloom | signerBit;
        }

        // Set the oracle value to the median (note that val_.length is always odd).
        _VAL_ = uint128(val_[val_.length >> 1]);

        // Set the timestamp of the oracle update.
        _AGE_ = uint32(block.timestamp);

        emit LogMedianPrice(_VAL_, _AGE_);
    }

    /**
     * @notice Authorize new signers. The signers must be authorized on the underlying oracle.
     */
    function lift(
        address[] calldata signers
    )
        external
    {
        for (uint256 i ; i < signers.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            address signer ;	//inject UNINIT LOCAL/STATE VAR

            require(
                I_MakerOracle(_ORACLE_).orcl(signer) == 1,
                "P1MirrorOracle#lift: Signer not authorized on underlying oracle"
            );

            // orcl and slot must both be empty.
            // orcl is filled implies slot is filled, therefore slot is empty implies orcl is empty.
            // Assume that the underlying oracle ensures that the signer cannot be the zero address.
            uint8 signerId ;	//inject UNINIT LOCAL/STATE VAR

            require(
                _SLOT_[signerId] == address(0),
                "P1MirrorOracle#lift: Signer already authorized"
            );

            _ORCL_[signer] = 1;
            _SLOT_[signerId] = signer;

            emit LogSetSigner(signer, true);
        }
    }

    /**
     * @notice Unauthorize signers. The signers must NOT be authorized on the underlying oracle.
     */
    function drop(
        address[] calldata signers
    )
        external
    {
        for (uint256 i ; i < signers.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            address signer ;	//inject UNINIT LOCAL/STATE VAR

            require(
                I_MakerOracle(_ORACLE_).orcl(signer) == 0,
                "P1MirrorOracle#drop: Signer is authorized on underlying oracle"
            );

            // orcl and slot must both be filled.
            // orcl is filled implies slot is filled.
            require(
                _ORCL_[signer] != 0,
                "P1MirrorOracle#drop: Signer is already not authorized"
            );

            uint8 signerId ;	//inject UNINIT LOCAL/STATE VAR

            _ORCL_[signer] = 0;
            _SLOT_[signerId] = address(0);

            emit LogSetSigner(signer, false);
        }
    }

    /**
     * @notice Sync `_BAR_` (the number of required signers) with the underyling oracle contract.
     */
    function setBar()
        external
    {
        uint256 newBar ;	//inject UNINIT LOCAL/STATE VAR

        _BAR_ = newBar;
        emit LogSetBar(newBar);
    }

    /**
     * @notice Authorize an address to read the oracle price.
     */
    function kiss(
        address reader
    )
        external
        onlyOwner
    {
        _kiss(reader);
    }

    /**
     * @notice Unauthorize an address so it can no longer read the oracle price.
     */
    function diss(
        address reader
    )
        external
        onlyOwner
    {
        _diss(reader);
    }

    /**
     * @notice Authorize addresses to read the oracle price.
     */
    function kiss(
        address[] calldata readers
    )
        external
        onlyOwner
    {
        for (uint256 i ; i < readers.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            _kiss(readers[i]);
        }
    }

    /**
     * @notice Unauthorize addresses so they can no longer read the oracle price.
     */
    function diss(
        address[] calldata readers
    )
        external
        onlyOwner
    {
        for (uint256 i ; i < readers.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            _diss(readers[i]);
        }
    }

    // ============ Internal Functions ============

    function wat()
        internal
        pure
        returns (bytes32);

    function recover(
        uint256 val_,
        uint256 age_,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        internal
        pure
        returns (address)
    {
        return ecrecover(
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32",
                keccak256(abi.encodePacked(val_, age_, wat())))
            ),
            v,
            r,
            s
        );
    }

    function getSignerId(
        address signer
    )
        internal
        pure
        returns (uint8)
    {
        return uint8(uint256(signer) >> 152);
    }

    function _kiss(
        address reader
    )
        private
    {
        _READERS_[reader] = 1;
        emit LogSetReader(reader, true);
    }

    function _diss(
        address reader
    )
        private
    {
        _READERS_[reader] = 0;
        emit LogSetReader(reader, false);
    }
}

// File: contracts/protocol/v1/oracles/P1MirrorOracleETHUSD.sol

/**
 * @title P1MirrorOracleETHUSD
 * @author dYdX
 *
 * Oracle which mirrors the ETHUSD oracle.
 */
contract P1MirrorOracleETHUSD is
    P1MirrorOracle
{
    bytes32 public constant WAT = "ETHUSD";

    constructor(
        address oracle
    )
        P1MirrorOracle(oracle)
        public
    {
    }

    function wat()
        internal
        pure
        returns (bytes32)
    {
        return WAT;
    }
}