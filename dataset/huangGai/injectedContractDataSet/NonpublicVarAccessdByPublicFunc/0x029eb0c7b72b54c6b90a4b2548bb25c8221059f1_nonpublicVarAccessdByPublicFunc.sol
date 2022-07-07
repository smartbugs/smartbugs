pragma solidity ^0.5.7;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Ownable {
	address internal owner;
	address internal newOwner;

	event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

	constructor() public {
		owner = msg.sender;
		newOwner = address(0);
	}

	modifier onlyOwner() {
		require(msg.sender == owner, "msg.sender == owner");
		_;
	}

	function transferOwnership(address _newOwner) public onlyOwner {
		require(address(0) != _newOwner, "address(0) != _newOwner");
		newOwner = _newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}

	function acceptOwnership() public {
		require(msg.sender == newOwner, "msg.sender == newOwner");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		emit OwnershipTransferred(owner, msg.sender);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		owner = msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		newOwner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}
}

contract Authorizable is Ownable {
    mapping(address => bool) internal authorized;
  
    event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);

    constructor() public {
        authorized[msg.sender] = true;
    }

    modifier onlyAuthorized() {
        require(authorized[msg.sender], "authorized[msg.sender]");
        _;
    }

    function setAuthorized(address addressAuthorized, bool authorization) onlyOwner public {
        emit AuthorizationSet(addressAuthorized, authorization);
        authorized[addressAuthorized] = authorization;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
  
}
 
contract tokenInterface {
    function transfer(address _to, uint256 _value) public returns (bool);
}

contract MultiSender is Authorizable {
	tokenInterface internal tokenContract;
	mapping( bytes32 => bool) internal txDone;
	
	constructor(address _tokenAddress) public {
	    tokenContract = tokenInterface(_tokenAddress);
	}
	
	function updateTokenContract(address _tokenAddress) public onlyAuthorized {
        tokenContract = tokenInterface(_tokenAddress);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
	
    function multiSend(address[] memory _dests, uint256[] memory _values, bytes32[] memory _id) public onlyAuthorized {
        require(_dests.length == _values.length, "_dests.length == _values.length");
        require(_dests.length == _id.length, "_dests.length == _id.length");
        for( uint256 i = 0; i < _dests.length; i += 1 ) {
            if ( txDone[_id[i]] == false ) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                tokenContract.transfer(_dests[i], _values[i]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                txDone[_id[i]] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }
        }
    }
	
	function withdrawTokens(address to, uint256 value) public onlyAuthorized returns (bool) {
        return tokenContract.transfer(to, value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function withdrawEther() public onlyAuthorized returns (bool) {
        msg.sender.transfer(address(this).balance);
        return true;
    }
}