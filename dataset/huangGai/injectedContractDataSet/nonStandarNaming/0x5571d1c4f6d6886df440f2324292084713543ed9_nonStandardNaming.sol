                                                                 

pragma solidity ^0.5.16;

                                                                                                   
library SafeMath {
                                                                                
    function MUL808(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                         
    function DIV72(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                            
    function SUB229(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

                                                                          
    function ADD121(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

                                                                                                                                                 
    function MOD464(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}

                                                                                                                                                                                             
contract Ownable {
    address private _owner;

    event OWNERSHIPTRANSFERRED920(address previousOwner, address newOwner);	//inject NONSTANDARD NAMING

                                                                                                                           
    constructor () internal {
        _owner = msg.sender;
        emit OWNERSHIPTRANSFERRED920(address(0), _owner);
    }

                                                        
    function OWNER455() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER459() {	//inject NONSTANDARD NAMING
        require(ISOWNER595());
        _;
    }

                                                                                 
    function ISOWNER595() public view returns (bool) {	//inject NONSTANDARD NAMING
        return msg.sender == _owner;
    }

                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP898() public ONLYOWNER459 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED920(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                                                    
    function TRANSFEROWNERSHIP989(address newOwner) public ONLYOWNER459 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP338(newOwner);
    }

                                                                                                                                         
    function _TRANSFEROWNERSHIP338(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0));
        emit OWNERSHIPTRANSFERRED920(_owner, newOwner);
        _owner = newOwner;
    }
}

contract AutoRedDotDistrict is Ownable {

    using SafeMath for uint256;

                    
                    
                    

                
                
                

                 
                 
                 

    // Anyone can call the createAuction function to receive a small reward when
    // any of the whitelisted kitties are available to sire.
    uint256 public auctionCreationReward = 10000000000000000; // 0.01 ETH

    // Users can only call createAuction for kitties that are whitelisted by
    // the owner.
    mapping (uint256 => bool) public kittyIsWhitelisted;
    uint256 public numberOfWhitelistedKitties;

    // The owner can set startingPrice, endingPrice, and auctionDuration for
    // siring auctions.
    mapping (uint256 => uint256) public startingSiringPriceForKitty;
    uint256 public globalEndingSiringPrice = 0;
    uint256 public globalAuctionDuration = 1296000; // 15 Days (in seconds)

                   
                   
                   

                   
                   
                   

    address public kittyCoreAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    address public kittySiresAddress = 0xC7af99Fe5513eB6710e6D5f44F9989dA40F27F26;

                   
                   
                   

    // Anyone can call this function to claim the auctionCreationReward when
    // any of the red dot district kitties are rested and ready to sire.
    // The auctionCreationReward funds come from the previous successful sire
    // auctions, so the owner does not have to keep refilling this contract.
    // This function is still callable even if the contract does not have enough
    // for the auctionCreationReward, the caller will simply not be rewarded.
    function CREATEAUCTION906(uint256 _kittyId) external {	//inject NONSTANDARD NAMING
        require(kittyIsWhitelisted[_kittyId] == true, 'kitty is not whitelisted');

        KittyCore(kittyCoreAddress).CREATESIRINGAUCTION26(
            _kittyId,
            startingSiringPriceForKitty[_kittyId],
            globalEndingSiringPrice,
            globalAuctionDuration
        );

        uint256 contractBalance = address(this).balance;
        if(contractBalance >= auctionCreationReward){
            msg.sender.transfer(auctionCreationReward);
        }
    }

    function OWNERCHANGESTARTINGSIRINGPRICE514(uint256 _kittyId, uint256 _newStartingSiringPrice) external ONLYOWNER459 {	//inject NONSTANDARD NAMING
        startingSiringPriceForKitty[_kittyId] = _newStartingSiringPrice;
    }

    function OWNERCHANGEGLOBALENDINGSIRINGPRICE671(uint256 _newGlobalEndingSiringPrice) external ONLYOWNER459 {	//inject NONSTANDARD NAMING
        globalEndingSiringPrice = _newGlobalEndingSiringPrice;
    }

    function OWNERCHANGEGLOBALAUCTIONDURATION321(uint256 _newGlobalAuctionDuration) external ONLYOWNER459 {	//inject NONSTANDARD NAMING
        globalAuctionDuration = _newGlobalAuctionDuration;
    }

    function OWNERCHANGEAUCTIONCREATIONREWARD955(uint256 _newAuctionCreationReward) external ONLYOWNER459 {	//inject NONSTANDARD NAMING
        auctionCreationReward = _newAuctionCreationReward;
    }

    function OWNERCANCELSIRINGAUCTION522(uint256 _kittyId) external ONLYOWNER459 {	//inject NONSTANDARD NAMING
        KittySires(kittySiresAddress).CANCELAUCTION283(_kittyId);
    }

    function OWNERWITHDRAWKITTY460(address _destination, uint256 _kittyId) external ONLYOWNER459 {	//inject NONSTANDARD NAMING
        KittyCore(kittyCoreAddress).TRANSFER410(_destination, _kittyId);
    }

    function OWNERWHITELISTKITTY644(uint256 _kittyId, bool _whitelist) external ONLYOWNER459 {	//inject NONSTANDARD NAMING
        kittyIsWhitelisted[_kittyId] = _whitelist;
        if(_whitelist){
            numberOfWhitelistedKitties = numberOfWhitelistedKitties.ADD121(1);
        } else {
            numberOfWhitelistedKitties = numberOfWhitelistedKitties.SUB229(1);
        }
    }

    // This is the main withdrawal function that the owner can call to claim
    // earnings. It leaves numberOfWhitelistedKitties * auctionCreationReward
    // in the contract to incentivize future callers of the createAuction
    // function.
    function OWNERWITHDRAWALLEARNINGS662() external ONLYOWNER459 {	//inject NONSTANDARD NAMING
        uint256 contractBalance = address(this).balance;
        uint256 fundsToLeaveToIncentivizeFutureCallers = auctionCreationReward.MUL808(numberOfWhitelistedKitties);
        if(contractBalance > fundsToLeaveToIncentivizeFutureCallers){
            uint256 earnings = contractBalance.SUB229(fundsToLeaveToIncentivizeFutureCallers);
            msg.sender.transfer(earnings);
        }
    }

    // This is an emergency function that the owner can call to retrieve all
    // ether, including the ether that would normally be left in the contract to
    // incentivize future callers of the createAuction function.
    function EMERGENCYWITHDRAW520() external ONLYOWNER459 {	//inject NONSTANDARD NAMING
        msg.sender.transfer(address(this).balance);
    }

    constructor() public {
        // Initialize starting prices for the six EN04 generation 0 kitties
        startingSiringPriceForKitty[848437] = 200000000000000000; // 0.2 ETH
        startingSiringPriceForKitty[848439] = 200000000000000000; // 0.2 ETH
        startingSiringPriceForKitty[848440] = 200000000000000000; // 0.2 ETH
        startingSiringPriceForKitty[848441] = 200000000000000000; // 0.2 ETH
        startingSiringPriceForKitty[848442] = 200000000000000000; // 0.2 ETH
        startingSiringPriceForKitty[848582] = 200000000000000000; // 0.2 ETH

        // Whitelist the six EN04 generation 0 kitties
        kittyIsWhitelisted[848437] = true;
        kittyIsWhitelisted[848439] = true;
        kittyIsWhitelisted[848440] = true;
        kittyIsWhitelisted[848441] = true;
        kittyIsWhitelisted[848442] = true;
        kittyIsWhitelisted[848582] = true;
        numberOfWhitelistedKitties = 6;

        // Transfer ownership to Dapper Labs original Red Dot District EOA
        // account on mainnet, they can change ownership to whatever address
        // they wish after that.
        TRANSFEROWNERSHIP989(0xBb1e390b77Ff99f2765e78EF1A7d069c29406bee);
    }

    function() external payable {}
}

contract KittyCore {
    function TRANSFER410(address _to, uint256 _tokenId) external;	//inject NONSTANDARD NAMING
    function CREATESIRINGAUCTION26(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external;	//inject NONSTANDARD NAMING
}

contract KittySires {
    function CANCELAUCTION283(uint256 _tokenId) external;	//inject NONSTANDARD NAMING
}