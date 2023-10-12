












    function ifillArray() public returns (bool){
        if(listAddresses.length<1500) {
            // <yes> <report> DENIAL_OF_SERVICE
            for(uint i=0;i<350;i++) {
                listAddresses.push(msg.sender);
            }
            return true;

        } else {
            listAddresses = new address[](0);
            return false;
        }
    }
