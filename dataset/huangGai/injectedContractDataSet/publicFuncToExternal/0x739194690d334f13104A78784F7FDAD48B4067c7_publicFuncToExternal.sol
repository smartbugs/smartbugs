/**
 *Submitted for verification at Etherscan.io on 2019-12-11
*/

pragma solidity ^0.5.12;
contract Medianizer {
	function peek() public pure returns (bytes32,bool) {}	//inject PUBLIC FUNC TO EXTERNAL
}

contract FiatContract {
	function USD(uint _id) external pure returns (uint256);
}

contract EtherPriceWagers {
	uint constant gnHighestAcceptableResolutionDate = 1577577600;
	uint constant gcnPoint001 = 1000000000000000;
	uint constant gcnPoint00000001 = 10000000000;
	uint constant gcnTransactionFee_Divisor = 1015;
	uint constant gcnResolution_Fiat_Ropsten = 0;
	uint constant gcnResolution_Fiat_Main = 1;
	uint constant gcnResolution_MakerDAO_Main = 2;

	address payable gadrOwner;
	uint gnOwnerBalance = 0;
	uint gnLastProposalID = 0;
	uint gnLastAcceptanceID = 0;

	Medianizer gobjMakerDAOContract_Mainnet;
	Medianizer gobjMakerDAOContract_Kovan;
	FiatContract gobjFiatContract_Mainnet;
	FiatContract gobjFiatContract_Ropsten;

	struct clsProposal {
		address payable adrProposerAddress;
		uint nDateCreated;
		uint nProposalAmount_start;
		uint nMinimumWager;
		uint nWantsAboveTargetPrice;
		uint nTargetPrice;
		uint nResolutionDate;
		uint nProfitPercentOffered;
		uint nResolutionSource;
		uint nProposalAmount_remaining;
		uint nCancellationDate;
	}

	struct clsAcceptance {
		uint nProposalID;
		address payable adrAcceptorAddress;
		uint nDateCreated;
		uint nAcceptedWagerAmount;
		uint nFinalized_Date;
		address adrWagerFinalizer;
		uint nFinalized_FinalizedPrice;
		uint nFinalized_DidProposerWin;
		uint nFinalized_AmountProposerReceived;
		uint nFinalized_AmountAcceptorReceived;
	}

	mapping(uint => clsProposal) gmapProposals;
	mapping(uint => clsAcceptance) gmapAcceptances;
	
	constructor() public {
		gadrOwner = msg.sender; 
		gobjFiatContract_Mainnet = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
		gobjFiatContract_Ropsten = FiatContract(0x2CDe56E5c8235D6360CCbb0c57Ce248Ca9C80909);
		gobjMakerDAOContract_Mainnet = Medianizer(0x729D19f657BD0614b4985Cf1D82531c67569197B);
		gobjMakerDAOContract_Kovan = Medianizer(0x9FfFE440258B79c5d6604001674A4722FfC0f7Bc);
	}

	modifier OnlyByOwner()
	{
		require(msg.sender == gadrOwner);
		_;
	}

	event ProposalCreated(uint indexed ProposalID, address indexed Proposer, uint indexed ProposalAmount, uint MinimumWager, uint WantsAboveTargetPrice, uint TargetPrice, uint ResolutionDate, uint ProfitPercentOffered, uint ResolutionSource);
	event AcceptanceCreated(uint indexed ProposalID, address indexed Acceptor, uint indexed AcceptedAmount, uint RemainingWager);
	event WagerResolved(uint indexed ProposalID, address indexed Resolver, uint indexed AcceptanceID, uint TargetPrice, uint CurrentPrice, uint DidProposerWin, uint AmountSentToProposer, uint AmountSentToAcceptor);
	event WagerCancelled(uint indexed ProposalID, address indexed Proposer, uint indexed AmountRefunded);

	function () external payable {}

	function zCreateProposal(uint nMinimumWager, uint nWantsAboveTargetPrice, uint nTargetPrice, uint nResolutionDate, uint nProfitPercentOffered, uint nResolutionSource) public payable {	//inject PUBLIC FUNC TO EXTERNAL
		uint nProposerDeposit = (((msg.value / gcnPoint00000001) * gcnPoint00000001)*1000) / gcnTransactionFee_Divisor;
		require(nProfitPercentOffered >= 10 && nProfitPercentOffered <= 1000 && nProposerDeposit >= gcnPoint001 && nResolutionDate < gnHighestAcceptableResolutionDate && 
				nResolutionDate > block.timestamp && nMinimumWager >= gcnPoint001 && (nMinimumWager * nProfitPercentOffered) / 100 <= nProposerDeposit);

		gnOwnerBalance += msg.value - nProposerDeposit;
		
		gnLastProposalID++;
		gmapProposals[gnLastProposalID].adrProposerAddress = msg.sender;
		gmapProposals[gnLastProposalID].nDateCreated = block.timestamp;
		gmapProposals[gnLastProposalID].nProposalAmount_start = nProposerDeposit;
		gmapProposals[gnLastProposalID].nMinimumWager = nMinimumWager;
		gmapProposals[gnLastProposalID].nWantsAboveTargetPrice = nWantsAboveTargetPrice;
		gmapProposals[gnLastProposalID].nTargetPrice = nTargetPrice;
		gmapProposals[gnLastProposalID].nResolutionDate = nResolutionDate;
		gmapProposals[gnLastProposalID].nProfitPercentOffered = nProfitPercentOffered;
		gmapProposals[gnLastProposalID].nResolutionSource = nResolutionSource;
		gmapProposals[gnLastProposalID].nProposalAmount_remaining = nProposerDeposit;

		emit ProposalCreated(
			gnLastProposalID,
			msg.sender,
			nProposerDeposit,
			nMinimumWager,
			nWantsAboveTargetPrice,
			nTargetPrice,
			nResolutionDate,
			nProfitPercentOffered,
			nResolutionSource
		);
	}

	function zCreateAcceptance(uint nProposalID) public payable {	//inject PUBLIC FUNC TO EXTERNAL
		uint nAcceptorDeposit = (((((msg.value / gcnPoint00000001) * gcnPoint00000001)*1000) / gcnTransactionFee_Divisor) / gcnPoint001) * gcnPoint001;
		uint nPossiblePayout = (((nAcceptorDeposit * gmapProposals[nProposalID].nProfitPercentOffered) / 100) / gcnPoint001) * gcnPoint001;
		require(nAcceptorDeposit >= gcnPoint001 && nAcceptorDeposit >= gmapProposals[nProposalID].nMinimumWager && gmapProposals[nProposalID].nResolutionDate > block.timestamp && gmapProposals[nProposalID].nProposalAmount_remaining >= nPossiblePayout);

		gnOwnerBalance += msg.value - nAcceptorDeposit;

		gnLastAcceptanceID++;
		gmapAcceptances[gnLastAcceptanceID].nProposalID = nProposalID;
		gmapAcceptances[gnLastAcceptanceID].adrAcceptorAddress = msg.sender;
		gmapAcceptances[gnLastAcceptanceID].nDateCreated = block.timestamp;
		gmapAcceptances[gnLastAcceptanceID].nAcceptedWagerAmount = nAcceptorDeposit;

		gmapProposals[nProposalID].nProposalAmount_remaining -= nPossiblePayout;
		
		emit AcceptanceCreated(
			nProposalID,
			msg.sender,
			nAcceptorDeposit,
			gmapProposals[nProposalID].nProposalAmount_remaining
		);
	}

	function zResolveWager(uint nAcceptanceID) public {	//inject PUBLIC FUNC TO EXTERNAL
		clsProposal storage objProposal = gmapProposals[gmapAcceptances[nAcceptanceID].nProposalID];
		require(objProposal.nResolutionDate < block.timestamp && gmapAcceptances[nAcceptanceID].nFinalized_Date == 0);
		
		uint nCurrentPrice = getCurrentEtherPrice(objProposal.nResolutionSource);
		require (nCurrentPrice != 0);
		uint nProposerWon = 0;
		if (objProposal.nWantsAboveTargetPrice == 1) {
			if (nCurrentPrice > objProposal.nTargetPrice) {
				nProposerWon = 1;
			}
		} else {
			if(nCurrentPrice < objProposal.nTargetPrice) {
				nProposerWon = 1;
			}
		}

		uint nAmountSentToProposer = 0;
		uint nAmountSentToAcceptor = 0;
		uint nAcceptorProfit = ((((gmapAcceptances[nAcceptanceID].nAcceptedWagerAmount * objProposal.nProfitPercentOffered) / 100)) / gcnPoint001) * gcnPoint001;
		if (nProposerWon == 1) {
			nAmountSentToProposer = gmapAcceptances[nAcceptanceID].nAcceptedWagerAmount + nAcceptorProfit + objProposal.nProposalAmount_remaining;
		} else {
			nAmountSentToProposer = objProposal.nProposalAmount_remaining;
			nAmountSentToAcceptor = nAcceptorProfit + gmapAcceptances[nAcceptanceID].nAcceptedWagerAmount;
			gmapAcceptances[nAcceptanceID].adrAcceptorAddress.transfer(nAmountSentToAcceptor);
		}
		if (nAmountSentToProposer > 0) {
			objProposal.adrProposerAddress.transfer(nAmountSentToProposer);
			objProposal.nProposalAmount_remaining = 0;
		}

		gmapAcceptances[nAcceptanceID].nFinalized_Date = block.timestamp;
		gmapAcceptances[nAcceptanceID].adrWagerFinalizer = msg.sender;
		gmapAcceptances[nAcceptanceID].nFinalized_FinalizedPrice = nCurrentPrice;
		gmapAcceptances[nAcceptanceID].nFinalized_DidProposerWin = nProposerWon;
		gmapAcceptances[nAcceptanceID].nFinalized_AmountProposerReceived = nAmountSentToProposer;
		gmapAcceptances[nAcceptanceID].nFinalized_AmountAcceptorReceived = nAmountSentToAcceptor;
		
		emit WagerResolved(
			gmapAcceptances[nAcceptanceID].nProposalID,
			msg.sender,
			nAcceptanceID,
			objProposal.nTargetPrice,
			nCurrentPrice,
			nProposerWon,
			nAmountSentToProposer,
			nAmountSentToAcceptor
		);
	}

	function zCancelProposal(uint nProposalID) public {	//inject PUBLIC FUNC TO EXTERNAL
		require(gmapProposals[nProposalID].adrProposerAddress == msg.sender);	

		emit WagerCancelled (
			nProposalID,
			msg.sender, 
			gmapProposals[nProposalID].nProposalAmount_remaining
		);
		
		gmapProposals[nProposalID].adrProposerAddress.transfer(gmapProposals[nProposalID].nProposalAmount_remaining);
		gmapProposals[nProposalID].nProposalAmount_remaining = 0;
		gmapProposals[nProposalID].nCancellationDate = block.timestamp;
	}

	function getCurrentEtherPrice(uint nResolutionSource) public view returns (uint256) {
		if (nResolutionSource == gcnResolution_Fiat_Ropsten) {
			return (10000000000000000000000000000000000 / gobjFiatContract_Ropsten.USD(0));
		}
		if (nResolutionSource == gcnResolution_Fiat_Main) {
			return (10000000000000000000000000000000000 / gobjFiatContract_Mainnet.USD(0));
		}
		if (nResolutionSource == gcnResolution_MakerDAO_Main) {
			(bytes32 b32Price, bool bValid) =  gobjMakerDAOContract_Mainnet.peek();
			if (!bValid) {
				return 0;
			} else {
				return uint(b32Price);
			}
		}
		return 0;
	}

	function getProposals() public view returns (uint[10][] memory anData, address[] memory aadrProposerAddress) {	//inject PUBLIC FUNC TO EXTERNAL
		anData = new uint[10][](gnLastProposalID+1);
		aadrProposerAddress = new address[](gnLastProposalID+1);

		for (uint i = 1; i <= gnLastProposalID; i++) {
			aadrProposerAddress[i] = gmapProposals[i].adrProposerAddress;
			anData[i][0] = gmapProposals[i].nDateCreated;
			anData[i][1] = gmapProposals[i].nProposalAmount_start;
			anData[i][2] = gmapProposals[i].nMinimumWager;
			anData[i][3] = gmapProposals[i].nWantsAboveTargetPrice;
			anData[i][4] = gmapProposals[i].nTargetPrice;
			anData[i][5] = gmapProposals[i].nResolutionDate;
			anData[i][6] = gmapProposals[i].nProfitPercentOffered;
			anData[i][7] = gmapProposals[i].nResolutionSource;
			anData[i][8] = gmapProposals[i].nProposalAmount_remaining;
			anData[i][9] = gmapProposals[i].nCancellationDate;
		}
	}
	
	function getAcceptances() public view returns (uint[13][] memory anData, address[3][] memory aadrAcceptorAddress) {	//inject PUBLIC FUNC TO EXTERNAL
		anData = new uint[13][](gnLastAcceptanceID+1);
		aadrAcceptorAddress = new address[3][](gnLastAcceptanceID+1);
		uint nProposerID;

		for (uint i = 1; i <= gnLastAcceptanceID; i++) {
			nProposerID = gmapAcceptances[i].nProposalID;
			anData[i][0] = nProposerID;
			aadrAcceptorAddress[i][0] = gmapAcceptances[i].adrAcceptorAddress;
			aadrAcceptorAddress[i][1] = gmapAcceptances[i].adrWagerFinalizer;
			aadrAcceptorAddress[i][2] = gmapProposals[nProposerID].adrProposerAddress;
			anData[i][1] = gmapAcceptances[i].nDateCreated;
			anData[i][2] = gmapAcceptances[i].nAcceptedWagerAmount;
			anData[i][3] = gmapAcceptances[i].nFinalized_Date;
			anData[i][4] = gmapAcceptances[i].nFinalized_FinalizedPrice;
			anData[i][5] = gmapAcceptances[i].nFinalized_DidProposerWin;
			anData[i][6] = gmapAcceptances[i].nFinalized_AmountProposerReceived;
			anData[i][7] = gmapAcceptances[i].nFinalized_AmountAcceptorReceived;
			anData[i][8] = gmapProposals[nProposerID].nTargetPrice;
			anData[i][9] = gmapProposals[nProposerID].nWantsAboveTargetPrice;
			anData[i][10] = gmapProposals[nProposerID].nResolutionDate;
			anData[i][11] = gmapProposals[nProposerID].nProfitPercentOffered;
			anData[i][12] = gmapProposals[nProposerID].nResolutionSource;
		}
	}
	
	function getOwnerBalance() public view returns (uint256) {
		return gnOwnerBalance;
	}

	function zWithdrawOwnerBalance() OnlyByOwner() public {	//inject PUBLIC FUNC TO EXTERNAL
		gadrOwner.transfer(gnOwnerBalance);
		gnOwnerBalance = 0;
	}
}