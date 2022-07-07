/**
 *Submitted for verification at Etherscan.io on 2020-01-13
*/

pragma solidity ^0.5.8;

contract CHUNTCOIN {

    struct Event {
        address event_address;
        uint8 max_member;
        uint8 member_count;
    }

    //Basic Token Info
    uint256 public constant totalSupply=100000000000000;
    string public constant name = "CHUNTCOIN";
    string public constant symbol = "CHUNT";
    string public constant description = "An ultimate payment solution";
    uint32 public constant decimals = 5;

    //Event related variables
    Event[8] public Events;
    address public coin_address;

    //Contract deployer address from constructor()
    address public owner;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value);

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value);

    //ERC20 and individual mappings
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => mapping(address => bool)) public event_mapping;
    mapping(address => bool) public coin_purchased;

    //Modifier to allow some functions to be run only by the deployer of the contract
    modifier onlyOwner() {
        require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }

    constructor() public {
        //balanceOf[_address]=totalSupply;
        balanceOf[msg.sender]=totalSupply;
		owner = msg.sender;
    }

    function transfer(address _to, uint256 _value) public returns (bool success){
        require(_value <= balanceOf[msg.sender]);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        for (uint x=0;x < 8;x++) {
            if (_to == Events[x].event_address) {
                if (_value == 1 && Events[x].member_count < Events[x].max_member && event_mapping[Events[x].event_address][msg.sender] == false) {
                    event_mapping[Events[x].event_address][msg.sender] = true;
                    Events[x].member_count += 1;
                }
                else {
                    balanceOf[_to] -= _value;
                    balanceOf[msg.sender] += _value;
                }
            }
        }

         if (_to == coin_address){
            if (_value == 1 && coin_purchased[msg.sender] == false){
                     coin_purchased[msg.sender] = true;
                 }
            else {
             balanceOf[_to] -= _value;
             balanceOf[msg.sender] += _value;
             }
         }

        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    //Event creation only by contract owner (see modifier)
    function create_event(uint8 _max_member, address _event_address, uint256 _pos) public onlyOwner {
        Events[_pos].event_address = _event_address;
        Events[_pos].max_member = _max_member;
        Events[_pos].member_count = 0;
    }

    //Coin address setting only by contract owner (see modifier)
    function set_coin_address(address _coin_address) public onlyOwner {
        coin_address = _coin_address;
    }

}