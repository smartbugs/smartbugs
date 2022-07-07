                                                                 

pragma solidity 0.6.0;

                                                                           
contract Nest_NToken_OfferMain {
    
    using SafeMath for uint256;
    using address_make_payable for address;
    using SafeERC20 for ERC20;
    
    // Offering data structure
    struct Nest_NToken_OfferPriceData {
        // The unique identifier is determined by the position of the offer in the array, and is converted to each other through a fixed algorithm (toindex(), toaddress())
        address owner;                                  //  Offering owner
        bool deviate;                                   //  Whether it deviates 
        address tokenAddress;                           //  The erc20 contract address of the target offer token
        
        uint256 ethAmount;                              //  The ETH amount in the offer list
        uint256 tokenAmount;                            //  The token amount in the offer list
        
        uint256 dealEthAmount;                          //  The remaining number of tradable ETH
        uint256 dealTokenAmount;                        //  The remaining number of tradable tokens
        
        uint256 blockNum;                               //  The block number where the offer is located
        uint256 serviceCharge;                          //  The fee for mining
        // Determine whether the asset has been collected by judging that ethamount, tokenamount, and servicecharge are all 0
    }
    
    Nest_NToken_OfferPriceData [] _prices;                              //  Array used to save offers
    Nest_3_VoteFactory _voteFactory;                                    //  Voting contract
    Nest_3_OfferPrice _offerPrice;                                      //  Price contract
    Nest_NToken_TokenMapping _tokenMapping;                             //  NToken mapping contract
    ERC20 _nestToken;                                                   //  nestToken
    Nest_3_Abonus _abonus;                                              //  Bonus pool
    uint256 _miningETH = 10;                                            //  Offering mining fee ratio
    uint256 _tranEth = 1;                                               //  Taker fee ratio
    uint256 _tranAddition = 2;                                          //  Additional transaction multiple
    uint256 _leastEth = 10 ether;                                       //  Minimum offer of ETH
    uint256 _offerSpan = 10 ether;                                      //  ETH Offering span
    uint256 _deviate = 10;                                              //  Price deviation - 10%
    uint256 _deviationFromScale = 10;                                   //  Deviation from asset scale
    uint256 _ownerMining = 5;                                           //  Creator ratio
    uint256 _afterMiningAmount = 0.4 ether;                             //  Stable period mining amount
    uint32 _blockLimit = 25;                                            //  Block interval upper limit
    
    uint256 _blockAttenuation = 2400000;                                //  Block decay interval
    mapping(uint256 => mapping(address => uint256)) _blockOfferAmount;  //  Block offer times - block number=>token address=>offer fee
    mapping(uint256 => mapping(address => uint256)) _blockMining;       //  Offering block mining amount - block number=>token address=>mining amount
    uint256[10] _attenuationAmount;                                     //  Mining decay list
    
    //  Log token contract address
    event OFFERTOKENCONTRACTADDRESS732(address contractAddress);           	//inject NONSTANDARD NAMING
    //  Log offering contract, token address, amount of ETH, amount of ERC20, delayed block, mining fee
    event OFFERCONTRACTADDRESS317(address contractAddress, address tokenAddress, uint256 ethAmount, uint256 erc20Amount, uint256 continued,uint256 mining);         	//inject NONSTANDARD NAMING
    //  Log transaction sender, transaction token, transaction amount, purchase token address, purchase token amount, transaction offering contract address, transaction user address
    event OFFERTRAN368(address tranSender, address tranToken, uint256 tranAmount,address otherToken, uint256 otherAmount, address tradedContract, address tradedOwner);        	//inject NONSTANDARD NAMING
    //  Log current block, current block mined amount, token address
    event OREDRAWINGLOG324(uint256 nowBlock, uint256 blockAmount, address tokenAddress);	//inject NONSTANDARD NAMING
    //  Log offering block, token address, token offered times
    event MININGLOG206(uint256 blockNum, address tokenAddress, uint256 offerTimes);	//inject NONSTANDARD NAMING
    
                                                                                               
    constructor (address voteFactory) public {
        Nest_3_VoteFactory voteFactoryMap = Nest_3_VoteFactory(address(voteFactory));
        _voteFactory = voteFactoryMap;                                                                 
        _offerPrice = Nest_3_OfferPrice(address(voteFactoryMap.CHECKADDRESS430("nest.v3.offerPrice")));            
        _nestToken = ERC20(voteFactoryMap.CHECKADDRESS430("nest"));                                                          
        _abonus = Nest_3_Abonus(voteFactoryMap.CHECKADDRESS430("nest.v3.abonus"));
        _tokenMapping = Nest_NToken_TokenMapping(address(voteFactoryMap.CHECKADDRESS430("nest.nToken.tokenMapping")));
        
        uint256 blockAmount = 4 ether;
        for (uint256 i = 0; i < 10; i ++) {
            _attenuationAmount[i] = blockAmount;
            blockAmount = blockAmount.MUL982(8).DIV757(10);
        }
    }
    
                                                                                                      
    function CHANGEMAPPING259(address voteFactory) public ONLYOWNER202 {	//inject NONSTANDARD NAMING
        Nest_3_VoteFactory voteFactoryMap = Nest_3_VoteFactory(address(voteFactory));
        _voteFactory = voteFactoryMap;                                                          
        _offerPrice = Nest_3_OfferPrice(address(voteFactoryMap.CHECKADDRESS430("nest.v3.offerPrice")));      
        _nestToken = ERC20(voteFactoryMap.CHECKADDRESS430("nest"));                                                   
        _abonus = Nest_3_Abonus(voteFactoryMap.CHECKADDRESS430("nest.v3.abonus"));
        _tokenMapping = Nest_NToken_TokenMapping(address(voteFactoryMap.CHECKADDRESS430("nest.nToken.tokenMapping")));
    }
    
                                                                                                                                                                      
    function OFFER735(uint256 ethAmount, uint256 erc20Amount, address erc20Address) public payable {	//inject NONSTANDARD NAMING
        require(address(msg.sender) == address(tx.origin), "It can't be a contract");
        address nTokenAddress = _tokenMapping.CHECKTOKENMAPPING799(erc20Address);
        require(nTokenAddress != address(0x0));
        //  Judge whether the price deviates
        uint256 ethMining;
        bool isDeviate = COMPARATIVEPRICE616(ethAmount,erc20Amount,erc20Address);
        if (isDeviate) {
            require(ethAmount >= _leastEth.MUL982(_deviationFromScale), "EthAmount needs to be no less than 10 times of the minimum scale");
            ethMining = _leastEth.MUL982(_miningETH).DIV757(1000);
        } else {
            ethMining = ethAmount.MUL982(_miningETH).DIV757(1000);
        }
        require(msg.value >= ethAmount.ADD379(ethMining), "msg.value needs to be equal to the quoted eth quantity plus Mining handling fee");
        uint256 subValue = msg.value.SUB918(ethAmount.ADD379(ethMining));
        if (subValue > 0) {
            REPAYETH964(address(msg.sender), subValue);
        }
        //  Create an offer
        CREATEOFFER725(ethAmount, erc20Amount, erc20Address,isDeviate, ethMining);
        //  Transfer in offer asset - erc20 to this contract
        ERC20(erc20Address).SAFETRANSFERFROM181(address(msg.sender), address(this), erc20Amount);
        _abonus.SWITCHTOETHFORNTOKENOFFER869.value(ethMining)(nTokenAddress);
        //  Mining
        if (_blockOfferAmount[block.number][erc20Address] == 0) {
            uint256 miningAmount = OREDRAWING657(nTokenAddress);
            Nest_NToken nToken = Nest_NToken(nTokenAddress);
            nToken.TRANSFER16(nToken.CHECKBIDDER306(), miningAmount.MUL982(_ownerMining).DIV757(100));
            _blockMining[block.number][erc20Address] = miningAmount.SUB918(miningAmount.MUL982(_ownerMining).DIV757(100));
        }
        _blockOfferAmount[block.number][erc20Address] = _blockOfferAmount[block.number][erc20Address].ADD379(ethMining);
    }
    
                                                                                                                                                                                       
    function CREATEOFFER725(uint256 ethAmount, uint256 erc20Amount, address erc20Address, bool isDeviate, uint256 mining) private {	//inject NONSTANDARD NAMING
        // Check offer conditions
        require(ethAmount >= _leastEth, "Eth scale is smaller than the minimum scale");                                                 
        require(ethAmount % _offerSpan == 0, "Non compliant asset span");
        require(erc20Amount % (ethAmount.DIV757(_offerSpan)) == 0, "Asset quantity is not divided");
        require(erc20Amount > 0);
        // Create offering contract
        emit OFFERCONTRACTADDRESS317(TOADDRESS719(_prices.length), address(erc20Address), ethAmount, erc20Amount,_blockLimit,mining);
        _prices.push(Nest_NToken_OfferPriceData(
            msg.sender,
            isDeviate,
            erc20Address,
            
            ethAmount,
            erc20Amount,
            
            ethAmount, 
            erc20Amount, 
            
            block.number,
            mining
        ));
        // Record price
        _offerPrice.ADDPRICE894(ethAmount, erc20Amount, block.number.ADD379(_blockLimit), erc20Address, address(msg.sender));
    }
    
    // Convert offer address into index in offer array
    function TOINDEX783(address contractAddress) public pure returns(uint256) {	//inject NONSTANDARD NAMING
        return uint256(contractAddress);
    }
    
    // Convert index in offer array into offer address 
    function TOADDRESS719(uint256 index) public pure returns(address) {	//inject NONSTANDARD NAMING
        return address(index);
    }
    
                                                                                         
    function TURNOUT418(address contractAddress) public {	//inject NONSTANDARD NAMING
        require(address(msg.sender) == address(tx.origin), "It can't be a contract");
        uint256 index = TOINDEX783(contractAddress);
        Nest_NToken_OfferPriceData storage offerPriceData = _prices[index];
        require(CHECKCONTRACTSTATE995(offerPriceData.blockNum) == 1, "Offer status error");
        // Withdraw ETH
        if (offerPriceData.ethAmount > 0) {
            uint256 payEth = offerPriceData.ethAmount;
            offerPriceData.ethAmount = 0;
            REPAYETH964(offerPriceData.owner, payEth);
        }
        // Withdraw erc20
        if (offerPriceData.tokenAmount > 0) {
            uint256 payErc = offerPriceData.tokenAmount;
            offerPriceData.tokenAmount = 0;
            ERC20(address(offerPriceData.tokenAddress)).TRANSFER16(offerPriceData.owner, payErc);
            
        }
        // Mining settlement
        if (offerPriceData.serviceCharge > 0) {
            MINING254(offerPriceData.blockNum, offerPriceData.tokenAddress, offerPriceData.serviceCharge, offerPriceData.owner);
            offerPriceData.serviceCharge = 0;
        }
    }
    
                                                                                                                                                                                                                                                                                                                                                                                                                                
    function SENDETHBUYERC123(uint256 ethAmount, uint256 tokenAmount, address contractAddress, uint256 tranEthAmount, uint256 tranTokenAmount, address tranTokenAddress) public payable {	//inject NONSTANDARD NAMING
        require(address(msg.sender) == address(tx.origin), "It can't be a contract");
        uint256 serviceCharge = tranEthAmount.MUL982(_tranEth).DIV757(1000);
        require(msg.value == ethAmount.ADD379(tranEthAmount).ADD379(serviceCharge), "msg.value needs to be equal to the quotation eth quantity plus transaction eth plus");
        require(tranEthAmount % _offerSpan == 0, "Transaction size does not meet asset span");
        
        //  Get the offer data structure
        uint256 index = TOINDEX783(contractAddress);
        Nest_NToken_OfferPriceData memory offerPriceData = _prices[index]; 
        //  Check the price, compare the current offer to the last effective price
        bool thisDeviate = COMPARATIVEPRICE616(ethAmount,tokenAmount,tranTokenAddress);
        bool isDeviate;
        if (offerPriceData.deviate == true) {
            isDeviate = true;
        } else {
            isDeviate = thisDeviate;
        }
        //  Limit the taker order only be twice the amount of the offer to prevent large-amount attacks
        if (offerPriceData.deviate) {
            //  The taker order deviates  x2
            require(ethAmount >= tranEthAmount.MUL982(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
        } else {
            if (isDeviate) {
                //  If the taken offer is normal and the taker order deviates x10
                require(ethAmount >= tranEthAmount.MUL982(_deviationFromScale), "EthAmount needs to be no less than 10 times of transaction scale");
            } else {
                //  If the taken offer is normal and the taker order is normal x2
                require(ethAmount >= tranEthAmount.MUL982(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
            }
        }
        
        // Check whether the conditions for taker order are satisfied
        require(CHECKCONTRACTSTATE995(offerPriceData.blockNum) == 0, "Offer status error");
        require(offerPriceData.dealEthAmount >= tranEthAmount, "Insufficient trading eth");
        require(offerPriceData.dealTokenAmount >= tranTokenAmount, "Insufficient trading token");
        require(offerPriceData.tokenAddress == tranTokenAddress, "Wrong token address");
        require(tranTokenAmount == offerPriceData.dealTokenAmount * tranEthAmount / offerPriceData.dealEthAmount, "Wrong token amount");
        
        // Update the offer information
        offerPriceData.ethAmount = offerPriceData.ethAmount.ADD379(tranEthAmount);
        offerPriceData.tokenAmount = offerPriceData.tokenAmount.SUB918(tranTokenAmount);
        offerPriceData.dealEthAmount = offerPriceData.dealEthAmount.SUB918(tranEthAmount);
        offerPriceData.dealTokenAmount = offerPriceData.dealTokenAmount.SUB918(tranTokenAmount);
        _prices[index] = offerPriceData;
        // Create a new offer
        CREATEOFFER725(ethAmount, tokenAmount, tranTokenAddress, isDeviate, 0);
        // Transfer in erc20 + offer asset to this contract
        if (tokenAmount > tranTokenAmount) {
            ERC20(tranTokenAddress).SAFETRANSFERFROM181(address(msg.sender), address(this), tokenAmount.SUB918(tranTokenAmount));
        } else {
            ERC20(tranTokenAddress).SAFETRANSFER797(address(msg.sender), tranTokenAmount.SUB918(tokenAmount));
        }

        // Modify price
        _offerPrice.CHANGEPRICE820(tranEthAmount, tranTokenAmount, tranTokenAddress, offerPriceData.blockNum.ADD379(_blockLimit));
        emit OFFERTRAN368(address(msg.sender), address(0x0), tranEthAmount, address(tranTokenAddress), tranTokenAmount, contractAddress, offerPriceData.owner);
        
        // Transfer fee
        if (serviceCharge > 0) {
            address nTokenAddress = _tokenMapping.CHECKTOKENMAPPING799(tranTokenAddress);
            _abonus.SWITCHTOETH95.value(serviceCharge)(nTokenAddress);
        }
    }
    
                                                                                                                                                                                                                                                                                                                                                                                                                                
    function SENDERCBUYETH398(uint256 ethAmount, uint256 tokenAmount, address contractAddress, uint256 tranEthAmount, uint256 tranTokenAmount, address tranTokenAddress) public payable {	//inject NONSTANDARD NAMING
        require(address(msg.sender) == address(tx.origin), "It can't be a contract");
        uint256 serviceCharge = tranEthAmount.MUL982(_tranEth).DIV757(1000);
        require(msg.value == ethAmount.SUB918(tranEthAmount).ADD379(serviceCharge), "msg.value needs to be equal to the quoted eth quantity plus transaction handling fee");
        require(tranEthAmount % _offerSpan == 0, "Transaction size does not meet asset span");
        //  Get the offer data structure
        uint256 index = TOINDEX783(contractAddress);
        Nest_NToken_OfferPriceData memory offerPriceData = _prices[index]; 
        //  Check the price, compare the current offer to the last effective price
        bool thisDeviate = COMPARATIVEPRICE616(ethAmount,tokenAmount,tranTokenAddress);
        bool isDeviate;
        if (offerPriceData.deviate == true) {
            isDeviate = true;
        } else {
            isDeviate = thisDeviate;
        }
        //  Limit the taker order only be twice the amount of the offer to prevent large-amount attacks
        if (offerPriceData.deviate) {
            //  The taker order deviates  x2
            require(ethAmount >= tranEthAmount.MUL982(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
        } else {
            if (isDeviate) {
                //  If the taken offer is normal and the taker order deviates x10
                require(ethAmount >= tranEthAmount.MUL982(_deviationFromScale), "EthAmount needs to be no less than 10 times of transaction scale");
            } else {
                //  If the taken offer is normal and the taker order is normal x2
                require(ethAmount >= tranEthAmount.MUL982(_tranAddition), "EthAmount needs to be no less than 2 times of transaction scale");
            }
        }
        // Check whether the conditions for taker order are satisfied
        require(CHECKCONTRACTSTATE995(offerPriceData.blockNum) == 0, "Offer status error");
        require(offerPriceData.dealEthAmount >= tranEthAmount, "Insufficient trading eth");
        require(offerPriceData.dealTokenAmount >= tranTokenAmount, "Insufficient trading token");
        require(offerPriceData.tokenAddress == tranTokenAddress, "Wrong token address");
        require(tranTokenAmount == offerPriceData.dealTokenAmount * tranEthAmount / offerPriceData.dealEthAmount, "Wrong token amount");
        // Update the offer information
        offerPriceData.ethAmount = offerPriceData.ethAmount.SUB918(tranEthAmount);
        offerPriceData.tokenAmount = offerPriceData.tokenAmount.ADD379(tranTokenAmount);
        offerPriceData.dealEthAmount = offerPriceData.dealEthAmount.SUB918(tranEthAmount);
        offerPriceData.dealTokenAmount = offerPriceData.dealTokenAmount.SUB918(tranTokenAmount);
        _prices[index] = offerPriceData;
        // Create a new offer
        CREATEOFFER725(ethAmount, tokenAmount, tranTokenAddress, isDeviate, 0);
        // Transfer in erc20 + offer asset to this contract
        ERC20(tranTokenAddress).SAFETRANSFERFROM181(address(msg.sender), address(this), tranTokenAmount.ADD379(tokenAmount));
        // Modify price
        _offerPrice.CHANGEPRICE820(tranEthAmount, tranTokenAmount, tranTokenAddress, offerPriceData.blockNum.ADD379(_blockLimit));
        emit OFFERTRAN368(address(msg.sender), address(tranTokenAddress), tranTokenAmount, address(0x0), tranEthAmount, contractAddress, offerPriceData.owner);
        // Transfer fee
        if (serviceCharge > 0) {
            address nTokenAddress = _tokenMapping.CHECKTOKENMAPPING799(tranTokenAddress);
            _abonus.SWITCHTOETH95.value(serviceCharge)(nTokenAddress);
        }
    }
    
                                                                           
    function OREDRAWING657(address ntoken) private returns(uint256) {	//inject NONSTANDARD NAMING
        Nest_NToken miningToken = Nest_NToken(ntoken);
        (uint256 createBlock, uint256 recentlyUsedBlock) = miningToken.CHECKBLOCKINFO350();
        uint256 attenuationPointNow = block.number.SUB918(createBlock).DIV757(_blockAttenuation);
        uint256 miningAmount = 0;
        uint256 attenuation;
        if (attenuationPointNow > 9) {
            attenuation = _afterMiningAmount;
        } else {
            attenuation = _attenuationAmount[attenuationPointNow];
        }
        miningAmount = attenuation.MUL982(block.number.SUB918(recentlyUsedBlock));
        miningToken.INCREASETOTAL78(miningAmount);
        emit OREDRAWINGLOG324(block.number, miningAmount, ntoken);
        return miningAmount;
    }
    
                                                                         
    function MINING254(uint256 blockNum, address token, uint256 serviceCharge, address owner) private returns(uint256) {	//inject NONSTANDARD NAMING
        //  Block mining amount*offer fee/block offer fee
        uint256 miningAmount = _blockMining[blockNum][token].MUL982(serviceCharge).DIV757(_blockOfferAmount[blockNum][token]);        
        //  Transfer NToken 
        Nest_NToken nToken = Nest_NToken(address(_tokenMapping.CHECKTOKENMAPPING799(token)));
        require(nToken.TRANSFER16(address(owner), miningAmount), "Transfer failure");
        
        emit MININGLOG206(blockNum, token,_blockOfferAmount[blockNum][token]);
        return miningAmount;
    }
    
    // Compare order prices
    function COMPARATIVEPRICE616(uint256 myEthValue, uint256 myTokenValue, address token) private view returns(bool) {	//inject NONSTANDARD NAMING
        (uint256 frontEthValue, uint256 frontTokenValue) = _offerPrice.UPDATEANDCHECKPRICEPRIVATE349(token);
        if (frontEthValue == 0 || frontTokenValue == 0) {
            return false;
        }
        uint256 maxTokenAmount = myEthValue.MUL982(frontTokenValue).MUL982(uint256(100).ADD379(_deviate)).DIV757(frontEthValue.MUL982(100));
        if (myTokenValue <= maxTokenAmount) {
            uint256 minTokenAmount = myEthValue.MUL982(frontTokenValue).MUL982(uint256(100).SUB918(_deviate)).DIV757(frontEthValue.MUL982(100));
            if (myTokenValue >= minTokenAmount) {
                return false;
            }
        }
        return true;
    }
    
    // Check contract status
    function CHECKCONTRACTSTATE995(uint256 createBlock) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (block.number.SUB918(createBlock) > _blockLimit) {
            return 1;
        }
        return 0;
    }
    
    // Transfer ETH
    function REPAYETH964(address accountAddress, uint256 asset) private {	//inject NONSTANDARD NAMING
        address payable addr = accountAddress.MAKE_PAYABLE861();
        addr.transfer(asset);
    }
    
    // View the upper limit of the block interval
    function CHECKBLOCKLIMIT652() public view returns(uint256) {	//inject NONSTANDARD NAMING
        return _blockLimit;
    }
    
    // View taker fee ratio
    function CHECKTRANETH271() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _tranEth;
    }
    
    // View additional transaction multiple
    function CHECKTRANADDITION123() public view returns(uint256) {	//inject NONSTANDARD NAMING
        return _tranAddition;
    }
    
    // View minimum offering ETH
    function CHECKLEASTETH415() public view returns(uint256) {	//inject NONSTANDARD NAMING
        return _leastEth;
    }
    
    // View offering ETH span
    function CHECKOFFERSPAN954() public view returns(uint256) {	//inject NONSTANDARD NAMING
        return _offerSpan;
    }

    // View block offering amount
    function CHECKBLOCKOFFERAMOUNT357(uint256 blockNum, address token) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _blockOfferAmount[blockNum][token];
    }
    
    // View offering block mining amount
    function CHECKBLOCKMINING594(uint256 blockNum, address token) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _blockMining[blockNum][token];
    }
    
    // View offering mining amount
    function CHECKOFFERMINING245(uint256 blockNum, address token, uint256 serviceCharge) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (serviceCharge == 0) {
            return 0;
        } else {
            return _blockMining[blockNum][token].MUL982(serviceCharge).DIV757(_blockOfferAmount[blockNum][token]);
        }
    }
    
    //  View the owner allocation ratio
    function CHECKOWNERMINING462() public view returns(uint256) {	//inject NONSTANDARD NAMING
        return _ownerMining;
    }
    
    // View the mining decay
    function CHECKATTENUATIONAMOUNT848(uint256 num) public view returns(uint256) {	//inject NONSTANDARD NAMING
        return _attenuationAmount[num];
    }
    
    // Modify taker order fee ratio
    function CHANGETRANETH866(uint256 num) public ONLYOWNER202 {	//inject NONSTANDARD NAMING
        _tranEth = num;
    }
    
    // Modify block interval upper limit
    function CHANGEBLOCKLIMIT22(uint32 num) public ONLYOWNER202 {	//inject NONSTANDARD NAMING
        _blockLimit = num;
    }
    
    // Modify additional transaction multiple
    function CHANGETRANADDITION884(uint256 num) public ONLYOWNER202 {	//inject NONSTANDARD NAMING
        require(num > 0, "Parameter needs to be greater than 0");
        _tranAddition = num;
    }
    
    // Modify minimum offering ETH
    function CHANGELEASTETH405(uint256 num) public ONLYOWNER202 {	//inject NONSTANDARD NAMING
        require(num > 0, "Parameter needs to be greater than 0");
        _leastEth = num;
    }
    
    // Modify offering ETH span
    function CHANGEOFFERSPAN492(uint256 num) public ONLYOWNER202 {	//inject NONSTANDARD NAMING
        require(num > 0, "Parameter needs to be greater than 0");
        _offerSpan = num;
    }
    
    // Modify price deviation
    function CHANGEKDEVIATE724(uint256 num) public ONLYOWNER202 {	//inject NONSTANDARD NAMING
        _deviate = num;
    }
    
    // Modify the deviation from scale 
    function CHANGEDEVIATIONFROMSCALE300(uint256 num) public ONLYOWNER202 {	//inject NONSTANDARD NAMING
        _deviationFromScale = num;
    }
    
    // Modify the owner allocation ratio
    function CHANGEOWNERMINING351(uint256 num) public ONLYOWNER202 {	//inject NONSTANDARD NAMING
        _ownerMining = num;
    }
    
    // Modify the mining decay
    function CHANGEATTENUATIONAMOUNT1(uint256 firstAmount, uint256 top, uint256 bottom) public ONLYOWNER202 {	//inject NONSTANDARD NAMING
        uint256 blockAmount = firstAmount;
        for (uint256 i = 0; i < 10; i ++) {
            _attenuationAmount[i] = blockAmount;
            blockAmount = blockAmount.MUL982(top).DIV757(bottom);
        }
    }
    
    // Vote administrators only
    modifier ONLYOWNER202(){	//inject NONSTANDARD NAMING
        require(_voteFactory.CHECKOWNERS558(msg.sender), "No authority");
        _;
    }
    
                                                                                                                                        
    function GETPRICECOUNT52() view public returns (uint256) {	//inject NONSTANDARD NAMING
        return _prices.length;
    }
    
                                                                                                                                          
    function GETPRICE258(uint256 priceIndex) view public returns (string memory) {	//inject NONSTANDARD NAMING
        //  The buffer array used to generate the result string
        bytes memory buf = new bytes(500000);
        uint256 index = 0;
        index = WRITEOFFERPRICEDATA490(priceIndex, _prices[priceIndex], buf, index);
        // Generate the result string and return
        bytes memory str = new bytes(index);
        while(index-- > 0) {
            str[index] = buf[index];
        }
        return string(str);
    }
    
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function FIND608(address start, uint256 count, uint256 maxFindCount, address owner) view public returns (string memory) {	//inject NONSTANDARD NAMING
        // Buffer array used to generate result string
        bytes memory buf = new bytes(500000);
        uint256 index = 0;
        // Calculate search interval i and end
        uint256 i = _prices.length;
        uint256 end = 0;
        if (start != address(0)) {
            i = TOINDEX783(start);
        }
        if (i > maxFindCount) {
            end = i - maxFindCount;
        }
        // Loop search, write qualified records into buffer
        while (count > 0 && i-- > end) {
            Nest_NToken_OfferPriceData memory price = _prices[i];
            if (price.owner == owner) {
                --count;
                index = WRITEOFFERPRICEDATA490(i, price, buf, index);
            }
        }
        // Generate result string and return
        bytes memory str = new bytes(index);
        while(index-- > 0) {
            str[index] = buf[index];
        }
        return string(str);
    }
    
                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function LIST901(uint256 offset, uint256 count, uint256 order) view public returns (string memory) {	//inject NONSTANDARD NAMING
        
        // Buffer array used to generate result string 
        bytes memory buf = new bytes(500000);
        uint256 index = 0;
        
        // Find search interval i and end
        uint256 i = 0;
        uint256 end = 0;
        
        if (order == 0) {
            // Reverse order, in default 
            // Calculate search interval i and end
            if (offset < _prices.length) {
                i = _prices.length - offset;
            } 
            if (count < i) {
                end = i - count;
            }
            
            // Write records in the target interval into the buffer
            while (i-- > end) {
                index = WRITEOFFERPRICEDATA490(i, _prices[i], buf, index);
            }
        } else {
            // Ascending order
            // Calculate the search interval i and end
            if (offset < _prices.length) {
                i = offset;
            } else {
                i = _prices.length;
            }
            end = i + count;
            if(end > _prices.length) {
                end = _prices.length;
            }
            
            // Write the records in the target interval into the buffer
            while (i < end) {
                index = WRITEOFFERPRICEDATA490(i, _prices[i], buf, index);
                ++i;
            }
        }
        
        // Generate the result string and return
        bytes memory str = new bytes(index);
        while(index-- > 0) {
            str[index] = buf[index];
        }
        return string(str);
    }   
     
    // Write the offer data into the buffer and return the buffer index
    function WRITEOFFERPRICEDATA490(uint256 priceIndex, Nest_NToken_OfferPriceData memory price, bytes memory buf, uint256 index) pure private returns (uint256) {	//inject NONSTANDARD NAMING
        
        index = WRITEADDRESS338(TOADDRESS719(priceIndex), buf, index);
        buf[index++] = byte(uint8(44));
        
        index = WRITEADDRESS338(price.owner, buf, index);
        buf[index++] = byte(uint8(44));
        
        index = WRITEADDRESS338(price.tokenAddress, buf, index);
        buf[index++] = byte(uint8(44));
        
        index = WRITEUINT859(price.ethAmount, buf, index);
        buf[index++] = byte(uint8(44));
        
        index = WRITEUINT859(price.tokenAmount, buf, index);
        buf[index++] = byte(uint8(44));
       
        index = WRITEUINT859(price.dealEthAmount, buf, index);
        buf[index++] = byte(uint8(44));
        
        index = WRITEUINT859(price.dealTokenAmount, buf, index);
        buf[index++] = byte(uint8(44));
        
        index = WRITEUINT859(price.blockNum, buf, index);
        buf[index++] = byte(uint8(44));
        
        index = WRITEUINT859(price.serviceCharge, buf, index);
        buf[index++] = byte(uint8(44));
        
        return index;
    }
     
    // Convert integer to string in decimal form, write the string into the buffer, and return the buffer index
    function WRITEUINT859(uint256 iv, bytes memory buf, uint256 index) pure public returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 i = index;
        do {
            buf[index++] = byte(uint8(iv % 10 +48));
            iv /= 10;
        } while (iv > 0);
        
        for (uint256 j = index; j > i; ++i) {
            byte t = buf[i];
            buf[i] = buf[--j];
            buf[j] = t;
        }
        
        return index;
    }

    // Convert the address to a hexadecimal string and write it into the buffer, and return the buffer index
    function WRITEADDRESS338(address addr, bytes memory buf, uint256 index) pure private returns (uint256) {	//inject NONSTANDARD NAMING
        
        uint256 iv = uint256(addr);
        uint256 i = index + 40;
        do {
            uint256 w = iv % 16;
            if(w < 10) {
                buf[index++] = byte(uint8(w +48));
            } else {
                buf[index++] = byte(uint8(w +87));
            }
            
            iv /= 16;
        } while (index < i);
        
        i -= 40;
        for (uint256 j = index; j > i; ++i) {
            byte t = buf[i];
            buf[i] = buf[--j];
            buf[j] = t;
        }
        
        return index;
    }
}

