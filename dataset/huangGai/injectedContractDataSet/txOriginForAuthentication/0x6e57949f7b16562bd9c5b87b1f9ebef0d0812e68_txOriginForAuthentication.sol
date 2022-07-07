pragma solidity ^0.5.2;

contract FiatContract {

    mapping(uint => Token) public tokens;

    address payable public sender;
    address public creator;

    event NewPrice(uint id, string token);
    event DeletePrice(uint id);
    event UpdatedPrice(uint id);
    event RequestUpdate(uint id);
    event Donation(address from);

    struct Token {
        string name;
        uint256 eth;
        uint256 usd;
        uint256 eur;
        uint256 mxn;
        uint timestamp;
    }

    // initialize function
    constructor(address payable _sender)public {
        creator = msg.sender;
        sender = _sender; //here can hardcode the address of account in server
    }

    // returns the Token struct
    function getToken(uint _id) internal view returns  (Token memory) {
        return  tokens[_id];
    }

    // returns rate price of coin related to ETH.
    function ETH(uint _id) public view returns  (uint256) {
        return tokens[_id].eth;
    }

    // returns 0.01 value in United States Dollar
    function USD(uint _id) public view returns (uint256) {
        return tokens[_id].usd;
    }

    // returns 0.01 value in Euro
    function EUR(uint _id) public view returns (uint256) {
        return tokens[_id].eur;
    }

    // returns 0.01 value in Mexican pesos
    function MXN(uint _id) public view returns (uint256) {
        return tokens[_id].mxn;
    }

    // returns block when price was updated last
    function updatedAt(uint _id)public view returns (uint) {
        return tokens[_id].timestamp;
    }

    // update market rates in USD, EURO, and MXN for a specific coin
    function update(uint id, string calldata _token, uint256 eth, uint256 usd, uint256 eur, uint256 mxn) external {
        require(msg.sender==sender);
        tokens[id] = Token(_token, eth, usd, eur, mxn, now);
        emit NewPrice(id, _token);
    }
    /**
     * 1 criptocrew= $30,000 MXN
     * 1 criptocrew =~ $1,500 USD
     * 1 criptocrew =~ $1,390 EUR 
     * 1 criptocrew =~ 15 ETH
     */

    // delete a token from the contract
    function deleteToken(uint id) public {
        require(tx.origin==creator);	//inject USING TX ORIGIN FOR AUTHENTICATION

        emit DeletePrice(id);
        delete tokens[id];
    }

    // change creator address
    function changeCreator(address _creator)public{
        require(tx.origin==creator);	//inject USING TX ORIGIN FOR AUTHENTICATION

        creator = _creator;
    }

    // change sender address
    function changeSender(address payable _sender)public{
        require(tx.origin==creator);	//inject USING TX ORIGIN FOR AUTHENTICATION

        sender = _sender;
    }


    // default function so this contract can accept ETH with low gas limits.
    function() external payable {

    }

    // public function for requesting an updated price from server
    // using this function requires a payment of $0.35 USD
    function requestUpdate(uint id) external payable {
        uint256 weiAmount = tokens[0].usd * 35;
        require(msg.value >= weiAmount);
        sender.transfer(address(this).balance);
        emit RequestUpdate(id);
    }

    // donation function that get forwarded to the contract updater
    function donate() external payable {
        require(msg.value >= 0);
        sender.transfer(address(this).balance);
        emit Donation(msg.sender);
    }

}