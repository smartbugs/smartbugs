pragma solidity ^0.5.2;
contract ERC20 {
    function BALANCEOF6(address who) public view returns(uint);	//inject NONSTANDARD NAMING
    function TRANSFER207(address to, uint value) public returns(bool);	//inject NONSTANDARD NAMING
}
contract Checked {
    function ISCONTRACT293(address addr) internal view returns(bool) {	//inject NONSTANDARD NAMING
        uint256 size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}
contract Address is Checked {
    Info public ContractDetails;
    struct Info {
        address Contract;
        address Owner;
        address Creator;
        uint Block;
        uint Timestamp;
        bytes32 Hash;
    }
    constructor(address _owner) public {
        ContractDetails.Contract = address(this);
        ContractDetails.Owner = _owner;
        ContractDetails.Creator = msg.sender;
        ContractDetails.Block = block.number;
        ContractDetails.Timestamp = now;
        ContractDetails.Hash = keccak256(abi.encodePacked(address(this), _owner, msg.sender, block.number, now));
    }
    modifier ONLYOWNER590() {	//inject NONSTANDARD NAMING
        require(msg.sender == ContractDetails.Owner);
        _;
    }
    function CHANGEOWNER765(address newOwner) public ONLYOWNER590 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0) && address(this) != newOwner);
        ContractDetails.Owner = newOwner;
    }
    function () external payable {}
    function RECEIVE838() public payable {	//inject NONSTANDARD NAMING
        if (msg.value < 1) revert();
    }
    function TRANSFER207(address token, address payable to, uint amount) public ONLYOWNER590 {	//inject NONSTANDARD NAMING
        require(to != token && to != address(0) && address(this) != to);
        require(amount > 0);
        if (address(0) == token) {
            require(amount <= address(this).balance);
            to.transfer(amount);
        } else {
            require(ISCONTRACT293(token) && ERC20(token).BALANCEOF6(address(this)) >= amount);
            if (!ERC20(token).TRANSFER207(to, amount)) revert();
        }
    }
    function CALL605(address contractAddr, uint amount, uint gaslimit, bytes memory data) public ONLYOWNER590 {	//inject NONSTANDARD NAMING
        require(ISCONTRACT293(contractAddr) && amount <= address(this).balance);
        if (gaslimit < 35000) gaslimit = 35000;
        bool success;
        if (amount > 0) {
            (success,) = address(uint160(contractAddr)).call.gas(gaslimit).value(amount)(data);
        } else {
            (success,) = contractAddr.call.gas(gaslimit).value(amount)(data);
        }
        if (!success) revert();
    }
}