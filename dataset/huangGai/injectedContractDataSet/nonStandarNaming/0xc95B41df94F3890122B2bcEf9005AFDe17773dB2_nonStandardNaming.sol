                                                                 

pragma solidity 0.6.6;


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                   
  function ADD711(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

                                                                                                                                                                                                                                                       
  function SUB103(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b <= a, "SafeMath: subtraction overflow");
    uint256 c = a - b;

    return c;
  }

                                                                                                                                                                                                                               
  function MUL19(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function DIV393(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, "SafeMath: division by zero");
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function MOD687(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b != 0, "SafeMath: modulo by zero");
    return a % b;
  }
}

library SignedSafeMath {
  int256 constant private _int256_min170 = -2**255;	//inject NONSTANDARD NAMING

                                                                          
  function MUL19(int256 a, int256 b) internal pure returns (int256) {	//inject NONSTANDARD NAMING
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    require(!(a == -1 && b == _int256_min170), "SignedSafeMath: multiplication overflow");

    int256 c = a * b;
    require(c / a == b, "SignedSafeMath: multiplication overflow");

    return c;
  }

                                                                                                                   
  function DIV393(int256 a, int256 b) internal pure returns (int256) {	//inject NONSTANDARD NAMING
    require(b != 0, "SignedSafeMath: division by zero");
    require(!(b == -1 && a == _int256_min170), "SignedSafeMath: division overflow");

    int256 c = a / b;

    return c;
  }

                                                                         
  function SUB103(int256 a, int256 b) internal pure returns (int256) {	//inject NONSTANDARD NAMING
    int256 c = a - b;
    require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");

    return c;
  }

                                                                    
  function ADD711(int256 a, int256 b) internal pure returns (int256) {	//inject NONSTANDARD NAMING
    int256 c = a + b;
    require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");

    return c;
  }

                                                                                                                                                                                                                                
  function AVG351(int256 _a, int256 _b)	//inject NONSTANDARD NAMING
    internal
    pure
    returns (int256)
  {
    if ((_a < 0 && _b > 0) || (_a > 0 && _b < 0)) {
      return ADD711(_a, _b) / 2;
    }
    int256 remainder = (_a % 2 + _b % 2) / 2;
    return ADD711(ADD711(_a / 2, _b / 2), remainder);
  }
}

