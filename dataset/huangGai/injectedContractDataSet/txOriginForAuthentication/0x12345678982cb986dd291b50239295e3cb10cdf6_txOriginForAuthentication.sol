pragma solidity ^0.5.3;

// counter.market smart contracts:
//  1) Proxy - delegatecalls into current exchange code, maintains storage of exchange state
//  2) Registry (this one) - stores information on the latest exchange contract version and user approvals
//  3) Treasury - takes custody of funds, moves them between token accounts, authorizing exchange code via

// Counter contracts are deployed at predefined addresses which can be hardcoded.
contract FixedAddress {
    address constant ProxyAddress = 0x1234567896326230a28ee368825D11fE6571Be4a;
    address constant TreasuryAddress = 0x12345678979f29eBc99E00bdc5693ddEa564cA80;
    address constant RegistryAddress = 0x12345678982cB986Dd291B50239295E3Cb10Cdf6;
}

// External contracts access Registry via one of these methods
interface RegistryInterface {
    function getOwner() external view returns (address);
    function getExchangeContract() external view returns (address);
    function contractApproved(address traderAddr) external view returns (bool);
    function contractApprovedBoth(address traderAddr1, address traderAddr2) external view returns (bool);
    function acceptNextExchangeContract() external;
}

// Standard ownership semantics
contract Ownable {
    address public owner;
    address private nextOwner;

    event OwnershipTransfer(address newOwner, address previousOwner);

    modifier onlyOwner {
        require (tx.origin == owner, "onlyOwner methods called by non-owner.");	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }

    function approveNextOwner(address _nextOwner) external onlyOwner {
        require (_nextOwner != owner, "Cannot approve current owner.");
        nextOwner = _nextOwner;
    }

    function acceptNextOwner() external {
        require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
        emit OwnershipTransfer(nextOwner, owner);
        owner = nextOwner;
    }
}

contract Registry is FixedAddress, RegistryInterface, Ownable {

    // *** Variables

    // Current exchange contract and its version.
    // Version 0 means uninitialized Registry, first ever Exchange contract is
    // version 1 and the number increments from there.
    address public exchangeContract;
    uint private exchangeContractVersion;

    // Contract upgrades are preapproved by the Registry owner, and the new version
    // should accept the ownership transfer from its address. This means that Exchange
    // contracts should use deterministic addresses which can be determined beforehand.
    address private nextExchangeContract;

    // Previously used Exchange contracts cannot be used again - this prevents some
    // scenarios where Counter operator may use old digital signatures of traders
    // maliciously.
    mapping (address => bool) private prevExchangeContracts;

    // The very first Exchange contract (version 1) is unconditionally trusted, because
    // users can study it before depositing funds. Exchange contract upgrades, however, may
    // invalidate many assumptions, so we require that each trader explicitly approves the upgrade.
    // These approvals are checked by the (immutable) Treasury contract before moving funds, so
    // that it's impossible to compromise user funds by substituting Exchange contract with malicious
    // code.
    mapping (address => uint) private traderApprovals;

    // *** Events

    event UpgradeExchangeContract(address exchangeContract, uint exchangeContractVersion);
    event TraderApproveContract(address traderAddr, uint exchangeContractVersion);

    // *** Constructor

    constructor () public {
        owner = msg.sender;
        // exchangeContract, exchangeContractVersion are zero upon initialization
    }

    // *** Public getters

    function getOwner() external view returns (address) {
        return owner;
    }

    function getExchangeContract() external view returns (address) {
        return exchangeContract;
    }

    // *** Exchange contract upgrade (approve/accept pattern)

    function approveNextExchangeContract(address _nextExchangeContract) external onlyOwner {
        require (_nextExchangeContract != exchangeContract, "Cannot approve current exchange contract.");
        require (!prevExchangeContracts[_nextExchangeContract], "Cannot approve previously used contract.");
        nextExchangeContract = _nextExchangeContract;
    }

    function acceptNextExchangeContract() external {
        require (msg.sender == nextExchangeContract, "Can only accept preapproved exchange contract.");
        exchangeContract = nextExchangeContract;
        prevExchangeContracts[nextExchangeContract] = true;
        exchangeContractVersion++;

        emit UpgradeExchangeContract(exchangeContract, exchangeContractVersion);
    }

    // *** Trader approval for the new contract version.

    function traderApproveCurrentExchangeContract(uint _exchangeContractVersion) external {
        require (_exchangeContractVersion > 1, "First version doesn't need approval.");
        require (_exchangeContractVersion == exchangeContractVersion, "Can only approve the latest version.");
        traderApprovals[msg.sender] = _exchangeContractVersion;

        emit TraderApproveContract(msg.sender, _exchangeContractVersion);
    }

    // *** Methods to check approval of the contract upgrade (invoked by the Treasury)

    function contractApproved(address traderAddr) external view returns (bool) {
        if (exchangeContractVersion > 1) {
            return exchangeContractVersion == traderApprovals[traderAddr];

        } else {
            return exchangeContractVersion == 1;
        }
    }

    function contractApprovedBoth(address traderAddr1, address traderAddr2) external view returns (bool) {
        // This method is an optimization - it checks approval of two traders simultaneously to
        // save gas on an extra cross-contract method call.
        if (exchangeContractVersion > 1) {
            return
              exchangeContractVersion == traderApprovals[traderAddr1] &&
              exchangeContractVersion == traderApprovals[traderAddr2];

        } else {
            return exchangeContractVersion == 1;
        }
    }

}