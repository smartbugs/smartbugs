                                                                 

// SPDX-License-Identifier: Apache-2.0
// Copyright 2017 Loopring Technology Limited.
pragma solidity ^0.7.0;


                  
                                                
                                                                      
                                                                               
                            
contract Ownable
{
    address public owner;

    event OWNERSHIPTRANSFERRED745(	//inject NONSTANDARD NAMING
        address indexed previousOwner,
        address indexed newOwner
    );

                                                                              
                           
    constructor()
    {
        owner = msg.sender;
    }

                                                                  
    modifier ONLYOWNER112()	//inject NONSTANDARD NAMING
    {
        require(msg.sender == owner, "UNAUTHORIZED");
        _;
    }

                                                                              
                       
                                                             
    function TRANSFEROWNERSHIP715(	//inject NONSTANDARD NAMING
        address newOwner
        )
        public
        virtual
        ONLYOWNER112
    {
        require(newOwner != address(0), "ZERO_ADDRESS");
        emit OWNERSHIPTRANSFERRED745(owner, newOwner);
        owner = newOwner;
    }

    function RENOUNCEOWNERSHIP221()	//inject NONSTANDARD NAMING
        public
        ONLYOWNER112
    {
        emit OWNERSHIPTRANSFERRED745(owner, address(0));
        owner = address(0);
    }
}

// Copyright 2017 Loopring Technology Limited.





                    
                                                
                                                                      
                                                                         
