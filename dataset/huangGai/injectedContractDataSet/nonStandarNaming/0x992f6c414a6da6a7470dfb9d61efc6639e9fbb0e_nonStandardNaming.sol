                                                                 

pragma solidity ^0.6.12;





                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }

    function _MSGSENDER366() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA251() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED16(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        address msgSender = _MSGSENDER366();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED16(address(0), msgSender);
    }

                                                                     
    function OWNER683() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER587() {	//inject NONSTANDARD NAMING
        require(_owner == _MSGSENDER366(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP938() public virtual ONLYOWNER587 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED16(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP553(address newOwner) public virtual ONLYOWNER587 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED16(_owner, newOwner);
        _owner = newOwner;
    }
}


contract MerkleTreeTokensVerification is Ownable{
  bytes32 public root;

  constructor(bytes32 _root)public{
    root = _root;
  }

  // owner can update root
  function CHANGEROOT100(bytes32 _root) public ONLYOWNER587{	//inject NONSTANDARD NAMING
    root = _root;
  }


  function VERIFY826(	//inject NONSTANDARD NAMING
    address _leaf,
    bytes32 [] memory proof,
    uint256 [] memory positions
  )
    public
    view
    returns (bool)
  {
    bytes32 leaf = GETLEAF57(_leaf);
    bytes32 computedHash = leaf;

    for (uint256 i = 0; i < proof.length; i++) {
       bytes32 proofElement = proof[i];
       if (positions[i] == 1) {
       computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
      } else {
       computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
       }
     }

     return computedHash == root;
  }

  // internal helpers for convert address
  function ADDRESSTOSTRING215(address x) internal pure returns (string memory) {	//inject NONSTANDARD NAMING
    bytes memory b = new bytes(20);
    for (uint i = 0; i < 20; i++)
        b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
    return string(b);
  }

  function GETLEAF57(address _input) internal pure returns(bytes32){	//inject NONSTANDARD NAMING
    return keccak256(abi.encodePacked(ADDRESSTOSTRING215(_input)));
  }
}