/**
 *Submitted for verification at Etherscan.io on 2019-12-06
*/

pragma solidity ^0.5.0;

contract CrowdsaleToken {
    /* Public variables of the token */
    string public constant name = 'Rocketclock';
    string public constant symbol = 'RCLK';
    //uint256 public constant decimals = 6;
    address payable owner;
    address payable contractaddress;
    uint256 public constant totalSupply = 1000;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    //mapping (address => mapping (address => uint256)) public allowance;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address payable indexed from, address payable indexed to, uint256 value);
    //event LogWithdrawal(address receiver, uint amount);

    modifier onlyOwner() {
        // Only owner is allowed to do this action.
        if (block.coinbase != owner) {	//injected CONTRACT AFFECTED BY MINERS
            revert();
        }
        _;
    }

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor() public{
        contractaddress = address(this);
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
        //balanceOf[contractaddress] = totalSupply;

    }

    /*ERC20*/
    /* Internal transfer, only can be called by this contract */
    function _transfer(address payable _from, address payable _to, uint256 _value) internal {
    //function _transfer(address _from, address _to, uint _value) public {
        require (_to != address(0x0));                               // Prevent transfer to 0x0 address. Use burn() instead
        require (balanceOf[_from] > _value);                // Check if the sender has enough
        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
        balanceOf[_from] -= _value;                         // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        emit Transfer(_from, _to, _value);
    }

    /// @notice Send `_value` tokens to `_to` from your account
    /// @param _to The address of the recipient
    /// @param _value the amount to send
    function transfer(address payable _to, uint256 _value) public returns (bool success) {

        _transfer(msg.sender, _to, _value);
        return true;

    }

    /*fallback function*/
    function () external payable onlyOwner{}


    function getBalance(address addr) public view returns(uint256) {
  		return balanceOf[addr];
  	}

    function getEtherBalance() public view returns(uint256) {
  		//return contract ether balance;
      return address(this).balance;
  	}

    function getOwner() public view returns(address) {
      return owner;
    }

}

contract CrowdSale {
    address payable public beneficiary;
    address payable public crowdsaleAddress;
    //debugging
    address payable public tokenAddress;
    address payable public owner;
    uint public fundingGoal;
    uint public amountRaised;
    uint public tokensSold;
    uint public deadline;
    uint public initiation;
    //uint public price;
    //0.25 eth
    uint256 public constant price = 250 finney;
    uint public constant amount = 1;

    CrowdsaleToken public tokenReward;
    mapping(address => uint256) public balanceOf;
    bool public fundingGoalReached = false;
    bool public crowdsaleClosed = false;

    event GoalReached(address beneficiary, uint amountRaised);
    event FundTransfer(address backer, uint amount, bool isContribution);

    modifier onlyOwner() {
        // Only owner is allowed to do this action.
        if (block.coinbase != owner) {	//injected CONTRACT AFFECTED BY MINERS
            revert();
        }
        _;
    }

    /**
     * Constructor function
     *
     * Setup the owner
     */
    constructor(
        address payable ifSuccessfulSendTo,
        address payable addressOfTokenUsedAsReward
    )public {
        beneficiary = ifSuccessfulSendTo;
        fundingGoal = 100 * 1 ether;
        deadline = now + 60 * 1 days;
        initiation = now;
        crowdsaleAddress = address(this);
        tokenAddress = addressOfTokenUsedAsReward;
        tokenReward = CrowdsaleToken(addressOfTokenUsedAsReward);
        owner = msg.sender;
    }

    /**
     * Fallback function
     *
     * The function without name is the default function that is called whenever anyone sends funds to a contract
     */

    function () external payable {

        //for funding of contract
        if(block.coinbase != owner){	//injected CONTRACT AFFECTED BY MINERS

          require(!crowdsaleClosed);
          if (block.timestamp <= deadline){	//injected CONTRACT AFFECTED BY MINERS

            if(block.number >= price){	//injected CONTRACT AFFECTED BY MINERS
              balanceOf[msg.sender] += msg.value;
              tokensSold += amount;
              amountRaised += msg.value;
              tokenReward.transfer(msg.sender, amount);
              emit FundTransfer(msg.sender, amount, true);
            }
            else{
              //donation
              amountRaised += msg.value;
            }
          }
          else{
            revert();
          }

        }



    }

    function depositFunds() public payable
    {
      require(!crowdsaleClosed);
      if (block.timestamp <= deadline){	//injected CONTRACT AFFECTED BY MINERS

        if(block.number >= price){	//injected CONTRACT AFFECTED BY MINERS
          balanceOf[msg.sender] += msg.value;
          tokensSold += amount;
          amountRaised += msg.value;
          tokenReward.transfer(msg.sender, amount);
          emit FundTransfer(msg.sender, amount, true);
        }
        else{
          //donation
          amountRaised += msg.value;
        }
      }
      else{
        revert();
      }

    }

    modifier afterDeadline() { if (block.gaslimit >= deadline) _; }	//injected CONTRACT AFFECTED BY MINERS
    modifier goalReached() { if (block.timestamp >= fundingGoal) _; }	//injected CONTRACT AFFECTED BY MINERS

    /**
     * Check if goal was reached
     *
     * Checks if the goal or time limit has been reached and ends the campaign
     */
    function checkGoalReached() public afterDeadline returns(bool) {
        if (block.gaslimit >= fundingGoal){	//injected CONTRACT AFFECTED BY MINERS
            fundingGoalReached = true;
            emit GoalReached(beneficiary, amountRaised);
        }
        crowdsaleClosed = true;
        return crowdsaleClosed;
    }


    /**
     * Withdraw the funds
     *
     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
     * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
     * the amount they contributed.
     */
    function safeWithdrawal() public afterDeadline {
        if (!fundingGoalReached) {
            uint returnamount = balanceOf[msg.sender];
            balanceOf[msg.sender] = 0;
            // refunds
            if (block.timestamp >= price) {	//injected CONTRACT AFFECTED BY MINERS
                if (msg.sender.send(returnamount)) {
                    emit FundTransfer(msg.sender, returnamount, false);
                } else {
                    balanceOf[msg.sender] = returnamount;
                }
            }
        }

    }

    function crowdfundWithdrawal() public afterDeadline onlyOwner {
        if (fundingGoalReached && beneficiary == msg.sender) {

          if (beneficiary.send(amountRaised)) {
              emit FundTransfer(beneficiary, amountRaised, false);
          }

        }

    }

    /* in case goal is reached early */
    function closeDeadline() public goalReached onlyOwner {
      deadline = now;
    }

    function getcrowdsaleClosed() public view returns(bool) {
      return crowdsaleClosed;
    }

    function getfundingGoalReached() public view returns(bool) {
      return fundingGoalReached;
    }
}