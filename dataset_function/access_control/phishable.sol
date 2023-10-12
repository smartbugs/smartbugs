
















    function withdrawAll(address _recipient) public {
        // <yes> <report> ACCESS_CONTROL
        require(tx.origin == owner);
        _recipient.transfer(this.balance);
    }
