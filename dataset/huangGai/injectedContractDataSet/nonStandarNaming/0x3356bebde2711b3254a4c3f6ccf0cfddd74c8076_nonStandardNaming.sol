pragma solidity ^0.5.4;

contract GVC{
    event MINTTRANSFER41(address indexe,uint);	//inject NONSTANDARD NAMING
    event TRANSFER486(address indexed _from,address indexed _to,uint _amount);	//inject NONSTANDARD NAMING
    event APPROVAL148(address indexed tokenOwner, address indexed spender, uint tokens);	//inject NONSTANDARD NAMING
    event BURN451(address,uint);	//inject NONSTANDARD NAMING
    string public constant name751="GlobalVc";	//inject NONSTANDARD NAMING
    string public constant symbol716="GVC";	//inject NONSTANDARD NAMING
    uint public constant decimals111=18;	//inject NONSTANDARD NAMING
    uint  public constant initialsuply325=1000000;	//inject NONSTANDARD NAMING
    uint public  totalSupply= initialsuply325*10**decimals111;
    address ownerOfTotalSupply;
    constructor(address _ownerOfTotalSupply)public{
        ownerOfTotalSupply = _ownerOfTotalSupply;
        balanceOf[_ownerOfTotalSupply] = totalSupply;
    }
    mapping(address=>uint)balanceOf;
    mapping(address=>mapping(address=>uint))allowed;
    function BALANCE172(address _owner)public view returns(uint){	//inject NONSTANDARD NAMING
        return(balanceOf[_owner]);
    }
    function _TRANSFER787(address _from,address _to,uint _value)public {	//inject NONSTANDARD NAMING
        require(_to != address(0x0));
        require(_to != _from);
        require(balanceOf[_from]>= _value);
        require(balanceOf[_to]+_value >= balanceOf[_to]);
        require(_value>0 );
        uint previosBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from]-=_value;
        balanceOf[_to]+=_value;
        emit TRANSFER486(_from,_to,_value);
        assert(balanceOf[_from] + balanceOf[_to] == previosBalances);
    }
    function TRANSFER610(address _to,uint _value)public returns(bool success){	//inject NONSTANDARD NAMING
        _TRANSFER787(msg.sender,_to,_value);
        return true;
    }
    function TRANSFERFROM371(address _from,address _to,uint _value)public returns(bool success){	//inject NONSTANDARD NAMING
        require(_value<=allowed[_from][msg.sender]);
        _TRANSFER787(_from,_to,_value);
        return true;
    }
    function APPROVE613(address _spender,uint _value)public returns(bool success){	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender]=_value;
        emit APPROVAL148(msg.sender,_spender,_value);
        return true;
    }
    function MINTTOKEN45(address _target,uint _amountMintToken)public{	//inject NONSTANDARD NAMING
        require(msg.sender == ownerOfTotalSupply);
        balanceOf[_target]+=_amountMintToken;
        totalSupply+=_amountMintToken;
        emit MINTTRANSFER41(ownerOfTotalSupply,_amountMintToken);
        emit TRANSFER486(ownerOfTotalSupply,_target,_amountMintToken);
    }
    function BURN959(uint _amount)public returns(bool success){	//inject NONSTANDARD NAMING
        require(msg.sender == ownerOfTotalSupply);
        require(balanceOf[msg.sender] >=_amount);
        balanceOf[msg.sender]-=_amount;
        totalSupply-=_amount;
        emit BURN451(msg.sender,_amount);
        return true;
    }
    function BURNFROM474(address _from,uint _amount)public  returns(bool success){	//inject NONSTANDARD NAMING
        require(balanceOf[_from]>= _amount);
        require(_amount<=allowed[_from][msg.sender]);
        balanceOf[_from]-=_amount;
        allowed[_from][msg.sender]-=_amount;
        totalSupply-=_amount;
        emit BURN451(_from,_amount);
        return true;
        
    }
}