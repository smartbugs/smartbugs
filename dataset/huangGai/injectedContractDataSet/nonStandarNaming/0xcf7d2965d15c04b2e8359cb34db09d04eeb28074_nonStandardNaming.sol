pragma solidity ^0.5.0;

// Check if we are on Constantinople!! 
// etherguy@mail.com

contract HelloWorld{
    function HELLO47() public pure returns (string memory){	//inject NONSTANDARD NAMING
        return ("Hello World");
    }
}

contract ConstantinopleCheck{
    
    address public DeployedContractAddress;
    
    function DEPLOY284() public {	//inject NONSTANDARD NAMING
        // hex of hello world deploy bytecode
        bytes memory code = hex'608060405234801561001057600080fd5b50610124806100206000396000f3fe6080604052348015600f57600080fd5b50600436106044577c01000000000000000000000000000000000000000000000000000000006000350463bcdfe0d581146049575b600080fd5b604f60c1565b6040805160208082528351818301528351919283929083019185019080838360005b8381101560875781810151838201526020016071565b50505050905090810190601f16801560b35780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b60408051808201909152600b81527f48656c6c6f20576f726c6400000000000000000000000000000000000000000060208201529056fea165627a7a72305820569c1233dc571997cbd1fa15675cd16b4cacd5615abb6c991dd85a516af1ecc80029';
        uint len = code.length;
        address deployed;
        assembly{
            deployed := create2(0, add(code, 0x20), len, "Hello Constantinople!")
        }
        DeployedContractAddress = deployed;
    }
    
    // reverts if not Constantinople
    function ISITCONSTANTINOPLE551() public view returns (bool){	//inject NONSTANDARD NAMING
        address target = address(this);
        bytes32 hash;
        assembly{
            hash := extcodehash(target)
        }
        return (true);
    }
    
    function HELLO47() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return (HelloWorld(DeployedContractAddress).HELLO47());
    }
    
    
    
}