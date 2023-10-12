













    // ADD overflow with result stored in state variable.
    function overflowaddtostate(uint256 input) public {
        // <yes> <report> ARITHMETIC
        count += input;
    }

    // MUL overflow with result stored in state variable.
    function overflowmultostate(uint256 input) public {
        // <yes> <report> ARITHMETIC
        count *= input;
    }

    // Underflow with result stored in state variable.
    function underflowtostate(uint256 input) public {
        // <yes> <report> ARITHMETIC
        count -= input;
    }

    // ADD Overflow, no effect on state.
    function overflowlocalonly(uint256 input) public {
        // <yes> <report> ARITHMETIC
        uint res = count + input;
    }

    // MUL Overflow, no effect on state.
    function overflowmulocalonly(uint256 input) public {
        // <yes> <report> ARITHMETIC
        uint res = count * input;
    }

    // Underflow, no effect on state.
    function underflowlocalonly(uint256 input) public {
        // <yes> <report> ARITHMETIC
       	uint res = count - input;
    }
