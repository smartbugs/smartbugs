/**
 *Submitted for verification at Etherscan.io on 2020-01-22
*/

pragma solidity 0.5.11;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //assert(c >= a);
        return c;
    }
}

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * See https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) balances;

    uint256 totalSupply_;

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    /**
    * @dev Transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Address must not be zero.");
        require(_value <= balances[msg.sender], "There is no enough balance.");

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

}

contract AtomicSwapErc20 {
    
    struct Swap {
        bytes32 hashedSecret;
        bytes32 secret;
        uint initTimestamp;
        uint refundTime;
        address payable initiator;
        address payable participant;
        uint256 value;
        bool emptied;
        bool initiated;
        address token;
    }

    mapping(bytes32 => Swap) public swaps;

    event Refunded(
        bytes32 indexed _hashedSecret,
        uint _refundTime
    );
    event Redeemed(
        bytes32 indexed _hashedSecret,
        bytes32 _secret,
        uint _redeemTime
    );
    event Initiated(
        bytes32 indexed _hashedSecret,
        uint _initTimestamp,
        uint _refundTime,
        address indexed _participant,
        address indexed _initiator,
        uint256 _value
    );

    constructor() public {
    }

    modifier isRefundable(bytes32 _hashedSecret) {
        require(block.timestamp > swaps[_hashedSecret].initTimestamp + swaps[_hashedSecret].refundTime, "refundTime has not come");
        _;
    }

    modifier isRedeemable(bytes32 _hashedSecret, bytes32 _secret) {
        require(block.timestamp <= swaps[_hashedSecret].initTimestamp + swaps[_hashedSecret].refundTime, "refundTime has already come");
        require(sha256(abi.encodePacked(_secret)) == _hashedSecret, "secret is not correct");
        _;
    }

    modifier isInitiated(bytes32 _hashedSecret) {
        require(swaps[_hashedSecret].emptied == false, "swap for this hash is already emptied");
        require(swaps[_hashedSecret].initiated == true, "no initiated swap for such hash");
        _;
    }

    modifier isInitiatable(bytes32 _hashedSecret) {
        require(swaps[_hashedSecret].emptied == false, "swap for this hash is already emptied");
        require(swaps[_hashedSecret].initiated == false, "swap for this hash is already initiated");
        _;
    }

    function initiate (bytes32 _hashedSecret, uint _refundTime, address payable _participant, uint256 value, address payable token)
    public payable isInitiatable(_hashedSecret) {
        
        swaps[_hashedSecret].hashedSecret = _hashedSecret;
        swaps[_hashedSecret].initTimestamp = block.timestamp;
        swaps[_hashedSecret].refundTime = _refundTime;
        swaps[_hashedSecret].initiator = msg.sender;
        swaps[_hashedSecret].participant = _participant;
        swaps[_hashedSecret].value = value;
        swaps[_hashedSecret].initiated = true;
        swaps[_hashedSecret].token = token;

        emit Initiated(
            _hashedSecret,
            swaps[_hashedSecret].initTimestamp,
            swaps[_hashedSecret].refundTime,
            swaps[_hashedSecret].participant,
            msg.sender,
            swaps[_hashedSecret].value
        );
    }
    
    function getContractAddress() public view returns (address){
        return address(this);
    }
    
    function redeem(bytes32 _hashedSecret, bytes32 _secret) public isInitiated(_hashedSecret) isRedeemable(_hashedSecret, _secret) {
        swaps[_hashedSecret].emptied = true;
        swaps[_hashedSecret].secret = _secret;

        emit Redeemed(
            _hashedSecret,
            _secret,
            block.timestamp
        );

        ERC20Basic(swaps[_hashedSecret].token).transfer(swaps[_hashedSecret].participant, swaps[_hashedSecret].value);
    }

    function refund(bytes32 _hashedSecret) public isInitiated(_hashedSecret) isRefundable(_hashedSecret) {
        swaps[_hashedSecret].emptied = true;
        swaps[_hashedSecret].initiated = false;

        emit Refunded(
            _hashedSecret,
            block.timestamp
        );

        swaps[_hashedSecret].initiator.transfer(swaps[_hashedSecret].value);
    }
    
    function stringToBytes32(string memory source) public view returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
            result := mload(add(source, 32))
        }
    }

    function bytes32ToSHA256(bytes32 _secret) public view returns(bytes32) {
        return sha256(abi.encodePacked(_secret));
    }
    
    function getTimestamp() public view returns(uint256) {
        return block.timestamp;
    }
    
    function getTimestampPlusHour() public view returns(uint256) {
        return block.timestamp+3600;
    }
    
    function getBalanceSwap(bytes32 _hashedSecret) public view returns (uint256) {
        return swaps[_hashedSecret].value;
    }
    
    function getSecretSwap(bytes32 _hashedSecret) public view returns (bytes32) {
        return swaps[_hashedSecret].secret;
    }
}