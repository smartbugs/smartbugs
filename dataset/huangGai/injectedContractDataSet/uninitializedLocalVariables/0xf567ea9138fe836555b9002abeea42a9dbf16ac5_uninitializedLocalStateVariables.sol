/**
 *Submitted for verification at Etherscan.io on 2020-01-15
*/

pragma solidity >=0.5.0 <0.6.0;
pragma experimental ABIEncoderV2;

contract HashTimeLock {
  mapping(bytes32 => LockContract) public contracts;

  enum SwapStatus { INVALID, ACTIVE, REFUNDED, WITHDRAWN, EXPIRED }

  struct LockContract {
    uint256 inputAmount;
    uint256 outputAmount;
    uint256 expiration;
    bytes32 hashLock;
    SwapStatus status;
    address payable sender;
    address payable receiver;
    string outputNetwork;
    string outputAddress;
  }

  event Withdraw(
    bytes32 indexed id,
    bytes32 secret,
    bytes32 hashLock,
    address indexed sender,
    address indexed receiver
  );

  event Refund(
    bytes32 indexed id,
    bytes32 hashLock,
    address indexed sender,
    address indexed receiver
  );

  event NewContract(
    uint256 inputAmount,
    uint256 outputAmount,
    uint256 expiration,
    bytes32 indexed id,
    bytes32 hashLock,
    address indexed sender,
    address indexed receiver,
    string outputNetwork,
    string outputAddress
  );

  modifier withdrawable(bytes32 id, bytes32 secret) {
    LockContract memory tempContract = contracts[id];
    require(tempContract.status == SwapStatus.ACTIVE, 'SWAP_NOT_ACTIVE');
    require(tempContract.expiration > block.timestamp, 'INVALID_TIME');
    require(
      tempContract.hashLock == sha256(abi.encodePacked(secret)),
      'INVALID_SECRET'
    );
    _;
  }

  modifier refundable(bytes32 id) {
    LockContract memory tempContract = contracts[id];
    require(tempContract.status == SwapStatus.ACTIVE, 'SWAP_NOT_ACTIVE');
    require(tempContract.expiration <= block.timestamp, 'INVALID_TIME');
    require(tempContract.sender == msg.sender, 'INVALID_SENDER');
    _;
  }

  function newContract(
    uint256 outputAmount,
    uint256 expiration,
    bytes32 hashLock,
    address payable receiver,
    string memory outputNetwork,
    string memory outputAddress
  ) public payable {
    address payable sender ;	//inject UNINIT LOCAL/STATE VAR

    uint256 inputAmount ;	//inject UNINIT LOCAL/STATE VAR


    require(expiration > block.timestamp, 'INVALID_TIME');

    require(inputAmount > 0, 'INVALID_AMOUNT');

    bytes32 id ;	//inject UNINIT LOCAL/STATE VAR


    contracts[id] = LockContract(
      inputAmount,
      outputAmount,
      expiration,
      hashLock,
      SwapStatus.ACTIVE,
      sender,
      receiver,
      outputNetwork,
      outputAddress
    );

    emit NewContract(
      inputAmount,
      outputAmount,
      expiration,
      id,
      hashLock,
      sender,
      receiver,
      outputNetwork,
      outputAddress
    );
  }

  function withdraw(bytes32 id, bytes32 secret)
    public
    withdrawable(id, secret)
    returns (bool)
  {
    LockContract storage c = contracts[id];
    c.status = SwapStatus.WITHDRAWN;
    c.receiver.transfer(c.inputAmount);
    emit Withdraw(id, secret, c.hashLock, c.sender, c.receiver);
    return true;
  }

  function refund(bytes32 id) external refundable(id) returns (bool) {
    LockContract storage c = contracts[id];
    c.status = SwapStatus.REFUNDED;
    c.sender.transfer(c.inputAmount);
    emit Refund(id, c.hashLock, c.sender, c.receiver);
    return true;
  }

  function getContract(bytes32 id) public view returns (LockContract memory) {
    LockContract memory c = contracts[id];
    return c;
  }

  function contractExists(bytes32 id) public view returns (bool) {
    return contracts[id].status != SwapStatus.INVALID;
  }

  function getStatus(bytes32[] memory ids)
    public
    view
    returns (uint8[] memory)
  {
    uint8[] memory result = new uint8[](ids.length);

    for (uint256 index ; index < ids.length; index++) {	//inject UNINIT LOCAL/STATE VAR

      result[index] = getStatus(ids[index]);
    }

    return result;
  }

  function getStatus(bytes32 id) public view returns (uint8 result) {
    LockContract memory tempContract = contracts[id];

    if (
      tempContract.status == SwapStatus.ACTIVE &&
      tempContract.expiration < block.timestamp
    ) {
      result = uint8(SwapStatus.EXPIRED);
    } else {
      result = uint8(tempContract.status);
    }
  }
}