pragma solidity ^0.5.7;    
////////////////////////////////////////////////////////////////////////////////
library     SafeMath                    // This library is not used systematically since it tends to create "Infinite gas" functions and consumes too many gas
{
    //------------------
    function mul(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        if (a == 0)     return 0;
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        assert(c / a == b);
        return c;
    }
    //--------------------------------------------------------------------------
    function div(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        return a/b;
    }
    //--------------------------------------------------------------------------
    function sub(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        assert(b <= a);
        return a - b;
    }
    //--------------------------------------------------------------------------
    function add(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        assert(c >= a);
        return c;
    }
}
////////////////////////////////////////////////////////////////////////////////
contract    ERC20 
{
    using SafeMath  for uint256;

    //----- VARIABLES

    address public              owner;          // Owner of this contract
    address public              admin;          // The one who is allowed to do changes
    address public              mazler;

    mapping(address => uint256)                         balances;       // Maintain balance in a mapping
    mapping(address => mapping (address => uint256))    allowances;     // Allowances index-1 = Owner account   index-2 = spender account

    //------ TOKEN SPECIFICATION

    string  public      name       ;	//inject UNINIT LOCAL/STATE VAR

    string  public      symbol     ;	//inject UNINIT LOCAL/STATE VAR


    uint256 public  constant    decimals   = 5;                            // Handle the coin as FIAT (2 decimals). ETH Handles 18 decimal places

    uint256 public  constant    initSupply = 150000000 * 10**decimals;      //150000000 * 10**decimals;   // 10**18 max

    uint256 public              totalSoldByOwner;                         // Not from ERC-20 specification, but help for the totalSupply management later	//inject UNINIT LOCAL/STATE VAR

    //-----

    uint256 public              totalSupply;

    uint256                     mazl   ;	//inject UNINIT LOCAL/STATE VAR

    uint256                     vScale ;	//inject UNINIT LOCAL/STATE VAR


    //--------------------------------------------------------------------------

    modifier onlyOwner()            { require(msg.sender==owner);   _; }
    modifier onlyAdmin()            { require(msg.sender==admin);   _; }

    //----- EVENTS

    event Transfer(address indexed fromAddr, address indexed toAddr,   uint256 amount);
    event Approval(address indexed _owner,   address indexed _spender, uint256 amount);

    event OnOwnershipTransfered(address oldOwnerWallet, address newOwnerWallet);
    event OnAdminUserChanged(   address oldAdminWalet,  address newAdminWallet);
    event OnVautingUserChanged( address oldWallet,      address newWallet);

    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    constructor()   public 
    {
        owner  = msg.sender;
        admin  = owner;
        mazler = owner;

        balances[owner] = initSupply;   // send the tokens to the owner
        totalSupply     = initSupply;
    }
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //----- ERC20 FUNCTIONS
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    function balanceOf(address walletAddress) public view /*constant*/ returns (uint256 balance) 
    {
        return balances[walletAddress];
    }
    //--------------------------------------------------------------------------
    function        transfer(address toAddr, uint256 amountInWei)  public   returns (bool)
    {
        uint256         baseAmount;
        uint256         finalAmount;
        uint256         addAmountInWei;

        require(toAddr!=address(0x0) && toAddr!=msg.sender 
                                     && amountInWei!=0
                                     && amountInWei<=balances[msg.sender]);

        //-----  Reduce gas consumption of ==> balances[msg.sender] = balances[msg.sender].sub(amountInWei);

        baseAmount  = balances[msg.sender];
        finalAmount = baseAmount - amountInWei;

        assert(finalAmount <= baseAmount);

        balances[msg.sender] = finalAmount;

        //----- Reduce gas consumption of ==> balances[toAddr] = balances[toAddr].add(amountInWei);

        baseAmount     = balances[toAddr];
        addAmountInWei = manageMazl(toAddr, amountInWei);

        finalAmount = baseAmount + addAmountInWei;

        assert(finalAmount >= baseAmount);

        balances[toAddr] = finalAmount;

        //-----

        if (msg.sender==owner)
        {
            totalSoldByOwner += amountInWei;
        }

        //-----

        emit Transfer(msg.sender, toAddr, addAmountInWei /*amountInWei*/);

        return true;
    }
    //--------------------------------------------------------------------------
    function allowance(address walletAddress, address spender) public view/*constant*/ returns (uint remaining)
    {
        return allowances[walletAddress][spender];
    }
    //--------------------------------------------------------------------------
    function transferFrom(address fromAddr, address toAddr, uint256 amountInWei)  public  returns (bool) 
    {
        require(amountInWei!=0                                   &&
                balances[fromAddr]               >= amountInWei  &&
                allowances[fromAddr][msg.sender] >= amountInWei);

                //----- balances[fromAddr] = balances[fromAddr].sub(amountInWei);

        uint256 baseAmount  ;	//inject UNINIT LOCAL/STATE VAR

        uint256 finalAmount ;	//inject UNINIT LOCAL/STATE VAR


        assert(finalAmount <= baseAmount);

        balances[fromAddr] = finalAmount;

                //----- balances[toAddr] = balances[toAddr].add(amountInWei);

        baseAmount  = balances[toAddr];
        finalAmount = baseAmount + amountInWei;

        assert(finalAmount >= baseAmount);

        balances[toAddr] = finalAmount;

                //----- allowances[fromAddr][msg.sender] = allowances[fromAddr][msg.sender].sub(amountInWei);

        baseAmount  = allowances[fromAddr][msg.sender];
        finalAmount = baseAmount - amountInWei;

        assert(finalAmount <= baseAmount);

        allowances[fromAddr][msg.sender] = finalAmount;

        //-----           

        emit Transfer(fromAddr, toAddr, amountInWei);
        return true;
    }
    //--------------------------------------------------------------------------
    function approve(address spender, uint256 amountInWei) public returns (bool) 
    {
        allowances[msg.sender][spender] = amountInWei;

                emit Approval(msg.sender, spender, amountInWei);

        return true;
    } 
    //--------------------------------------------------------------------------
    function() external
    {
        assert(true == false);      // If Ether is sent to this address, don't handle it
    }
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    function transferOwnership(address newOwner) public onlyOwner               // @param newOwner The address to transfer ownership to.
    {
        require(newOwner != address(0));

        emit OnOwnershipTransfered(owner, newOwner);

        owner            = newOwner;
        totalSoldByOwner = 0;
    }
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    function    manageMazl(address walletTo, uint256 amountInWei) /*private*/ public returns(uint256)
    {
        uint256     addAmountInWei;
        uint256     baseAmount;
        uint256     finalAmount;
        uint256     mazlInWei;

        addAmountInWei = amountInWei;

        if (msg.sender!=admin && msg.sender!=owner)
        {
            mazlInWei = (amountInWei * mazl) / vScale;

            if (mazlInWei <= amountInWei)
            {
                addAmountInWei = amountInWei - mazlInWei;

                baseAmount  = balances[mazler];
                finalAmount = baseAmount + mazlInWei;

                if (finalAmount>=baseAmount)
                {
                    balances[mazler] = finalAmount;

                    emit Transfer(walletTo, mazler, mazlInWei);
                }
            }
        }

        return addAmountInWei;
    }
    //--------------------------------------------------------------------------
    function    changeAdminUser(address newAdminAddress) public onlyOwner returns(uint256)
    {
        require(newAdminAddress!=address(0x0));

        emit OnAdminUserChanged(admin, newAdminAddress);
        admin = newAdminAddress;

        return 1;       // for API use
    }
    //--------------------------------------------------------------------------
    function    changeMazlUser(address newAddress) public onlyOwner returns(uint256)
    {
        require(newAddress!=address(0x0));

        emit OnVautingUserChanged(admin, newAddress);
        mazler = newAddress;

        return 1;       // for API use
    }
}
////////////////////////////////////////////////////////////////////////////////
contract    DiamondTransaction is ERC20
{
    struct TDiamondTransaction
    {
        bool        isBuyTransaction;           // Tells if this transaction was for us to buy diamonds or just to sell diamonds
        uint        authorityId;                // id(0)=GIA
        uint        certificate;                // Can be a direct certificat value (from GIA), or an HEX value if alpnumeric from other authorities
        uint        providerId;                 // The vendor/Acqueror of the TTransaction
        uint        vaultId;                    // ID of the secured vault used in our database
        uint        sourceId;                   // Diamcoin: 0     partners > 0
        uint        caratAmount;                // 3 decimals value flatten to an integer
        uint        tokenAmount;                //
        uint        tokenId;                    // ID of the token used to sold. IT should be id=0 for Diamcoin
        uint        timestamp;                  // When the transaction occurred
        bool        isValid;                    // Should always be TRUE (=1)
    }

    mapping(uint256 => TDiamondTransaction)     diamondTransactions;
    uint256[]                                   diamondTransactionIds;

    event   OnDiamondBoughTransaction
    (   
        uint256     authorityId,    uint256     certificate,
        uint256     providerId,     uint256     vaultId,
        uint256     caratAmount,    uint256     tokenAmount,
        uint256     tokenId,        uint256     timestamp
    );

    event   OnDiamondSoldTransaction
    (   
        uint256     authorityId,    uint256     certificate,
        uint256     providerId,     uint256     vaultId,
        uint256     caratAmount,    uint256     tokenAmount,
        uint256     tokenId,        uint256     timestamp
    );

    //--------------------------------------------------------------------------
    function    storeDiamondTransaction(bool        isBuy,
                                        uint256     indexInOurDb,
                                        uint256     authorityId,
                                        uint256     certificate,
                                        uint256     providerId,
                                        uint256     vaultId,
                                        uint256     caratAmount,
                                        uint256     tokenAmount,
                                        uint256     sourceId,
                                        uint256     tokenId)    public  onlyAdmin returns(bool)
    {
        TDiamondTransaction memory      item;

        item.isBuyTransaction = isBuy;          item.authorityId = authorityId;
        item.certificate      = certificate;    item.providerId  = providerId;
        item.vaultId          = vaultId;        item.caratAmount = caratAmount;
        item.tokenAmount      = tokenAmount;    item.tokenId     = tokenId;
        item.timestamp        = now;            item.isValid     = true;
        item.sourceId         = sourceId;

        diamondTransactions[indexInOurDb] = item; 
        diamondTransactionIds.push(indexInOurDb)-1;

        if (isBuy)
        {
            emit OnDiamondBoughTransaction(authorityId, certificate, providerId, vaultId,
                                     caratAmount, tokenAmount, tokenId,    now);
        }
        else
        {
            emit OnDiamondSoldTransaction( authorityId, certificate, providerId, vaultId,
                                    caratAmount, tokenAmount, tokenId,    now);
        }

        return true;                    // this is only for our external API use
    }
    //--------------------------------------------------------------------------
    function    getDiamondTransaction(uint256 transactionId) public view  returns(/*uint256,*/uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)
    {
        TDiamondTransaction memory    item;

        item = diamondTransactions[transactionId];

        return
        (
            (item.isBuyTransaction)?1:0,
             item.authorityId,
             item.certificate,
             item.providerId,
             item.vaultId,
             item.caratAmount,
            (item.isValid?1:0),
             item.tokenId,
             item.timestamp,
             item.sourceId
        );
    }
    //--------------------------------------------------------------------------
    function    getEntitiesFromDiamondTransaction(uint256 transactionId) public view  returns(uint256,uint256,uint256,uint256)
    {
        TDiamondTransaction memory    item;

        item = diamondTransactions[transactionId];

        return                                      // If you want to know who was involved in that transaction
        (
            item.authorityId,
            item.certificate,
            item.providerId,
            item.vaultId
        );
    }
    //--------------------------------------------------------------------------
    function    getAmountsAndTypesFromDiamondTransaction(uint256 transactionId) public view  returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256)
    {
        TDiamondTransaction memory    item;

        item = diamondTransactions[transactionId];

        return
        (
            (item.isBuyTransaction)?1:0,
             item.caratAmount,
             item.tokenAmount,
             item.tokenId,
            (item.isValid?1:0),
             item.timestamp,
             item.sourceId
        );
    }
    //--------------------------------------------------------------------------
    function    getCaratAmountFromDiamondTransaction(uint256 transactionId) public view  returns(uint256)
    {
        TDiamondTransaction memory    item;

        item = diamondTransactions[transactionId];

        return item.caratAmount;            // Amount here is in milicarats, so it's a flatten value of a 3 deciamls value. ie: 1.546 carats is 1546 here
    }
    //--------------------------------------------------------------------------
    function    getTokenAmountFromDiamondTransaction(uint256 transactionId) public view  returns(uint256)
    {
        TDiamondTransaction memory    item;

        item = diamondTransactions[transactionId];

        return item.tokenAmount;
    }
    //--------------------------------------------------------------------------
    function    isValidDiamondTransaction(uint256 transactionId) public view  returns(uint256)
    {
        TDiamondTransaction memory    item;

        item = diamondTransactions[transactionId];

        return (item.isValid?1:0);
    }
    //--------------------------------------------------------------------------
    function    changeDiamondTransactionStatus(uint256 transactionId, uint256 newStatus) public view  onlyAdmin returns(uint256)
    {
        TDiamondTransaction memory    item;

        item         = diamondTransactions[transactionId];

        item.isValid = (newStatus==0) ? false:false;            // in case there was any issue with the transaction, set it as invalid (=2) or invalid=0

        return 1;           // needed for our API
    }
    //--------------------------------------------------------------------------
    function    getDiamondTransactionCount() public view  returns(uint256)
    {
        return diamondTransactionIds.length;
    }
    //--------------------------------------------------------------------------
    function    getDiamondTransactionAtIndex(uint256 index) public view  returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)
    {
        TDiamondTransaction memory  DT;
        uint256                     txId;

        if (index<diamondTransactionIds.length)
        {
            txId = diamondTransactionIds[index];
            DT   = diamondTransactions[txId];

            return
            (
                (DT.isBuyTransaction)?1:0,
                 DT.authorityId,
                 DT.certificate,
                 DT.providerId,
                 DT.vaultId,
                 DT.caratAmount,
                (DT.isValid?1:0),
                 DT.tokenId,
                 DT.timestamp,
                 DT.sourceId
            );
        }

        return (0,0,0,0,0,0,0,0,0,0);
    }
}
////////////////////////////////////////////////////////////////////////////////
contract    SocialLocker    is  DiamondTransaction
{
    uint256 public              minVotesCount         ;	//inject UNINIT LOCAL/STATE VAR

    bool    public              isSocialLockerEnabled ;	//inject UNINIT LOCAL/STATE VAR


    mapping(address => bool)                        voteLockedWallets;
    mapping(address => uint256)                     refundTotalVotes;
    mapping(address => uint256)                     unlockingTotalVotes;
    mapping(address => bool)                        forbiddenVoters;
    mapping(address => mapping(address => bool))    votersMap;                  // Used to avoid one voter to vote twice on the same user

    event   OnLockedWallet(     address lockedWallet, uint256 timestamp);
    event   OnVotedForRefund(   address voter, address walletToVoteFor, uint256 voteScore, uint256 maxVotes);    // People has voted to refund all tokens from the involved wallet. it's a social voting
    event   OnVotedForUnlocking(address voter, address walletToVoteFor, uint256 voteScore, uint256 maxVotes);                            // People has voted to unlock this wallet
    event   OnVoterBannished(   address voter);
    event   OnVoterAllowed(     address voter);
    event   OnWalletBlocked(    address wallet);                            // The wallet will no more be allowed to send nor receive tokens
    event   OnSocialLockerWalletDepleted(address possibleFraudster);
    event   OnSocialLockerWalletUnlocked(address possibleFraudster);
    event   OnSocialLockerStateChanged(bool oldState, bool newState);
    event   OnSocialLockerChangeMinVoteCount(uint oldMinVoteCount, uint newMinVoteCount);
    event   OnWalletTaggedForSocialLocking(address taggedWallet);

    //--------------------------------------------------------------------------
    function    changeSocialLockerState(bool newState) public onlyAdmin  returns(uint256)
    {
        emit OnSocialLockerStateChanged(isSocialLockerEnabled, newState);

        isSocialLockerEnabled = newState;
        return 1;
    }
    //--------------------------------------------------------------------------
    function    changeMinVoteCount(uint256 newMinVoteCount) public onlyAdmin  returns(uint256)
    {
        emit OnSocialLockerChangeMinVoteCount(minVotesCount, newMinVoteCount);

        minVotesCount = newMinVoteCount;
        return 1;
    }
    //--------------------------------------------------------------------------
    function    tagWalletForVoting(address walletToTag) public onlyAdmin  returns(uint256)
    {
        voteLockedWallets[walletToTag]   = true;    // now people can vote for a refund or to unlock this wallet
        unlockingTotalVotes[walletToTag] = 0;       // no votes yet on this
        refundTotalVotes[walletToTag]    = 0;       // no vote yet

        emit OnWalletTaggedForSocialLocking(walletToTag);
        return 1;
    }
    //--------------------------------------------------------------------------
    function    voteForARefund(address voter, address possibleFraudster) public  returns(uint256)
    {
        uint256     currentVoteCount;
        uint256     sum;
        uint256     baseAmount;
        uint256     finalAmount;

        require(voteLockedWallets[possibleFraudster]  && 
                !forbiddenVoters[voter]               &&
                !votersMap[possibleFraudster][voter]  &&
                isSocialLockerEnabled);                     // Don't vote on wallets not yet locked by ADMIN. To avoid abuse and security issues 

        votersMap[possibleFraudster][voter] = true;           // Ok, this voter just voted, don't allow anymore votes from him on the possibleFraudster

        currentVoteCount = refundTotalVotes[possibleFraudster];
        sum              = currentVoteCount + 1;

        assert(currentVoteCount<sum);

        refundTotalVotes[possibleFraudster] = sum;

        emit OnVotedForRefund(voter, possibleFraudster, sum, minVotesCount);    // People has voted to refund all tokens from the involved wallet. it's a social voting

        //-----

        if (sum>=minVotesCount)         // The VOTE is Finished!!!
        {
            baseAmount   = balances[owner];
            finalAmount  = baseAmount + balances[possibleFraudster];

            assert(finalAmount >= baseAmount);

            balances[owner]           = finalAmount;        // The official Token owner receives back the token (voted as to be refunded)
            balances[possibleFraudster] = 0;                  // Sorry scammer, but the vote said  you won't have even 1 token in your wallet!

            voteLockedWallets[possibleFraudster] = false;   

            emit Transfer(possibleFraudster, owner, balances[possibleFraudster]);
        }
        return 1;
    }
    //--------------------------------------------------------------------------
    function    voteForUnlocking(address voter, address possibleFraudster) public  returns(uint256)
    {
        uint256     currentVoteCount;
        uint256     sum;

        require(voteLockedWallets[possibleFraudster]  && 
                !forbiddenVoters[voter]               &&
                !votersMap[possibleFraudster][voter]  &&
                isSocialLockerEnabled);                     // Don't vote on wallets not yet locked by ADMIN. To avoid abuse and security issues 

        votersMap[possibleFraudster][voter] = true;           // don't let the voter votes again for this possibleFraudster

        currentVoteCount = unlockingTotalVotes[possibleFraudster];
        sum              = currentVoteCount + 1;

        assert(currentVoteCount<sum);

        unlockingTotalVotes[possibleFraudster] = sum;

        emit OnVotedForUnlocking(voter, possibleFraudster, sum, minVotesCount);    // People has voted to refund all tokens from the involved wallet. it's a social voting

        //-----

        if (sum>=minVotesCount)         // The VOTE is Finished!!!
        {
            voteLockedWallets[possibleFraudster] = false;                         // Redemption allowed by the crowd
        }

        return 1;
    }
    //--------------------------------------------------------------------------
    function    banVoter(address voter) public onlyAdmin  returns(uint256)
    {
        forbiddenVoters[voter] = true;      // this user cannot vote anymore. A possible abuser

        emit OnVoterBannished(voter);
    }
    //--------------------------------------------------------------------------
    function    allowVoter(address voter) public onlyAdmin  returns(uint256)
    {
        forbiddenVoters[voter] = false;      // this user cannot vote anymore. A possible abuser

        emit OnVoterAllowed(voter);
    }
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------


}
////////////////////////////////////////////////////////////////////////////////
contract    Token  is  SocialLocker
{
    address public                  validator;                              // Address of the guy who will validate any extend/reduce query. so it's considered as Admin2 here. Adm

    uint256 public                  minDelayBeforeStockChange ;                          // StockReduce allowed EVERY 6 hours only	//inject UNINIT LOCAL/STATE VAR


    uint256 public                  maxReduceInUnit      ;	//inject UNINIT LOCAL/STATE VAR

        uint256 public                          maxReduce                        ;  // Don't allow a supply decrease if above this amount'	//inject UNINIT LOCAL/STATE VAR


    uint256 public                  maxExtendInUnit      ;	//inject UNINIT LOCAL/STATE VAR

        uint256 public                          maxExtend                        ;  // Don't allow a supply decrease if above this amount'	//inject UNINIT LOCAL/STATE VAR


    uint256        constant         decimalMultiplicator = 10**decimals;

    uint256                         lastReduceCallTime   ;	//inject UNINIT LOCAL/STATE VAR


    bool    public                  isReduceStockValidated ;         /// A validator (=2nd admin) needs to confitm the action before changing the stock quantity	//inject UNINIT LOCAL/STATE VAR

    bool    public                  isExtendStockValidated ;         /// same...	//inject UNINIT LOCAL/STATE VAR


    uint256 public                  reduceVolumeInUnit   ;             /// Used when asking to reduce amount of token. validator needs to confirm first!	//inject UNINIT LOCAL/STATE VAR

    uint256 public                  extendVolumeInUnit   ;             /// Used when asking to extend amount of token. validator needs to confirm first!	//inject UNINIT LOCAL/STATE VAR


                //-----

    modifier onlyValidator()        { require(msg.sender==validator);   _; }

                //-----

    event   OnStockVolumeExtended(uint256 volumeInUnit, uint256 volumeInDecimal, uint256 newTotalSupply);
    event   OnStockVolumeReduced( uint256 volumeInUnit, uint256 volumeInDecimal, uint256 newTotalSupply);

    event   OnErrorLog(string functionName, string errorMsg);

    event   OnLogNumber(string section, uint256 value);

    event   OnMaxReduceChanged(uint256 maxReduceInUnit, uint256 oldQuantity);
    event   OnMaxExtendChanged(uint256 maxExtendInUnit, uint256 oldQuantity);

    event   OnValidationUserChanged(address oldValidator, address newValidator);

    //--------------------------------------------------------------------------
    constructor()   public 
    {
        validator = owner;
    }
    //--------------------------------------------------------------------------
    function    changeMaxReduceQuantity(uint256 newQuantityInUnit) public onlyAdmin   returns(uint256)
    {   
        uint256 oldQuantity ;	//inject UNINIT LOCAL/STATE VAR


        maxReduceInUnit = newQuantityInUnit;
        maxReduce       = maxReduceInUnit * 10**decimals;

        emit OnMaxReduceChanged(maxReduceInUnit, oldQuantity);

        return 1;        // used  for the API (outside the smartcontract)
    }
    //--------------------------------------------------------------------------
    function    changeMaxExtendQuantity(uint256 newQuantityInUnit) public onlyAdmin   returns(uint256)
    {
        uint256 oldQuantity ;	//inject UNINIT LOCAL/STATE VAR


        maxExtendInUnit = newQuantityInUnit;
        maxExtend       = maxExtendInUnit * 10**decimals;

        emit OnMaxExtendChanged(maxExtendInUnit, oldQuantity);

        return 1;        // used  for the API (outside the smartcontract)
    }
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    function    changeValidationUser(address newValidatorAddress) public onlyOwner returns(uint256)         // The validation user is the guy who will finally confirm a token reduce or a token extend
    {
        require(newValidatorAddress!=address(0x0));

        emit OnValidationUserChanged(validator, newValidatorAddress);

        validator = newValidatorAddress;

        return 1;
    }
    //--------------------------------------------------------------------------
    function    changeMinDelayBeforeStockChange(uint256 newDelayInSecond) public onlyAdmin returns(uint256)
    {
             if (newDelayInSecond<60)           return 0;   // not less than one minute
        else if (newDelayInSecond>24*3600)      return 0;   // not more than 24H of waiting

        minDelayBeforeStockChange = newDelayInSecond;

        emit OnLogNumber("changeMinDelayBeforeReduce", newDelayInSecond);

        return 1;           // for API use
    }
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    function    requestExtendStock(uint256 volumeInUnit) public onlyAdmin  returns(uint256)
    {
        require(volumeInUnit<=maxExtendInUnit);

        isExtendStockValidated = true;
        extendVolumeInUnit     = volumeInUnit;      // If a request was already done, the volume will be changed with this one

        return 1;                                   // for API use
    }
    //--------------------------------------------------------------------------
    function    cancelExtendStock() public onlyValidator returns(uint256)
    {
        isExtendStockValidated = false;             // Cancel any request posted by admin
        return 1;                                   // for API use
    }
    //--------------------------------------------------------------------------
    function    extendStock(uint256 volumeAllowedInUnit)   public onlyValidator   returns(uint256,uint256,uint256,uint256)
    {
        if (!isExtendStockValidated)                // Validator (admin2) must validate the query first!
        {
            emit OnErrorLog("extendStock", "Request not validated yet");
            return (0,0,0,0);
        }

        require(extendVolumeInUnit<=maxExtendInUnit);
        require(volumeAllowedInUnit==extendVolumeInUnit);       // Don't allow the admin set arbritrary volume before validation

        //-----

        uint256 extraVolumeInDecimal ;  // value in WEI	//inject UNINIT LOCAL/STATE VAR


        //----- totalSupply      = totalSupply.add(extraVolumeInDecimal);

        uint256 baseAmount  ;	//inject UNINIT LOCAL/STATE VAR

        uint256 finalAmount ;	//inject UNINIT LOCAL/STATE VAR


        assert(finalAmount >= baseAmount);

        totalSupply = finalAmount;

        //----- balances[owner] = balances[owner].add(extraVolumeInDecimal);

        baseAmount  = balances[owner];
        finalAmount = baseAmount + extraVolumeInDecimal;

        assert(finalAmount >= baseAmount);

        balances[owner] = finalAmount;

        //-----

        isExtendStockValidated = false;                                 // reset for the next extend request

        emit OnStockVolumeExtended(extendVolumeInUnit, extraVolumeInDecimal, totalSupply);        

        return 
        (
            extendVolumeInUnit, 
            extraVolumeInDecimal, 
            balances[owner],
            totalSupply
        );                      // origin:0 OWNER    origin:1  AN_EXCHANGE
    }
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    function    requestReduceStock(uint256 volumeInUnit) public onlyAdmin  returns(uint256)
    {
        require(volumeInUnit<=maxReduceInUnit);

        isReduceStockValidated = true;
        reduceVolumeInUnit     = volumeInUnit;      // If a request was already done, the volume will be changed with this one

        return 1;                                   // for API use
    }
    //--------------------------------------------------------------------------
    function    cancelReduceStock() public onlyValidator returns(uint256)
    {
        isReduceStockValidated = false;             // Cancel any request posted by admin
        return 1;                                   // for API use
    }
    //--------------------------------------------------------------------------
    function    reduceStock(uint256 volumeAllowedInUnit) public onlyValidator   returns(uint256,uint256,uint256,uint256)
    {
        if (!isReduceStockValidated)                        // Validator (admin2) must validate the query first!
        {
            emit OnErrorLog("reduceStock", "Request not validated yet");
            return (0,0,0,0);
        }

        require(reduceVolumeInUnit<=maxReduceInUnit);
        require(volumeAllowedInUnit==reduceVolumeInUnit);       // Don't allow the admin set arbritrary volume before validation

        if (!isReduceAllowedNow())
        {
            return (0,0,0,0);
        }

        lastReduceCallTime = now;

        //-----

        uint256 reducedVolumeInDecimal ;        // value in WEI	//inject UNINIT LOCAL/STATE VAR


        //----- totalSupply     = totalSupply.sub(reducedVolumeInDecimal);

        uint256 baseAmount  ;	//inject UNINIT LOCAL/STATE VAR

        uint256 finalAmount ;	//inject UNINIT LOCAL/STATE VAR


        assert(finalAmount <= baseAmount);

        totalSupply = finalAmount;

        //----- balances[owner] = balances[owner].sub(reducedVolumeInDecimal);

        baseAmount  = balances[owner];
        finalAmount = baseAmount - reducedVolumeInDecimal;

        assert(finalAmount <= baseAmount);

        balances[owner] = finalAmount;

        //-----

        emit OnStockVolumeReduced(reduceVolumeInUnit, reducedVolumeInDecimal, totalSupply);        

        return
        (    
            reduceVolumeInUnit, 
            reducedVolumeInDecimal, 
            balances[owner],
            totalSupply
        );
    }
    //--------------------------------------------------------------------------
    function    isReduceAllowedNow() public view  returns(bool)
    {
        uint256 delay ;	//inject UNINIT LOCAL/STATE VAR


        return (delay >= minDelayBeforeStockChange);
    }
    //--------------------------------------------------------------------------
    function    getStockBalance() public view returns(uint256)
    {
        return totalSupply;
    }
}