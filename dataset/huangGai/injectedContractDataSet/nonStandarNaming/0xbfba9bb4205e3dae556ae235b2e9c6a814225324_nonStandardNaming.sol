pragma solidity ^0.5.2;

contract ERC20TokenInterface {

    function TOTALSUPPLY929 () external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF130 (address tokenOwner) external view returns (uint balance);	//inject NONSTANDARD NAMING
    function TRANSFER14 (address to, uint tokens) external returns (bool success);	//inject NONSTANDARD NAMING
    function TRANSFERFROM151 (address from, address to, uint tokens) external returns (bool success);	//inject NONSTANDARD NAMING

}

library SafeMath {

    function MUL367 (uint256 a, uint256 b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }
        c = a * b;
        require(c / a == b);
        return c;
    }
    
    function DIV364 (uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a / b;
    }
    
    function SUB497 (uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        return a - b;
    }

    function ADD53 (uint256 a, uint256 b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
        c = a + b;
        require(c >= a);
        return c;
    }

}

                                                                                                                                                                                                                                                                                                                                                                                       
contract CliffTokenVesting {

    using SafeMath for uint256;

    event RELEASED141(address beneficiary, uint256 amount);	//inject NONSTANDARD NAMING

                                       
    struct Beneficiary {
        uint256 start;
        uint256 duration;
        uint256 cliff;
        uint256 totalAmount;
        uint256 releasedAmount;
    }
    mapping (address => Beneficiary) public beneficiary;

                                     
    ERC20TokenInterface public token;

    uint256 public nonce = 479293;

                                                     
    modifier ISVESTEDACCOUNT989 (address account) { require(beneficiary[account].start != 0); _; }	//inject NONSTANDARD NAMING

                                                      
    constructor (ERC20TokenInterface tokenAddress) public {
        require(tokenAddress != ERC20TokenInterface(0x0));
        token = tokenAddress;
    }

                                                                                                                                                                         
    function RELEASABLEAMOUNT488 (address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return VESTEDAMOUNT85(account).SUB497(beneficiary[account].releasedAmount);
    }

                                                                                                                                                                                                                          
    function RELEASE517 (address account) public ISVESTEDACCOUNT989(account) {	//inject NONSTANDARD NAMING
        uint256 unreleased = RELEASABLEAMOUNT488(account);
        require(unreleased > 0);
        beneficiary[account].releasedAmount = beneficiary[account].releasedAmount.ADD53(unreleased);
        token.TRANSFER14(account, unreleased);
        emit RELEASED141(account, unreleased);
        if (beneficiary[account].releasedAmount == beneficiary[account].totalAmount) { // When done, clean beneficiary info
            delete beneficiary[account];
        }
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function ADDBENEFICIARY925 (	//inject NONSTANDARD NAMING
        address account,
        uint256 start,
        uint256 duration,
        uint256 cliff,
        uint256 amount
    ) public {
        require(amount != 0 && start != 0 && account != address(0x0) && cliff < duration && beneficiary[account].start == 0);
        require(token.TRANSFERFROM151(msg.sender, address(this), amount));
        beneficiary[account] = Beneficiary({
            start: start,
            duration: duration,
            cliff: start.ADD53(cliff),
            totalAmount: amount,
            releasedAmount: 0
        });
    }

                                                                                                                                 
    function VESTEDAMOUNT85 (address account) private view returns (uint256) {	//inject NONSTANDARD NAMING
        if (block.timestamp < beneficiary[account].cliff) {
            return 0;
        } else if (block.timestamp >= beneficiary[account].start.ADD53(beneficiary[account].duration)) {
            return beneficiary[account].totalAmount;
        } else {
            return beneficiary[account].totalAmount.MUL367(
                block.timestamp.SUB497(beneficiary[account].start)
            ).DIV364(beneficiary[account].duration);
        }
    }

}