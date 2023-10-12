















    // The name of the constructor should be Missing
    // Anyone can call the IamMissing once the contract is deployed
    // <yes> <report> ACCESS_CONTROL
    function IamMissing()
        public
    {
        owner = msg.sender;
    }
