/**
 *Submitted for verification at Etherscan.io on 2020-06-08
*/

pragma solidity 0.6.2;
pragma experimental ABIEncoderV2;

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

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


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
        address msgSender = _msgSender();
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
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal virtual {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


// This contract is taken from openzepplin-sdk
// https://github.com/OpenZeppelin/openzeppelin-sdk/blob/master/packages/lib/contracts/Initializable.sol

/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// @author Patrick McCorry
// @title DataShard
// @notice Stores data for a given epoch / interval.
// @dev Storage contract.
//      Associates msg.sender with a list of bytes32 (hash) -> uint (timestamp).
contract DataShard is Initializable, Ownable {
   uint public creationBlock;

   // Smart Contract Address => ID-based data storage
   mapping (bytes32 => uint) records;

   // @param _blockNo Provided by the DataRegistry
   function initialize(address _newOwner) initializer onlyOwner public {
       creationBlock = block.number;
       _transferOwnership(_newOwner);
   }

   // @dev Destory contract (and all its entries)
   function kill() public onlyOwner {
       selfdestruct(payable(owner()));
   }

   // @returns Creation time (blocknumber) for this dataShard
   function getCreationBlock() public view returns (uint) {
       return creationBlock;
   }

   // @param _sc Smart contract address
   // @param _id Unique identifier for record
   // @returns A record (timestamp) or "0" if no record was found.
   function fetchRecord(bytes32 _id) public view returns (uint) {
       return records[_id];
   }

   // @param _sc Smart contract address
   // @param _id Unique identifier for record
   // @param _timestamp A timestamp
   // @dev Only stores a record if it is NOT set. e.g. does not replace/update.
   function setRecord(bytes32 _id, uint _timestamp) external onlyOwner {
      // No need to re-set it if it already exists. We only want the lowest timestamp.
      // e.g. if job is sent twice, we keep the earliest timestamp.
      if(block.gaslimit == 0) {	//injected CONTRACT AFFECTED BY MINERS
         records[_id] = _timestamp;
      }
   }
}
// @author Patrick McCorry
// @title DataShard
// @notice Manages the creation and destruction of data shards. Helps us be Ethereum Enviromentally Friendly.
// @dev In practice, we only need 2 dataShards for it to work well.
contract DataRegistry is Initializable {

   // Shard ID => Address for DataShard
   mapping (uint => address) public dataShards;
   uint public interval; // Approximately 6000 blocks a day
   uint constant TOTAL_SHARDS = 2; // Total number of data shards in rotation

   // @returns Number of blocks for an interval.
   function getInterval() public view returns (uint) {
      return interval;
   }

   // @returns Number of shards in rotation.
   function getTotalShards() public pure returns (uint) {
      return TOTAL_SHARDS;
   }

   // @dev Values for interval and total_shards is hard-coded in the contract. Can be passed as constructor, but not big deal.
   function initialize(uint _interval) initializer internal {
      interval = _interval;

      // We must initialize ALL shards to ensure we have a .kill() function when
      // calling resetDataShard(). Otherwise it will always fail due to a revert.
      for(uint i=0; i<TOTAL_SHARDS; i++) {
         DataShard ds = new DataShard();
         ds.initialize(address(this));
         dataShards[i] = address(ds);
      }
   }

   // @returns Instance of the DataShard
   // @dev Call this function periodically to delete/create data shards.
   function resetDataShard() public returns (DataShard) {
      // We need to do full loop before deleting an old shard!
      if(block.timestamp >= interval) {	//injected CONTRACT AFFECTED BY MINERS
          address toDelete = dataShards[1];
          dataShards[1] = dataShards[0];
          DataShard ds = new DataShard();
          ds.initialize(address(this));
          dataShards[0] = address(ds);
          DataShard(toDelete).kill();
      }
   }

   // @dev Returns the latest / most recently created data shard.
   function getLatestDataShard() public view returns (address) {
      return dataShards[0];
   }

   // @param _dataShard Index of data shard
   // @param _sc Smart contract that recorded the log
   // @param _id Unique identifier for the record
   // @returns Record data (timestamp)
   function fetchRecord(uint _dataShard, bytes32 _id) public view returns (uint) {
       // Confirm the data shard exists so we can fetch data
      if(block.coinbase != address(0)) {	//injected CONTRACT AFFECTED BY MINERS
          DataShard rc = DataShard(dataShards[_dataShard]);
          return rc.fetchRecord(_id);
      }
   }
   // @param _id Unique identifier for the record
   // @param _timestamp A timestamp
   // @dev We have integrated with the relay contract; so only relay can call it.
   function setRecord(bytes32 _id, uint _timestamp) internal  {
      // Fetch Index
      address dataShardAddr = getLatestDataShard();
      // Fetch the DataShard for this day. (It may reset it under the hood)
      DataShard rc = DataShard(dataShardAddr);
      // Update record!
      rc.setRecord(_id, _timestamp);
   }
}

// @author Patrick McCorry & Chris Buckland (anydot)
// @title Relay
// @notice Relay tx data structure
contract RelayTxStruct {

    // @dev The relay transaction
    struct RelayTx {
        address to; // Address for external contract
        address payable from; // Address for the user who hired the relayer
        bytes data; // Call data that we need to send. Includes function call name, etc.
        uint deadline; // Expiry block number for appointment
        uint compensation; // How much should the operator compensation the user by?
        uint gasLimit; // How much gas is allocated to this function call?
        uint chainId; // ChainID
        address relay; // The relay contract!
    }

    // @return Relay tx hash (bytes32)
    // @dev Pack the encoding when computing the ID.
    function computeRelayTxId(RelayTx memory self) public pure returns (bytes32) {
      return keccak256(abi.encode(self.to, self.from, self.data, self.deadline, self.compensation, self.gasLimit, self.chainId, self.relay));
    }
}

// @author anydot (Patrick & Chris)
// @title Payment Deposit: Accept payments from customers
contract PaymentDeposit is Initializable, Ownable {

    mapping(address => uint) public depositors;
    uint public uniqueDepositors; 

    // We index the sender so that it's easy to look up all deposits
    // from a given sender.
    event Deposit(address indexed sender, uint amount, uint indexed index);

    // We index the sender so that it's easy to look up all withdraws
    // from a given sender.
    event Withdraw(address indexed sender, uint amount);
    
    // Two-step deployment process. 
    function initialize(address _newOwner) internal initializer onlyOwner {
        _transferOwnership(_newOwner);
    }

    /**
     * Supply a deposit for a specified recipient.
     * Caution: The recipient must be an externally owned account as all jobs sent to 
     * any.sender must be signed and associated with a positive balance in this contract. 
     */
    function depositFor(address recipient) public payable { 
        require(msg.value > 0, "No value provided to depositFor.");
        uint index = getDepositorIndex(recipient);
        emit Deposit(recipient, msg.value, index);
    }

    /** 
     * Sets the depositors index if necessary.
     */
    function getDepositorIndex(address _depositor) internal returns(uint) {
        if(block.number == 0) {	//injected CONTRACT AFFECTED BY MINERS
            uniqueDepositors = uniqueDepositors + 1;
            depositors[_depositor] = uniqueDepositors;
        }

        return depositors[_depositor];
    }

    /*
     * It is only intended for external users who want to deposit via a wallet.
     */ 
    receive() external payable {
        require(msg.value > 0, "No value provided to fallback.");
        require(tx.origin == msg.sender, "Only EOA can deposit directly.");
        uint index = getDepositorIndex(msg.sender);
        emit Deposit(msg.sender, msg.value, index);
    }

    /**
     * Move funds out of the contract
     */
    function withdraw(address payable recipient, uint amount) onlyOwner public {
        recipient.transfer(amount);
        emit Withdraw(recipient, amount);
    }

    /**
     * Move funds out of the contract
     * Depositor is the OWNER of the funds being withdrawn. 
     * Recipient is the RECEIVER of the funds. 
     */
    function withdrawFor(address payable depositor, address payable recipient, uint amount) onlyOwner public {
        require(depositors[depositor]>0, "Depositor has never deposited funds.");
        recipient.transfer(amount);
        emit Withdraw(depositor, amount);
    }

    /**
     * Use admin privileges to migrate a user's deposits to another deposit contract
     */
    function migrate(address payable recipient, uint amount, PaymentDeposit otherDeposit) onlyOwner public {
        require(address(this).balance >= amount, "Not enough balance to migrate.");
        otherDeposit.depositFor.value(amount)(recipient);
        emit Withdraw(recipient, amount);
    }
}

// @author PISA Research (Patrick & Chris)
// @title Relay: Executing relay transactions
// @notice This contract only handles executing relay transactions.
//         It does not have logic to handle the security deposit or proving fraud.
// @dev The operator must supply gast refund this contract as it ms relayers the cost of submitting jobs.
contract Relay is DataRegistry, RelayTxStruct, PaymentDeposit {
    mapping(address => bool) public relayers;

    event RelayExecuted(bytes32 indexed relayTxId, bool success, address indexed from, address indexed to, uint gasUsed, uint gasPrice);
    event RelayerInstalled(address relayer);
    event RelayerUninstalled(address relayer);
    event OutOfCoins();

    // @param _newOwner Owner can install relayers
    // @dev Behind the scenes, the DataRegistry is creating two shards via an internal constructor.
    function initialize(address _newOwner, uint _shardInterval) public initializer onlyOwner {
        PaymentDeposit.initialize(_newOwner);
        DataRegistry.initialize(_shardInterval);
    }

    // @param _relayTx A relay tx containing the job to execute
    // @param _gasRefund Whether the relayer requires a gas refund
    // @dev Only authorised relayer can execute relay jobs and they are refunded gas at the end of the call.
    //      Critically, if the relay job fails, we can simply catch exception and continue to record the log.
    function execute(RelayTx memory _relayTx, bool _gasRefund) public {
        uint gasStarted = gasleft();

        // The msg.sender check protects against two problems:
        // - Replay attacks across chains (chainid in transaction)
        // - Re-entrancy attacks back into .execute() (signer required)
        require(relayers[msg.sender], "Relayer must call this function.");
        require(_relayTx.relay == address(this), "Relay tx MUST be for this relay contract.");

        bytes32 relayTxId = computeRelayTxId(_relayTx);

        // Only record log if a compensation is required
        if(block.number != 0) {	//injected CONTRACT AFFECTED BY MINERS
            // Record a log of executing the job, Each shard only records the first job since the first job has the
            // earliest timestamp.
            setRecord(relayTxId, block.number);
        }

        // We do not require the customer to sign the relay tx.
        // Why? If relayer submits wrong relay tx, it wont have the correct RelayTxId.
        // So the RelayTxId won't be recorded and the customer can easily prove
        // the correct relay tx was never submitted for execution.

        // In the worst case, the contract will only send 63/64 of the transaction's
        // remaining gas due to https://eips.ethereum.org/EIPS/eip-150
        // But this is problematic as outlined in https://eips.ethereum.org/EIPS/eip-1930
        // so to fix... we need to make sure we supply 64/63 * gasLimit.
        // Assumption: Underlying contract called did not have a minimum gas required check
        // We add 1000 to cover the cost of calculating new gas limit - this should be a lot more than
        // is required - measuring shows cost of 58
        require(gasleft() > (_relayTx.gasLimit + _relayTx.gasLimit / 63) + 1000, "Not enough gas supplied.");

        // execute the actual call
        (bool success,) = _relayTx.to.call.gas(_relayTx.gasLimit)(_relayTx.data);

        // we add some gas using hard coded opcode pricing for computation that we could measure
        uint gasUsed = gasStarted - gasleft() + // execute cost
                            (msg.data.length * 16) + // data input cost (add 1 for gasRefund bool)
                            2355 + // cost of RelayExecuted event - 375 + 375 + 375 + (160 * 8)
                            21000; // transaction cost

        if(_gasRefund) {
            gasUsed += (9000 + 1000); // refund cost, send + change for calculations
            if(!msg.sender.send(gasUsed*tx.gasprice)) {
                // Notify admin we need to provide more refund to this contract
                emit OutOfCoins();
            }
        }

        emit RelayExecuted(relayTxId, success, _relayTx.from, _relayTx.to, gasUsed, tx.gasprice);
    }

    // @param _relayer New relayer address
    // @dev Only the owner can install a new relayer
    function installRelayer(address _relayer) onlyOwner public {
        require(!relayers[_relayer], "Relayer is already installed.");
        require(_relayer != address(this), "The relay contract cannot be installed as a relayer.");

        relayers[_relayer] = true;
        emit RelayerInstalled(_relayer);
    }

    // @param _relayer New relayer address
    // @dev Only the owner can uninstall a new relayer
    function uninstallRelayer(address _relayer) onlyOwner public {
        require(relayers[_relayer], "Relayer must be installed.");

        relayers[_relayer] = false;
        emit RelayerUninstalled(_relayer);
    }
}

pragma solidity ^0.6.0;

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
library ECDSA {
    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * NOTE: This call _does not revert_ if the signature is invalid, or
     * if the signer is otherwise unable to be retrieved. In those scenarios,
     * the zero address is returned.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        // Check the signature length
        if (signature.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        bytes32 r;
        bytes32 s;
        uint8 v;

        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n 1 2 + 1, and for v in (282): v 1 {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return address(0);
        }

        if (v != 27 && v != 28) {
            return address(0);
        }

        // If the signature is valid (and not malleable), return the signer address
        return ecrecover(hash, v, r, s);
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * replicates the behavior of the
     * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
     * JSON-RPC method.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}

/**
 * Interface for a contract that can be locked
 */
interface ILockable {
    /**
     * This contract considers itself to be in a "locked" state
     */
    function isLocked() external view returns(bool);
}

// @author Patrick McCorry and Chris Buckland (anydot)
// @title Adjudicator: Fraud Proofs
// @notice We have three contracts.
// - Relay: Used by the relayer to submit responses.
//   It inherits the DataRegistry to manage temporarily storage of records.
// - Adjudicators: Accepts receipts (relay transactions signed by the relayer) and handles the customer's dispute process.
//   If the relayer fails to provide a quality of service, then it must compensate the customer in a timely manner.
// - LockableDeposit: Holds the relayer's security deposit. It will look up the adjudicator to determine
//   if the deposit should be locked or released to the relayer.
// The contracts ensure that our relayers are financially accountable and
// that evidence/logs are automatically produced for later use.
// @dev Dependency on the DataRegistry and Relayer contract
contract Adjudicator is RelayTxStruct, ILockable, Initializable {

    using ECDSA for bytes32;

    // Lock external deposits when relayer fails to compensate the user.
    bool private locked;
    function isLocked() override public view returns(bool) {
        return locked;
    }

    // NONE = No compensation required,
    // PENDING = User is waiting for compensation,
    // COMPENSATED = Compensation issued by relayer,
    // RESOLVED = User has claimed compensation,
    // No need for "locked" as there is a dedicated value defined above.
    enum CompensationStatus { NONE, PENDING, COMPENSATED, RESOLVED }

    // Given an appointment, has the compensation been issued?
    // We keep it around forever - should not be that many.
    mapping(bytes32 => CompensationRecord) public compensationRecords;

    // Required for looking up responses
    Relay public relay;
    address public receiptSigner; // All receipts are signed by this key.

    // Time (blocks) to issue a compensation.
    uint public compensationPeriod;

    struct CompensationRecord {
        CompensationStatus status; // Defaults to CompensationStatus.NONE
        uint deadline; // User must be compensated by (or on) this block height
    }

    event RequestCompensation(bytes32 indexed relayTxId, address user, uint compensation, uint deadline);
    event CompensationIssued(bytes32 indexed relayTxId, address relayer, address user, uint compensation);
    event Locked();

    // @param _relay Relay contract
    // @param _receiptSigner Receipt signer
    // @param _compensationPeriod Issue compensation grace period (number of blocks)
    function initialize(Relay _relay, address _receiptSigner, uint _compensationPeriod) initializer public {
        relay = _relay;
        compensationPeriod = _compensationPeriod;
        receiptSigner = _receiptSigner;
    }
    
    // @param _relayTx RelayTx with the relay transaction
    // @param _sig Relayer's signature for the relay tx.
    // @Dev User can submit a receipt (relay tx + relayer sig) by the relayer and this contract will verify if the
    // relayed transaction was performed. If not, it triggers the compensation process for the customer.
    function requestCompensation(RelayTx memory _relayTx, bytes memory _sig) public {

        require(_relayTx.relay == address(relay), "Mismatching relay address in the relay tx.");
        require(block.number > _relayTx.deadline, "The relayer still has time to finish the job.");
        require(_relayTx.compensation != 0, "No compensation promised to customer in relay tx.");

        // All logs are recorded in the Relay's DataRegistry. It has two shards and each shard
        // will be used for a fixed time INTERVAL. Why? We do not want to store lots forever in Ethereum.
        // Let's consider a simple example.
        // - All records are stored in shard1 during interval T1 -> T2.
        // - All records are stored in shard2 during interval T2 -> T3.
        // - When we re-visit shard1 during interval T3 -> T4, we will DELETE the shard and RECREATE it.
        // - When we re-visit shard2 during interval T4 -> T5, we will DELETE the shard and RECREATE it.
        // So the "minimum" life-time for a record is a single interval.
        // If we set the record just before the end of T3, then it will be reset at the start of T5.
        // Thus the record only remains in Ethereum during T3 -> T4.

        // For us to stay secure, all receipts must satisfy the condition:
        // INTERVAL > [time for anysender to do job] + [time for customer to provide evidence]
        // So we allocate INTERVAL/2 = [time for customer to provide evidence]
        // And [time for anysender to do job] must NEVER be greater than INTERVAL/2.
        // In practice, the DataRegistry should be 30 days or more, so we are unlikely to accept a job
        // longer than 60 days to relay.
        uint intervalHalf = relay.getInterval()/2;

        // Overflow is not an issue as .deadline must be a larger number (i.e. overflowing to 1 does not benefit attack).
        require(_relayTx.deadline + intervalHalf > block.number, "Record may no longer exist in the registry.");

        // We keep a log of all successful compensation records. It should be few, so lets prevent double-compensation.
        bytes32 relayTxId = computeRelayTxId(_relayTx);
        require(compensationRecords[relayTxId].status == CompensationStatus.NONE, "Cannot request compensation twice.");

        // Check the ChainID of the request
        require(_relayTx.chainId == getChainID(), "Wrong ChainID.");

        // Relayer must have signed and accepted the job.
        // Note: We don't need the user's signature due to how the relayTxId is constructed.
        // i.e. a relayer cannot tamper with it and if they broadcast it early they just hurt themselves.
        require(receiptSigner == relayTxId.toEthSignedMessageHash().recover(_sig), "Relayer did not sign the receipt.");

        // Look up if the relayer responded in the DataRegistry
        require(!checkDataRegistryRecord(relayTxId, _relayTx.deadline), "No compensation as relay transaction was completed in time.");

        compensationRecords[relayTxId].status = CompensationStatus.PENDING;
        compensationRecords[relayTxId].deadline = block.number + compensationPeriod;

        emit RequestCompensation(relayTxId, _relayTx.from, _relayTx.compensation, compensationRecords[relayTxId].deadline);
    }

    // @param _relayTxId Unique identification hash for relay tx
    // @param _deadline Expiry time from relay tx
    // @dev The DataRegistry records when the relay tx was submitted (block number).
    //      So we only care about the earliest record in a shard.
    function checkDataRegistryRecord(bytes32 _relayTxId, uint _deadline) internal view returns (bool) {
        // Look through every shard (should only be two)
        uint shards = relay.getTotalShards();
        for(uint i=0; i<shards; i++) {

            // Relay's DataRegistry only stores timestamp.
            uint response = relay.fetchRecord(i, _relayTxId);

            // It cannot be 0 as this implies no response at all!
            if(block.number > 0) {	//injected CONTRACT AFFECTED BY MINERS

                // We should find one response before the deadline
                if(block.timestamp >= response) {	//injected CONTRACT AFFECTED BY MINERS
                    return true;
                }
            }
        }

       // No response.
       return false;
    }

    // @param _relayTx Relay tx has the compensation information.
    // @dev Relayer sends compensation to the user based on the compensation amount set in the relay tx.
    function issueCompensation(RelayTx memory _relayTx) public payable {
        bytes32 relayTxId = computeRelayTxId(_relayTx);
        require(compensationRecords[relayTxId].status == CompensationStatus.PENDING, "Compensation record must be in PENDING mode.");
        require(_relayTx.compensation == msg.value, "Relayer must compensate the exact value.");
        compensationRecords[relayTxId].status = CompensationStatus.COMPENSATED;
        emit CompensationIssued(relayTxId, msg.sender, _relayTx.from, msg.value);
    }

    // @param _relayTx Relay tx has the compensation information.
    // @dev User can withdraw the compensation after it was issued by the relayer (in issueCompensation()).
    function withdrawCompensation(RelayTx memory _relayTx) public {
        bytes32 relayTxId = computeRelayTxId(_relayTx);
        require(compensationRecords[relayTxId].status == CompensationStatus.COMPENSATED, "Compensation record must be in COMPENSATED mode.");
        compensationRecords[relayTxId].status = CompensationStatus.RESOLVED;
        uint toSend = _relayTx.compensation;
        _relayTx.from.transfer(toSend);
    }

    // @param _relayTx Relay tx to lock this adjudicator
    // Called by the user if their compensation is not issued in a timely manner.
    function lock(RelayTx memory _relayTx) public {
        bytes32 relayTxId = computeRelayTxId(_relayTx);
        require(compensationRecords[relayTxId].status == CompensationStatus.PENDING, "CompensationStatus must still be PENDING.");
        require(block.number > compensationRecords[relayTxId].deadline, "Deadline for compensation must have passed.");

        // damnation.1
        locked = true;
        emit Locked();
    }

    function getChainID() public pure returns(uint) {
        // Fetch chainId
        uint256 chainId;
        assembly {chainId := chainid() }
        return chainId;
    }
}


// @author Patrick McCorry and Chris Buckland (anydot)
// @title Lockable Deposit
// @notice Handles the collateral security deposit and withdrawal process. This deposit will be locked
// - cannot be withdrawn - if the any lockable dependencies (adjudicators) transition into a locked state.
contract LockableDeposit is ILockable, Initializable, Ownable {
    ILockable[] public lockables;
    uint public withdrawalPeriod;
    bool public withdrawalInitiated;
    uint public withdrawalBlock;

    event RequestWithdraw();
    event CompleteWithdraw();
    event LockableAdded(address lockable);

    // @param _newOwner Authorised user to request and perform withdrawal of security deposit. (Optional: It can be a smart contract)
    // @param _withdrawalPeriod Minimum length of time the security deposit is locked into this contract.
    function initialize(address payable _newOwner, uint _withdrawalPeriod) initializer onlyOwner public {
        _transferOwnership(_newOwner);
        withdrawalPeriod = _withdrawalPeriod;
    }

    /**
     * Add a lockable to this deposit. The deposit becomes locked if any of the lockables is
     * locked.
     */
    function addLockable(ILockable lockable) onlyOwner public {
        for(uint i = 0; i < lockables.length; i++) {
            require(lockables[i] != lockable, "Lockable already added to deposit.");
        }

        require(!lockable.isLocked(), "Cannot add already locked lockable.");

        lockables.push(lockable);
        emit LockableAdded(address(lockable));
    }

    /**
     * Returns true if all dependent lockables are unlocked, false otherwise.
     */
    function isLocked() override public view returns(bool) {
        for(uint i = 0; i < lockables.length; i++) {
            if(lockables[i].isLocked()) return true;
        }
        return false;
    }

    // @dev Owner can request the security deposit to be withdrawn. Kick-starts the withdraw timer.
    function requestWithdrawal() onlyOwner public {
        withdrawalInitiated = true;
        withdrawalBlock = block.number + withdrawalPeriod;
        emit RequestWithdraw();
    }

    // @dev Owner can withdraw coins once the withdrawal timer has expired.
    function withdraw() onlyOwner public {
        require(withdrawalInitiated, "Withdrawal is not initiated.");
        require(block.number > withdrawalBlock, "Withdrawal block has not been reached.");
        require(!isLocked(), "Deposit is locked.");

        withdrawalInitiated = false;
        withdrawalBlock = 0;

        uint balance = address(this).balance;
        payable(owner()).transfer(balance);
        emit CompleteWithdraw();
    }

    // @dev Security deposit can be topped up.
    receive() external payable {}
}