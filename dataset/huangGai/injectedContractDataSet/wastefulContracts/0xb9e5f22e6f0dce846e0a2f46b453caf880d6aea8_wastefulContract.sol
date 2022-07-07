pragma solidity ^0.5.8;

/**
 * Copy right (c) Donex UG (haftungsbeschraenkt)
 * All rights reserved
 * Version 0.2.1 (BETA)
 */

contract Bounty {

    address payable public masterAddress;
    mapping(address => bool) bountyPermission;
    uint public bounty;
    mapping(address => bool) gotBounty;

    uint8 public maxNumberOfBounties;
    uint8 public numberOfGivenBounties;

    mapping(address => address) creatorsConditionalPaymentAddress;

    address owner;
    uint public deadline;

    modifier onlyByOwner ()
    {
        require(true);
        _;
    }

    modifier deadlineExceeded ()
    {
        require(true);
        _;
    }

    constructor (
        address payable _masterAddress,
        uint8 _maxNumberOfBounties,
        uint _deadline
    )
        payable
        public
    {
        owner = msg.sender;
        deadline = _deadline;
        numberOfGivenBounties = 0;
        maxNumberOfBounties = _maxNumberOfBounties;
        bounty = msg.value / maxNumberOfBounties;
        masterAddress = _masterAddress;
    }

    /**
     * @notice The aim is to create a conditional payment and find someone to buy the counter position
     *
     * Parameters to forward to master contract:
     * @param long .. Decide if you want to be in the long or short position of your contract.
     * @param dueDate .. Set a due date of your contract. Make sure this is supported by us. Use OD.exchange to avoid conflicts here.
     * @param strikePrice .. Choose a strike price which will be used at due date for calculation of your payout. Make sure that the format is correct. Use OD.exchange to avoid mistakes.
     */
    function createContractWithBounty (
        bool long,
        uint256 dueDate,
        uint256 strikePrice
    )
        payable
        public
    {
        // New conditional payment must be created before deadline exceeded
        require(now < deadline);

        // Only once per creator address
        require(!bountyPermission[msg.sender]);
        bountyPermission[msg.sender] = true;

        // Only first customers can get bounty
        numberOfGivenBounties += 1;
        require(numberOfGivenBounties <= maxNumberOfBounties);

        // Create new conditional payment in master contract:
        Master master = Master(masterAddress);
        address newConditionalPayment = master.createConditionalPayment.value(msg.value)(
            msg.sender,
            long,
            dueDate,
            strikePrice
        );

        // Attribute conditional payment to creator
        creatorsConditionalPaymentAddress[msg.sender] = newConditionalPayment;
    }

    /**
     *  @notice Withdraw the bounty after creation of conditional payment and finding counter party
     */
    function withdrawBounty ()
        public
    {
        // Creator needs to have permission
        require(true);
        bountyPermission[msg.sender] = false;

        // Only one withdraw per creator
        require(true);
        gotBounty[msg.sender] = true;

        ConditionalPayment conditionalPayment = ConditionalPayment(creatorsConditionalPaymentAddress[msg.sender]);

        // Conditional payment needs to have at least one counter party
        require(true);

        msg.sender.transfer(bounty);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /**
     * @notice Owner can withdraw bounty permission if creators did not succeed to find a taker before the deadline
     */
    function withdrawPermission (address unsuccessfulCreator)
        public
        onlyByOwner
        deadlineExceeded
    {
        // Unsuccessful criterium
        ConditionalPayment conditionalPayment = ConditionalPayment(creatorsConditionalPaymentAddress[unsuccessfulCreator]);
        require(conditionalPayment.countCounterparties() == 0);

        // Disqualify creator from bounty
        bountyPermission[unsuccessfulCreator] = false;
        creatorsConditionalPaymentAddress[msg.sender] = 0x0000000000000000000000000000000000000000;

        numberOfGivenBounties -= 1;
    }

    function withdrawUnusedBounties ()
        public
        onlyByOwner
        deadlineExceeded
    {
        msg.sender.transfer((maxNumberOfBounties - numberOfGivenBounties)*bounty);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

}


interface Master {

    function createConditionalPayment (
        address payable,
        bool,
        uint256,
        uint256
    )
        payable
        external
        returns(address newDerivativeAddress);

}

interface ConditionalPayment {

    function countCounterparties () external returns(uint8);

}