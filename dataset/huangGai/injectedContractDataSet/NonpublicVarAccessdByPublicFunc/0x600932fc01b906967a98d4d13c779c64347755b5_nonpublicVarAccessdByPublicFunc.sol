/**
 *Submitted for verification at Etherscan.io on 2020-06-10
*/

pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;
/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */

 // solium-disable-line no-experimental


/**
 * Copyright (c) 2018-present, Leap DAO (leapdao.org)
 *
 * This source code is licensed under the Mozilla Public License, version 2,
 * found in the LICENSE file in the root directory of this source tree.
 */


 // solium-disable-line no-experimental


interface IColony {

  struct Payment {
    address payable recipient;
    bool finalized;
    uint256 fundingPotId;
    uint256 domainId;
    uint256[] skills;
  }

  // Implemented in ColonyPayment.sol
  /// @notice Add a new payment in the colony. Secured function to authorised members.
  /// @param _permissionDomainId The domainId in which I have the permission to take this action
  /// @param _childSkillIndex The index that the `_domainId` is relative to `_permissionDomainId`,
  /// (only used if `_permissionDomainId` is different to `_domainId`)
  /// @param _recipient Address of the payment recipient
  /// @param _token Address of the token, `0x0` value indicates Ether
  /// @param _amount Payout amount
  /// @param _domainId The domain where the payment belongs
  /// @param _skillId The skill associated with the payment
  /// @return paymentId Identifier of the newly created payment
  function addPayment(
    uint256 _permissionDomainId,
    uint256 _childSkillIndex,
    address payable _recipient,
    address _token,
    uint256 _amount,
    uint256 _domainId,
    uint256 _skillId)
    external returns (uint256 paymentId);

  /// @notice Returns an exiting payment.
  /// @param _id Payment identifier
  /// @return payment The Payment data structure
  function getPayment(uint256 _id) external view returns (Payment memory payment);

  /// @notice Move a given amount: `_amount` of `_token` funds from funding pot with id `_fromPot` to one with id `_toPot`.
  /// @param _permissionDomainId The domainId in which I have the permission to take this action
  /// @param _fromChildSkillIndex The child index in `_permissionDomainId` where we can find the domain for `_fromPotId`
  /// @param _toChildSkillIndex The child index in `_permissionDomainId` where we can find the domain for `_toPotId`
  /// @param _fromPot Funding pot id providing the funds
  /// @param _toPot Funding pot id receiving the funds
  /// @param _amount Amount of funds
  /// @param _token Address of the token, `0x0` value indicates Ether
  function moveFundsBetweenPots(
    uint256 _permissionDomainId,
    uint256 _fromChildSkillIndex,
    uint256 _toChildSkillIndex,
    uint256 _fromPot,
    uint256 _toPot,
    uint256 _amount,
    address _token
    ) external;

  /// @notice Finalizes the payment and logs the reputation log updates.
  /// Allowed to be called once after payment is fully funded. Secured function to authorised members.
  /// @param _permissionDomainId The domainId in which I have the permission to take this action
  /// @param _childSkillIndex The index that the `_domainId` is relative to `_permissionDomainId`
  /// @param _id Payment identifier
  function finalizePayment(uint256 _permissionDomainId, uint256 _childSkillIndex, uint256 _id) external;

  /// @notice Claim the payout in `_token` denomination for payment `_id`. Here the network receives its fee from each payout.
  /// Same as for tasks, ether fees go straight to the Meta Colony whereas Token fees go to the Network to be auctioned off.
  /// @param _id Payment identifier
  /// @param _token Address of the token, `0x0` value indicates Ether
  function claimPayment(uint256 _id, address _token) external;
}
/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev give an account access to this role
     */
    function add(Role storage role, address account) internal {
        require(account != address(0));
        require(!has(role, account));

        role.bearer[account] = true;
    }

    /**
     * @dev remove an account's access to this role
     */
    function remove(Role storage role, address account) internal {
        require(account != address(0));
        require(has(role, account));

        role.bearer[account] = false;
    }

    /**
     * @dev check if an account has this role
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0));
        return role.bearer[account];
    }
}

/**
 * @title WhitelistAdminRole
 * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
 */
