/**
 *Submitted for verification at Etherscan.io on 2020-03-03
*/

pragma solidity ^0.5.16;

/*
	https://dragonETH.com
*/

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

 /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

 /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

 /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

 /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title Helps contracts guard agains reentrancy attacks.
 * @author Remco Bloemen <remco@21.com>
 * @notice If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {

  /**
   * @dev We use a single lock for the whole contract.
   */
  bool private reentrancyLock = false;

  /**
   * @dev Prevents a contract from calling itself, directly or indirectly.
   * @notice If you mark a function `nonReentrant`, you should also
   * mark it `external`. Calling one nonReentrant function from
   * another is not supported. Instead, you can implement a
   * `private` function doing the actual work, and a `external`
   * wrapper marked as `nonReentrant`.
   */
  modifier nonReentrant() {
    require(!reentrancyLock);
    reentrancyLock = true;
    _;
    reentrancyLock = false;
  }
}

/**
 * @title Roles
 * @author Francisco Giordano (@frangio)
 * @dev Library for managing addresses assigned to a Role.
 *      See RBAC.sol for example usage.
 */
library Roles {
  struct Role {
    mapping (address => bool) bearer;
  }

  /**
   * @dev give an address access to this role
   */
  function add(Role storage role, address addr)
    internal
  {
    role.bearer[addr] = true;
  }

  /**
   * @dev remove an address' access to this role
   */
  function remove(Role storage role, address addr)
    internal
  {
    role.bearer[addr] = false;
  }

  /**
   * @dev check if an address has this role
   * // reverts
   */
  function check(Role storage role, address addr)
    view
    internal
  {
    require(has(role, addr));
  }

  /**
   * @dev check if an address has this role
   * @return bool
   */
  function has(Role storage role, address addr)
    view
    internal
    returns (bool)
  {
    return role.bearer[addr];
  }
}

/**
 * @title RBAC (Role-Based Access Control)
 * @author Matt Condon (@Shrugs)
 * @dev Stores and provides setters and getters for roles and addresses.
 * @dev Supports unlimited numbers of roles and addresses.
 * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
 * This RBAC method uses strings to key roles. It may be beneficial
 *  for you to write your own implementation of this interface using Enums or similar.
 * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
 *  to avoid typos.
 */
contract RBAC {
  using Roles for Roles.Role;

  mapping (string => Roles.Role) private roles;

  event RoleAdded(address addr, string roleName);
  event RoleRemoved(address addr, string roleName);

  /**
   * @dev reverts if addr does not have role
   * @param addr address
   * @param roleName the name of the role
   * // reverts
   */
  function checkRole(address addr, string memory roleName)
    view
    public
  {
    roles[roleName].check(addr);
  }

  /**
   * @dev determine if addr has role
   * @param addr address
   * @param roleName the name of the role
   * @return bool
   */
  function hasRole(address addr, string memory roleName)
    view
    public
    returns (bool)
  {
    return roles[roleName].has(addr);
  }

  /**
   * @dev add a role to an address
   * @param addr address
   * @param roleName the name of the role
   */
  function addRole(address addr, string memory roleName)
    internal
  {
    roles[roleName].add(addr);
    emit RoleAdded(addr, roleName);
  }

  /**
   * @dev remove a role from an address
   * @param addr address
   * @param roleName the name of the role
   */
  function removeRole(address addr, string memory roleName)
    internal
  {
    roles[roleName].remove(addr);
    emit RoleRemoved(addr, roleName);
  }

  /**
   * @dev modifier to scope access to a single role (uses msg.sender as addr)
   * @param roleName the name of the role
   * // reverts
   */
  modifier onlyRole(string memory roleName)
  {
    checkRole(msg.sender, roleName);
    _;
  }

}

/**
 * @title RBACWithAdmin
 * @author Matt Condon (@Shrugs)
 * @dev It's recommended that you define constants in the contract,
 * @dev like ROLE_ADMIN below, to avoid typos.
 */
