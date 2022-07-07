pragma solidity 0.5.9;

                                                                                                   
library SafeMath {
                                                                                  
    function MUL605(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

                                                                                                                           
    function DIV657(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                              
    function SUB818(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

                                                                            
    function ADD758(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

                                                                                                                                                    
    function MOD448(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}

                                                                                   
interface IERC20 {
    function TRANSFER631(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function APPROVE666(address spender, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM769(address from, address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TOTALSUPPLY761() external view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF683(address who) external view returns (uint256);	//inject NONSTANDARD NAMING

    function ALLOWANCE981(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

    event TRANSFER920(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

    event APPROVAL971(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

                                                                                                                                                     
contract Claimable {
    address public owner;
    address public pendingOwner;

    event OWNERSHIPTRANSFERRED96(	//inject NONSTANDARD NAMING
        address indexed previousOwner,
        address indexed newOwner
    );

                                                                                                                          
    constructor() public {
        owner = msg.sender;
    }

                                                                               
    modifier ONLYOWNER329() {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }

                                                                                               
    modifier ONLYPENDINGOWNER713() {	//inject NONSTANDARD NAMING
        require(msg.sender == pendingOwner);
        _;
    }

                                                                                                                                               
    function TRANSFEROWNERSHIP498(address newOwner) public ONLYOWNER329 {	//inject NONSTANDARD NAMING
        pendingOwner = newOwner;
    }

                                                                                   
    function CLAIMOWNERSHIP631() public ONLYPENDINGOWNER713 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED96(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract Keeper is Claimable {
    using SafeMath for uint256;
    IERC20 public token;
    // the date when withdrawals become possible
    uint256 public unFreezeStartDate;
    // the date when all funds get unfrozen
    uint256 public totalUnFreezeDate;
    // the records about individual balances
    mapping(address => uint256) public balances;
    // the records about already withdrawn amounts
    mapping(address => uint256) public withdrawnBalances;
    // the sum of registered balance
    uint256 public totalBalance;

    constructor(
        IERC20 _token,
        uint256 _unFreezeStartDate,
        uint256 _totalUnFreezeDate
    ) public {
        // solhint-disable-next-line not-rely-on-time
        require(_unFreezeStartDate >= block.timestamp);
        require(_totalUnFreezeDate > _unFreezeStartDate);
        token = _token;
        unFreezeStartDate = _unFreezeStartDate;
        totalUnFreezeDate = _totalUnFreezeDate;
    }

                                                                                                                                                                            
    function ADDBALANCE553(address _to, uint256 _value) public ONLYOWNER329 {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value > 0);
        require(totalBalance.ADD758(_value)
                <= token.BALANCEOF683(address(this)), "not enough tokens");
        balances[_to] = balances[_to].ADD758(_value);
        totalBalance = totalBalance.ADD758(_value);
    }

                                                                                                                                                        
    function WITHDRAW512(address _to, uint256 _value) public {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value > 0);
        require(unFreezeStartDate < now, "not unfrozen yet");
        require(
            (GETUNFROZENAMOUNT640(msg.sender).SUB818(withdrawnBalances[msg.sender]))
            >= _value
        );
        withdrawnBalances[msg.sender] = withdrawnBalances[msg.sender].ADD758(_value);
        totalBalance = totalBalance.SUB818(_value);
        token.TRANSFER631(_to, _value);
    }

                                                                                                                                                                
    function GETUNFROZENAMOUNT640(address _holder) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (now > unFreezeStartDate) {
            if (now > totalUnFreezeDate) {
                return balances[_holder];
            }
            uint256 partialFreezePeriodLen =
                totalUnFreezeDate.SUB818(unFreezeStartDate);
            uint256 secondsSincePeriodStart = now.SUB818(unFreezeStartDate);
            uint256 amount = balances[_holder]
                .MUL605(secondsSincePeriodStart)
                .DIV657(partialFreezePeriodLen);
            return amount;
        }
        return 0;
    }
}