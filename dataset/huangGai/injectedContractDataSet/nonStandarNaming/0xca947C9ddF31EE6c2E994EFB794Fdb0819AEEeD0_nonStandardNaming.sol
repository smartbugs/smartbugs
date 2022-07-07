                                                                 

pragma solidity 0.6.6;


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                   
  function ADD145(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

                                                                                                                                                                                                                                                       
  function SUB54(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b <= a, "SafeMath: subtraction overflow");
    uint256 c = a - b;

    return c;
  }

                                                                                                                                                                                                                               
  function MUL161(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function DIV829(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, "SafeMath: division by zero");
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function MOD954(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b != 0, "SafeMath: modulo by zero");
    return a % b;
  }
}

library SignedSafeMath {
  int256 constant private _int256_min421 = -2**255;	//inject NONSTANDARD NAMING

                                                                          
  function MUL161(int256 a, int256 b) internal pure returns (int256) {	//inject NONSTANDARD NAMING
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    require(!(a == -1 && b == _int256_min421), "SignedSafeMath: multiplication overflow");

    int256 c = a * b;
    require(c / a == b, "SignedSafeMath: multiplication overflow");

    return c;
  }

                                                                                                                   
  function DIV829(int256 a, int256 b) internal pure returns (int256) {	//inject NONSTANDARD NAMING
    require(b != 0, "SignedSafeMath: division by zero");
    require(!(b == -1 && a == _int256_min421), "SignedSafeMath: division overflow");

    int256 c = a / b;

    return c;
  }

                                                                         
  function SUB54(int256 a, int256 b) internal pure returns (int256) {	//inject NONSTANDARD NAMING
    int256 c = a - b;
    require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");

    return c;
  }

                                                                    
  function ADD145(int256 a, int256 b) internal pure returns (int256) {	//inject NONSTANDARD NAMING
    int256 c = a + b;
    require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");

    return c;
  }

                                                                                                                                                                                                                                
  function AVG682(int256 _a, int256 _b)	//inject NONSTANDARD NAMING
    internal
    pure
    returns (int256)
  {
    if ((_a < 0 && _b > 0) || (_a > 0 && _b < 0)) {
      return ADD145(_a, _b) / 2;
    }
    int256 remainder = (_a % 2 + _b % 2) / 2;
    return ADD145(ADD145(_a / 2, _b / 2), remainder);
  }
}

