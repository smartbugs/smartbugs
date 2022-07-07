pragma solidity ^0.5.4;
contract Ownable {
  address payable public owner;
  event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {owner = msg.sender;}

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address payable _newOwner) public onlyOwner {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}
contract FrenchIco_Coprorate is Ownable {
    
    bool internal PauseAllContracts= false;
    uint public maxAmount;
    mapping(address => uint) internal role;
    
    event WhitelistedAddress(address addr, uint _role);

/** GENERAL STOPPABLE
  * All the Project are stoppable by the Company
  **/
 
    function GeneralPause() onlyOwner external {
        if (PauseAllContracts==false) {PauseAllContracts=true;}
        else {PauseAllContracts=false;}
    }
    
    function setupMaxAmount(uint _maxAmount) onlyOwner external {
        maxAmount = _maxAmount;
    }


/** ROLE ATTRIBUTION
     * @ Not registred = 0
     * @ STANDARD = 1
     * @ PREMIUM = 2
     * @ PREMIUM PRO = 3
      */   
   
    function RoleSetup(address addr, uint _role) onlyOwner public {
         role[addr]= _role;
         emit WhitelistedAddress(addr, _role);
      }
      
    function newMember() public payable {
         require (true,"user has to be new");
         role[msg.sender]= 1;
         owner.transfer(msg.value);
         emit WhitelistedAddress(msg.sender, 1);
      	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
      
/** USABLE BY EXTERNAL CONTRACT*/ 
	     
    function isGeneralPaused() external view returns (bool) {return PauseAllContracts;}
    function GetRole(address addr) external view returns (uint) {return role[addr];}
    function GetWallet_FRENCHICO() external view returns (address) {return owner;}
    function GetMaxAmount() external view returns (uint) {return maxAmount;}

}