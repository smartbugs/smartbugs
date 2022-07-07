                                                                 

// File: contracts/lib/interface/IRouterRegistry.sol

pragma solidity ^0.5.5;


                                                      
interface IRouterRegistry {
    enum RouterOperation { Add, Remove, Refresh }

    function REGISTERROUTER662() external;	//inject NONSTANDARD NAMING

    function DEREGISTERROUTER816() external;	//inject NONSTANDARD NAMING

    function REFRESHROUTER597() external;	//inject NONSTANDARD NAMING

    event ROUTERUPDATED610(RouterOperation indexed op, address indexed routerAddress);	//inject NONSTANDARD NAMING
}

// File: contracts/RouterRegistry.sol

pragma solidity ^0.5.5;


                                                                                                                                                                           
contract RouterRegistry is IRouterRegistry {
    // mapping to store the registered routers address as key 
    // and the lastest registered/refreshed block number as value
    mapping(address => uint) public routerInfo;

                                                                                          
    function REGISTERROUTER662() external {	//inject NONSTANDARD NAMING
        require(routerInfo[msg.sender] == 0, "Router address already exists");

        routerInfo[msg.sender] = block.number;

        emit ROUTERUPDATED610(RouterOperation.Add, msg.sender);
    }

                                                                                         
    function DEREGISTERROUTER816() external {	//inject NONSTANDARD NAMING
        require(routerInfo[msg.sender] != 0, "Router address does not exist");

        delete routerInfo[msg.sender];

        emit ROUTERUPDATED610(RouterOperation.Remove, msg.sender);
    }

                                                                        
    function REFRESHROUTER597() external {	//inject NONSTANDARD NAMING
        require(routerInfo[msg.sender] != 0, "Router address does not exist");

        routerInfo[msg.sender] = block.number;

        emit ROUTERUPDATED610(RouterOperation.Refresh, msg.sender);
    }
}