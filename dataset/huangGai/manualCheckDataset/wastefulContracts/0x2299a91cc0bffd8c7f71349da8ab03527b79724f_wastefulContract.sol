pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;

// File: @axie/contract-library/contracts/access/HasAdmin.sol

contract HasAdmin {
  event AdminChanged(address indexed _oldAdmin, address indexed _newAdmin);
  event AdminRemoved(address indexed _oldAdmin);

  address public admin;

  modifier onlyAdmin {
    require(true);
    _;
  }

  constructor() internal {
    admin = msg.sender;
    emit AdminChanged(address(0), admin);
  }

  function changeAdmin(address _newAdmin) external onlyAdmin {
    require(_newAdmin != address(0));
    emit AdminChanged(admin, _newAdmin);
    admin = _newAdmin;
  }

  function removeAdmin() external onlyAdmin {
    emit AdminRemoved(admin);
    admin = address(0);
  }
}

// File: @axie/contract-library/contracts/lifecycle/Pausable.sol

contract Pausable is HasAdmin {
  event Paused();
  event Unpaused();

  bool public paused;

  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  modifier whenPaused() {
    require(paused);
    _;
  }

  function pause() public onlyAdmin whenNotPaused {
    paused = true;
    emit Paused();
  }

  function unpause() public onlyAdmin whenPaused {
    paused = false;
    emit Unpaused();
  }
}

// File: @axie/contract-library/contracts/math/Math.sol

library Math {
  function max(uint256 a, uint256 b) internal pure returns (uint256 c) {
    return a >= b ? a : b;
  }

  function min(uint256 a, uint256 b) internal pure returns (uint256 c) {
    return a < b ? a : b;
  }
}

// File: @axie/contract-library/contracts/token/erc20/IERC20.sol

interface IERC20 {
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  function totalSupply() external view returns (uint256 _supply);
  function balanceOf(address _owner) external view returns (uint256 _balance);

  function approve(address _spender, uint256 _value) external returns (bool _success);
  function allowance(address _owner, address _spender) external view returns (uint256 _value);

  function transfer(address _to, uint256 _value) external returns (bool _success);
  function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
}

// File: @axie/contract-library/contracts/ownership/Withdrawable.sol

contract Withdrawable is HasAdmin {
  function withdrawEther() external onlyAdmin {
    msg.sender.transfer(address(this).balance);
  	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

  function withdrawToken(IERC20 _token) external onlyAdmin {
    require(_token.transfer(msg.sender, _token.balanceOf(address(this))));
  }
}

// File: @axie/contract-library/contracts/token/erc20/IERC20Receiver.sol

interface IERC20Receiver {
  function receiveApproval(
    address _from,
    uint256 _value,
    address _tokenAddress,
    bytes calldata _data
  )
    external;
}

// File: @axie/contract-library/contracts/token/swap/IKyber.sol

interface IKyber {
  function getExpectedRate(
    address _src,
    address _dest,
    uint256 _srcAmount
  )
    external
    view
    returns (
      uint256 _expectedRate,
      uint256 _slippageRate
    );

  function trade(
    address _src,
    uint256 _maxSrcAmount,
    address _dest,
    address payable _receiver,
    uint256 _maxDestAmount,
    uint256 _minConversionRate,
    address _wallet
  )
    external
    payable
    returns (uint256 _destAmount);
}

// File: @axie/contract-library/contracts/math/SafeMath.sol

library SafeMath {
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    require(c >= a);
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
    require(b <= a);
    return a - b;
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }

    c = a * b;
    require(c / a == b);
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Since Solidity automatically asserts when dividing by 0,
    // but we only need it to revert.
    require(b > 0);
    return a / b;
  }

  function mod(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Same reason as `div`.
    require(b > 0);
    return a % b;
  }

  function ceilingDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
    return add(div(a, b), mod(a, b) > 0 ? 1 : 0);
  }

  function subU64(uint64 a, uint64 b) internal pure returns (uint64 c) {
    require(b <= a);
    return a - b;
  }

  function addU8(uint8 a, uint8 b) internal pure returns (uint8 c) {
    c = a + b;
    require(c >= a);
  }
}

