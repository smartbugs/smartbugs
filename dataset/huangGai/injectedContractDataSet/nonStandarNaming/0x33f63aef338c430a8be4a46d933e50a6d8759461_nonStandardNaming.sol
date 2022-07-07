                                                                 

pragma solidity 0.6.12;

// SPDX-License-Identifier: BSD-3-Clause

                                                                                                                                                                                  

                                                                                                                                                                                             
contract Ownable {
    address private _owner;
    address public pendingOwner;


    event OWNERSHIPTRANSFERRED622(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                                                           
    constructor () internal {
        _owner = msg.sender;
        emit OWNERSHIPTRANSFERRED622(address(0), _owner);
    }

                                                        
    function OWNER408() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER181() {	//inject NONSTANDARD NAMING
        require(ISOWNER686());
        _;
    }
    
                                                                             
  modifier ONLYPENDINGOWNER31() {	//inject NONSTANDARD NAMING
    assert(msg.sender != address(0));
    require(msg.sender == pendingOwner);
    _;
  }

                                                                                 
    function ISOWNER686() public view returns (bool) {	//inject NONSTANDARD NAMING
        return msg.sender == _owner;
    }

                                                                                                                                                               
  function TRANSFEROWNERSHIP398(address _newOwner) public ONLYOWNER181 {	//inject NONSTANDARD NAMING
    require(_newOwner != address(0));
    pendingOwner = _newOwner;
  }
  
                                                                               
  function CLAIMOWNERSHIP185() ONLYPENDINGOWNER31 public {	//inject NONSTANDARD NAMING
    _TRANSFEROWNERSHIP98(pendingOwner);
    pendingOwner = address(0);
  }

                                                                                                                                         
    function _TRANSFEROWNERSHIP98(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0));
        emit OWNERSHIPTRANSFERRED622(_owner, newOwner);
        _owner = newOwner;
    }
}

interface token {
    function TRANSFER674(address, uint) external returns (bool);	//inject NONSTANDARD NAMING
}

contract TokenLock is Ownable {
    

    address public constant beneficiary441 = 0x3E7e36f4Dd5394E48ce3D5dB86D71F062B18aE1B;	//inject NONSTANDARD NAMING

    
    // unlock timestamp in seconds (Oct 20 2020 UTC)
    uint public constant unlocktime159 = 1603152000;	//inject NONSTANDARD NAMING

    function ISUNLOCKED95() public view returns (bool) {	//inject NONSTANDARD NAMING
        return now > unlocktime159;
    }
    
    function CLAIM843(address _tokenAddr, uint _amount) public ONLYOWNER181 {	//inject NONSTANDARD NAMING
        require(ISUNLOCKED95(), "Cannot transfer tokens while locked.");
        token(_tokenAddr).TRANSFER674(beneficiary441, _amount);
    }
}