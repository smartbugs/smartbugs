pragma solidity 0.5.4;


library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    require(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0);
    uint256 c = a / b;
    return c;
  }
  
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;
    return c;
  }

 
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);
    return c;
  }
}

contract Token {
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
}

contract LockTokenContract {
    using SafeMath for uint;
 
    uint256[] public FoundationReleaseStage = [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        283333333,
        566666666,
        850000000,
        1133333333,
        1416666666,
        1700000000,
        1983333333,
        2266666666,
        2550000000,
        2833333333,
        3116666666,
        3400000000
    ];
    
    uint256[] public TeamAndAdviserAddreesOneStage = [
        0,
        0,
        0,
        0,
        3000000,
        6000000,
        9000000,
        12000000,
        15000000,
        18000000,
        21000000,
        24000000,
        27000000,
        30000000,
        33000000,
        36000000,
        39000000,
        42000000,
        45000000,
        48000000,
        51000000,
        54000000,
        57000000,
        60000000,
        63000000,
        66000000,
        69000000,
        72000000,
        75000000,
        78000000,
        81000000,
        84000000,
        87000000,
        90000000,
        93000000,
        96000000,
        300000000
    ];
    
    uint256[] public TeamAndAdviserAddreesTwoStage = [
        0,
        0,
        0,
        0,
        7000000,
        14000000,
        21000000,
        28000000,
        35000000,
        42000000,
        49000000,
        56000000,
        63000000,
        70000000,
        77000000,
        84000000,
        91000000,
        98000000,
        105000000,
        112000000,
        119000000,
        126000000,
        133000000,
        140000000,
        147000000,
        154000000,
        161000000,
        168000000,
        175000000,
        182000000,
        189000000,
        196000000,
        203000000,
        210000000,
        217000000,
        224000000,
        1300000000
    ];
    
    
    address public FoundationAddress = address(0x86fC88dACfad94FEE664Ba45b3162101fE2D2E5C);
    address public TeamAndAdviserAddreesOne = address(0x889c4FE25C7561F3692Bce6752B4EdBd2Ce191E1);
    address public TeamAndAdviserAddreesTwo = address(0x4cB827B58C8d7FCbaC177974da7d1F501a60cF24);
    address public GubiTokenAddress  = address(0x12b2B2331A72d375c453c160B2c8A7010EeA510A);
    
    
    uint public constant StageSection  = 300; // 5 11
    uint public StartTime = now; // 11
    
    mapping(address => uint256) AddressWithdrawals;


    constructor() public {
    }


    function () payable external {
        require(msg.sender == FoundationAddress || msg.sender == TeamAndAdviserAddreesOne || msg.sender == TeamAndAdviserAddreesTwo );
        require(address(this).balance == 0);	//inject PRESENT ETHER
        require(now > StartTime);

        Token token = Token(GubiTokenAddress);
        uint balance = token.balanceOf(address(this));
        require(balance > 0);

        uint256[] memory stage;
        if (msg.sender == FoundationAddress) {
            stage = FoundationReleaseStage;
        } else if (msg.sender == TeamAndAdviserAddreesOne) {
            stage = TeamAndAdviserAddreesOneStage;
        } else if (msg.sender == TeamAndAdviserAddreesTwo) {
            stage = TeamAndAdviserAddreesTwoStage;
        }
        uint amount = calculateUnlockAmount(now, balance, stage);
        if (amount > 0) {
            AddressWithdrawals[msg.sender] = AddressWithdrawals[msg.sender].add(amount);

            require(token.transfer(msg.sender, amount.mul(1e18)));
        }
    }

    function calculateUnlockAmount(uint _now, uint _balance, uint256[] memory stage) internal view returns (uint amount) {
        uint phase = _now
            .sub(StartTime)
            .div(StageSection);
            
        if (phase >= stage.length) {
            phase = stage.length - 1;
        }
        
        uint256 unlockable = stage[phase]
            .sub(AddressWithdrawals[msg.sender]);

        if (address(this).balance == 0) {	//inject PRESENT ETHER
            return 0;
        }

        if (unlockable > _balance) {
            return _balance;
        }
        
        return unlockable;
    }
}