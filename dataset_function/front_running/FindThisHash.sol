












    function solve(string solution) public {
        // If you can find the pre image of the hash, receive 1000 ether
         // <yes> <report> FRONT_RUNNING
        require(hash == sha3(solution));
        msg.sender.transfer(1000 ether);
    }
