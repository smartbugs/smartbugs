                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

pragma solidity 0.5.2;


                                                                                                   
library SafeMath {
                                                                                  
    function MUL272(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                           
    function DIV750(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                              
    function SUB989(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

                                                                            
    function ADD192(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

                                                                                                                                                    
    function MOD240(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}


contract Medianizer {
    function READ644() public view returns (bytes32);	//inject NONSTANDARD NAMING
}


contract Weth {
    mapping(address => mapping(address => uint)) public allowance;
    mapping(address => uint) public balanceOf;

    function TRANSFERFROM733(address src, address dst, uint wad) public returns (bool);	//inject NONSTANDARD NAMING
}


                               
                                        
contract Subscrypto {
    using SafeMath for uint;
    Medianizer public daiPriceContract;
    Weth public wethContract;

                                                                                                                        
    constructor(address daiMedianizerContract, address wethContractAddress) public {
        daiPriceContract = Medianizer(daiMedianizerContract);
        wethContract = Weth(wethContractAddress);
    }

    event NEWSUBSCRIPTION922(	//inject NONSTANDARD NAMING
        address indexed subscriber,
        address indexed receiver,
        uint daiCents,
        uint32 interval
    );

    event UNSUBSCRIBE503(	//inject NONSTANDARD NAMING
        address indexed subscriber, 
        address indexed receiver
    );

    event RECEIVERPAYMENTSCOLLECTED234(	//inject NONSTANDARD NAMING
        address indexed receiver,
        uint weiAmount,
        uint startIndex,
        uint endIndex
    );

    event PAYMENTCOLLECTED515(	//inject NONSTANDARD NAMING
        address indexed subscriber,
        address indexed receiver,
        uint weiAmount,
        uint daiCents,
        uint48 effectiveTimestamp
    );

    event UNFUNDEDPAYMENT140(	//inject NONSTANDARD NAMING
        address indexed subscriber,
        address indexed receiver,
        uint weiAmount,
        uint daiCents
    );

    event STALESUBSCRIPTION369(	//inject NONSTANDARD NAMING
        address indexed subscriber,
        address indexed receiver
    );

    event SUBSCRIPTIONDEACTIVATED635(	//inject NONSTANDARD NAMING
        address indexed subscriber,
        address indexed receiver
    );

    event SUBSCRIPTIONREACTIVATED687(	//inject NONSTANDARD NAMING
        address indexed subscriber,
        address indexed receiver
    );

    // Conservative amount of gas used per loop in collectPayments()
    uint constant min_gas_per_collect_payment583 = 45000;	//inject NONSTANDARD NAMING
    // Force subscribers to use multiple accounts when this limit is reached.
    uint constant max_subscription_per_subscriber712 = 10000;	//inject NONSTANDARD NAMING
    // Minimum payment of 1 DAI
    uint constant min_subscription_dai_cents316 = 100;	//inject NONSTANDARD NAMING
    // If this many intervals pass without being collected, mark as inactive
    uint constant stale_interval_threshold361 = 3;	//inject NONSTANDARD NAMING

    struct Subscription {
        bool    isActive;        //  1 byte
        uint48  nextPaymentTime; //  6 bytes
        uint32  interval;        //  4 bytes
        address subscriber;      // 20 bytes
        address receiver;        // 20 bytes
        uint    daiCents;        // 32 bytes
    }

    // global counter for suscriptions
    uint64 nextIndex = 1;

    // source of truth for subscriptions
    mapping(uint64 => Subscription) public subscriptions;

    // subscriber => receiver => subsciptionIndex
    mapping(address => mapping(address => uint64)) public subscriberReceiver;

    // receiver => subs array
    mapping(address => uint64[]) public receiverSubs;

    // subscriber => subs array
    mapping(address => uint64[]) public subscriberSubs;

                                                                                                                                                                                                                                                                                                                                                                                                  
    function SUBSCRIBE386(address receiver, uint daiCents, uint32 interval) external {	//inject NONSTANDARD NAMING
        uint weiAmount = DAICENTSTOETHWEI491(daiCents, ETHPRICEINDAIWAD237());
        uint64 existingIndex = subscriberReceiver[msg.sender][receiver];
        require(subscriptions[existingIndex].daiCents == 0, "Subscription exists");
        require(daiCents >= min_subscription_dai_cents316, "Subsciption amount too low");
        require(interval >= 86400, "Interval must be at least 1 day");
        require(interval <= 31557600, "Interval must be at most 1 year");
        require(subscriberSubs[msg.sender].length < max_subscription_per_subscriber712,"Subscription count limit reached");

        // first payment
        require(wethContract.TRANSFERFROM733(msg.sender, receiver, weiAmount), "wETH transferFrom() failed");

        // add to subscription mappings
        subscriptions[nextIndex] = Subscription(
            true,
            uint48(now.ADD192(interval)),
            interval,
            msg.sender,
            receiver,
            daiCents
        );
        subscriberReceiver[msg.sender][receiver] = nextIndex;
        receiverSubs[receiver].push(nextIndex);
        subscriberSubs[msg.sender].push(nextIndex);

        emit NEWSUBSCRIPTION922(msg.sender, receiver, daiCents, interval);
        emit PAYMENTCOLLECTED515(msg.sender, receiver, weiAmount, daiCents, uint48(now));

        nextIndex++;
    }
    
                                                                                                                                                                                                                                                                            
    function DEACTIVATESUBSCRIPTION332(address receiver) external returns (bool) {	//inject NONSTANDARD NAMING
        uint64 index = subscriberReceiver[msg.sender][receiver];
        require(index != 0, "Subscription does not exist");

        Subscription storage sub = subscriptions[index];
        require(sub.isActive, "Subscription is already disabled");
        require(sub.daiCents > 0, "Subscription does not exist");

        sub.isActive = false;
        emit SUBSCRIPTIONDEACTIVATED635(msg.sender, receiver);

        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function REACTIVATESUBSCRIPTION562(address receiver) external returns (bool) {	//inject NONSTANDARD NAMING
        uint64 index = subscriberReceiver[msg.sender][receiver];
        require(index != 0, "Subscription does not exist");

        Subscription storage sub = subscriptions[index];
        require(!sub.isActive, "Subscription is already active");

        sub.isActive = true;
        emit SUBSCRIPTIONREACTIVATED687(msg.sender, receiver);

        if (CALCULATEUNPAIDINTERVALSUNTIL880(sub, now) > 0) {
            // only make a payment if at least one interval has lapsed since the last payment
            uint weiAmount = DAICENTSTOETHWEI491(sub.daiCents, ETHPRICEINDAIWAD237());
            require(wethContract.TRANSFERFROM733(msg.sender, receiver, weiAmount), "Insufficient funds to reactivate subscription");
            emit PAYMENTCOLLECTED515(msg.sender, receiver, weiAmount, sub.daiCents, uint48(now));
        }

        sub.nextPaymentTime = uint48(now.ADD192(sub.interval));

        return true;
    }

                                                                                                                                                                              
    function UNSUBSCRIBE300(address receiver) external {	//inject NONSTANDARD NAMING
        uint64 index = subscriberReceiver[msg.sender][receiver];
        require(index != 0, "Subscription does not exist");
        delete subscriptions[index];
        delete subscriberReceiver[msg.sender][receiver];
        DELETEELEMENT542(subscriberSubs[msg.sender], index);
        emit UNSUBSCRIBE503(msg.sender, receiver);
    }

                                                                                                                                                                              
    function UNSUBSCRIBEBYRECEIVER872(address subscriber) external {	//inject NONSTANDARD NAMING
        uint64 index = subscriberReceiver[subscriber][msg.sender];
        require(index != 0, "Subscription does not exist");
        delete subscriptions[index];
        delete subscriberReceiver[subscriber][msg.sender];
        DELETEELEMENT542(subscriberSubs[subscriber], index);
        emit UNSUBSCRIBE503(subscriber, msg.sender);
    }

                                                                                                                                                                                                                                                                                                         
    function COLLECTPAYMENTS193(address receiver) external {	//inject NONSTANDARD NAMING
        COLLECTPAYMENTSRANGE133(receiver, 0, receiverSubs[receiver].length);
    }

                                                                                                                                                                                                          
    function GETTOTALUNCLAIMEDPAYMENTS90(address receiver) external view returns (uint) {	//inject NONSTANDARD NAMING
        uint totalPayment = 0;
        uint ethPriceWad = ETHPRICEINDAIWAD237();

        for (uint i = 0; i < receiverSubs[receiver].length; i++) {
            Subscription storage sub = subscriptions[receiverSubs[receiver][i]];

            if (sub.isActive && sub.daiCents != 0) {
                uint wholeUnpaidIntervals = CALCULATEUNPAIDINTERVALSUNTIL880(sub, now);
                if (wholeUnpaidIntervals > 0 && wholeUnpaidIntervals < stale_interval_threshold361) {
                    uint weiAmount = DAICENTSTOETHWEI491(sub.daiCents, ethPriceWad);
                    uint authorizedBalance = ALLOWEDBALANCE770(sub.subscriber);

                    do {
                        if (authorizedBalance >= weiAmount) {
                            totalPayment = totalPayment.ADD192(weiAmount);
                            authorizedBalance = authorizedBalance.SUB989(weiAmount);
                        }
                        wholeUnpaidIntervals = wholeUnpaidIntervals.SUB989(1);
                    } while (wholeUnpaidIntervals > 0);
                }
            }
        }

        return totalPayment;
    }

                                                                                                                                                                                                                                                          
    function OUTSTANDINGBALANCEUNTIL585(address subscriber, uint time) external view returns (uint) {	//inject NONSTANDARD NAMING
        uint until = time <= now ? now : time;

        uint64[] memory subs = subscriberSubs[subscriber];

        uint totalDaiCents = 0;
        for (uint64 i = 0; i < subs.length; i++) {
            Subscription memory sub = subscriptions[subs[i]];
            if (sub.isActive) {
                totalDaiCents = totalDaiCents.ADD192(sub.daiCents.MUL272(CALCULATEUNPAIDINTERVALSUNTIL880(sub, until)));
            }
        }

        return totalDaiCents;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function COLLECTPAYMENTSRANGE133(address receiver, uint start, uint end) public returns (uint) {	//inject NONSTANDARD NAMING
        uint64[] storage subs = receiverSubs[receiver];
        require(subs.length > 0, "receiver has no subscriptions");
        require(start < end && end <= subs.length, "wrong arguments for range");
        uint totalPayment = 0;
        uint ethPriceWad = ETHPRICEINDAIWAD237();

        uint last = end;
        uint i = start;
        while (i < last) {
            if (gasleft() < min_gas_per_collect_payment583) {
                break;
            }
            Subscription storage sub = subscriptions[subs[i]];

            // delete empty subs
            while (sub.daiCents == 0 && subs.length > 0) {
                uint lastIndex = subs.length.SUB989(1);
                subs[i] = subs[lastIndex];
                delete(subs[lastIndex]);
                subs.length = lastIndex;
                if (last > lastIndex) {
                    last = lastIndex;
                }
                if (lastIndex > 0) {
                    sub = subscriptions[subs[i]];
                }
            }

            if (sub.isActive && sub.daiCents != 0) {
                uint wholeUnpaidIntervals = CALCULATEUNPAIDINTERVALSUNTIL880(sub, now);
                
                if (wholeUnpaidIntervals > 0) {
                    // this could be placed in the following else{} block, but the stack becomes too deep
                    uint subscriberPayment = 0;

                    if (wholeUnpaidIntervals >= stale_interval_threshold361) {
                        sub.isActive = false;
                        emit SUBSCRIPTIONDEACTIVATED635(sub.subscriber, receiver);
                        emit STALESUBSCRIPTION369(sub.subscriber, receiver);
                    } else {
                        uint weiAmount = DAICENTSTOETHWEI491(sub.daiCents, ethPriceWad);
                        uint authorizedBalance = ALLOWEDBALANCE770(sub.subscriber);

                        do {
                            if (authorizedBalance >= weiAmount) {
                                totalPayment = totalPayment.ADD192(weiAmount);
                                subscriberPayment = subscriberPayment.ADD192(weiAmount);
                                authorizedBalance = authorizedBalance.SUB989(weiAmount);
                                emit PAYMENTCOLLECTED515(sub.subscriber, receiver, weiAmount, sub.daiCents, sub.nextPaymentTime);
                                sub.nextPaymentTime = CALCULATENEXTPAYMENTTIME716(sub);
                            } else {
                                emit UNFUNDEDPAYMENT140(sub.subscriber, receiver, weiAmount, sub.daiCents);
                            }
                            wholeUnpaidIntervals = wholeUnpaidIntervals.SUB989(1);
                        } while (wholeUnpaidIntervals > 0);
                    }

                    if (subscriberPayment > 0) {
                        assert(wethContract.TRANSFERFROM733(sub.subscriber, receiver, subscriberPayment));
                    }
                }
            }

            i++;
        }

        emit RECEIVERPAYMENTSCOLLECTED234(receiver, totalPayment, start, i);
        return i;
    }

                                                                                                                                                                                                                                                                                                              
    function ALLOWEDBALANCE770(address subscriber) public view returns (uint) {	//inject NONSTANDARD NAMING
        uint balance = wethContract.balanceOf(subscriber);
        uint allowance = wethContract.allowance(subscriber, address(this));

        return balance > allowance ? allowance : balance;
    }

                                                                                                                                                          
    function ETHPRICEINDAIWAD237() public view returns (uint) {	//inject NONSTANDARD NAMING
        uint price = uint(daiPriceContract.READ644());
        require(price > 1, "Invalid price for DAI.");
        return price;
    }

                                                                                                                                                                                                                                                                             
    function DELETEELEMENT542(uint64[] storage array, uint64 element) internal {	//inject NONSTANDARD NAMING
        uint lastIndex = array.length.SUB989(1);
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == element) {
                array[i] = array[lastIndex];
                delete(array[lastIndex]);
                array.length = lastIndex;
                break;
            }
        }
    }

                                                                                                                                                                                                                                                                                                                 
    function CALCULATEUNPAIDINTERVALSUNTIL880(Subscription memory sub, uint time) internal view returns (uint) {	//inject NONSTANDARD NAMING
        require(time >= now, "don't use a time before now");

        if (time > sub.nextPaymentTime) {
            return ((time.SUB989(sub.nextPaymentTime)).DIV750(sub.interval)).ADD192(1);
        }

        return 0;
    }

                                                                                                                                                                                          
    function CALCULATENEXTPAYMENTTIME716(Subscription memory sub) internal pure returns (uint48) {	//inject NONSTANDARD NAMING
        uint48 nextPaymentTime = sub.nextPaymentTime + sub.interval;
        assert(nextPaymentTime > sub.nextPaymentTime);
        return nextPaymentTime;
    }

                                                                                                                                                                                                                                          
    function DAICENTSTOETHWEI491(uint daiCents, uint ethPriceWad) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return CENTSTOWAD345(daiCents).MUL272(10**18).DIV750(ethPriceWad);
    }

                                                                                                                                                                         
    function CENTSTOWAD345(uint cents) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return cents.MUL272(10**16);
    }
}