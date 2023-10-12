












    function emptyCreditors() public {
        // <yes> <report> DENIAL_OF_SERVICE
        if(creditorAddresses.length>1500) {
            creditorAddresses = new address[](0);
            win = true;
        }
    }