contract RBACWithAdmin is RBAC { // , DESTROYER {
  /**
   * A constant role name for indicating admins.
   */
  string public constant ROLE_ADMIN = "admin";
  string public constant ROLE_PAUSE_ADMIN = "pauseAdmin";

  /**
   * @dev modifier to scope access to admins
   * // reverts
   */
  modifier onlyAdmin()
  {
    checkRole(msg.sender, ROLE_ADMIN);
    _;
  }
  modifier onlyPauseAdmin()
  {
    checkRole(msg.sender, ROLE_PAUSE_ADMIN);
    _;
  }
  /**
   * @dev constructor. Sets msg.sender as admin by default
   */
  constructor()
    public
  {
    addRole(msg.sender, ROLE_ADMIN);
    addRole(msg.sender, ROLE_PAUSE_ADMIN);
  }

  /**
   * @dev add a role to an address
   * @param addr address
   * @param roleName the name of the role
   */
  function adminAddRole(address addr, string memory roleName)
    onlyAdmin
    public
  {
    addRole(addr, roleName);
  }

  /**
   * @dev remove a role from an address
   * @param addr address
   * @param roleName the name of the role
   */
  function adminRemoveRole(address addr, string memory roleName)
    onlyAdmin
    public
  {
    removeRole(addr, roleName);
  }
}

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is RBACWithAdmin {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyPauseAdmin whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyPauseAdmin whenPaused public {
    paused = false;
    emit Unpause();
  }
}

contract DragonsETH {
    struct Dragon {
        uint256 gen1;
        uint8 stage; // 0 - Dead, 1 - Egg, 2 - Young Dragon 
        uint8 currentAction; // 0 - free, 1 - fight place, 0xFF - Necropolis,  2 - random fight,
                             // 3 - breed market, 4 - breed auction, 5 - random breed, 6 - market place ...
        uint240 gen2;
        uint256 nextBlock2Action;
    }
    Dragon[] public dragons;
    
    function ownerOf(uint256 _tokenId) public view returns (address);
    function checkDragonStatus(uint256 _dragonID, uint8 _stage) public view;
    function setCurrentAction(uint256 _dragonID, uint8 _currentAction) external;
    function setTime2Rest(uint256 _dragonID, uint256 _addNextBlock2Action) external;
    function isApprovedOrOwner(address _spender, uint256 _tokenId) public view returns (bool);
}

contract DragonsFight {
    function getWinner(uint256 _dragonOneID, uint256 _dragonTwoID) external returns (uint256 _winerID);
}

contract DragonsStats {
    function incFightWin(uint256 _dragonID) external;
    function incFightLose(uint256 _dragonID) external;
    function setLastAction(uint256 _dragonID, uint256 _lastActionDragonID, uint8 _lastActionID) external;
}

contract Mutagen {
    function mint(address _to, uint256 _amount)  public returns (bool);
}

contract DragonsFightGC is Pausable {
    Mutagen public mutagenContract;
    DragonsETH public mainContract;
    DragonsFight public dragonsFightContract;
    DragonsStats public dragonsStatsContract;
    address payable wallet;
    uint256 public mutagenToWin = 10;
    uint256 public mutagenToLose =1;
    uint256 public addTime2Rest = 240; // ~ 60 min
    
    event FightFP(uint256 _winnerId, uint256 _loserId, address indexed _ownerWinner, address indexed _onwerLoser);
    event AddDragonFP(address indexed _from, uint256 _tokenId);
    event RemoveDragonFP(address indexed _from, uint256 _tokenId);
    
 
    function changeAddressMutagenContract(address _newAddress) external onlyAdmin {
        mutagenContract = Mutagen(_newAddress);
    }
    function changeAddressMainContract(address _newAddress) external onlyAdmin {
        mainContract = DragonsETH(_newAddress);
    }
    function changeAddressFightContract(address _newAddress) external onlyAdmin {
        dragonsFightContract = DragonsFight(_newAddress);
    }
    function changeAddressStatsContract(address _newAddress) external onlyAdmin {
        dragonsStatsContract = DragonsStats(_newAddress);
    }
    function changeWallet(address payable _wallet) external onlyAdmin {
        wallet = _wallet;
    }
    function changeMutagenToWin(uint256 _mutagenToWin) external onlyAdmin {
        mutagenToWin = _mutagenToWin;
    }
    
    function changeMutagenToLose(uint256 _mutagenToLose) external onlyAdmin {
        mutagenToLose = _mutagenToLose;
    }
    function changeAddTime2Rest(uint256 _addTime2Rest) external onlyAdmin {
        addTime2Rest = _addTime2Rest;
    }
    function withdrawAllEther() external onlyAdmin {
        require(wallet != address(0), "Withdraw address can't be zero!");
        wallet.transfer(0);
    }
}

