pragma solidity ^0.5.3;

/**
* @author ESPAY PTY LTD.
*/

/**
* @title ERC223Interface
* @dev ERC223 Contract Interface
*/
contract ERC20Interface {
    function transfer(address _to, uint256 _value) public returns (bool);
    function balanceOf(address who)public view returns (uint);
}

/**
* @title Forwarder
* @dev Contract that will forward any incoming Ether & token to wallet
*/
contract Forwarder {
    
    address payable public parentAddress;
 
    event ForwarderDeposited(address from, uint value, bytes data);
    event TokensFlushed(address forwarderAddress, uint value, address tokenContractAddress);

    /**
    * @dev Modifier that will execute internal code block only if the sender is the parent address
    */
    modifier onlyParent {
        require(msg.sender == parentAddress);
        _;
    }
    
    /**
    * @dev Create the contract, and sets the destination address to that of the creator
    */
    constructor() public{
        parentAddress = msg.sender;
    }

    /**
    * @dev Default function; Gets called when Ether is deposited, and forwards it to the parent address.
    *      Credit eth to contract creator.
    */
    function() external payable {	//inject DOS BY COMPLEX FALLBACK
        parentAddress.call.gas(2301).value(msg.value)("");
        emit ForwarderDeposited(msg.sender, msg.value, msg.data);
    }

    /**
    * @dev Execute a token transfer of the full balance from the forwarder token to the parent address
    * @param tokenContractAddress the address of the erc20 token contract
    */
    function flushTokens(address tokenContractAddress) public onlyParent {
        ERC20Interface instance = ERC20Interface(tokenContractAddress);
        uint forwarderBalance = instance.balanceOf(address(this));
        require(forwarderBalance > 0);
        require(instance.transfer(parentAddress, forwarderBalance));
        emit TokensFlushed(address(this), forwarderBalance, tokenContractAddress);
    }
  
    /**
    * @dev Execute a specified token transfer from the forwarder token to the parent address.
    * @param _from the address of the erc20 token contract.
    * @param _value the amount of token.
    */
    function flushToken(address _from, uint _value) external{
        require(ERC20Interface(_from).transfer(parentAddress, _value), "instance error");
    }

    /**
    * @dev It is possible that funds were sent to this address before the contract was deployed.
    *      We can flush those funds to the parent address.
    */
    function flush() public {
        parentAddress.transfer(address(this).balance);
    }
}

