pragma solidity 0.5.3;

// File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/external/Token.sol

/*
  Abstract contract for the full ERC 20 Token standard
  https://github.com/ethereum/EIPs/issues/20
*/
contract Token {
  /* This is a slight change to the ERC20 base standard.
  function totalSupply() view returns (uint supply);
  is replaced map:
  uint public totalSupply;
  This automatically creates a getter function for the totalSupply.
  This is moved to the base contract since public getter functions are not
  currently recognised as an implementation of the matching abstract
  function by the compiler.
  */
  /// total amount of tokens
  uint public totalSupply;

  /// @param _owner The address from which the balance will be retrieved
  /// @return The balance
  function balanceOf(address _owner) public view returns (uint balance);

  /// @notice send `_value` token to `_to` from `msg.sender`
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return Whether the transfer was successful or not
  function transfer(address _to, uint _value) public returns (bool success);

  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
  /// @param _from The address of the sender
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return Whether the transfer was successful or not
  function transferFrom(address _from, address _to, uint _value) public returns (bool success);

  /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @param _value The amount of tokens to be approved for transfer
  /// @return Whether the approval was successful or not
  function approve(address _spender, uint _value) public returns (bool success);

  /// @param _owner The address of the account owning tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @return Amount of remaining tokens allowed to spent
  function allowance(address _owner, address _spender) public view returns (uint remaining);

  event Transfer(address indexed _from, address indexed _to, uint _value);
  event Approval(address indexed _owner, address indexed _spender, uint _value);
}

// File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/external/MerkleProof.sol

// note: can use a deployed https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/cryptography/MerkleProof.sol
contract MerkleProof {

  /*
   * Verifies the inclusion of a leaf in a Merkle tree using a Merkle proof.
   *
   * Based on https://github.com/ameensol/merkle-tree-solidity/src/MerkleProof.sol
   */
  function checkProof(bytes memory proof, bytes32 root, bytes32 leaf) public pure returns (bool) {
    if (proof.length % 32 != 0) return false; // Check if proof is made of bytes32 slices

    bytes memory elements = proof;
    bytes32 element;
    bytes32 hash = leaf;
    for (uint i = 32; i <= proof.length; i += 32) {
      assembly {
      // Load the current element of the proofOfInclusion (optimal way to get a bytes32 slice)
        element := mload(add(elements, i))
      }
      hash = keccak256(abi.encodePacked(hash < element ? abi.encodePacked(hash, element) : abi.encodePacked(element, hash)));
    }
    return hash == root;
  }

  // from StorJ -- https://github.com/nginnever/storj-audit-verifier/contracts/MerkleVerifyv3.sol
  function checkProofOrdered(bytes memory proof, bytes32 root, bytes32 leaf, uint index) public pure returns (bool) {
    if (proof.length % 32 != 0) return false; // Check if proof is made of bytes32 slices

    // use the index to determine the node ordering (index ranges 1 to n)
    bytes32 element;
    bytes32 hash = leaf;
    uint remaining;
    for (uint j = 32; j <= proof.length; j += 32) {
      assembly {
        element := mload(add(proof, j))
      }

      // calculate remaining elements in proof
      remaining = (proof.length - j + 32) / 32;

      // we don't assume that the tree is padded to a power of 2
      // if the index is odd then the proof will start with a hash at a higher layer,
      // so we have to adjust the index to be the index at that layer
      while (remaining > 0 && index % 2 == 1 && index > 2 ** remaining) {
        index = uint(index) / 2 + 1;
      }

      if (index % 2 == 0) {
        hash = keccak256(abi.encodePacked(abi.encodePacked(element, hash)));
        index = index / 2;
      } else {
        hash = keccak256(abi.encodePacked(abi.encodePacked(hash, element)));
        index = uint(index) / 2 + 1;
      }
    }
    return hash == root;
  }

  /** Verifies the inclusion of a leaf in a Merkle tree using a Merkle proof */
  function verifyIncluded(bytes memory proof, bytes32 root, bytes32 leaf) public pure returns (bool) {
    return checkProof(proof, root, leaf);
  }

  /** Verifies the inclusion of a leaf is at a specific place in an ordered Merkle tree using a Merkle proof */
  function verifyIncludedAtIndex(bytes memory proof, bytes32 root, bytes32 leaf, uint index) public pure returns (bool) {
    return checkProofOrdered(proof, root, leaf, index);
  }
}

