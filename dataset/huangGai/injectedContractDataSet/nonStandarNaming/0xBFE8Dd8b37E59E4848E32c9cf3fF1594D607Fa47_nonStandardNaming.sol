                                                                 

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;


                                                                                                                                                                                                                 
interface ICore {
                                                                                                              
    function TRANSFERPROXY290()	//inject NONSTANDARD NAMING
        external
        view
        returns (address);

                                                                                              
    function VAULT497()	//inject NONSTANDARD NAMING
        external
        view
        returns (address);

                                                                                                                                                                                                     
    function EXCHANGEIDS396(	//inject NONSTANDARD NAMING
        uint8 _exchangeId
    )
        external
        view
        returns (address);

                                                                                                                                       
    function VALIDSETS319(address)	//inject NONSTANDARD NAMING
        external
        view
        returns (bool);

                                                                                                           
    function VALIDMODULES100(address)	//inject NONSTANDARD NAMING
        external
        view
        returns (bool);

                                                                                                                                                                                                                                        
    function VALIDPRICELIBRARIES391(	//inject NONSTANDARD NAMING
        address _priceLibrary
    )
        external
        view
        returns (bool);

                                                                                                                                                                            
    function ISSUE203(	//inject NONSTANDARD NAMING
        address _set,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                                                                                               
    function ISSUETO740(	//inject NONSTANDARD NAMING
        address _recipient,
        address _set,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                               
    function ISSUEINVAULT15(	//inject NONSTANDARD NAMING
        address _set,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                
    function REDEEM524(	//inject NONSTANDARD NAMING
        address _set,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                                                                        
    function REDEEMTO270(	//inject NONSTANDARD NAMING
        address _recipient,
        address _set,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                              
    function REDEEMINVAULT358(	//inject NONSTANDARD NAMING
        address _set,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function REDEEMANDWITHDRAWTO873(	//inject NONSTANDARD NAMING
        address _set,
        address _to,
        uint256 _quantity,
        uint256 _toExclude
    )
        external;

                                                                                                                                                                                                                                                                                                                  
    function BATCHDEPOSIT892(	//inject NONSTANDARD NAMING
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external;

                                                                                                                                                                                                                                                                                                                        
    function BATCHWITHDRAW872(	//inject NONSTANDARD NAMING
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external;

                                                                                                                                                                                                           
    function DEPOSIT357(	//inject NONSTANDARD NAMING
        address _token,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                           
    function WITHDRAW715(	//inject NONSTANDARD NAMING
        address _token,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                                                                                                             
    function INTERNALTRANSFER147(	//inject NONSTANDARD NAMING
        address _token,
        address _to,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    function CREATESET426(	//inject NONSTANDARD NAMING
        address _factory,
        address[] calldata _components,
        uint256[] calldata _units,
        uint256 _naturalUnit,
        bytes32 _name,
        bytes32 _symbol,
        bytes calldata _callData
    )
        external
        returns (address);

                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function DEPOSITMODULE827(	//inject NONSTANDARD NAMING
        address _from,
        address _to,
        address _token,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function WITHDRAWMODULE670(	//inject NONSTANDARD NAMING
        address _from,
        address _to,
        address _token,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function BATCHDEPOSITMODULE88(	//inject NONSTANDARD NAMING
        address _from,
        address _to,
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function BATCHWITHDRAWMODULE533(	//inject NONSTANDARD NAMING
        address _from,
        address _to,
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                           
    function ISSUEMODULE367(	//inject NONSTANDARD NAMING
        address _owner,
        address _recipient,
        address _set,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                                                                          
    function REDEEMMODULE605(	//inject NONSTANDARD NAMING
        address _burnAddress,
        address _incrementAddress,
        address _set,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                                                                                                                
    function BATCHINCREMENTTOKENOWNERMODULE149(	//inject NONSTANDARD NAMING
        address[] calldata _tokens,
        address _owner,
        uint256[] calldata _quantities
    )
        external;

                                                                                                                                                                                                                                                                                                                                                    
    function BATCHDECREMENTTOKENOWNERMODULE440(	//inject NONSTANDARD NAMING
        address[] calldata _tokens,
        address _owner,
        uint256[] calldata _quantities
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                                                                               
    function BATCHTRANSFERBALANCEMODULE930(	//inject NONSTANDARD NAMING
        address[] calldata _tokens,
        address _from,
        address _to,
        uint256[] calldata _quantities
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                                                
    function TRANSFERMODULE315(	//inject NONSTANDARD NAMING
        address _token,
        uint256 _quantity,
        address _from,
        address _to
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                                                           
    function BATCHTRANSFERMODULE23(	//inject NONSTANDARD NAMING
        address[] calldata _tokens,
        uint256[] calldata _quantities,
        address _from,
        address _to
    )
        external;
}

// File: set-protocol-contracts/contracts/core/lib/RebalancingLibrary.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;


                                                                                                                                                                                                                             
library RebalancingLibrary {

                                         

    enum State { Default, Proposal, Rebalance, Drawdown }

                                           

    struct AuctionPriceParameters {
        uint256 auctionStartTime;
        uint256 auctionTimeToPivot;
        uint256 auctionStartPrice;
        uint256 auctionPivotPrice;
    }

    struct BiddingParameters {
        uint256 minimumBid;
        uint256 remainingCurrentSets;
        uint256[] combinedCurrentUnits;
        uint256[] combinedNextSetUnits;
        address[] combinedTokenArray;
    }
}

// File: set-protocol-contracts/contracts/core/interfaces/IFeeCalculator.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;

                                                           
interface IFeeCalculator {

                                                      

    function INITIALIZE627(	//inject NONSTANDARD NAMING
        bytes calldata _feeCalculatorData
    )
        external;

    function GETFEE645()	//inject NONSTANDARD NAMING
        external
        view
        returns(uint256);

    function UPDATEANDGETFEE787()	//inject NONSTANDARD NAMING
        external
        returns(uint256);

    function ADJUSTFEE487(	//inject NONSTANDARD NAMING
        bytes calldata _newFeeData
    )
        external;
}

// File: set-protocol-contracts/contracts/core/interfaces/ISetToken.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;

                                                                                                                                                                                          
interface ISetToken {

                                                      

                                                                                                      
    function NATURALUNIT908()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                          
    function GETCOMPONENTS458()	//inject NONSTANDARD NAMING
        external
        view
        returns (address[] memory);

                                                                                                                
    function GETUNITS229()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256[] memory);

                                                                                                                                                                                                             
    function TOKENISCOMPONENT45(	//inject NONSTANDARD NAMING
        address _tokenAddress
    )
        external
        view
        returns (bool);

                                                                                                                                                                                                                                                      
    function MINT918(	//inject NONSTANDARD NAMING
        address _issuer,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                     
    function BURN396(	//inject NONSTANDARD NAMING
        address _from,
        uint256 _quantity
    )
        external;

                                                                                                                                                              
    function TRANSFER558(	//inject NONSTANDARD NAMING
        address to,
        uint256 value
    )
        external;
}

// File: set-protocol-contracts/contracts/core/interfaces/IRebalancingSetToken.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;


                                                                                                                                                                                                                           

interface IRebalancingSetToken {

                                                                                                                                                                              
    function AUCTIONLIBRARY983()	//inject NONSTANDARD NAMING
        external
        view
        returns (address);

                                                                                           
    function TOTALSUPPLY978()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                       
    function PROPOSALSTARTTIME533()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                 
    function LASTREBALANCETIMESTAMP491()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                       
    function REBALANCEINTERVAL619()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                                                
    function REBALANCESTATE812()	//inject NONSTANDARD NAMING
        external
        view
        returns (RebalancingLibrary.State);

                                                                                                                               
    function STARTINGCURRENTSETAMOUNT132()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                                                                                                              
    function BALANCEOF827(	//inject NONSTANDARD NAMING
        address owner
    )
        external
        view
        returns (uint256);

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function PROPOSE395(	//inject NONSTANDARD NAMING
        address _nextSet,
        address _auctionLibrary,
        uint256 _auctionTimeToPivot,
        uint256 _auctionStartPrice,
        uint256 _auctionPivotPrice
    )
        external;

                                                                                                      
    function NATURALUNIT908()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                                                            
    function CURRENTSET165()	//inject NONSTANDARD NAMING
        external
        view
        returns (address);

                                                                                                                                                                              
    function NEXTSET94()	//inject NONSTANDARD NAMING
        external
        view
        returns (address);

                                                                                                                                    
    function UNITSHARES97()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                                                                                                                                       
    function BURN396(	//inject NONSTANDARD NAMING
        address _from,
        uint256 _quantity
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function PLACEBID341(	//inject NONSTANDARD NAMING
        uint256 _quantity
    )
        external
        returns (address[] memory, uint256[] memory, uint256[] memory);

                                                                                                         
    function GETCOMBINEDTOKENARRAYLENGTH557()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                         
    function GETCOMBINEDTOKENARRAY587()	//inject NONSTANDARD NAMING
        external
        view
        returns (address[] memory);

                                                                                                                                   
    function GETFAILEDAUCTIONWITHDRAWCOMPONENTS419()	//inject NONSTANDARD NAMING
        external
        view
        returns (address[] memory);

                                                                                                                                                             
    function GETAUCTIONPRICEPARAMETERS272()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256[] memory);

                                                                                                                                                   
    function GETBIDDINGPARAMETERS33()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256[] memory);

                                                                                                                                                                                                                                                                                                                                                                                                                        
    function GETBIDPRICE601(	//inject NONSTANDARD NAMING
        uint256 _quantity
    )
        external
        view
        returns (uint256[] memory, uint256[] memory);

}

// File: set-protocol-contracts/contracts/core/lib/Rebalance.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;



                                                                                                         
library Rebalance {

    struct TokenFlow {
        address[] addresses;
        uint256[] inflow;
        uint256[] outflow;
    }

    function COMPOSETOKENFLOW703(	//inject NONSTANDARD NAMING
        address[] memory _addresses,
        uint256[] memory _inflow,
        uint256[] memory _outflow
    )
        internal
        pure
        returns(TokenFlow memory)
    {
        return TokenFlow({addresses: _addresses, inflow: _inflow, outflow: _outflow });
    }

    function DECOMPOSETOKENFLOW508(TokenFlow memory _tokenFlow)	//inject NONSTANDARD NAMING
        internal
        pure
        returns (address[] memory, uint256[] memory, uint256[] memory)
    {
        return (_tokenFlow.addresses, _tokenFlow.inflow, _tokenFlow.outflow);
    }

    function DECOMPOSETOKENFLOWTOBIDPRICE741(TokenFlow memory _tokenFlow)	//inject NONSTANDARD NAMING
        internal
        pure
        returns (uint256[] memory, uint256[] memory)
    {
        return (_tokenFlow.inflow, _tokenFlow.outflow);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function GETTOKENFLOWS792(	//inject NONSTANDARD NAMING
        IRebalancingSetToken _rebalancingSetToken,
        uint256 _quantity
    )
        internal
        view
        returns (address[] memory, uint256[] memory, uint256[] memory)
    {
        // Get token addresses
        address[] memory combinedTokenArray = _rebalancingSetToken.GETCOMBINEDTOKENARRAY587();

        // Get inflow and outflow arrays for the given bid quantity
        (
            uint256[] memory inflowArray,
            uint256[] memory outflowArray
        ) = _rebalancingSetToken.GETBIDPRICE601(_quantity);

        return (combinedTokenArray, inflowArray, outflowArray);
    }
}

// File: set-protocol-contracts/contracts/core/interfaces/ILiquidator.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;




                                                        
interface ILiquidator {

                                                      

    function STARTREBALANCE53(	//inject NONSTANDARD NAMING
        ISetToken _currentSet,
        ISetToken _nextSet,
        uint256 _startingCurrentSetQuantity,
        bytes calldata _liquidatorData
    )
        external;

    function GETBIDPRICE601(	//inject NONSTANDARD NAMING
        address _set,
        uint256 _quantity
    )
        external
        view
        returns (Rebalance.TokenFlow memory);

    function PLACEBID341(	//inject NONSTANDARD NAMING
        uint256 _quantity
    )
        external
        returns (Rebalance.TokenFlow memory);


    function SETTLEREBALANCE859()	//inject NONSTANDARD NAMING
        external;

    function ENDFAILEDREBALANCE906() external;	//inject NONSTANDARD NAMING

    // ----------------------------------------------------------------------
    // Auction Price
    // ----------------------------------------------------------------------

    function AUCTIONPRICEPARAMETERS855(address _set)	//inject NONSTANDARD NAMING
        external
        view
        returns (RebalancingLibrary.AuctionPriceParameters memory);

    // ----------------------------------------------------------------------
    // Auction
    // ----------------------------------------------------------------------

    function HASREBALANCEFAILED531(address _set) external view returns (bool);	//inject NONSTANDARD NAMING
    function MINIMUMBID335(address _set) external view returns (uint256);	//inject NONSTANDARD NAMING
    function STARTINGCURRENTSETS972(address _set) external view returns (uint256);	//inject NONSTANDARD NAMING
    function REMAININGCURRENTSETS800(address _set) external view returns (uint256);	//inject NONSTANDARD NAMING
    function GETCOMBINEDCURRENTSETUNITS997(address _set) external view returns (uint256[] memory);	//inject NONSTANDARD NAMING
    function GETCOMBINEDNEXTSETUNITS743(address _set) external view returns (uint256[] memory);	//inject NONSTANDARD NAMING
    function GETCOMBINEDTOKENARRAY587(address _set) external view returns (address[] memory);	//inject NONSTANDARD NAMING
}

// File: set-protocol-contracts/contracts/core/interfaces/IRebalancingSetTokenV2.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;





                                                                                                                                                                                                                                 

interface IRebalancingSetTokenV2 {

                                                                                           
    function TOTALSUPPLY978()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                            
    function LIQUIDATOR933()	//inject NONSTANDARD NAMING
        external
        view
        returns (ILiquidator);

                                                                                                                 
    function LASTREBALANCETIMESTAMP491()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                         
    function REBALANCESTARTTIME708()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                               
    function STARTINGCURRENTSETAMOUNT132()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                       
    function REBALANCEINTERVAL619()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                      
    function GETAUCTIONPRICEPARAMETERS272() external view returns (uint256[] memory);	//inject NONSTANDARD NAMING

                                                                                                                     
    function GETBIDDINGPARAMETERS33() external view returns (uint256[] memory);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    function REBALANCESTATE812()	//inject NONSTANDARD NAMING
        external
        view
        returns (RebalancingLibrary.State);

                                                                                                                                                                                                                              
    function BALANCEOF827(	//inject NONSTANDARD NAMING
        address owner
    )
        external
        view
        returns (uint256);

                                                                                   
    function MANAGER161()	//inject NONSTANDARD NAMING
        external
        view
        returns (address);

                                                                                             
    function FEERECIPIENT200()	//inject NONSTANDARD NAMING
        external
        view
        returns (address);

                                                                                     
    function ENTRYFEE977()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                    
    function REBALANCEFEE979()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                          
    function REBALANCEFEECALCULATOR847()	//inject NONSTANDARD NAMING
        external
        view
        returns (IFeeCalculator);

                                                                                                          
    function INITIALIZE627(	//inject NONSTANDARD NAMING
        bytes calldata _rebalanceFeeCalldata
    )
        external;

                                                                                       
    function SETLIQUIDATOR462(	//inject NONSTANDARD NAMING
        ILiquidator _newLiquidator
    )
        external;

                                                    
    function SETFEERECIPIENT786(	//inject NONSTANDARD NAMING
        address _newFeeRecipient
    )
        external;

                                            
    function SETENTRYFEE61(	//inject NONSTANDARD NAMING
        uint256 _newEntryFee
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function STARTREBALANCE53(	//inject NONSTANDARD NAMING
        address _nextSet,
        bytes calldata _liquidatorData

    )
        external;

                                                                                                                                                                                                                                                                                                       
    function SETTLEREBALANCE859()	//inject NONSTANDARD NAMING
        external;

                                                                                                      
    function NATURALUNIT908()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                                                            
    function CURRENTSET165()	//inject NONSTANDARD NAMING
        external
        view
        returns (ISetToken);

                                                                                                                                                                              
    function NEXTSET94()	//inject NONSTANDARD NAMING
        external
        view
        returns (ISetToken);

                                                                                                                                    
    function UNITSHARES97()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function PLACEBID341(	//inject NONSTANDARD NAMING
        uint256 _quantity
    )
        external
        returns (address[] memory, uint256[] memory, uint256[] memory);

                                                                                                                                                                                                                                                                                                                                                                                                                        
    function GETBIDPRICE601(	//inject NONSTANDARD NAMING
        uint256 _quantity
    )
        external
        view
        returns (uint256[] memory, uint256[] memory);

                                                                             
    function NAME118()	//inject NONSTANDARD NAMING
        external
        view
        returns (string memory);

                                                                                 
    function SYMBOL994()	//inject NONSTANDARD NAMING
        external
        view
        returns (string memory);
}

// File: set-protocol-contracts/contracts/core/interfaces/IRebalancingSetTokenV3.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;





                                                                                                                                                                                                                                 

interface IRebalancingSetTokenV3 {

                                                                                           
    function TOTALSUPPLY978()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                            
    function LIQUIDATOR933()	//inject NONSTANDARD NAMING
        external
        view
        returns (ILiquidator);

                                                                                                                 
    function LASTREBALANCETIMESTAMP491()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                         
    function REBALANCESTARTTIME708()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                               
    function STARTINGCURRENTSETAMOUNT132()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                       
    function REBALANCEINTERVAL619()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                      
    function GETAUCTIONPRICEPARAMETERS272() external view returns (uint256[] memory);	//inject NONSTANDARD NAMING

                                                                                                                     
    function GETBIDDINGPARAMETERS33() external view returns (uint256[] memory);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    function REBALANCESTATE812()	//inject NONSTANDARD NAMING
        external
        view
        returns (RebalancingLibrary.State);

                                                                                                                                                                                                                              
    function BALANCEOF827(	//inject NONSTANDARD NAMING
        address owner
    )
        external
        view
        returns (uint256);

                                                                                   
    function MANAGER161()	//inject NONSTANDARD NAMING
        external
        view
        returns (address);

                                                                                             
    function FEERECIPIENT200()	//inject NONSTANDARD NAMING
        external
        view
        returns (address);

                                                                                     
    function ENTRYFEE977()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                    
    function REBALANCEFEE979()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                          
    function REBALANCEFEECALCULATOR847()	//inject NONSTANDARD NAMING
        external
        view
        returns (IFeeCalculator);

                                                                                                          
    function INITIALIZE627(	//inject NONSTANDARD NAMING
        bytes calldata _rebalanceFeeCalldata
    )
        external;

                                                                                       
    function SETLIQUIDATOR462(	//inject NONSTANDARD NAMING
        ILiquidator _newLiquidator
    )
        external;

                                                    
    function SETFEERECIPIENT786(	//inject NONSTANDARD NAMING
        address _newFeeRecipient
    )
        external;

                                            
    function SETENTRYFEE61(	//inject NONSTANDARD NAMING
        uint256 _newEntryFee
    )
        external;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function STARTREBALANCE53(	//inject NONSTANDARD NAMING
        address _nextSet,
        bytes calldata _liquidatorData

    )
        external;

                                                                                                                                                                                                                                                                                                       
    function SETTLEREBALANCE859()	//inject NONSTANDARD NAMING
        external;

                                                                                                                                                                                                                                                                                                                                                     
    function ACTUALIZEFEE454()	//inject NONSTANDARD NAMING
        external;

                                                                                                                                                  
    function ADJUSTFEE487(	//inject NONSTANDARD NAMING
        bytes calldata _newFeeData
    )
        external;

                                                                                                      
    function NATURALUNIT908()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                                                            
    function CURRENTSET165()	//inject NONSTANDARD NAMING
        external
        view
        returns (ISetToken);

                                                                                                                                                                              
    function NEXTSET94()	//inject NONSTANDARD NAMING
        external
        view
        returns (ISetToken);

                                                                                                                                    
    function UNITSHARES97()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function PLACEBID341(	//inject NONSTANDARD NAMING
        uint256 _quantity
    )
        external
        returns (address[] memory, uint256[] memory, uint256[] memory);

                                                                                                                                                                                                                                                                                                                                                                                                                        
    function GETBIDPRICE601(	//inject NONSTANDARD NAMING
        uint256 _quantity
    )
        external
        view
        returns (uint256[] memory, uint256[] memory);

                                                                             
    function NAME118()	//inject NONSTANDARD NAMING
        external
        view
        returns (string memory);

                                                                                 
    function SYMBOL994()	//inject NONSTANDARD NAMING
        external
        view
        returns (string memory);
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.2;

                                                                                                   
library SafeMath {
                                                                                  
    function MUL940(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

                                                                                                                           
    function DIV983(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                              
    function SUB806(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

                                                                            
    function ADD949(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

                                                                                                                                                    
    function MOD276(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.5.2;

                                                                                                                                                                                             
contract Ownable {
    address private _owner;

    event OWNERSHIPTRANSFERRED84(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                                                           
    constructor () internal {
        _owner = msg.sender;
        emit OWNERSHIPTRANSFERRED84(address(0), _owner);
    }

                                                        
    function OWNER334() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER733() {	//inject NONSTANDARD NAMING
        require(ISOWNER347());
        _;
    }

                                                                                 
    function ISOWNER347() public view returns (bool) {	//inject NONSTANDARD NAMING
        return msg.sender == _owner;
    }

                                                                                                                                                                                                                                                                                                                                                           
    function RENOUNCEOWNERSHIP178() public ONLYOWNER733 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED84(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                                                    
    function TRANSFEROWNERSHIP217(address newOwner) public ONLYOWNER733 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP828(newOwner);
    }

                                                                                                                                         
    function _TRANSFEROWNERSHIP828(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0));
        emit OWNERSHIPTRANSFERRED84(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: set-protocol-contracts/contracts/lib/TimeLockUpgrade.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;




                                                                                                                                                         
contract TimeLockUpgrade is
    Ownable
{
    using SafeMath for uint256;

                                                   

    // Timelock Upgrade Period in seconds
    uint256 public timeLockPeriod;

    // Mapping of upgradable units and initialized timelock
    mapping(bytes32 => uint256) public timeLockedUpgrades;

                                          

    event UPGRADEREGISTERED246(	//inject NONSTANDARD NAMING
        bytes32 _upgradeHash,
        uint256 _timestamp
    );

                                             

    modifier TIMELOCKUPGRADE701() {	//inject NONSTANDARD NAMING
        // If the time lock period is 0, then allow non-timebound upgrades.
        // This is useful for initialization of the protocol and for testing.
        if (timeLockPeriod == 0) {
            _;

            return;
        }

        // The upgrade hash is defined by the hash of the transaction call data,
        // which uniquely identifies the function as well as the passed in arguments.
        bytes32 upgradeHash = keccak256(
            abi.encodePacked(
                msg.data
            )
        );

        uint256 registrationTime = timeLockedUpgrades[upgradeHash];

        // If the upgrade hasn't been registered, register with the current time.
        if (registrationTime == 0) {
            timeLockedUpgrades[upgradeHash] = block.timestamp;

            emit UPGRADEREGISTERED246(
                upgradeHash,
                block.timestamp
            );

            return;
        }

        require(
            block.timestamp >= registrationTime.ADD949(timeLockPeriod),
            "TimeLockUpgrade: Time lock period must have elapsed."
        );

        // Reset the timestamp to 0
        timeLockedUpgrades[upgradeHash] = 0;

        // Run the rest of the upgrades
        _;
    }

                                            

                                                                                                                                                                                                                            
    function SETTIMELOCKPERIOD792(	//inject NONSTANDARD NAMING
        uint256 _timeLockPeriod
    )
        external
        ONLYOWNER733
    {
        // Only allow setting of the timeLockPeriod if the period is greater than the existing
        require(
            _timeLockPeriod > timeLockPeriod,
            "TimeLockUpgrade: New period must be greater than existing"
        );

        timeLockPeriod = _timeLockPeriod;
    }
}

// File: set-protocol-contracts/contracts/lib/UnrestrictedTimeLockUpgrade.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;




                                                                                                                                                                                                                                                                                                                                                                                                                              

contract UnrestrictedTimeLockUpgrade is
    TimeLockUpgrade
{
                                          

    event REMOVEREGISTEREDUPGRADE343(	//inject NONSTANDARD NAMING
        bytes32 indexed _upgradeHash
    );

                                                     

                                                                                                                                                                
    function REMOVEREGISTEREDUPGRADEINTERNAL162(	//inject NONSTANDARD NAMING
        bytes32 _upgradeHash
    )
        internal
    {
        require(
            timeLockedUpgrades[_upgradeHash] != 0,
            "TimeLockUpgradeV2.removeRegisteredUpgrade: Upgrade hash must be registered"
        );

        // Reset the timestamp to 0
        timeLockedUpgrades[_upgradeHash] = 0;

        emit REMOVEREGISTEREDUPGRADE343(
            _upgradeHash
        );
    }
}

// File: set-protocol-contracts/contracts/lib/LimitOneUpgrade.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;



                                                                                                                                                                                                                                         

contract LimitOneUpgrade is
    UnrestrictedTimeLockUpgrade
{
                                                   

    mapping(address => bytes32) public upgradeIdentifier;

                                            

                                                                                                                                                                                                   
    modifier LIMITONEUPGRADE170(address _upgradeAddress) {	//inject NONSTANDARD NAMING
        if (timeLockPeriod > 0) {
            // Get upgradeHash
            bytes32 upgradeHash = keccak256(msg.data);

            if (upgradeIdentifier[_upgradeAddress] != 0) {
                // If upgrade hash has no record then revert since must be second upgrade
                require(
                    upgradeIdentifier[_upgradeAddress] == upgradeHash,
                    "Another update already in progress."
                );

                upgradeIdentifier[_upgradeAddress] = 0;

            } else {
                upgradeIdentifier[_upgradeAddress] = upgradeHash;
            }
        }
        _;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                            
    function REMOVEREGISTEREDUPGRADEINTERNAL162(	//inject NONSTANDARD NAMING
        address _upgradeAddress,
        bytes32 _upgradeHash
    )
        internal
    {
        require(
            upgradeIdentifier[_upgradeAddress] == _upgradeHash,
            "Passed upgrade hash does not match upgrade address."
        );

        UnrestrictedTimeLockUpgrade.REMOVEREGISTEREDUPGRADEINTERNAL162(_upgradeHash);

        upgradeIdentifier[_upgradeAddress] = 0;
    }
}

// File: set-protocol-contracts/contracts/lib/AddressArrayUtils.sol

// Pulled in from Cryptofin Solidity package in order to control Solidity compiler version
// https://github.com/cryptofinlabs/cryptofin-solidity/blob/master/contracts/array-utils/AddressArrayUtils.sol

pragma solidity 0.5.7;


library AddressArrayUtils {

                                                                                                                                                                                                                                                       
    function INDEXOF640(address[] memory A, address a) internal pure returns (uint256, bool) {	//inject NONSTANDARD NAMING
        uint256 length = A.length;
        for (uint256 i = 0; i < length; i++) {
            if (A[i] == a) {
                return (i, true);
            }
        }
        return (0, false);
    }

                                                                                                                                                                                                                                                   
    function CONTAINS824(address[] memory A, address a) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        bool isIn;
        (, isIn) = INDEXOF640(A, a);
        return isIn;
    }

                                                                                                                                                                        
    function EXTEND286(address[] memory A, address[] memory B) internal pure returns (address[] memory) {	//inject NONSTANDARD NAMING
        uint256 aLength = A.length;
        uint256 bLength = B.length;
        address[] memory newAddresses = new address[](aLength + bLength);
        for (uint256 i = 0; i < aLength; i++) {
            newAddresses[i] = A[i];
        }
        for (uint256 j = 0; j < bLength; j++) {
            newAddresses[aLength + j] = B[j];
        }
        return newAddresses;
    }

                                                                                                                                                                         
    function APPEND631(address[] memory A, address a) internal pure returns (address[] memory) {	//inject NONSTANDARD NAMING
        address[] memory newAddresses = new address[](A.length + 1);
        for (uint256 i = 0; i < A.length; i++) {
            newAddresses[i] = A[i];
        }
        newAddresses[A.length] = a;
        return newAddresses;
    }

                                                                                                                                                                                                                                            
    function INTERSECT449(address[] memory A, address[] memory B) internal pure returns (address[] memory) {	//inject NONSTANDARD NAMING
        uint256 length = A.length;
        bool[] memory includeMap = new bool[](length);
        uint256 newLength = 0;
        for (uint256 i = 0; i < length; i++) {
            if (CONTAINS824(B, A[i])) {
                includeMap[i] = true;
                newLength++;
            }
        }
        address[] memory newAddresses = new address[](newLength);
        uint256 j = 0;
        for (uint256 k = 0; k < length; k++) {
            if (includeMap[k]) {
                newAddresses[j] = A[k];
                j++;
            }
        }
        return newAddresses;
    }

                                                                                                                                                                                                
    function UNION513(address[] memory A, address[] memory B) internal pure returns (address[] memory) {	//inject NONSTANDARD NAMING
        address[] memory leftDifference = DIFFERENCE589(A, B);
        address[] memory rightDifference = DIFFERENCE589(B, A);
        address[] memory intersection = INTERSECT449(A, B);
        return EXTEND286(leftDifference, EXTEND286(intersection, rightDifference));
    }

                                                                                                                                                                                                               
    function DIFFERENCE589(address[] memory A, address[] memory B) internal pure returns (address[] memory) {	//inject NONSTANDARD NAMING
        uint256 length = A.length;
        bool[] memory includeMap = new bool[](length);
        uint256 count = 0;
        // First count the new length because can't push for in-memory arrays
        for (uint256 i = 0; i < length; i++) {
            address e = A[i];
            if (!CONTAINS824(B, e)) {
                includeMap[i] = true;
                count++;
            }
        }
        address[] memory newAddresses = new address[](count);
        uint256 j = 0;
        for (uint256 k = 0; k < length; k++) {
            if (includeMap[k]) {
                newAddresses[j] = A[k];
                j++;
            }
        }
        return newAddresses;
    }

                                                                                                                                                            
    function POP272(address[] memory A, uint256 index)	//inject NONSTANDARD NAMING
        internal
        pure
        returns (address[] memory, address)
    {
        uint256 length = A.length;
        address[] memory newAddresses = new address[](length - 1);
        for (uint256 i = 0; i < index; i++) {
            newAddresses[i] = A[i];
        }
        for (uint256 j = index + 1; j < length; j++) {
            newAddresses[j - 1] = A[j];
        }
        return (newAddresses, A[index]);
    }

                                                    
    function REMOVE947(address[] memory A, address a)	//inject NONSTANDARD NAMING
        internal
        pure
        returns (address[] memory)
    {
        (uint256 index, bool isIn) = INDEXOF640(A, a);
        if (!isIn) {
            revert();
        } else {
            (address[] memory _A,) = POP272(A, index);
            return _A;
        }
    }

                                                                                                                                                                            
    function HASDUPLICATE629(address[] memory A) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        if (A.length == 0) {
            return false;
        }
        for (uint256 i = 0; i < A.length - 1; i++) {
            for (uint256 j = i + 1; j < A.length; j++) {
                if (A[i] == A[j]) {
                    return true;
                }
            }
        }
        return false;
    }

                                                                                                                                                                                            
    function ISEQUAL297(address[] memory A, address[] memory B) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        if (A.length != B.length) {
            return false;
        }
        for (uint256 i = 0; i < A.length; i++) {
            if (A[i] != B[i]) {
                return false;
            }
        }
        return true;
    }
}

// File: set-protocol-contracts/contracts/lib/WhiteList.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;





                                                                                         
contract WhiteList is
    Ownable,
    TimeLockUpgrade
{
    using AddressArrayUtils for address[];

                                                   

    address[] public addresses;
    mapping(address => bool) public whiteList;

                                          

    event ADDRESSADDED659(	//inject NONSTANDARD NAMING
        address _address
    );

    event ADDRESSREMOVED325(	//inject NONSTANDARD NAMING
        address _address
    );

                                               

                                                                                                                                                                                                                                                   
    constructor(
        address[] memory _initialAddresses
    )
        public
    {
        // Add each of initial addresses to state
        for (uint256 i = 0; i < _initialAddresses.length; i++) {
            address addressToAdd = _initialAddresses[i];

            addresses.push(addressToAdd);
            whiteList[addressToAdd] = true;
        }
    }

                                                      

                                                                                                                       
    function ADDADDRESS683(	//inject NONSTANDARD NAMING
        address _address
    )
        external
        ONLYOWNER733
        TIMELOCKUPGRADE701
    {
        require(
            !whiteList[_address],
            "WhiteList.addAddress: Address has already been whitelisted."
        );

        addresses.push(_address);

        whiteList[_address] = true;

        emit ADDRESSADDED659(
            _address
        );
    }

                                                                                                                                 
    function REMOVEADDRESS177(	//inject NONSTANDARD NAMING
        address _address
    )
        external
        ONLYOWNER733
    {
        require(
            whiteList[_address],
            "WhiteList.removeAddress: Address is not current whitelisted."
        );

        addresses = addresses.REMOVE947(_address);

        whiteList[_address] = false;

        emit ADDRESSREMOVED325(
            _address
        );
    }

                                                                                                                        
    function VALIDADDRESSES284()	//inject NONSTANDARD NAMING
        external
        view
        returns (address[] memory)
    {
        return addresses;
    }

                                                                                                                                                                                                                           
    function AREVALIDADDRESSES358(	//inject NONSTANDARD NAMING
        address[] calldata _addresses
    )
        external
        view
        returns (bool)
    {
        for (uint256 i = 0; i < _addresses.length; i++) {
            if (!whiteList[_addresses[i]]) {
                return false;
            }
        }

        return true;
    }
}

// File: contracts/managers/allocators/ISocialAllocator.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;


                                                                                                                         
interface ISocialAllocator {

                                                                                                                                                                                                                                                     
    function DETERMINENEWALLOCATION631(	//inject NONSTANDARD NAMING
        uint256 _targetBaseAssetAllocation
    )
        external
        returns (ISetToken);

                                                                                                                                                                                                                                    
    function CALCULATECOLLATERALSETVALUE480(	//inject NONSTANDARD NAMING
        ISetToken _collateralSet
    )
        external
        view
        returns(uint256);
}

// File: contracts/managers/lib/SocialTradingLibrary.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;



                                                                                                             
library SocialTradingLibrary {

                                           
    struct PoolInfo {
        address trader;                 // Address allowed to make admin and allocation decisions
        ISocialAllocator allocator;     // Allocator used to make collateral Sets, defines asset pair being used
        uint256 currentAllocation;      // Current base asset allocation of tradingPool
        uint256 newEntryFee;            // New fee percentage to change to after time lock passes, defaults to 0
        uint256 feeUpdateTimestamp;     // Timestamp when fee update process can be finalized, defaults to maxUint256
    }
}

// File: contracts/managers/SocialTradingManager.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;











                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
contract SocialTradingManager is
    WhiteList
{
    using SafeMath for uint256;

                                          

    event TRADINGPOOLCREATED990(	//inject NONSTANDARD NAMING
        address indexed trader,
        ISocialAllocator indexed allocator,
        address indexed tradingPool,
        uint256 startingAllocation
    );

    event ALLOCATIONUPDATE207(	//inject NONSTANDARD NAMING
        address indexed tradingPool,
        uint256 oldAllocation,
        uint256 newAllocation
    );

    event NEWTRADER325(	//inject NONSTANDARD NAMING
        address indexed tradingPool,
        address indexed oldTrader,
        address indexed newTrader
    );

                                            

    modifier ONLYTRADER541(IRebalancingSetTokenV2 _tradingPool) {	//inject NONSTANDARD NAMING
        require(
            msg.sender == TRADER685(_tradingPool),
            "Sender must be trader"
        );
        _;
    }

                                             

    uint256 public constant rebalancing_set_natural_unit564 = 1e8;	//inject NONSTANDARD NAMING
    uint public constant one_percent337 = 1e16;	//inject NONSTANDARD NAMING
    uint256 constant public maximum_allocation339 = 1e18;	//inject NONSTANDARD NAMING

                                                   

    ICore public core;
    address public factory;
    mapping(address => SocialTradingLibrary.PoolInfo) public pools;

    uint256 public maxEntryFee;
    uint256 public feeUpdateTimelock;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    constructor(
        ICore _core,
        address _factory,
        address[] memory _whiteListedAllocators,
        uint256 _maxEntryFee,
        uint256 _feeUpdateTimelock
    )
        public
        WhiteList(_whiteListedAllocators)
    {
        core = _core;
        factory = _factory;

        maxEntryFee = _maxEntryFee;
        feeUpdateTimelock = _feeUpdateTimelock;
    }

                                            

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function CREATETRADINGPOOL384(	//inject NONSTANDARD NAMING
        ISocialAllocator _tradingPairAllocator,
        uint256 _startingBaseAssetAllocation,
        uint256 _startingUSDValue,
        bytes32 _name,
        bytes32 _symbol,
        bytes calldata _rebalancingSetCallData
    )
        external
    {
        // Validate relevant params
        VALIDATECREATETRADINGPOOL868(_tradingPairAllocator, _startingBaseAssetAllocation, _rebalancingSetCallData);

        // Get collateral Set
        ISetToken collateralSet = _tradingPairAllocator.DETERMINENEWALLOCATION631(
            _startingBaseAssetAllocation
        );

        uint256[] memory unitShares = new uint256[](1);

        // Value collateral
        uint256 collateralValue = _tradingPairAllocator.CALCULATECOLLATERALSETVALUE480(
            collateralSet
        );

        // unitShares is equal to _startingUSDValue divided by colalteral Value
        unitShares[0] = _startingUSDValue.MUL940(rebalancing_set_natural_unit564).DIV983(collateralValue);

        address[] memory components = new address[](1);
        components[0] = address(collateralSet);

        // Create tradingPool
        address tradingPool = core.CREATESET426(
            factory,
            components,
            unitShares,
            rebalancing_set_natural_unit564,
            _name,
            _symbol,
            _rebalancingSetCallData
        );

        pools[tradingPool].trader = msg.sender;
        pools[tradingPool].allocator = _tradingPairAllocator;
        pools[tradingPool].currentAllocation = _startingBaseAssetAllocation;
        pools[tradingPool].feeUpdateTimestamp = 0;

        emit TRADINGPOOLCREATED990(
            msg.sender,
            _tradingPairAllocator,
            tradingPool,
            _startingBaseAssetAllocation
        );
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function UPDATEALLOCATION788(	//inject NONSTANDARD NAMING
        IRebalancingSetTokenV2 _tradingPool,
        uint256 _newAllocation,
        bytes calldata _liquidatorData
    )
        external
        ONLYTRADER541(_tradingPool)
    {
        // Validate updateAllocation params
        VALIDATEALLOCATIONUPDATE492(_tradingPool, _newAllocation);

        // Create nextSet collateral
        ISetToken nextSet = ALLOCATOR261(_tradingPool).DETERMINENEWALLOCATION631(
            _newAllocation
        );

        // Trigger start rebalance on RebalancingSetTokenV2
        _tradingPool.STARTREBALANCE53(address(nextSet), _liquidatorData);

        emit ALLOCATIONUPDATE207(
            address(_tradingPool),
            CURRENTALLOCATION387(_tradingPool),
            _newAllocation
        );

        // Save new allocation
        pools[address(_tradingPool)].currentAllocation = _newAllocation;
    }

                                                                                                                                                                                                                                                                                                                                  
    function INITIATEENTRYFEECHANGE772(	//inject NONSTANDARD NAMING
        IRebalancingSetTokenV2 _tradingPool,
        uint256 _newEntryFee
    )
        external
        ONLYTRADER541(_tradingPool)
    {
        // Validate new entry fee doesn't exceed max
        VALIDATENEWENTRYFEE141(_newEntryFee);

        // Log new entryFee and timestamp to start timelock from
        pools[address(_tradingPool)].feeUpdateTimestamp = block.timestamp.ADD949(feeUpdateTimelock);
        pools[address(_tradingPool)].newEntryFee = _newEntryFee;
    }

                                                                                                                                                                                                      
    function FINALIZEENTRYFEECHANGE511(	//inject NONSTANDARD NAMING
        IRebalancingSetTokenV2 _tradingPool
    )
        external
        ONLYTRADER541(_tradingPool)
    {
        // If feeUpdateTimestamp is equal to 0 indicates initiate wasn't called
        require(
            FEEUPDATETIMESTAMP466(_tradingPool) != 0,
            "SocialTradingManager.finalizeSetFeeRecipient: Must initiate fee change first."
        );

        // Current block timestamp must exceed feeUpdateTimestamp
        require(
            block.timestamp >= FEEUPDATETIMESTAMP466(_tradingPool),
            "SocialTradingManager.finalizeSetFeeRecipient: Time lock period must elapse to update fees."
        );

        // Reset timestamp to avoid reentrancy
        pools[address(_tradingPool)].feeUpdateTimestamp = 0;

        // Update fee on RebalancingSetTokenV2
        _tradingPool.SETENTRYFEE61(NEWENTRYFEE285(_tradingPool));

        // Reset newEntryFee
        pools[address(_tradingPool)].newEntryFee = 0;
    }

                                                                                                                                                                                                                   
    function SETTRADER910(	//inject NONSTANDARD NAMING
        IRebalancingSetTokenV2 _tradingPool,
        address _newTrader
    )
        external
        ONLYTRADER541(_tradingPool)
    {
        emit NEWTRADER325(
            address(_tradingPool),
            TRADER685(_tradingPool),
            _newTrader
        );

        pools[address(_tradingPool)].trader = _newTrader;
    }

                                                                                                                                                                                                               
    function SETLIQUIDATOR462(	//inject NONSTANDARD NAMING
        IRebalancingSetTokenV2 _tradingPool,
        ILiquidator _newLiquidator
    )
        external
        ONLYTRADER541(_tradingPool)
    {
        _tradingPool.SETLIQUIDATOR462(_newLiquidator);
    }

                                                                                                                                                                                                                    
    function SETFEERECIPIENT786(	//inject NONSTANDARD NAMING
        IRebalancingSetTokenV2 _tradingPool,
        address _newFeeRecipient
    )
        external
        ONLYTRADER541(_tradingPool)
    {
        _tradingPool.SETFEERECIPIENT786(_newFeeRecipient);
    }

                                            

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    function VALIDATECREATETRADINGPOOL868(	//inject NONSTANDARD NAMING
        ISocialAllocator _tradingPairAllocator,
        uint256 _startingBaseAssetAllocation,
        bytes memory _rebalancingSetCallData
    )
        internal
        view
    {
        VALIDATEALLOCATIONAMOUNT616(_startingBaseAssetAllocation);

        VALIDATEMANAGERADDRESS45(_rebalancingSetCallData);

        require(
            whiteList[address(_tradingPairAllocator)],
            "SocialTradingManager.validateCreateTradingPool: Passed allocator is not valid."
        );
    }

                                                                                                                                                                                                                                                                                                                                                                                                     
    function VALIDATEALLOCATIONUPDATE492(	//inject NONSTANDARD NAMING
        IRebalancingSetTokenV2 _tradingPool,
        uint256 _newAllocation
    )
        internal
        view
    {
        VALIDATEALLOCATIONAMOUNT616(_newAllocation);

        // If current allocation is 0/100%, cannot be the same allocation
        uint256 currentAllocationValue = CURRENTALLOCATION387(_tradingPool);
        require(
            !(currentAllocationValue == maximum_allocation339 && _newAllocation == maximum_allocation339) &&
            !(currentAllocationValue == 0 && _newAllocation == 0),
            "SocialTradingManager.validateAllocationUpdate: Invalid allocation"
        );

        // Require that enough time has passed from last rebalance
        uint256 lastRebalanceTimestamp = _tradingPool.LASTREBALANCETIMESTAMP491();
        uint256 rebalanceInterval = _tradingPool.REBALANCEINTERVAL619();
        require(
            block.timestamp >= lastRebalanceTimestamp.ADD949(rebalanceInterval),
            "SocialTradingManager.validateAllocationUpdate: Rebalance interval not elapsed"
        );

        // Require that Rebalancing Set Token is in Default state, won't allow for re-proposals
        // because malicious actor could prevent token from ever rebalancing
        require(
            _tradingPool.REBALANCESTATE812() == RebalancingLibrary.State.Default,
            "SocialTradingManager.validateAllocationUpdate: State must be in Default"
        );
    }

                                                                                                                                                                                                                                
    function VALIDATEALLOCATIONAMOUNT616(	//inject NONSTANDARD NAMING
        uint256 _allocation
    )
        internal
        view
    {
        require(
            _allocation <= maximum_allocation339,
            "Passed allocation must not exceed 100%."
        );

        require(
            _allocation.MOD276(one_percent337) == 0,
            "Passed allocation must be multiple of 1%."
        );
    }

                                                                                                                                                                                       
    function VALIDATENEWENTRYFEE141(	//inject NONSTANDARD NAMING
        uint256 _entryFee
    )
        internal
        view
    {
        require(
            _entryFee <= maxEntryFee,
            "SocialTradingManager.validateNewEntryFee: Passed entry fee must not exceed maxEntryFee."
        );
    }

                                                                                                                                                                                                                    
    function VALIDATEMANAGERADDRESS45(	//inject NONSTANDARD NAMING
        bytes memory _rebalancingSetCallData
    )
        internal
        view
    {
        address manager;

        assembly {
            manager := mload(add(_rebalancingSetCallData, 32))   // manager slot
        }

        require(
            manager == address(this),
            "SocialTradingManager.validateCallDataArgs: Passed manager address is not this address."
        );
    }

    function ALLOCATOR261(IRebalancingSetTokenV2 _tradingPool) internal view returns (ISocialAllocator) {	//inject NONSTANDARD NAMING
        return pools[address(_tradingPool)].allocator;
    }

    function TRADER685(IRebalancingSetTokenV2 _tradingPool) internal view returns (address) {	//inject NONSTANDARD NAMING
        return pools[address(_tradingPool)].trader;
    }

    function CURRENTALLOCATION387(IRebalancingSetTokenV2 _tradingPool) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return pools[address(_tradingPool)].currentAllocation;
    }

    function FEEUPDATETIMESTAMP466(IRebalancingSetTokenV2 _tradingPool) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return pools[address(_tradingPool)].feeUpdateTimestamp;
    }

    function NEWENTRYFEE285(IRebalancingSetTokenV2 _tradingPool) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return pools[address(_tradingPool)].newEntryFee;
    }
}

// File: contracts/managers/SocialTradingManagerV2.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.7;
pragma experimental "ABIEncoderV2";







                                                                                                                                                                                                                                                      
contract SocialTradingManagerV2 is
    SocialTradingManager,
    LimitOneUpgrade
{
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    constructor(
        ICore _core,
        address _factory,
        address[] memory _whiteListedAllocators,
        uint256 _maxEntryFee,
        uint256 _feeUpdateTimelock
    )
        public
        SocialTradingManager(
            _core,
            _factory,
            _whiteListedAllocators,
            _maxEntryFee,
            _feeUpdateTimelock
        )
    {}

                                            

                                                                                                                                                                                                                                                                                                         
    function ADJUSTFEE487(	//inject NONSTANDARD NAMING
        address _tradingPool,
        bytes calldata _newFeeCallData
    )
        external
        ONLYTRADER541(IRebalancingSetTokenV2(_tradingPool))
        LIMITONEUPGRADE170(_tradingPool)
        TIMELOCKUPGRADE701
    {
        IRebalancingSetTokenV3(_tradingPool).ADJUSTFEE487(_newFeeCallData);
    }

                                                                                                                                                                                                                                                                                                    
    function REMOVEREGISTEREDUPGRADE402(	//inject NONSTANDARD NAMING
        address _tradingPool,
        bytes32 _upgradeHash
    )
        external
        ONLYTRADER541(IRebalancingSetTokenV2(_tradingPool))
    {
        LimitOneUpgrade.REMOVEREGISTEREDUPGRADEINTERNAL162(_tradingPool, _upgradeHash);
    }
}