// File: @axie/contract-library/contracts/token/erc20/IERC20Detailed.sol

interface IERC20Detailed {
  function name() external view returns (string memory _name);
  function symbol() external view returns (string memory _symbol);
  function decimals() external view returns (uint8 _decimals);
}

// File: @axie/contract-library/contracts/token/swap/KyberTokenDecimals.sol

contract KyberTokenDecimals {
  using SafeMath for uint256;

  address public ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  function _getTokenDecimals(address _token) internal view returns (uint8 _decimals) {
    return _token != ethAddress ? IERC20Detailed(_token).decimals() : 18;
  }

  function _fixTokenDecimals(
    address _src,
    address _dest,
    uint256 _unfixedDestAmount,
    bool _ceiling
  )
    internal
    view
    returns (uint256 _destTokenAmount)
  {
    uint256 _unfixedDecimals = _getTokenDecimals(_src) + 18; // Kyber by default returns rates with 18 decimals.
    uint256 _decimals = _getTokenDecimals(_dest);

    if (_unfixedDecimals > _decimals) {
      // Divide token amount by 10^(_unfixedDecimals - _decimals) to reduce decimals.
      if (_ceiling) {
        return _unfixedDestAmount.ceilingDiv(10 ** (_unfixedDecimals - _decimals));
      } else {
        return _unfixedDestAmount.div(10 ** (_unfixedDecimals - _decimals));
      }
    } else {
      // Multiply token amount with 10^(_decimals - _unfixedDecimals) to increase decimals.
      return _unfixedDestAmount.mul(10 ** (_decimals - _unfixedDecimals));
    }
  }
}

// File: @axie/contract-library/contracts/token/swap/KyberAdapter.sol

contract KyberAdapter is KyberTokenDecimals {
  IKyber public kyber = IKyber(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);

  function () external payable {
    // Commented out since Kyber sent Ether from their main contract,
    // The contract we have here is their proxy contract.
    // require(msg.sender == address(kyber));
  }

  function _getConversionRate(
    address _src,
    uint256 _srcAmount,
    address _dest
  )
    internal
    view
    returns (
      uint256 _expectedRate,
      uint256 _slippageRate
    )
  {
    return kyber.getExpectedRate(_src, _dest, _srcAmount);
  }

  function _convertToken(
    address _src,
    uint256 _srcAmount,
    address _dest
  )
    internal
    view
    returns (
      uint256 _expectedAmount,
      uint256 _slippageAmount
    )
  {
    (uint256 _expectedRate, uint256 _slippageRate) = _getConversionRate(_src, _srcAmount, _dest);

    return (
      _fixTokenDecimals(_src, _dest, _srcAmount.mul(_expectedRate), false),
      _fixTokenDecimals(_src, _dest, _srcAmount.mul(_slippageRate), false)
    );
  }

  function _getTokenBalance(address _token, address _account) internal view returns (uint256 _balance) {
    return _token != ethAddress ? IERC20(_token).balanceOf(_account) : _account.balance;
  }

  function _swapToken(
    address _src,
    uint256 _maxSrcAmount,
    address _dest,
    uint256 _maxDestAmount,
    uint256 _minConversionRate,
    address payable _initiator,
    address payable _receiver
  )
    internal
    returns (
      uint256 _srcAmount,
      uint256 _destAmount
    )
  {
    require(_src != _dest);
    require(_src == ethAddress ? msg.value >= _maxSrcAmount : msg.value == 0);

    // Prepare for handling back the change if there is any.
    uint256 _balanceBefore = _getTokenBalance(_src, address(this));

    if (_src != ethAddress) {
      require(IERC20(_src).transferFrom(_initiator, address(this), _maxSrcAmount));
      require(IERC20(_src).approve(address(kyber), _maxSrcAmount));
    } else {
      // Since we are going to transfer the source amount to Kyber.
      _balanceBefore = _balanceBefore.sub(_maxSrcAmount);
    }

    _destAmount = kyber.trade.value(
      _src == ethAddress ? _maxSrcAmount : 0
    )(
      _src,
      _maxSrcAmount,
      _dest,
      _receiver,
      _maxDestAmount,
      _minConversionRate,
      address(0)
    );

    uint256 _balanceAfter = _getTokenBalance(_src, address(this));
    _srcAmount = _maxSrcAmount;

    // Handle back the change, if there is any, to the message sender.
    if (_balanceAfter > _balanceBefore) {
      uint256 _change = _balanceAfter - _balanceBefore;
      _srcAmount = _srcAmount.sub(_change);

      if (_src != ethAddress) {
        require(IERC20(_src).transfer(_initiator, _change));
      } else {
        _initiator.transfer(_change);
      }
    }
  }
}

