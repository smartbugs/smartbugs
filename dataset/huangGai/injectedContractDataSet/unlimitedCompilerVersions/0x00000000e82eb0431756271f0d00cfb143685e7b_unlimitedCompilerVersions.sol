pragma solidity ^0.5.6;	//inject UNLIMITED COMPILER VERSIONS


/**
 * @title Metamorphic Contract Factory
 * @author 0age
 * @notice This contract creates metamorphic contracts, or contracts that can be
 * redeployed with new code to the same address. It does so by deploying a
 * contract with fixed, non-deterministic initialization code via the CREATE2
 * opcode. This contract clones the implementation contract in its constructor.
 * Once a contract undergoes metamorphosis, all existing storage will be deleted
 * and any existing contract code will be replaced with the deployed contract
 * code of the new implementation contract.
 * @dev CREATE2 will not be available on mainnet until (at least) block
 * 7,280,000. This contract has not yet been fully tested or audited - proceed
 * with caution and please share any exploits or optimizations you discover.
 */
contract MetamorphicContractFactory {
  // fires when a metamorphic contract is deployed by cloning another contract.
  event Metamorphosed(address metamorphicContract, address newImplementation);
  
  // fires when a metamorphic contract is deployed through a transient contract.
  event MetamorphosedWithConstructor(
    address metamorphicContract,
    address transientContract
  );

  // store the initialization code for metamorphic contracts.
  bytes private _metamorphicContractInitializationCode;

  // store hash of the initialization code for metamorphic contracts as well.
  bytes32 private _metamorphicContractInitializationCodeHash;

  // store init code for transient contracts that deploy metamorphic contracts.
  bytes private _transientContractInitializationCode;

  // store the hash of the initialization code for transient contracts as well.
  bytes32 private _transientContractInitializationCodeHash;

  // maintain a mapping of metamorphic contracts to metamorphic implementations.
  mapping(address => address) private _implementations;

  // maintain a mapping of transient contracts to metamorphic init codes.
  mapping(address => bytes) private _initCodes;

  /**
   * @dev In the constructor, set up the initialization code for metamorphic
   * contracts as well as the keccak256 hash of the given initialization code.
   * @param transientContractInitializationCode bytes The initialization code
   * that will be used to deploy any transient contracts, which will deploy any
   * metamorphic contracts that require the use of a constructor.
   * 
   * Metamorphic contract initialization code (29 bytes): 
   *
   *       0x5860208158601c335a63aaf10f428752fa158151803b80938091923cf3
   *
   * Description:
   *
   * pc|op|name         | [stack]                                | <memory>
   *
   * ** set the first stack item to zero - used later **
   * 00 58 getpc          [0]                                       <>
   *
   * ** set second stack item to 32, length of word returned from staticcall **
   * 01 60 push1
   * 02 20 outsize        [0, 32]                                   <>
   *
   * ** set third stack item to 0, position of word returned from staticcall **
   * 03 81 dup2           [0, 32, 0]                                <>
   *
   * ** set fourth stack item to 4, length of selector given to staticcall **
   * 04 58 getpc          [0, 32, 0, 4]                             <>
   *
   * ** set fifth stack item to 28, position of selector given to staticcall **
   * 05 60 push1
   * 06 1c inpos          [0, 32, 0, 4, 28]                         <>
   *
   * ** set the sixth stack item to msg.sender, target address for staticcall **
   * 07 33 caller         [0, 32, 0, 4, 28, caller]                 <>
   *
   * ** set the seventh stack item to msg.gas, gas to forward for staticcall **
   * 08 5a gas            [0, 32, 0, 4, 28, caller, gas]            <>
   *
   * ** set the eighth stack item to selector, "what" to store via mstore **
   * 09 63 push4
   * 10 aaf10f42 selector [0, 32, 0, 4, 28, caller, gas, 0xaaf10f42]    <>
   *
   * ** set the ninth stack item to 0, "where" to store via mstore ***
   * 11 87 dup8           [0, 32, 0, 4, 28, caller, gas, 0xaaf10f42, 0] <>
   *
   * ** call mstore, consume 8 and 9 from the stack, place selector in memory **
   * 12 52 mstore         [0, 32, 0, 4, 0, caller, gas]             <0xaaf10f42>
   *
   * ** call staticcall, consume items 2 through 7, place address in memory **
   * 13 fa staticcall     [0, 1 (if successful)]                    <address>
   *
   * ** flip success bit in second stack item to set to 0 **
   * 14 15 iszero         [0, 0]                                    <address>
   *
   * ** push a third 0 to the stack, position of address in memory **
   * 15 81 dup2           [0, 0, 0]                                 <address>
   *
   * ** place address from position in memory onto third stack item **
   * 16 51 mload          [0, 0, address]                           <>
   *
   * ** place address to fourth stack item for extcodesize to consume **
   * 17 80 dup1           [0, 0, address, address]                  <>
   *
   * ** get extcodesize on fourth stack item for extcodecopy **
   * 18 3b extcodesize    [0, 0, address, size]                     <>
   *
   * ** dup and swap size for use by return at end of init code **
   * 19 80 dup1           [0, 0, address, size, size]               <> 
   * 20 93 swap4          [size, 0, address, size, 0]               <>
   *
   * ** push code position 0 to stack and reorder stack items for extcodecopy **
   * 21 80 dup1           [size, 0, address, size, 0, 0]            <>
   * 22 91 swap2          [size, 0, address, 0, 0, size]            <>
   * 23 92 swap3          [size, 0, size, 0, 0, address]            <>
   *
   * ** call extcodecopy, consume four items, clone runtime code to memory **
   * 24 3c extcodecopy    [size, 0]                                 <code>
   *
   * ** return to deploy final code in memory **
   * 25 f3 return         []                                        *deployed!*
   *
   *
   * Transient contract initialization code derived from TransientContract.sol.
   */
  constructor(bytes memory transientContractInitializationCode) public {
    // assign the initialization code for the metamorphic contract.
    _metamorphicContractInitializationCode = (
      hex"5860208158601c335a63aaf10f428752fa158151803b80938091923cf3"
    );

    // calculate and assign keccak256 hash of metamorphic initialization code.
    _metamorphicContractInitializationCodeHash = keccak256(
      abi.encodePacked(
        _metamorphicContractInitializationCode
      )
    );

    // store the initialization code for the transient contract.
    _transientContractInitializationCode = transientContractInitializationCode;

    // calculate and assign keccak256 hash of transient initialization code.
    _transientContractInitializationCodeHash = keccak256(
      abi.encodePacked(
        _transientContractInitializationCode
      )
    );
  }

  /* solhint-disable function-max-lines */
  /**
   * @dev Deploy a metamorphic contract by submitting a given salt or nonce
   * along with the initialization code for the metamorphic contract, and
   * optionally provide calldata for initializing the new metamorphic contract.
   * To replace the contract, first selfdestruct the current contract, then call
   * with the same salt value and new initialization code (be aware that all
   * existing state will be wiped from the existing contract). Also note that
   * the first 20 bytes of the salt must match the calling address, which
   * prevents contracts from being created by unintended parties.
   * @param salt bytes32 The nonce that will be passed into the CREATE2 call and
   * thus will determine the resulant address of the metamorphic contract.
   * @param implementationContractInitializationCode bytes The initialization
   * code for the implementation contract for the metamorphic contract. It will
   * be used to deploy a new contract that the metamorphic contract will then
   * clone in its constructor.
   * @param metamorphicContractInitializationCalldata bytes An optional data
   * parameter that can be used to atomically initialize the metamorphic
   * contract.
   * @return Address of the metamorphic contract that will be created.
   */
  function deployMetamorphicContract(
    bytes32 salt,
    bytes calldata implementationContractInitializationCode,
    bytes calldata metamorphicContractInitializationCalldata
  ) external payable containsCaller(salt) returns (
    address metamorphicContractAddress
  ) {
    // move implementation init code and initialization calldata to memory.
    bytes memory implInitCode = implementationContractInitializationCode;
    bytes memory data = metamorphicContractInitializationCalldata;

    // move the initialization code from storage to memory.
    bytes memory initCode = _metamorphicContractInitializationCode;

    // declare variable to verify successful metamorphic contract deployment.
    address deployedMetamorphicContract;

    // determine the address of the metamorphic contract.
    metamorphicContractAddress = _getMetamorphicContractAddress(salt);

    // declare a variable for the address of the implementation contract.
    address implementationContract;

    // load implementation init code and length, then deploy via CREATE.
    /* solhint-disable no-inline-assembly */
    assembly {
      let encoded_data := add(0x20, implInitCode) // load initialization code.
      let encoded_size := mload(implInitCode)     // load init code's length.
      implementationContract := create(       // call CREATE with 3 arguments.
        0,                                    // do not forward any endowment.
        encoded_data,                         // pass in initialization code.
        encoded_size                          // pass in init code's length.
      )
    } /* solhint-enable no-inline-assembly */

    require(
      implementationContract != address(0),
      "Could not deploy implementation."
    );

    // store the implementation to be retrieved by the metamorphic contract.
    _implementations[metamorphicContractAddress] = implementationContract;

    // load metamorphic contract data and length of data and deploy via CREATE2.
    /* solhint-disable no-inline-assembly */
    assembly {
      let encoded_data := add(0x20, initCode) // load initialization code.
      let encoded_size := mload(initCode)     // load the init code's length.
      deployedMetamorphicContract := create2( // call CREATE2 with 4 arguments.
        0,                                    // do not forward any endowment.
        encoded_data,                         // pass in initialization code.
        encoded_size,                         // pass in init code's length.
        salt                                  // pass in the salt value.
      )
    } /* solhint-enable no-inline-assembly */

    // ensure that the contracts were successfully deployed.
    require(
      deployedMetamorphicContract == metamorphicContractAddress,
      "Failed to deploy the new metamorphic contract."
    );

    // initialize the new metamorphic contract if any data or value is provided.
    if (data.length > 0 || msg.value > 0) {
      /* solhint-disable avoid-call-value */
      (bool success,) = deployedMetamorphicContract.call.value(msg.value)(data);
      /* solhint-enable avoid-call-value */

      require(success, "Failed to initialize the new metamorphic contract.");
    }

    emit Metamorphosed(deployedMetamorphicContract, implementationContract);
  } /* solhint-enable function-max-lines */

  /**
   * @dev Deploy a metamorphic contract by submitting a given salt or nonce
   * along with the address of an existing implementation contract to clone, and
   * optionally provide calldata for initializing the new metamorphic contract.
   * To replace the contract, first selfdestruct the current contract, then call
   * with the same salt value and a new implementation address (be aware that
   * all existing state will be wiped from the existing contract). Also note
   * that the first 20 bytes of the salt must match the calling address, which
   * prevents contracts from being created by unintended parties.
   * @param salt bytes32 The nonce that will be passed into the CREATE2 call and
   * thus will determine the resulant address of the metamorphic contract.
   * @param implementationContract address The address of the existing
   * implementation contract to clone.
   * @param metamorphicContractInitializationCalldata bytes An optional data
   * parameter that can be used to atomically initialize the metamorphic
   * contract.
   * @return Address of the metamorphic contract that will be created.
   */
  function deployMetamorphicContractFromExistingImplementation(
    bytes32 salt,
    address implementationContract,
    bytes calldata metamorphicContractInitializationCalldata
  ) external payable containsCaller(salt) returns (
    address metamorphicContractAddress
  ) {
    // move initialization calldata to memory.
    bytes memory data = metamorphicContractInitializationCalldata;

    // move the initialization code from storage to memory.
    bytes memory initCode = _metamorphicContractInitializationCode;

    // declare variable to verify successful metamorphic contract deployment.
    address deployedMetamorphicContract;

    // determine the address of the metamorphic contract.
    metamorphicContractAddress = _getMetamorphicContractAddress(salt);

    // store the implementation to be retrieved by the metamorphic contract.
    _implementations[metamorphicContractAddress] = implementationContract;

    // using inline assembly: load data and length of data, then call CREATE2.
    /* solhint-disable no-inline-assembly */
    assembly {
      let encoded_data := add(0x20, initCode) // load initialization code.
      let encoded_size := mload(initCode)     // load the init code's length.
      deployedMetamorphicContract := create2( // call CREATE2 with 4 arguments.
        0,                                    // do not forward any endowment.
        encoded_data,                         // pass in initialization code.
        encoded_size,                         // pass in init code's length.
        salt                                  // pass in the salt value.
      )
    } /* solhint-enable no-inline-assembly */

    // ensure that the contracts were successfully deployed.
    require(
      deployedMetamorphicContract == metamorphicContractAddress,
      "Failed to deploy the new metamorphic contract."
    );

    // initialize the new metamorphic contract if any data or value is provided.
    if (data.length > 0 || msg.value > 0) {
      /* solhint-disable avoid-call-value */
      (bool success,) = metamorphicContractAddress.call.value(msg.value)(data);
      /* solhint-enable avoid-call-value */

      require(success, "Failed to initialize the new metamorphic contract.");
    }

    emit Metamorphosed(deployedMetamorphicContract, implementationContract);
  }

  /* solhint-disable function-max-lines */
  /**
   * @dev Deploy a metamorphic contract by submitting a given salt or nonce
   * along with the initialization code to a transient contract which will then
   * deploy the metamorphic contract before immediately selfdestructing. To
   * replace the metamorphic contract, first selfdestruct the current contract,
   * then call with the same salt value and new initialization code (be aware
   * that all existing state will be wiped from the existing contract). Also
   * note that the first 20 bytes of the salt must match the calling address,
   * which prevents contracts from being created by unintended parties.
   * @param salt bytes32 The nonce that will be passed into the CREATE2 call and
   * thus will determine the resulant address of the metamorphic contract.
   * @param initializationCode bytes The initialization code for the metamorphic
   * contract that will be deployed by the transient contract.
   * @return Address of the metamorphic contract that will be created.
   */
  function deployMetamorphicContractWithConstructor(
    bytes32 salt,
    bytes calldata initializationCode
  ) external payable containsCaller(salt) returns (
    address metamorphicContractAddress
  ) {
    // move transient contract initialization code from storage to memory.
    bytes memory initCode = _transientContractInitializationCode;

    // declare variable to verify successful transient contract deployment.
    address deployedTransientContract;

    // determine the address of the transient contract.
    address transientContractAddress = _getTransientContractAddress(salt);

    // store the initialization code to be retrieved by the transient contract.
    _initCodes[transientContractAddress] = initializationCode;

    // load transient contract data and length of data, then deploy via CREATE2.
    /* solhint-disable no-inline-assembly */
    assembly {
      let encoded_data := add(0x20, initCode) // load initialization code.
      let encoded_size := mload(initCode)     // load the init code's length.
      deployedTransientContract := create2(   // call CREATE2 with 4 arguments.
        callvalue,                            // forward any supplied endowment.
        encoded_data,                         // pass in initialization code.
        encoded_size,                         // pass in init code's length.
        salt                                  // pass in the salt value.
      )
    } /* solhint-enable no-inline-assembly */

    // ensure that the contracts were successfully deployed.
    require(
      deployedTransientContract == transientContractAddress,
      "Failed to deploy metamorphic contract using given salt and init code."
    );

    metamorphicContractAddress = _getMetamorphicContractAddressWithConstructor(
      transientContractAddress
    );

    emit MetamorphosedWithConstructor(
      metamorphicContractAddress,
      transientContractAddress
    );
  } /* solhint-enable function-max-lines */

  /**
   * @dev View function for retrieving the address of the implementation
   * contract to clone. Called by the constructor of each metamorphic contract.
   */
  function getImplementation() external view returns (address implementation) {
    return _implementations[msg.sender];
  }

  /**
   * @dev View function for retrieving the initialization code for a given
   * metamorphic contract to deploy via a transient contract. Called by the
   * constructor of each transient contract.
   * @return The initialization code to use to deploy the metamorphic contract.
   */
  function getInitializationCode() external view returns (
    bytes memory initializationCode
  ) {
    return _initCodes[msg.sender];
  }

  /**
   * @dev View function for retrieving the address of the current implementation
   * contract of a given metamorphic contract, where the address of the contract
   * is supplied as an argument. Be aware that the implementation contract has
   * an independent state and may have been altered or selfdestructed from when
   * it was last cloned by the metamorphic contract.
   * @param metamorphicContractAddress address The address of the metamorphic
   * contract.
   * @return Address of the corresponding implementation contract.
   */
  function getImplementationContractAddress(
    address metamorphicContractAddress
  ) external view returns (address implementationContractAddress) {
    return _implementations[metamorphicContractAddress];
  }

  /**
   * @dev View function for retrieving the initialization code for a given
   * metamorphic contract instance deployed via a transient contract, where the address
   * of the transient contract is supplied as an argument.
   * @param transientContractAddress address The address of the transient
   * contract that deployed the metamorphic contract.
   * @return The initialization code used to deploy the metamorphic contract.
   */
  function getMetamorphicContractInstanceInitializationCode(
    address transientContractAddress
  ) external view returns (bytes memory initializationCode) {
    return _initCodes[transientContractAddress];
  }

  /**
   * @dev Compute the address of the metamorphic contract that will be created
   * upon submitting a given salt to the contract.
   * @param salt bytes32 The nonce passed into CREATE2 by metamorphic contract.
   * @return Address of the corresponding metamorphic contract.
   */
  function findMetamorphicContractAddress(
    bytes32 salt
  ) external view returns (address metamorphicContractAddress) {
    // determine the address where the metamorphic contract will be deployed.
    metamorphicContractAddress = _getMetamorphicContractAddress(salt);
  }

  /**
   * @dev Compute the address of the transient contract that will be created
   * upon submitting a given salt to the contract.
   * @param salt bytes32 The nonce passed into CREATE2 when deploying the
   * transient contract.
   * @return Address of the corresponding transient contract.
   */
  function findTransientContractAddress(
    bytes32 salt
  ) external view returns (address transientContractAddress) {
    // determine the address where the transient contract will be deployed.
    transientContractAddress = _getTransientContractAddress(salt);
  }

  /**
   * @dev Compute the address of the metamorphic contract that will be created
   * by the transient contract upon submitting a given salt to the contract.
   * @param salt bytes32 The nonce passed into CREATE2 when deploying the
   * transient contract.
   * @return Address of the corresponding metamorphic contract.
   */
  function findMetamorphicContractAddressWithConstructor(
    bytes32 salt
  ) external view returns (address metamorphicContractAddress) {
    // determine the address of the metamorphic contract.
    metamorphicContractAddress = _getMetamorphicContractAddressWithConstructor(
      _getTransientContractAddress(salt)
    );
  }

  /**
   * @dev View function for retrieving the initialization code of metamorphic
   * contracts for purposes of verification.
   */
  function getMetamorphicContractInitializationCode() external view returns (
    bytes memory metamorphicContractInitializationCode
  ) {
    return _metamorphicContractInitializationCode;
  }

  /**
   * @dev View function for retrieving the keccak256 hash of the initialization
   * code of metamorphic contracts for purposes of verification.
   */
  function getMetamorphicContractInitializationCodeHash() external view returns (
    bytes32 metamorphicContractInitializationCodeHash
  ) {
    return _metamorphicContractInitializationCodeHash;
  }

  /**
   * @dev View function for retrieving the initialization code of transient
   * contracts for purposes of verification.
   */
  function getTransientContractInitializationCode() external view returns (
    bytes memory transientContractInitializationCode
  ) {
    return _transientContractInitializationCode;
  }

  /**
   * @dev View function for retrieving the keccak256 hash of the initialization
   * code of transient contracts for purposes of verification.
   */
  function getTransientContractInitializationCodeHash() external view returns (
    bytes32 transientContractInitializationCodeHash
  ) {
    return _transientContractInitializationCodeHash;
  }

  /**
   * @dev Internal view function for calculating a metamorphic contract address
   * given a particular salt.
   */
  function _getMetamorphicContractAddress(
    bytes32 salt
  ) internal view returns (address) {
    // determine the address of the metamorphic contract.
    return address(
      uint160(                      // downcast to match the address type.
        uint256(                    // convert to uint to truncate upper digits.
          keccak256(                // compute the CREATE2 hash using 4 inputs.
            abi.encodePacked(       // pack all inputs to the hash together.
              hex"ff",              // start with 0xff to distinguish from RLP.
              address(this),        // this contract will be the caller.
              salt,                 // pass in the supplied salt value.
              _metamorphicContractInitializationCodeHash // the init code hash.
            )
          )
        )
      )
    );
  }

  /**
   * @dev Internal view function for calculating a transient contract address
   * given a particular salt.
   */
  function _getTransientContractAddress(
    bytes32 salt
  ) internal view returns (address) {
    // determine the address of the transient contract.
    return address(
      uint160(                      // downcast to match the address type.
        uint256(                    // convert to uint to truncate upper digits.
          keccak256(                // compute the CREATE2 hash using 4 inputs.
            abi.encodePacked(       // pack all inputs to the hash together.
              hex"ff",              // start with 0xff to distinguish from RLP.
              address(this),        // this contract will be the caller.
              salt,                 // pass in the supplied salt value.
              _transientContractInitializationCodeHash // supply init code hash.
            )
          )
        )
      )
    );
  }

  /**
   * @dev Internal view function for calculating a metamorphic contract address
   * that has been deployed via a transient contract given the address of the
   * transient contract.
   */
  function _getMetamorphicContractAddressWithConstructor(
    address transientContractAddress
  ) internal pure returns (address) { 
    // determine the address of the metamorphic contract.
    return address(
      uint160(                          // downcast to match the address type.
        uint256(                        // set to uint to truncate upper digits.
          keccak256(                    // compute CREATE hash via RLP encoding.
            abi.encodePacked(           // pack all inputs to the hash together.
              byte(0xd6),               // first RLP byte.
              byte(0x94),               // second RLP byte.
              transientContractAddress, // called by the transient contract.
              byte(0x01)                // nonce begins at 1 for contracts.
            )
          )
        )
      )
    );
  }

  /**
   * @dev Modifier to ensure that the first 20 bytes of a submitted salt match
   * those of the calling account. This provides protection against the salt
   * being stolen by frontrunners or other attackers.
   * @param salt bytes32 The salt value to check against the calling address.
   */
  modifier containsCaller(bytes32 salt) {
    // prevent contract submissions from being stolen from tx.pool by requiring
    // that the first 20 bytes of the submitted salt match msg.sender.
    require(
      address(bytes20(salt)) == msg.sender,
      "Invalid salt - first 20 bytes of the salt must match calling address."
    );
    _;
  }
}