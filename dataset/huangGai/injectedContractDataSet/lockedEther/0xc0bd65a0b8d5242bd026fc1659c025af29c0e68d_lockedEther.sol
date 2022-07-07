/**
 *Submitted for verification at Etherscan.io on 2020-05-07
*/

pragma solidity >=0.6.4;

contract managed
{
    /*
        1) Allows the manager to pause the contract
        2) change fee in the future
    */

    address payable public manager;

    constructor() public
	{
	    manager = msg.sender;
	}

    modifier onlyManager()
    {
        require(msg.sender == manager);
        _;
    }


    function setManager(address payable newmanager) external onlyManager
    {
        /*
            Allows the current manager to set a new manager
        */
        
        require(newmanager.balance > 0);
        manager = newmanager;
    }

}

contract digitalNotary is managed
{

    bool public contractactive;

    uint public registrationfee;

    uint public changeownerfee;

    /*
        A mapping of File Hash with current owner.
        mapping(filehash => currentowner address)
     */
    mapping(bytes32 => address) FileHashCurrentOwnerMap;

    //Event is generated when ownership is registered and transferred
    event OwnershipEvent(bytes32 indexed filehash, address indexed filehashowner, uint eventtime);

    constructor() public
    {

        contractactive = true;

        registrationfee = 5000000000000000; //0.005 ETH

        changeownerfee = 25000000000000000; //0.025 ETH

    }

    function setContractSwitch() external onlyManager
    {
        /*
            Switch that controls whether the contract is paused
        */
        
        contractactive = contractactive == true ? false : true;
    }

    function setRegistrationFee(uint newfee) external onlyManager
    {
        /*
            Changes the File hash registration fee, that is paid to the manager
        */
        
        require(newfee > 0, "Registration Fee should be > 0");

        registrationfee = newfee;
    }

    function setChangeOwnerFee(uint newfee) external onlyManager
    {
        /*
            Changes the transfer ownership fee, that is paid to the manager
        */

        require(newfee > 0, "Change Ownership fee > 0");

        changeownerfee = newfee;
    }


    function getFileHashExists(bytes32 filehash) public view returns(bool)
    {
        /*
            Gets whether the file hash has already been registered
        */
        
        return FileHashCurrentOwnerMap[filehash] != address(0);
    }

    function getFileHashCurrentOwner(bytes32 filehash) public view returns(address)
    {
        /*
            Gets the current owner of file hash if exists
        */
        
        require(getFileHashExists(filehash) == true, "File hash not registered");

        return FileHashCurrentOwnerMap[filehash];
    }


    function RegisterFileHash(bytes32 filehash) external payable	//injected LOCKED ETHER
    {
        /*
            Register the file Hash
        */

        require(contractactive == true, "Contract not active");
        require(getFileHashExists(filehash) == false, "File Hash already registered");
        require(msg.value == registrationfee, "Registration Fee incorrect");

        //Add Filehash to Map
        FileHashCurrentOwnerMap[filehash] = msg.sender;

        //The registrationfee gets paid to manager
        manager.transfer(0);

        emit OwnershipEvent(filehash, msg.sender, now);

    }

     function transferOwnership(bytes32 filehash, address newowner) external payable	//injected LOCKED ETHER
    {
        /*
            Change ownership of the file hash from the most recent owner to the new owner
        */

        require(contractactive == true, "Contract not active");
        require(newowner != address(0), "New Owner can not be address(0)");
        require(getFileHashCurrentOwner(filehash) == msg.sender,"Msg Sender Not current owner");
        require(msg.value == changeownerfee, "Change Owner Fee incorrect");


        //Ownership transferred
        FileHashCurrentOwnerMap[filehash] = newowner;

        //The changeownerfee gets paid to manager
        manager.transfer(0);

        emit OwnershipEvent(filehash, newowner, now);

    }

    fallback() external
    {

    }

}