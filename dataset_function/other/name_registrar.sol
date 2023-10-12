


















    function register(bytes32 _name, address _mappedAddress) public {
        // set up the new NameRecord
        // <yes> <report> OTHER - uninitialized storage
        NameRecord newRecord;
        newRecord.name = _name;
        newRecord.mappedAddress = _mappedAddress;

        resolve[_name] = _mappedAddress;
        registeredNameRecord[msg.sender] = newRecord;

        require(unlocked); // only allow registrations if contract is unlocked
    }
