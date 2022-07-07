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
      if(address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
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
/*
 * Author: Patrick McCorry (anydot)
 *
 * An on-chain competition to win prize money.
 *
 * How to enter:
 * Developers simply need to call submit() and send it via the any.sender service.
 *
 * - Skills required to play:
 * All tickets must be sent via the any.sender service, so it requires techncial skill (e.g. developer)
 * to participate in the competition. We have added some extra "ticket bumps" during the game,
 * so it might be worth writing a script that can watch out for the bumps to purchase extra tickets.
 *
 * - How it works:
 * Users can have one or more tickets, and all tickets are appended to a list.
 * When the game ends, we'll use the blockhash as a random beacon and it will
 * a random index in the list of tickets. Whoever owns that ticket is the winner.
 * We took inspiration from https://www.cl.cam.ac.uk/~fms27/papers/2008-StajanoCla-cyberdice.pdf
 *
 * - Minting tickets:
 * We have added rules on how the tickets are minted, so please
 * check out getNoTickets() for up to date information.
 *
 * - Why did we make a competition?
 * It really demonstrates the power of Ethereum and the any.sender service.
 *
 */
contract CyberDice is MsgSender {

    // Let thy explode
    mapping(address => uint) public userTickets;
    address[] public entries;

    // any.sender relayers
    mapping(address => bool) public relayers;

    uint public startBlock; // used for the bumping feature 
    uint public deadline; // competition end-time 

    // senpai
    address public oracleCon; 
    address public winner;

    // League of Entropy 
    uint public roundNumber;

    // Beacon details
    uint public beacon;

    // Notify world of new entry
    event Entry(address signer, uint newTickets, string message);
    event Deposit(address depositor, uint deposit);
    event RequestBeacon();
    event Winner(uint winningTicket, address winner, uint prize); 

    /** 
     * Hard-codes the relevant contracts and the competition's finish time (block).
     * @param _deadline Random beacon is computed based on this block.
     */
    constructor(address[] memory _relayers, address _relayHub, address _oracleCon, uint _deadline, uint _roundNumber) public {
        // Register the any.sender relayers
        for(uint i=0; i<_relayers.length; i++) {
            relayers[_relayers[i]] = true;
        }

        relayHub = _relayHub; // Relay hub address
        startBlock = block.number; // Used for the bump feature 
        deadline = _deadline; // Unix timestamp (to sync with League of Entropy)
        oracleCon = _oracleCon; // Oracle contract
        roundNumber = _roundNumber; // League of Entropy round number
    }

    /*
     * Fetch the beacon and then compute the winner.
     * Must be called within 256 blocks of deadline
     * Just in case there is spam near end of competition,
     * all expired entries will auto-call computeWinner().
     */
    function computeWinner() public {
        require(now > deadline, "We must wait until the competition deadline before computing the winner.");
        require(winner == address(0), "Winner already set");

        beacon = CommunityOracle(oracleCon).getBeacon();
        require(beacon != 0, "Beacon is not ready");

        uint winningTicket = beacon % entries.length;
        winner = entries[winningTicket];

        emit Winner(winningTicket, winner, address(this).balance);
    }

    /*
     * @param _signer Ticket owner
     * @param _tickets New tickets
     *
     * We append the owner's tickets to the global pool!
     */
    function appendTickets(address _signer, uint _tickets) internal {
        userTickets[_signer] = userTickets[_signer] + _tickets;
        for(uint i=0; i<_tickets; i++) {
            entries.push(_signer);
        }
    }
    
    /**
     * Mints new tickets for the user and posts a message to the board.
     * @param _message Message to broadcast
     */
    function submit(string memory _message) public
    {
        require(relayers[tx.origin], "All entries must be sent via any.sender");
        require(msg.sender == relayHub, "All entries must be sent via the RelayHub");
        require(deadline > now, "You have missed your chance to submit a ticket!");
        address ticketOwner = _msgSender();
        uint tickets = getNoTickets();
        appendTickets(ticketOwner, tickets);

        // Post message
        emit Entry(ticketOwner, tickets, _message);
    }

    /**
     * Ticket issuance is based on the progress of lottery.
     * - Favours early in the game
     * - Periodic bumps of tickets
     *
     * ~240 blocks an hour
     * ~5760 blocks a day
     */
    function getNoTickets() internal view returns (uint) {

        // We offer high ticket issueance during the first day
        if(5760 > block.number - startBlock) {
            return 3;
        }

        // Four hour period of bumps
        if(block.number % 5760 < 960) {
            return 2;
        }

        // Four hour period of bumps
        if(block.number % 5760 > 1920 && block.number % 5760 < 2880) {
            return 2;
        }

        // Period bumps
        return 1;
    }

    // Total tickets minted 
    function totalTickets() public view returns(uint) {
        return entries.length;
    }

    /**
     * Winner authorises withdrawal of prize
     */
    function sendPrize() public payable {
        require(winner != address(0), "Winner must be set");
        payable(winner).transfer(address(this).balance);
      
    }

    // Deposit function 
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}