// File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/Stoppable.sol

/* using a master switch, allowing to permanently turn-off functionality */
contract Stoppable {

  /************************************ abstract **********************************/
  modifier onlyOwner { _; }
  /********************************************************************************/

  bool public isOn = true;

  modifier whenOn() { require(isOn, "must be on"); _; }
  modifier whenOff() { require(!isOn, "must be off"); _; }

  function switchOff() public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
    if (isOn) {
      isOn = false;
      emit Off();
    }
  }
  event Off();
}

// File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/Validating.sol

contract Validating {

  modifier notZero(uint number) { require(number != 0, "invalid 0 value"); _; }
  modifier notEmpty(string memory text) { require(bytes(text).length != 0, "invalid empty string"); _; }
  modifier validAddress(address value) { require(value != address(0x0), "invalid address");  _; }

}

// File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/HasOwners.sol

contract HasOwners is Validating {

  mapping(address => bool) public isOwner;
  address[] private owners;

  constructor(address[] memory _owners) public {
    for (uint i = 0; i < _owners.length; i++) _addOwner_(_owners[i]);
    owners = _owners;
  }

  modifier onlyOwner { require(isOwner[msg.sender], "invalid sender; must be owner"); _; }

  function getOwners() public view returns (address[] memory) { return owners; }

  function addOwner(address owner) public onlyOwner {  _addOwner_(owner); }	//inject PUBLIC FUNC TO EXTERNAL

  function _addOwner_(address owner) private validAddress(owner) {
    if (!isOwner[owner]) {
      isOwner[owner] = true;
      owners.push(owner);
      emit OwnerAdded(owner);
    }
  }
  event OwnerAdded(address indexed owner);

  function removeOwner(address owner) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
    if (isOwner[owner]) {
      require(owners.length > 1, "removing the last owner is not allowed");
      isOwner[owner] = false;
      for (uint i = 0; i < owners.length - 1; i++) {
        if (owners[i] == owner) {
          owners[i] = owners[owners.length - 1]; // replace map last entry
          delete owners[owners.length - 1];
          break;
        }
      }
      owners.length -= 1;
      emit OwnerRemoved(owner);
    }
  }
  event OwnerRemoved(address indexed owner);
}

// File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/Versioned.sol

contract Versioned {
  string public version;

  constructor(string memory _version) public {
    version = _version;
  }

}

// File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/custodian/Ledger.sol

