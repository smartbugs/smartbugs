                                                                 

// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.5.4;

                                                                                                                                                                                                     
contract Proxy {

    address implementation;

    event RECEIVED369(uint indexed value, address indexed sender, bytes data);	//inject NONSTANDARD NAMING

    constructor(address _implementation) public {
        implementation = _implementation;
    }

    function() external payable {

        if (msg.data.length == 0 && msg.value > 0) {
            emit RECEIVED369(msg.value, msg.sender, msg.data);
        } else {
            // solium-disable-next-line security/no-inline-assembly
            assembly {
                let target := sload(0)
                calldatacopy(0, 0, calldatasize())
                let result := delegatecall(gas, target, 0, calldatasize(), 0, 0)
                returndatacopy(0, 0, returndatasize())
                switch result
                case 0 {revert(0, returndatasize())}
                default {return (0, returndatasize())}
            }
        }
    }
}

                                                                                                                                                             
contract BaseWallet {
    function INIT685(address _owner, address[] calldata _modules) external;	//inject NONSTANDARD NAMING
    function AUTHORISEMODULE812(address _module, bool _value) external;	//inject NONSTANDARD NAMING
    function ENABLESTATICCALL186(address _module, bytes4 _method) external;	//inject NONSTANDARD NAMING
    function SETOWNER798(address _newOwner) external;	//inject NONSTANDARD NAMING
    function INVOKE21(address _target, uint _value, bytes calldata _data) external returns (bytes memory _result);	//inject NONSTANDARD NAMING
    function() external payable;
}

                                                                                                                
contract Owned {

    // The owner
    address public owner;

    event OWNERCHANGED436(address indexed _newOwner);	//inject NONSTANDARD NAMING

                                                                  
    modifier ONLYOWNER47 {	//inject NONSTANDARD NAMING
        require(msg.sender == owner, "Must be owner");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

                                                                                                                                    
    function CHANGEOWNER39(address _newOwner) external ONLYOWNER47 {	//inject NONSTANDARD NAMING
        require(_newOwner != address(0), "Address must not be null");
        owner = _newOwner;
        emit OWNERCHANGED436(_newOwner);
    }
}

                                                                                                                                                                      
contract Managed is Owned {

    // The managers
    mapping (address => bool) public managers;

                                                                  
    modifier ONLYMANAGER653 {	//inject NONSTANDARD NAMING
        require(managers[msg.sender] == true, "M: Must be manager");
        _;
    }

    event MANAGERADDED439(address indexed _manager);	//inject NONSTANDARD NAMING
    event MANAGERREVOKED398(address indexed _manager);	//inject NONSTANDARD NAMING

                                                                                           
    function ADDMANAGER871(address _manager) external ONLYOWNER47 {	//inject NONSTANDARD NAMING
        require(_manager != address(0), "M: Address must not be null");
        if (managers[_manager] == false) {
            managers[_manager] = true;
            emit MANAGERADDED439(_manager);
        }
    }

                                                                                              
    function REVOKEMANAGER965(address _manager) external ONLYOWNER47 {	//inject NONSTANDARD NAMING
        require(managers[_manager] == true, "M: Target must be an existing manager");
        delete managers[_manager];
        emit MANAGERREVOKED398(_manager);
    }
}

                                              
interface IENSManager {
    event ROOTNODEOWNERCHANGE990(bytes32 indexed _rootnode, address indexed _newOwner);	//inject NONSTANDARD NAMING
    event ENSRESOLVERCHANGED200(address addr);	//inject NONSTANDARD NAMING
    event REGISTERED245(address indexed _owner, string _ens);	//inject NONSTANDARD NAMING
    event UNREGISTERED914(string _ens);	//inject NONSTANDARD NAMING

    function CHANGEROOTNODEOWNER398(address _newOwner) external;	//inject NONSTANDARD NAMING
    function REGISTER194(string calldata _label, address _owner) external;	//inject NONSTANDARD NAMING
    function ISAVAILABLE666(bytes32 _subnode) external view returns(bool);	//inject NONSTANDARD NAMING
    function GETENSREVERSEREGISTRAR478() external view returns (address);	//inject NONSTANDARD NAMING
    function ENSRESOLVER758() external view returns (address);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                               
contract ModuleRegistry {
    function REGISTERMODULE445(address _module, bytes32 _name) external;	//inject NONSTANDARD NAMING
    function DEREGISTERMODULE847(address _module) external;	//inject NONSTANDARD NAMING
    function REGISTERUPGRADER868(address _upgrader, bytes32 _name) external;	//inject NONSTANDARD NAMING
    function DEREGISTERUPGRADER19(address _upgrader) external;	//inject NONSTANDARD NAMING
    function MODULEINFO202(address _module) external view returns (bytes32);	//inject NONSTANDARD NAMING
    function UPGRADERINFO731(address _upgrader) external view returns (bytes32);	//inject NONSTANDARD NAMING
    function ISREGISTEREDMODULE404(address _module) external view returns (bool);	//inject NONSTANDARD NAMING
    function ISREGISTEREDMODULE404(address[] calldata _modules) external view returns (bool);	//inject NONSTANDARD NAMING
    function ISREGISTEREDUPGRADER426(address _upgrader) external view returns (bool);	//inject NONSTANDARD NAMING
}

                                                                    
interface IGuardianStorage{
    function ADDGUARDIAN190(BaseWallet _wallet, address _guardian) external;	//inject NONSTANDARD NAMING
    function REVOKEGUARDIAN58(BaseWallet _wallet, address _guardian) external;	//inject NONSTANDARD NAMING
    function ISGUARDIAN756(BaseWallet _wallet, address _guardian) external view returns (bool);	//inject NONSTANDARD NAMING
}

                                                                                                                                                         
contract WalletFactory is Owned, Managed {

    // The address of the module dregistry
    address public moduleRegistry;
    // The address of the base wallet implementation
    address public walletImplementation;
    // The address of the ENS manager
    address public ensManager;
    // The address of the GuardianStorage
    address public guardianStorage;

    // *************** Events *************************** //

    event MODULEREGISTRYCHANGED334(address addr);	//inject NONSTANDARD NAMING
    event ENSMANAGERCHANGED648(address addr);	//inject NONSTANDARD NAMING
    event GUARDIANSTORAGECHANGED398(address addr);	//inject NONSTANDARD NAMING
    event WALLETCREATED189(address indexed wallet, address indexed owner, address indexed guardian);	//inject NONSTANDARD NAMING

    // *************** Modifiers *************************** //

                                                                              
    modifier GUARDIANSTORAGEDEFINED740 {	//inject NONSTANDARD NAMING
        require(guardianStorage != address(0), "GuardianStorage address not defined");
        _;
    }

    // *************** Constructor ********************** //

                                                
    constructor(address _moduleRegistry, address _walletImplementation, address _ensManager) public {
        moduleRegistry = _moduleRegistry;
        walletImplementation = _walletImplementation;
        ensManager = _ensManager;
    }

    // *************** External Functions ********************* //

                                                                                                                                                                                                                                                                                                                                                                  
    function CREATEWALLET541(	//inject NONSTANDARD NAMING
        address _owner,
        address[] calldata _modules,
        string calldata _label
    )
        external
        ONLYMANAGER653
    {
        _CREATEWALLET379(_owner, _modules, _label, address(0));
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function CREATEWALLETWITHGUARDIAN388(	//inject NONSTANDARD NAMING
        address _owner,
        address[] calldata _modules,
        string calldata _label,
        address _guardian
    )
        external
        ONLYMANAGER653
        GUARDIANSTORAGEDEFINED740
    {
        require(_guardian != (address(0)), "WF: guardian cannot be null");
        _CREATEWALLET379(_owner, _modules, _label, _guardian);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                      
    function CREATECOUNTERFACTUALWALLET430(	//inject NONSTANDARD NAMING
        address _owner,
        address[] calldata _modules,
        string calldata _label,
        bytes32 _salt
    )
        external
        ONLYMANAGER653
    {
        _CREATECOUNTERFACTUALWALLET436(_owner, _modules, _label, address(0), _salt);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function CREATECOUNTERFACTUALWALLETWITHGUARDIAN167(	//inject NONSTANDARD NAMING
        address _owner,
        address[] calldata _modules,
        string calldata _label,
        address _guardian,
        bytes32 _salt
    )
        external
        ONLYMANAGER653
        GUARDIANSTORAGEDEFINED740
    {
        require(_guardian != (address(0)), "WF: guardian cannot be null");
        _CREATECOUNTERFACTUALWALLET436(_owner, _modules, _label, _guardian, _salt);
    }

                                                                                                                                                                                                                                                                                                           
    function GETADDRESSFORCOUNTERFACTUALWALLET140(	//inject NONSTANDARD NAMING
        address _owner,
        address[] calldata _modules,
        bytes32 _salt
    )
        external
        view
        returns (address _wallet)
    {
        _wallet = _GETADDRESSFORCOUNTERFACTUALWALLET709(_owner, _modules, address(0), _salt);
    }

                                                                                                                                                                                                                                                                                                                                                                                       
    function GETADDRESSFORCOUNTERFACTUALWALLETWITHGUARDIAN758(	//inject NONSTANDARD NAMING
        address _owner,
        address[] calldata _modules,
        address _guardian,
        bytes32 _salt
    )
        external
        view
        returns (address _wallet)
    {
        require(_guardian != (address(0)), "WF: guardian cannot be null");
        _wallet = _GETADDRESSFORCOUNTERFACTUALWALLET709(_owner, _modules, _guardian, _salt);
    }

                                                                                                                                                                         
    function CHANGEMODULEREGISTRY647(address _moduleRegistry) external ONLYOWNER47 {	//inject NONSTANDARD NAMING
        require(_moduleRegistry != address(0), "WF: address cannot be null");
        moduleRegistry = _moduleRegistry;
        emit MODULEREGISTRYCHANGED334(_moduleRegistry);
    }

                                                                                                                                                             
    function CHANGEENSMANAGER916(address _ensManager) external ONLYOWNER47 {	//inject NONSTANDARD NAMING
        require(_ensManager != address(0), "WF: address cannot be null");
        ensManager = _ensManager;
        emit ENSMANAGERCHANGED648(_ensManager);
    }

                                                                                                                                                                          
    function CHANGEGUARDIANSTORAGE66(address _guardianStorage) external ONLYOWNER47 {	//inject NONSTANDARD NAMING
        require(_guardianStorage != address(0), "WF: address cannot be null");
        guardianStorage = _guardianStorage;
        emit GUARDIANSTORAGECHANGED398(_guardianStorage);
    }

                                                                                                                                                                           
    function INIT685(BaseWallet _wallet) external pure { // solium-disable-line no-empty-blocks	//inject NONSTANDARD NAMING
        //do nothing
    }

    // *************** Internal Functions ********************* //

                                                                                                                                                                                                                                                                                                                                                                                                                                             
    function _CREATEWALLET379(address _owner, address[] memory _modules, string memory _label, address _guardian) internal {	//inject NONSTANDARD NAMING
        _VALIDATEINPUTS330(_owner, _modules, _label);
        Proxy proxy = new Proxy(walletImplementation);
        address payable wallet = address(proxy);
        _CONFIGUREWALLET163(BaseWallet(wallet), _owner, _modules, _label, _guardian);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function _CREATECOUNTERFACTUALWALLET436(	//inject NONSTANDARD NAMING
        address _owner,
        address[] memory _modules,
        string memory _label,
        address _guardian,
        bytes32 _salt
    )
        internal
    {
        _VALIDATEINPUTS330(_owner, _modules, _label);
        bytes32 newsalt = _NEWSALT377(_salt, _owner, _modules, _guardian);
        bytes memory code = abi.encodePacked(type(Proxy).creationCode, uint256(walletImplementation));
        address payable wallet;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            wallet := create2(0, add(code, 0x20), mload(code), newsalt)
            if iszero(extcodesize(wallet)) { revert(0, returndatasize) }
        }
        _CONFIGUREWALLET163(BaseWallet(wallet), _owner, _modules, _label, _guardian);
    }

                                                                                                                                                                                                                                                                                                                                                    
    function _CONFIGUREWALLET163(	//inject NONSTANDARD NAMING
        BaseWallet _wallet,
        address _owner,
        address[] memory _modules,
        string memory _label,
        address _guardian
    )
        internal
    {
        // add the factory to modules so it can claim the reverse ENS or add a guardian
        address[] memory extendedModules = new address[](_modules.length + 1);
        extendedModules[0] = address(this);
        for (uint i = 0; i < _modules.length; i++) {
            extendedModules[i + 1] = _modules[i];
        }
        // initialise the wallet with the owner and the extended modules
        _wallet.INIT685(_owner, extendedModules);
        // add guardian if needed
        if (_guardian != address(0)) {
            IGuardianStorage(guardianStorage).ADDGUARDIAN190(_wallet, _guardian);
        }
        // register ENS
        _REGISTERWALLETENS735(address(_wallet), _label);
        // remove the factory from the authorised modules
        _wallet.AUTHORISEMODULE812(address(this), false);
        // emit event
        emit WALLETCREATED189(address(_wallet), _owner, _guardian);
    }

                                                                                                                                                                                                                                                                                                                                                                    
    function _GETADDRESSFORCOUNTERFACTUALWALLET709(	//inject NONSTANDARD NAMING
        address _owner,
        address[] memory _modules,
        address _guardian,
        bytes32 _salt
    )
        internal
        view
        returns (address _wallet)
    {
        bytes32 newsalt = _NEWSALT377(_salt, _owner, _modules, _guardian);
        bytes memory code = abi.encodePacked(type(Proxy).creationCode, uint256(walletImplementation));
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), newsalt, keccak256(code)));
        _wallet = address(uint160(uint256(hash)));
    }

                                                                                                                                                                                                                                                                                                         
    function _NEWSALT377(bytes32 _salt, address _owner, address[] memory _modules, address _guardian) internal pure returns (bytes32) {	//inject NONSTANDARD NAMING
        if (_guardian == address(0)) {
            return keccak256(abi.encodePacked(_salt, _owner, _modules));
        } else {
            return keccak256(abi.encodePacked(_salt, _owner, _modules, _guardian));
        }
    }

                                                                                                                                                                  
    function _VALIDATEINPUTS330(address _owner, address[] memory _modules, string memory _label) internal view {	//inject NONSTANDARD NAMING
        require(_owner != address(0), "WF: owner cannot be null");
        require(_modules.length > 0, "WF: cannot assign with less than 1 module");
        require(ModuleRegistry(moduleRegistry).ISREGISTEREDMODULE404(_modules), "WF: one or more modules are not registered");
        bytes memory labelBytes = bytes(_label);
        require(labelBytes.length != 0, "WF: ENS lable must be defined");
    }

                                                                                                                                                                          
    function _REGISTERWALLETENS735(address payable _wallet, string memory _label) internal {	//inject NONSTANDARD NAMING
        // claim reverse
        address ensResolver = IENSManager(ensManager).ENSRESOLVER758();
        bytes memory methodData = abi.encodeWithSignature("claimWithResolver(address,address)", ensManager, ensResolver);
        address ensReverseRegistrar = IENSManager(ensManager).GETENSREVERSEREGISTRAR478();
        BaseWallet(_wallet).INVOKE21(ensReverseRegistrar, 0, methodData);
        // register with ENS manager
        IENSManager(ensManager).REGISTER194(_label, _wallet);
    }
}