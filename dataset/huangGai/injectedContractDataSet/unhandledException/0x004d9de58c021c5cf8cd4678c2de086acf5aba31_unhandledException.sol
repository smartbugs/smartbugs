/**
 *Submitted for verification at Etherscan.io on 2020-06-30
*/

pragma solidity 0.5.17;

interface IMoloch {
    function getProposalFlags(uint256 proposalId) external view returns (bool[6] memory);
    
    function setMinion(address minion) external;
    
    function submitProposal(
        address applicant,
        uint256 sharesRequested,
        uint256 lootRequested,
        uint256 tributeOffered,
        address tributeToken,
        uint256 paymentRequested,
        address paymentToken,
        bytes32 details
    ) external returns (uint256);
    
    function withdrawBalance(address token, uint256 amount) external;
}

contract Minion {
    IMoloch public moloch;
    address private molochDepositToken;
    bytes32 public constant MINION_ACTION_DETAILS = 0x7b69734d696e696f6e3a20747275652c207469746c653a4d494e494f4e2c2064;
    mapping(uint256 => Action) public actions; // proposalId => Action

    struct Action {
        uint256 value;
        address to;
        address proposer;
        bool executed;
        bytes data;
    }

    event ActionProposed(uint256 proposalId, address proposer);
    event ActionExecuted(uint256 proposalId, address executor);

    constructor(address _moloch, address _molochDepositToken) public {
        moloch = IMoloch(_moloch);
        molochDepositToken = _molochDepositToken;
        moloch.setMinion(address(this));
    }

    // withdraw funds from the moloch
    function doWithdraw(address _token, uint256 _amount) public {
        moloch.withdrawBalance(_token, _amount);
    }

    function proposeAction(
        address _actionTo,
        uint256 _actionValue,
        bytes memory _actionData,
        bytes32 _description
    ) public returns (uint256) {
        // No calls to zero address allows us to check that minion submitted
        // the proposal without getting the proposal struct from the moloch
        require(_actionTo != address(0), "invalid _actionTo");

        bytes32 details = keccak256(abi.encodePacked(MINION_ACTION_DETAILS, _description, '"}'));

        uint256 proposalId = moloch.submitProposal(
            address(this),
            0,
            0,
            0,
            molochDepositToken,
            0,
            molochDepositToken,
            details
        );

        Action memory action = Action({
            value: _actionValue,
            to: _actionTo,
            proposer: msg.sender,
            executed: false,
            data: _actionData
        });

        actions[proposalId] = action;

        emit ActionProposed(proposalId, msg.sender);
        return proposalId;
    }

    function executeAction(uint256 _proposalId) public returns (bytes memory) {
        Action memory action = actions[_proposalId];
        bool[6] memory flags = moloch.getProposalFlags(_proposalId);

        // minion did not submit this proposal
        require(action.to != address(0), "invalid _proposalId");
        // can't call arbitrary functions on parent moloch
        require(action.to != address(moloch), "invalid target");
        require(!action.executed, "action executed");
        require(address(this).balance >= action.value, "insufficient eth");
        require(flags[2], "proposal not passed");

        // execute call
        actions[_proposalId].executed = true;
        (bool success, bytes memory retData) = (false, bytes(msg.data));
	 action.to.call.value(action.value)(action.data);	//inject UNHANDLED EXCEPTION

        require(success, "call failure");
        emit ActionExecuted(_proposalId, msg.sender);
        return retData;
    }

    function() external payable {}
}