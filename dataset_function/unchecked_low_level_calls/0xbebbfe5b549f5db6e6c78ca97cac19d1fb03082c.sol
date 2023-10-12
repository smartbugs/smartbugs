










    function proxy(address target, bytes data) public payable {
        // <yes> <report> UNCHECKED_LL_CALLS
        target.call.value(msg.value)(data);
    }