library Median {
  using SignedSafeMath for int256;

  int256 constant int_max472 = 2**255-1;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                  
  function CALCULATE872(int256[] memory list)	//inject NONSTANDARD NAMING
    internal
    pure
    returns (int256)
  {
    return CALCULATEINPLACE219(COPY65(list));
  }

                                                                                                                            
  function CALCULATEINPLACE219(int256[] memory list)	//inject NONSTANDARD NAMING
    internal
    pure
    returns (int256)
  {
    require(0 < list.length, "list must not be empty");
    uint256 len = list.length;
    uint256 middleIndex = len / 2;
    if (len % 2 == 0) {
      int256 median1;
      int256 median2;
      (median1, median2) = QUICKSELECTTWO341(list, 0, len - 1, middleIndex - 1, middleIndex);
      return SignedSafeMath.AVG351(median1, median2);
    } else {
      return QUICKSELECT495(list, 0, len - 1, middleIndex);
    }
  }

                                                                              
  uint256 constant shortselecttwo_max_length473 = 7;	//inject NONSTANDARD NAMING

                                                                                                                                   
  function SHORTSELECTTWO800(	//inject NONSTANDARD NAMING
    int256[] memory list,
    uint256 lo,
    uint256 hi,
    uint256 k1,
    uint256 k2
  )
    private
    pure
    returns (int256 k1th, int256 k2th)
  {
    // Uses an optimal sorting network (https://en.wikipedia.org/wiki/Sorting_network)
    // for lists of length 7. Network layout is taken from
    // http://jgamble.ripco.net/cgi-bin/nw.cgi?inputs=7&algorithm=hibbard&output=svg

    uint256 len = hi + 1 - lo;
    int256 x0 = list[lo + 0];
    int256 x1 = 1 < len ? list[lo + 1] : int_max472;
    int256 x2 = 2 < len ? list[lo + 2] : int_max472;
    int256 x3 = 3 < len ? list[lo + 3] : int_max472;
    int256 x4 = 4 < len ? list[lo + 4] : int_max472;
    int256 x5 = 5 < len ? list[lo + 5] : int_max472;
    int256 x6 = 6 < len ? list[lo + 6] : int_max472;

    if (x0 > x1) {(x0, x1) = (x1, x0);}
    if (x2 > x3) {(x2, x3) = (x3, x2);}
    if (x4 > x5) {(x4, x5) = (x5, x4);}
    if (x0 > x2) {(x0, x2) = (x2, x0);}
    if (x1 > x3) {(x1, x3) = (x3, x1);}
    if (x4 > x6) {(x4, x6) = (x6, x4);}
    if (x1 > x2) {(x1, x2) = (x2, x1);}
    if (x5 > x6) {(x5, x6) = (x6, x5);}
    if (x0 > x4) {(x0, x4) = (x4, x0);}
    if (x1 > x5) {(x1, x5) = (x5, x1);}
    if (x2 > x6) {(x2, x6) = (x6, x2);}
    if (x1 > x4) {(x1, x4) = (x4, x1);}
    if (x3 > x6) {(x3, x6) = (x6, x3);}
    if (x2 > x4) {(x2, x4) = (x4, x2);}
    if (x3 > x5) {(x3, x5) = (x5, x3);}
    if (x3 > x4) {(x3, x4) = (x4, x3);}

    uint256 index1 = k1 - lo;
    if (index1 == 0) {k1th = x0;}
    else if (index1 == 1) {k1th = x1;}
    else if (index1 == 2) {k1th = x2;}
    else if (index1 == 3) {k1th = x3;}
    else if (index1 == 4) {k1th = x4;}
    else if (index1 == 5) {k1th = x5;}
    else if (index1 == 6) {k1th = x6;}
    else {revert("k1 out of bounds");}

    uint256 index2 = k2 - lo;
    if (k1 == k2) {return (k1th, k1th);}
    else if (index2 == 0) {return (k1th, x0);}
    else if (index2 == 1) {return (k1th, x1);}
    else if (index2 == 2) {return (k1th, x2);}
    else if (index2 == 3) {return (k1th, x3);}
    else if (index2 == 4) {return (k1th, x4);}
    else if (index2 == 5) {return (k1th, x5);}
    else if (index2 == 6) {return (k1th, x6);}
    else {revert("k2 out of bounds");}
  }

                                                                                                                                                       
  function QUICKSELECT495(int256[] memory list, uint256 lo, uint256 hi, uint256 k)	//inject NONSTANDARD NAMING
    private
    pure
    returns (int256 kth)
  {
    require(lo <= k);
    require(k <= hi);
    while (lo < hi) {
      if (hi - lo < shortselecttwo_max_length473) {
        int256 ignore;
        (kth, ignore) = SHORTSELECTTWO800(list, lo, hi, k, k);
        return kth;
      }
      uint256 pivotIndex = PARTITION682(list, lo, hi);
      if (k <= pivotIndex) {
        // since pivotIndex < (original hi passed to partition),
        // termination is guaranteed in this case
        hi = pivotIndex;
      } else {
        // since (original lo passed to partition) <= pivotIndex,
        // termination is guaranteed in this case
        lo = pivotIndex + 1;
      }
    }
    return list[lo];
  }

                                                                                                                                                                   
  function QUICKSELECTTWO341(	//inject NONSTANDARD NAMING
    int256[] memory list,
    uint256 lo,
    uint256 hi,
    uint256 k1,
    uint256 k2
  )
    internal // for testing
    pure
    returns (int256 k1th, int256 k2th)
  {
    require(k1 < k2);
    require(lo <= k1 && k1 <= hi);
    require(lo <= k2 && k2 <= hi);

    while (true) {
      if (hi - lo < shortselecttwo_max_length473) {
        return SHORTSELECTTWO800(list, lo, hi, k1, k2);
      }
      uint256 pivotIdx = PARTITION682(list, lo, hi);
      if (k2 <= pivotIdx) {
        hi = pivotIdx;
      } else if (pivotIdx < k1) {
        lo = pivotIdx + 1;
      } else {
        assert(k1 <= pivotIdx && pivotIdx < k2);
        k1th = QUICKSELECT495(list, lo, pivotIdx, k1);
        k2th = QUICKSELECT495(list, pivotIdx + 1, hi, k2);
        return (k1th, k2th);
      }
    }
  }

                                                                                                                                                                                                                                                                                                                             
  function PARTITION682(int256[] memory list, uint256 lo, uint256 hi)	//inject NONSTANDARD NAMING
    private
    pure
    returns (uint256)
  {
    // We don't care about overflow of the addition, because it would require a list
    // larger than any feasible computer's memory.
    int256 pivot = list[(lo + hi) / 2];
    lo -= 1; // this can underflow. that's intentional.
    hi += 1;
    while (true) {
      do {
        lo += 1;
      } while (list[lo] < pivot);
      do {
        hi -= 1;
      } while (list[hi] > pivot);
      if (lo < hi) {
        (list[lo], list[hi]) = (list[hi], list[lo]);
      } else {
        // Let orig_lo and orig_hi be the original values of lo and hi passed to partition.
        // Then, hi < orig_hi, because hi decreases *strictly* monotonically
        // in each loop iteration and
        // - either list[orig_hi] > pivot, in which case the first loop iteration
        //   will achieve hi < orig_hi;
        // - or list[orig_hi] <= pivot, in which case at least two loop iterations are
        //   needed:
        //   - lo will have to stop at least once in the interval
        //     [orig_lo, (orig_lo + orig_hi)/2]
        //   - (orig_lo + orig_hi)/2 < orig_hi
        return hi;
      }
    }
  }

                                                                                                                            
  function COPY65(int256[] memory list)	//inject NONSTANDARD NAMING
    private
    pure
    returns(int256[] memory)
  {
    int256[] memory list2 = new int256[](list.length);
    for (uint256 i = 0; i < list.length; i++) {
      list2[i] = list[i];
    }
    return list2;
  }
}

                                                                                                     
contract Owned {

  address payable public owner;
  address private pendingOwner;

  event OWNERSHIPTRANSFERREQUESTED614(	//inject NONSTANDARD NAMING
    address indexed from,
    address indexed to
  );
  event OWNERSHIPTRANSFERRED732(	//inject NONSTANDARD NAMING
    address indexed from,
    address indexed to
  );

  constructor() public {
    owner = msg.sender;
  }

                                                                                                     
  function TRANSFEROWNERSHIP993(address _to)	//inject NONSTANDARD NAMING
    external
    ONLYOWNER559()
  {
    pendingOwner = _to;

    emit OWNERSHIPTRANSFERREQUESTED614(owner, _to);
  }

                                                                                    
  function ACCEPTOWNERSHIP161()	//inject NONSTANDARD NAMING
    external
  {
    require(msg.sender == pendingOwner, "Must be proposed owner");

    address oldOwner = owner;
    owner = msg.sender;
    pendingOwner = address(0);

    emit OWNERSHIPTRANSFERRED732(oldOwner, msg.sender);
  }

                                                                                
  modifier ONLYOWNER559() {	//inject NONSTANDARD NAMING
    require(msg.sender == owner, "Only callable by owner");
    _;
  }

}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
library SafeMath128 {
                                                                                                                                                                                                                   
  function ADD711(uint128 a, uint128 b) internal pure returns (uint128) {	//inject NONSTANDARD NAMING
    uint128 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

                                                                                                                                                                                                                                                       
  function SUB103(uint128 a, uint128 b) internal pure returns (uint128) {	//inject NONSTANDARD NAMING
    require(b <= a, "SafeMath: subtraction overflow");
    uint128 c = a - b;

    return c;
  }

                                                                                                                                                                                                                               
  function MUL19(uint128 a, uint128 b) internal pure returns (uint128) {	//inject NONSTANDARD NAMING
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint128 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function DIV393(uint128 a, uint128 b) internal pure returns (uint128) {	//inject NONSTANDARD NAMING
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, "SafeMath: division by zero");
    uint128 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function MOD687(uint128 a, uint128 b) internal pure returns (uint128) {	//inject NONSTANDARD NAMING
    require(b != 0, "SafeMath: modulo by zero");
    return a % b;
  }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
library SafeMath32 {
                                                                                                                                                                                                                   
  function ADD711(uint32 a, uint32 b) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
    uint32 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

                                                                                                                                                                                                                                                       
  function SUB103(uint32 a, uint32 b) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
    require(b <= a, "SafeMath: subtraction overflow");
    uint32 c = a - b;

    return c;
  }

                                                                                                                                                                                                                               
  function MUL19(uint32 a, uint32 b) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint32 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function DIV393(uint32 a, uint32 b) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, "SafeMath: division by zero");
    uint32 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function MOD687(uint32 a, uint32 b) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
    require(b != 0, "SafeMath: modulo by zero");
    return a % b;
  }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
library SafeMath64 {
                                                                                                                                                                                                                   
  function ADD711(uint64 a, uint64 b) internal pure returns (uint64) {	//inject NONSTANDARD NAMING
    uint64 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

                                                                                                                                                                                                                                                       
  function SUB103(uint64 a, uint64 b) internal pure returns (uint64) {	//inject NONSTANDARD NAMING
    require(b <= a, "SafeMath: subtraction overflow");
    uint64 c = a - b;

    return c;
  }

                                                                                                                                                                                                                               
  function MUL19(uint64 a, uint64 b) internal pure returns (uint64) {	//inject NONSTANDARD NAMING
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint64 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function DIV393(uint64 a, uint64 b) internal pure returns (uint64) {	//inject NONSTANDARD NAMING
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, "SafeMath: division by zero");
    uint64 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function MOD687(uint64 a, uint64 b) internal pure returns (uint64) {	//inject NONSTANDARD NAMING
    require(b != 0, "SafeMath: modulo by zero");
    return a % b;
  }
}

interface AggregatorInterface {
  function LATESTANSWER707() external view returns (int256);	//inject NONSTANDARD NAMING
  function LATESTTIMESTAMP837() external view returns (uint256);	//inject NONSTANDARD NAMING
  function LATESTROUND755() external view returns (uint256);	//inject NONSTANDARD NAMING
  function GETANSWER393(uint256 roundId) external view returns (int256);	//inject NONSTANDARD NAMING
  function GETTIMESTAMP991(uint256 roundId) external view returns (uint256);	//inject NONSTANDARD NAMING

  event ANSWERUPDATED28(int256 indexed current, uint256 indexed roundId, uint256 updatedAt);	//inject NONSTANDARD NAMING
  event NEWROUND976(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);	//inject NONSTANDARD NAMING
}

interface AggregatorV3Interface {

  function DECIMALS935() external view returns (uint8);	//inject NONSTANDARD NAMING
  function DESCRIPTION856() external view returns (string memory);	//inject NONSTANDARD NAMING
  function VERSION169() external view returns (uint256);	//inject NONSTANDARD NAMING

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function GETROUNDDATA39(uint80 _roundId)	//inject NONSTANDARD NAMING
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
  function LATESTROUNDDATA217()	//inject NONSTANDARD NAMING
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

}

interface AggregatorV2V3Interface is AggregatorInterface, AggregatorV3Interface
{
}

interface AggregatorValidatorInterface {
  function VALIDATE825(	//inject NONSTANDARD NAMING
    uint256 previousRoundId,
    int256 previousAnswer,
    uint256 currentRoundId,
    int256 currentAnswer
  ) external returns (bool);
}

interface LinkTokenInterface {
  function ALLOWANCE958(address owner, address spender) external view returns (uint256 remaining);	//inject NONSTANDARD NAMING
  function APPROVE714(address spender, uint256 value) external returns (bool success);	//inject NONSTANDARD NAMING
  function BALANCEOF159(address owner) external view returns (uint256 balance);	//inject NONSTANDARD NAMING
  function DECIMALS935() external view returns (uint8 decimalPlaces);	//inject NONSTANDARD NAMING
  function DECREASEAPPROVAL588(address spender, uint256 addedValue) external returns (bool success);	//inject NONSTANDARD NAMING
  function INCREASEAPPROVAL942(address spender, uint256 subtractedValue) external;	//inject NONSTANDARD NAMING
  function NAME521() external view returns (string memory tokenName);	//inject NONSTANDARD NAMING
  function SYMBOL579() external view returns (string memory tokenSymbol);	//inject NONSTANDARD NAMING
  function TOTALSUPPLY663() external view returns (uint256 totalTokensIssued);	//inject NONSTANDARD NAMING
  function TRANSFER827(address to, uint256 value) external returns (bool success);	//inject NONSTANDARD NAMING
  function TRANSFERANDCALL22(address to, uint256 value, bytes calldata data) external returns (bool success);	//inject NONSTANDARD NAMING
  function TRANSFERFROM869(address from, address to, uint256 value) external returns (bool success);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                
contract FluxAggregator is AggregatorV2V3Interface, Owned {
  using SafeMath for uint256;
  using SafeMath128 for uint128;
  using SafeMath64 for uint64;
  using SafeMath32 for uint32;

  struct Round {
    int256 answer;
    uint64 startedAt;
    uint64 updatedAt;
    uint32 answeredInRound;
  }

  struct RoundDetails {
    int256[] submissions;
    uint32 maxSubmissions;
    uint32 minSubmissions;
    uint32 timeout;
    uint128 paymentAmount;
  }

  struct OracleStatus {
    uint128 withdrawable;
    uint32 startingRound;
    uint32 endingRound;
    uint32 lastReportedRound;
    uint32 lastStartedRound;
    int256 latestSubmission;
    uint16 index;
    address admin;
    address pendingAdmin;
  }

  struct Requester {
    bool authorized;
    uint32 delay;
    uint32 lastStartedRound;
  }

  struct Funds {
    uint128 available;
    uint128 allocated;
  }

  LinkTokenInterface public linkToken;
  AggregatorValidatorInterface public validator;

  // Round related params
  uint128 public paymentAmount;
  uint32 public maxSubmissionCount;
  uint32 public minSubmissionCount;
  uint32 public restartDelay;
  uint32 public timeout;
  uint8 public override decimals;
  string public override description;

  int256 immutable public minSubmissionValue;
  int256 immutable public maxSubmissionValue;

  uint256 constant public override version491 = 3;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                             
  uint256 constant private reserve_rounds846 = 2;	//inject NONSTANDARD NAMING
  uint256 constant private max_oracle_count659 = 77;	//inject NONSTANDARD NAMING
  uint32 constant private round_max969 = 2**32-1;	//inject NONSTANDARD NAMING
  uint256 private constant validator_gas_limit936 = 100000;	//inject NONSTANDARD NAMING
  // An error specific to the Aggregator V3 Interface, to prevent possible
  // confusion around accidentally reading unset values as reported values.
  string constant private v3_no_data_error3 = "No data present";	//inject NONSTANDARD NAMING

  uint32 private reportingRoundId;
  uint32 internal latestRoundId;
  mapping(address => OracleStatus) private oracles;
  mapping(uint32 => Round) internal rounds;
  mapping(uint32 => RoundDetails) internal details;
  mapping(address => Requester) internal requesters;
  address[] private oracleAddresses;
  Funds private recordedFunds;

  event AVAILABLEFUNDSUPDATED544(	//inject NONSTANDARD NAMING
    uint256 indexed amount
  );
  event ROUNDDETAILSUPDATED693(	//inject NONSTANDARD NAMING
    uint128 indexed paymentAmount,
    uint32 indexed minSubmissionCount,
    uint32 indexed maxSubmissionCount,
    uint32 restartDelay,
    uint32 timeout // measured in seconds
  );
  event ORACLEPERMISSIONSUPDATED729(	//inject NONSTANDARD NAMING
    address indexed oracle,
    bool indexed whitelisted
  );
  event ORACLEADMINUPDATED368(	//inject NONSTANDARD NAMING
    address indexed oracle,
    address indexed newAdmin
  );
  event ORACLEADMINUPDATEREQUESTED335(	//inject NONSTANDARD NAMING
    address indexed oracle,
    address admin,
    address newAdmin
  );
  event SUBMISSIONRECEIVED309(	//inject NONSTANDARD NAMING
    int256 indexed submission,
    uint32 indexed round,
    address indexed oracle
  );
  event REQUESTERPERMISSIONSSET42(	//inject NONSTANDARD NAMING
    address indexed requester,
    bool authorized,
    uint32 delay
  );
  event VALIDATORUPDATED135(	//inject NONSTANDARD NAMING
    address indexed previous,
    address indexed current
  );

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
  constructor(
    address _link,
    uint128 _paymentAmount,
    uint32 _timeout,
    address _validator,
    int256 _minSubmissionValue,
    int256 _maxSubmissionValue,
    uint8 _decimals,
    string memory _description
  ) public {
    linkToken = LinkTokenInterface(_link);
    UPDATEFUTUREROUNDS867(_paymentAmount, 0, 0, 0, _timeout);
    SETVALIDATOR367(_validator);
    minSubmissionValue = _minSubmissionValue;
    maxSubmissionValue = _maxSubmissionValue;
    decimals = _decimals;
    description = _description;
    rounds[0].updatedAt = uint64(block.timestamp.SUB103(uint256(_timeout)));
  }

                                                                                                                                                                                                                                      
  function SUBMIT494(uint256 _roundId, int256 _submission)	//inject NONSTANDARD NAMING
    external
  {
    bytes memory error = VALIDATEORACLEROUND770(msg.sender, uint32(_roundId));
    require(_submission >= minSubmissionValue, "value below minSubmissionValue");
    require(_submission <= maxSubmissionValue, "value above maxSubmissionValue");
    require(error.length == 0, string(error));

    ORACLEINITIALIZENEWROUND227(uint32(_roundId));
    RECORDSUBMISSION1000(_submission, uint32(_roundId));
    (bool updated, int256 newAnswer) = UPDATEROUNDANSWER354(uint32(_roundId));
    PAYORACLE788(uint32(_roundId));
    DELETEROUNDDETAILS630(uint32(_roundId));
    if (updated) {
      VALIDATEANSWER492(uint32(_roundId), newAnswer);
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  function CHANGEORACLES314(	//inject NONSTANDARD NAMING
    address[] calldata _removed,
    address[] calldata _added,
    address[] calldata _addedAdmins,
    uint32 _minSubmissions,
    uint32 _maxSubmissions,
    uint32 _restartDelay
  )
    external
    ONLYOWNER559()
  {
    for (uint256 i = 0; i < _removed.length; i++) {
      REMOVEORACLE174(_removed[i]);
    }

    require(_added.length == _addedAdmins.length, "need same oracle and admin count");
    require(uint256(ORACLECOUNT519()).ADD711(_added.length) <= max_oracle_count659, "max oracles allowed");

    for (uint256 i = 0; i < _added.length; i++) {
      ADDORACLE604(_added[i], _addedAdmins[i]);
    }

    UPDATEFUTUREROUNDS867(paymentAmount, _minSubmissions, _maxSubmissions, _restartDelay, timeout);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function UPDATEFUTUREROUNDS867(	//inject NONSTANDARD NAMING
    uint128 _paymentAmount,
    uint32 _minSubmissions,
    uint32 _maxSubmissions,
    uint32 _restartDelay,
    uint32 _timeout
  )
    public
    ONLYOWNER559()
  {
    uint32 oracleNum = ORACLECOUNT519(); // Save on storage reads
    require(_maxSubmissions >= _minSubmissions, "max must equal/exceed min");
    require(oracleNum >= _maxSubmissions, "max cannot exceed total");
    require(oracleNum == 0 || oracleNum > _restartDelay, "delay cannot exceed total");
    require(recordedFunds.available >= REQUIREDRESERVE861(_paymentAmount), "insufficient funds for payment");
    if (ORACLECOUNT519() > 0) {
      require(_minSubmissions > 0, "min must be greater than 0");
    }

    paymentAmount = _paymentAmount;
    minSubmissionCount = _minSubmissions;
    maxSubmissionCount = _maxSubmissions;
    restartDelay = _restartDelay;
    timeout = _timeout;

    emit ROUNDDETAILSUPDATED693(
      paymentAmount,
      _minSubmissions,
      _maxSubmissions,
      _restartDelay,
      _timeout
    );
  }

                                                                             
  function ALLOCATEDFUNDS307()	//inject NONSTANDARD NAMING
    external
    view
    returns (uint128)
  {
    return recordedFunds.allocated;
  }

                                                                          
  function AVAILABLEFUNDS420()	//inject NONSTANDARD NAMING
    external
    view
    returns (uint128)
  {
    return recordedFunds.available;
  }

                                                                             
  function UPDATEAVAILABLEFUNDS163()	//inject NONSTANDARD NAMING
    public
  {
    Funds memory funds = recordedFunds;

    uint256 nowAvailable = linkToken.BALANCEOF159(address(this)).SUB103(funds.allocated);

    if (funds.available != nowAvailable) {
      recordedFunds.available = uint128(nowAvailable);
      emit AVAILABLEFUNDSUPDATED544(nowAvailable);
    }
  }

                                                      
  function ORACLECOUNT519() public view returns (uint8) {	//inject NONSTANDARD NAMING
    return uint8(oracleAddresses.length);
  }

                                                                                         
  function GETORACLES569() external view returns (address[] memory) {	//inject NONSTANDARD NAMING
    return oracleAddresses;
  }

                                                                                                                                                                                                                                                                                                                                                                         
  function LATESTANSWER707()	//inject NONSTANDARD NAMING
    public
    view
    virtual
    override
    returns (int256)
  {
    return rounds[latestRoundId].answer;
  }

                                                                                                                                                                                                                                                                                                                                                                            
  function LATESTTIMESTAMP837()	//inject NONSTANDARD NAMING
    public
    view
    virtual
    override
    returns (uint256)
  {
    return rounds[latestRoundId].updatedAt;
  }

                                                                                                                                                                                                                                                                                                                                                                        
  function LATESTROUND755()	//inject NONSTANDARD NAMING
    public
    view
    virtual
    override
    returns (uint256)
  {
    return latestRoundId;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                      
  function GETANSWER393(uint256 _roundId)	//inject NONSTANDARD NAMING
    public
    view
    virtual
    override
    returns (int256)
  {
    if (VALIDROUNDID318(_roundId)) {
      return rounds[uint32(_roundId)].answer;
    }
    return 0;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  function GETTIMESTAMP991(uint256 _roundId)	//inject NONSTANDARD NAMING
    public
    view
    virtual
    override
    returns (uint256)
  {
    if (VALIDROUNDID318(_roundId)) {
      return rounds[uint32(_roundId)].updatedAt;
    }
    return 0;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
  function GETROUNDDATA39(uint80 _roundId)	//inject NONSTANDARD NAMING
    public
    view
    virtual
    override
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    )
  {
    Round memory r = rounds[uint32(_roundId)];

    require(r.answeredInRound > 0 && VALIDROUNDID318(_roundId), v3_no_data_error3);

    return (
      _roundId,
      r.answer,
      r.startedAt,
      r.updatedAt,
      r.answeredInRound
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
   function LATESTROUNDDATA217()	//inject NONSTANDARD NAMING
    public
    view
    virtual
    override
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    )
  {
    return GETROUNDDATA39(latestRoundId);
  }


                                                                                     
  function WITHDRAWABLEPAYMENT734(address _oracle)	//inject NONSTANDARD NAMING
    external
    view
    returns (uint256)
  {
    return oracles[_oracle].withdrawable;
  }

                                                                                                                                                                                                                                                                                               
  function WITHDRAWPAYMENT231(address _oracle, address _recipient, uint256 _amount)	//inject NONSTANDARD NAMING
    external
  {
    require(oracles[_oracle].admin == msg.sender, "only callable by admin");

    // Safe to downcast _amount because the total amount of LINK is less than 2^128.
    uint128 amount = uint128(_amount);
    uint128 available = oracles[_oracle].withdrawable;
    require(available >= amount, "insufficient withdrawable funds");

    oracles[_oracle].withdrawable = available.SUB103(amount);
    recordedFunds.allocated = recordedFunds.allocated.SUB103(amount);

    assert(linkToken.TRANSFER827(_recipient, uint256(amount)));
  }

                                                                                                                                                                                  
  function WITHDRAWFUNDS824(address _recipient, uint256 _amount)	//inject NONSTANDARD NAMING
    external
    ONLYOWNER559()
  {
    uint256 available = uint256(recordedFunds.available);
    require(available.SUB103(REQUIREDRESERVE861(paymentAmount)) >= _amount, "insufficient reserve funds");
    require(linkToken.TRANSFER827(_recipient, _amount), "token transfer failed");
    UPDATEAVAILABLEFUNDS163();
  }

                                                                                                                                         
  function GETADMIN170(address _oracle)	//inject NONSTANDARD NAMING
    external
    view
    returns (address)
  {
    return oracles[_oracle].admin;
  }

                                                                                                                                                                                                  
  function TRANSFERADMIN939(address _oracle, address _newAdmin)	//inject NONSTANDARD NAMING
    external
  {
    require(oracles[_oracle].admin == msg.sender, "only callable by admin");
    oracles[_oracle].pendingAdmin = _newAdmin;

    emit ORACLEADMINUPDATEREQUESTED335(_oracle, msg.sender, _newAdmin);
  }

                                                                                                                                                          
  function ACCEPTADMIN475(address _oracle)	//inject NONSTANDARD NAMING
    external
  {
    require(oracles[_oracle].pendingAdmin == msg.sender, "only callable by pending admin");
    oracles[_oracle].pendingAdmin = address(0);
    oracles[_oracle].admin = msg.sender;

    emit ORACLEADMINUPDATED368(_oracle, msg.sender);
  }

                                                                  
  function REQUESTNEWROUND544()	//inject NONSTANDARD NAMING
    external
    returns (uint80)
  {
    require(requesters[msg.sender].authorized, "not authorized requester");

    uint32 current = reportingRoundId;
    require(rounds[current].updatedAt > 0 || TIMEDOUT67(current), "prev round must be supersedable");

    uint32 newRoundId = current.ADD711(1);
    REQUESTERINITIALIZENEWROUND361(newRoundId);
    return newRoundId;
  }

                                                                                                                                                                                                                                                                                                                                               
  function SETREQUESTERPERMISSIONS685(address _requester, bool _authorized, uint32 _delay)	//inject NONSTANDARD NAMING
    external
    ONLYOWNER559()
  {
    if (requesters[_requester].authorized == _authorized) return;

    if (_authorized) {
      requesters[_requester].authorized = _authorized;
      requesters[_requester].delay = _delay;
    } else {
      delete requesters[_requester];
    }

    emit REQUESTERPERMISSIONSSET42(_requester, _authorized, _delay);
  }

                                                                                                                                                                                                                                                                                  
  function ONTOKENTRANSFER815(address, uint256, bytes calldata _data)	//inject NONSTANDARD NAMING
    external
  {
    require(_data.length == 0, "transfer doesn't accept calldata");
    UPDATEAVAILABLEFUNDS163();
  }

                                                                                                                                                                                                                                  
  function ORACLEROUNDSTATE528(address _oracle, uint32 _queriedRoundId)	//inject NONSTANDARD NAMING
    external
    view
    returns (
      bool _eligibleToSubmit,
      uint32 _roundId,
      int256 _latestSubmission,
      uint64 _startedAt,
      uint64 _timeout,
      uint128 _availableFunds,
      uint8 _oracleCount,
      uint128 _paymentAmount
    )
  {
    require(msg.sender == tx.origin, "off-chain reading only");

    if (_queriedRoundId > 0) {
      Round storage round = rounds[_queriedRoundId];
      RoundDetails storage details = details[_queriedRoundId];
      return (
        ELIGIBLEFORSPECIFICROUND530(_oracle, _queriedRoundId),
        _queriedRoundId,
        oracles[_oracle].latestSubmission,
        round.startedAt,
        details.timeout,
        recordedFunds.available,
        ORACLECOUNT519(),
        (round.startedAt > 0 ? details.paymentAmount : paymentAmount)
      );
    } else {
      return ORACLEROUNDSTATESUGGESTROUND855(_oracle);
    }
  }

                                                                                                                                                                           
  function SETVALIDATOR367(address _newValidator)	//inject NONSTANDARD NAMING
    public
    ONLYOWNER559()
  {
    address previous = address(validator);

    if (previous != _newValidator) {
      validator = AggregatorValidatorInterface(_newValidator);

      emit VALIDATORUPDATED135(previous, _newValidator);
    }
  }


                        

  function INITIALIZENEWROUND962(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    UPDATETIMEDOUTROUNDINFO248(_roundId.SUB103(1));

    reportingRoundId = _roundId;
    RoundDetails memory nextDetails = RoundDetails(
      new int256[](0),
      maxSubmissionCount,
      minSubmissionCount,
      timeout,
      paymentAmount
    );
    details[_roundId] = nextDetails;
    rounds[_roundId].startedAt = uint64(block.timestamp);

    emit NEWROUND976(_roundId, msg.sender, rounds[_roundId].startedAt);
  }

  function ORACLEINITIALIZENEWROUND227(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    if (!NEWROUND565(_roundId)) return;
    uint256 lastStarted = oracles[msg.sender].lastStartedRound; // cache storage reads
    if (_roundId <= lastStarted + restartDelay && lastStarted != 0) return;

    INITIALIZENEWROUND962(_roundId);

    oracles[msg.sender].lastStartedRound = _roundId;
  }

  function REQUESTERINITIALIZENEWROUND361(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    if (!NEWROUND565(_roundId)) return;
    uint256 lastStarted = requesters[msg.sender].lastStartedRound; // cache storage reads
    require(_roundId > lastStarted + requesters[msg.sender].delay || lastStarted == 0, "must delay requests");

    INITIALIZENEWROUND962(_roundId);

    requesters[msg.sender].lastStartedRound = _roundId;
  }

  function UPDATETIMEDOUTROUNDINFO248(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    if (!TIMEDOUT67(_roundId)) return;

    uint32 prevId = _roundId.SUB103(1);
    rounds[_roundId].answer = rounds[prevId].answer;
    rounds[_roundId].answeredInRound = rounds[prevId].answeredInRound;
    rounds[_roundId].updatedAt = uint64(block.timestamp);

    delete details[_roundId];
  }

  function ELIGIBLEFORSPECIFICROUND530(address _oracle, uint32 _queriedRoundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool _eligible)
  {
    if (rounds[_queriedRoundId].startedAt > 0) {
      return ACCEPTINGSUBMISSIONS855(_queriedRoundId) && VALIDATEORACLEROUND770(_oracle, _queriedRoundId).length == 0;
    } else {
      return DELAYED153(_oracle, _queriedRoundId) && VALIDATEORACLEROUND770(_oracle, _queriedRoundId).length == 0;
    }
  }

  function ORACLEROUNDSTATESUGGESTROUND855(address _oracle)	//inject NONSTANDARD NAMING
    private
    view
    returns (
      bool _eligibleToSubmit,
      uint32 _roundId,
      int256 _latestSubmission,
      uint64 _startedAt,
      uint64 _timeout,
      uint128 _availableFunds,
      uint8 _oracleCount,
      uint128 _paymentAmount
    )
  {
    Round storage round = rounds[0];
    OracleStatus storage oracle = oracles[_oracle];

    bool shouldSupersede = oracle.lastReportedRound == reportingRoundId || !ACCEPTINGSUBMISSIONS855(reportingRoundId);
    // Instead of nudging oracles to submit to the next round, the inclusion of
    // the shouldSupersede bool in the if condition pushes them towards
    // submitting in a currently open round.
    if (SUPERSEDABLE88(reportingRoundId) && shouldSupersede) {
      _roundId = reportingRoundId.ADD711(1);
      round = rounds[_roundId];

      _paymentAmount = paymentAmount;
      _eligibleToSubmit = DELAYED153(_oracle, _roundId);
    } else {
      _roundId = reportingRoundId;
      round = rounds[_roundId];

      _paymentAmount = details[_roundId].paymentAmount;
      _eligibleToSubmit = ACCEPTINGSUBMISSIONS855(_roundId);
    }

    if (VALIDATEORACLEROUND770(_oracle, _roundId).length != 0) {
      _eligibleToSubmit = false;
    }

    return (
      _eligibleToSubmit,
      _roundId,
      oracle.latestSubmission,
      round.startedAt,
      details[_roundId].timeout,
      recordedFunds.available,
      ORACLECOUNT519(),
      _paymentAmount
    );
  }

  function UPDATEROUNDANSWER354(uint32 _roundId)	//inject NONSTANDARD NAMING
    internal
    returns (bool, int256)
  {
    if (details[_roundId].submissions.length < details[_roundId].minSubmissions) {
      return (false, 0);
    }

    int256 newAnswer = Median.CALCULATEINPLACE219(details[_roundId].submissions);
    rounds[_roundId].answer = newAnswer;
    rounds[_roundId].updatedAt = uint64(block.timestamp);
    rounds[_roundId].answeredInRound = _roundId;
    latestRoundId = _roundId;

    emit ANSWERUPDATED28(newAnswer, _roundId, now);

    return (true, newAnswer);
  }

  function VALIDATEANSWER492(	//inject NONSTANDARD NAMING
    uint32 _roundId,
    int256 _newAnswer
  )
    private
  {
    AggregatorValidatorInterface av = validator; // cache storage reads
    if (address(av) == address(0)) return;

    uint32 prevRound = _roundId.SUB103(1);
    uint32 prevAnswerRoundId = rounds[prevRound].answeredInRound;
    int256 prevRoundAnswer = rounds[prevRound].answer;
    // We do not want the validator to ever prevent reporting, so we limit its
    // gas usage and catch any errors that may arise.
    try av.VALIDATE825{gas: validator_gas_limit936}(
      prevAnswerRoundId,
      prevRoundAnswer,
      _roundId,
      _newAnswer
    ) {} catch {}
  }

  function PAYORACLE788(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    uint128 payment = details[_roundId].paymentAmount;
    Funds memory funds = recordedFunds;
    funds.available = funds.available.SUB103(payment);
    funds.allocated = funds.allocated.ADD711(payment);
    recordedFunds = funds;
    oracles[msg.sender].withdrawable = oracles[msg.sender].withdrawable.ADD711(payment);

    emit AVAILABLEFUNDSUPDATED544(funds.available);
  }

  function RECORDSUBMISSION1000(int256 _submission, uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    require(ACCEPTINGSUBMISSIONS855(_roundId), "round not accepting submissions");

    details[_roundId].submissions.push(_submission);
    oracles[msg.sender].lastReportedRound = _roundId;
    oracles[msg.sender].latestSubmission = _submission;

    emit SUBMISSIONRECEIVED309(_submission, _roundId, msg.sender);
  }

  function DELETEROUNDDETAILS630(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    if (details[_roundId].submissions.length < details[_roundId].maxSubmissions) return;

    delete details[_roundId];
  }

  function TIMEDOUT67(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    uint64 startedAt = rounds[_roundId].startedAt;
    uint32 roundTimeout = details[_roundId].timeout;
    return startedAt > 0 && roundTimeout > 0 && startedAt.ADD711(roundTimeout) < block.timestamp;
  }

  function GETSTARTINGROUND884(address _oracle)	//inject NONSTANDARD NAMING
    private
    view
    returns (uint32)
  {
    uint32 currentRound = reportingRoundId;
    if (currentRound != 0 && currentRound == oracles[_oracle].endingRound) {
      return currentRound;
    }
    return currentRound.ADD711(1);
  }

  function PREVIOUSANDCURRENTUNANSWERED322(uint32 _roundId, uint32 _rrId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    return _roundId.ADD711(1) == _rrId && rounds[_rrId].updatedAt == 0;
  }

  function REQUIREDRESERVE861(uint256 payment)	//inject NONSTANDARD NAMING
    private
    view
    returns (uint256)
  {
    return payment.MUL19(ORACLECOUNT519()).MUL19(reserve_rounds846);
  }

  function ADDORACLE604(	//inject NONSTANDARD NAMING
    address _oracle,
    address _admin
  )
    private
  {
    require(!ORACLEENABLED271(_oracle), "oracle already enabled");

    require(_admin != address(0), "cannot set admin to 0");
    require(oracles[_oracle].admin == address(0) || oracles[_oracle].admin == _admin, "owner cannot overwrite admin");

    oracles[_oracle].startingRound = GETSTARTINGROUND884(_oracle);
    oracles[_oracle].endingRound = round_max969;
    oracles[_oracle].index = uint16(oracleAddresses.length);
    oracleAddresses.push(_oracle);
    oracles[_oracle].admin = _admin;

    emit ORACLEPERMISSIONSUPDATED729(_oracle, true);
    emit ORACLEADMINUPDATED368(_oracle, _admin);
  }

  function REMOVEORACLE174(	//inject NONSTANDARD NAMING
    address _oracle
  )
    private
  {
    require(ORACLEENABLED271(_oracle), "oracle not enabled");

    oracles[_oracle].endingRound = reportingRoundId.ADD711(1);
    address tail = oracleAddresses[uint256(ORACLECOUNT519()).SUB103(1)];
    uint16 index = oracles[_oracle].index;
    oracles[tail].index = index;
    delete oracles[_oracle].index;
    oracleAddresses[index] = tail;
    oracleAddresses.pop();

    emit ORACLEPERMISSIONSUPDATED729(_oracle, false);
  }

  function VALIDATEORACLEROUND770(address _oracle, uint32 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bytes memory)
  {
    // cache storage reads
    uint32 startingRound = oracles[_oracle].startingRound;
    uint32 rrId = reportingRoundId;

    if (startingRound == 0) return "not enabled oracle";
    if (startingRound > _roundId) return "not yet enabled oracle";
    if (oracles[_oracle].endingRound < _roundId) return "no longer allowed oracle";
    if (oracles[_oracle].lastReportedRound >= _roundId) return "cannot report on previous rounds";
    if (_roundId != rrId && _roundId != rrId.ADD711(1) && !PREVIOUSANDCURRENTUNANSWERED322(_roundId, rrId)) return "invalid round to report";
    if (_roundId != 1 && !SUPERSEDABLE88(_roundId.SUB103(1))) return "previous round not supersedable";
  }

  function SUPERSEDABLE88(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    return rounds[_roundId].updatedAt > 0 || TIMEDOUT67(_roundId);
  }

  function ORACLEENABLED271(address _oracle)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    return oracles[_oracle].endingRound == round_max969;
  }

  function ACCEPTINGSUBMISSIONS855(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    return details[_roundId].maxSubmissions != 0;
  }

  function DELAYED153(address _oracle, uint32 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    uint256 lastStarted = oracles[_oracle].lastStartedRound;
    return _roundId > lastStarted + restartDelay || lastStarted == 0;
  }

  function NEWROUND565(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    return _roundId == reportingRoundId.ADD711(1);
  }

  function VALIDROUNDID318(uint256 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    return _roundId <= round_max969;
  }

}

interface AccessControllerInterface {
  function HASACCESS288(address user, bytes calldata data) external view returns (bool);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                            
contract SimpleWriteAccessController is AccessControllerInterface, Owned {

  bool public checkEnabled;
  mapping(address => bool) internal accessList;

  event ADDEDACCESS289(address user);	//inject NONSTANDARD NAMING
  event REMOVEDACCESS891(address user);	//inject NONSTANDARD NAMING
  event CHECKACCESSENABLED36();	//inject NONSTANDARD NAMING
  event CHECKACCESSDISABLED41();	//inject NONSTANDARD NAMING

  constructor()
    public
  {
    checkEnabled = true;
  }

                                                                                                
  function HASACCESS288(	//inject NONSTANDARD NAMING
    address _user,
    bytes memory
  )
    public
    view
    virtual
    override
    returns (bool)
  {
    return accessList[_user] || !checkEnabled;
  }

                                                                                                
  function ADDACCESS909(address _user)	//inject NONSTANDARD NAMING
    external
    ONLYOWNER559()
  {
    if (!accessList[_user]) {
      accessList[_user] = true;

      emit ADDEDACCESS289(_user);
    }
  }

                                                                                                        
  function REMOVEACCESS253(address _user)	//inject NONSTANDARD NAMING
    external
    ONLYOWNER559()
  {
    if (accessList[_user]) {
      accessList[_user] = false;

      emit REMOVEDACCESS891(_user);
    }
  }

                                                        
  function ENABLEACCESSCHECK763()	//inject NONSTANDARD NAMING
    external
    ONLYOWNER559()
  {
    if (!checkEnabled) {
      checkEnabled = true;

      emit CHECKACCESSENABLED36();
    }
  }

                                                          
  function DISABLEACCESSCHECK53()	//inject NONSTANDARD NAMING
    external
    ONLYOWNER559()
  {
    if (checkEnabled) {
      checkEnabled = false;

      emit CHECKACCESSDISABLED41();
    }
  }

                                                                
  modifier CHECKACCESS28() {	//inject NONSTANDARD NAMING
    require(HASACCESS288(msg.sender, msg.data), "No access");
    _;
  }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
contract SimpleReadAccessController is SimpleWriteAccessController {

                                                                                                
  function HASACCESS288(	//inject NONSTANDARD NAMING
    address _user,
    bytes memory _calldata
  )
    public
    view
    virtual
    override
    returns (bool)
  {
    return super.HASACCESS288(_user, _calldata) || _user == tx.origin;
  }

}

                                                                                                                                                                                                        
contract AccessControlledAggregator is FluxAggregator, SimpleReadAccessController {

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
  constructor(
    address _link,
    uint128 _paymentAmount,
    uint32 _timeout,
    address _validator,
    int256 _minSubmissionValue,
    int256 _maxSubmissionValue,
    uint8 _decimals,
    string memory _description
  ) public FluxAggregator(
    _link,
    _paymentAmount,
    _timeout,
    _validator,
    _minSubmissionValue,
    _maxSubmissionValue,
    _decimals,
    _description
  ){}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  function GETROUNDDATA39(uint80 _roundId)	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS28()
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    )
  {
    return super.GETROUNDDATA39(_roundId);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function LATESTROUNDDATA217()	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS28()
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    )
  {
    return super.LATESTROUNDDATA217();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                        
  function LATESTANSWER707()	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS28()
    returns (int256)
  {
    return super.LATESTANSWER707();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                          
  function LATESTROUND755()	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS28()
    returns (uint256)
  {
    return super.LATESTROUND755();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                           
  function LATESTTIMESTAMP837()	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS28()
    returns (uint256)
  {
    return super.LATESTTIMESTAMP837();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
  function GETANSWER393(uint256 _roundId)	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS28()
    returns (int256)
  {
    return super.GETANSWER393(_roundId);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function GETTIMESTAMP991(uint256 _roundId)	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS28()
    returns (uint256)
  {
    return super.GETTIMESTAMP991(_roundId);
  }

}