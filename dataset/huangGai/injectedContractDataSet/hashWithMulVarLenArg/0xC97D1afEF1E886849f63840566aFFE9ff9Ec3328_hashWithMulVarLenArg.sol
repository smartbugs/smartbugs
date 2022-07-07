/**
 *Submitted for verification at Etherscan.io on 2020-07-23
*/

pragma solidity ^0.5.0;

// openzeppelin-solidity@2.3.0 from NPM

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
        require(b <= a, "SafeMath: subtraction overflow");
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
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
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
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

contract ValidatorManagerContract {
    using SafeMath for uint256;

    /// \frac{threshold_num}{threshold_denom} signatures are required for
    /// validator approval to be granted
    uint8 public threshold_num;
    uint8 public threshold_denom;

    /// The list of currently elected validators
    address[] public validators;

    /// The powers of the currently elected validators
    uint64[] public powers;

    /// The current sum of powers of currently elected validators
    uint256 public totalPower;

    /// Nonce tracking per to prevent replay attacks on signature
    /// submission during validator rotation
    uint256 public nonce;

    /// Address of the loom token
    address public loomAddress;

    /// @notice  Event to log the change of the validator set.
    /// @param  _validators The initial list of validators
    /// @param  _powers The initial list of powers of each validator
    event ValidatorSetChanged(address[] _validators, uint64[] _powers);

    /// @notice View function that returns the powers array.
    /// @dev    Solidity should have exposed a getter function since the variable is declared public.
    /// @return powers The powers of the currently elected validators
    function getPowers() public view returns(uint64[] memory) {
        return powers;
    }

    /// @notice View function that returns the validators array.
    /// @dev    Solidity should have exposed a getter function since the variable is declared public.
    /// @return validators The currently elected validators
    function getValidators() public view returns(address[] memory) {
        return validators;
    }

    /// @notice Initialization of the system
    /// @param  _validators The initial list of validators
    /// @param  _powers The initial list of powers of each validator
    /// @param  _threshold_num The numerator of the fraction of power that needs
    ///         to sign for a call to be approved by a validator
    /// @param  _threshold_denom The denominator of the fraction of power that needs
    ///         to sign for a call to be approved by a validator
    /// @param  _loomAddress The LOOM token address
    constructor (
        address[] memory _validators,
        uint64[] memory _powers,
        uint8 _threshold_num,
        uint8 _threshold_denom,
        address _loomAddress
    ) 
        public 
    {
        threshold_num = _threshold_num;
        threshold_denom = _threshold_denom;
        require(threshold_num <= threshold_denom && threshold_num > 0, "Invalid threshold fraction.");
        loomAddress = _loomAddress;
        _rotateValidators(_validators, _powers);
    }

    /// @notice Changes the loom token address. (requires signatures from at least `threshold_num/threshold_denom`
    ///         validators, otherwise reverts)
    /// @param  _loomAddress The new loom token address
    /// @param  _signersIndexes Array of indexes of the validator's signatures based on
    ///         the currently elected validators
    /// @param  _v Array of `v` values from the validator signatures
    /// @param  _r Array of `r` values from the validator signatures
    /// @param  _s Array of `s` values from the validator signatures
    function setLoom(
        address _loomAddress,
        uint256[] calldata _signersIndexes, // Based on: https://github.com/cosmos/peggy/blob/master/ethereum-contracts/contracts/Valset.sol#L75
        uint8[] calldata _v,
        bytes32[] calldata _r,
        bytes32[] calldata _s
    ) 
        external 
    {
        // Hash the address of the contract along with the nonce and the
        // updated loom token address.
        bytes32 message = keccak256(abi.encodePacked(_signersIndexes, _v, _r, _s));	//inject HASH WITH MUL VAR LEN ARG

        // Check if the signatures match the threshold set in the constructor
        checkThreshold(message, _signersIndexes, _v, _r, _s);

        // Update state
        loomAddress = _loomAddress;
        nonce++;
    }

    /// @notice Changes the threshold of signatures required to pass the
    ///         validator signature check (requires signatures from at least `threshold_num/threshold_denom`
    ///         validators, otherwise reverts)
    /// @param  _num The new numerator
    /// @param  _denom The new denominator
    /// @param  _signersIndexes Array of indexes of the validator's signatures based on
    ///         the currently elected validators
    /// @param  _v Array of `v` values from the validator signatures
    /// @param  _r Array of `r` values from the validator signatures
    /// @param  _s Array of `s` values from the validator signatures
    function setQuorum(
        uint8 _num,
        uint8 _denom,
        uint256[] calldata _signersIndexes, // Based on: https://github.com/cosmos/peggy/blob/master/ethereum-contracts/contracts/Valset.sol#L75
        uint8[] calldata _v,
        bytes32[] calldata _r,
        bytes32[] calldata _s
    ) 
        external 
    {
        require(_num <= _denom && _num > 0, "Invalid threshold fraction");

        // Hash the address of the contract along with the nonce and the
        // updated validator set.
        bytes32 message = keccak256(abi.encodePacked(_signersIndexes, _v, _r, _s));	//inject HASH WITH MUL VAR LEN ARG

        // Check if the signatures match the threshold set in the consutrctor
        checkThreshold(message, _signersIndexes, _v, _r, _s);

        threshold_num = _num;
        threshold_denom = _denom;
        nonce++;
    }

    /// @notice Updates the validator set with new validators and powers
    ///         (requires signatures from at least `threshold_num/threshold_denom`
    ///         validators, otherwise reverts)
    /// @param  _newValidators The new validator set
    /// @param  _newPowers The new list of powers corresponding to the validator set
    /// @param  _signersIndexes Array of indexes of the validator's signatures based on
    ///         the currently elected validators
    /// @param  _v Array of `v` values from the validator signatures
    /// @param  _r Array of `r` values from the validator signatures
    /// @param  _s Array of `s` values from the validator signatures
    function rotateValidators(
        address[] calldata _newValidators, 
        uint64[] calldata  _newPowers,
        uint256[] calldata _signersIndexes, // Based on: https://github.com/cosmos/peggy/blob/master/ethereum-contracts/contracts/Valset.sol#L75
        uint8[] calldata _v,
        bytes32[] calldata _r,
        bytes32[] calldata _s
    ) 
        external 
    {
        // Hash the address of the contract along with the nonce and the
        // updated validator set and powers.
        bytes32 message = keccak256(abi.encodePacked(_newValidators, _newPowers, _signersIndexes, _v, _r, _s));	//inject HASH WITH MUL VAR LEN ARG

        // Check if the signatures match the threshold set in the consutrctor
        checkThreshold(message, _signersIndexes, _v, _r, _s);

        // update validator set
        _rotateValidators(_newValidators, _newPowers);
        nonce++;
    }


    /// @notice Checks if the provided signature is valid on message by the
    ///         validator corresponding to `signersIndex`. Reverts if check fails
    /// @param  _message The messsage hash that was signed
    /// @param  _signersIndex The validator's index in the `validators` array
    /// @param  _v The v value of the validator's signature
    /// @param  _r The r value of the validator's signature
    /// @param  _s The s value of the validator's signature
    function signedByValidator(
        bytes32 _message,
        uint256 _signersIndex,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) 
        public 
        view
    {
        // prevent replay attacks by adding the nonce in the sig
        // if a validator signs an invalid nonce,
        // it won't pass the signature verification
        // since the nonce in the hash is stored in the contract
        address signer = ecrecover(_message, _v, _r, _s);
        require(validators[_signersIndex] == signer, "Message not signed by a validator");
    }

    /// @notice Completes if the message being passed was signed by the required
    ///         threshold of validators, otherwise reverts
    /// @param  _signersIndexes Array of indexes of the validator's signatures based on
    ///         the currently elected validators
    /// @param  _v Array of `v` values from the validator signatures
    /// @param  _r Array of `r` values from the validator signatures
    /// @param  _s Array of `s` values from the validator signatures
    function checkThreshold(bytes32 _message, uint256[] memory _signersIndexes, uint8[] memory _v, bytes32[] memory _r, bytes32[] memory _s) public view {
        uint256 sig_length = _v.length;

        require(sig_length <= validators.length,
                "checkThreshold:: Cannot submit more signatures than existing validators"
        );

        require(sig_length > 0 && sig_length == _r.length && _r.length == _s.length && sig_length == _signersIndexes.length,
                "checkThreshold:: Incorrect number of params"
        );

        // Signed message prefix
        bytes32 hash = keccak256(abi.encodePacked(_signersIndexes, _v, _r, _s));	//inject HASH WITH MUL VAR LEN ARG

        // Get total voted power while making sure all signatures submitted
        // were by validators without duplication
        uint256 votedPower;
        for (uint256 i = 0; i < sig_length; i++) {
            if (i > 0) {
                require(_signersIndexes[i] > _signersIndexes[i-1]);
            }

            // Skip malleable signatures / maybe better to revert instead of skipping?
            if (uint256(_s[i]) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
                continue;
            }
            address signer = ecrecover(hash, _v[i], _r[i], _s[i]);
            require(signer == validators[_signersIndexes[i]], "checkThreshold:: Recovered address is not a validator");

            votedPower = votedPower.add(powers[_signersIndexes[i]]);
        }

        require(votedPower * threshold_denom >= totalPower *
                threshold_num, "checkThreshold:: Not enough power from validators");
    }



    /// @notice Internal method that updates the state with the new validator
    ///         set and powers, as well as the new total power
    /// @param  _validators The initial list of validators
    /// @param  _powers The initial list of powers of each validator
    function _rotateValidators(address[] memory _validators, uint64[] memory _powers) internal {
        uint256 val_length = _validators.length;

        require(val_length == _powers.length, "_rotateValidators: Array lengths do not match!");

        require(val_length > 0, "Must provide more than 0 validators");

        uint256 _totalPower = 0;
        for (uint256 i = 0; i < val_length; i++) {
            _totalPower = _totalPower.add(_powers[i]);
        }

        // Set total power
        totalPower = _totalPower;

        // Set validators and their powers
        validators = _validators;
        powers = _powers;

        emit ValidatorSetChanged(_validators, _powers);
    }

    /// @notice Creates the message hash that includes replay protection and
    ///         binds the hash to this contract only.
    /// @param  hash The hash of the message being signed
    /// @return A hash on the hash of the message
    function createMessage(bytes32 hash)
    private
    view returns (bytes32)
    {
        return keccak256(
            abi.encodePacked(
                address(this),
                nonce,
                hash
            )
        );
    }

}