contract Claimable is Ownable
{
    address public pendingOwner;

                                                                                  
    modifier ONLYPENDINGOWNER834() {	//inject NONSTANDARD NAMING
        require(msg.sender == pendingOwner, "UNAUTHORIZED");
        _;
    }

                                                                      
                                                             
    function TRANSFEROWNERSHIP715(	//inject NONSTANDARD NAMING
        address newOwner
        )
        public
        override
        ONLYOWNER112
    {
        require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");
        pendingOwner = newOwner;
    }

                                                                      
    function CLAIMOWNERSHIP503()	//inject NONSTANDARD NAMING
        public
        ONLYPENDINGOWNER834
    {
        emit OWNERSHIPTRANSFERRED745(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}

// Copyright 2017 Loopring Technology Limited.



                                     
                                               
library MathUint
{
    using MathUint for uint;

    function MUL260(	//inject NONSTANDARD NAMING
        uint a,
        uint b
        )
        internal
        pure
        returns (uint c)
    {
        c = a * b;
        require(a == 0 || c / a == b, "MUL_OVERFLOW");
    }

    function SUB429(	//inject NONSTANDARD NAMING
        uint a,
        uint b
        )
        internal
        pure
        returns (uint)
    {
        require(b <= a, "SUB_UNDERFLOW");
        return a - b;
    }

    function ADD886(	//inject NONSTANDARD NAMING
        uint a,
        uint b
        )
        internal
        pure
        returns (uint c)
    {
        c = a + b;
        require(c >= a, "ADD_OVERFLOW");
    }

    function ADD64567(	//inject NONSTANDARD NAMING
        uint64 a,
        uint64 b
        )
        internal
        pure
        returns (uint64 c)
    {
        c = a + b;
        require(c >= a, "ADD_OVERFLOW");
    }
}

// Copyright 2017 Loopring Technology Limited.



// Copyright 2017 Loopring Technology Limited.



                                          
                                               
                                                
library AddressUtil
{
    using AddressUtil for *;

    function ISCONTRACT780(	//inject NONSTANDARD NAMING
        address addr
        )
        internal
        view
        returns (bool)
    {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(addr) }
        return (codehash != 0x0 &&
                codehash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
    }

    function TOPAYABLE290(	//inject NONSTANDARD NAMING
        address addr
        )
        internal
        pure
        returns (address payable)
    {
        return payable(addr);
    }

    // Works like address.send but with a customizable gas limit
    // Make sure your code is safe for reentrancy when using this function!
    function SENDETH93(	//inject NONSTANDARD NAMING
        address to,
        uint    amount,
        uint    gasLimit
        )
        internal
        returns (bool success)
    {
        if (amount == 0) {
            return true;
        }
        address payable recipient = to.TOPAYABLE290();
                                      
        (success, ) = recipient.call{value: amount, gas: gasLimit}("");
    }

    // Works like address.transfer but with a customizable gas limit
    // Make sure your code is safe for reentrancy when using this function!
    function SENDETHANDVERIFY115(	//inject NONSTANDARD NAMING
        address to,
        uint    amount,
        uint    gasLimit
        )
        internal
        returns (bool success)
    {
        success = to.SENDETH93(amount, gasLimit);
        require(success, "TRANSFER_FAILURE");
    }

    // Works like call but is slightly more efficient when data
    // needs to be copied from memory to do the call.
    function FASTCALL566(	//inject NONSTANDARD NAMING
        address to,
        uint    gasLimit,
        uint    value,
        bytes   memory data
        )
        internal
        returns (bool success, bytes memory returnData)
    {
        if (to != address(0)) {
            assembly {
                // Do the call
                success := call(gasLimit, to, value, add(data, 32), mload(data), 0, 0)
                // Copy the return data
                let size := returndatasize()
                returnData := mload(0x40)
                mstore(returnData, size)
                returndatacopy(add(returnData, 32), 0, size)
                // Update free memory pointer
                mstore(0x40, add(returnData, add(32, size)))
            }
        }
    }

    // Like fastCall, but throws when the call is unsuccessful.
    function FASTCALLANDVERIFY742(	//inject NONSTANDARD NAMING
        address to,
        uint    gasLimit,
        uint    value,
        bytes   memory data
        )
        internal
        returns (bytes memory returnData)
    {
        bool success;
        (success, returnData) = FASTCALL566(to, gasLimit, value, data);
        if (!success) {
            assembly {
                revert(add(returnData, 32), mload(returnData))
            }
        }
    }
}


// Copyright 2017 Loopring Technology Limited.



                              
                                                   
                                                
library ERC20SafeTransfer
{
    function SAFETRANSFERANDVERIFY454(	//inject NONSTANDARD NAMING
        address token,
        address to,
        uint    value
        )
        internal
    {
        SAFETRANSFERWITHGASLIMITANDVERIFY643(
            token,
            to,
            value,
            gasleft()
        );
    }

    function SAFETRANSFER263(	//inject NONSTANDARD NAMING
        address token,
        address to,
        uint    value
        )
        internal
        returns (bool)
    {
        return SAFETRANSFERWITHGASLIMIT116(
            token,
            to,
            value,
            gasleft()
        );
    }

    function SAFETRANSFERWITHGASLIMITANDVERIFY643(	//inject NONSTANDARD NAMING
        address token,
        address to,
        uint    value,
        uint    gasLimit
        )
        internal
    {
        require(
            SAFETRANSFERWITHGASLIMIT116(token, to, value, gasLimit),
            "TRANSFER_FAILURE"
        );
    }

    function SAFETRANSFERWITHGASLIMIT116(	//inject NONSTANDARD NAMING
        address token,
        address to,
        uint    value,
        uint    gasLimit
        )
        internal
        returns (bool)
    {
        // A transfer is successful when 'call' is successful and depending on the token:
        // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
        // - A single boolean is returned: this boolean needs to be true (non-zero)

        // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
        bytes memory callData = abi.encodeWithSelector(
            bytes4(0xa9059cbb),
            to,
            value
        );
        (bool success, ) = token.call{gas: gasLimit}(callData);
        return CHECKRETURNVALUE539(success);
    }

    function SAFETRANSFERFROMANDVERIFY218(	//inject NONSTANDARD NAMING
        address token,
        address from,
        address to,
        uint    value
        )
        internal
    {
        SAFETRANSFERFROMWITHGASLIMITANDVERIFY78(
            token,
            from,
            to,
            value,
            gasleft()
        );
    }

    function SAFETRANSFERFROM863(	//inject NONSTANDARD NAMING
        address token,
        address from,
        address to,
        uint    value
        )
        internal
        returns (bool)
    {
        return SAFETRANSFERFROMWITHGASLIMIT242(
            token,
            from,
            to,
            value,
            gasleft()
        );
    }

    function SAFETRANSFERFROMWITHGASLIMITANDVERIFY78(	//inject NONSTANDARD NAMING
        address token,
        address from,
        address to,
        uint    value,
        uint    gasLimit
        )
        internal
    {
        bool result = SAFETRANSFERFROMWITHGASLIMIT242(
            token,
            from,
            to,
            value,
            gasLimit
        );
        require(result, "TRANSFER_FAILURE");
    }

    function SAFETRANSFERFROMWITHGASLIMIT242(	//inject NONSTANDARD NAMING
        address token,
        address from,
        address to,
        uint    value,
        uint    gasLimit
        )
        internal
        returns (bool)
    {
        // A transferFrom is successful when 'call' is successful and depending on the token:
        // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
        // - A single boolean is returned: this boolean needs to be true (non-zero)

        // bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
        bytes memory callData = abi.encodeWithSelector(
            bytes4(0x23b872dd),
            from,
            to,
            value
        );
        (bool success, ) = token.call{gas: gasLimit}(callData);
        return CHECKRETURNVALUE539(success);
    }

    function CHECKRETURNVALUE539(	//inject NONSTANDARD NAMING
        bool success
        )
        internal
        pure
        returns (bool)
    {
        // A transfer/transferFrom is successful when 'call' is successful and depending on the token:
        // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
        // - A single boolean is returned: this boolean needs to be true (non-zero)
        if (success) {
            assembly {
                switch returndatasize()
                // Non-standard ERC20: nothing is returned so if 'call' was successful we assume the transfer succeeded
                case 0 {
                    success := 1
                }
                // Standard ERC20: a single boolean value is returned which needs to be true
                case 32 {
                    returndatacopy(0, 0, 32)
                    success := mload(0)
                }
                // None of the above: not successful
                default {
                    success := 0
                }
            }
        }
        return success;
    }
}


// Copyright 2017 Loopring Technology Limited.



                          
                                                
                                                                     
                                                                                     
                                                                          
                                                 
contract ReentrancyGuard
{
    //The default value must be 0 in order to work behind a proxy.
    uint private _guardValue;

    // Use this modifier on a function to prevent reentrancy
    modifier NONREENTRANT948()	//inject NONSTANDARD NAMING
    {
        // Check if the guard value has its original value
        require(_guardValue == 0, "REENTRANCY");

        // Set the value to something else
        _guardValue = 1;

        // Function body
        _;

        // Set the value back
        _guardValue = 0;
    }
}


// Copyright 2017 Loopring Technology Limited.

pragma experimental ABIEncoderV2;



// Copyright 2017 Loopring Technology Limited.




// Copyright 2017 Loopring Technology Limited.


interface IAgent{}

interface IAgentRegistry
{
                                                                             
                                       
                                      
                                                                                       
    function ISAGENT707(	//inject NONSTANDARD NAMING
        address owner,
        address agent
        )
        external
        view
        returns (bool);

                                                                               
                                         
                                      
                                                                                       
    function ISAGENT707(	//inject NONSTANDARD NAMING
        address[] calldata owners,
        address            agent
        )
        external
        view
        returns (bool);
}


// Copyright 2017 Loopring Technology Limited.






                         
                                                
abstract contract IBlockVerifier is Claimable
{
    // -- Events --

    event CIRCUITREGISTERED31(	//inject NONSTANDARD NAMING
        uint8  indexed blockType,
        uint16         blockSize,
        uint8          blockVersion
    );

    event CIRCUITDISABLED690(	//inject NONSTANDARD NAMING
        uint8  indexed blockType,
        uint16         blockSize,
        uint8          blockVersion
    );

    // -- Public functions --

                                                              
                                                                                  
                                                                              
                                
                                              
                                                                    
                                                                                           
                                      
    function REGISTERCIRCUIT284(	//inject NONSTANDARD NAMING
        uint8    blockType,
        uint16   blockSize,
        uint8    blockVersion,
        uint[18] calldata vk
        )
        external
        virtual;

                                                       
                                                                                                       
                                   
                                              
                                                                    
                                                                                           
    function DISABLECIRCUIT787(	//inject NONSTANDARD NAMING
        uint8  blockType,
        uint16 blockSize,
        uint8  blockVersion
        )
        external
        virtual;

                                                                   
                                                                           
                                                   
                                          
                                                                    
                                                                                           
                                                                         
                                                                       
                                                           
    function VERIFYPROOFS612(	//inject NONSTANDARD NAMING
        uint8  blockType,
        uint16 blockSize,
        uint8  blockVersion,
        uint[] calldata publicInputs,
        uint[] calldata proofs
        )
        external
        virtual
        view
        returns (bool);

                                                                             
                                              
                                                                    
                                                                                           
                                                                  
    function ISCIRCUITREGISTERED877(	//inject NONSTANDARD NAMING
        uint8  blockType,
        uint16 blockSize,
        uint8  blockVersion
        )
        external
        virtual
        view
        returns (bool);

                                                                        
                                              
                                                                    
                                                                                           
                                                               
    function ISCIRCUITENABLED480(	//inject NONSTANDARD NAMING
        uint8  blockType,
        uint16 blockSize,
        uint8  blockVersion
        )
        external
        virtual
        view
        returns (bool);
}


// Copyright 2017 Loopring Technology Limited.



                            
                                                                   
///
                                                                                           
                                                                                     
                                                                                      
                                                           
                                                
interface IDepositContract
{
                                                               
    function ISTOKENSUPPORTED796(address token)	//inject NONSTANDARD NAMING
        external
        view
        returns (bool);

                                                                             
                                                                  
                                                                              
                                                                                         
                                                                                       
                                                                   
    ///
                                                                 
    ///
                                                              
    ///
                                                                     
                                                                          
                                                       
                                                                                           
                                                                                             
    function DEPOSIT812(	//inject NONSTANDARD NAMING
        address from,
        address token,
        uint96  amount,
        bytes   calldata extraData
        )
        external
        payable
        returns (uint96 amountReceived);

                                                                             
                                                                            
                                                                                  
                                                                                         
                                                                           
                                                                            
                                                                                      
                                            
    ///
                                                                 
    ///
                                                              
    ///
                                                                           
                                                                       
                                                                          
                                                       
                                                                                              
    function WITHDRAW961(	//inject NONSTANDARD NAMING
        address from,
        address to,
        address token,
        uint    amount,
        bytes   calldata extraData
        )
        external
        payable;

                                                                                    
                                                                                           
                                                     
                                                                                    
                                                                                                 
                                                                                           
                                               
    ///
                                                                 
    ///
                                                              
    ///
                                                                     
                                                                       
                                                                                            
                                                       
    function TRANSFER658(	//inject NONSTANDARD NAMING
        address from,
        address to,
        address token,
        uint    amount
        )
        external
        payable;

                                                                           
                                                                                             
    ///
                                                                                               
                                                                                                 
                                                                                   
    ///
                                        
                                                                           
    function ISETH195(address addr)	//inject NONSTANDARD NAMING
        external
        view
        returns (bool);
}



                       
                                                                          
                                              
                                                
                                                
library ExchangeData
{
    // -- Enums --
    enum TransactionType
    {
        NOOP,
        DEPOSIT,
        WITHDRAWAL,
        TRANSFER,
        SPOT_TRADE,
        ACCOUNT_UPDATE,
        AMM_UPDATE
    }

    // -- Structs --
    struct Token
    {
        address token;
    }

    struct ProtocolFeeData
    {
        uint32 syncedAt; // only valid before 2105 (85 years to go)
        uint8  takerFeeBips;
        uint8  makerFeeBips;
        uint8  previousTakerFeeBips;
        uint8  previousMakerFeeBips;
    }

    // General auxiliary data for each conditional transaction
    struct AuxiliaryData
    {
        uint  txIndex;
        bytes data;
    }

    // This is the (virtual) block the owner  needs to submit onchain to maintain the
    // per-exchange (virtual) blockchain.
    struct Block
    {
        uint8      blockType;
        uint16     blockSize;
        uint8      blockVersion;
        bytes      data;
        uint256[8] proof;

        // Whether we should store the @BlockInfo for this block on-chain.
        bool storeBlockInfoOnchain;

        // Block specific data that is only used to help process the block on-chain.
        // It is not used as input for the circuits and it is not necessary for data-availability.
        AuxiliaryData[] auxiliaryData;

        // Arbitrary data, mainly for off-chain data-availability, i.e.,
        // the multihash of the IPFS file that contains the block data.
        bytes offchainData;
    }

    struct BlockInfo
    {
        // The time the block was submitted on-chain.
        uint32  timestamp;
        // The public data hash of the block (the 28 most significant bytes).
        bytes28 blockDataHash;
    }

    // Represents an onchain deposit request.
    struct Deposit
    {
        uint96 amount;
        uint64 timestamp;
    }

    // A forced withdrawal request.
    // If the actual owner of the account initiated the request (we don't know who the owner is
    // at the time the request is being made) the full balance will be withdrawn.
    struct ForcedWithdrawal
    {
        address owner;
        uint64  timestamp;
    }

    struct Constants
    {
        uint SNARK_SCALAR_FIELD;
        uint MAX_OPEN_FORCED_REQUESTS;
        uint MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE;
        uint TIMESTAMP_HALF_WINDOW_SIZE_IN_SECONDS;
        uint MAX_NUM_ACCOUNTS;
        uint MAX_NUM_TOKENS;
        uint MIN_AGE_PROTOCOL_FEES_UNTIL_UPDATED;
        uint MIN_TIME_IN_SHUTDOWN;
        uint TX_DATA_AVAILABILITY_SIZE;
        uint MAX_AGE_DEPOSIT_UNTIL_WITHDRAWABLE_UPPERBOUND;
    }

    function SNARK_SCALAR_FIELD483() internal pure returns (uint) {	//inject NONSTANDARD NAMING
        // This is the prime number that is used for the alt_bn128 elliptic curve, see EIP-196.
        return 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    }
    function MAX_OPEN_FORCED_REQUESTS307() internal pure returns (uint16) { return 4096; }	//inject NONSTANDARD NAMING
    function MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE249() internal pure returns (uint32) { return 15 days; }	//inject NONSTANDARD NAMING
    function TIMESTAMP_HALF_WINDOW_SIZE_IN_SECONDS626() internal pure returns (uint32) { return 7 days; }	//inject NONSTANDARD NAMING
    function MAX_NUM_ACCOUNTS339() internal pure returns (uint) { return 2 ** 32; }	//inject NONSTANDARD NAMING
    function MAX_NUM_TOKENS337() internal pure returns (uint) { return 2 ** 16; }	//inject NONSTANDARD NAMING
    function MIN_AGE_PROTOCOL_FEES_UNTIL_UPDATED702() internal pure returns (uint32) { return 7 days; }	//inject NONSTANDARD NAMING
    function MIN_TIME_IN_SHUTDOWN3() internal pure returns (uint32) { return 30 days; }	//inject NONSTANDARD NAMING
    // The amount of bytes each rollup transaction uses in the block data for data-availability.
    // This is the maximum amount of bytes of all different transaction types.
    function TX_DATA_AVAILABILITY_SIZE508() internal pure returns (uint32) { return 68; }	//inject NONSTANDARD NAMING
    function MAX_AGE_DEPOSIT_UNTIL_WITHDRAWABLE_UPPERBOUND638() internal pure returns (uint32) { return 15 days; }	//inject NONSTANDARD NAMING
    function ACCOUNTID_PROTOCOLFEE156() internal pure returns (uint32) { return 0; }	//inject NONSTANDARD NAMING

    function TX_DATA_AVAILABILITY_SIZE_PART_1259() internal pure returns (uint32) { return 29; }	//inject NONSTANDARD NAMING
    function TX_DATA_AVAILABILITY_SIZE_PART_2833() internal pure returns (uint32) { return 39; }	//inject NONSTANDARD NAMING

    struct AccountLeaf
    {
        uint32   accountID;
        address  owner;
        uint     pubKeyX;
        uint     pubKeyY;
        uint32   nonce;
        uint     feeBipsAMM;
    }

    struct BalanceLeaf
    {
        uint16   tokenID;
        uint96   balance;
        uint96   weightAMM;
        uint     storageRoot;
    }

    struct MerkleProof
    {
        ExchangeData.AccountLeaf accountLeaf;
        ExchangeData.BalanceLeaf balanceLeaf;
        uint[48]                 accountMerkleProof;
        uint[24]                 balanceMerkleProof;
    }

    struct BlockContext
    {
        bytes32 DOMAIN_SEPARATOR;
        uint32  timestamp;
    }

    // Represents the entire exchange state except the owner of the exchange.
    struct State
    {
        uint32  maxAgeDepositUntilWithdrawable;
        bytes32 DOMAIN_SEPARATOR;

        ILoopringV3      loopring;
        IBlockVerifier   blockVerifier;
        IAgentRegistry   agentRegistry;
        IDepositContract depositContract;


        // The merkle root of the offchain data stored in a Merkle tree. The Merkle tree
        // stores balances for users using an account model.
        bytes32 merkleRoot;

        // List of all blocks
        mapping(uint => BlockInfo) blocks;
        uint  numBlocks;

        // List of all tokens
        Token[] tokens;

        // A map from a token to its tokenID + 1
        mapping (address => uint16) tokenToTokenId;

        // A map from an accountID to a tokenID to if the balance is withdrawn
        mapping (uint32 => mapping (uint16 => bool)) withdrawnInWithdrawMode;

        // A map from an account to a token to the amount withdrawable for that account.
        // This is only used when the automatic distribution of the withdrawal failed.
        mapping (address => mapping (uint16 => uint)) amountWithdrawable;

        // A map from an account to a token to the forced withdrawal (always full balance)
        mapping (uint32 => mapping (uint16 => ForcedWithdrawal)) pendingForcedWithdrawals;

        // A map from an address to a token to a deposit
        mapping (address => mapping (uint16 => Deposit)) pendingDeposits;

        // A map from an account owner to an approved transaction hash to if the transaction is approved or not
        mapping (address => mapping (bytes32 => bool)) approvedTx;

        // A map from an account owner to a destination address to a tokenID to an amount to a storageID to a new recipient address
        mapping (address => mapping (address => mapping (uint16 => mapping (uint => mapping (uint32 => address))))) withdrawalRecipient;


        // Counter to keep track of how many of forced requests are open so we can limit the work that needs to be done by the owner
        uint32 numPendingForcedTransactions;

        // Cached data for the protocol fee
        ProtocolFeeData protocolFeeData;

        // Time when the exchange was shutdown
        uint shutdownModeStartTime;

        // Time when the exchange has entered withdrawal mode
        uint withdrawalModeStartTime;

        // Last time the protocol fee was withdrawn for a specific token
        mapping (address => uint) protocolFeeLastWithdrawnTime;
    }
}



                      
                                                                     
                                                                       
                                                       
///
                                                                   
                         
///
                                                
                                                
abstract contract IExchangeV3 is Claimable
{
    // -- Events --

    event EXCHANGECLONED511(	//inject NONSTANDARD NAMING
        address exchangeAddress,
        address owner,
        bytes32 genesisMerkleRoot
    );

    event TOKENREGISTERED650(	//inject NONSTANDARD NAMING
        address token,
        uint16  tokenId
    );

    event SHUTDOWN33(	//inject NONSTANDARD NAMING
        uint timestamp
    );

    event WITHDRAWALMODEACTIVATED651(	//inject NONSTANDARD NAMING
        uint timestamp
    );

    event BLOCKSUBMITTED428(	//inject NONSTANDARD NAMING
        uint    indexed blockIdx,
        bytes32         merkleRoot,
        bytes32         publicDataHash
    );

    event DEPOSITREQUESTED482(	//inject NONSTANDARD NAMING
        address from,
        address to,
        address token,
        uint16  tokenId,
        uint96  amount
    );

    event FORCEDWITHDRAWALREQUESTED509(	//inject NONSTANDARD NAMING
        address owner,
        address token,
        uint32  accountID
    );

    event WITHDRAWALCOMPLETED711(	//inject NONSTANDARD NAMING
        uint8   category,
        address from,
        address to,
        address token,
        uint    amount
    );

    event WITHDRAWALFAILED876(	//inject NONSTANDARD NAMING
        uint8   category,
        address from,
        address to,
        address token,
        uint    amount
    );

    event PROTOCOLFEESUPDATED599(	//inject NONSTANDARD NAMING
        uint8 takerFeeBips,
        uint8 makerFeeBips,
        uint8 previousTakerFeeBips,
        uint8 previousMakerFeeBips
    );

    event TRANSACTIONAPPROVED992(	//inject NONSTANDARD NAMING
        address owner,
        bytes32 transactionHash
    );

    // events from libraries
                                                                                                                                     

                                                                                                                           

                                                                                                                                          

                                                                                   


    // -- Initialization --
                                                                            
                                                         
                                                 
                                                                
    function INITIALIZE599(	//inject NONSTANDARD NAMING
        address loopring,
        address owner,
        bytes32 genesisMerkleRoot
        )
        virtual
        external;

                                                                          
                                                           
                                                                   
    function SETAGENTREGISTRY336(address agentRegistry)	//inject NONSTANDARD NAMING
        external
        virtual;

                                                                   
                                           
    function GETAGENTREGISTRY130()	//inject NONSTANDARD NAMING
        external
        virtual
        view
        returns (IAgentRegistry);

                                                           
                                                              
    function SETDEPOSITCONTRACT329(address depositContract)	//inject NONSTANDARD NAMING
        external
        virtual;

                                                            
                                    
    function GETDEPOSITCONTRACT552()	//inject NONSTANDARD NAMING
        external
        virtual
        view
        returns (IDepositContract);

    // @dev Exchange owner withdraws fees from the exchange.
    // @param token Fee token address
    // @param feeRecipient Fee recipient address
    function WITHDRAWEXCHANGEFEES258(	//inject NONSTANDARD NAMING
        address token,
        address feeRecipient
        )
        external
        virtual;

    // -- Constants --
                                                              
                                                
    function GETCONSTANTS860()	//inject NONSTANDARD NAMING
        external
        virtual
        pure
        returns(ExchangeData.Constants memory);

    // -- Mode --
                                                               
                                                                               
    function ISINWITHDRAWALMODE735()	//inject NONSTANDARD NAMING
        external
        virtual
        view
        returns (bool);

                                                      
                                                                     
    function ISSHUTDOWN18()	//inject NONSTANDARD NAMING
        external
        virtual
        view
        returns (bool);

    // -- Tokens --
                                                                                            
                                                    
    ///
                                                                                                   
                                                        
    ///
                                                                  
    ///
                                                
                                                         
    function REGISTERTOKEN777(	//inject NONSTANDARD NAMING
        address tokenAddress
        )
        external
        virtual
        returns (uint16 tokenID);

                                                  
                                                
                                                         
    function GETTOKENID492(	//inject NONSTANDARD NAMING
        address tokenAddress
        )
        external
        virtual
        view
        returns (uint16 tokenID);

                                                       
                                                         
                                                
    function GETTOKENADDRESS957(	//inject NONSTANDARD NAMING
        uint16 tokenID
        )
        external
        virtual
        view
        returns (address tokenAddress);

    // -- Stakes --
                                                                                   
                                                                                  
                                                                                              
                                                                               
    ///
                                        
    function GETEXCHANGESTAKE420()	//inject NONSTANDARD NAMING
        external
        virtual
        view
        returns (uint);

                                                           
                                                                               
                                                           
                                                 
                                                                                          
    ///
                                                      
    ///
                                                     
    function WITHDRAWEXCHANGESTAKE391(	//inject NONSTANDARD NAMING
        address recipient
        )
        external
        virtual
        returns (uint amountLRC);

                                                                                   
                                      
    ///
                                                                       
                                                
    function BURNEXCHANGESTAKE0()	//inject NONSTANDARD NAMING
        external
        virtual;

    // -- Blocks --

                                                                                
                                        
    function GETMERKLEROOT398()	//inject NONSTANDARD NAMING
        external
        virtual
        view
        returns (bytes32);

                                                                                          
                               
                                                                                   
    function GETBLOCKHEIGHT308()	//inject NONSTANDARD NAMING
        external
        virtual
        view
        returns (uint);

                                                                                        
                                                                                    
                                                       
                                        
    function GETBLOCKINFO928(uint blockIdx)	//inject NONSTANDARD NAMING
        external
        virtual
        view
        returns (ExchangeData.BlockInfo memory);

                                                         
    ///
                                                                       
    ///
                                                
                                                   
                                                                                
                                                     
                                                                               
                                                                                                  
                                            
                                                                                          
                                                                           
    function SUBMITBLOCKS846(ExchangeData.Block[] calldata blocks)	//inject NONSTANDARD NAMING
        external
        virtual;

                                                               
                                              
    function GETNUMAVAILABLEFORCEDSLOTS361()	//inject NONSTANDARD NAMING
        external
        virtual
        view
        returns (uint);

    // -- Deposits --

                                                                     
    ///
                                                                  
    ///
                                                                      
                                                                               
                            
    ///
                                                                       
                                                                 
                                                                          
                                                     
                                                                             
    function DEPOSIT812(	//inject NONSTANDARD NAMING
        address from,
        address to,
        address tokenAddress,
        uint96  amount,
        bytes   calldata auxiliaryData
        )
        external
        virtual
        payable;

                                                                                
                                                                      
                                                                          
                                             
    function GETPENDINGDEPOSITAMOUNT893(	//inject NONSTANDARD NAMING
        address owner,
        address tokenAddress
        )
        external
        virtual
        view
        returns (uint96);

    // -- Withdrawals --
                                                                                
                                                            
    ///
                                                                       
    ///
                                                                                
                                                                                 
    ///
                                                                           
                                                                                                  
                                                            
    ///
                                                      
                                                                          
                                                                    
    function FORCEWITHDRAW720(	//inject NONSTANDARD NAMING
        address owner,
        address tokenAddress,
        uint32  accountID
        )
        external
        virtual
        payable;

                                                                             
                                                                
                                       
                                                             
    function ISFORCEDWITHDRAWALPENDING612(	//inject NONSTANDARD NAMING
        uint32  accountID,
        address token
        )
        external
        virtual
        view
        returns (bool);

                                                                                  
                                                                             
    ///
                                                                  
    ///
                                                                           
                                                                                                  
                                                            
    ///
                                                                          
    function WITHDRAWPROTOCOLFEES774(	//inject NONSTANDARD NAMING
        address tokenAddress
        )
        external
        virtual
        payable;

                                                                           
                                                                          
                                                             
    function GETPROTOCOLFEELASTWITHDRAWNTIME313(	//inject NONSTANDARD NAMING
        address tokenAddress
        )
        external
        virtual
        view
        returns (uint);

                                                                                           
                                                                                   
    ///
                                                                                 
                                                                          
    ///
                                                                                 
                                                                                    
                                                                        
    ///
                                                      
    function WITHDRAWFROMMERKLETREE611(	//inject NONSTANDARD NAMING
        ExchangeData.MerkleProof calldata merkleProof
        )
        external
        virtual;

                                                                                               
                                                                
                                       
                                                                 
    function ISWITHDRAWNINWITHDRAWALMODE951(	//inject NONSTANDARD NAMING
        uint32  accountID,
        address token
        )
        external
        virtual
        view
        returns (bool);

                                                                                         
                                                                                 
    ///
                                                                               
                                                             
    ///
                                                                             
                                       
    function WITHDRAWFROMDEPOSITREQUEST842(	//inject NONSTANDARD NAMING
        address owner,
        address token
        )
        external
        virtual;

                                                                                
                                                                   
    ///
                                                                          
                                                              
    ///
                                                                                 
                                                                             
                                                                  
                                                                                     
    ///
                                                       
    ///
                                                                                
                                          
    function WITHDRAWFROMAPPROVEDWITHDRAWALS239(	//inject NONSTANDARD NAMING
        address[] calldata owners,
        address[] calldata tokens
        )
        external
        virtual;

                                                                                                      
                                                                             
                                       
                                       
    function GETAMOUNTWITHDRAWABLE280(	//inject NONSTANDARD NAMING
        address owner,
        address token
        )
        external
        virtual
        view
        returns (uint);

                                                                                   
                                                                                 
    ///
                                     
    ///
                                                                       
                                                                 
    function NOTIFYFORCEDREQUESTTOOOLD650(	//inject NONSTANDARD NAMING
        uint32  accountID,
        address token
        )
        external
        virtual;

                                                                             
                                                                                   
                                                           
    ///
                                                          
    ///
                                                                        
                                                                                  
                                                                                
                                                                          
                                                                 
                                                                        
    function SETWITHDRAWALRECIPIENT592(	//inject NONSTANDARD NAMING
        address from,
        address to,
        address token,
        uint96  amount,
        uint32  storageID,
        address newRecipient
        )
        external
        virtual;

                                           
    ///
                                                                        
                                                                                  
                                                                                
                                                                          
                                                                 
    function GETWITHDRAWALRECIPIENT486(	//inject NONSTANDARD NAMING
        address from,
        address to,
        address token,
        uint96  amount,
        uint32  storageID
        )
        external
        virtual
        view
        returns (address);

                                                                                     
                                                                                                                  
                                                                                               
    ///
                                                          
    ///
                                                                     
                                                                       
                                                                                            
                                                       
    function ONCHAINTRANSFERFROM491(	//inject NONSTANDARD NAMING
        address from,
        address to,
        address token,
        uint    amount
        )
        external
        virtual;

                                                    
    ///
                                                          
    ///
                                             
                                                 
    function APPROVETRANSACTION417(	//inject NONSTANDARD NAMING
        address owner,
        bytes32 txHash
        )
        external
        virtual;

                                                            
    ///
                                                          
    ///
                                        
                                                      
    function APPROVETRANSACTIONS714(	//inject NONSTANDARD NAMING
        address[] calldata owners,
        bytes32[] calldata txHashes
        )
        external
        virtual;

                                                                   
    ///
                                                                            
                                                 
                                                      
    function ISTRANSACTIONAPPROVED916(	//inject NONSTANDARD NAMING
        address owner,
        bytes32 txHash
        )
        external
        virtual
        view
        returns (bool);

    // -- Admins --
                                                                                  
                                      
                               
    function SETMAXAGEDEPOSITUNTILWITHDRAWABLE624(	//inject NONSTANDARD NAMING
        uint32 newValue
        )
        external
        virtual
        returns (uint32);

                                                                                     
                          
    function GETMAXAGEDEPOSITUNTILWITHDRAWABLE693()	//inject NONSTANDARD NAMING
        external
        virtual
        view
        returns (uint32);

                                     
                                                                                         
                                                                                
                                                   
    ///
                                                                                           
                                                                                              
                                                                                                 
                                                       
    ///
                                                      
    ///
                                                                    
    function SHUTDOWN305()	//inject NONSTANDARD NAMING
        external
        virtual
        returns (bool success);

                                                      
                                                                          
                                                   
                                                   
                                                                    
                                                                    
    function GETPROTOCOLFEEVALUES606()	//inject NONSTANDARD NAMING
        external
        virtual
        view
        returns (
            uint32 syncedAt,
            uint8 takerFeeBips,
            uint8 makerFeeBips,
            uint8 previousTakerFeeBips,
            uint8 previousMakerFeeBips
        );

                                                             
    function GETDOMAINSEPARATOR671()	//inject NONSTANDARD NAMING
        external
        virtual
        view
        returns (bytes32);
}


// Copyright 2017 Loopring Technology Limited.





                      
                                                
                                                
abstract contract ILoopringV3 is Claimable
{
    // == Events ==
    event EXCHANGESTAKEDEPOSITED907(address exchangeAddr, uint amount);	//inject NONSTANDARD NAMING
    event EXCHANGESTAKEWITHDRAWN386(address exchangeAddr, uint amount);	//inject NONSTANDARD NAMING
    event EXCHANGESTAKEBURNED415(address exchangeAddr, uint amount);	//inject NONSTANDARD NAMING
    event SETTINGSUPDATED90(uint time);	//inject NONSTANDARD NAMING

    // == Public Variables ==
    mapping (address => uint) internal exchangeStake;

    address public lrcAddress;
    uint    public totalStake;
    address public blockVerifierAddress;
    uint    public forcedWithdrawalFee;
    uint    public tokenRegistrationFeeLRCBase;
    uint    public tokenRegistrationFeeLRCDelta;
    uint8   public protocolTakerFeeBips;
    uint8   public protocolMakerFeeBips;

    address payable public protocolFeeVault;

    // == Public Functions ==
                                                  
                                                                            
    ///
                                                                   
                                    
    function UPDATESETTINGS249(	//inject NONSTANDARD NAMING
        address payable _protocolFeeVault,   // address(0) not allowed
        address _blockVerifierAddress,       // address(0) not allowed
        uint    _forcedWithdrawalFee
        )
        external
        virtual;

                                                      
                                                                            
    ///
                                                                   
                                    
    function UPDATEPROTOCOLFEESETTINGS464(	//inject NONSTANDARD NAMING
        uint8 _protocolTakerFeeBips,
        uint8 _protocolMakerFeeBips
        )
        external
        virtual;

                                                           
                                                       
                                           
    function GETEXCHANGESTAKE420(	//inject NONSTANDARD NAMING
        address exchangeAddr
        )
        public
        virtual
        view
        returns (uint stakedLRC);

                                                                          
                                                                              
                                                                                 
                                                                 
    function BURNEXCHANGESTAKE0(	//inject NONSTANDARD NAMING
        uint amount
        )
        external
        virtual
        returns (uint burnedLRC);

                                             
                                                        
                                                    
                                                                         
    function DEPOSITEXCHANGESTAKE519(	//inject NONSTANDARD NAMING
        address exchangeAddr,
        uint    amountLRC
        )
        external
        virtual
        returns (uint stakedLRC);

                                                                                           
                                                                                     
                                                    
                                                             
                                                     
    function WITHDRAWEXCHANGESTAKE391(	//inject NONSTANDARD NAMING
        address recipient,
        uint    requestedAmount
        )
        external
        virtual
        returns (uint amountLRC);

                                                          
                                                   
                                                   
    function GETPROTOCOLFEEVALUES606(	//inject NONSTANDARD NAMING
        )
        public
        virtual
        view
        returns (
            uint8 takerFeeBips,
            uint8 makerFeeBips
        );
}



                     
                                              
                                                
                                                
contract LoopringV3 is ILoopringV3, ReentrancyGuard
{
    using AddressUtil       for address payable;
    using MathUint          for uint;
    using ERC20SafeTransfer for address;

    // -- Constructor --
    constructor(
        address _lrcAddress,
        address payable _protocolFeeVault,
        address _blockVerifierAddress
        )
        Claimable()
    {
        require(address(0) != _lrcAddress, "ZERO_ADDRESS");

        lrcAddress = _lrcAddress;

        UPDATESETTINGSINTERNAL160(_protocolFeeVault, _blockVerifierAddress, 0);
    }

    // == Public Functions ==
    function UPDATESETTINGS249(	//inject NONSTANDARD NAMING
        address payable _protocolFeeVault,
        address _blockVerifierAddress,
        uint    _forcedWithdrawalFee
        )
        external
        override
        NONREENTRANT948
        ONLYOWNER112
    {
        UPDATESETTINGSINTERNAL160(
            _protocolFeeVault,
            _blockVerifierAddress,
            _forcedWithdrawalFee
        );
    }

    function UPDATEPROTOCOLFEESETTINGS464(	//inject NONSTANDARD NAMING
        uint8 _protocolTakerFeeBips,
        uint8 _protocolMakerFeeBips
        )
        external
        override
        NONREENTRANT948
        ONLYOWNER112
    {
        protocolTakerFeeBips = _protocolTakerFeeBips;
        protocolMakerFeeBips = _protocolMakerFeeBips;

        emit SETTINGSUPDATED90(block.timestamp);
    }

    function GETEXCHANGESTAKE420(	//inject NONSTANDARD NAMING
        address exchangeAddr
        )
        public
        override
        view
        returns (uint)
    {
        return exchangeStake[exchangeAddr];
    }

    function BURNEXCHANGESTAKE0(	//inject NONSTANDARD NAMING
        uint amount
        )
        external
        override
        NONREENTRANT948
        returns (uint burnedLRC)
    {
        burnedLRC = exchangeStake[msg.sender];

        if (amount < burnedLRC) {
            burnedLRC = amount;
        }
        if (burnedLRC > 0) {
            lrcAddress.SAFETRANSFERANDVERIFY454(protocolFeeVault, burnedLRC);
            exchangeStake[msg.sender] = exchangeStake[msg.sender].SUB429(burnedLRC);
            totalStake = totalStake.SUB429(burnedLRC);
        }
        emit EXCHANGESTAKEBURNED415(msg.sender, burnedLRC);
    }

    function DEPOSITEXCHANGESTAKE519(	//inject NONSTANDARD NAMING
        address exchangeAddr,
        uint    amountLRC
        )
        external
        override
        NONREENTRANT948
        returns (uint stakedLRC)
    {
        require(amountLRC > 0, "ZERO_VALUE");

        lrcAddress.SAFETRANSFERFROMANDVERIFY218(msg.sender, address(this), amountLRC);

        stakedLRC = exchangeStake[exchangeAddr].ADD886(amountLRC);
        exchangeStake[exchangeAddr] = stakedLRC;
        totalStake = totalStake.ADD886(amountLRC);

        emit EXCHANGESTAKEDEPOSITED907(exchangeAddr, amountLRC);
    }

    function WITHDRAWEXCHANGESTAKE391(	//inject NONSTANDARD NAMING
        address recipient,
        uint    requestedAmount
        )
        external
        override
        NONREENTRANT948
        returns (uint amountLRC)
    {
        uint stake = exchangeStake[msg.sender];
        amountLRC = (stake > requestedAmount) ? requestedAmount : stake;

        if (amountLRC > 0) {
            lrcAddress.SAFETRANSFERANDVERIFY454(recipient, amountLRC);
            exchangeStake[msg.sender] = exchangeStake[msg.sender].SUB429(amountLRC);
            totalStake = totalStake.SUB429(amountLRC);
        }

        emit EXCHANGESTAKEWITHDRAWN386(msg.sender, amountLRC);
    }

    function GETPROTOCOLFEEVALUES606()	//inject NONSTANDARD NAMING
        public
        override
        view
        returns (
            uint8 takerFeeBips,
            uint8 makerFeeBips
        )
    {
        return (protocolTakerFeeBips, protocolMakerFeeBips);
    }

    // == Internal Functions ==
    function UPDATESETTINGSINTERNAL160(	//inject NONSTANDARD NAMING
        address payable  _protocolFeeVault,
        address _blockVerifierAddress,
        uint    _forcedWithdrawalFee
        )
        private
    {
        require(address(0) != _protocolFeeVault, "ZERO_ADDRESS");
        require(address(0) != _blockVerifierAddress, "ZERO_ADDRESS");

        protocolFeeVault = _protocolFeeVault;
        blockVerifierAddress = _blockVerifierAddress;
        forcedWithdrawalFee = _forcedWithdrawalFee;

        emit SETTINGSUPDATED90(block.timestamp);
    }
}