contract WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistAdminAdded(address indexed account);
    event WhitelistAdminRemoved(address indexed account);

    Roles.Role private _whitelistAdmins;

    constructor () internal {
        _addWhitelistAdmin(msg.sender);
    }

    modifier onlyWhitelistAdmin() {
        require(isWhitelistAdmin(msg.sender));
        _;
    }

    function isWhitelistAdmin(address account) public view returns (bool) {
        return _whitelistAdmins.has(account);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
        _addWhitelistAdmin(account);
    }

    function renounceWhitelistAdmin() public {
        _removeWhitelistAdmin(msg.sender);
    }

    function _addWhitelistAdmin(address account) internal {
        _whitelistAdmins.add(account);
        emit WhitelistAdminAdded(account);
    }

    function _removeWhitelistAdmin(address account) internal {
        _whitelistAdmins.remove(account);
        emit WhitelistAdminRemoved(account);
    }
}

/**
 * @title WhitelistedRole
 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Whitelisteds themselves.
 */
contract WhitelistedRole is WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistedAdded(address indexed account);
    event WhitelistedRemoved(address indexed account);

    Roles.Role private _whitelisteds;

    modifier onlyWhitelisted() {
        require(isWhitelisted(msg.sender));
        _;
    }

    function isWhitelisted(address account) public view returns (bool) {
        return _whitelisteds.has(account);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function addWhitelisted(address account) public onlyWhitelistAdmin {
        _addWhitelisted(account);
    }

    function removeWhitelisted(address account) public onlyWhitelistAdmin {
        _removeWhitelisted(account);
    }

    function renounceWhitelisted() public {
        _removeWhitelisted(msg.sender);
    }

    function _addWhitelisted(address account) internal {
        _whitelisteds.add(account);
        emit WhitelistedAdded(account);
    }

    function _removeWhitelisted(address account) internal {
        _whitelisteds.remove(account);
        emit WhitelistedRemoved(account);
    }
}
/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract BountyPayout is WhitelistedRole {

  uint256 constant DAI_DECIMALS = 10^18;
  uint256 constant PERMISSION_DOMAIN_ID = 1;
  uint256 constant CHILD_SKILL_INDEX = 0;
  uint256 constant DOMAIN_ID = 1;
  uint256 constant SKILL_ID = 0;

  address public colonyAddr;
  address public daiAddr;
  address public leapAddr;

  enum PayoutType { Gardener, Worker, Reviewer }
  event Payout(
    bytes32 indexed bountyId,
    PayoutType indexed payoutType,
    address indexed recipient,
    uint256 amount,
    uint256 paymentId
  );

  constructor(
    address _colonyAddr,
    address _daiAddr,
    address _leapAddr) public {
    colonyAddr = _colonyAddr;
    daiAddr = _daiAddr;
    leapAddr = _leapAddr;
  }

  modifier refundGasCost() {
    uint remainingGasStart = gasleft();

    _;

    if (msg.value > 0) {
      uint remainingGasEnd = gasleft();
      uint usedGas = remainingGasStart - remainingGasEnd;
      // markup for transfers and whatnot
      usedGas += 66000;
      // Possibly need to check max gasprice and usedGas here to limit possibility for abuse.
      uint gasCost = usedGas * tx.gasprice;
      // Refund gas cost
      tx.origin.transfer(gasCost); // solium-disable-line security/no-tx-origin
      // send the rest back
      msg.sender.transfer(msg.value - gasCost);
    }
  }

  /**
  * Pays out a bounty to the different roles of a bounty
  *
  * @dev This contract should have enough allowance of daiAddr from payerAddr
  * @dev This colony contract should have enough LEAP in its funding pot
  * @param _gardener DAI amount to pay gardner and gardener wallet address
  * @param _worker DAI amount to pay worker and worker wallet address
  * @param _reviewer DAI amount to pay reviewer and reviewer wallet address
  */
  function payout(
    bytes32 _gardener,
    bytes32 _worker,
    bytes32 _reviewer,
    bytes32 _bountyId
  ) public payable onlyWhitelisted refundGasCost {
    _payout(
      address(bytes20(_gardener)),
      uint96(uint256(_gardener)),
      address(bytes20(_worker)),
      uint96(uint256(_worker)),
      address(bytes20(_reviewer)),
      uint96(uint256(_reviewer)),
      _bountyId
    );
  }

  function payoutReviewedDelivery(
    bytes32 _gardener,
    bytes32 _reviewer,
    bytes32 _bountyId
  ) public payable onlyWhitelisted refundGasCost {
    _payout(
      address(bytes20(_gardener)),
      uint96(uint256(_gardener)),
      address(bytes20(_gardener)),
      0,
      address(bytes20(_reviewer)),
      uint96(uint256(_reviewer)),
      _bountyId
    );
  }

  function payoutNoReviewer(
    bytes32 _gardener,
    bytes32 _worker,
    bytes32 _bountyId
  ) public payable onlyWhitelisted refundGasCost {
    _payout(
      address(bytes20(_gardener)),
      uint96(uint256(_gardener)),
      address(bytes20(_worker)),
      uint96(uint256(_worker)),
      address(bytes20(_gardener)),
      0,
      _bountyId
    );
  }

  function _isRepOnly(uint256 amount) internal returns (bool) {
    return ((amount & 0x01) == 1);
  }

  function _makeColonyPayment(
    address payable _worker,
    uint256 _amount
  ) internal returns (uint256) {

    IColony colony = IColony(colonyAddr);
    // Add a new payment
    uint256 paymentId = colony.addPayment(
      PERMISSION_DOMAIN_ID,
      CHILD_SKILL_INDEX,
      _worker,
      leapAddr,
      _amount,
      DOMAIN_ID,
      SKILL_ID
    );
    IColony.Payment memory payment = colony.getPayment(paymentId);

    // Fund the payment
    colony.moveFundsBetweenPots(
      1, // Root domain always 1
      0, // Not used, this extension contract must have funding permission in the root for this function to work
      CHILD_SKILL_INDEX,
      1, // Root domain funding pot is always 1
      payment.fundingPotId,
      _amount,
      leapAddr
    );
    colony.finalizePayment(PERMISSION_DOMAIN_ID, CHILD_SKILL_INDEX, paymentId);

    // Claim payout on behalf of the recipient
    colony.claimPayment(paymentId, leapAddr);
    return paymentId;
  }

  function _payout(
    address payable _gardenerAddr,
    uint256 _gardenerDaiAmount,
    address payable _workerAddr,
    uint256 _workerDaiAmount,
    address payable _reviewerAddr,
    uint256 _reviewerDaiAmount,
    bytes32 _bountyId
  ) internal {
    IERC20 dai = IERC20(daiAddr);

    // gardener worker
    // Why is a gardener share required?
    // Later we will hold a stake for gardeners, which will be handled here.
    require(_gardenerDaiAmount > DAI_DECIMALS, "gardener amount too small");
    uint256 paymentId = _makeColonyPayment(_gardenerAddr, _gardenerDaiAmount);
    if (!_isRepOnly(_gardenerDaiAmount)) {
      dai.transferFrom(msg.sender, _gardenerAddr, _gardenerDaiAmount);
    }
    // solium-disable-next-line arg-overflow
    emit Payout(_bountyId, PayoutType.Gardener, _gardenerAddr, _gardenerDaiAmount, paymentId);

    // handle worker
    if (_workerDaiAmount > 0) {
      paymentId = _makeColonyPayment(_workerAddr, _workerDaiAmount);
      if (!_isRepOnly(_workerDaiAmount)) {
        dai.transferFrom(msg.sender, _workerAddr, _workerDaiAmount);
      }
      // solium-disable-next-line arg-overflow
      emit Payout(_bountyId, PayoutType.Worker, _workerAddr, _workerDaiAmount, paymentId);
    }

    // handle reviewer
    if (_reviewerDaiAmount > 0) {
      paymentId = _makeColonyPayment(_reviewerAddr, _reviewerDaiAmount);
      if (!_isRepOnly(_reviewerDaiAmount)) {
        dai.transferFrom(msg.sender, _reviewerAddr, _reviewerDaiAmount);
      }
      // solium-disable-next-line arg-overflow
      emit Payout(_bountyId, PayoutType.Reviewer, _reviewerAddr, _reviewerDaiAmount, paymentId);
    }
  }

}