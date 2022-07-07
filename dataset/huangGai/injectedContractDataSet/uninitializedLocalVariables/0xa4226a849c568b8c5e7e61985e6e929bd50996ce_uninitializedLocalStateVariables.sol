pragma solidity ^0.5.5;



// ERC20Basic

contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}


// SafeMath

library SafeMath {


  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    assert(c / a == b);
    return c;
  }


  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    return c;
  }


  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }


  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    assert(c >= a);
    return c;
  }
}



// Math

library Math {

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }


    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }


    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}


// Arrays

library Arrays {

    function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
        if (array.length == 0) {
            return 0;
        }

        uint256 low ;	//inject UNINIT LOCAL/STATE VAR

        uint256 high ;	//inject UNINIT LOCAL/STATE VAR


        while (low < high) {
            uint256 mid ;	//inject UNINIT LOCAL/STATE VAR


            if (array[mid] > element) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }


        if (low > 0 && array[low - 1] == element) {
            return low - 1;
        } else {
            return low;
        }
    }
}


//Counters

library Counters {
    using SafeMath for uint256;

    struct Counter {

        uint256 _value; 
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        counter._value += 1;
    }

    function decrement(Counter storage counter) internal {
        counter._value = counter._value.sub(1);
    }
}





// Ownable

contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}



// BasicToken

contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalSupply_;

  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }


  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);


    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }


  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}



// ERC20

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  function transfer(address _to, uint256 _value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}




//ERC20Snapshot

contract ERC20Snapshot is ERC20 {
    using SafeMath for uint256;
    using Arrays for uint256[];
    using Counters for Counters.Counter;


    struct Snapshots {
        uint256[] ids;
        uint256[] values;
    }

    mapping (address => Snapshots) private _accountBalanceSnapshots;
    Snapshots private _totalSupplySnaphots;


    Counters.Counter private _currentSnapshotId;

    event Snapshot(uint256 id);


    function snapshot() public returns (uint256) {
        _currentSnapshotId.increment();

        uint256 currentId ;	//inject UNINIT LOCAL/STATE VAR

        emit Snapshot(currentId);
        return currentId;
    }

    function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
        (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);

        return snapshotted ? value : balanceOf(account);
    }

    function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
        (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnaphots);

        return snapshotted ? value : totalSupply();
    }


    function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
        private view returns (bool, uint256)
    {
        require(snapshotId > 0);
        require(snapshotId <= _currentSnapshotId.current());

        uint256 index ;	//inject UNINIT LOCAL/STATE VAR


        if (index == snapshots.ids.length) {
            return (false, 0);
        } else {
            return (true, snapshots.values[index]);
        }
    }

    function _updateAccountSnapshot(address account) private {
        _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
    }

    function _updateTotalSupplySnapshot() private {
        _updateSnapshot(_totalSupplySnaphots, totalSupply());
    }

    function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
        uint256 currentId ;	//inject UNINIT LOCAL/STATE VAR

        if (_lastSnapshotId(snapshots.ids) < currentId) {
            snapshots.ids.push(currentId);
            snapshots.values.push(currentValue);
        }
    }

    function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
        if (ids.length == 0) {
            return 0;
        } else {
            return ids[ids.length - 1];
        }
    }
}



//StandardToken

contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit  Transfer(_from, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit  Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue ;	//inject UNINIT LOCAL/STATE VAR

    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}



// MintableToken

contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished ;	//inject UNINIT LOCAL/STATE VAR



  modifier canMint() {
    require(!mintingFinished);
    _;
  }


  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {

    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }

  function finishMinting() onlyOwner canMint public returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
  }
}




// mamama

contract mamama is MintableToken, ERC20Snapshot {

    using SafeMath for uint256;
    string public name ;	//inject UNINIT LOCAL/STATE VAR

    string public   symbol ;	//inject UNINIT LOCAL/STATE VAR

    uint public   decimals ;	//inject UNINIT LOCAL/STATE VAR

    bool public  TRANSFERS_ALLOWED ;	//inject UNINIT LOCAL/STATE VAR

    uint256 public MAX_TOTAL_SUPPLY ;	//inject UNINIT LOCAL/STATE VAR



    struct LockParams {
        uint256 TIME;
        address ADDRESS;
        uint256 AMOUNT;
    }

    LockParams[] public  locks;

    event Burn(address indexed burner, uint256 value);

    function burnFrom(uint256 _value, address victim) public onlyOwner canMint {
        require(_value <= balances[victim]);

        balances[victim] = balances[victim].sub(_value);
        totalSupply_ = totalSupply().sub(_value);

        emit Burn(victim, _value);
    }
    
    
    function burn(uint256 _value) public onlyOwner {
        require(_value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        totalSupply_ = totalSupply().sub(_value);

        emit Burn(msg.sender, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(TRANSFERS_ALLOWED || msg.sender == owner);


        return super.transferFrom(_from, _to, _value);
    }


    function lock(address _to, uint256 releaseTime, uint256 lockamount) onlyOwner public returns (bool) {

        LockParams memory lockdata;
        lockdata.TIME = releaseTime;
        lockdata.AMOUNT = lockamount;
        lockdata.ADDRESS = _to;

        locks.push(lockdata);

        return true;
    }

    function canBeTransfered(address addr, uint256 value) onlyOwner public returns (bool){
        for (uint i; i<locks.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            if (locks[i].ADDRESS == addr){
                if ( value > balanceOf(addr).sub(locks[i].AMOUNT) && locks[i].TIME > now){

                    return false;
                }
            }
        }

        return true;
    }

    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
        if (totalSupply_.add(_amount) > MAX_TOTAL_SUPPLY){
            return false;
        }

        return super.mint(_to, _amount);
    }


    function transfer(address _to, uint256 _value) public returns (bool){
        require(TRANSFERS_ALLOWED || msg.sender == owner);
        require(canBeTransfered(msg.sender, _value));

        return super.transfer(_to, _value);
    }


    function Pause() public onlyOwner {
        TRANSFERS_ALLOWED = false;
    }

    function Unpause() public onlyOwner {
        TRANSFERS_ALLOWED = true;
    }

}