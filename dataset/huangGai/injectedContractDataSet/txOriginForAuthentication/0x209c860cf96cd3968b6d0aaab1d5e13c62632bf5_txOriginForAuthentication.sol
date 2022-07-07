pragma solidity ^0.5.0;

/** 
  * @title Remember Jeju 4.3 Tragedy 
  * @author Sooyoung Hyun
  * @notice You can use this contract to create online memorial database based on smart contracts.
  * @dev For more implementation details read the "README.md" document. 
  */
contract Remember43 {
    
    mapping(uint16 => Victim) public victims;
    mapping(address => bool) public isContributor;
    
    uint16 public victimsCount;
    address owner;
    uint timeout = 20 minutes;
    
    modifier onlyOwner {
        require(owner == tx.origin);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }
    
    modifier onlyContributor {
        require(isContributor[msg.sender]);
        _;
    }
    
    struct Victim {
        uint16 idx;
        string name;
        string addr;
        uint createTime;
    }
    
    event contributorSet(address indexed contributor, bool state);
    event victimAdded(uint16 idx, string name, string addr, uint createTime);
    event victimModified(uint16 idx, string name, string addr, uint createTime);

    constructor() public {
        owner = msg.sender;
    }
    
    /**
      * @notice Set contributor's state true or false.
      * @dev Only owner can use this function to change contributor's state. 
      * @param _addr User address for updating state.
      * @param _state True or false for updating state.
      */
    function setContributor(address _addr, bool _state) onlyOwner public {
        isContributor[_addr] = _state;
        emit contributorSet(_addr, isContributor[_addr]);
    }
    
    /**
      * @notice Add victim to storage.
      * @dev Only owner and contributor can use this function to add victim to storage.
      * @param _name Name of victim.
      * @param _addr Local address of victim.
      */
    function addVictim(string memory _name, string memory _addr) onlyContributor public {
        victimsCount++;
        Victim memory vt = Victim(victimsCount, _name, _addr, now);
        victims[victimsCount] = vt;
        emit victimAdded(victims[victimsCount].idx, victims[victimsCount].name, victims[victimsCount].addr, victims[victimsCount].createTime);
    }
    
    /**
      * @notice Get victim infomation.
      * @dev Function used in frontend to get the user infomation.
      * @param _idx Request index for providing infomation.  
      * @return _idx User index of requests.
      * @return vt.name User name of requests.
      * @return vt.addr User local address of requests.
      */
    function getVictim(uint16 _idx) public view returns(uint16, string memory, string memory) {
        Victim memory vt = victims[_idx]; 
        return (_idx, vt.name, vt.addr); 
    }
    
    /**
      * @notice Modify victim infomation.
      * @dev Only owner and contributor can use this function to modify victim infomation.
      * @dev It can be modified only within the time limit.
      * @param _idx Index of victim.
      * @param _name Name of victim.
      * @param _addr Local address of victim.
      */
    function modifyVictim(uint16 _idx, string memory _name, string memory _addr) onlyContributor public {
        require(victims[_idx].createTime + timeout > now);
        victims[_idx].name = _name;
        victims[_idx].addr = _addr;
        emit victimModified(victims[_idx].idx, victims[_idx].name, victims[_idx].addr, victims[_idx].createTime);
        
    }
}