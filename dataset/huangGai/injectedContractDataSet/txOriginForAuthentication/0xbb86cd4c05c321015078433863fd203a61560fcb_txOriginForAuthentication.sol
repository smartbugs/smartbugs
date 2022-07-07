/**
 *Submitted for verification at Etherscan.io on 2020-02-14
*/

pragma solidity 0.5.0;

contract Gruppa_Istoricheskiy_Roman {


    mapping (address => uint) contributions;
    uint totalContributors;     // TOTAL COUNT OF CONTRIBUTORS
    uint goal;                  // AMOUNT NEEDS TO BE RAISED
    uint raisedAmount;          // AMOUNT RAISED
    uint totalSentToGruppa;     // TOTAL AMOUNT TRANSFERRED IN ALL ROUNDS
    address Owner;              // PROJECT OWNER
    address payable recepientAddress;
    bool uje_sobrali;
    bool paid;

    address[] refund;
    address[] addresses;

    constructor (uint _goal) public {
        
        goal = _goal;
        raisedAmount = 0;
        Owner = msg.sender;
        recepientAddress = 0x7B43e50058Da1565806e946A7d93c6beD14F75ed;
        goal = 0.1 ether; //AMOUNT NEEEDED
        totalSentToGruppa = 0;
    
    }
    
    
    function donate() public payable  {
        require(msg.value >= 0.01 ether, "Send at least 0.001 Ether");
        if(contributions[msg.sender] == 0) {
            totalContributors++;
        }
        contributions[msg.sender] += msg.value;
        raisedAmount += msg.value;
   
    }
    
    function getRefund() public payable {
        require(contributions[msg.sender] > 0);
        msg.sender.transfer(contributions[msg.sender]);
        raisedAmount -= contributions[msg.sender];
        contributions[msg.sender] = 0;
        totalContributors -= 1;
        
    }
    
    function send_funds_to_Gruppa_Istoricheskiy_Roman() public payable {
        require(raisedAmount >= goal);
        recepientAddress.transfer(raisedAmount);
        paid == true;
        totalSentToGruppa += raisedAmount;
        raisedAmount = 0;
        }
    
    
    function skolko_nado_sobrat() public view returns (uint) {
    return goal;
    }
    
    function skolko_uje_sobrali() public view returns (uint) {
    return raisedAmount;
    }
    
    function skolkoVsegoOtpravleno() public view returns (uint) {
    return totalSentToGruppa;
    }
    
    
    function skolko_chelovek_skinulis() public view returns (uint) {
    return totalContributors;
    }
    
    function uje_sobrali_li() public view returns (bool) {
        if(raisedAmount >= goal){
            return true;
        }
        else return false;
    }
    
    function kill() public onlyOwner {
    selfdestruct(msg.sender);
    }
    
    modifier onlyOwner {
        require(tx.origin == Owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }
 
}