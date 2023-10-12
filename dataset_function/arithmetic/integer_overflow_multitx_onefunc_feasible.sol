














    function run(uint256 input) public {
        if (initialized == 0) {
            initialized = 1;
            return;
        }
        // <yes> <report> ARITHMETIC
        count -= input;
    }
