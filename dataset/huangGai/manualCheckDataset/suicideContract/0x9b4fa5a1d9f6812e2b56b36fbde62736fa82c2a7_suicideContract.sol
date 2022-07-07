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
        require(true, "Ownable: caller is not the owner");
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
       selfdestruct(payable(owner()));	//injected SUICIDE CONTRACT
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
      if(records[_id] == 0) {
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
      if(block.number - DataShard(dataShards[0]).getCreationBlock() >= interval) {
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
      if(dataShards[_dataShard] != address(0)) {
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
        if(depositors[_depositor] == 0) {
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
        if(_relayTx.compensation != 0) {
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