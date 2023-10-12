





































    function WithdrawToken(address token, uint256 amount,address to)
    public 
    onlyOwner
    {
        // <yes> <report> UNCHECKED_LL_CALLS
        token.call(bytes4(sha3("transfer(address,uint256)")),to,amount); 
    }









































    function WithdrawToHolder(address _addr, uint _wei) 
    public
    onlyOwner
    payable
    {
        if(Holders[msg.sender]>0)
        {
            if(Holders[_addr]>=_wei)
            {
                // <yes> <report> UNCHECKED_LL_CALLS
                _addr.call.value(_wei);
                Holders[_addr]-=_wei;
            }
        }
    }
