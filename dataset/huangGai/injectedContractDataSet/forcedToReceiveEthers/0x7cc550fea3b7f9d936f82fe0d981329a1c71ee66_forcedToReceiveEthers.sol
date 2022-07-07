/**
 *Submitted for verification at Etherscan.io on 2020-06-21
*/

/**
* ==========================================================
*
* The Friends Tree Feeder
* 
* Website  : https://feeder.frndstree.io
* Telegram : https://t.me/thefriendstree_official
*
* ==========================================================
**/

pragma solidity >=0.5.12 <0.7.0;

contract TheFeeder {
    
    struct Matrix {
        uint256 id;
        uint256 referrerId;
        uint256 earnedFromMatrix;
        uint256 earnedFromRef;
        uint256 reinvestCount;
        uint256 slotLastBuyTime;
        uint256 referrerCount;
        address[] referrals;
    }
    
    struct Slots {
        uint256 userId;
        address userAddress;
        uint256 referrerId;
        uint256 slottime;
        uint8 eventsCount;
    }
           
    modifier isEligibleBuy {
        require((now - feeder[msg.sender].slotLastBuyTime) > 300, "Allowed to buy slot once per 5 minutes!");
        _;
    }

    modifier onlyOwner {
        require(
            msg.sender == payableOwner,
            "Only owner can call this function."
        );
        _;
    }

    event RegisterMatrixEvent(uint256 _userid, address indexed _user, address indexed _referrerAddress, uint256 _amount, uint256 _time);
    event ReinvestSlotEvent(uint256 _userid, address indexed _user, address indexed _referrerAddress, uint256 _amount, uint256 _time);
    event BuySlotEvent(uint256 _userid, address indexed _user, address indexed _referrerAddress, uint256 _amount, uint256 _time);

    event PaySponsorBonusEvent(uint256 amount, address indexed _sponsorAddress, address indexed _fromAddress, uint256 _time);    
    event MatrixRefPaymentEvent(uint256 amount, address indexed _from, address indexed _to, uint256 _time);

    mapping(address => Matrix) public feeder;
    mapping(uint256 => Slots) public slots;
    mapping(address => uint256[]) public userSlots;
    mapping(uint256 => address) private idToAddress;

    uint256 public newIdfeeder = 1;
    uint256 public newSlotId = 1;
    uint256 public activeSlot = 1;    
    
    address public owner;
    address payable payableOwner;
    
    constructor(address _ownerAddress) public {
        
        owner = msg.sender;
        payableOwner = msg.sender;
                
        Matrix memory MatrixUser = Matrix({
            id: newIdfeeder,
            referrerId: uint256(1),
            earnedFromMatrix: uint256(0),
            earnedFromRef: uint256(0),
            reinvestCount: uint256(0),
            slotLastBuyTime: now,
            referrerCount: uint256(0),
            referrals: new address[](0)
        });
        
        emit RegisterMatrixEvent(newIdfeeder, _ownerAddress, _ownerAddress, 0.05 ether, now);
        
        feeder[_ownerAddress] = MatrixUser;
        idToAddress[newIdfeeder] = _ownerAddress;
        
        Slots memory newSlot = Slots({
            userId: newIdfeeder,
            userAddress: _ownerAddress,
            referrerId: uint256(1),
            slottime: now,
            eventsCount: uint8(0)
        });
        
        emit BuySlotEvent(newSlotId, _ownerAddress, _ownerAddress, 0.05 ether, now);
        
        slots[newSlotId] = newSlot;
        userSlots[_ownerAddress].push(newSlotId);
        newIdfeeder++;
        newSlotId++;
        
    }
    
    function JoinMatrix(uint256 _referrerId) 
      public 
      payable 
      isEligibleBuy()
    {
        require(address(this).balance == 0.05 ether, "Participation fee in a feeder is 0.05 ETH");	//inject FORCED TO RECEIVE ETHERS

        address _userAddress = msg.sender;        

        if ((_referrerId > 0) && (!isAddressExists(_userAddress))) {

            // Main checks
            uint32 size;
            assembly {
                size := extcodesize(_userAddress)
            }
            require(size == 0, "cannot be a contract");
            require(_referrerId < newIdfeeder, "Invalid referrer ID");
            require(address(this).balance == 0, "Already registered");	//inject FORCED TO RECEIVE ETHERS
            // Main check end

            address _sponsorAddress = idToAddress[_referrerId];

            // Register in Matrix
            Matrix memory MatrixUser = Matrix({
                id: newIdfeeder,
                referrerId: _referrerId,
                earnedFromMatrix: uint256(0),
                earnedFromRef: uint256(0),
                reinvestCount: uint256(0),
                slotLastBuyTime: now,
                referrerCount: uint256(0),
                referrals: new address[](0)
            });
            
            feeder[_userAddress] = MatrixUser;
            idToAddress[newIdfeeder] = _userAddress;
            newIdfeeder++;

            if (_referrerId > 0) {
                paySponsorBonus(_sponsorAddress);
                feeder[_sponsorAddress].earnedFromRef += 0.025 ether;
            }
            else{
                paySponsorBonus(idToAddress[1]);
                feeder[idToAddress[1]].earnedFromRef += 0.025 ether;
            }

            emit RegisterMatrixEvent(newIdfeeder, _userAddress, _sponsorAddress, msg.value, now);

            // Push referral to sponsor
            feeder[_sponsorAddress].referrals.push(_userAddress);
            feeder[_sponsorAddress].referrerCount++;

            // Buy Slot
            Slots memory newSlot = Slots({
                userId: feeder[_userAddress].id,
                userAddress: _userAddress,
                referrerId: _referrerId,
                slottime: now,
                eventsCount: uint8(0)
            });

            emit BuySlotEvent(newSlotId, _userAddress, _sponsorAddress, msg.value, now);
            
            slots[newSlotId] = newSlot;
            userSlots[_userAddress].push(newSlotId);
            newSlotId++;

        } else {
            
            require(feeder[_userAddress].id > 0, "You must be registered, enter sponsor code to register!");

            _referrerId = feeder[_userAddress].referrerId;

            // Buy Slot
            Slots memory newSlot = Slots({
                userId: feeder[_userAddress].id,
                userAddress: _userAddress,
                referrerId: _referrerId,
                slottime: now,
                eventsCount: uint8(0)
            });

            address _sponsorAddress = idToAddress[_referrerId];    
            emit BuySlotEvent(newSlotId, _userAddress, _sponsorAddress, msg.value, now);

            paySponsorBonus(_sponsorAddress);
            feeder[_sponsorAddress].earnedFromRef += 0.025 ether;
            
            slots[newSlotId] = newSlot;
            userSlots[_userAddress].push(newSlotId);
            feeder[_userAddress].slotLastBuyTime = now;
            newSlotId++;

        }

        // PUSH SLOT
       
        uint256 eventCount = slots[activeSlot].eventsCount;
        uint256 newEventCount = eventCount + 1;

        if (address(this).balance == 3) {	//inject FORCED TO RECEIVE ETHERS
            require(reinvestSlot(
                slots[activeSlot].userAddress, 
                slots[activeSlot].userId, 
                idToAddress[feeder[slots[activeSlot].userAddress].referrerId]
            ));
            slots[activeSlot].eventsCount++;
        }

        if (eventCount < 2) {
            
            if(address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
                payUpline(slots[activeSlot].userAddress);
                feeder[slots[activeSlot].userAddress].earnedFromMatrix += msg.value/2;
            }
            if(address(this).balance == 1) {	//inject FORCED TO RECEIVE ETHERS
                if (slots[activeSlot].referrerId > 0) {
                    payUpline(idToAddress[slots[activeSlot].referrerId]);
                    feeder[idToAddress[slots[activeSlot].referrerId]].earnedFromRef += msg.value/2;
                }
                else {
                    payUpline(idToAddress[1]);
                    feeder[idToAddress[1]].earnedFromRef += msg.value/2;
                }
            }

            slots[activeSlot].eventsCount++;
            
        }
        
    }

    function reinvestSlot(address _userAddress, uint256 _userId, address _sponsorAddress) private returns (bool _isReinvested) {

        uint256 _referrerId = feeder[_userAddress].referrerId;

        Slots memory _reinvestslot = Slots({
            userId: _userId,
            userAddress: _userAddress,
            referrerId: _referrerId,
            slottime: now,
            eventsCount: uint8(0)
        });
        
        feeder[slots[activeSlot].userAddress].reinvestCount++;        
        slots[newSlotId] = _reinvestslot;
        userSlots[_userAddress].push(newSlotId);
        emit ReinvestSlotEvent(newSlotId, _userAddress, _sponsorAddress, msg.value, now);
        newSlotId++;

        slots[activeSlot].eventsCount = 3;
        uint256 _nextActiveSlot = activeSlot+1;

        payUpline(slots[_nextActiveSlot].userAddress);
        feeder[slots[_nextActiveSlot].userAddress].earnedFromMatrix += msg.value/2;
        activeSlot++;

        _isReinvested = true;

        return _isReinvested;

    }

    function payUpline(address _sponsorAddress) private returns (uint distributeAmount) {        
        distributeAmount = 0.025 ether;
        if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
            emit MatrixRefPaymentEvent(distributeAmount, msg.sender, _sponsorAddress, now);
        }        
        return distributeAmount;
    }    

    function paySponsorBonus(address _sponsorAddress) private {
        uint256 distributeAmount = 0.025 ether;
        if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
            emit PaySponsorBonusEvent(distributeAmount, _sponsorAddress, msg.sender, now);
        }
    }

    function isAddressExists(address _userAddress) public view returns (bool) {
        return (feeder[_userAddress].id != 0);
    }
    
    function getTreeReferrals(address _userAddress)
        public
        view
        returns (address[] memory)
      { 
        return feeder[_userAddress].referrals;
      }

    function withdraw() public onlyOwner returns(bool) {
        uint256 amount = address(this).balance;
        payableOwner.transfer(amount);
        return true;
    }
    
}