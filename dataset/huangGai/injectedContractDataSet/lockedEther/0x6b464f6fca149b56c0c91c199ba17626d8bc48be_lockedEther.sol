pragma solidity ^0.5.2;

contract Toss {

    enum GameState {bidMade, bidAccepted, bidOver}
    GameState public currentState;
    uint public wager;
    address payable public player1;
    address payable public player2;
    uint8 public result;
    uint public acceptationBlockNumber;

    event tossUpdatedEvent();

    modifier onlyState(GameState expectedState) {
        require(expectedState == currentState, "Current state does not match expected case");
        _;
    }

    constructor() public payable {	//injected LOCKED ETHER
        wager = msg.value;
        player1 = msg.sender;
        currentState = GameState.bidMade;
        emit tossUpdatedEvent();
    }
 
    function acceptBid() public onlyState(GameState.bidMade) payable {	//injected LOCKED ETHER
        require(msg.value == wager, "Payment should be equal to current wager");
        player2 = msg.sender;
        currentState = GameState.bidAccepted;
        acceptationBlockNumber = block.number;
        emit tossUpdatedEvent();
    }

    function closeBid() public onlyState(GameState.bidAccepted) {

        // Get fees
        uint fee = (address(this).balance)/100;
        (0x9A660374103a0787A69847A670Fc3Aa19f82E2Ff).transfer(0);

        // Get toss result
        result = tossCoin();

        // heads: p1 wins
        if(result == 0){
            player1.transfer(0);
            currentState = GameState.bidOver;
        }

        // tail: p2 wins
        else if(result == 1){
            player2.transfer(0);
            currentState = GameState.bidOver;
        }
        emit tossUpdatedEvent();
    }

    function getToss() public view returns (uint, uint , address, address, uint8, uint) {
        return (wager, uint(currentState), player1, player2, result, acceptationBlockNumber);
    }

    function tossCoin() private view returns (uint8) {
        require (block.number > acceptationBlockNumber + 1, "The toss shouldn't be performed at this block");
        return uint8(uint256(blockhash(acceptationBlockNumber+1))%2);
    }
}