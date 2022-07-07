                                                                 

pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

interface IERC20 {
                                                                      
    function TOTALSUPPLY191() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF259(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER420(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE902(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE574(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM864(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER774(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL822(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}


contract Initializable {

                                                                       
  bool private initialized;

                                                                                         
  bool private initializing;

                                                                                
  modifier INITIALIZER61() {	//inject NONSTANDARD NAMING
    require(initializing || ISCONSTRUCTOR660() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

                                                                                 
  function ISCONSTRUCTOR660() private view returns (bool) {	//inject NONSTANDARD NAMING
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}


contract ContextUpgradeable is Initializable {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    function INITIALIZE27() virtual public INITIALIZER61 { }	//inject NONSTANDARD NAMING

    function _MSGSENDER667() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA252() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


contract OwnableUpgradeable is ContextUpgradeable {
    address private _owner;

    event OWNERSHIPTRANSFERRED786(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    function INITIALIZE27() override virtual public INITIALIZER61 {	//inject NONSTANDARD NAMING
        ContextUpgradeable.INITIALIZE27();

        address msgSender = _MSGSENDER667();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED786(address(0), msgSender);
    }

                                                                     
    function OWNER726() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER702() {	//inject NONSTANDARD NAMING
        require(_owner == _MSGSENDER667(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP65() public virtual ONLYOWNER702 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED786(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP548(address newOwner) public virtual ONLYOWNER702 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED786(_owner, newOwner);
        _owner = newOwner;
    }
}


library Account {
    struct Info {
        address owner; // The address that owns the account
        uint256 number; // A nonce that allows a single address to control many accounts
    }
}

library Actions {
    enum ActionType {
        Deposit, // supply tokens
        Withdraw, // borrow tokens
        Transfer, // transfer balance between accounts
        Buy, // buy an amount of some token (publicly)
        Sell, // sell an amount of some token (publicly)
        Trade, // trade tokens against another account
        Liquidate, // liquidate an undercollateralized or expiring account
        Vaporize, // use excess tokens to zero-out a completely negative account
        Call // send arbitrary data to an address
    }
    struct ActionArgs {
        ActionType actionType;
        uint256 accountId;
        Types.AssetAmount amount;
        uint256 primaryMarketId;
        uint256 secondaryMarketId;
        address otherAddress;
        uint256 otherAccountId;
        bytes data;
    }
}

library Types {
    enum AssetDenomination {
        Wei, // the amount is denominated in wei
        Par // the amount is denominated in par
    }

    enum AssetReference {
        Delta, // the amount is given as a delta from the current value
        Target // the amount is given as an exact number to end up at
    }

    struct AssetAmount {
        bool sign; // true if positive
        AssetDenomination denomination;
        AssetReference ref;
        uint256 value;
    }
 
    struct Par {
        bool sign; // true if positive
        uint128 value;
    }

    struct Wei {
        bool sign; // true if positive
        uint256 value;
    }
}

interface ISoloMargin {
    function OPERATE203(	//inject NONSTANDARD NAMING
        Account.Info[] memory accounts,
        Actions.ActionArgs[] memory actions
    ) external;

    function GETACCOUNTBALANCES476(Account.Info memory account)	//inject NONSTANDARD NAMING
        external view
        returns (
            address[] memory,
            Types.Par[] memory,
            Types.Wei[] memory
        );
}

contract dYdXWrapper is OwnableUpgradeable {
    IERC20 public constant dai94 = IERC20(	//inject NONSTANDARD NAMING
        0x6B175474E89094C44Da98b954EedeAC495271d0F
    );
    ISoloMargin public constant solomargin196 = ISoloMargin(	//inject NONSTANDARD NAMING
        0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e
    );

    function INITIALIZE27() public override INITIALIZER61 {	//inject NONSTANDARD NAMING
        OwnableUpgradeable.INITIALIZE27();
        dai94.APPROVE574(address(solomargin196), 100000e18);
    }

    function DEPOSIT959(uint256 value) external ONLYOWNER702 {	//inject NONSTANDARD NAMING
        Account.Info[] memory accounts = new Account.Info[](1);
        accounts[0] = Account.Info(address(this), 0);

        Actions.ActionArgs[] memory actions = new Actions.ActionArgs[](1);
        actions[0] = Actions.ActionArgs(
            Actions.ActionType.Deposit,
            0,
            Types.AssetAmount(
                true,
                Types.AssetDenomination.Wei,
                Types.AssetReference.Delta,
                value
            ),
            3,
            0,
            address(this),
            0,
            bytes("")
        );
        solomargin196.OPERATE203(accounts, actions);
    }

    function WITHDRAW104(uint256 value) external ONLYOWNER702 {	//inject NONSTANDARD NAMING
        Account.Info[] memory accounts = new Account.Info[](1);
        accounts[0] = Account.Info(address(this), 0);

        Actions.ActionArgs[] memory actions = new Actions.ActionArgs[](1);

        actions[0] = Actions.ActionArgs({
            actionType: Actions.ActionType.Withdraw,
            accountId: 0,
            amount: Types.AssetAmount({
                sign: false,
                denomination: Types.AssetDenomination.Wei,
                ref: Types.AssetReference.Delta,
                value: value
            }),
            primaryMarketId: 3,
            secondaryMarketId: 0,
            otherAddress: address(this),
            otherAccountId: 0,
            data: ""
        });
        solomargin196.OPERATE203(accounts, actions);
    }

    function ME244() public view returns (address) {	//inject NONSTANDARD NAMING
        return address(this);
    }

    function BALANCE490()	//inject NONSTANDARD NAMING
        external
        view
        returns (
            address[] memory,
            Types.Par[] memory,
            Types.Wei[] memory
        )
    {
        Account.Info memory account = Account.Info(address(this), 0);
        return solomargin196.GETACCOUNTBALANCES476(account);
    }
}