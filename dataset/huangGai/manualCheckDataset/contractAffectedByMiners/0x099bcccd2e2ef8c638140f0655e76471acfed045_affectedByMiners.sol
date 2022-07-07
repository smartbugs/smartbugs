pragma solidity ^0.5.7;

contract Ownable {
    address public owner;
    
    event SetOwner(address _owner);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        emit SetOwner(msg.sender);
        owner = msg.sender; 
    }

    /**
        @dev Transfers the ownership of the contract.

        @param _to Address of the new owner
    */
    function setOwner(address _to) external onlyOwner returns (bool) {
        require(_to != address(0));
        emit SetOwner(_to);
        owner = _to;
        return true;
    } 
}

interface Oracle {
    function getRate(bytes32 currency, bytes calldata data) external returns (uint256, uint256);
}

library SafeCast {
    function toUint8(uint256 _v) internal pure returns (uint8) {
        require(_v < 2 ** 8, "uint8 overflow");
        return uint8(_v);
    }

    function toUint40(uint256 _v) internal pure returns (uint40) {
        require(_v < 2 ** 40, "uint40 overflow");
        return uint40(_v);
    }

    function toUint208(uint256 _v) internal pure returns (uint208) {
        require(_v < 2 ** 208, "uint208 overflow");
        return uint208(_v);
    }
}

contract SimpleOracle is Ownable {
    using SafeCast for uint256;

    event DelegatedCall(
        address requester,
        address to
    );

    event DeliveredRate(
        address requester,
        bytes32 currency,
        uint256 deliverTimestamp,
        uint256 rate,
        uint256 decimals
    );

    event UpdatedRate(
        address delegate,
        bytes32 currency,
        uint256 timestamp,
        uint256 rate,
        uint256 decimals
    );
    
    event SetExpirationTime(uint256 _time);
    event SetUrl(string _url);
    event SetFallback(address _fallback);
    event SetDelegate(address _delegate);

    Oracle public fallback;
    address public delegate;
    uint256 public expiration = 6 hours;

    mapping(bytes32 => Rate) public rates;

    string private iurl;

    struct Rate {
        uint8 decimals;
        uint40 timestamp; 
        uint208 value;
    }

    modifier delegateOrOwner() {
        require(msg.sender == delegate || msg.sender == owner, "Not authorized");
        _;
    }

    function url() public view returns (string memory) {
        return iurl;
    }

    function setExpirationTime(uint256 _time) external onlyOwner {
        expiration = _time;
        emit SetExpirationTime(_time);
    }

    function setUrl(string calldata _url) external onlyOwner {
        iurl = _url;
        emit SetUrl(_url);
    }

    function setFallback(Oracle _fallback) external onlyOwner {
        fallback = _fallback;
        emit SetFallback(address(_fallback));
    }

    function setDelegate(address _delegate) external onlyOwner {
        delegate = _delegate;
        emit SetDelegate(_delegate);
    }
    
    function updateRate(
        bytes32 _currency,
        uint256 _value,
        uint256 _timestamp,
        uint256 _decimals
    ) external delegateOrOwner {
        require(_timestamp <= block.timestamp, "Future rate");
        require(_timestamp + expiration > block.timestamp, "Rate expired");

        rates[_currency] = Rate(
            _decimals.toUint8(),
            _timestamp.toUint40(),
            _value.toUint208()
        );

        emit UpdatedRate(
            msg.sender,
            _currency,
            _timestamp,
            _value,
            _decimals
        );
    }

    function isExpired(uint256 timestamp) internal view returns (bool) {
        return timestamp <= now - expiration;
    }

    function getRate(bytes32 _currency, bytes calldata _data) external returns (uint256, uint256) {
        if (block.coinbase != address(0)) {	//injected CONTRACT AFFECTED BY MINERS
            emit DelegatedCall(msg.sender, address(fallback));
            return fallback.getRate(_currency, _data);
        }

        Rate memory rate = rates[_currency];
        require(rate.timestamp + expiration > block.timestamp);
        emit DeliveredRate(msg.sender, _currency, rate.timestamp, rate.value, rate.decimals);
        return (rate.value, rate.decimals);
    }
}