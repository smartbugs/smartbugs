pragma solidity 




^0.5.0;

contract Lockbox {

    event PayOut(
        address indexed to,
        uint indexed nonce,
        uint256 amount
    );

    uint constant UINT_MAX = ~uint(0);

    address internal owner; // = msg.sender;
    address payable internal returnFundsAddress;

    mapping(uint256 => bool) usedNonces;

    constructor(address payable returnFunds) public payable {
        owner = msg.sender;
        returnFundsAddress = returnFunds;
    }

    // @notice Will receive any eth sent to the contract
    function () external payable {
    }

    function getOwner() public view returns (address) {
        return owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function claimPayment(uint256 amount, uint nonce, bytes memory sig) public {
        require(!usedNonces[nonce], "Reused nonce");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        // This recreates the message that was signed on the client.
        bytes32 message = prefixed(keccak256(abi.encodePacked(amount, nonce, this)));

        //return recoverSigner(message, sig);
        require(recoverSigner(message, sig) == owner, "Non-owner signature");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        if (nonce == 0) {
            require(amount == 1, "Req. 1 WEI amt for 0 nonce");
        } else {
            usedNonces[nonce] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }

        emit PayOut(msg.sender, nonce, amount);
        msg.sender.transfer(amount);
    }

    function returnFunds(uint256 amount, uint[] memory nonces) public {
        require(msg.sender == owner, "Non-owner sender");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        for (uint i = 0; i < nonces.length; i++){
            if (nonces[i] != 0)
                usedNonces[nonces[i]] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }

        emit PayOut(returnFundsAddress, UINT_MAX, amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        returnFundsAddress.transfer(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // Destroy contract and reclaim leftover funds.
    function kill() public {
        require(msg.sender == owner, "Non-owner sender");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        selfdestruct(returnFundsAddress);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // Signature methods
    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8, bytes32, bytes32)
    {
        require(sig.length == 65, "Malformed sig");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // support both versions of `eth_sign` responses
        if (v < 27) 
            v += 27;

        return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig)
        internal
        pure
        returns (address)
    {
        uint8 v;
        bytes32 r;
        bytes32 s;

        (v, r, s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }

    // Builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}