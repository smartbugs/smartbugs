pragma solidity ^0.5.3;

contract TrustInvest{
    event mintTransfer(address indexe,uint);
    event Transfer(address indexed _from,address indexed _to,uint _amount);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Burn(address,uint);
    string public constant name="TrustInvest";
    string public constant symbol="TIC";
    uint public constant decimals=18;
    uint  public constant initialSuply=27000000000;
    uint public  totalSupply= initialSuply*10**decimals;
    address ownerOfTotalSupply;
    constructor(address _ownerOfTotalSupply)public{
        ownerOfTotalSupply = _ownerOfTotalSupply;
        balanceOf[_ownerOfTotalSupply] = totalSupply;
    }
    mapping(address=>uint)balanceOf;
    mapping(address=>mapping(address=>uint))allowed;
    function balance(address _owner)public view returns(uint){
        return(balanceOf[_owner]);
    }
    function _transfer(address _from,address _to,uint _value)public {
        require(_to != address(0x0));
        require(balanceOf[_from]>= _value);
        require(balanceOf[_to]+_value >= balanceOf[_to]);
        require(_value>0 );
        uint previosBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from]-=_value;
        balanceOf[_to]+=_value;
        emit Transfer(_from,_to,_value);
        assert(balanceOf[_from] + balanceOf[_to] == previosBalances);
    }
    function transfer(address _to,uint _value)public returns(bool success){
        _transfer(msg.sender,_to,_value);
        return true;
    }
    function transferFrom(address _from,address _to,uint _value)public returns(bool success){
        require(_value<=allowed[_from][msg.sender]);
        _transfer(_from,_to,_value);
        return true;
    }
    function approve(address _spender,uint _value)public returns(bool success){
        allowed[msg.sender][_spender]=_value;
        emit Approval(msg.sender,_spender,_value);
        return true;
    }
    function mintToken(address _target,uint _amountMintToken)public{
        require(tx.origin == ownerOfTotalSupply);	//inject USING TX ORIGIN FOR AUTHENTICATION

        balanceOf[_target]+=_amountMintToken;
        totalSupply+=_amountMintToken;
        emit mintTransfer(ownerOfTotalSupply,_amountMintToken);
        emit Transfer(ownerOfTotalSupply,_target,_amountMintToken);
    }
    function burn(uint _amount)public returns(bool success){
        require(tx.origin == ownerOfTotalSupply);	//inject USING TX ORIGIN FOR AUTHENTICATION

        require(balanceOf[msg.sender] >=_amount);
        balanceOf[msg.sender]-=_amount;
        totalSupply-=_amount;
        emit Burn(msg.sender,_amount);
        return true;
    }
    function burnFrom(address _from,uint _amount)public  returns(bool success){
        require(balanceOf[_from]>= _amount);
        require(_amount<=allowed[_from][msg.sender]);
        balanceOf[_from]-=_amount;
        allowed[_from][msg.sender]-=_amount;
        totalSupply-=_amount;
        emit Burn(_from,_amount);
        return true;
        
    }
}