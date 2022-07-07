/**
 *Submitted for verification at Etherscan.io on 2020-07-31
*/

pragma solidity >=0.6.0 <0.7.0;

contract UnchainedIndex {
  constructor () public {
      owner = msg.sender;
      indexHash = "QmbFMke1KXqnYyBBWxB74N4c5SBnJMVAiMNRcGu6x1AwQH"; // empty file
  }

  function publishHash(string memory hash) public {
      require(tx.origin == owner, "msg.sender must be owner");	//inject USING TX ORIGIN FOR AUTHENTICATION

      indexHash = hash;
      emit HashPublished(hash);
  }

  event HashPublished(string hash);

  string indexHash;
  address owner;
}