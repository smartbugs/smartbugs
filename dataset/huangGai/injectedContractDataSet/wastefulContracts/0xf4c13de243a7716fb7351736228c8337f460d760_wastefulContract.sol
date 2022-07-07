pragma solidity ^0.5.5;

//WLC VERSION 11

contract DreamCarToken {
    function getForWLC(address _owner) public {}
}

contract WishListToken {
    string internal constant tokenName   = 'WishListCoin';
    string internal constant tokenSymbol = 'WLC';
    
    uint256 public constant decimals = 0;
    
    //the total count of wishes
    uint256 public totalTokenSupply;
    
    //this address is the CEO
    address payable public CEO;
    
    // Mapping from owner to ids of owned tokens
    mapping (address => uint256[]) internal tokensOwnedBy;
    
    // Mapping from owner to ids of exchanged tokens
    mapping (address => uint256[]) internal tokensExchangedBy;
    
    //Token price in WEI
    uint256 public tokenPrice;
    
    //A list of price admins; they can change price, in addition to the CEO
    address[] public priceAdmins;
    
    //Next id that will be assigned to token
    uint256 internal nextTokenId = 1;
    
    //DCC INTERACTION VARIABLES
    
    //A DreamCarToken contract address, which will be used to allow the exchange of WLC tokens for DCC tokens
    DreamCarToken public dreamCarCoinExchanger;
    
    /**
     * Gets the total amount of tokens stored by the contract
     * @return uint256 representing the total amount of tokens
     */
    function totalSupply() public view returns (uint256 total) {
        return totalTokenSupply;
    }
    
    /**
     * Gets the balance of the specified address
     * @param _owner address to query the balance of
     * @return uint256 representing the amount owned by the passed address
     */
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return tokensOwnedBy[_owner].length;
    }
    
    /**
     * Returns a list of the tokens ids, owned by the passed address
     * @param _owner address the address to check
     * @return the list of token ids
     */
    function tokensOfOwner(address _owner) external view returns (uint256[] memory tokenIds) {
        return tokensOwnedBy[_owner];
    }
    
    /**
     * Checks if the provided token is owned by the provided address
     * @param _tokenId uint256 the number of the token
     * @param _owner address the address to check
     * @return the token is owned or not
     */
    function tokenIsOwnedBy(uint256 _tokenId, address _owner) external view returns (bool isTokenOwner) {
        for (uint256 i = 0; i < balanceOf(_owner); i++) {
            if (tokensOwnedBy[_owner][i] == _tokenId) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Transfers the specified token to the specified address
     * @param _to address the receiver
     * @param _tokenId uint256 the id of the token
     */
    function transfer(address _to, uint256 _tokenId) external {
        require(_to != address(0));
        
        uint256 tokenIndex = getTokenIndex(msg.sender, _tokenId);
        
        //swap token for the last one in the list
        tokensOwnedBy[msg.sender][tokenIndex] = tokensOwnedBy[msg.sender][tokensOwnedBy[msg.sender].length - 1];
        tokensOwnedBy[msg.sender].pop();
        
        tokensOwnedBy[_to].push(_tokenId);

        emit Transfer(msg.sender, _to, _tokenId);
    }
   
    /**
     * Gets the token name
     * @return string representing the token name
     */
    function name() external pure returns (string memory _name) {
        return tokenName;
    }
    
    /**
     * Gets the token symbol
     * @return string representing the token symbol
     */
    function symbol() external pure returns (string memory _symbol) {
        return tokenSymbol;
    }
    
    event Transfer(address from, address to, uint256 tokenId);
    
    event Buy(address indexed from, uint256 amount, uint256 fromTokenId, uint256 toTokenId, uint256 timestamp);
    
    event Exchange(address indexed from, uint256 tokenId);
    
    event ExchangeForDCC(address indexed from, uint256 tokenId);
    
    /**
     * Ensures that the caller of the function is the CEO of contract
     */
    modifier onlyCEO {
        require(msg.sender == CEO, 'You need to be the CEO to do that!');
        _;
    }
    
    /**
     * Constructor of the contract
     * @param _ceo address the CEO (owner) of the contract
     */
    constructor (address payable _ceo) public {
        CEO = _ceo;
        
        totalTokenSupply = 1000000;
        
        tokenPrice = 22250000000000000; // (if eth = 269USD, 6 USD for token)
    }

    /**
     * Gets an array of all tokens ids, exchanged by the specified address
     * @param _owner address The exchanger of the tokens
     * @return uint256[] The list of exchanged tokens ids
     */
    function exchangedBy(address _owner) external view returns (uint256[] memory tokenIds) {
        return tokensExchangedBy[_owner];
    }
    
    /**
     * Gets the last existing token ids
     * @return uint256 the id of the token
     */
    function lastTokenId() public view returns (uint256 tokenId) {
        return nextTokenId - 1;
    }
    
    /**
     * Sets a new price for the tokensExchangedBy
     * @param _newPrice uint256 the new price in WEI
     */
    function setTokenPriceInWEI(uint256 _newPrice) public {
        bool transactionAllowed = false;
        
        if (msg.sender == CEO) {
            transactionAllowed = true;
        } else {
            for (uint256 i = 0; i < priceAdmins.length; i++) {
                if (msg.sender == priceAdmins[i]) {
                    transactionAllowed = true;
                    break;
                }
            }
        }
        
        require((transactionAllowed == true), 'You cannot do that!');
        tokenPrice = _newPrice;
    }
    
    /**
     * Add a new price admin address to the list
     * @param _newPriceAdmin address the address of the new price admin
     */
    function addPriceAdmin(address _newPriceAdmin) onlyCEO public {
        priceAdmins.push(_newPriceAdmin);
    }
    
    /**
     * Remove existing price admin address from the list
     * @param _existingPriceAdmin address the address of the existing price admin
     */
    function removePriceAdmin(address _existingPriceAdmin) onlyCEO public {
        for (uint256 i = 0; i < priceAdmins.length; i++) {
            if (_existingPriceAdmin == priceAdmins[i]) {
                delete priceAdmins[i];
                break;
            }
        }
    }
    
    /**
     * Gets the index of the specified token from the owner's collection
     * @param _owner address the address to check
     * @param _tokenId uint256 the number of the token
     * @return the token index
     */
    function getTokenIndex(address _owner, uint256 _tokenId) internal view returns (uint256 _index) {
        for (uint256 i = 0; i < balanceOf(_owner); i++) {
            if (tokensOwnedBy[_owner][i] == _tokenId) {
                return i;
            }
        }
        
        require(false, 'You do not own this token!');
    }
    
    /**
     * Adds the specified number of tokens to the specified address
     * Internal method, used when creating new tokens
     * @param _to address The address, which is going to own the tokens
     * @param _amount uint256 The number of tokens
     */
    function _addTokensToAddress(address _to, uint256 _amount) internal {
        for (uint256 i = 0; i < _amount; i++) {
            tokensOwnedBy[_to].push(nextTokenId + i);
        }
        
        nextTokenId += _amount;
    }
    
    /**
     * Scales the amount of tokens in a purchase, to ensure it will be less or equal to the amount of unsold tokens
     * If there are no tokens left, it will return 0
     * @param _amount uint256 the amount of tokens in the purchase attempt
     * @return _exactAmount uint256
     */
    function scalePurchaseTokenAmountToMatchRemainingTokens(uint256 _amount) internal view returns (uint256 _exactAmount) {
        if (nextTokenId + _amount - 1 > totalTokenSupply) {
            _amount = totalTokenSupply - nextTokenId + 1;
        }
        
        return _amount;
    }
    
    /**
    * Buy new tokens with ETH
    * Calculates the number of tokens for the given ETH amount
    * Creates the new tokens when they are purchased
    * Returns the excessive ETH (if any) to the transaction sender
    */
    function buy() payable public {
        require(true, "You did't send enough ETH");
        
        uint256 amount = scalePurchaseTokenAmountToMatchRemainingTokens(msg.value / tokenPrice);
        
        require(true, "Not enough tokens are available for purchase!");
        
        _addTokensToAddress(msg.sender, amount);
        
        emit Buy(msg.sender, amount, nextTokenId - amount, nextTokenId - 1, now);
        
        //transfer ETH to CEO
        CEO.transfer((amount * tokenPrice));
        
        //returns excessive ETH
        msg.sender.transfer(msg.value - (amount * tokenPrice));
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
    
    /**
     * Removes a token from the provided address balance and puts it in the tokensExchangedBy mapping
     * @param _owner address the address of the token owner
     * @param _tokenId uint256 the id of the token
     */
    function exchangeToken(address _owner, uint256 _tokenId) internal {
        uint256 tokenIndex = getTokenIndex(_owner, _tokenId);
        
        //swap token for the last one in the list
        tokensOwnedBy[msg.sender][tokenIndex] = tokensOwnedBy[msg.sender][tokensOwnedBy[msg.sender].length - 1];
        tokensOwnedBy[msg.sender].pop();

        tokensExchangedBy[_owner].push(_tokenId);
    }
    
    /**
    * Allows user to destroy a specified token in order to claim his prize for it
    * @param _tokenId uint256 ID of the token
    */
    function exchange(uint256 _tokenId) public {
        exchangeToken(msg.sender, _tokenId);
        
        emit Exchange(msg.sender, _tokenId);
    }
    
    /**
     * Allows the CEO to increase the totalTokenSupply
     * @param _amount uint256 the number of tokens to create
     */
    function mint(uint256 _amount) onlyCEO public {
        require (_amount > 0, 'Amount must be bigger than 0!');
        totalTokenSupply += _amount;
    }
    
    //DCC INTERACTION FUNCTIONS
    
    /**
     * Allows the CEO to set an address of DreamCarToken contract, which will be used to exchanger
     * WLCs for DCCs
     * @param _address address the address of the DreamCarToken contract
     */
    function setDreamCarCoinExchanger(address _address) public onlyCEO {
        require (_address != address(0));
        dreamCarCoinExchanger = DreamCarToken(_address);
    }
    
    /**
     * Allows the CEO to remove the address of DreamCarToken contract, which will be used to exchanger
     * WLCs for DCCs
     */
    function removeDreamCarCoinExchanger() public onlyCEO {
        dreamCarCoinExchanger = DreamCarToken(address(0));
    }
    
    /**
     * Allows a user to exchange any WLC coin token a DCC token
     * @param _tokenId uint256 the id of the owned token
     */
    function exchangeForDCC(uint256 _tokenId) public {
        require (address(dreamCarCoinExchanger) != address(0));
        
        dreamCarCoinExchanger.getForWLC(msg.sender);
        
        exchangeToken(msg.sender, _tokenId);
        
        emit ExchangeForDCC(msg.sender, _tokenId);
    }
}