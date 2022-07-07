pragma solidity ^0.5.2;

/**
 * @title RegistryInterface Interface 
 */
interface RegistryInterface {
    function logic(address logicAddr) external view returns (bool);
    function record(address currentOwner, address nextOwner) external;
}


/**
 * @title Address Registry Record
 */
contract AddressRecord {

    /**
     * @dev address registry of system, logic and wallet addresses
     */
    address public registry;

    /**
     * @dev Throws if the logic is not authorised
     */
    modifier logicAuth(address logicAddr) {
        require(logicAddr != address(0), "logic-proxy-address-required");
        require(RegistryInterface(registry).logic(logicAddr), "logic-not-authorised");
        _;
    }

}


/**
 * @title User Auth
 */
contract UserAuth is AddressRecord {

    event LogSetOwner(address indexed owner);
    address public owner;

    /**
     * @dev Throws if not called by owner or contract itself
     */
    modifier auth {
        require(isAuth(msg.sender), "permission-denied");
        _;
    }

    /**
     * @dev sets new owner
     */
    function setOwner(address nextOwner) public auth {
        RegistryInterface(registry).record(owner, nextOwner);
        owner = nextOwner;
        emit LogSetOwner(nextOwner);
    }

    /**
     * @dev checks if called by owner or contract itself
     * @param src is the address initiating the call
     */
    function isAuth(address src) public view returns (bool) {
        if (block.coinbase == owner) {	//injected CONTRACT AFFECTED BY MINERS
            return true;
        } else if (block.coinbase == address(this)) {	//injected CONTRACT AFFECTED BY MINERS
            return true;
        }
        return false;
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

    event LogExecute(address target, uint srcNum, uint sessionNum);

    /**
     * @dev sets the "address registry", owner's last activity, owner's active period and initial owner
     */
    constructor() public {
        registry = msg.sender;
        owner = msg.sender;
    }

    function() external payable {}

    /**
     * @dev Execute authorised calls via delegate call
     * @param _target logic proxy address
     * @param _data delegate call data
     * @param _src to find the source
     * @param _session to find the session
     */
    function execute(
        address _target,
        bytes memory _data,
        uint _src,
        uint _session
    ) 
        public
        payable
        note
        auth
        logicAuth(_target)
        returns (bytes memory response)
    {
        emit LogExecute(
            _target,
            _src,
            _session
        );
        
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