                                                                 

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface AccountInterface {
    function ISAUTH768(address user) external view returns (bool);	//inject NONSTANDARD NAMING
    function SHEILD383() external view returns (bool);	//inject NONSTANDARD NAMING
    function VERSION240() external view returns (uint);	//inject NONSTANDARD NAMING
}

interface ListInterface {
    struct UserLink {
        uint64 first;
        uint64 last;
        uint64 count;
    }

    struct UserList {
        uint64 prev;
        uint64 next;
    }

    struct AccountLink {
        address first;
        address last;
        uint64 count;
    }

    struct AccountList {
        address prev;
        address next;
    }

    function ACCOUNTS436() external view returns (uint);	//inject NONSTANDARD NAMING
    function ACCOUNTID58(address) external view returns (uint64);	//inject NONSTANDARD NAMING
    function ACCOUNTADDR630(uint64) external view returns (address);	//inject NONSTANDARD NAMING
    function USERLINK309(address) external view returns (UserLink memory);	//inject NONSTANDARD NAMING
    function USERLIST982(address, uint64) external view returns (UserList memory);	//inject NONSTANDARD NAMING
    function ACCOUNTLINK485(uint64) external view returns (AccountLink memory);	//inject NONSTANDARD NAMING
    function ACCOUNTLIST101(uint64, address) external view returns (AccountList memory);	//inject NONSTANDARD NAMING

}

interface IndexInterface {
    function MASTER640() external view returns (address);	//inject NONSTANDARD NAMING
    function LIST592() external view returns (address);	//inject NONSTANDARD NAMING
    function CONNECTORS7(uint) external view returns (address);	//inject NONSTANDARD NAMING
    function ACCOUNT363(uint) external view returns (address);	//inject NONSTANDARD NAMING
    function CHECK929(uint) external view returns (address);	//inject NONSTANDARD NAMING
    function VERSIONCOUNT530() external view returns (uint);	//inject NONSTANDARD NAMING

}

interface ConnectorsInterface {
    struct List {
        address prev;
        address next;
    }
    function CHIEF335(address) external view returns (bool);	//inject NONSTANDARD NAMING
    function CONNECTORS7(address) external view returns (bool);	//inject NONSTANDARD NAMING
    function STATICCONNECTORS444(address) external view returns (bool);	//inject NONSTANDARD NAMING

    function CONNECTORARRAY96(uint) external view returns (address);	//inject NONSTANDARD NAMING
    function CONNECTORLENGTH479() external view returns (uint);	//inject NONSTANDARD NAMING
    function STATICCONNECTORARRAY158(uint) external view returns (address);	//inject NONSTANDARD NAMING
    function STATICCONNECTORLENGTH188() external view returns (uint);	//inject NONSTANDARD NAMING
    function CONNECTORCOUNT675() external view returns (uint);	//inject NONSTANDARD NAMING

    function ISCONNECTOR224(address[] calldata _connectors) external view returns (bool isOk);	//inject NONSTANDARD NAMING
    function ISSTATICCONNECTOR579(address[] calldata _connectors) external view returns (bool isOk);	//inject NONSTANDARD NAMING

}

interface ConnectorInterface {
    function NAME27() external view returns (string memory);	//inject NONSTANDARD NAMING
}

contract Helpers {
    address public index;
    address public list;
    address public connectors;
    IndexInterface indexContract;
    ListInterface listContract;
    ConnectorsInterface connectorsContract;
}

