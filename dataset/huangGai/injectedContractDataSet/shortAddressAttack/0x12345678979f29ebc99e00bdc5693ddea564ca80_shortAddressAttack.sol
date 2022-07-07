pragma solidity ^0.5.3;

// counter.market smart contracts:
//  1) Proxy - delegatecalls into current exchange code, maintains storage of exchange state
//  2) Registry - stores information on the latest exchange contract version and user approvals
//  3) Treasury (this one) - takes custody of funds, moves them between token accounts, authorizing exchange code via Registry

// Counter contracts are deployed at predefined addresses which can be hardcoded.
contract FixedAddress {
    address constant ProxyAddress = 0x1234567896326230a28ee368825D11fE6571Be4a;
    address constant TreasuryAddress = 0x12345678979f29eBc99E00bdc5693ddEa564cA80;
    address constant RegistryAddress = 0x12345678982cB986Dd291B50239295E3Cb10Cdf6;

    function getRegistry() internal pure returns (RegistryInterface) {
        return RegistryInterface(RegistryAddress);
    }
}

// External contracts access Registry via one of these methods
interface RegistryInterface {
    function getOwner() external view returns (address);
    function getExchangeContract() external view returns (address);
    function contractApproved(address traderAddr) external view returns (bool);
    function contractApprovedBoth(address traderAddr1, address traderAddr2) external view returns (bool);
    function acceptNextExchangeContract() external;
}

// Access modifiers on restricted Treasury methods
contract AccessModifiers is FixedAddress {

    // Only the owner of the Registry contract may invoke this method.
    modifier onlyRegistryOwner() {
        require (msg.sender == getRegistry().getOwner(), "onlyRegistryOwner() method called by non-owner.");
        _;
    }

    // Method should be called by the current exchange (by delegatecall from Proxy), and trader should have approved
    // the latest Exchange code.
    modifier onlyApprovedExchange(address trader) {
        require (msg.sender == ProxyAddress, "onlyApprovedExchange() called not by exchange proxy.");
        require (getRegistry().contractApproved(trader), "onlyApprovedExchange() requires approval of the latest contract code by trader.");
        _;
    }

    // The same as above, but checks approvals of two traders simultaneously.
    modifier onlyApprovedExchangeBoth(address trader1, address trader2) {
        require (msg.sender == ProxyAddress, "onlyApprovedExchange() called not by exchange proxy.");
        require (getRegistry().contractApprovedBoth(trader1, trader2), "onlyApprovedExchangeBoth() requires approval of the latest contract code by both traders.");
        _;
    }

}

// External contracts access Treasury via one of these methods
interface TreasuryInterface {
    function withdrawEther(address traderAddr, address payable withdrawalAddr, uint amount) external;
    function withdrawERC20Token(uint16 tokenCode, address traderAddr, address withdrawalAddr, uint amount) external;
    function transferTokens(uint16 tokenCode, address fromAddr, address toAddr, uint amount) external;
    function transferTokensTwice(uint16 tokenCode, address fromAddr, address toAddr1, uint amount1, address toAddr2, uint amount2) external;
    function exchangeTokens(uint16 tokenCode1, uint16 tokenCode2, address addr1, address addr2, address addrFee, uint amount1, uint fee1, uint amount2, uint fee2) external;
}

// Treasury responsibilities:
//  - storing the mapping of token codes to token contract addresses
//  - processing deposits to/withdrawals from/transfers between token accounts within itself
//  - processing emergency releases

// Treasury is required because Counter is not a wallet-to-wallet exchange, and requires deposits and
// withdrawals in order to be able to trade. Having full control over settlement order enables Counter
// to be responsive on its UI by settling trades and withdrawals in background. The former
// operations are authorized by ECDSA signatures collected from users and effected on-chain by the
// Counter arbiter services.

// Because user signatures are effected on the contract via an intermediary (the Counter arbiter),
// there is inherent trust issue where a trader may assume that the Counter may refuse to apply some
// operations on-chain (especially withdrawals), or may simply experience prolonged downtime. Hence
// the need for the emergency release (ER) feature, which is an ability to withdraw funds from Counter
// directly. It works as follows:
//  1) any trader may initiate a cooldown of two days for all token accounts of the same address
//  2) this cooldown is reset by invoking withdrawal or exchange on this address - these are the
//     operations which require explicit consent in the form of digital signature and thus mean
//     that a) exchange is operational b) the user trusts it
//  3) in case the cooldown have not been reset by any means within two day period, the user may withdraw
//     the entirety of their funds from Treasury.
//
// A note should be made regarding 2) - Counter does _not_ have an ability to reset the ER cooldown
// arbitrarily long, as trade signatures contain an explicit expiration date, and withdrawals have a
// nonce which makes them eligible to be applied once.