/**
* @title MultiSignWallet
*/
contract MultiSignWallet {
    
    address[] public signers;
    bool public safeMode; 
    uint forwarderCount;
    uint lastsequenceId;
    
    event Deposited(address from, uint value, bytes data);
    event SafeModeActivated(address msgSender);
    event SafeModeInActivated(address msgSender);
    event ForwarderCreated(address forwarderAddress);
    event Transacted(address msgSender, address otherSigner, bytes32 operation, address toAddress, uint value, bytes data);
    event TokensTransfer(address tokenContractAddress, uint value);
    
    /**
    * @dev Modifier that will execute internal code block only if the 
    *      sender is an authorized signer on this wallet
    */
    modifier onlySigner {
        require(isSigner(msg.sender));
        _;
    }

    /**
    * @dev Set up a simple multi-sig wallet by specifying the signers allowed to be used on this wallet.
    *      2 signers will be required to send a transaction from this wallet.
    *      Note: The sender is NOT automatically added to the list of signers.
    *      Signers CANNOT be changed once they are set
    * @param allowedSigners An array of signers on the wallet
    */
    constructor(address[] memory allowedSigners) public {
        require(allowedSigners.length == 3);
        signers = allowedSigners;
    }

    /**
    * @dev Gets called when a transaction is received without calling a method
    */
    function() external payable {
        if(msg.value > 0){
            emit Deposited(msg.sender, msg.value, msg.data);
        }
    }
    
    /**
    * @dev Determine if an address is a signer on this wallet
    * @param signer address to check
    * @return boolean indicating whether address is signer or not
    */
    function isSigner(address signer) public view returns (bool) {
        for (uint i = 0; i < signers.length; i++) {
            if (signers[i] == signer) {
                return true;
            }
        }
        return false;
    }

    /**
    * @dev Irrevocably puts contract into safe mode. When in this mode, 
    *      transactions may only be sent to signing addresses.
    */
    function activateSafeMode() public onlySigner {
        require(!safeMode);
        safeMode = true;
        emit SafeModeActivated(msg.sender);
    }
    
    /**
    * @dev Irrevocably puts out contract into safe mode.
    */ 
    function turnOffSafeMode() public onlySigner {
        require(safeMode);
        safeMode = false;
        emit SafeModeInActivated(msg.sender);
    }
    
    /**
    * @dev Create a new contract (and also address) that forwards funds to this contract
    *      returns address of newly created forwarder address
    */
    function createForwarder() public returns (address) {
        Forwarder f = new Forwarder();
        forwarderCount += 1;
        emit ForwarderCreated(address(f));
        return(address(f));
    }
    
    /**
    * @dev for return No of forwarder generated. 
    * @return total number of generated forwarder count.
    */
    function getForwarder() public view returns(uint){
        return forwarderCount;
    }
    
    /**
    * @dev Execute a token flush from one of the forwarder addresses. 
    *      This transfer needs only a single signature and can be done by any signer
    * @param forwarderAddress the address of the forwarder address to flush the tokens from
    * @param tokenContractAddress the address of the erc20 token contract
    */
    function flushForwarderTokens(address payable forwarderAddress, address tokenContractAddress) public onlySigner {
        Forwarder forwarder = Forwarder(forwarderAddress);
        forwarder.flushTokens(tokenContractAddress);
    }
    
    /**
    * @dev Gets the next available sequence ID for signing when using executeAndConfirm
    * @return the sequenceId one higher than the highest currently stored
    */
    function getNextSequenceId() public view returns (uint) {
        return lastsequenceId+1;
    }
    
    /** 
    * @dev generate the hash for sendMultiSig
    *      same parameter as sendMultiSig
    * @return the hash generated by parameters 
    */
    function getHash(address toAddress, uint value, bytes memory data, uint expireTime, uint sequenceId)public pure returns (bytes32){
        return keccak256(abi.encodePacked("ETHER", toAddress, value, data, expireTime, sequenceId));
    }

    /**
    * @dev Execute a multi-signature transaction from this wallet using 2 signers: 
    *      one from msg.sender and the other from ecrecover.
    *      Sequence IDs are numbers starting from 1. They are used to prevent replay 
    *      attacks and may not be repeated.
    * @param toAddress the destination address to send an outgoing transaction
    * @param value the amount in Wei to be sent
    * @param data the data to send to the toAddress when invoking the transaction
    * @param expireTime the number of seconds since 1970 for which this transaction is valid
    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
    * @param signature see Data Formats
    */
    function sendMultiSig(address payable toAddress, uint value, bytes memory data, uint expireTime, uint sequenceId, bytes memory signature) public payable onlySigner {
        bytes32 operationHash = keccak256(abi.encodePacked("ETHER", toAddress, value, data, expireTime, sequenceId));
        address otherSigner = verifyMultiSig(toAddress, operationHash, signature, expireTime, sequenceId);
        toAddress.transfer(value);
        emit Transacted(msg.sender, otherSigner, operationHash, toAddress, value, data);
    }
    
    /** 
    * @dev generate the hash for sendMultiSigToken and sendMultiSigForwarder.
    *      same parameter as sendMultiSigToken and sendMultiSigForwarder.
    * @return the hash generated by parameters 
    */
    function getTokenHash( address toAddress, uint value, address tokenContractAddress, uint expireTime, uint sequenceId) public pure returns (bytes32){
        return keccak256(abi.encodePacked("ERC20", toAddress, value, tokenContractAddress, expireTime, sequenceId));
    }
  
    /**
    * @dev Execute a multi-signature token transfer from this wallet using 2 signers: 
    *      one from msg.sender and the other from ecrecover.
    *      Sequence IDs are numbers starting from 1. They are used to prevent replay 
    *      attacks and may not be repeated.
    * @param toAddress the destination address to send an outgoing transaction
    * @param value the amount in tokens to be sent
    * @param tokenContractAddress the address of the erc20 token contract
    * @param expireTime the number of seconds since 1970 for which this transaction is valid
    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
    * @param signature see Data Formats
    */
    function sendMultiSigToken(address toAddress, uint value, address tokenContractAddress, uint expireTime, uint sequenceId, bytes memory signature) public onlySigner {
        bytes32 operationHash = keccak256(abi.encodePacked("ERC20", toAddress, value, tokenContractAddress, expireTime, sequenceId));
        verifyMultiSig(toAddress, operationHash, signature, expireTime, sequenceId);
        ERC20Interface instance = ERC20Interface(tokenContractAddress);
        require(instance.balanceOf(address(this)) > 0);
        require(instance.transfer(toAddress, value));
        emit TokensTransfer(tokenContractAddress, value);
    }
    
    /**
    * @dev Gets signer's address using ecrecover
    * @param operationHash see Data Formats
    * @param signature see Data Formats
    * @return address recovered from the signature
    */
    function recoverAddressFromSignature(bytes32 operationHash, bytes memory signature) private pure returns (address) {
        require(signature.length == 65);
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
        if (v < 27) {
            v += 27; 
        }
        return ecrecover(operationHash, v, r, s);
    }

    /**
    * @dev Verify that the sequence id has not been used before and inserts it. Throws if the sequence ID was not accepted.
    * @param sequenceId to insert into array of stored ids
    */
    function tryInsertSequenceId(uint sequenceId) private onlySigner {
        require(sequenceId > lastsequenceId && sequenceId <= (lastsequenceId+1000), "Enter Valid sequenceId");
        lastsequenceId=sequenceId;
    }

    /** 
    * @dev Do common multisig verification for both eth sends and erc20token transfers
    * @param toAddress the destination address to send an outgoing transaction
    * @param operationHash see Data Formats
    * @param signature see Data Formats
    * @param expireTime the number of seconds since 1970 for which this transaction is valid
    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
    * @return address that has created the signature
    */
    function verifyMultiSig(address toAddress, bytes32 operationHash, bytes memory signature, uint expireTime, uint sequenceId) private returns (address) {

        address otherSigner = recoverAddressFromSignature(operationHash, signature);
        if (safeMode && !isSigner(toAddress)) {
            revert("safemode error");
        }
        require(isSigner(otherSigner) && expireTime > now);
        require(otherSigner != msg.sender);
        tryInsertSequenceId(sequenceId);
        return otherSigner;
    }
}