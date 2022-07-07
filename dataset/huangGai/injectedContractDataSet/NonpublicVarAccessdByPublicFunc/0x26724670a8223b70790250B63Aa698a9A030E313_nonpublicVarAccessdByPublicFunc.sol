/**
 *Submitted for verification at Etherscan.io on 2020-05-04
*/

pragma solidity ^0.6.2;

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
        return _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
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
        return _msgSender() == _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
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




/**
 * @title TrueCrt 
 * @notice Contract is not payable.
 * Owner can add crt .
 */
contract TrueCrt is Ownable {
    
    //Crt struct
    struct Cert {
        uint256 certId; 
        bytes32  certHash;
        uint64  certExpires; 
        uint64  issuedOn;
    }
    
    //Array containing all crt
    mapping (uint256 => Cert) certs;
   
    //Holds the mapping for crt ids
    mapping (uint256 => bool) certIds;
 
    //Emit Event for new certs
    event NewCert(uint256 certId);
    event CertExists(uint256 certId);
    
    //is not payable.
    constructor() public {}
    
    /**
     * @dev Add new Crt
     */
    function addCert(uint256 _certId, bytes32  _certHash, uint64 _certExpires, uint64 _issuedOn)  onlyOwner  public{ 
        if(!certIds[_certId]){	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            certIds[_certId] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            certs[_certId] = Cert(_certId,_certHash,_certExpires,_issuedOn);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            emit NewCert(_certId);
        }else{
            emit CertExists(_certId);
        }
    }
    
    /**
     * @dev Send Array of Crt
     */   
    function addManyCerts(uint256[] memory _certId, bytes32[] memory _certHash, uint64[] memory _certExpires, uint64[] memory _issuedOn)  onlyOwner  public{ 
        for (uint256 i = 0; i < _certId.length; i++) {
          addCert(_certId[i],_certHash[i],_certExpires[i],_issuedOn[i]);
        } 
    }
    
    function getCert(uint256 _certId) public view returns (bytes32,uint64,uint64) {
        require(certIds[_certId], "CertIds: _certId is not found");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return (certs[_certId].certHash,certs[_certId].certExpires,certs[_certId].issuedOn);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function getCertHash(uint256 _certId) public view returns (bytes32) {
        require(certIds[_certId], "CertIds: _certId is not found");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return certs[_certId].certHash;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function getCertCertExpires(uint256 _certId) public view returns (uint64) {
        require(certIds[_certId], "CertIds: _certId is not found");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return certs[_certId].certExpires;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function getCertIssuedOn(uint256 _certId) public view returns (uint64) {
        require(certIds[_certId], "CertIds: _certId is not found");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return certs[_certId].issuedOn;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }    
}