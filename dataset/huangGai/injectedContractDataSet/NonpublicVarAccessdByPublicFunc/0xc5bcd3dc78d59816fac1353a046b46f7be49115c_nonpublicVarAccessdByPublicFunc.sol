pragma solidity ^0.5.0;


/**
 * @title User Auth
 */
contract UserAuth {

    event LogSetOwner(address indexed owner, address setter);
    address internal owner;

    /**
     * @dev Throws if not called by owner or contract itself
     */
    modifier auth {
        require(msg.sender == owner, "permission-denied");
        _;
    }
    
    /**
     * @dev sets new owner
     * @param _owner is the new owner of this proxy contract
     */
    function setOwner(address _owner) public auth {
        owner = _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit LogSetOwner(owner, msg.sender);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

}


/**
 * @dev logging the execute events
 */
contract UserNote {
    event LogNote(
        bytes4 indexed sig,
        address indexed guy,
        bytes32 indexed foo,
        bytes32 bar,
        uint wad,
        bytes fax
    );

    modifier note {
        bytes32 foo;
        bytes32 bar;
        assembly {
            foo := calldataload(4)
            bar := calldataload(36)
        }
        emit LogNote(
            msg.sig, 
            msg.sender, 
            foo, 
            bar, 
            msg.value, 
            msg.data
        );
        _;
    }
}


/**
 * @title User Owned Contract Wallet
 */
contract UserWallet is UserAuth, UserNote {

    event LogExecute(address target);

    /**
     * @dev sets the initial owner
     */
    constructor() public {
        owner = msg.sender; // will be changed in initial call
    }

    function() external payable {}

    /**
     * @dev execute authorised calls via delegate call
     * @param _target logic proxy address
     * @param _data delegate call data
     */
    function execute(address _target, bytes memory _data) 
        public
        payable
        note
        auth
        returns (bytes memory response)
    {
        require(_target != address(0), "invalid-logic-proxy-address");
        emit LogExecute(_target);
        
        // call contract in current context
        assembly {
            let succeeded := delegatecall(sub(gas, 5000), _target, add(_data, 0x20), mload(_data), 0, 0)
            let size := returndatasize

            response := mload(0x40)
            mstore(0x40, add(response, and(add(add(size, 0x20), 0x1f), not(0x1f))))
            mstore(response, size)
            returndatacopy(add(response, 0x20), 0, size)

            switch iszero(succeeded)
                case 1 {
                    // throw if delegatecall failed
                    revert(add(response, 0x20), size)
                }
        }
    }

}


/**
 * @title User Wallet Registry
 */
contract WalletRegistry {
    
    event Created(address indexed sender, address indexed owner, address proxy);
    mapping(address => UserWallet) internal proxies;

    /**
     * @dev deploys a new proxy instance and sets custom owner of proxy
     * Throws if the owner already have a UserWallet
     */
    function build() public returns (UserWallet proxy) {
        require(proxies[msg.sender] == UserWallet(0), "multiple-proxy-per-user-not-allowed");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        proxy = new UserWallet();
        proxy.setOwner(msg.sender);
        emit Created(msg.sender, msg.sender, address(proxy));
        proxies[msg.sender] = proxy;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

}