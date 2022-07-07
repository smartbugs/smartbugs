/**
 *Submitted for verification at Etherscan.io on 2020-10-12
*/

pragma solidity ^0.6.6;

contract Ownable {
  address internal owner;
  
  constructor() public {
      owner = msg.sender;
  }

  event OwnerUpdate(address _prevOwner, address _newOwner);

  modifier onlyOwner {
    assert(msg.sender == owner);
    _;
  }

  function transferOwnership(address _newOwner) public onlyOwner {
    require(_newOwner != owner, "Cannot transfer to yourself");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    owner = _newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
}

interface ERC20 {
    function balanceOf(address target) external returns (uint256);
    function approve(address spender, uint256 amount) external returns (uint256);
}
interface AragonFinance {
    function deposit(address _token, uint256 _amount, string calldata _reference) external;
}

interface Marketplace {
    function transferOwnership(address) external;
    function setOwnerCutPerMillion(uint256 _ownerCutPerMillion) external;
    function pause() external;
    function unpause() external;
}

contract MANACollect is Ownable {

    Marketplace internal marketplace;
    Marketplace internal bidMarketplace;
    AragonFinance internal aragonFinance;
    ERC20 internal mana;

    constructor(address manaAddress,
        address _marketAddress,
        address _bidAddress,
        address _aragonFinance
    ) public {
        mana = ERC20(manaAddress);
        marketplace = Marketplace(_marketAddress);
        bidMarketplace = Marketplace(_bidAddress);
        aragonFinance = AragonFinance(_aragonFinance);
    }

    function claimTokens() public {
        uint256 balance = mana.balanceOf(address(this));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        mana.approve(address(aragonFinance), balance);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        aragonFinance.deposit(address(mana), balance, "Fees collected from Marketplace");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function transferMarketplaceOwnership(address target) public onlyOwner {
        marketplace.transferOwnership(target);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function transferBidMarketplaceOwnership(address target) public onlyOwner {
        bidMarketplace.transferOwnership(target);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setOwnerCutPerMillion(uint256 _ownerCutPerMillion) public onlyOwner {
        marketplace.setOwnerCutPerMillion(_ownerCutPerMillion);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setBidOwnerCutPerMillion(uint256 _ownerCutPerMillion) public onlyOwner {
        bidMarketplace.setOwnerCutPerMillion(_ownerCutPerMillion);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function pause() public onlyOwner {
        marketplace.pause();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function unpause() public onlyOwner {
        marketplace.unpause();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function pauseBid() public onlyOwner {
        bidMarketplace.pause();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function unpauseBid() public onlyOwner {
        bidMarketplace.unpause();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}