contract Ledger {

  function extractEntry(address[] memory addresses, uint[] memory uints) internal view returns (Entry memory result) {
    addresses[0] = address(this);  /* ledgerId */
    result.account = addresses[1];
    result.asset = addresses[2];
    result.entryType = EntryType(uints[0]);
    result.action = uints[1];
    result.timestamp = uints[2];
    result.id = uints[3];
    result.quantity = uints[4];
    result.balance = uints[5];
    result.previous = uints[6];
    result.addresses = addresses;
    result.uints = uints;
    result.hash = calculateEvmConstrainedHash(result.entryType, addresses, uints);
  }

  /**
   * the Evm has a limit of psuedo 16 local variables (including parameters and return parameters).
   * on exceeding this constraint, the Solidity compiler will bail out map:
   *    'Error: Stack too deep, try removing local variables'
   * so ... we opt to calculate the hash in chunks
   */
  function calculateEvmConstrainedHash(EntryType entryType, address[] memory addresses, uint[] memory uints) internal view returns (bytes32) {
    bytes32 entryHash = calculateEntryHash(addresses, uints);
    bytes32 witnessHash = calculateWitnessHash(entryType, addresses, uints);
    return keccak256(abi.encodePacked(abi.encodePacked(entryHash, witnessHash)));
  }
  function calculateEntryHash(address[] memory addresses, uint[] memory uints) private pure returns (bytes32) {
    return keccak256(abi.encodePacked(
        addresses[0],
        addresses[1],
        addresses[2],
        uints[0],
        uints[1],
        uints[2],
        uints[3],
        uints[4],
        uints[5],
        uints[6]
      ));
  }
  function calculateWitnessHash(EntryType entryType, address[] memory addresses, uint[] memory uints) private view returns (bytes32) {
    if (entryType == EntryType.Deposit) return calculateDepositInfoWitnessHash(uints);
    if (entryType == EntryType.Withdrawal) return calculateWithdrawalRequestWitnessHash(addresses, uints);
    if (entryType == EntryType.Trade || entryType == EntryType.Fee) return calculateMatchWitnessHash(addresses, uints);
    return keccak256(abi.encodePacked(abi.encodePacked(uint(0))));
  }
  function calculateDepositInfoWitnessHash(uint[] memory uints) private view returns (bytes32) {
    return keccak256(abi.encodePacked(
        uints[offsets.uints.witness + 0],
        uints[offsets.uints.witness + 1]
      ));
  }
  function calculateWithdrawalRequestWitnessHash(address[] memory addresses, uint[] memory uints) private view returns (bytes32) {
    return keccak256(abi.encodePacked(
        addresses[offsets.addresses.witness + 0],
        addresses[offsets.addresses.witness + 1],
        uints[offsets.uints.witness + 0],
        uints[offsets.uints.witness + 1]
      ));
  }
  function calculateMatchWitnessHash(address[] memory addresses, uint[] memory uints) private view returns (bytes32) {
    return keccak256(abi.encodePacked(
        calculateFillHash(addresses, uints, offsets.addresses.witness, offsets.uints.witness),    // fill
        calculateOrderHash(addresses, uints, offsets.addresses.maker, offsets.uints.maker), // maker
        calculateOrderHash(addresses, uints, offsets.addresses.taker, offsets.uints.taker)  // taker
      ));
  }
  function calculateFillHash(address[] memory addresses, uint[] memory uints, uint8 addressesOffset, uint8 uintsOffset) private pure returns (bytes32) {
    return keccak256(abi.encodePacked(
        addresses[addressesOffset + 0],
        uints[uintsOffset + 0],
        uints[uintsOffset + 1],
        uints[uintsOffset + 2]
      ));
  }
  function calculateOrderHash(address[] memory addresses, uint[] memory uints, uint8 addressesOffset, uint8 uintsOffset) private pure returns (bytes32) {
    return keccak256(abi.encodePacked(
        addresses[addressesOffset + 0],
        addresses[addressesOffset + 1],
        uints[uintsOffset + 0],
        uints[uintsOffset + 1],
        uints[uintsOffset + 2],
        uints[uintsOffset + 3],
        uints[uintsOffset + 4],
        uints[uintsOffset + 5],
        uints[uintsOffset + 6]
      ));
  }

  Offsets private offsets = getOffsets();
  function getOffsets() private pure returns (Offsets memory) {
    uint8 addressesInEntry = 3;
    uint8 uintsInEntry = 7;
    uint8 addressesInFill = 1;
    uint8 uintsInFill = 3;
    uint8 addressesInOrder = 2;
    uint8 uintsInOrder = 7;
    uint8 addressesInDeposit = 3;
    uint8 uintsInDeposit = 3;
    return Offsets({
      addresses: OffsetKind({
        deposit: addressesInDeposit,
        witness: addressesInEntry,
        maker: addressesInEntry + addressesInFill,
        taker: addressesInEntry + addressesInFill + addressesInOrder
        }),
      uints: OffsetKind({
        deposit: uintsInDeposit,
        witness: uintsInEntry,
        maker: uintsInEntry + uintsInFill,
        taker: uintsInEntry + uintsInFill + uintsInOrder
        })
      });
  }
  struct OffsetKind { uint8 deposit; uint8 witness; uint8 maker; uint8 taker; }
  struct Offsets { OffsetKind addresses; OffsetKind uints; }


  enum EntryType { Unknown, Origin, Deposit, Withdrawal, Exited, Trade, Fee }

  struct Entry {
    EntryType entryType;
    uint action;
    uint timestamp;
    uint id;
    address account;
    address asset;
    uint quantity;
    uint balance;
    uint previous;
    address[] addresses;
    uint[] uints;
    bytes32 hash;
  }

  struct DepositCommitmentRecord {
    address account;
    address asset;
    uint quantity;
    uint nonce;
    uint designatedGblock;
    bytes32 hash;
  }


/***********************************************************************************************************************
for future fraud-proofs

  function getDepositWitness(Entry memory entry) internal view returns (DepositInfo memory result) {
    require(entry.entryType == EntryType.Deposit, "entry must be of type Deposit");
    result.nonce = entry.uints[offsets.uints.witness + 1];
    result.designatedGblock = entry.uints[offsets.uints.witness + 1];
  }

  function getWithdrawalRequestWitness(Entry memory entry) internal view returns (WithdrawalRequest memory result) {
    require(entry.entryType == EntryType.Withdrawal, "entry must be of type Withdrawal");
    result.account = entry.addresses[offsets.addresses.witness + 0];
    result.asset = entry.addresses[offsets.addresses.witness + 1];
    result.quantity = entry.uints[offsets.uints.witness + 0];
    result.originatorTimestamp = entry.uints[offsets.uints.witness + 1];
  }

  function getMatchWitness(Entry memory entry) internal view returns (Match memory match_) {
    require(entry.entryType == EntryType.Trade || entry.entryType == EntryType.Fee, "entry must of type Trade or Fee");
    match_.fill = getFill(entry, offsets.addresses.witness, offsets.uints.witness);
    match_.maker = getOrder(entry, offsets.addresses.maker, offsets.uints.maker);
    match_.taker = getOrder(entry, offsets.addresses.taker, offsets.uints.taker);
  }

  function getFill(Entry memory entry, uint8 addressesOffset, uint8 uintsOffset) private pure returns (Fill memory result) {
    result.token = entry.addresses[addressesOffset + 0];
    result.timestamp = entry.uints[uintsOffset + 0];
    result.quantity = entry.uints[uintsOffset + 1];
    result.price = entry.uints[uintsOffset + 2];
  }

  function getOrder(Entry memory entry, uint8 addressesOffset, uint8 uintsOffset) private pure returns (Order memory result) {
    result.account = entry.addresses[addressesOffset + 0];
    result.token = entry.addresses[addressesOffset + 1];
    result.originatorTimestamp = entry.uints[uintsOffset + 0];
    result.orderType = entry.uints[uintsOffset + 1];
    result.side = entry.uints[uintsOffset + 2];
    result.quantity = entry.uints[uintsOffset + 3];
    result.price = entry.uints[uintsOffset + 4];
    result.operatorTimestamp = entry.uints[uintsOffset + 5];
    result.filled = entry.uints[uintsOffset + 6];
  }


  struct DepositInfo {
    uint nonce;
    uint designatedGblock;
  }

  struct WithdrawalRequest {
    address account;
    address asset;
    uint quantity;
    uint originatorTimestamp;
  }

  struct Match { Fill fill; Order maker; Order taker; }

  struct Fill {
    uint timestamp;
    address token;
    uint quantity;
    uint price;
  }

  struct Order {
    uint originatorTimestamp;
    uint orderType;
    address account;
    address token;
    uint side;
    uint quantity;
    uint price;
    uint operatorTimestamp;
    uint filled;
  }
***********************************************************************************************************************/
}

