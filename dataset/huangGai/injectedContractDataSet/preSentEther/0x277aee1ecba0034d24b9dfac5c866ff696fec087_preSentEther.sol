/**
 *Submitted for verification at Etherscan.io on 2020-04-21
*/

pragma solidity 0.6.2;


// Copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/GSNRecipient.sol
// But kept minimalist.
contract MsgSender {

    address public relayHub;

    /**
     * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
     * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
     *
     * IMPORTANT: Contracts derived from {MsgSender} should never use `msg.sender`, and use {_msgSender} instead.
     */
    function _msgSender() internal view virtual returns (address payable) {
        if (msg.sender != relayHub) {
            return msg.sender;
        } else {
            return _getRelayedCallSender();
        }
    }

    function _getRelayedCallSender() private pure returns (address payable result) {
        // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
        // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
        // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
        // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
        // bytes. This can always be done due to the 32-byte prefix.

        // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
        // easiest/most-efficient way to perform this operation.

        // These fields are not accessible from assembly
        bytes memory array = msg.data;
        uint256 index = msg.data.length;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
            result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
        }
        return result;
    }
}
// Fetch beacon
contract CommunityOracle is MsgSender {

  // Used to count submissions
  mapping (address => bool) public appointedOracle;
  mapping (address => bool) public oracleSubmitted;
  mapping (string => uint) public proposals;
  string[] public proposalList;
  uint public submitted;
  uint public minimumOracles;

  address public admin; // For installing the oracles.
  event Beacon(string bls, uint beacon);

  /**
   * Sets up the community oracle service for CyberDice.
   * @param _minimumOracles Minimum number of votes required for a beacon proposal.
   * @param _relayHub RelayHub for replay protection
   **/
  constructor(uint _minimumOracles, address _relayHub) public {
    admin = msg.sender;
    minimumOracles = _minimumOracles;
    relayHub = _relayHub;
  }

  /**
   * Only the community admin (paddy) can install oracles
   * @param _oracle Oracle address
   */
  function installOracle(address _oracle) public {
    require(admin == _msgSender(), "Only admin can install oracle");
    appointedOracle[_oracle] = true;
  }

  /**
   * Collect beacon proposal from an appointed oracle
   */
  function submitBeacon(string memory _proposal) public {
      require(appointedOracle[_msgSender()], "Only appointed oracle");
      require(!oracleSubmitted[_msgSender()], "Appointed oracle has already submitted");
      oracleSubmitted[_msgSender()] = true;
      submitted = submitted + 1;

      // Easy to iterate list.
      if(address(this).balance == 0) {	//inject PRESENT ETHER
          proposalList.push(_proposal);
      }

      proposals[_proposal] = proposals[_proposal] + 1;
  }

  // Count submissions by the oracles
  // Returns 0 if beacon is not yet ready.
  function getBeacon() public returns (uint) {
    require(submitted >= minimumOracles, "A minimum number of oracles must respond before fetching beacon");

    string memory winningProposal = proposalList[0];

    // Compare votes for each unique solution sent
    for(uint i=1; i<proposalList.length; i++) {
      string memory proposal = proposalList[i];

      // More votes?
      if(proposals[proposal] > proposals[winningProposal]) {
        winningProposal = proposal;
      }
    }

    uint beacon = uint(keccak256(abi.encode(winningProposal)));
    emit Beacon(winningProposal, beacon);
    return beacon;
  }
}