library Median {
  using SignedSafeMath for int256;

  int256 constant int_max839 = 2**255-1;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                  
  function CALCULATE363(int256[] memory list)	//inject NONSTANDARD NAMING
    internal
    pure
    returns (int256)
  {
    return CALCULATEINPLACE706(COPY192(list));
  }

                                                                                                                            
  function CALCULATEINPLACE706(int256[] memory list)	//inject NONSTANDARD NAMING
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
      (median1, median2) = QUICKSELECTTWO107(list, 0, len - 1, middleIndex - 1, middleIndex);
      return SignedSafeMath.AVG682(median1, median2);
    } else {
      return QUICKSELECT317(list, 0, len - 1, middleIndex);
    }
  }

                                                                              
  uint256 constant shortselecttwo_max_length191 = 7;	//inject NONSTANDARD NAMING

                                                                                                                                   
  function SHORTSELECTTWO879(	//inject NONSTANDARD NAMING
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
    int256 x1 = 1 < len ? list[lo + 1] : int_max839;
    int256 x2 = 2 < len ? list[lo + 2] : int_max839;
    int256 x3 = 3 < len ? list[lo + 3] : int_max839;
    int256 x4 = 4 < len ? list[lo + 4] : int_max839;
    int256 x5 = 5 < len ? list[lo + 5] : int_max839;
    int256 x6 = 6 < len ? list[lo + 6] : int_max839;

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

                                                                                                                                                       
  function QUICKSELECT317(int256[] memory list, uint256 lo, uint256 hi, uint256 k)	//inject NONSTANDARD NAMING
    private
    pure
    returns (int256 kth)
  {
    require(lo <= k);
    require(k <= hi);
    while (lo < hi) {
      if (hi - lo < shortselecttwo_max_length191) {
        int256 ignore;
        (kth, ignore) = SHORTSELECTTWO879(list, lo, hi, k, k);
        return kth;
      }
      uint256 pivotIndex = PARTITION723(list, lo, hi);
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

                                                                                                                                                                   
  function QUICKSELECTTWO107(	//inject NONSTANDARD NAMING
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
      if (hi - lo < shortselecttwo_max_length191) {
        return SHORTSELECTTWO879(list, lo, hi, k1, k2);
      }
      uint256 pivotIdx = PARTITION723(list, lo, hi);
      if (k2 <= pivotIdx) {
        hi = pivotIdx;
      } else if (pivotIdx < k1) {
        lo = pivotIdx + 1;
      } else {
        assert(k1 <= pivotIdx && pivotIdx < k2);
        k1th = QUICKSELECT317(list, lo, pivotIdx, k1);
        k2th = QUICKSELECT317(list, pivotIdx + 1, hi, k2);
        return (k1th, k2th);
      }
    }
  }

                                                                                                                                                                                                                                                                                                                             
  function PARTITION723(int256[] memory list, uint256 lo, uint256 hi)	//inject NONSTANDARD NAMING
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

                                                                                                                            
  function COPY192(int256[] memory list)	//inject NONSTANDARD NAMING
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

  event OWNERSHIPTRANSFERREQUESTED940(	//inject NONSTANDARD NAMING
    address indexed from,
    address indexed to
  );
  event OWNERSHIPTRANSFERRED48(	//inject NONSTANDARD NAMING
    address indexed from,
    address indexed to
  );

  constructor() public {
    owner = msg.sender;
  }

                                                                                                     
  function TRANSFEROWNERSHIP383(address _to)	//inject NONSTANDARD NAMING
    external
    ONLYOWNER6()
  {
    pendingOwner = _to;

    emit OWNERSHIPTRANSFERREQUESTED940(owner, _to);
  }

                                                                                    
  function ACCEPTOWNERSHIP965()	//inject NONSTANDARD NAMING
    external
  {
    require(msg.sender == pendingOwner, "Must be proposed owner");

    address oldOwner = owner;
    owner = msg.sender;
    pendingOwner = address(0);

    emit OWNERSHIPTRANSFERRED48(oldOwner, msg.sender);
  }

                                                                                
  modifier ONLYOWNER6() {	//inject NONSTANDARD NAMING
    require(msg.sender == owner, "Only callable by owner");
    _;
  }

}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
library SafeMath128 {
                                                                                                                                                                                                                   
  function ADD145(uint128 a, uint128 b) internal pure returns (uint128) {	//inject NONSTANDARD NAMING
    uint128 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

                                                                                                                                                                                                                                                       
  function SUB54(uint128 a, uint128 b) internal pure returns (uint128) {	//inject NONSTANDARD NAMING
    require(b <= a, "SafeMath: subtraction overflow");
    uint128 c = a - b;

    return c;
  }

                                                                                                                                                                                                                               
  function MUL161(uint128 a, uint128 b) internal pure returns (uint128) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function DIV829(uint128 a, uint128 b) internal pure returns (uint128) {	//inject NONSTANDARD NAMING
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, "SafeMath: division by zero");
    uint128 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function MOD954(uint128 a, uint128 b) internal pure returns (uint128) {	//inject NONSTANDARD NAMING
    require(b != 0, "SafeMath: modulo by zero");
    return a % b;
  }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
library SafeMath32 {
                                                                                                                                                                                                                   
  function ADD145(uint32 a, uint32 b) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
    uint32 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

                                                                                                                                                                                                                                                       
  function SUB54(uint32 a, uint32 b) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
    require(b <= a, "SafeMath: subtraction overflow");
    uint32 c = a - b;

    return c;
  }

                                                                                                                                                                                                                               
  function MUL161(uint32 a, uint32 b) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function DIV829(uint32 a, uint32 b) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, "SafeMath: division by zero");
    uint32 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function MOD954(uint32 a, uint32 b) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
    require(b != 0, "SafeMath: modulo by zero");
    return a % b;
  }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
library SafeMath64 {
                                                                                                                                                                                                                   
  function ADD145(uint64 a, uint64 b) internal pure returns (uint64) {	//inject NONSTANDARD NAMING
    uint64 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

                                                                                                                                                                                                                                                       
  function SUB54(uint64 a, uint64 b) internal pure returns (uint64) {	//inject NONSTANDARD NAMING
    require(b <= a, "SafeMath: subtraction overflow");
    uint64 c = a - b;

    return c;
  }

                                                                                                                                                                                                                               
  function MUL161(uint64 a, uint64 b) internal pure returns (uint64) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function DIV829(uint64 a, uint64 b) internal pure returns (uint64) {	//inject NONSTANDARD NAMING
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, "SafeMath: division by zero");
    uint64 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function MOD954(uint64 a, uint64 b) internal pure returns (uint64) {	//inject NONSTANDARD NAMING
    require(b != 0, "SafeMath: modulo by zero");
    return a % b;
  }
}

interface AggregatorInterface {
  function LATESTANSWER348() external view returns (int256);	//inject NONSTANDARD NAMING
  function LATESTTIMESTAMP303() external view returns (uint256);	//inject NONSTANDARD NAMING
  function LATESTROUND494() external view returns (uint256);	//inject NONSTANDARD NAMING
  function GETANSWER896(uint256 roundId) external view returns (int256);	//inject NONSTANDARD NAMING
  function GETTIMESTAMP461(uint256 roundId) external view returns (uint256);	//inject NONSTANDARD NAMING

  event ANSWERUPDATED260(int256 indexed current, uint256 indexed roundId, uint256 updatedAt);	//inject NONSTANDARD NAMING
  event NEWROUND740(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);	//inject NONSTANDARD NAMING
}

interface AggregatorV3Interface {

  function DECIMALS461() external view returns (uint8);	//inject NONSTANDARD NAMING
  function DESCRIPTION688() external view returns (string memory);	//inject NONSTANDARD NAMING
  function VERSION47() external view returns (uint256);	//inject NONSTANDARD NAMING

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function GETROUNDDATA766(uint80 _roundId)	//inject NONSTANDARD NAMING
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
  function LATESTROUNDDATA762()	//inject NONSTANDARD NAMING
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
  function VALIDATE11(	//inject NONSTANDARD NAMING
    uint256 previousRoundId,
    int256 previousAnswer,
    uint256 currentRoundId,
    int256 currentAnswer
  ) external returns (bool);
}

interface LinkTokenInterface {
  function ALLOWANCE493(address owner, address spender) external view returns (uint256 remaining);	//inject NONSTANDARD NAMING
  function APPROVE867(address spender, uint256 value) external returns (bool success);	//inject NONSTANDARD NAMING
  function BALANCEOF315(address owner) external view returns (uint256 balance);	//inject NONSTANDARD NAMING
  function DECIMALS461() external view returns (uint8 decimalPlaces);	//inject NONSTANDARD NAMING
  function DECREASEAPPROVAL361(address spender, uint256 addedValue) external returns (bool success);	//inject NONSTANDARD NAMING
  function INCREASEAPPROVAL792(address spender, uint256 subtractedValue) external;	//inject NONSTANDARD NAMING
  function NAME612() external view returns (string memory tokenName);	//inject NONSTANDARD NAMING
  function SYMBOL16() external view returns (string memory tokenSymbol);	//inject NONSTANDARD NAMING
  function TOTALSUPPLY470() external view returns (uint256 totalTokensIssued);	//inject NONSTANDARD NAMING
  function TRANSFER233(address to, uint256 value) external returns (bool success);	//inject NONSTANDARD NAMING
  function TRANSFERANDCALL808(address to, uint256 value, bytes calldata data) external returns (bool success);	//inject NONSTANDARD NAMING
  function TRANSFERFROM838(address from, address to, uint256 value) external returns (bool success);	//inject NONSTANDARD NAMING
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

  uint256 constant public override version911 = 3;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                             
  uint256 constant private reserve_rounds982 = 2;	//inject NONSTANDARD NAMING
  uint256 constant private max_oracle_count410 = 77;	//inject NONSTANDARD NAMING
  uint32 constant private round_max162 = 2**32-1;	//inject NONSTANDARD NAMING
  uint256 private constant validator_gas_limit564 = 100000;	//inject NONSTANDARD NAMING
  // An error specific to the Aggregator V3 Interface, to prevent possible
  // confusion around accidentally reading unset values as reported values.
  string constant private v3_no_data_error636 = "No data present";	//inject NONSTANDARD NAMING

  uint32 private reportingRoundId;
  uint32 internal latestRoundId;
  mapping(address => OracleStatus) private oracles;
  mapping(uint32 => Round) internal rounds;
  mapping(uint32 => RoundDetails) internal details;
  mapping(address => Requester) internal requesters;
  address[] private oracleAddresses;
  Funds private recordedFunds;

  event AVAILABLEFUNDSUPDATED487(	//inject NONSTANDARD NAMING
    uint256 indexed amount
  );
  event ROUNDDETAILSUPDATED240(	//inject NONSTANDARD NAMING
    uint128 indexed paymentAmount,
    uint32 indexed minSubmissionCount,
    uint32 indexed maxSubmissionCount,
    uint32 restartDelay,
    uint32 timeout // measured in seconds
  );
  event ORACLEPERMISSIONSUPDATED311(	//inject NONSTANDARD NAMING
    address indexed oracle,
    bool indexed whitelisted
  );
  event ORACLEADMINUPDATED140(	//inject NONSTANDARD NAMING
    address indexed oracle,
    address indexed newAdmin
  );
  event ORACLEADMINUPDATEREQUESTED729(	//inject NONSTANDARD NAMING
    address indexed oracle,
    address admin,
    address newAdmin
  );
  event SUBMISSIONRECEIVED162(	//inject NONSTANDARD NAMING
    int256 indexed submission,
    uint32 indexed round,
    address indexed oracle
  );
  event REQUESTERPERMISSIONSSET676(	//inject NONSTANDARD NAMING
    address indexed requester,
    bool authorized,
    uint32 delay
  );
  event VALIDATORUPDATED807(	//inject NONSTANDARD NAMING
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
    UPDATEFUTUREROUNDS948(_paymentAmount, 0, 0, 0, _timeout);
    SETVALIDATOR301(_validator);
    minSubmissionValue = _minSubmissionValue;
    maxSubmissionValue = _maxSubmissionValue;
    decimals = _decimals;
    description = _description;
    rounds[0].updatedAt = uint64(block.timestamp.SUB54(uint256(_timeout)));
  }

                                                                                                                                                                                                                                      
  function SUBMIT159(uint256 _roundId, int256 _submission)	//inject NONSTANDARD NAMING
    external
  {
    bytes memory error = VALIDATEORACLEROUND243(msg.sender, uint32(_roundId));
    require(_submission >= minSubmissionValue, "value below minSubmissionValue");
    require(_submission <= maxSubmissionValue, "value above maxSubmissionValue");
    require(error.length == 0, string(error));

    ORACLEINITIALIZENEWROUND887(uint32(_roundId));
    RECORDSUBMISSION761(_submission, uint32(_roundId));
    (bool updated, int256 newAnswer) = UPDATEROUNDANSWER573(uint32(_roundId));
    PAYORACLE28(uint32(_roundId));
    DELETEROUNDDETAILS708(uint32(_roundId));
    if (updated) {
      VALIDATEANSWER400(uint32(_roundId), newAnswer);
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  function CHANGEORACLES743(	//inject NONSTANDARD NAMING
    address[] calldata _removed,
    address[] calldata _added,
    address[] calldata _addedAdmins,
    uint32 _minSubmissions,
    uint32 _maxSubmissions,
    uint32 _restartDelay
  )
    external
    ONLYOWNER6()
  {
    for (uint256 i = 0; i < _removed.length; i++) {
      REMOVEORACLE21(_removed[i]);
    }

    require(_added.length == _addedAdmins.length, "need same oracle and admin count");
    require(uint256(ORACLECOUNT250()).ADD145(_added.length) <= max_oracle_count410, "max oracles allowed");

    for (uint256 i = 0; i < _added.length; i++) {
      ADDORACLE657(_added[i], _addedAdmins[i]);
    }

    UPDATEFUTUREROUNDS948(paymentAmount, _minSubmissions, _maxSubmissions, _restartDelay, timeout);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function UPDATEFUTUREROUNDS948(	//inject NONSTANDARD NAMING
    uint128 _paymentAmount,
    uint32 _minSubmissions,
    uint32 _maxSubmissions,
    uint32 _restartDelay,
    uint32 _timeout
  )
    public
    ONLYOWNER6()
  {
    uint32 oracleNum = ORACLECOUNT250(); // Save on storage reads
    require(_maxSubmissions >= _minSubmissions, "max must equal/exceed min");
    require(oracleNum >= _maxSubmissions, "max cannot exceed total");
    require(oracleNum == 0 || oracleNum > _restartDelay, "delay cannot exceed total");
    require(recordedFunds.available >= REQUIREDRESERVE718(_paymentAmount), "insufficient funds for payment");
    if (ORACLECOUNT250() > 0) {
      require(_minSubmissions > 0, "min must be greater than 0");
    }

    paymentAmount = _paymentAmount;
    minSubmissionCount = _minSubmissions;
    maxSubmissionCount = _maxSubmissions;
    restartDelay = _restartDelay;
    timeout = _timeout;

    emit ROUNDDETAILSUPDATED240(
      paymentAmount,
      _minSubmissions,
      _maxSubmissions,
      _restartDelay,
      _timeout
    );
  }

                                                                             
  function ALLOCATEDFUNDS634()	//inject NONSTANDARD NAMING
    external
    view
    returns (uint128)
  {
    return recordedFunds.allocated;
  }

                                                                          
  function AVAILABLEFUNDS625()	//inject NONSTANDARD NAMING
    external
    view
    returns (uint128)
  {
    return recordedFunds.available;
  }

                                                                             
  function UPDATEAVAILABLEFUNDS50()	//inject NONSTANDARD NAMING
    public
  {
    Funds memory funds = recordedFunds;

    uint256 nowAvailable = linkToken.BALANCEOF315(address(this)).SUB54(funds.allocated);

    if (funds.available != nowAvailable) {
      recordedFunds.available = uint128(nowAvailable);
      emit AVAILABLEFUNDSUPDATED487(nowAvailable);
    }
  }

                                                      
  function ORACLECOUNT250() public view returns (uint8) {	//inject NONSTANDARD NAMING
    return uint8(oracleAddresses.length);
  }

                                                                                         
  function GETORACLES524() external view returns (address[] memory) {	//inject NONSTANDARD NAMING
    return oracleAddresses;
  }

                                                                                                                                                                                                                                                                                                                                                                         
  function LATESTANSWER348()	//inject NONSTANDARD NAMING
    public
    view
    virtual
    override
    returns (int256)
  {
    return rounds[latestRoundId].answer;
  }

                                                                                                                                                                                                                                                                                                                                                                            
  function LATESTTIMESTAMP303()	//inject NONSTANDARD NAMING
    public
    view
    virtual
    override
    returns (uint256)
  {
    return rounds[latestRoundId].updatedAt;
  }

                                                                                                                                                                                                                                                                                                                                                                        
  function LATESTROUND494()	//inject NONSTANDARD NAMING
    public
    view
    virtual
    override
    returns (uint256)
  {
    return latestRoundId;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                      
  function GETANSWER896(uint256 _roundId)	//inject NONSTANDARD NAMING
    public
    view
    virtual
    override
    returns (int256)
  {
    if (VALIDROUNDID399(_roundId)) {
      return rounds[uint32(_roundId)].answer;
    }
    return 0;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  function GETTIMESTAMP461(uint256 _roundId)	//inject NONSTANDARD NAMING
    public
    view
    virtual
    override
    returns (uint256)
  {
    if (VALIDROUNDID399(_roundId)) {
      return rounds[uint32(_roundId)].updatedAt;
    }
    return 0;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
  function GETROUNDDATA766(uint80 _roundId)	//inject NONSTANDARD NAMING
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

    require(r.answeredInRound > 0 && VALIDROUNDID399(_roundId), v3_no_data_error636);

    return (
      _roundId,
      r.answer,
      r.startedAt,
      r.updatedAt,
      r.answeredInRound
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
   function LATESTROUNDDATA762()	//inject NONSTANDARD NAMING
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
    return GETROUNDDATA766(latestRoundId);
  }


                                                                                     
  function WITHDRAWABLEPAYMENT432(address _oracle)	//inject NONSTANDARD NAMING
    external
    view
    returns (uint256)
  {
    return oracles[_oracle].withdrawable;
  }

                                                                                                                                                                                                                                                                                               
  function WITHDRAWPAYMENT607(address _oracle, address _recipient, uint256 _amount)	//inject NONSTANDARD NAMING
    external
  {
    require(oracles[_oracle].admin == msg.sender, "only callable by admin");

    // Safe to downcast _amount because the total amount of LINK is less than 2^128.
    uint128 amount = uint128(_amount);
    uint128 available = oracles[_oracle].withdrawable;
    require(available >= amount, "insufficient withdrawable funds");

    oracles[_oracle].withdrawable = available.SUB54(amount);
    recordedFunds.allocated = recordedFunds.allocated.SUB54(amount);

    assert(linkToken.TRANSFER233(_recipient, uint256(amount)));
  }

                                                                                                                                                                                  
  function WITHDRAWFUNDS431(address _recipient, uint256 _amount)	//inject NONSTANDARD NAMING
    external
    ONLYOWNER6()
  {
    uint256 available = uint256(recordedFunds.available);
    require(available.SUB54(REQUIREDRESERVE718(paymentAmount)) >= _amount, "insufficient reserve funds");
    require(linkToken.TRANSFER233(_recipient, _amount), "token transfer failed");
    UPDATEAVAILABLEFUNDS50();
  }

                                                                                                                                         
  function GETADMIN40(address _oracle)	//inject NONSTANDARD NAMING
    external
    view
    returns (address)
  {
    return oracles[_oracle].admin;
  }

                                                                                                                                                                                                  
  function TRANSFERADMIN329(address _oracle, address _newAdmin)	//inject NONSTANDARD NAMING
    external
  {
    require(oracles[_oracle].admin == msg.sender, "only callable by admin");
    oracles[_oracle].pendingAdmin = _newAdmin;

    emit ORACLEADMINUPDATEREQUESTED729(_oracle, msg.sender, _newAdmin);
  }

                                                                                                                                                          
  function ACCEPTADMIN844(address _oracle)	//inject NONSTANDARD NAMING
    external
  {
    require(oracles[_oracle].pendingAdmin == msg.sender, "only callable by pending admin");
    oracles[_oracle].pendingAdmin = address(0);
    oracles[_oracle].admin = msg.sender;

    emit ORACLEADMINUPDATED140(_oracle, msg.sender);
  }

                                                                  
  function REQUESTNEWROUND677()	//inject NONSTANDARD NAMING
    external
    returns (uint80)
  {
    require(requesters[msg.sender].authorized, "not authorized requester");

    uint32 current = reportingRoundId;
    require(rounds[current].updatedAt > 0 || TIMEDOUT101(current), "prev round must be supersedable");

    uint32 newRoundId = current.ADD145(1);
    REQUESTERINITIALIZENEWROUND37(newRoundId);
    return newRoundId;
  }

                                                                                                                                                                                                                                                                                                                                               
  function SETREQUESTERPERMISSIONS783(address _requester, bool _authorized, uint32 _delay)	//inject NONSTANDARD NAMING
    external
    ONLYOWNER6()
  {
    if (requesters[_requester].authorized == _authorized) return;

    if (_authorized) {
      requesters[_requester].authorized = _authorized;
      requesters[_requester].delay = _delay;
    } else {
      delete requesters[_requester];
    }

    emit REQUESTERPERMISSIONSSET676(_requester, _authorized, _delay);
  }

                                                                                                                                                                                                                                                                                  
  function ONTOKENTRANSFER807(address, uint256, bytes calldata _data)	//inject NONSTANDARD NAMING
    external
  {
    require(_data.length == 0, "transfer doesn't accept calldata");
    UPDATEAVAILABLEFUNDS50();
  }

                                                                                                                                                                                                                                  
  function ORACLEROUNDSTATE90(address _oracle, uint32 _queriedRoundId)	//inject NONSTANDARD NAMING
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
        ELIGIBLEFORSPECIFICROUND479(_oracle, _queriedRoundId),
        _queriedRoundId,
        oracles[_oracle].latestSubmission,
        round.startedAt,
        details.timeout,
        recordedFunds.available,
        ORACLECOUNT250(),
        (round.startedAt > 0 ? details.paymentAmount : paymentAmount)
      );
    } else {
      return ORACLEROUNDSTATESUGGESTROUND66(_oracle);
    }
  }

                                                                                                                                                                           
  function SETVALIDATOR301(address _newValidator)	//inject NONSTANDARD NAMING
    public
    ONLYOWNER6()
  {
    address previous = address(validator);

    if (previous != _newValidator) {
      validator = AggregatorValidatorInterface(_newValidator);

      emit VALIDATORUPDATED807(previous, _newValidator);
    }
  }


                        

  function INITIALIZENEWROUND636(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    UPDATETIMEDOUTROUNDINFO506(_roundId.SUB54(1));

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

    emit NEWROUND740(_roundId, msg.sender, rounds[_roundId].startedAt);
  }

  function ORACLEINITIALIZENEWROUND887(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    if (!NEWROUND17(_roundId)) return;
    uint256 lastStarted = oracles[msg.sender].lastStartedRound; // cache storage reads
    if (_roundId <= lastStarted + restartDelay && lastStarted != 0) return;

    INITIALIZENEWROUND636(_roundId);

    oracles[msg.sender].lastStartedRound = _roundId;
  }

  function REQUESTERINITIALIZENEWROUND37(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    if (!NEWROUND17(_roundId)) return;
    uint256 lastStarted = requesters[msg.sender].lastStartedRound; // cache storage reads
    require(_roundId > lastStarted + requesters[msg.sender].delay || lastStarted == 0, "must delay requests");

    INITIALIZENEWROUND636(_roundId);

    requesters[msg.sender].lastStartedRound = _roundId;
  }

  function UPDATETIMEDOUTROUNDINFO506(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    if (!TIMEDOUT101(_roundId)) return;

    uint32 prevId = _roundId.SUB54(1);
    rounds[_roundId].answer = rounds[prevId].answer;
    rounds[_roundId].answeredInRound = rounds[prevId].answeredInRound;
    rounds[_roundId].updatedAt = uint64(block.timestamp);

    delete details[_roundId];
  }

  function ELIGIBLEFORSPECIFICROUND479(address _oracle, uint32 _queriedRoundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool _eligible)
  {
    if (rounds[_queriedRoundId].startedAt > 0) {
      return ACCEPTINGSUBMISSIONS813(_queriedRoundId) && VALIDATEORACLEROUND243(_oracle, _queriedRoundId).length == 0;
    } else {
      return DELAYED922(_oracle, _queriedRoundId) && VALIDATEORACLEROUND243(_oracle, _queriedRoundId).length == 0;
    }
  }

  function ORACLEROUNDSTATESUGGESTROUND66(address _oracle)	//inject NONSTANDARD NAMING
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

    bool shouldSupersede = oracle.lastReportedRound == reportingRoundId || !ACCEPTINGSUBMISSIONS813(reportingRoundId);
    // Instead of nudging oracles to submit to the next round, the inclusion of
    // the shouldSupersede bool in the if condition pushes them towards
    // submitting in a currently open round.
    if (SUPERSEDABLE18(reportingRoundId) && shouldSupersede) {
      _roundId = reportingRoundId.ADD145(1);
      round = rounds[_roundId];

      _paymentAmount = paymentAmount;
      _eligibleToSubmit = DELAYED922(_oracle, _roundId);
    } else {
      _roundId = reportingRoundId;
      round = rounds[_roundId];

      _paymentAmount = details[_roundId].paymentAmount;
      _eligibleToSubmit = ACCEPTINGSUBMISSIONS813(_roundId);
    }

    if (VALIDATEORACLEROUND243(_oracle, _roundId).length != 0) {
      _eligibleToSubmit = false;
    }

    return (
      _eligibleToSubmit,
      _roundId,
      oracle.latestSubmission,
      round.startedAt,
      details[_roundId].timeout,
      recordedFunds.available,
      ORACLECOUNT250(),
      _paymentAmount
    );
  }

  function UPDATEROUNDANSWER573(uint32 _roundId)	//inject NONSTANDARD NAMING
    internal
    returns (bool, int256)
  {
    if (details[_roundId].submissions.length < details[_roundId].minSubmissions) {
      return (false, 0);
    }

    int256 newAnswer = Median.CALCULATEINPLACE706(details[_roundId].submissions);
    rounds[_roundId].answer = newAnswer;
    rounds[_roundId].updatedAt = uint64(block.timestamp);
    rounds[_roundId].answeredInRound = _roundId;
    latestRoundId = _roundId;

    emit ANSWERUPDATED260(newAnswer, _roundId, now);

    return (true, newAnswer);
  }

  function VALIDATEANSWER400(	//inject NONSTANDARD NAMING
    uint32 _roundId,
    int256 _newAnswer
  )
    private
  {
    AggregatorValidatorInterface av = validator; // cache storage reads
    if (address(av) == address(0)) return;

    uint32 prevRound = _roundId.SUB54(1);
    uint32 prevAnswerRoundId = rounds[prevRound].answeredInRound;
    int256 prevRoundAnswer = rounds[prevRound].answer;
    // We do not want the validator to ever prevent reporting, so we limit its
    // gas usage and catch any errors that may arise.
    try av.VALIDATE11{gas: validator_gas_limit564}(
      prevAnswerRoundId,
      prevRoundAnswer,
      _roundId,
      _newAnswer
    ) {} catch {}
  }

  function PAYORACLE28(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    uint128 payment = details[_roundId].paymentAmount;
    Funds memory funds = recordedFunds;
    funds.available = funds.available.SUB54(payment);
    funds.allocated = funds.allocated.ADD145(payment);
    recordedFunds = funds;
    oracles[msg.sender].withdrawable = oracles[msg.sender].withdrawable.ADD145(payment);

    emit AVAILABLEFUNDSUPDATED487(funds.available);
  }

  function RECORDSUBMISSION761(int256 _submission, uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    require(ACCEPTINGSUBMISSIONS813(_roundId), "round not accepting submissions");

    details[_roundId].submissions.push(_submission);
    oracles[msg.sender].lastReportedRound = _roundId;
    oracles[msg.sender].latestSubmission = _submission;

    emit SUBMISSIONRECEIVED162(_submission, _roundId, msg.sender);
  }

  function DELETEROUNDDETAILS708(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
  {
    if (details[_roundId].submissions.length < details[_roundId].maxSubmissions) return;

    delete details[_roundId];
  }

  function TIMEDOUT101(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    uint64 startedAt = rounds[_roundId].startedAt;
    uint32 roundTimeout = details[_roundId].timeout;
    return startedAt > 0 && roundTimeout > 0 && startedAt.ADD145(roundTimeout) < block.timestamp;
  }

  function GETSTARTINGROUND70(address _oracle)	//inject NONSTANDARD NAMING
    private
    view
    returns (uint32)
  {
    uint32 currentRound = reportingRoundId;
    if (currentRound != 0 && currentRound == oracles[_oracle].endingRound) {
      return currentRound;
    }
    return currentRound.ADD145(1);
  }

  function PREVIOUSANDCURRENTUNANSWERED532(uint32 _roundId, uint32 _rrId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    return _roundId.ADD145(1) == _rrId && rounds[_rrId].updatedAt == 0;
  }

  function REQUIREDRESERVE718(uint256 payment)	//inject NONSTANDARD NAMING
    private
    view
    returns (uint256)
  {
    return payment.MUL161(ORACLECOUNT250()).MUL161(reserve_rounds982);
  }

  function ADDORACLE657(	//inject NONSTANDARD NAMING
    address _oracle,
    address _admin
  )
    private
  {
    require(!ORACLEENABLED658(_oracle), "oracle already enabled");

    require(_admin != address(0), "cannot set admin to 0");
    require(oracles[_oracle].admin == address(0) || oracles[_oracle].admin == _admin, "owner cannot overwrite admin");

    oracles[_oracle].startingRound = GETSTARTINGROUND70(_oracle);
    oracles[_oracle].endingRound = round_max162;
    oracles[_oracle].index = uint16(oracleAddresses.length);
    oracleAddresses.push(_oracle);
    oracles[_oracle].admin = _admin;

    emit ORACLEPERMISSIONSUPDATED311(_oracle, true);
    emit ORACLEADMINUPDATED140(_oracle, _admin);
  }

  function REMOVEORACLE21(	//inject NONSTANDARD NAMING
    address _oracle
  )
    private
  {
    require(ORACLEENABLED658(_oracle), "oracle not enabled");

    oracles[_oracle].endingRound = reportingRoundId.ADD145(1);
    address tail = oracleAddresses[uint256(ORACLECOUNT250()).SUB54(1)];
    uint16 index = oracles[_oracle].index;
    oracles[tail].index = index;
    delete oracles[_oracle].index;
    oracleAddresses[index] = tail;
    oracleAddresses.pop();

    emit ORACLEPERMISSIONSUPDATED311(_oracle, false);
  }

  function VALIDATEORACLEROUND243(address _oracle, uint32 _roundId)	//inject NONSTANDARD NAMING
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
    if (_roundId != rrId && _roundId != rrId.ADD145(1) && !PREVIOUSANDCURRENTUNANSWERED532(_roundId, rrId)) return "invalid round to report";
    if (_roundId != 1 && !SUPERSEDABLE18(_roundId.SUB54(1))) return "previous round not supersedable";
  }

  function SUPERSEDABLE18(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    return rounds[_roundId].updatedAt > 0 || TIMEDOUT101(_roundId);
  }

  function ORACLEENABLED658(address _oracle)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    return oracles[_oracle].endingRound == round_max162;
  }

  function ACCEPTINGSUBMISSIONS813(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    return details[_roundId].maxSubmissions != 0;
  }

  function DELAYED922(address _oracle, uint32 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    uint256 lastStarted = oracles[_oracle].lastStartedRound;
    return _roundId > lastStarted + restartDelay || lastStarted == 0;
  }

  function NEWROUND17(uint32 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    return _roundId == reportingRoundId.ADD145(1);
  }

  function VALIDROUNDID399(uint256 _roundId)	//inject NONSTANDARD NAMING
    private
    view
    returns (bool)
  {
    return _roundId <= round_max162;
  }

}

interface AccessControllerInterface {
  function HASACCESS656(address user, bytes calldata data) external view returns (bool);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                            
contract SimpleWriteAccessController is AccessControllerInterface, Owned {

  bool public checkEnabled;
  mapping(address => bool) internal accessList;

  event ADDEDACCESS832(address user);	//inject NONSTANDARD NAMING
  event REMOVEDACCESS756(address user);	//inject NONSTANDARD NAMING
  event CHECKACCESSENABLED184();	//inject NONSTANDARD NAMING
  event CHECKACCESSDISABLED416();	//inject NONSTANDARD NAMING

  constructor()
    public
  {
    checkEnabled = true;
  }

                                                                                                
  function HASACCESS656(	//inject NONSTANDARD NAMING
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

                                                                                                
  function ADDACCESS313(address _user)	//inject NONSTANDARD NAMING
    external
    ONLYOWNER6()
  {
    if (!accessList[_user]) {
      accessList[_user] = true;

      emit ADDEDACCESS832(_user);
    }
  }

                                                                                                        
  function REMOVEACCESS708(address _user)	//inject NONSTANDARD NAMING
    external
    ONLYOWNER6()
  {
    if (accessList[_user]) {
      accessList[_user] = false;

      emit REMOVEDACCESS756(_user);
    }
  }

                                                        
  function ENABLEACCESSCHECK558()	//inject NONSTANDARD NAMING
    external
    ONLYOWNER6()
  {
    if (!checkEnabled) {
      checkEnabled = true;

      emit CHECKACCESSENABLED184();
    }
  }

                                                          
  function DISABLEACCESSCHECK244()	//inject NONSTANDARD NAMING
    external
    ONLYOWNER6()
  {
    if (checkEnabled) {
      checkEnabled = false;

      emit CHECKACCESSDISABLED416();
    }
  }

                                                                
  modifier CHECKACCESS464() {	//inject NONSTANDARD NAMING
    require(HASACCESS656(msg.sender, msg.data), "No access");
    _;
  }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
contract SimpleReadAccessController is SimpleWriteAccessController {

                                                                                                
  function HASACCESS656(	//inject NONSTANDARD NAMING
    address _user,
    bytes memory _calldata
  )
    public
    view
    virtual
    override
    returns (bool)
  {
    return super.HASACCESS656(_user, _calldata) || _user == tx.origin;
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  function GETROUNDDATA766(uint80 _roundId)	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS464()
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    )
  {
    return super.GETROUNDDATA766(_roundId);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function LATESTROUNDDATA762()	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS464()
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    )
  {
    return super.LATESTROUNDDATA762();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                        
  function LATESTANSWER348()	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS464()
    returns (int256)
  {
    return super.LATESTANSWER348();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                          
  function LATESTROUND494()	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS464()
    returns (uint256)
  {
    return super.LATESTROUND494();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                           
  function LATESTTIMESTAMP303()	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS464()
    returns (uint256)
  {
    return super.LATESTTIMESTAMP303();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
  function GETANSWER896(uint256 _roundId)	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS464()
    returns (int256)
  {
    return super.GETANSWER896(_roundId);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function GETTIMESTAMP461(uint256 _roundId)	//inject NONSTANDARD NAMING
    public
    view
    override
    CHECKACCESS464()
    returns (uint256)
  {
    return super.GETTIMESTAMP461(_roundId);
  }

}