contract DragonsFightPlace is DragonsFightGC, ReentrancyGuard {
    using SafeMath for uint256;
    uint256 public priceToFight = 0.001 ether; // price for test
    uint256 public priceToAdd = 0.0001 ether;  // price for test
    mapping(uint256 => address) dragonOwners;
    mapping(address => uint256) public ownerDragonsCount;
    mapping(uint256 => uint256) public dragonsListIndex;
    uint256[] public dragonsList;
    
    
    constructor(address payable _wallet) public {
        wallet = _wallet;
    }

    
    function addToFightPlace(uint256 _dragonID) external payable whenNotPaused nonReentrant {	//injected LOCKED ETHER
        require(mainContract.isApprovedOrOwner(msg.sender, _dragonID), "The sender is not an owner!");
        require(msg.value >= priceToAdd, "Not enough ether!");
        mainContract.checkDragonStatus(_dragonID, 2);
        uint256 valueToReturn = msg.value.sub(priceToAdd);
        if (priceToAdd != 0) {
            wallet.transfer(0);
        }
        
        if (valueToReturn != 0) {
            msg.sender.transfer(0);
        }
        dragonOwners[_dragonID] = mainContract.ownerOf(_dragonID);
        ownerDragonsCount[dragonOwners[_dragonID]]++;
        dragonsListIndex[_dragonID] = dragonsList.length;
        dragonsList.push(_dragonID);
        mainContract.setCurrentAction(_dragonID, 1);
        emit AddDragonFP(dragonOwners[_dragonID], _dragonID);
        
    }
    
    function delFromFightPlace(uint256 _dragonID) external {
        require(mainContract.isApprovedOrOwner(msg.sender, _dragonID), "Only the owner or approved address can do this!");
        emit RemoveDragonFP(dragonOwners[_dragonID], _dragonID);
        _delItem(_dragonID);
    }

    function fightWithDragon(uint256 _yourDragonID,uint256 _thisDragonID) external payable whenNotPaused nonReentrant {	//injected LOCKED ETHER
        require(msg.value >= priceToFight, "Not enough ether!");
        require(mainContract.isApprovedOrOwner(msg.sender, _yourDragonID), "The sender is not an owner!");
        uint8 stage;
        uint8 currentAction;
        uint256 nextBlock2Action;
        (,stage,currentAction,,nextBlock2Action) = mainContract.dragons(_yourDragonID);
        require(stage >= 2, "No eggs, No dead dragons!");
        require(nextBlock2Action <= block.number, "Dragon is resting!");
        require(currentAction == 0 || currentAction == 1, "Dragon is busy!");
        uint256 valueToReturn = msg.value - priceToFight;
        if (priceToFight != 0) {
            wallet.transfer(0);
        }
        if (valueToReturn != 0) {
            msg.sender.transfer(0);
        }
        if (dragonsFightContract.getWinner(_yourDragonID, _thisDragonID) == _yourDragonID ) {
            _setFightResult(_yourDragonID, _thisDragonID);
            _closeFight(_yourDragonID, _thisDragonID);
            emit FightFP(_yourDragonID, _thisDragonID, mainContract.ownerOf(_yourDragonID), dragonOwners[_thisDragonID]);
        } else {
            _setFightResult(_thisDragonID, _yourDragonID);
            _closeFight(_thisDragonID, _yourDragonID);
            emit FightFP(_thisDragonID, _yourDragonID, dragonOwners[_thisDragonID], mainContract.ownerOf(_yourDragonID));
        }
        _delItem(_thisDragonID);
        if (dragonOwners[_yourDragonID] != address(0))
            _delItem(_yourDragonID);
    }
    function getAllDragonsFight() external view returns(uint256[] memory) {
        return dragonsList;
    }
    function getSlicedDragonsSale(uint256 _firstIndex, uint256 _aboveLastIndex) external view returns(uint256[] memory) {
        require(_firstIndex < dragonsList.length, "First index greater than totalDragonsToFight!");
        uint256 lastIndex = _aboveLastIndex;
        if (_aboveLastIndex > dragonsList.length) lastIndex = dragonsList.length;
        require(_firstIndex <= lastIndex, "First index greater than last!");
        uint256 resultCount = lastIndex - _firstIndex;
        if (resultCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](resultCount);
            uint256 _dragonIndex;
            uint256 _resultIndex = 0;

            for (_dragonIndex = _firstIndex; _dragonIndex < lastIndex; _dragonIndex++) {
                result[_resultIndex] = dragonsList[_dragonIndex];
                _resultIndex++;
            }

            return result;
        }
    }
    function getFewDragons(uint256[] calldata _dragonIDs) external view returns(uint256[] memory) {
        uint256 dragonCount = _dragonIDs.length;
        if (dragonCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](dragonCount * 3);
            uint256 resultIndex = 0;

            for (uint256 dragonIndex = 0; dragonIndex < dragonCount; dragonIndex++) {
                uint256 dragonID = _dragonIDs[dragonIndex];
                if (dragonOwners[dragonID] == address(0))
                    continue;
                result[resultIndex++] = dragonID;
                uint8 dragonStage;
                (,dragonStage,,,) = mainContract.dragons(dragonID);
                result[resultIndex++] = uint256(dragonStage);
                result[resultIndex++] = uint256(dragonOwners[dragonID]);
            }
            return result; 
        }
    }
    function getAddressDragons(address _owner) external view returns(uint256[] memory) {
        uint256 dragonCount = ownerDragonsCount[_owner];
        if (dragonCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](dragonCount * 2);
            uint256 resultIndex = 0;

            for (uint256 dragonIndex = 0; dragonIndex < dragonsList.length; dragonIndex++) {
                uint256 dragonID = dragonsList[dragonIndex];
                if (_owner != dragonOwners[dragonID])
                    continue;
                result[resultIndex++] = dragonID;
                uint8 dragonStage;
                (,dragonStage,,,) = mainContract.dragons(dragonID);
                result[resultIndex++] = uint256(dragonStage);
            }
            return result; 
        }
    }
    function totalDragonsToFight() external view returns(uint256) {
        return dragonsList.length;
    }
    function _delItem(uint256 _dragonID) private {
        require(dragonOwners[_dragonID] != address(0), "An attempt to remove an unregistered dragon!");
        mainContract.setCurrentAction(_dragonID, 0);
        ownerDragonsCount[dragonOwners[_dragonID]]--;
        delete(dragonOwners[_dragonID]);
        if (dragonsList.length - 1 != dragonsListIndex[_dragonID]) {
            dragonsList[dragonsListIndex[_dragonID]] = dragonsList[dragonsList.length - 1];
            dragonsListIndex[dragonsList[dragonsList.length - 1]] = dragonsListIndex[_dragonID];
        }
        dragonsList.length--;
        delete(dragonsListIndex[_dragonID]);
    }
    function _setFightResult(uint256 _dragonWin, uint256 _dragonLose) private {
        dragonsStatsContract.incFightWin(_dragonWin);
        dragonsStatsContract.incFightLose(_dragonLose);
        dragonsStatsContract.setLastAction(_dragonWin, _dragonLose, 13);
        dragonsStatsContract.setLastAction(_dragonLose, _dragonWin, 14);
    }
    function _closeFight(uint256 _dragonWin, uint256 _dragonLose) private {
        mainContract.setTime2Rest(_dragonWin, addTime2Rest);
        mainContract.setTime2Rest(_dragonLose, addTime2Rest);
        mutagenContract.mint(mainContract.ownerOf(_dragonWin), mutagenToWin);
        mutagenContract.mint(mainContract.ownerOf(_dragonLose), mutagenToLose);
    }
    function clearFightPlace(uint256[] calldata _dragonIDs) external onlyAdmin whenPaused {
        uint256 dragonCount = _dragonIDs.length;
        for (uint256 dragonIndex = 0; dragonIndex < dragonCount; dragonIndex++) {
            uint256 dragonID = _dragonIDs[dragonIndex];
            if (dragonOwners[dragonID] != address(0))
                _delItem(dragonID);
        }
    }
    function changePrices(uint256 _priceToFight,uint256 _priceToAdd) external onlyAdmin {
        priceToFight = _priceToFight;
        priceToAdd = _priceToAdd;
    }
}