contract AccountResolver is Helpers {

    function GETID717(address account) public view returns(uint id){	//inject NONSTANDARD NAMING
        return listContract.ACCOUNTID58(account);
    }

    function GETACCOUNT405(uint64 id) public view returns(address account){	//inject NONSTANDARD NAMING
        return listContract.ACCOUNTADDR630(uint64(id));
    }

    function GETAUTHORITYIDS115(address authority) public view returns(uint64[] memory){	//inject NONSTANDARD NAMING
        ListInterface.UserLink memory userLink = listContract.USERLINK309(authority);
        uint64[] memory IDs = new uint64[](userLink.count);
        uint64 id = userLink.first;
        for (uint i = 0; i < userLink.count; i++) {
            IDs[i] = id;
            ListInterface.UserList memory userList = listContract.USERLIST982(authority, id);
            id = userList.next;
        }
        return IDs;
    }

    function GETAUTHORITYACCOUNTS933(address authority) public view returns(address[] memory){	//inject NONSTANDARD NAMING
        uint64[] memory IDs = GETAUTHORITYIDS115(authority);
        address[] memory accounts = new address[](IDs.length);
        for (uint i = 0; i < IDs.length; i++) {
            accounts[i] = GETACCOUNT405(IDs[i]);
        }
        return accounts;
    }

    function GETIDAUTHORITIES487(uint id) public view returns(address[] memory){	//inject NONSTANDARD NAMING
        ListInterface.AccountLink memory accountLink = listContract.ACCOUNTLINK485(uint64(id));
        address[] memory authorities = new address[](accountLink.count);
        address authority = accountLink.first;
        for (uint i = 0; i < accountLink.count; i++) {
            authorities[i] = authority;
            ListInterface.AccountList memory accountList = listContract.ACCOUNTLIST101(uint64(id), authority);
            authority = accountList.next;
        }
        return authorities;
    }

    function GETACCOUNTAUTHORITIES305(address account) public view returns(address[] memory){	//inject NONSTANDARD NAMING
        return GETIDAUTHORITIES487(GETID717(account));
    }

    function GETACCOUNTVERSIONS313(address[] memory accounts) public view returns(uint[] memory) {	//inject NONSTANDARD NAMING
        uint[] memory versions = new uint[](accounts.length);
        for (uint i = 0; i < accounts.length; i++) {
            versions[i] = AccountInterface(accounts[i]).VERSION240();
        }
        return versions;
    }

    struct AuthorityData {
        uint64[] IDs;
        address[] accounts;
        uint[] versions;
    }

    struct AccountData {
        uint ID;
        address account;
        uint version;
        address[] authorities;
    }

    function GETAUTHORITYDETAILS348(address authority) public view returns(AuthorityData memory){	//inject NONSTANDARD NAMING
        address[] memory accounts = GETAUTHORITYACCOUNTS933(authority);
        return AuthorityData(
            GETAUTHORITYIDS115(authority),
            accounts,
            GETACCOUNTVERSIONS313(accounts)
        );
    }

    function GETACCOUNTDETAILS682(uint id) public view returns(AccountData memory){	//inject NONSTANDARD NAMING
        address account = GETACCOUNT405(uint64(id));
        require(account != address(0), "no-account");
        return AccountData(
            id,
            account,
            AccountInterface(account).VERSION240(),
            GETIDAUTHORITIES487(id)
        );
    }

    function ISSHIELD75(address account) public view returns(bool shield) {	//inject NONSTANDARD NAMING
        shield = AccountInterface(account).SHEILD383();
    }
}


contract ConnectorsResolver is AccountResolver {
    struct ConnectorsData {
        address connector;
        uint connectorID;
        string name;
    }

    function GETENABLEDCONNECTORS300() public view returns(address[] memory){	//inject NONSTANDARD NAMING
        uint enabledCount = connectorsContract.CONNECTORCOUNT675();
        address[] memory addresses = new address[](enabledCount);
        uint connectorArrayLength = connectorsContract.CONNECTORLENGTH479();
        uint count;
        for (uint i = 0; i < connectorArrayLength ; i++) {
            address connector = connectorsContract.CONNECTORARRAY96(i);
            if (connectorsContract.CONNECTORS7(connector)) {
                addresses[count] = connector;
                count++;
            }
        }
        return addresses;
    }

    function GETENABLEDCONNECTORSDATA82() public view returns(ConnectorsData[] memory){	//inject NONSTANDARD NAMING
        uint enabledCount = connectorsContract.CONNECTORCOUNT675();
        ConnectorsData[] memory connectorsData = new ConnectorsData[](enabledCount);
        uint connectorArrayLength = connectorsContract.CONNECTORLENGTH479();
        uint count;
        for (uint i = 0; i < connectorArrayLength ; i++) {
            address connector = connectorsContract.CONNECTORARRAY96(i);
            if (connectorsContract.CONNECTORS7(connector)) {
                connectorsData[count] = ConnectorsData(
                    connector,
                    i+1,
                    ConnectorInterface(connector).NAME27()
                );
                count++;
            }
        }
        return connectorsData;
    }

    function GETSTATICCONNECTORS358() public view returns(address[] memory){	//inject NONSTANDARD NAMING
        uint staticLength = connectorsContract.STATICCONNECTORLENGTH188();
        address[] memory staticConnectorArray = new address[](staticLength);
        for (uint i = 0; i < staticLength ; i++) {
            staticConnectorArray[i] = connectorsContract.STATICCONNECTORARRAY158(i);
        }
        return staticConnectorArray;
    }

    function GETSTATICCONNECTORSDATA543() public view returns(ConnectorsData[] memory){	//inject NONSTANDARD NAMING
        uint staticLength = connectorsContract.STATICCONNECTORLENGTH188();
        ConnectorsData[] memory staticConnectorsData = new ConnectorsData[](staticLength);
        for (uint i = 0; i < staticLength ; i++) {
            address staticConnector = connectorsContract.STATICCONNECTORARRAY158(i);
            staticConnectorsData[i] = ConnectorsData(
                staticConnector,
                i+1,
                ConnectorInterface(staticConnector).NAME27()
            );
        }
        return staticConnectorsData;
    }
}


contract InstaDSAResolver is ConnectorsResolver {
    string public constant name451 = "DSA-Resolver-v1";	//inject NONSTANDARD NAMING
    uint public constant version931 = 1;	//inject NONSTANDARD NAMING

    constructor(address _index) public{
        index = _index;
        indexContract = IndexInterface(index);
        list = indexContract.LIST592();
        listContract = ListInterface(list);
        connectors = indexContract.CONNECTORS7(version931);
        connectorsContract = ConnectorsInterface(connectors);
    }
}