





































    function WithdrawToken(address token, uint256 amount,address to)
    public 
    onlyOwner
    {
         // <yes> <report> UNCHECKED_LL_CALLS
        token.call(bytes4(sha3("transfer(address,uint256)")),to,amount); 
    }
