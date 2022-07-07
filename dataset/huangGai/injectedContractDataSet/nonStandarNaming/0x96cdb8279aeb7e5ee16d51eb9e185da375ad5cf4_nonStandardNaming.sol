                                                                 

pragma solidity ^0.7.0;


// SPDX-License-Identifier: none

contract Owned {
    modifier ONLYOWNER635() {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }
    address owner;
    address newOwner;
    function CHANGEOWNER950(address payable _newOwner) public ONLYOWNER635 {	//inject NONSTANDARD NAMING
        newOwner = _newOwner;
    }
    function ACCEPTOWNERSHIP254() public {	//inject NONSTANDARD NAMING
        if (msg.sender == newOwner) {
            owner = newOwner;
        }
    }
}

contract ERC20 {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping (address=>uint256) balances;
    mapping (address=>mapping (address=>uint256)) allowed;
    event TRANSFER187(address indexed _from, address indexed _to, uint256 _value);	//inject NONSTANDARD NAMING
    event APPROVAL520(address indexed _owner, address indexed _spender, uint256 _value);	//inject NONSTANDARD NAMING
    
    function BALANCEOF5(address _owner) view public returns (uint256 balance) {return balances[_owner];}	//inject NONSTANDARD NAMING
    
    function TRANSFER8(address _to, uint256 _amount) public returns (bool success) {	//inject NONSTANDARD NAMING
        require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
        balances[msg.sender]-=_amount;
        balances[_to]+=_amount;
        emit TRANSFER187(msg.sender,_to,_amount);
        return true;
    }
  
    function TRANSFERFROM411(address _from,address _to,uint256 _amount) public returns (bool success) {	//inject NONSTANDARD NAMING
        require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
        balances[_from]-=_amount;
        allowed[_from][msg.sender]-=_amount;
        balances[_to]+=_amount;
        emit TRANSFER187(_from, _to, _amount);
        return true;
    }
  
    function APPROVE112(address _spender, uint256 _amount) public returns (bool success) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender]=_amount;
        emit APPROVAL520(msg.sender, _spender, _amount);
        return true;
    }
    
    function ALLOWANCE836(address _owner, address _spender) view public returns (uint256 remaining) {	//inject NONSTANDARD NAMING
      return allowed[_owner][_spender];
    }
}

contract PumptonicRebirth is Owned,ERC20{
    uint256 public maxSupply;

    constructor(address _owner) {
        symbol = "PTR";
        name = "PumptonicRebirth";
        decimals = 18;                                    // 18 Decimals are Best for Liquidity...
        totalSupply = 300000000000000000000;              // 300 is Total Supply ; Rest 18 Zeros are Decimals...
        maxSupply   = 300000000000000000000;              // 300 is Total Supply ; Rest 18 Zeros are Decimals...
        owner = _owner;
        balances[owner] = totalSupply;
    }
    
    receive() external payable {
        revert();
    }
    
   
}