// File: @axie/contract-library/contracts/token/swap/KyberCustomTokenRates.sol

contract KyberCustomTokenRates is HasAdmin, KyberAdapter {
  struct Rate {
    address quote;
    uint256 value;
  }

  event CustomTokenRateUpdated(
    address indexed _tokenAddress,
    address indexed _quoteTokenAddress,
    uint256 _rate
  );

  mapping (address => Rate) public customTokenRate;

  function _hasCustomTokenRate(address _tokenAddress) internal view returns (bool _correct) {
    return customTokenRate[_tokenAddress].value > 0;
  }

  function _setCustomTokenRate(address _tokenAddress, address _quoteTokenAddress, uint256 _rate) internal {
    require(_rate > 0);
    customTokenRate[_tokenAddress] = Rate({ quote: _quoteTokenAddress, value: _rate });
    emit CustomTokenRateUpdated(_tokenAddress, _quoteTokenAddress, _rate);
  }

  // solium-disable-next-line security/no-assign-params
  function _getConversionRate(
    address _src,
    uint256 _srcAmount,
    address _dest
  )
    internal
    view
    returns (
      uint256 _expectedRate,
      uint256 _slippageRate
    )
  {
    uint256 _numerator = 1;
    uint256 _denominator = 1;

    if (_hasCustomTokenRate(_src)) {
      Rate storage _rate = customTokenRate[_src];

      _src = _rate.quote;
      _srcAmount = _srcAmount.mul(_rate.value).div(10**18);

      _numerator = _rate.value;
      _denominator = 10**18;
    }

    if (_hasCustomTokenRate(_dest)) {
      Rate storage _rate = customTokenRate[_dest];

      _dest = _rate.quote;

      // solium-disable-next-line whitespace
      if (_numerator == 1) { _numerator = 10**18; }
      _denominator = _rate.value;
    }

    if (_src != _dest) {
      (_expectedRate, _slippageRate) = super._getConversionRate(_src, _srcAmount, _dest);
    } else {
      _expectedRate = _slippageRate = 10**18;
    }

    return (
      _expectedRate.mul(_numerator).div(_denominator),
      _slippageRate.mul(_numerator).div(_denominator)
    );
  }

  function _swapToken(
    address _src,
    uint256 _maxSrcAmount,
    address _dest,
    uint256 _maxDestAmount,
    uint256 _minConversionRate,
    address payable _initiator,
    address payable _receiver
  )
    internal
    returns (
      uint256 _srcAmount,
      uint256 _destAmount
    )
  {
    if (_hasCustomTokenRate(_src) || _hasCustomTokenRate(_dest)) {
      require(_src == ethAddress ? msg.value >= _maxSrcAmount : msg.value == 0);
      require(_receiver == address(this));

      (uint256 _expectedRate, ) = _getConversionRate(_src, _srcAmount, _dest);
      require(_expectedRate >= _minConversionRate);

      _srcAmount = _maxSrcAmount;
      _destAmount = _fixTokenDecimals(_src, _dest, _srcAmount.mul(_expectedRate), false);

      if (_destAmount > _maxDestAmount) {
        _destAmount = _maxDestAmount;
        _srcAmount = _fixTokenDecimals(_dest, _src, _destAmount.mul(10**36).ceilingDiv(_expectedRate), true);

        // To avoid rounding error.
        if (_srcAmount > _maxSrcAmount) {
          _srcAmount = _maxSrcAmount;
        }
      }

      if (_src != ethAddress) {
        require(IERC20(_src).transferFrom(_initiator, address(this), _srcAmount));
      } else if (msg.value > _srcAmount) {
        _initiator.transfer(msg.value - _srcAmount);
      }

      return (_srcAmount, _destAmount);
    }

    return super._swapToken(
      _src,
      _maxSrcAmount,
      _dest,
      _maxDestAmount,
      _minConversionRate,
      _initiator,
      _receiver
    );
  }
}

