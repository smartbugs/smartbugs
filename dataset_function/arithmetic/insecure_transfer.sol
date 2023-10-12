










    // INSECURE
    function transfer(address _to, uint256 _value) public{
        /* Check if sender has balance */
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        // <yes> <report> ARITHMETIC
        balanceOf[_to] += _value;
}