// Price contract
interface Nest_3_OfferPrice {
    // Add price data
    function ADDPRICE894(uint256 ethAmount, uint256 tokenAmount, uint256 endBlock, address tokenAddress, address offerOwner) external;	//inject NONSTANDARD NAMING
    // Modify price
    function CHANGEPRICE820(uint256 ethAmount, uint256 tokenAmount, address tokenAddress, uint256 endBlock) external;	//inject NONSTANDARD NAMING
    function UPDATEANDCHECKPRICEPRIVATE349(address tokenAddress) external view returns(uint256 ethAmount, uint256 erc20Amount);	//inject NONSTANDARD NAMING
}

// Voting contract
interface Nest_3_VoteFactory {
    //  Check address
	function CHECKADDRESS430(string calldata name) external view returns (address contractAddress);	//inject NONSTANDARD NAMING
	// Check whether an administrator
	function CHECKOWNERS558(address man) external view returns (bool);	//inject NONSTANDARD NAMING
}

// NToken contract
interface Nest_NToken {
    // Additional issuance
    function INCREASETOTAL78(uint256 value) external;	//inject NONSTANDARD NAMING
    // Check mining information
    function CHECKBLOCKINFO350() external view returns(uint256 createBlock, uint256 recentlyUsedBlock);	//inject NONSTANDARD NAMING
    // Check creator
    function CHECKBIDDER306() external view returns(address);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY249() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF133(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER16(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE798(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function APPROVE147(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM462(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER56(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL26(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// NToken mapping contract
interface Nest_NToken_TokenMapping {
    // Check token mapping
    function CHECKTOKENMAPPING799(address token) external view returns (address);	//inject NONSTANDARD NAMING
}

// Bonus pool contract
interface Nest_3_Abonus {
    function SWITCHTOETH95(address token) external payable;	//inject NONSTANDARD NAMING
    function SWITCHTOETHFORNTOKENOFFER869(address token) external payable;	//inject NONSTANDARD NAMING
}

library SafeMath {
    function ADD379(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function SUB918(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB918(a, b, "SafeMath: subtraction overflow");
    }
    function SUB918(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function MUL982(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function DIV757(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV757(a, b, "SafeMath: division by zero");
    }
    function DIV757(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    function MOD863(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD863(a, b, "SafeMath: modulo by zero");
    }
    function MOD863(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

library address_make_payable {
   function MAKE_PAYABLE861(address x) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
      return address(uint160(x));
   }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER797(ERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN10(token, abi.encodeWithSelector(token.TRANSFER16.selector, to, value));
    }

    function SAFETRANSFERFROM181(ERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN10(token, abi.encodeWithSelector(token.TRANSFERFROM462.selector, from, to, value));
    }

    function SAFEAPPROVE632(ERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require((value == 0) || (token.ALLOWANCE798(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN10(token, abi.encodeWithSelector(token.APPROVE147.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE243(ERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE798(address(this), spender).ADD379(value);
        CALLOPTIONALRETURN10(token, abi.encodeWithSelector(token.APPROVE147.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE715(ERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE798(address(this), spender).SUB918(value, "SafeERC20: decreased allowance below zero");
        CALLOPTIONALRETURN10(token, abi.encodeWithSelector(token.APPROVE147.selector, spender, newAllowance));
    }
    function CALLOPTIONALRETURN10(ERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        require(address(token).ISCONTRACT477(), "SafeERC20: call to non-contract");
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface ERC20 {
    function TOTALSUPPLY249() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF133(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER16(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE798(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function APPROVE147(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM462(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER56(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL26(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

library Address {
    function ISCONTRACT477(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }
    function SENDVALUE528(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}