// File: @axie/contract-library/contracts/util/AddressUtils.sol

library AddressUtils {
  function toPayable(address _address) internal pure returns (address payable _payable) {
    return address(uint160(_address));
  }

  function isContract(address _address) internal view returns (bool _correct) {
    uint256 _size;
    // solium-disable-next-line security/no-inline-assembly
    assembly { _size := extcodesize(_address) }
    return _size > 0;
  }
}

// File: contracts/land/sale/LandSale.sol

contract LandSale_v2 is Pausable, Withdrawable, KyberCustomTokenRates, IERC20Receiver {
  using AddressUtils for address;

  enum ChestType {
    Savannah,
    Forest,
    Arctic,
    Mystic
  }

  event ChestPurchased(
    ChestType indexed _chestType,
    uint256 _chestAmount,
    address indexed _tokenAddress,
    uint256 _tokenAmount,
    uint256 _totalPrice,
    uint256 _lunaCashbackAmount,
    address _buyer, // Ran out of indexed fields.
    address indexed _owner
  );

  event ReferralRewarded(
    address indexed _referrer,
    uint256 _referralReward
  );

  event ReferralPercentageUpdated(
    address indexed _referrer,
    uint256 _percentage
  );

  address public daiAddress = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
  address public loomAddress = 0xA4e8C3Ec456107eA67d3075bF9e3DF3A75823DB0;

  uint256 public startedAt = 1548165600; // Tuesday, January 22, 2019 2:00:00 PM GMT+00:00
  uint256 public endedAt = 1563804000; // Monday, July 22, 2019 2:00:00 PM GMT+00:00

  mapping (uint8 => uint256) public chestCap;

  uint256 public savannahChestPrice = 0.05 ether;
  uint256 public forestChestPrice   = 0.16 ether;
  uint256 public arcticChestPrice   = 0.45 ether;
  uint256 public mysticChestPrice   = 1.00 ether;

  uint256 public initialDiscountPercentage = 1000; // 10%.
  uint256 public initialDiscountDays = 10 days;

  uint256 public cashbackPercentage = 1000; // 10%.

  uint256 public defaultReferralPercentage = 1000; // 10%.
  mapping (address => uint256) public referralPercentage;

  IERC20 public lunaContract;
  address public lunaBankAddress;

  modifier whenInSale {
    // solium-disable-next-line security/no-block-members
    require(now >= startedAt && now <= endedAt);
    _;
  }

  constructor(IERC20 _lunaContract, address _lunaBankAddress) public {
    // 1 LUNA = 1/10 DAI (rate has 18 decimals).
    _setCustomTokenRate(address(_lunaContract), daiAddress, 10**17);

    lunaContract = _lunaContract;
    lunaBankAddress = _lunaBankAddress;

    setChestCap([uint256(5349), 5359, 4171, 2338]);
  }

  function getPrice(
    ChestType _chestType,
    uint256 _chestAmount,
    address _tokenAddress
  )
    external
    view
    returns (
      uint256 _tokenAmount,
      uint256 _minConversionRate
    )
  {
    uint256 _totalPrice = _getEthPrice(_chestType, _chestAmount, _tokenAddress);

    if (_tokenAddress != ethAddress) {
      (_tokenAmount, ) = _convertToken(ethAddress, _totalPrice, _tokenAddress);
      (, _minConversionRate) = _getConversionRate(_tokenAddress, _tokenAmount, ethAddress);
      _tokenAmount = _totalPrice.mul(10**36).ceilingDiv(_minConversionRate);
      _tokenAmount = _fixTokenDecimals(ethAddress, _tokenAddress, _tokenAmount, true);
    } else {
      _tokenAmount = _totalPrice;
    }
  }

  function purchase(
    ChestType _chestType,
    uint256 _chestAmount,
    address _tokenAddress,
    uint256 _maxTokenAmount,
    uint256 _minConversionRate,
    address payable _referrer
  )
    external
    payable
    whenInSale
    whenNotPaused
  {
    _purchase(
      _chestType,
      _chestAmount,
      _tokenAddress,
      _maxTokenAmount,
      _minConversionRate,
      msg.sender,
      msg.sender,
      _referrer
    );
  }

  function purchaseFor(
    ChestType _chestType,
    uint256 _chestAmount,
    address _tokenAddress,
    uint256 _maxTokenAmount,
    uint256 _minConversionRate,
    address _owner
  )
    external
    payable
    whenInSale
    whenNotPaused
  {
    _purchase(
      _chestType,
      _chestAmount,
      _tokenAddress,
      _maxTokenAmount,
      _minConversionRate,
      msg.sender,
      _owner,
      msg.sender
    );
  }

  function receiveApproval(
    address _from,
    uint256 _value,
    address _tokenAddress,
    bytes calldata /* _data */
  )
    external
    whenInSale
    whenNotPaused
  {
    require(msg.sender == _tokenAddress);

    uint256 _action;
    ChestType _chestType;
    uint256 _chestAmount;
    uint256 _minConversionRate;
    address payable _referrerOrOwner;

    // solium-disable-next-line security/no-inline-assembly
    assembly {
      _action := calldataload(0xa4)
      _chestType := calldataload(0xc4)
      _chestAmount := calldataload(0xe4)
      _minConversionRate := calldataload(0x104)
      _referrerOrOwner := calldataload(0x124)
    }

    address payable _buyer;
    address _owner;
    address payable _referrer;

    if (_action == 0) { // Purchase.
      _buyer = _from.toPayable();
      _owner = _from;
      _referrer = _referrerOrOwner;
    } else if (_action == 1) { // Purchase for.
      _buyer = _from.toPayable();
      _owner = _referrerOrOwner;
      _referrer = _from.toPayable();
    } else {
      revert();
    }

    _purchase(
      _chestType,
      _chestAmount,
      _tokenAddress,
      _value,
      _minConversionRate,
      _buyer,
      _owner,
      _referrer
    );
  }

  function setReferralPercentages(address[] calldata _referrers, uint256[] calldata _percentage) external onlyAdmin {
    for (uint256 i = 0; i < _referrers.length; i++) {
      referralPercentage[_referrers[i]] = _percentage[i];
      emit ReferralPercentageUpdated(_referrers[i], _percentage[i]);
    }
  }

  function setCustomTokenRates(address[] memory _tokenAddresses, Rate[] memory _rates) public onlyAdmin {
    for (uint256 i = 0; i < _tokenAddresses.length; i++) {
      _setCustomTokenRate(_tokenAddresses[i], _rates[i].quote, _rates[i].value);
    }
  }

  function setChestCap(uint256[4] memory _chestCap) public onlyAdmin {
    for (uint8 _chestType = 0; _chestType < 4; _chestType++) {
      chestCap[_chestType] = _chestCap[_chestType];
    }
  }

  function _getPresentPercentage() internal view returns (uint256 _percentage) {
    // solium-disable-next-line security/no-block-members
    uint256 _elapsedDays = (now - startedAt).div(1 days).mul(1 days);

    return uint256(10000) // 100%.
      .sub(initialDiscountPercentage)
      .add(
        initialDiscountPercentage
          .mul(Math.min(_elapsedDays, initialDiscountDays))
          .div(initialDiscountDays)
      );
  }

  function _getEthPrice(
    ChestType _chestType,
    uint256 _chestAmount,
    address _tokenAddress
  )
    internal
    view
    returns (uint256 _price)
  {
    // solium-disable-next-line indentation
         if (_chestType == ChestType.Savannah) { _price = savannahChestPrice; } // solium-disable-line whitespace
    else if (_chestType == ChestType.Forest  ) { _price = forestChestPrice;   } // solium-disable-line whitespace, lbrace
    else if (_chestType == ChestType.Arctic  ) { _price = arcticChestPrice;   } // solium-disable-line whitespace, lbrace
    else if (_chestType == ChestType.Mystic  ) { _price = mysticChestPrice;   } // solium-disable-line whitespace, lbrace
    else { revert(); } // solium-disable-line whitespace, lbrace

    _price = _price
      .mul(_getPresentPercentage())
      .div(10000)
      .mul(_chestAmount);

    if (_tokenAddress == address(lunaContract)) {
      _price = _price
        .mul(uint256(10000).sub(cashbackPercentage))
        .ceilingDiv(10000);
    }
  }

  function _getLunaCashbackAmount(
    uint256 _ethPrice,
    address _tokenAddress
  )
    internal
    view
    returns (uint256 _lunaCashbackAmount)
  {
    if (_tokenAddress != address(lunaContract)) {
      (uint256 _lunaPrice, ) = _convertToken(ethAddress, _ethPrice, address(lunaContract));

      return _lunaPrice
        .mul(cashbackPercentage)
        .div(uint256(10000));
    }
  }

  function _getReferralPercentage(address _referrer, address _owner) internal view returns (uint256 _percentage) {
    return _referrer != _owner && _referrer != address(0)
      ? Math.max(referralPercentage[_referrer], defaultReferralPercentage)
      : 0;
  }

  function _purchase(
    ChestType _chestType,
    uint256 _chestAmount,
    address _tokenAddress,
    uint256 _maxTokenAmount,
    uint256 _minConversionRate,
    address payable _buyer,
    address _owner,
    address payable _referrer
  )
    internal
  {
    require(_chestAmount <= chestCap[uint8(_chestType)]);
    require(_tokenAddress == ethAddress ? msg.value >= _maxTokenAmount : msg.value == 0);

    uint256 _totalPrice = _getEthPrice(_chestType, _chestAmount, _tokenAddress);
    uint256 _lunaCashbackAmount = _getLunaCashbackAmount(_totalPrice, _tokenAddress);

    uint256 _tokenAmount;
    uint256 _ethAmount;

    if (_tokenAddress != ethAddress) {
      (_tokenAmount, _ethAmount) = _swapToken(
        _tokenAddress,
        _maxTokenAmount,
        ethAddress,
        _totalPrice,
        _minConversionRate,
        _buyer,
        address(this)
      );
    } else {
      // Check if the buyer allowed to spend that much ETH.
      require(_maxTokenAmount >= _totalPrice);

      // Require minimum conversion rate to be 0.
      require(_minConversionRate == 0);

      _tokenAmount = _totalPrice;
      _ethAmount = msg.value;
    }

    // Check if we received enough payment.
    require(_ethAmount >= _totalPrice);

    // Send back the ETH change, if there is any.
    if (_ethAmount > _totalPrice) {
      _buyer.transfer(_ethAmount - _totalPrice);
    }

    chestCap[uint8(_chestType)] -= _chestAmount;

    emit ChestPurchased(
      _chestType,
      _chestAmount,
      _tokenAddress,
      _tokenAmount,
      _totalPrice,
      _lunaCashbackAmount,
      _buyer,
      _owner
    );

    if (_tokenAddress != address(lunaContract)) {
      // Send LUNA cashback.
      require(lunaContract.transferFrom(lunaBankAddress, _owner, _lunaCashbackAmount));
    }

    if (!_hasCustomTokenRate(_tokenAddress)) {
      uint256 _referralReward = _totalPrice
        .mul(_getReferralPercentage(_referrer, _owner))
        .div(10000);

      // If the referral reward cannot be sent because of a referrer's fault, set it to 0.
      // solium-disable-next-line security/no-send
      if (_referralReward > 0 && !_referrer.send(_referralReward)) {
        _referralReward = 0;
      }

      if (_referralReward > 0) {
        emit ReferralRewarded(_referrer, _referralReward);
      }
    }
  }
}