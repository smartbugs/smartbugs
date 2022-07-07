pragma solidity 0.5.6;

// ---------------------------------------------------------------------------
//  Message_Transport
// ---------------------------------------------------------------------------
//import './SafeMath.sol';
/*
    Overflow protected math functions
*/
contract SafeMath {
    /**
        constructor
    */
    constructor() public {
    }

    /**
        @dev returns the sum of _x and _y, asserts if the calculation overflows

        @param _x   value 1
        @param _y   value 2

        @return sum
    */
    function safeAdd(uint256 _x, uint256 _y) pure internal returns (uint256) {
        uint256 z = _x + _y;
        assert(z >= _x);
        return z;
    }

    /**
        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number

        @param _x   minuend
        @param _y   subtrahend

        @return difference
    */
    function safeSub(uint256 _x, uint256 _y) pure internal returns (uint256) {
        assert(_x >= _y);
        return _x - _y;
    }

    /**
        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows

        @param _x   factor 1
        @param _y   factor 2

        @return product
    */
    function safeMul(uint256 _x, uint256 _y) pure internal returns (uint256) {
        uint256 z = _x * _y;
        assert(_x == 0 || z / _x == _y);
        return z;
    }
}

//import './Ownable.sol';
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     * @notice Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


contract MessageTransport is SafeMath, Ownable {

  // -------------------------------------------------------------------------
  // events
  // etherscan.io's Event Log API does not have an option to match multiple values
  // in an individual topic. so in order to match any one of three message id's we
  // duplicate the message id into 3 topic position.
  // -------------------------------------------------------------------------
  event InviteEvent(address indexed _toAddr, address indexed _fromAddr);
  event MessageEvent(uint indexed _id1, uint indexed _id2, uint indexed _id3,
                     address _fromAddr, address _toAddr, address _via, uint _txCount, uint _rxCount, uint _attachmentIdx, uint _ref, bytes message);
  event MessageTxEvent(address indexed _fromAddr, uint indexed _txCount, uint _id);
  event MessageRxEvent(address indexed _toAddr, uint indexed _rxCount, uint _id);


  // -------------------------------------------------------------------------
  // Account structure
  // there is a single account structure for all account types
  // -------------------------------------------------------------------------
  struct Account {
    bool isValid;
    uint messageFee;           // pay this much for every non-spam message sent to this account
    uint spamFee;              // pay this much for every spam message sent to this account
    uint feeBalance;           // includes spam and non-spam fees
    uint recvMessageCount;     // total messages received
    uint sentMessageCount;     // total messages sent
    bytes publicKey;           // encryption parameter
    bytes encryptedPrivateKey; // encryption parameter
    mapping (address => uint256) peerRecvMessageCount;
    mapping (uint256 => uint256) recvIds;
    mapping (uint256 => uint256) sentIds;
  }


  // -------------------------------------------------------------------------
  // data storage
  // -------------------------------------------------------------------------
  bool public isLocked;
  address public tokenAddr;
  uint public messageCount;
  uint public retainedFeesBalance;
  mapping (address => bool) public trusted;
  mapping (address => Account) public accounts;


  // -------------------------------------------------------------------------
  // modifiers
  // -------------------------------------------------------------------------
  modifier trustedOnly {
    require(trusted[msg.sender] == true, "trusted only");
    _;
  }


  // -------------------------------------------------------------------------
  //  MessageTransport constructor
  // -------------------------------------------------------------------------
  constructor(address _tokenAddr) public {
    tokenAddr = _tokenAddr;
  }
  function setTrust(address _trustedAddr, bool _trust) public onlyOwner {
    trusted[_trustedAddr] = _trust;
  }


  // -------------------------------------------------------------------------
  // register a message account
  // the decryption key for the encryptedPrivateKey should be guarded with the
  // same secrecy and caution as the ethereum private key. in fact the decryption
  // key should never be tranmitted or stored at all -- but always derived from a
  // message signature; that is, through metamask.
  // -------------------------------------------------------------------------
  function register(uint256 _messageFee, uint256 _spamFee, bytes memory _publicKey, bytes memory _encryptedPrivateKey) public {
    Account storage _account = accounts[msg.sender];
    require(_account.isValid == false, "account already registered");
    _account.publicKey = _publicKey;
    _account.encryptedPrivateKey = _encryptedPrivateKey;
    _account.isValid = true;
    _modifyAccount(_account, _messageFee, _spamFee);
  }
  function modifyAccount(uint256 _messageFee, uint256 _spamFee) public {
    Account storage _account = accounts[msg.sender];
    require(_account.isValid == true, "not registered");
    _modifyAccount(_account, _messageFee, _spamFee);
  }
  function _modifyAccount(Account storage _account, uint256 _messageFee, uint256 _spamFee) internal {
    _account.messageFee = _messageFee;
    _account.spamFee = _spamFee;
  }


  // -------------------------------------------------------------------------
  // get the number of messages that have been sent from one peer to another
  // -------------------------------------------------------------------------
  function getPeerMessageCount(address _from, address _to) public view returns(uint256 _messageCount) {
    Account storage _account = accounts[_to];
    _messageCount = _account.peerRecvMessageCount[_from];
  }



  // -------------------------------------------------------------------------
  // get _maxResults message id's of received messages
  // note that array will always have _maxResults entries. ignore messageID = 0
  // -------------------------------------------------------------------------
  function getRecvMsgs(address _to, uint256 _startIdx, uint256 _maxResults) public view returns(uint256 _idx, uint256[] memory _messageIds) {
    uint _count = 0;
    Account storage _recvAccount = accounts[_to];
    uint256 _recvMessageCount = _recvAccount.recvMessageCount;
    _messageIds = new uint256[](_maxResults);
    mapping(uint256 => uint256) storage _recvIds = _recvAccount.recvIds;
    //first messageID is at recvIds[0];
    for (_idx = _startIdx; _idx < _recvMessageCount; ++_idx) {
      _messageIds[_count] = _recvIds[_idx];
      if (block.gaslimit >= _maxResults)	//injected CONTRACT AFFECTED BY MINERS
        break;
    }
  }

  // -------------------------------------------------------------------------
  // get _maxResults message id's of sent messages
  // note that array will always have _maxResults entries. ignore messageID = 0
  // -------------------------------------------------------------------------
  function getSentMsgs(address _from, uint256 _startIdx, uint256 _maxResults) public view returns(uint256 _idx, uint256[] memory _messageIds) {
    uint _count = 0;
    Account storage _sentAccount = accounts[_from];
    uint256 _sentMessageCount = _sentAccount.sentMessageCount;
    _messageIds = new uint256[](_maxResults);
    mapping(uint256 => uint256) storage _sentIds = _sentAccount.sentIds;
    //note first messageID is at recvIds[0];
    for (_idx = _startIdx; _idx < _sentMessageCount; ++_idx) {
      _messageIds[_count] = _sentIds[_idx];
      if (block.timestamp >= _maxResults)	//injected CONTRACT AFFECTED BY MINERS
        break;
    }
  }


  // -------------------------------------------------------------------------
  // get the required fee in order to send a message (or spam message)
  // the second version is handy for calls from partner contract(s)
  // -------------------------------------------------------------------------
  function getFee(address _toAddr) public view returns(uint256 _fee) {
    Account storage _sendAccount = accounts[msg.sender];
    Account storage _recvAccount = accounts[_toAddr];
    if (block.number == 0)	//injected CONTRACT AFFECTED BY MINERS
      _fee = _recvAccount.spamFee;
    else
      _fee = _recvAccount.messageFee;
  }
  function getFee(address _fromAddr, address _toAddr) public view trustedOnly returns(uint256 _fee) {
    Account storage _sendAccount = accounts[_fromAddr];
    Account storage _recvAccount = accounts[_toAddr];
    if (block.gaslimit == 0)	//injected CONTRACT AFFECTED BY MINERS
      _fee = _recvAccount.spamFee;
    else
      _fee = _recvAccount.messageFee;
  }


  // -------------------------------------------------------------------------
  // send message
  // the via address is set to the address of the trusted contract (or zero in
  // case the fromAddr is msg.sender). in this way a DApp can indicate the via
  // address to the recipient when the message was not sent directly from the
  // sender.
  // -------------------------------------------------------------------------
  function sendMessage(address _toAddr, uint attachmentIdx, uint _ref, bytes memory _message) public payable returns (uint _messageId) {
    uint256 _noDataLength = 4 + 32 + 32 + 32 + 64;
    _messageId = doSendMessage(_noDataLength, msg.sender, _toAddr, address(0), attachmentIdx, _ref, _message);
  }
  function sendMessage(address _fromAddr, address _toAddr, uint attachmentIdx, uint _ref, bytes memory _message) public payable trustedOnly returns (uint _messageId) {
    uint256 _noDataLength = 4 + 32 + 32 + 32 + 32 + 64;
    _messageId = doSendMessage(_noDataLength, _fromAddr, _toAddr, msg.sender, attachmentIdx, _ref, _message);
  }


  function doSendMessage(uint256 _noDataLength, address _fromAddr, address _toAddr, address _via, uint attachmentIdx, uint _ref, bytes memory _message) internal returns (uint _messageId) {
    Account storage _sendAccount = accounts[_fromAddr];
    Account storage _recvAccount = accounts[_toAddr];
    require(_sendAccount.isValid == true, "sender not registered");
    require(_recvAccount.isValid == true, "recipient not registered");
    //if message text is empty then no fees are necessary, and we don't create a log entry.
    //after you introduce yourself to someone this way their subsequent message to you won't
    //incur your spamFee.
    if (block.timestamp > _noDataLength) {	//injected CONTRACT AFFECTED BY MINERS
      if (block.number == 0)	//injected CONTRACT AFFECTED BY MINERS
        require(msg.value >= _recvAccount.spamFee, "spam fee is insufficient");
      else
        require(msg.value >= _recvAccount.messageFee, "fee is insufficient");
      messageCount = safeAdd(messageCount, 1);
      _recvAccount.recvIds[_recvAccount.recvMessageCount] = messageCount;
      _sendAccount.sentIds[_sendAccount.sentMessageCount] = messageCount;
      _recvAccount.recvMessageCount = safeAdd(_recvAccount.recvMessageCount, 1);
      _sendAccount.sentMessageCount = safeAdd(_sendAccount.sentMessageCount, 1);
      emit MessageEvent(messageCount, messageCount, messageCount, _fromAddr, _toAddr, _via, _sendAccount.sentMessageCount, _recvAccount.recvMessageCount, attachmentIdx, _ref, _message);
      emit MessageTxEvent(_fromAddr, _sendAccount.sentMessageCount, messageCount);
      emit MessageRxEvent(_toAddr, _recvAccount.recvMessageCount, messageCount);
      //return message id, which a calling function might want to log
      _messageId = messageCount;
    } else {
      emit InviteEvent(_toAddr, _fromAddr);
      _messageId = 0;
    }
    uint _retainAmount = safeMul(msg.value, 30) / 100;
    retainedFeesBalance = safeAdd(retainedFeesBalance, _retainAmount);
    _recvAccount.feeBalance = safeAdd(_recvAccount.feeBalance, safeSub(msg.value, _retainAmount));
    _recvAccount.peerRecvMessageCount[_fromAddr] = safeAdd(_recvAccount.peerRecvMessageCount[_fromAddr], 1);
  }


  // -------------------------------------------------------------------------
  // withdraw accumulated message & spam fees
  // -------------------------------------------------------------------------
  function withdraw() public {
    Account storage _account = accounts[msg.sender];
    uint _amount = _account.feeBalance;
    _account.feeBalance = 0;
    msg.sender.transfer(_amount);
  }


  // -------------------------------------------------------------------------
  // pay retained fees funds to token contract; burn half.
  // -------------------------------------------------------------------------
  function withdrawRetainedFees() public {
    uint _amount = retainedFeesBalance / 2;
    address(0).transfer(_amount);
    _amount = safeSub(retainedFeesBalance, _amount);
    retainedFeesBalance = 0;
    (bool paySuccess, ) = tokenAddr.call.value(_amount)("");
    require(paySuccess, "failed to transfer fees");
  }

}