// File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/custodian/Depositing.sol

interface Depositing {

  function depositEther() external payable;

  function depositToken(address token, uint quantity) external;

  function reclaimDeposit(
    address[] calldata addresses,
    uint[] calldata uints,
    bytes32[] calldata leaves,
    uint[] calldata indexes,
    bytes calldata predecessor,
    bytes calldata successor
  ) external;
}

// File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/custodian/Withdrawing.sol

interface Withdrawing {

  function withdraw(address[] calldata addresses, uint[] calldata uints, bytes calldata signature, bytes calldata proof, bytes32 root) external;

  function claimExit(address[] calldata addresses, uint[] calldata uints, bytes calldata signature, bytes calldata proof, bytes32 root) external;

  function exit(bytes32 entryHash, bytes calldata proof, bytes32 root) external;

  function exitOnHalt(address[] calldata addresses, uint[] calldata uints, bytes calldata signature, bytes calldata proof, bytes32 root) external;
}

// File: contracts/custodian/Custodian.sol

contract Custodian is Stoppable, HasOwners, MerkleProof, Ledger, Depositing, Withdrawing, Versioned {

  address public constant ETH = address(0x0);
  uint public constant confirmationDelay = 5;
  uint public constant visibilityDelay = 3;
  uint public nonceGenerator = 0;

  address public operator;
  address public registry;

  constructor(address[] memory _owners, address _registry, address _operator, uint _submissionInterval, string memory _version)
    HasOwners(_owners)
    Versioned(_version)
    public validAddress(_registry) validAddress(_operator)
  {
    operator = _operator;
    registry = _registry;
    submissionInterval = _submissionInterval;
  }

  // note: can move to a library
  function transfer(uint quantity, address asset, address account) internal {
    asset == ETH ?
      require(address(uint160(account)).send(quantity), "failed to transfer ether") : // explicit casting to `address payable`
      require(Token(asset).transfer(account, quantity), "failed to transfer token");
  }

  /**
   * @dev Recover signer address from a message by using their signature
   * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
   * @param signature bytes generated using web3.eth.account.sign().signature
   *
   * Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
   * TODO: Remove this library once solidity supports passing a signature to ecrecover.
   * See https://github.com/ethereum/solidity/issues/864
   */
  // note: can move to a library
  // note: can use a deployed https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/cryptography/ECDSA.sol
  function recover(bytes32 hash, bytes memory signature) private pure returns (address) {
    bytes32 r; bytes32 s; uint8 v;
    if (signature.length != 65) return (address(0)); //Check the signature length

    // Divide the signature into r, s and v variables
    assembly {
      r := mload(add(signature, 32))
      s := mload(add(signature, 64))
      v := byte(0, mload(add(signature, 96)))
    }

    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
    if (v < 27) v += 27;

    // If the version is correct return the signer address
    return (v != 27 && v != 28) ? (address(0)) : ecrecover(hash, v, r, s);
  }

  function verifySignedBy(bytes32 hash, bytes memory signature, address signer) internal pure {
    require(recover(hash, signature) == signer, "failed to verify signature");
  }

  /**************************************************** Depositing ****************************************************/

  mapping (bytes32 => bool) public deposits;

  modifier validToken(address value) { require(value != ETH, "value must be a valid ERC20 token address"); _; }

  function () external payable { deposit(msg.sender, ETH, msg.value); }
  function depositEther() public payable { deposit(msg.sender, ETH, msg.value); }	//inject PUBLIC FUNC TO EXTERNAL

  // note: an account must call token.approve(custodian, quantity) beforehand
  function depositToken(address token, uint quantity) public validToken(token) {	//inject PUBLIC FUNC TO EXTERNAL
    uint balanceBefore = Token(token).balanceOf(address(this));
    require(Token(token).transferFrom(msg.sender, address(this), quantity), "failure to transfer quantity from token");
    uint balanceAfter = Token(token).balanceOf(address(this));
    require(balanceAfter - balanceBefore == quantity, "bad Token; transferFrom erroneously reported of successful transfer");
    deposit(msg.sender, token, quantity);
  }

  function deposit(address account, address asset, uint quantity) private whenOn {
    uint nonce = ++nonceGenerator;
    uint designatedGblock = currentGblockNumber + visibilityDelay;
    DepositCommitmentRecord memory record = toDepositCommitmentRecord(account, asset, quantity, nonce, designatedGblock);
    deposits[record.hash] = true;
    emit Deposited(address(this), account, asset, quantity, nonce, designatedGblock);
  }

  function reclaimDeposit(
    address[] calldata addresses,
    uint[] calldata uints,
    bytes32[] calldata leaves,
    uint[] calldata indexes,
    bytes calldata predecessor,
    bytes calldata successor
  ) external {
    ProofOfExclusionOfDeposit memory proof = extractProofOfExclusionOfDeposit(addresses, uints, leaves, indexes, predecessor, successor);
    DepositCommitmentRecord memory record = proof.excluded;
    require(record.account == msg.sender, "claimant must be the original depositor");
    require(currentGblockNumber > record.designatedGblock && record.designatedGblock != 0, "designated gblock is unconfirmed or unknown");

    Gblock memory designatedGblock = gblocksByNumber[record.designatedGblock];
    require(proveIsExcludedFromDeposits(designatedGblock.depositsRoot, proof), "failed to proof exclusion of deposit");

    _reclaimDeposit_(record);
  }

  function proveIsExcludedFromDeposits(bytes32 root, ProofOfExclusionOfDeposit memory proof) private pure returns (bool) {
    return
      proof.successor.index == proof.predecessor.index + 1 && // predecessor & successor must be consecutive
      verifyIncludedAtIndex(proof.predecessor.proof, root, proof.predecessor.leaf, proof.predecessor.index) &&
      verifyIncludedAtIndex(proof.successor.proof, root, proof.successor.leaf, proof.successor.index);
  }

  function reclaimDepositOnHalt(address asset, uint quantity, uint nonce, uint designatedGblock) public whenOff {	//inject PUBLIC FUNC TO EXTERNAL
    DepositCommitmentRecord memory record = toDepositCommitmentRecord(msg.sender, asset, quantity, nonce, designatedGblock);
    require(record.designatedGblock >= currentGblockNumber, "designated gblock is already confirmed; use exitOnHalt instead");
    _reclaimDeposit_(record);
  }

  function _reclaimDeposit_(DepositCommitmentRecord memory record) private {
    require(deposits[record.hash], "unknown deposit");
    delete deposits[record.hash];
    transfer(record.quantity, record.asset, record.account);
    emit DepositReclaimed(address(this), record.account, record.asset, record.quantity, record.nonce);
  }

  function extractProofOfExclusionOfDeposit(
    address[] memory addresses,
    uint[] memory uints,
    bytes32[] memory leaves,
    uint[] memory indexes,
    bytes memory predecessor,
    bytes memory successor
  ) private view returns (ProofOfExclusionOfDeposit memory result) {
    result.excluded = extractDepositCommitmentRecord(addresses, uints);
    result.predecessor = ProofOfInclusionAtIndex(leaves[0], indexes[0], predecessor);
    result.successor = ProofOfInclusionAtIndex(leaves[1], indexes[1], successor);
  }

  function extractDepositCommitmentRecord(address[] memory addresses, uint[] memory uints) private view returns (DepositCommitmentRecord memory) {
    return toDepositCommitmentRecord(
      addresses[1],
      addresses[2],
      uints[0],
      uints[1],
      uints[2]
    );
  }

  function toDepositCommitmentRecord(
    address account,
    address asset,
    uint quantity,
    uint nonce,
    uint designatedGblock
  ) private view returns (DepositCommitmentRecord memory result) {
    result.account = account;
    result.asset = asset;
    result.quantity = quantity;
    result.nonce = nonce;
    result.designatedGblock = designatedGblock;
    result.hash = keccak256(abi.encodePacked(
      address(this),
      account,
      asset,
      quantity,
      nonce,
      designatedGblock
    ));
  }

  event Deposited(address indexed custodian, address indexed account, address indexed asset, uint quantity, uint nonce, uint designatedGblock);
  event DepositReclaimed(address indexed custodian, address indexed account, address indexed asset, uint quantity, uint nonce);

  struct ProofOfInclusionAtIndex { bytes32 leaf; uint index; bytes proof; }
  struct ProofOfExclusionOfDeposit { DepositCommitmentRecord excluded; ProofOfInclusionAtIndex predecessor; ProofOfInclusionAtIndex successor; }

  /**************************************************** Withdrawing ***************************************************/

  mapping (bytes32 => bool) public withdrawn;
  mapping (bytes32 => ExitClaim) private exitClaims;
  mapping (address => mapping (address => bool)) public exited; // account => asset => did-exit

  function withdraw(
    address[] calldata addresses,
    uint[] calldata uints,
    bytes calldata signature,
    bytes calldata proof,
    bytes32 root
  ) external {
    Entry memory entry = extractEntry(addresses, uints);
    verifySignedBy(entry.hash, signature, operator);
    require(entry.account == msg.sender, "withdrawer must be entry's account");
    require(entry.entryType == EntryType.Withdrawal, "entry must be of type Withdrawal");
    require(proveInConfirmedWithdrawals(proof, root, entry.hash), "invalid entry proof");
    require(!withdrawn[entry.hash], "entry already withdrawn");
    withdrawn[entry.hash] = true;
    transfer(entry.quantity, entry.asset, entry.account);
    emit Withdrawn(entry.hash, entry.account, entry.asset, entry.quantity);
  }

  function claimExit(
    address[] calldata addresses,
    uint[] calldata uints,
    bytes calldata signature,
    bytes calldata proof,
    bytes32 root
  ) external whenOn {
    Entry memory entry = extractEntry(addresses, uints);
    verifySignedBy(entry.hash, signature, operator);
    require(entry.account == msg.sender, "claimant must be entry's account");
    require(!hasExited(entry.account, entry.asset), "previously exited");
    require(proveInConfirmedBalances(proof, root, entry.hash), "invalid balance proof");

    uint confirmationThreshold = currentGblockNumber + confirmationDelay;
    exitClaims[entry.hash] = ExitClaim(entry, confirmationThreshold);
    emit ExitClaimed(entry.hash, entry.account, entry.asset, entry.balance, entry.timestamp, confirmationThreshold);
  }

  function exit(bytes32 entryHash, bytes calldata proof, bytes32 root) external whenOn {
    ExitClaim memory claim = exitClaims[entryHash];
    require(canExit(entryHash), "no prior claim found to withdraw OR balances are yet to be confirmed");
    require(proveInUnconfirmedBalances(proof, root, entryHash), "invalid balance proof");
    delete exitClaims[entryHash];
    _exit_(claim.entry);
  }

  function exitOnHalt(
    address[] calldata addresses,
    uint[] calldata uints,
    bytes calldata signature,
    bytes calldata proof,
    bytes32 root
  ) external whenOff {
    Entry memory entry = extractEntry(addresses, uints);
    verifySignedBy(entry.hash, signature, operator);
    require(entry.account == msg.sender, "claimant must be entry's account");
    require(proveInConfirmedBalances(proof, root, entry.hash), "invalid balance proof");
    _exit_(entry);
  }

  function _exit_(Entry memory entry) private {
    require(!hasExited(entry.account, entry.asset), "previously exited");
    exited[entry.account][entry.asset] = true;
    transfer(entry.balance, entry.asset, entry.account);
    emit Exited(entry.account, entry.asset, entry.balance);
  }

  function hasExited(address account, address asset) public view returns (bool) { return exited[account][asset]; }

  function canExit(bytes32 entryHash) public view returns (bool) {
    return
      exitClaims[entryHash].confirmationThreshold != 0 &&  // exists
      currentGblockNumber >= exitClaims[entryHash].confirmationThreshold;
  }

  event ExitClaimed(bytes32 hash, address indexed account, address indexed asset, uint quantity, uint timestamp, uint confirmationThreshold);
  event Exited(address indexed account, address indexed asset, uint quantity);
  event Withdrawn(bytes32 hash, address indexed account, address indexed asset, uint quantity);

  struct ExitClaim { Entry entry; uint confirmationThreshold; }

  /**************************************************** FraudProof ****************************************************/

  uint public currentGblockNumber;
  mapping(uint => Gblock) public gblocksByNumber;
  mapping(bytes32 => uint) public gblocksByDepositsRoot;
  mapping(bytes32 => uint) public gblocksByWithdrawalsRoot;
  mapping(bytes32 => uint) public gblocksByBalancesRoot;
  uint public submissionInterval;
  uint public submissionBlock = block.number;

  function canSubmit() public view returns (bool) { return block.number >= submissionBlock; }

  function submit(uint gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot) public whenOn {	//inject PUBLIC FUNC TO EXTERNAL
    require(canSubmit(), "cannot submit yet");
    require(msg.sender == operator, "submitter must be the operator");
    require(gblockNumber == currentGblockNumber + 1, "gblock must be the next in sequence");
    Gblock memory gblock = Gblock(gblockNumber, withdrawalsRoot, depositsRoot, balancesRoot);
    gblocksByNumber[gblockNumber] = gblock;
    gblocksByDepositsRoot[depositsRoot] = gblockNumber;
    gblocksByWithdrawalsRoot[withdrawalsRoot] = gblockNumber;
    gblocksByBalancesRoot[balancesRoot] = gblockNumber;
    currentGblockNumber = gblockNumber;
    submissionBlock = block.number + submissionInterval;
    emit Submitted(gblockNumber, withdrawalsRoot, depositsRoot, balancesRoot);
  }

  function proveInConfirmedWithdrawals(bytes memory proof, bytes32 root, bytes32 entryHash) public view returns (bool) {
    return isConfirmedWithdrawals(root) && verifyIncluded(proof, root, entryHash);
  }

  function proveInConfirmedBalances(bytes memory proof, bytes32 root, bytes32 entryHash) public view returns (bool) {
    return
      root == gblocksByNumber[currentGblockNumber - 1 /* last-confirmed gblock */].balancesRoot &&
      verifyIncluded(proof, root, entryHash);
  }

  function proveInUnconfirmedBalances(bytes memory proof, bytes32 root, bytes32 entryHash) public view returns (bool) {
    return
      root == gblocksByNumber[currentGblockNumber /* unconfirmed gblock */].balancesRoot &&
      verifyIncluded(proof, root, entryHash);
  }

  function isConfirmedWithdrawals(bytes32 root) public view returns (bool) { return isConfirmedGblock(gblocksByWithdrawalsRoot[root]); }
  function isUnconfirmedWithdrawals(bytes32 root) public view returns (bool) { return gblocksByWithdrawalsRoot[root] == currentGblockNumber; }
  function includesWithdrawals(bytes32 root) public view returns (bool) { return gblocksByWithdrawalsRoot[root] != 0; }

  function isUnconfirmedBalances(bytes32 root) public view returns (bool) { return gblocksByBalancesRoot[root] == currentGblockNumber; }

  function isConfirmedGblock(uint number) public view returns (bool) { return 0 < number && number < currentGblockNumber; }

  event Submitted(uint gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot);

  struct Gblock { uint number; bytes32 withdrawalsRoot; bytes32 depositsRoot; bytes32 balancesRoot; }

  /********************************************************************************************************************/
}