contract Treasury is AccessModifiers, TreasuryInterface {
    // *** Constants.

    uint constant EMERGENCY_RELEASE_CHALLENGE_PERIOD = 2 days;

    // *** Variables.

    // Treasury can be "paused" by the registry owner to effectively freeze fund movement
    // (sans emergency releases).
    bool active = false;

    // Mapping from token codes (uint16) into corresponding ERC-20 contract addresses.
    // Each token code can only be assigned once for security reasons. Token code 0 is
    // always Ether.
    mapping (uint16 => address) public tokenContracts;

    // Balance of a specific token account, in lowest denomination (wei for Ether).
    // uint176 key is composite of u16 token code (bits 160..175) and address (bits 0..159).
    mapping (uint176 => uint) public tokenAmounts;

    // *** Events

    event SetActive(bool active);
    event ChangeTokenInfo(uint16 tokenCode, address tokenContract);
    event StartEmergencyRelease(address account);
    event Deposit(uint16 tokenCode, address account, uint amount);
    event Withdrawal(uint16 tokenCode, address traderAddr, address withdrawalAddr, uint amount);
    event EmergencyRelease(uint16 tokenCode, address account, uint amount);

    // Emergency release status for an address (_not_ for the token account):
    //     == 0 - escape release challenge inactive
    //     != 0 - timestamp after which ER can be executed
    mapping (address => uint) public emergencyReleaseSince;

    // *** Constructor

    constructor () public {
    }

    // *** Modifiers

    modifier onlyActive() {
        require (active, "Inactive treasury only allows withdrawals.");
        _;
    }

    modifier emergencyReleasePossible(address trader) {
        uint deadline = emergencyReleaseSince[trader];
        require (deadline > 0 && block.timestamp > deadline, "Challenge should be active and deadline expired.");
        _;
    }

    // *** Admin methods (mostly self-explanatory)

    function setActive(bool _active) external onlyRegistryOwner() {
        active = _active;

        emit SetActive(active);
    }

    function changeTokenInfo(uint16 tokenCode, address tokenContract) external onlyRegistryOwner() {
        require (tokenCode != 0,
                 "Token code of zero is reserved for Ether.");

        require (tokenContracts[tokenCode] == address(0),
                 "Token contract address can be assigned only once.");

        tokenContracts[tokenCode] = tokenContract;

        emit ChangeTokenInfo(tokenCode, tokenContract);
    }

    // *** Emergency release initiation and reset

    // This method is invoked by the user to start the ER cooldown
    function startEmergencyRelease() external {
        emergencyReleaseSince[msg.sender] = block.timestamp + EMERGENCY_RELEASE_CHALLENGE_PERIOD;

        emit StartEmergencyRelease(msg.sender);
    }

    // This private method resets the UR cooldown for when executing successful trades/withdrawals
    function resetEmergencyRelease(address traderAddr) private {
        if (emergencyReleaseSince[traderAddr] != 0) {
            emergencyReleaseSince[traderAddr] = 0;
        }
    }

    // *** Fund movement methods

    // * Deposits (initiated by and paid for by the trader)

    function depositEther(address account) external payable {
        emit Deposit(0, account, msg.value);

        addBalance(0, account, msg.value);
    }

    function depositERC20Token(uint176 tokenAccount, uint amount) external {
        uint16 tokenCode = uint16(tokenAccount >> 160);
        address tokenContract = tokenContracts[tokenCode];

        require (tokenContract != address(0), "Registered token contract.");

        // Need a preliminary .approve() call
        require (safeTransferFrom(tokenContract, msg.sender, address(this), amount),
                 "Could not transfer ERC-20 tokens using transferFrom.");

        address account = address(tokenAccount);
        emit Deposit(tokenCode, account, amount);

        addBalance(tokenCode, account, amount);
    }

    // * Emergency release (initiated by and paid for by the trader)

    function emergencyReleaseEther() external emergencyReleasePossible(msg.sender) {
        uint amount = deductFullBalance(0, msg.sender);

        emit EmergencyRelease(0, msg.sender, amount);

        msg.sender.transfer(amount);
    }

    function emergencyReleaseERC20Token(uint16 tokenCode) external emergencyReleasePossible(msg.sender) {
        uint amount = deductFullBalance(tokenCode, msg.sender);

        emit EmergencyRelease(tokenCode, msg.sender, amount);

        address tokenContract = tokenContracts[tokenCode];
        require (tokenContract != address(0), "Registered token contract.");

        require (safeTransfer(tokenContract, msg.sender, amount),
                 "Could not transfer ERC-20 tokens using transfer.");
    }

    // * Regular withdrawal (authorized by the trader, initiated and paid for by Counter)
    //   Requires trader approval of exchange contract.
    //   Resets ER.

    function withdrawEther(address traderAddr, address payable withdrawalAddr, uint amount) external
        onlyActive()
        onlyApprovedExchange(traderAddr) {

        deductBalance(0, traderAddr, amount);
        resetEmergencyRelease(traderAddr);

        emit Withdrawal(0, traderAddr, withdrawalAddr, amount);

        withdrawalAddr.transfer(amount);	//injected SHORT ADDRESS ATTACK

    }

    function withdrawERC20Token(uint16 tokenCode, address traderAddr, address withdrawalAddr, uint amount) external
        onlyActive()
        onlyApprovedExchange(traderAddr) {

        deductBalance(tokenCode, traderAddr, amount);
        resetEmergencyRelease(traderAddr);

        address tokenContract = tokenContracts[tokenCode];
        require (tokenContract != address(0), "Registered token contract.");

        require (safeTransfer(tokenContract, withdrawalAddr, amount),
                 "Could not transfer ERC-20 tokens using transfer.");

        emit Withdrawal(tokenCode, traderAddr, withdrawalAddr, amount);
    }

    // * Funds transfer between token accounts within Treasury
    //   Initiated and paid for by Counter as part of trade or withdrawal fee collection.
    //   Requires trader approval of exchange contract.
    //   There are three specializations to save gas on inter-contract method calls.
    //   Resets ER.

    // Case 1 - transfer tokens from one account to another
    // Example usecase: withdrawal fee collection
    function transferTokens(uint16 tokenCode, address fromAddr, address toAddr, uint amount) external
        onlyActive() onlyApprovedExchange(fromAddr) {

        resetEmergencyRelease(fromAddr);

        deductBalance(tokenCode, fromAddr, amount);
        addBalance(tokenCode, toAddr, amount);
    }

    // Case 2 - transfer tokens from one account to two accounts, splitting arbitrarily.
    function transferTokensTwice(uint16 tokenCode, address fromAddr, address toAddr1, uint amount1, address toAddr2, uint amount2) external
        onlyActive() onlyApprovedExchange(fromAddr) {

        resetEmergencyRelease(fromAddr);

        deductBalance(tokenCode, fromAddr, amount1 + amount2);

        addBalance(tokenCode, toAddr1, amount1);
        addBalance(tokenCode, toAddr2, amount2);
    }

    // Case 3 - transfer tokens of one type from A to B, tokens of another type from B to A,
    //          and deduct a fee from both transfers to a third account C.
    // Example usecase: any trade on Counter
    function exchangeTokens(
        uint16 tokenCode1, uint16 tokenCode2,
        address addr1, address addr2, address addrFee,
        uint amount1, uint fee1,
        uint amount2, uint fee2) external onlyActive() onlyApprovedExchangeBoth(addr1, addr2) {

        resetEmergencyRelease(addr1);
        resetEmergencyRelease(addr2);

        deductBalance(tokenCode1, addr1, amount1 + fee1);
        deductBalance(tokenCode2, addr2, amount2 + fee2);

        addBalance(tokenCode1, addr2, amount1);
        addBalance(tokenCode2, addr1, amount2);
        addBalance(tokenCode1, addrFee, fee1);
        addBalance(tokenCode2, addrFee, fee2);
    }

    // * Token account balance management routines.
    //   Construct uint176 ids, check for over- and underflows.

    function deductBalance(uint tokenCode, address addr, uint amount) private {
        uint176 tokenAccount = uint176(tokenCode) << 160 | uint176(addr);
        uint before = tokenAmounts[tokenAccount];
        require (before >= amount, "Enough funds.");
        tokenAmounts[tokenAccount] = before - amount;
    }

    function deductFullBalance(uint tokenCode, address addr) private returns (uint amount) {
        uint176 tokenAccount = uint176(tokenCode) << 160 | uint176(addr);
        amount = tokenAmounts[tokenAccount];
        tokenAmounts[tokenAccount] = 0;
    }

    function addBalance(uint tokenCode, address addr, uint amount) private {
        uint176 tokenAccount = uint176(tokenCode) << 160 | uint176(addr);
        uint before = tokenAmounts[tokenAccount];
        require (before + amount >= before, "No overflow.");
        tokenAmounts[tokenAccount] = before + amount;
    }

    // * Safe ERC-20 transfer() and transferFrom() invocations
    //   Work correctly with those tokens that do not return (bool success) and thus are not
    //   strictly speaking ERC-20 compatible, but unfortunately are quite widespread.

    function safeTransfer(address tokenContract, address to, uint value) internal returns (bool success)
    {
        // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
        (bool call_success, bytes memory return_data) = tokenContract.call(abi.encodeWithSelector(0xa9059cbb, to, value));

        success = false;

        if (call_success) {
            if (return_data.length == 0) {
                // transfer() doesn't have a return value
                success = true;

            } else if (return_data.length == 32) {
                // check returned bool
                assembly { success := mload(add(return_data, 0x20)) }
            }

        }
    }

    function safeTransferFrom(address tokenContract, address from, address to, uint value) internal returns (bool success)
    {
        // bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
        (bool call_success, bytes memory return_data) = tokenContract.call(abi.encodeWithSelector(0x23b872dd, from, to, value));

        success = false;

        if (call_success) {
            if (return_data.length == 0) {
                success = true;

            } else if (return_data.length == 32) {
                assembly { success := mload(add(return_data, 0x20)) }
            }

        }
    }

}