/**
 *Submitted for verification at Etherscan.io on 2020-01-16
*/

pragma solidity 0.5.10;

/**
  * @author @veronicaLC (Veronica Coutts)
  * @title  The interface for the market factory
  */
interface IMarketFactory {
    /**
      * @notice Vyper cannot handle arrays of unknown length,
      *         and thus the funding goals and durations will
      *         only be stored in the vault, which is Solidity.
      * @dev    This function allows for the creation of a
      *         new market, consisting of a curve and vault
      * @param  _fundingGoals This is the amount wanting to be
      *         raised in each round, in collateral.
      * @param  _phaseDurations The time for each round in
      *         number of blocks.
      * @param	_creator Address of the researcher.
      * @param	_curveType Curve selected
      * @param	_feeRate The pecentage of fee. e.g: 60
      */
    function deployMarket(
        uint256[] calldata _fundingGoals,
        uint256[] calldata _phaseDurations,
        address _creator,
        uint256 _curveType,
        uint256 _feeRate
    )
        external;

    /**
      * @notice This function will only affect new markets, and will not update
      *         already created markets. This can only be called by an admin
      */
    function updateMoleculeVault(address _newMoleculeVault) external;

	/**
      * @return address: The address of the molecule vault
      */
    function moleculeVault() external view returns(address);

	/**
      * @return address: The contract address of the market registry.
      */
    function marketRegistry() external view returns(address);

	/**
      * @return address: The contract address of the curve registry
      */
    function curveRegistry() external view returns(address);

	/**
      * @return address: The contract address of the collateral token
      */
    function collateralToken() external view returns(address);
}


/**
  * @author @veronicaLC (Veronica Coutts) & @RyRy79261 (Ryan Nobel)
  * @title  The interface for the market registry.
  */
interface IMarketRegistry {
	// Emitted when a market is created
    event MarketCreated(
		uint256 index,
		address indexed marketAddress,
		address indexed vault,
		address indexed creator
    );
	// Emitted when a deployer is added
    event DeployerAdded(address deployer, string version);
    // Emitted when a deployer is removed
	event DeployerRemoved(address deployer, string reason);

    /**
      * @dev    Adds a new market deployer to the registry.
      * @param  _newDeployer: Address of the new market deployer.
      * @param  _version: string - Log text for tracking purposes.
      */
    function addMarketDeployer(
      address _newDeployer,
      string calldata _version
    ) external;

    /**
      * @dev    Removes a market deployer from the registry.
      * @param  _deployerToRemove: Address of the market deployer to remove.
      * @param  _reason: Log text for tracking purposes.
      */
    function removeMarketDeployer(
      address _deployerToRemove,
      string calldata _reason
    ) external;

    /**
      * @dev    Logs the market into the registery.
      * @param  _vault: Address of the vault.
      * @param  _creator: Creator of the market.
      * @return uint256: Returns the index of market for looking up.
      */
    function registerMarket(
        address _marketAddress,
        address _vault,
        address _creator
    )
        external
        returns(uint256);

    /**
      * @dev    Fetches all data and contract addresses of deployed
      *         markets by index, kept as interface for later
      *         intergration.
      * @param  _index: Index of the market.
      * @return address: The address of the market.
	  * @return	address: The address of the vault.
	  * @return	address: The address of the creator.
      */
    function getMarket(uint256 _index)
        external
        view
        returns(
            address,
            address,
            address
        );

	/**
	  * @dev	Fetchs the current number of markets infering maximum
	  *			callable index.
	  * @return	uint256: The number of markets that have been deployed.
	  */
    function getIndex() external view returns(uint256);

	/**
	  * @dev	Used to check if the deployer is registered.
      * @param  _deployer: The address of the deployer
	  * @return	bool: A simple bool to indicate state.
	  */
    function isMarketDeployer(address _deployer) external view returns(bool);

	/**
	  * @dev	In order to look up logs efficently, the published block is
	  *			available.
	  * @return	uint256: The block when the contract was published.
	  */
    function publishedBlocknumber() external view returns(uint256);
}


/**
  * @author @veronicaLC (Veronica Coutts) & @RyRy79261 (Ryan Nobel)
  * @title  The interface for the curve registry.
  */
interface ICurveRegistry {
	// Emitted when a curve is registered
    event CurveRegisterd(
        uint256 index,
        address indexed libraryAddress,
        string curveFunction
    );
	// Emitted when a curve is registered
    event CurveActivated(uint256 index, address indexed libraryAddress);
	// Emitted when a curve is deactivated
    event CurveDeactivated(uint256 index, address indexed libraryAddress);

    /**
      * @dev    Logs the market into the registery.
      * @param  _libraryAddress: Address of the library.
      * @param  _curveFunction: Curve title/statement.
      * @return uint256: Returns the index of market for looking up
      */
    function registerCurve(
        address _libraryAddress,
        string calldata _curveFunction)
        external
        returns(uint256);

    /**
      * @notice Allows an dmin to set a curves state to inactive. This function
      *         is for the case of an incorect curve module, or vunrability.
      * @param  _index: The index of the curve to be set as inactive.
      */
    function deactivateCurve(uint256 _index) external;

    /**
      * @notice Allows an admin to set a curves state to active.
      * @param  _index: The index of the curve to be set as active.
      */
    function reactivateCurve(uint256 _index) external;

    /**
      * @dev    Fetches all data and contract addresses of deployed curves by
      *         index, kept as interface for later intergration.
      * @param  _index: Index of the curve library
      * @return address: The address of the curve
      */
    function getCurveAddress(uint256 _index)
        external
        view
        returns(address);

    /**
      * @dev    Fetches all data and contract addresses of deployed curves by
      *         index, kept as interface for later intergration.
      * @param  _index: Index of the curve library.
      * @return address: The address of the math library.
      * @return string: The function of the curve.
      * @return bool: The curves active state.
      */
    function getCurveData(uint256 _index)
        external
        view
        returns(
            address,
            string memory,
            bool
        );

    /**
      * @dev    Fetchs the current number of curves infering maximum callable
      *         index.
      * @return uint256: Returns the total number of curves registered.
      */
    function getIndex()
        external
        view
        returns(uint256);

    /**
      * @dev    In order to look up logs efficently, the published block is
      *         available.
      * @return uint256: The block when the contract was published
      */
    function publishedBlocknumber() external view returns(uint256);
}

/**
  * @author @veronicaLC (Veronica Coutts) & @RyRy79261 (Ryan Nobel)
  * @title  The interface for the molecule vault
  */
interface IMoleculeVault {

    /**
      * @notice Allows an admin to add another admin.
      * @param  _moleculeAdmin: The address of the new admin.
      */
    function addAdmin(address _moleculeAdmin) external;
    
    /**
      * @notice Allows an admin to transfer colalteral out of the molecule
      *         vault and into another address.
      * @param  _to: The address that the collateral will be transfered to.
      * @param  _amount: The amount of collateral being transfered.
      */
    function transfer(address _to, uint256 _amount) external;

    /**
      * @notice Allows an admin to approve a spender of the molecule vault
      *         collateral.
      * @param  _spender: The address that will be aproved as a spender.
      * @param  _amount: The amount the spender will be approved to spend.
      */
    function approve(address _spender, uint256 _amount) external;

    /**
      * @notice Allows the admin to update the fee rate charged by the
      *         molecule vault.
      * @param  _newFeeRate : The new fee rate.
      * @return bool: If the update was successful
      */
    function updateFeeRate(uint256 _newFeeRate) external returns(bool);

    /**
      * @return address: The address of the collateral token.
      */
    function collateralToken() external view returns(address);

    /**
      * @return uint256 : The fee rate the molecule vault has.
      */
    function feeRate() external view returns(uint256);
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        //require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}


/**
  * @author @veronicaLC (Veronica Coutts) & @RyRy79261 (Ryan Nobel)
  * @title Market
  */
interface IMarket {
	// Emitted when a spender is approved
    event Approval(
      address indexed owner,
      address indexed spender,
      uint256 value
    );
    // Emitted when a transfer, mint or burn occurs
    event Transfer(address indexed from, address indexed to, uint value);
    // Emitted when tokens are minted
    event Mint(
      address indexed to,			// The address reciving the tokens
      uint256 amountMinted,			// The amount of tokens minted
      uint256 collateralAmount,		// The amount of DAI spent
      uint256 researchContribution	// The tax donatedd (in DAI)
    );
    // Emitted when tokens are burnt
    event Burn(
      address indexed from,			// The address burning the tokens
      uint256 amountBurnt,			// The amount of tokens burnt
      uint256 collateralReturned	//  DAI being recived (in DAI)
    );
	// Emitted when the market is terminated
    event MarketTerminated();

    /**
      * @notice Approves transfers for a given address.
      * @param  _spender : The account that will receive the funds.
      * @param  _value : The value of funds accessed.
      * @return boolean : Indicating the action was successful.
      */
    function approve(address _spender, uint256 _value) external returns (bool);

     /**
      * @dev    Selling tokens back to the bonding curve for collateral.
      * @param  _numTokens: The number of tokens that you want to burn.
      */
    function burn(uint256 _numTokens) external returns(bool);

    /**
      * @dev	We have modified the minting function to divert a portion of the
      *         collateral for the purchased tokens to the vault.
      * @param  _to : Address to mint tokens to.
      * @param  _numTokens : The number of tokens you want to mint.
      */
    function mint(address _to, uint256 _numTokens) external returns(bool);

    /**
      * @notice Transfer ownership token from msg.sender to a specified address.
      * @param  _to : The address to transfer to.
      * @param  _value : The amount to be transferred.
      */
    function transfer(address _to, uint256 _value) external returns (bool);

    /**
      * @notice Transfer tokens from one address to another.
      * @param  _from: The address which you want to send tokens from.
      * @param  _to: The address which you want to transfer to.
      * @param  _value: The amount of tokens to be transferred.
      */
    function transferFrom(
		address _from,
		address _to,
		uint256 _value
	)
		external
		returns(bool);

    /**
	  * @notice	Can only be called by this markets vault
      * @dev    Allows the market to end once all funds have been raised.
      *         Ends the market so that no more tokens can be bought or sold.
	  *			Tokens can still be transfered, or "withdrawn" for an enven
	  *			distribution of remaining collateral.
      */
    function finaliseMarket() external returns(bool);

    /**
      * @dev    Allows token holders to withdraw collateral in return for tokens
      * 		after the market has been finalised.
      * @param 	_amount: The amount of tokens they want to withdraw
      */
    function withdraw(uint256 _amount) external returns(bool);

    /**
	  * @dev	Returns the required collateral amount for a volume of bonding
	  *			curve tokens
	  * @param	_numTokens: The number of tokens to calculate the price of
      * @return uint256 : The required collateral amount for a volume of bonding
      *         curve tokens.
      */
    function priceToMint(uint256 _numTokens) external view returns(uint256);

    /**
	  * @dev	Returns the required collateral amount for a volume of bonding
	  *			curve tokens
	  * @param	_numTokens: The number of tokens to work out the collateral
	  *			vaule of
      * @return uint256: The required collateral amount for a volume of bonding
      *         curve tokens
      */
    function rewardForBurn(uint256 _numTokens) external view returns(uint256);

    /**
      * @notice This function returns the amount of tokens one can receive for a
      *         specified amount of collateral token. Including molecule &
	  *			market contributions
      * @param  _collateralTokenOffered: Amount of reserve token offered for
      *         purchase
      * @return uint256: The amount of tokens one can purchase with the
      *         specified collateral
      */
    function collateralToTokenBuying(
		uint256 _collateralTokenOffered
	)
		external
		view
		returns(uint256);

    /**
      * @notice This function returns the amount of tokens needed to be burnt to
      *         withdraw a specified amount of reserve token.
      * @param  _collateralTokenNeeded: Amount of dai to be withdraw.
	  * @return	uint256: The amount of tokens needed to burn to reach goal
	  *			colalteral
      */
    function collateralToTokenSelling(
		uint256 _collateralTokenNeeded
	)
		external
		view
		returns(uint256);

    /**
      * @notice Gets the value of the current allowance specifed for that
      *         account.
      * @param  _owner: The account sending the funds.
      * @param  _spender: The account that will receive the funds.
	  * @return	uint256: representing the amount the spender can spend
      */
    function allowance(
		address _owner,
		address _spender
	)
		external
		view
		returns(uint256);

    /**
      * @notice Gets the balance of the specified address.
      * @param  _owner: The address to query the the balance of.
      * @return  uint256: Represents the amount owned by the passed address.
      */
    function balanceOf(address _owner) external view returns (uint256);

    /**
      * @notice Total collateral backing the curve.
      * @return uint256: Represents the total collateral backing the curve.
      */
    function poolBalance() external view returns (uint256);

    /**
      * @notice Total number of tokens in existence
      * @return uint256: Represents the total supply of tokens in this market.
      */
    function totalSupply() external view returns (uint256);

    /**
      * @dev 	The rate of fee (%) the market pays towards the vault on token
	    *			  purchases.
      */
    function feeRate() external view returns(uint256);

    /**
      * @return	uint256: The decimals set for the market
      */
    function decimals() external view returns(uint256);

    /**
      * @return	bool: The active stat of the market. Inactive markets have
	    *			    ended.
      */
    function active() external view returns(bool);
}


/**
  * @author @veronicaLC (Veronica Coutts) & @RyRy79261 (Ryan Nobel)
  * @title  Storage and collection of market tax.
  * @notice The vault stores the tax from the market until the funding goal is
  *         reached, thereafter the creator may withdraw the funds. If the
  *         funding is not reached within the stipulated time-frame, or the
  *         creator terminates the market, the funding is sent back to the
  *         market to be re-distributed.
  * @dev    The vault pulls the mol tax directly from the molecule vault.
  */
interface IVault {
	// States for each funding round
	enum FundingState { NOT_STARTED, STARTED, ENDED, PAID }
	// Emitted when funding is withdrawn by the creator
	event FundingWithdrawn(uint256 phase, uint256 amount);
	// Emitted when a phase has been successfully filled
	event PhaseFinalised(uint256 phase, uint256 amount);

   	/**
      * @dev    Initialized the contract, sets up owners and gets the market
      *         address. This function exists because the Vault does not have
      *         an address until the constructor has finished running. The
      *         cumulative funding threshold is set here because of gas issues
      *         within the constructor.
      * @param _market: The market that will be sending this vault it's
      *         collateral.
      */
    function initialize(address _market) external returns(bool);

    /**
	  * @notice	AAllows the creator to withdraw the various phases as they are
	  *			completed.
      * @return bool: The funding has successfully been transferred.
	  */
    function withdraw() external returns(bool);

    /**
      * @notice	Verifies that the phase passed in: has not been withdrawn,
	  *			funding goal has been reached, and that the phase has not
	  *			expired. Adds fee amount to the vault pool.
      * @param  _receivedFunding: The amount of funding recived
      * @return bool: Wheather or not the funding is valid
      */
    function validateFunding(uint256 _receivedFunding) external returns(bool);

	/**
      * @dev    This function sends the vaults funds to the market, and sets the
      *         outstanding withdraw to 0.
      * @notice If this function is called before the end of all phases, all
      *         unclaimed (outstanding) funding will be sent to the market to be
      *         redistributed.
      */
    function terminateMarket() external;

	/**
      * @notice Returns all the details (relavant to external code) for a
      *         specific phase.
      * @param  _phase: The phase that you want the information of
      * @return uint256: The funding goal (including mol tax) of the round
      * @return uint256: The amount of funding currently raised for the round
      * @return uint256: The duration of the phase
      * @return uint256: The timestamp of the start date of the round
      * @return FundingState: The enum state of the round (see IVault)
      */
    function fundingPhase(
      uint256 _phase
    )
		external
		view
		returns(
			uint256,
			uint256,
			uint256,
			uint256,
			FundingState
		);

	/**
	  * @return	uint256: The amount of funding that the creator has earned by
	  *			not withdrawn.
	  */
    function outstandingWithdraw() external view returns(uint256);

	/**
      * @dev    The current active phase of funding
      * @return uint256: The current phase the project is in.
      */
    function currentPhase() external view returns(uint256);

	/**
      * @return uint256: The total number of rounds for this project.
      */
    function getTotalRounds() external view returns(uint256);

	/**
	  * @return	address: The address of the market that is funding this vault.
	  */
    function market() external view returns(address);

	/**
	  * @return	address: The address of the creator of this project.
	  */
    function creator() external view returns(address);
}

/**
  * @author @veronicaLC (Veronica Coutts) & @BenSchZA (Ben Scholtz)
  * @title  The interface for the curve functions.
  */
interface ICurveFunctions {
    /**
      * @dev    Calculates the definite integral of the curve
      * @param  _x : Token value for upper limit of definite integral
      */
    function curveIntegral(uint256 _x) external pure returns(uint256);

    /**
      * @dev    Calculates the definite inverse integral of the curve
      * @param  _x : collateral value for upper limit of definite integral
      */
    function inverseCurveIntegral(uint256 _x) external pure returns(uint256);
}


// ----------------------------------------------------------------------------
// BokkyPooBah's DateTime Library v1.00
//
// A gas-efficient Solidity date and time library
//
// https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
//
// Tested date range 1970/01/01 to 2345/12/31
//
// Conventions:
// Unit      | Range         | Notes
// :-------- |:-------------:|:-----
// timestamp | >= 0          | Unix timestamp, number of seconds since 1970/01/01 00:00:00 UTC
// year      | 1970 ... 2345 |
// month     | 1 ... 12      |
// day       | 1 ... 31      |
// hour      | 0 ... 23      |
// minute    | 0 ... 59      |
// second    | 0 ... 59      |
// dayOfWeek | 1 ... 7       | 1 = Monday, ..., 7 = Sunday
//
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018.
//
// GNU Lesser General Public License 3.0
// https://www.gnu.org/licenses/lgpl-3.0.en.html
// ----------------------------------------------------------------------------

library BokkyPooBahsDateTimeLibrary {

    uint256  constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint256  constant SECONDS_PER_HOUR = 60 * 60;
    uint256  constant SECONDS_PER_MINUTE = 60;
    int256 constant OFFSET19700101 = 2440588;

    uint256  constant DOW_MON = 1;
    uint256  constant DOW_TUE = 2;
    uint256  constant DOW_WED = 3;
    uint256  constant DOW_THU = 4;
    uint256  constant DOW_FRI = 5;
    uint256  constant DOW_SAT = 6;
    uint256  constant DOW_SUN = 7;

    // ------------------------------------------------------------------------
    // Calculate the number of days from 1970/01/01 to year/month/day using
    // the date conversion algorithm from
    //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
    // and subtracting the offset 2440588 so that 1970/01/01 is day 0
    //
    // days = day
    //      - 32075
    //      + 1461 * (year + 4800 + (month - 14) / 12) / 4
    //      + 367 * (month - 2 - (month - 14) / 12 * 12) / 12
    //      - 3 * ((year + 4900 + (month - 14) / 12) / 100) / 4
    //      - offset
    // ------------------------------------------------------------------------
    function _daysFromDate(uint256  year, uint256  month, uint256  day) internal pure returns (uint256  _days) {
        require(year >= 1970, "Epoch error");
        int256 _year = int256(year);
        int256 _month = int256(month);
        int256 _day = int256(day);

        int256 __days = _day
          - 32075
          + 1461 * (_year + 4800 + (_month - 14) / 12) / 4
          + 367 * (_month - 2 - (_month - 14) / 12 * 12) / 12
          - 3 * ((_year + 4900 + (_month - 14) / 12) / 100) / 4
          - OFFSET19700101;

        _days = uint256 (__days);
    }

    // ------------------------------------------------------------------------
    // Calculate year/month/day from the number of days since 1970/01/01 using
    // the date conversion algorithm from
    //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
    // and adding the offset 2440588 so that 1970/01/01 is day 0
    //
    // int256 L = days + 68569 + offset
    // int256 N = 4 * L / 146097
    // L = L - (146097 * N + 3) / 4
    // year = 4000 * (L + 1) / 1461001
    // L = L - 1461 * year / 4 + 31
    // month = 80 * L / 2447
    // dd = L - 2447 * month / 80
    // L = month / 11
    // month = month + 2 - 12 * L
    // year = 100 * (N - 49) + year + L
    // ------------------------------------------------------------------------
    function _daysToDate(uint256  _days) internal pure returns (uint256  year, uint256  month, uint256  day) {
        int256 __days = int256(_days);

        int256 L = __days + 68569 + OFFSET19700101;
        int256 N = 4 * L / 146097;
        L = L - (146097 * N + 3) / 4;
        int256 _year = 4000 * (L + 1) / 1461001;
        L = L - 1461 * _year / 4 + 31;
        int256 _month = 80 * L / 2447;
        int256 _day = L - 2447 * _month / 80;
        L = _month / 11;
        _month = _month + 2 - 12 * L;
        _year = 100 * (N - 49) + _year + L;

        year = uint256 (_year);
        month = uint256 (_month);
        day = uint256 (_day);
    }

    function timestampFromDate(uint256  year, uint256  month, uint256  day) internal pure returns (uint256  timestamp) {
        timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY;
    }
    function timestampFromDateTime(uint256  year, uint256  month, uint256  day, uint256  hour, uint256  minute, uint256  second) internal pure returns (uint256  timestamp) {
        timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + hour * SECONDS_PER_HOUR + minute * SECONDS_PER_MINUTE + second;
    }
    function timestampToDate(uint256  timestamp) internal pure returns (uint256  year, uint256  month, uint256  day) {
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function timestampToDateTime(uint256  timestamp) internal pure returns (uint256  year, uint256  month, uint256  day, uint256  hour, uint256  minute, uint256  second) {
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        uint256  secs = timestamp % SECONDS_PER_DAY;
        hour = secs / SECONDS_PER_HOUR;
        secs = secs % SECONDS_PER_HOUR;
        minute = secs / SECONDS_PER_MINUTE;
        second = secs % SECONDS_PER_MINUTE;
    }

    function isValidDate(uint256  year, uint256  month, uint256  day) internal pure returns (bool valid) {
        if (year >= 1970 && month > 0 && month <= 12) {
            uint256  daysInMonth = _getDaysInMonth(year, month);
            if (day > 0 && day <= daysInMonth) {
                valid = true;
            }
        }
    }
    function isValidDateTime(uint256  year, uint256  month, uint256  day, uint256  hour, uint256  minute, uint256  second) internal pure returns (bool valid) {
        if (isValidDate(year, month, day)) {
            if (hour < 24 && minute < 60 && second < 60) {
                valid = true;
            }
        }
    }
    function isLeapYear(uint256  timestamp) internal pure returns (bool leapYear) {
        uint256  year;
        uint256  month;
        uint256  day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        leapYear = _isLeapYear(year);
    }
    function _isLeapYear(uint256  year) internal pure returns (bool leapYear) {
        leapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
    }
    function isWeekDay(uint256  timestamp) internal pure returns (bool weekDay) {
        weekDay = getDayOfWeek(timestamp) <= DOW_FRI;
    }
    function isWeekEnd(uint256  timestamp) internal pure returns (bool weekEnd) {
        weekEnd = getDayOfWeek(timestamp) >= DOW_SAT;
    }
    function getDaysInMonth(uint256  timestamp) internal pure returns (uint256  daysInMonth) {
        uint256  year;
        uint256  month;
        uint256  day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        daysInMonth = _getDaysInMonth(year, month);
    }
    function _getDaysInMonth(uint256  year, uint256  month) internal pure returns (uint256  daysInMonth) {
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
            daysInMonth = 31;
        } else if (month != 2) {
            daysInMonth = 30;
        } else {
            daysInMonth = _isLeapYear(year) ? 29 : 28;
        }
    }
    // 1 = Monday, 7 = Sunday
    function getDayOfWeek(uint256  timestamp) internal pure returns (uint256  dayOfWeek) {
        uint256  _days = timestamp / SECONDS_PER_DAY;
        dayOfWeek = (_days + 3) % 7 + 1;
    }

    function getYear(uint256  timestamp) internal pure returns (uint256  year) {
        uint256  month;
        uint256  day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function getMonth(uint256  timestamp) internal pure returns (uint256  month) {
        uint256  year;
        uint256  day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function getDay(uint256  timestamp) internal pure returns (uint256  day) {
        uint256  year;
        uint256  month;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function getHour(uint256  timestamp) internal pure returns (uint256  hour) {
        uint256  secs = timestamp % SECONDS_PER_DAY;
        hour = secs / SECONDS_PER_HOUR;
    }
    function getMinute(uint256  timestamp) internal pure returns (uint256  minute) {
        uint256  secs = timestamp % SECONDS_PER_HOUR;
        minute = secs / SECONDS_PER_MINUTE;
    }
    function getSecond(uint256  timestamp) internal pure returns (uint256  second) {
        second = timestamp % SECONDS_PER_MINUTE;
    }

    function addYears(uint256  timestamp, uint256  _years) internal pure returns (uint256  newTimestamp) {
        uint256  year;
        uint256  month;
        uint256  day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        year += _years;
        uint256  daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        assert(newTimestamp >= timestamp);
    }
    function addMonths(uint256  timestamp, uint256  _months) internal pure returns (uint256  newTimestamp) {
        uint256  year;
        uint256  month;
        uint256  day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        month += _months;
        year += (month - 1) / 12;
        month = (month - 1) % 12 + 1;
        uint256  daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        assert(newTimestamp >= timestamp);
    }
    function addDays(uint256  timestamp, uint256  _days) internal pure returns (uint256  newTimestamp) {
        newTimestamp = timestamp + _days * SECONDS_PER_DAY;
        assert(newTimestamp >= timestamp);
    }
    function addHours(uint256  timestamp, uint256  _hours) internal pure returns (uint256  newTimestamp) {
        newTimestamp = timestamp + _hours * SECONDS_PER_HOUR;
        assert(newTimestamp >= timestamp);
    }
    function addMinutes(uint256  timestamp, uint256  _minutes) internal pure returns (uint256  newTimestamp) {
        newTimestamp = timestamp + _minutes * SECONDS_PER_MINUTE;
        require(newTimestamp >= timestamp);
    }
    function addSeconds(uint256  timestamp, uint256  _seconds) internal pure returns (uint256  newTimestamp) {
        newTimestamp = timestamp + _seconds;
        assert(newTimestamp >= timestamp);
    }

    function subYears(uint256  timestamp, uint256  _years) internal pure returns (uint256  newTimestamp) {
        uint256  year;
        uint256  month;
        uint256  day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        year -= _years;
        uint256  daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        assert(newTimestamp <= timestamp);
    }
    function subMonths(uint256  timestamp, uint256  _months) internal pure returns (uint256  newTimestamp) {
        uint256  year;
        uint256  month;
        uint256  day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        uint256  yearMonth = year * 12 + (month - 1) - _months;
        year = yearMonth / 12;
        month = yearMonth % 12 + 1;
        uint256  daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        assert(newTimestamp <= timestamp);
    }
    function subDays(uint256  timestamp, uint256  _days) internal pure returns (uint256  newTimestamp) {
        newTimestamp = timestamp - _days * SECONDS_PER_DAY;
        assert(newTimestamp <= timestamp);
    }
    function subHours(uint256  timestamp, uint256  _hours) internal pure returns (uint256  newTimestamp) {
        newTimestamp = timestamp - _hours * SECONDS_PER_HOUR;
        assert(newTimestamp <= timestamp);
    }
    function subMinutes(uint256  timestamp, uint256  _minutes) internal pure returns (uint256  newTimestamp) {
        newTimestamp = timestamp - _minutes * SECONDS_PER_MINUTE;
        assert(newTimestamp <= timestamp);
    }
    function subSeconds(uint256  timestamp, uint256  _seconds) internal pure returns (uint256  newTimestamp) {
        newTimestamp = timestamp - _seconds;
        assert(newTimestamp <= timestamp);
    }

    function diffYears(uint256  fromTimestamp, uint256  toTimestamp) internal pure returns (uint256  _years) {
        require(fromTimestamp <= toTimestamp);
        uint256  fromYear;
        uint256  fromMonth;
        uint256  fromDay;
        uint256  toYear;
        uint256  toMonth;
        uint256  toDay;
        (fromYear, fromMonth, fromDay) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
        (toYear, toMonth, toDay) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
        _years = toYear - fromYear;
    }
    function diffMonths(uint256  fromTimestamp, uint256  toTimestamp) internal pure returns (uint256  _months) {
        require(fromTimestamp <= toTimestamp);
        uint256  fromYear;
        uint256  fromMonth;
        uint256  fromDay;
        uint256  toYear;
        uint256  toMonth;
        uint256  toDay;
        (fromYear, fromMonth, fromDay) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
        (toYear, toMonth, toDay) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
        _months = toYear * 12 + toMonth - fromYear * 12 - fromMonth;
    }
    function diffDays(uint256  fromTimestamp, uint256  toTimestamp) internal pure returns (uint256  _days) {
        require(fromTimestamp <= toTimestamp);
        _days = (toTimestamp - fromTimestamp) / SECONDS_PER_DAY;
    }
    function diffHours(uint256  fromTimestamp, uint256  toTimestamp) internal pure returns (uint256  _hours) {
        require(fromTimestamp <= toTimestamp);
        _hours = (toTimestamp - fromTimestamp) / SECONDS_PER_HOUR;
    }
    function diffMinutes(uint256  fromTimestamp, uint256  toTimestamp) internal pure returns (uint256  _minutes) {
        require(fromTimestamp <= toTimestamp);
        _minutes = (toTimestamp - fromTimestamp) / SECONDS_PER_MINUTE;
    }
    function diffSeconds(uint256  fromTimestamp, uint256  toTimestamp) internal pure returns (uint256  _seconds) {
        require(fromTimestamp <= toTimestamp);
        _seconds = toTimestamp - fromTimestamp;
    }
}

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}






/**
  * @author @veronicaLC (Veronica Coutts) & @RyRy79261 (Ryan Nobel)
  * @title  Creation and storage of project tokens, fills vault with fee.
  * @notice The market will send a portion of all collateral on mint to the
  *         vault to fill the funding rounds.
  * @dev    Checks with vault on every mint to ensure rounds are still active,
  *         goal has not been met, and that the round has not expired.
  */
contract Market is IMarket, IERC20 {
    // For math functions with overflow & underflow checks
    using SafeMath for uint256;

    // Allows market to be deactivated after funding
    bool internal active_ = true;
    // Vault that recives fee
    IVault internal creatorVault_;
    // Percentage of vault fee e.g. 20
    uint256 internal feeRate_;
    // Address of curve function
    ICurveFunctions internal curveLibrary_;
    // Underlying collateral token
    IERC20 internal collateralToken_;
    // Total minted tokens
    uint256 internal totalSupply_;
    // Decimal accuracy of token
    uint256 internal decimals_ = 18;

    // Allowances for spenders
    mapping(address => mapping (address => uint256)) internal allowed;
    // Balances of token holders
    mapping(address => uint256) internal balances;

    /**
	  * @notice	Sets the needed variables for the market
      * @param  _feeRate : The percentage for the fee i.e 20
      * @param  _creatorVault : The vault for fee to go to
      * @param  _curveLibrary : Math module.
      * @param  _collateralToken : The ERC20 collateral tokem
      */
    constructor(
        uint256 _feeRate,
        address _creatorVault,
        address _curveLibrary,
        address _collateralToken
    )
        public
    {
        // Sets the storage variables
        feeRate_ = _feeRate;
        creatorVault_ = IVault(_creatorVault);
        curveLibrary_ = ICurveFunctions(_curveLibrary);
        collateralToken_ = IERC20(_collateralToken);
    }

    /**
      * @notice Ensures the market's key functionality is only available when
      *         the market is active.
      */
    modifier onlyActive(){
        require(active_, "Market inactive");
        _;
    }

    /**
      * @notice Enaures a function is only callable by the vault.
      */
    modifier onlyVault(){
        require(msg.sender == address(creatorVault_), "Invalid requestor");
        _;
    }

    /**
      * @dev    Selling tokens back to the bonding curve for collateral.
      * @param  _numTokens: The number of tokens that you want to burn.
      */
    function burn(uint256 _numTokens) external onlyActive() returns(bool) {
        require(
            balances[msg.sender] >= _numTokens,
            "Not enough tokens available"
        );

        uint256 reward = rewardForBurn(_numTokens);

        totalSupply_ = totalSupply_.sub(_numTokens);	//injected INTEGER OVERFLOW OR UNDERFLOW

        balances[msg.sender] = balances[msg.sender].sub(_numTokens);	//injected INTEGER OVERFLOW OR UNDERFLOW


        require(
            collateralToken_.transfer(
                msg.sender,
                reward
            ),
            "Tokens not sent"
        );

        emit Transfer(msg.sender, address(0), _numTokens);
        emit Burn(msg.sender, _numTokens, reward);
        return true;
    }

    /**
      * @dev	We have modified the minting function to divert a portion of the
      *         collateral for the purchased tokens to the vault. 
      * @notice If a mint transaction exceeded the needed funding for the last
      *         round, the excess funds WILL NOT BE RETURNED TO SENDER. The
      *         Molecule Catalyst front end prevents this.
      *         The curve intergral code will reject any values that are too
      *         small or large, that could result in over/under flows.
      * @param  _to : Address to mint tokens to.
      * @param  _numTokens : The number of tokens you want to mint.
      */
    function mint(
        address _to,
        uint256 _numTokens
    )
        external
        onlyActive()
        returns(bool)
    {
        // Gets the price (in collateral) for the tokens
        uint256 priceForTokens = priceToMint(_numTokens);
        
        // Ensures there is no overflow
        require(priceForTokens > 0, "Tokens requested too low");

        // Works out how much fee needs to be sent to the vault
        uint256 fee = priceForTokens.mul(feeRate_).div(100);
        // Sends the collateral from the buyer to this market
        require(
            collateralToken_.transferFrom(
                msg.sender,
                address(this),
                priceForTokens
            ),
            "Collateral transfer failed"
        );
        // Sends the fee to the vault
        require(
            collateralToken_.transfer(
                address(creatorVault_),
                fee
            ),
            "Vault fee not transferred"
        );

        // Adds the tokens to the total supply
        totalSupply_ = totalSupply_.add(_numTokens);	//injected INTEGER OVERFLOW OR UNDERFLOW

        // Adds the tokens to the balance of the buyer
        balances[msg.sender] = balances[msg.sender].add(_numTokens);	//injected INTEGER OVERFLOW OR UNDERFLOW

        // Validates the funding with the vault
        require(
            creatorVault_.validateFunding(fee),
            "Funding validation failed"
        );
        // Works out the vaule of the tokens without the fee
        uint256 priceWithoutFee = priceForTokens.sub(fee);

        emit Transfer(address(0), _to, _numTokens);
        emit Mint(_to, _numTokens, priceWithoutFee, fee);
        return true;
    }

	    /**
      * @notice This function returns the amount of tokens one can receive for a
      *         specified amount of collateral token.
      * @param  _collateralTokenOffered : Amount of reserve token offered for
      *         purchase.
      * @return uint256 : The amount of tokens once can purchase with the
      *         specified collateral.
      */
    function collateralToTokenBuying(
        uint256 _collateralTokenOffered
    )
        external
        view
        returns(uint256)
    {
        // Works out the amount of collateral for fee
        uint256 fee = _collateralTokenOffered.mul(feeRate_).div(100);
        // Removes the fee amount from the collateral offered
        uint256 amountLessFee = _collateralTokenOffered.sub(fee);
        // Works out the inverse curve of the pool with the fee removed amount
        return _inverseCurveIntegral(
                _curveIntegral(totalSupply_).add(amountLessFee)
            ).sub(totalSupply_);
    }

    /**
      * @notice This function returns the amount of tokens needed to be burnt to
      *         withdraw a specified amount of reserve token.
      * @param  _collateralTokenNeeded : Amount of dai to be withdraw.
      */
    function collateralToTokenSelling(
        uint256 _collateralTokenNeeded
    )
        external
        view
        returns(uint256)
    {
        return uint256(
            totalSupply_.sub(
                _inverseCurveIntegral(
                    _curveIntegral(totalSupply_).sub(_collateralTokenNeeded)
                )
            )
        );
    }

    /**
      * @notice Total collateral backing the curve.
      * @return uint256 : Represents the total collateral backing the curve.
      */
    function poolBalance() external view returns (uint256){
        return collateralToken_.balanceOf(address(this));
    }

    /**
      * @dev 	The rate of fee the market pays towards the vault on token
	  *         purchases.
      */
    function feeRate() external view returns(uint256) {
        return feeRate_;
    }

    /**
      * @return	uint256 : The decimals set for the market
      */
    function decimals() external view returns(uint256) {
        return decimals_;
    }

    /**
      * @return	bool : The active stat of the market. Inactive markets have
	  *         ended.
      */
    function active() external view returns(bool){
        return active_;
    }

    /**
	  * @notice	Can only be called by this markets vault
      * @dev    Allows the market to end once all funds have been raised.
      *         Ends the market so that no more tokens can be bought or sold.
	  *			Tokens can still be transfered, or "withdrawn" for an enven
	  *			distribution of remaining collateral.
      */
    function finaliseMarket() public onlyVault() returns(bool) {
        require(active_, "Market deactivated");
        active_ = false;
        emit MarketTerminated();
        return true;
    }

    /**
      * @dev    Allows token holders to withdraw collateral in return for tokens
      * 		after the market has been finalised.
      * @param 	_amount: The amount of tokens they want to withdraw
      */
    function withdraw(uint256 _amount) public returns(bool) {
        // Ensures withdraw can only be called in an inactive market
        require(!active_, "Market not finalised");
        // Ensures the sender has enough tokens
        require(_amount <= balances[msg.sender], "Insufficient funds");
        // Ensures there are no anomaly withdraws that might break calculations
        require(_amount > 0, "Cannot withdraw 0");

        // Removes amount from user balance
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        // Gets the balance of the market (vault may send excess funding)
        uint256 balance = collateralToken_.balanceOf(address(this));

        // Performs a flat linear 100% collateralized sale
        uint256 collateralToTransfer = balance.mul(_amount).div(totalSupply_);
        // Removes token amount from the total supply
        totalSupply_ = totalSupply_.sub(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW


        // Ensures the sender is sent their collateral amount
        require(
            collateralToken_.transfer(msg.sender, collateralToTransfer),
            "Dai transfer failed"
        );

        emit Transfer(msg.sender, address(0), _amount);
        emit Burn(msg.sender, _amount, collateralToTransfer);

        return true;
    }

    /**
	  * @dev	Returns the required collateral amount for a volume of bonding
	  *			curve tokens.
      * @notice The curve intergral code will reject any values that are too
      *         small or large, that could result in over/under flows.
	  * @param	_numTokens: The number of tokens to calculate the price of
      * @return uint256 : The required collateral amount for a volume of bonding
      *         curve tokens.
      */
    function priceToMint(uint256 _numTokens) public view returns(uint256) {
        // Gets the balance of the market
        uint256 balance = collateralToken_.balanceOf(address(this));
        // Performs the curve intergral with the relavant vaules
        uint256 collateral = _curveIntegral(
                totalSupply_.add(_numTokens)
            ).sub(balance);
        // Sets the base unit for decimal shift
        uint256 baseUnit = 100;
        // Adds the fee amount
        uint256 result = collateral.mul(100).div(baseUnit.sub(feeRate_));
        return result;
    }

    /**
	  * @dev	Returns the required collateral amount for a volume of bonding
	  *			curve tokens
	  * @param	_numTokens: The number of tokens to work out the collateral
	  *			vaule of
      * @return uint256: The required collateral amount for a volume of bonding
      *         curve tokens
      */
    function rewardForBurn(uint256 _numTokens) public view returns(uint256) {
        // Gets the curent balance of the market
        uint256 poolBalanceFetched = collateralToken_.balanceOf(address(this));
        // Returns the pool balance minus the curve intergral of the removed
        // tokens
        return poolBalanceFetched.sub(
            _curveIntegral(totalSupply_.sub(_numTokens))
        );
    }

    /**
      * @dev    Calculate the integral from 0 to x tokens supply. Calls the
      *         curve integral function on the math library.
      * @param  _x : The number of tokens supply to integrate to.
      * @return he total supply in tokens, not wei.
      */
    function _curveIntegral(uint256 _x) internal view returns (uint256) {
        return curveLibrary_.curveIntegral(_x);
    }

    /**
      * @dev    Inverse integral to convert the incoming colateral value to
      *         token volume.
      * @param  _x : The volume to identify the root off
      */
    function _inverseCurveIntegral(uint256 _x) internal view returns(uint256) {
        return curveLibrary_.inverseCurveIntegral(_x);
    }

	//--------------------------------------------------------------------------
	// ERC20 functions
	//--------------------------------------------------------------------------

	/**
      * @notice Total number of tokens in existence
      * @return uint256: Represents the total supply of tokens in this market.
      */
    function totalSupply() external view returns (uint256) {
        return totalSupply_;
    }

	/**
      * @notice Gets the balance of the specified address.
      * @param  _owner : The address to query the the balance of.
      * @return  uint256 : Represents the amount owned by the passed address.
      */
    function balanceOf(address _owner) external view returns (uint256) {
        return balances[_owner];
    }

	/**
      * @notice Gets the value of the current allowance specifed for that
      *         account.
      * @param  _owner: The account sending the funds.
      * @param  _spender: The account that will receive the funds.
	  * @return	uint256: representing the amount the spender can spend
      */
    function allowance(
        address _owner,
        address _spender
    )
        external
        view
        returns (uint256)
    {
        return allowed[_owner][_spender];
    }

    /**
      * @notice Approves transfers for a given address.
      * @param  _spender : The account that will receive the funds.
      * @param  _value : The value of funds accessed.
      * @return boolean : Indicating the action was successful.
      */
    function approve(
        address _spender,
        uint256 _value
    )
        external
        returns (bool)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
      * @dev    Atomically increases the allowance granted to `spender` by the
      *         caller.
      * @notice This is an alternative to {approve} that can be used as a
      *         mitigation for problems described in {IERC20-approve}.
      */
    function increaseAllowance(
        address _spender,
        uint256 _addedValue
    )
        public
        returns(bool) 
    {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender]
            .add(_addedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, _spender, _addedValue);
        return true;
    }

    /**
      * @dev    Atomically decreases the allowance granted to `spender` by the
      *         caller.
      * @notice This is an alternative to {approve} that can be used as a
      *         mitigation for problems described in {IERC20-approve}.
      */
    function decreaseAllowance(
        address _spender,
        uint256 _subtractedValue
    )
        public
        returns(bool)
    {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender]
            .sub(_subtractedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, _spender, _subtractedValue);
        return true;
    }

	/**
      * @notice Transfer tokens from one address to another.
      * @param  _from : The address which you want to send tokens from.
      * @param  _to : The address which you want to transfer to.
      * @param  _value : The amount of tokens to be transferred.
      */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
        public
        returns (bool)
    {
        require(_value <= balances[_from], "Requested amount exceeds balance");
        require(_value <= allowed[_from][msg.sender], "Allowance exceeded");
        require(_to != address(0), "Target account invalid");

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        emit Transfer(_from, _to, _value);

        return true;
    }

	/**
      * @notice Transfer ownership token from msg.sender to a specified address.
      * @param  _to : The address to transfer to.
      * @param  _value : The amount to be transferred.
      */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_value <= balances[msg.sender], "Insufficient funds");
        require(_to != address(0), "Target account invalid");

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Transfer(msg.sender, _to, _value);
        return true;
    }
}


/**
  * @title  ModifiedWhitelistAdminRole
  * @dev    WhitelistAdmins are responsible for assigning and removing 
  *         Whitelisted accounts.
  */
contract ModifiedWhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistAdminAdded(address indexed account);
    event WhitelistAdminRemoved(address indexed account);

    Roles.Role private _whitelistAdmins;
    // this is a uint8 rather than a 256 for storage. 
    uint8 internal noOfAdmins_;
    // Initial admin address 
    address internal initialAdmin_;

    constructor () internal {
        _addWhitelistAdmin(msg.sender);
        initialAdmin_ = msg.sender;
    }

    modifier onlyWhitelistAdmin() {
        require(
            isWhitelistAdmin(msg.sender), 
            "ModifiedWhitelistAdminRole: caller does not have the WhitelistAdmin role"
        );
        _;
    }

    /**
      * @dev    This allows for the initial admin added to have additional admin
      *         rights, such as removing another admin. 
      */
    modifier onlyInitialAdmin() {
        require(
            msg.sender == initialAdmin_,
            "Only initial admin may remove another admin"
        );
        _;
    }

    function isWhitelistAdmin(address account) public view returns (bool) {
        return _whitelistAdmins.has(account);
    }

    function addWhitelistAdmin(address account) public onlyWhitelistAdmin() {
        _addWhitelistAdmin(account);
    }

    /**
      * @dev    This allows the initial admin to replace themselves as the super
      *         admin.
      * @param  account: The address of the new super admin
      */
    function addNewInitialAdmin(address account) public onlyInitialAdmin() {
        if(!isWhitelistAdmin(account)) {
            _addWhitelistAdmin(account);
        }
        initialAdmin_ = account;
    }

    function renounceWhitelistAdmin() public {
        _removeWhitelistAdmin(msg.sender);
    }

    /**
      * @dev    Allows the super admin to remover other admins
      * @param  account: The address of the admin to be removed
      */
    function removeWhitelistAdmin(address account) public onlyInitialAdmin() {
        _removeWhitelistAdmin(account);
    }

    function _addWhitelistAdmin(address account) internal {
        if(!isWhitelistAdmin(account)) {
            noOfAdmins_ += 1;
        }
        _whitelistAdmins.add(account);
        emit WhitelistAdminAdded(account);
    }

    function _removeWhitelistAdmin(address account) internal {
        noOfAdmins_ -= 1;
        require(noOfAdmins_ >= 1, "Cannot remove all admins");
        _whitelistAdmins.remove(account);
        emit WhitelistAdminRemoved(account);
    }

    function getAdminCount() public view returns(uint8) {
        return noOfAdmins_;
    }
}








/**
  * @author @veronicaLC (Veronica Coutts) & @RyRy79261 (Ryan Nobel)
  * @title  Storage and collection of market fee.
  * @notice The vault stores the fee from the market until the funding goal is
  *         reached, thereafter the creator may withdraw the funds. If the
  *         funding is not reached within the stipulated time-frame, or the
  *         creator terminates the market, the funding is sent back to the
  *         market to be re-distributed.
  * @dev    The vault pulls the mol fee directly from the molecule vault.
  */
contract Vault is IVault, ModifiedWhitelistAdminRole {
    // For math functions with overflow & underflow checks
    using SafeMath for uint256;
    // For keep track of time in months
    using BokkyPooBahsDateTimeLibrary for uint256;

    // The vault benificiary
    address internal creator_;
    // Market feeds collateral to vault
    IMarket internal market_;
    // Underlying collateral token
    IERC20 internal collateralToken_;
    // Vault for molecule fee
    IMoleculeVault internal moleculeVault_;
    // Fee percentage for molecule fee, i.e 50
    uint256 internal moleculeFeeRate_;
    // The funding round that is active
    uint256 internal currentPhase_;
    // Offset for checking funding threshold
    uint256 internal outstandingWithdraw_;
    // The total number of funding rounds
    uint256 internal totalRounds_;
    // The total cumulative fee received from market
    uint256 internal cumulativeReceivedFee_;
    // If the vault has been initialized and has not reached its funding goal
    bool internal _active;
    
    // All funding phases information to their position in mapping
    mapping(uint256 => FundPhase) internal fundingPhases_;

    // Information stored about each phase
    struct FundPhase{
        uint256 fundingThreshold;   // Collateral limit to trigger funding
        uint256 cumulativeFundingThreshold; // The cumulative funding goals
        uint256 fundingRaised;      // The amount of funding raised
        uint256 phaseDuration;      // Period of time for round (start to end)
        uint256 startDate;
        FundingState state;         // State enum
    }

    /**
      * @dev    Checks the range of funding rounds (1-9). Gets the Molecule fee
      *         from the molecule vault directly.
      * @notice Any change in the fee rate in the Molecule Vault will not affect
      *         already deployed vaults. This was done to ensure transparency
      *         and trust in the fee rates.
      * @param  _fundingGoals: The collateral goal for each funding round.
      * @param  _phaseDurations: The time limit of each funding round.
      * @param  _creator: The creator
      * @param  _collateralToken: The ERC20 collateral token
      * @param  _moleculeVault: The molecule vault
      */
    constructor(
        uint256[] memory _fundingGoals,
        uint256[] memory _phaseDurations,
        address _creator,
        address _collateralToken,
        address _moleculeVault
    )
        public
        ModifiedWhitelistAdminRole()
    {
        require(_fundingGoals.length > 0, "No funding goals specified");
        require(_fundingGoals.length < 10, "Too many phases defined");
        require(
            _fundingGoals.length == _phaseDurations.length,
            "Invalid phase configuration"
        );

        // Storing variables in storage
        super.addNewInitialAdmin(_creator);
        outstandingWithdraw_ = 0;
        creator_ = _creator;
        collateralToken_ = IERC20(_collateralToken);
        moleculeVault_ = IMoleculeVault(_moleculeVault);
        moleculeFeeRate_ = moleculeVault_.feeRate();

        // Saving the funding rounds into storage
        uint256 loopLength = _fundingGoals.length;
        for(uint8 i = 0; i < loopLength; i++) {
            if(moleculeFeeRate_ == 0) {
                fundingPhases_[i].fundingThreshold = _fundingGoals[i];
            } else {
                // Works out the rounds fee
                uint256 withFee = _fundingGoals[i].add(
                    _fundingGoals[i].mul(moleculeFeeRate_).div(100)
                );
                // Saving the funding threshold with fee
                fundingPhases_[i].fundingThreshold = withFee;
            }
            // Setting the amount of funding raised so far
            fundingPhases_[i].fundingRaised = 0;
            // Setting the phase duration
            fundingPhases_[i].phaseDuration = _phaseDurations[i];
            // Counter for the total number of rounds
            totalRounds_ = totalRounds_.add(1);
        }

        // Sets the start time to the current time
        fundingPhases_[0].startDate = block.timestamp;
        // Setting the state of the current phase to started
        fundingPhases_[0].state = FundingState.STARTED;
        // Setting the storage of the current phase
        currentPhase_ = 0;
    }

    /**
      * @notice Ensures that only the market may call the function.
      */
    modifier onlyMarket() {
        require(msg.sender == address(market_), "Invalid requesting account");
        _;
    }

    /**
      * @notice Ensures that the vault gets initialized before use.
      */
    modifier isActive() {
        require(_active, "Vault has not been initialized.");
        _;
    }

    /**
      * @dev    Initialized the contract, sets up owners and gets the market
      *         address. This function exists because the Vault does not have
      *         an address until the constructor has finished running. The
      *         cumulative funding threshold is set here because of gas issues
      *         within the constructor.
      * @param _market: The market that will be sending this vault it's
      *         collateral.
      */
    function initialize(
        address _market
    )
        external
        onlyWhitelistAdmin()
        returns(bool)
    {
        require(_market != address(0), "Contracts initialized");
        // Stores the market in storage 
        market_ = IMarket(_market); 
        // Removes the market factory contract as an admin
        super.renounceWhitelistAdmin();

        // Adding all previous rounds funding goals to the cumulative goal
        for(uint8 i = 0; i < totalRounds_; i++) {
            if(i == 0) {
                fundingPhases_[i].cumulativeFundingThreshold.add(
                    fundingPhases_[i].fundingThreshold
                );
            }
            fundingPhases_[i].cumulativeFundingThreshold.add(
                fundingPhases_[i-1].cumulativeFundingThreshold
            );
        }
        _active = true;

        return true;
    }

    /**
      * @notice Allows the creator to withdraw a round of funding.
      * @dev    The withdraw function should be called after each funding round
      *         has been successfully filled. If the withdraw is called after the
      *         last round has ended, the market will terminate and any
      *         remaining funds will be sent to the market.
      * @return bool : The funding has successfully been transferred.
      */
    function withdraw()
        external
        isActive()
        onlyWhitelistAdmin()
        returns(bool)
    {
        require(outstandingWithdraw_ > 0, "No funds to withdraw");

        for(uint8 i; i <= totalRounds_; i++) {
            if(fundingPhases_[i].state == FundingState.PAID) {
                continue;
            } else if(fundingPhases_[i].state == FundingState.ENDED) {
                // Removes this rounds funding from the outstanding withdraw
                outstandingWithdraw_ = outstandingWithdraw_.sub(
                    fundingPhases_[i].fundingThreshold
                );
                // Sets the rounds funding to be paid
                fundingPhases_[i].state = FundingState.PAID;

                uint256 molFee = fundingPhases_[i].fundingThreshold
                    .mul(moleculeFeeRate_)
                    .div(moleculeFeeRate_.add(100));
                // Transfers the mol fee to the molecule vault
                require(
                    collateralToken_.transfer(address(moleculeVault_), molFee),
                    "Tokens not transfer"
                );

                // Working out the original funding goal without the mol fee
                uint256 creatorAmount = fundingPhases_[i].fundingThreshold
                    .sub(molFee);

                // Sending the creator their collateral amount
                require(
                    collateralToken_.transfer(msg.sender, creatorAmount),
                    "Tokens not transfer"
                );
                
                emit FundingWithdrawn(i, creatorAmount);
            } else {
                break;
            }
        }

        // This checks if the current round is the last round, if it is, it
        // terminates the market and sends all remaining funds to the market.
        if(
            fundingPhases_[currentPhase_].state == FundingState.NOT_STARTED
        ) {
            if(market_.active() && outstandingWithdraw_ == 0) {
                // This will transfer any remaining funding to the market
                terminateMarket();
            }
        }
        return true;
    }

    /**
      * @notice Allows the market to check that the funding round(s) have not
      *         been completed, and that the market is still open.
      * @dev    This function will terminate the market if the time for the
      *         round is exceeded. This will loose any funding the creator has
      *         not withdrawn.
      * @param  _receivedFunding: The amount of funding received
      * @return bool: Whether or not the funding is valid
      */
    function validateFunding(
        uint256 _receivedFunding
    )
        external
        isActive()
        onlyMarket()
        returns(bool)
    {
        require(
            fundingPhases_[currentPhase_].state == FundingState.STARTED,
            "Funding inactive"
        );

        // Works out the time the phase should end
        uint256 endOfPhase = fundingPhases_[currentPhase_].startDate
            .addMonths(fundingPhases_[currentPhase_].phaseDuration);
        // Invalidates mint in market if the rounds time has expired.
        if(endOfPhase <= block.timestamp) {
            terminateMarket();
            return false;
        }

        // Gets the balance of the vault against the collateral token
        uint256 balance = collateralToken_.balanceOf(address(this));
        // Adds the fee to the funding raised for this round
        fundingPhases_[currentPhase_]
            .fundingRaised = fundingPhases_[currentPhase_]
            .fundingRaised.add(_receivedFunding);	//injected INTEGER OVERFLOW OR UNDERFLOW

        // Adds received funding to the cumulative record of fee received
        cumulativeReceivedFee_.add(_receivedFunding);

        // Ensures the total fee received finishes the current round
        if(
            fundingPhases_[currentPhase_].cumulativeFundingThreshold <=
                cumulativeReceivedFee_ &&
            balance.sub(outstandingWithdraw_) >=
                fundingPhases_[currentPhase_].fundingThreshold
        ) {
            // Ensures that the round has been funded correctly
            assert(
                fundingPhases_[currentPhase_].fundingRaised >=
                fundingPhases_[currentPhase_].fundingThreshold
            );
            // end current round will check if there is excess funding and add
            // it to the next round, as well as incrementing the current round
            _endCurrentRound();
            // Checks if the funding raised is larger than this rounds goal
            if(
                fundingPhases_[currentPhase_].fundingRaised >
                fundingPhases_[currentPhase_].fundingThreshold
            ) {
                // Ends the round
                _endCurrentRound();
                // Ensures the received funding does not finish any other rounds
                do {
                    // checks if the next funding rounds cumulative funding goal
                    // is completed
                    if(
                        fundingPhases_[currentPhase_]
                            .cumulativeFundingThreshold <=
                            cumulativeReceivedFee_ &&
                        balance.sub(outstandingWithdraw_) >=
                        fundingPhases_[currentPhase_].fundingThreshold
                    ) {
                        _endCurrentRound();
                    } else {
                        break;
                    }
                } while(currentPhase_ < totalRounds_);
            }
        }
        return true;
    }

    /**
      * @dev    This function sends the vaults funds to the market, and sets the
      *         outstanding withdraw to 0.
      * @notice If this function is called before the end of all phases, all
      *         unclaimed (outstanding) funding will be sent to the market to be
      *         redistributed.
      */
    function terminateMarket()
        public
        isActive()
        onlyWhitelistAdmin()
    {
        uint256 remainingBalance = collateralToken_.balanceOf(address(this));
        // This ensures that if the creator has any outstanding funds, that
        // those funds do not get sent to the market.
        if(outstandingWithdraw_ > 0) {
            remainingBalance = remainingBalance.sub(outstandingWithdraw_);
        }
        // Transfers remaining balance to the market
        require(
            collateralToken_.transfer(address(market_), remainingBalance),
            "Transfering of funds failed"
        );
        // Finalizes market (stops buys/sells distributes collateral evenly)
        require(market_.finaliseMarket(), "Market termination error");
    }

    /**
      * @notice Returns all the details (relevant to external code) for a
      *         specific phase.
      * @param  _phase: The phase that you want the information of
      * @return uint256: The funding goal (including mol tax) of the round
      * @return uint256: The amount of funding currently raised for the round
      * @return uint256: The duration of the phase
      * @return uint256: The timestamp of the start date of the round
      * @return FundingState: The enum state of the round (see IVault)
      */
    function fundingPhase(
        uint256 _phase
    )
        public
        view
        returns(
            uint256,
            uint256,
            uint256,
            uint256,
            FundingState
        ) {
        return (
            fundingPhases_[_phase].fundingThreshold,
            fundingPhases_[_phase].fundingRaised,
            fundingPhases_[_phase].phaseDuration,
            fundingPhases_[_phase].startDate,
            fundingPhases_[_phase].state
        );
    }

    /**
	  * @return	uint256: The amount of funding that the creator has earned by
	  *			not withdrawn.
	  */
    function outstandingWithdraw() public view returns(uint256) {
        uint256 minusMolFee = outstandingWithdraw_
            .sub(outstandingWithdraw_
                .mul(moleculeFeeRate_)
                .div(moleculeFeeRate_.add(100))
            );
        return minusMolFee;
    }

    /**
      * @dev    The current active phase of funding
      * @return uint256: The current phase the project is in.
      */
    function currentPhase() public view returns(uint256) {
        return currentPhase_;
    }

    /**
      * @return uint256: The total number of rounds for this project.
      */
    function getTotalRounds() public view returns(uint256) {
        return totalRounds_;
    }

    /**
	  * @return	address: The address of the market that is funding this vault.
	  */
    function market() public view returns(address) {
        return address(market_);
    }

    /**
	  * @return	address: The address of the creator of this project.
	  */
    function creator() external view returns(address) {
        return creator_;
    }

    /**
      * @dev    Ends the round, increments to the next round, rolls-over excess
      *         funding, sets the start date of the next round, if there is one.
      */
    function _endCurrentRound() internal {
        // Setting active phase state to ended
        fundingPhases_[currentPhase_].state = FundingState.ENDED;
        // Works out the excess funding for the round
        uint256 excess = fundingPhases_[currentPhase_]
            .fundingRaised.sub(fundingPhases_[currentPhase_].fundingThreshold);
        // If there is excess, adds it to the next round
        if (excess > 0) {
            // Adds the excess funding into the next round.
            fundingPhases_[currentPhase_.add(1)]
                .fundingRaised = fundingPhases_[currentPhase_.add(1)]
                .fundingRaised.add(excess);
            // Setting the current rounds funding raised to the threshold
            fundingPhases_[currentPhase_]
                .fundingRaised = fundingPhases_[currentPhase_].fundingThreshold;
        }
        // Adding the funished rounds funding to the outstanding withdraw.
        outstandingWithdraw_ = outstandingWithdraw_
            .add(fundingPhases_[currentPhase_].fundingThreshold);
        // Incrementing the current phase
        currentPhase_ = currentPhase_ + 1;
        // Set the states the start time, starts the next round if there is one.
        if(fundingPhases_[currentPhase_].fundingThreshold > 0) {
            // Setting active phase state to Started
            fundingPhases_[currentPhase_].state = FundingState.STARTED;
            // This works out the end time of the previous round
            uint256 endTime = fundingPhases_[currentPhase_
                .sub(1)].startDate
                .addMonths(fundingPhases_[currentPhase_].phaseDuration);
            // This works out the remaining time
            uint256 remaining = endTime.sub(block.timestamp);
            // This sets the start date to the end date of the previous round
            fundingPhases_[currentPhase_].startDate = block.timestamp
                .add(remaining);
        }

        emit PhaseFinalised(
            currentPhase_.sub(1),
            fundingPhases_[currentPhase_.sub(1)].fundingThreshold
        );
    }
}




// import { WhitelistedRole } from "openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol";





/**
  * @author @veronicaLC (Veronica Coutts) & @RyRy79261 (Ryan Nobel)
  * @title  The creation and co-ordinated storage of markets (a vault and
  *         market).
  * @notice The market factory stores the addresses in the relevant registry.
  */
contract MarketFactory is IMarketFactory, ModifiedWhitelistAdminRole {
    //The molecule vault for molecule fee
    IMoleculeVault internal moleculeVault_;
    //The registry of all created markets
    IMarketRegistry internal marketRegistry_;
    //The registry of all curve types
    ICurveRegistry internal curveRegistry_;
    //The ERC20 collateral token contract address
    IERC20 internal collateralToken_;
    // Address of market deployer
    address internal marketCreator_;
    // The init function can only be called once 
    bool internal isInitialized_  = false;

    event NewApiAddressAdded(address indexed oldAddress, address indexed newAddress);

    modifier onlyAnAdmin() {
        require(isInitialized_, "Market factory has not been activated");
        require(
            isWhitelistAdmin(msg.sender) || msg.sender == marketCreator_,
            "Functionality restricted to whitelisted admin"
        );
        _;
    }

    /**
      * @dev    Sets variables for market deployments.
      * @param  _collateralToken Address of the ERC20 collateral token
      * @param  _moleculeVault   The address of the molecule fee vault
      * @param  _marketRegistry  Address of the registry of all markets
      * @param  _curveRegistry   Address of the registry of all curve types
      *         funding rounds.
      */
    constructor(
        address _collateralToken,
        address _moleculeVault,
        address _marketRegistry,
        address _curveRegistry
    )
        ModifiedWhitelistAdminRole()
        public
    {
        collateralToken_ = IERC20(_collateralToken);
        moleculeVault_ = IMoleculeVault(_moleculeVault);
        marketRegistry_ = IMarketRegistry(_marketRegistry);
        curveRegistry_ = ICurveRegistry(_curveRegistry);
    }

    /**
      * @notice Inits the market factory
      * @param  _admin The address of the admin contract manager
      * @param  _api The address of the backend market deployer
      */
    function init(
        address _admin,
        address _api
    )
        onlyWhitelistAdmin()
        public
    {
        super.addNewInitialAdmin(_admin);
        marketCreator_ = _api;
        super.renounceWhitelistAdmin();
        isInitialized_ = true;
    }

    function updateApiAddress(
        address _newApiPublicKey
    ) 
        onlyWhitelistAdmin() 
        public 
        returns(address)
    {
        address oldMarketCreator = marketCreator_;
        marketCreator_ = _newApiPublicKey;

        emit NewApiAddressAdded(oldMarketCreator, marketCreator_);
        return _newApiPublicKey;
    }

    /**
      * @notice This function allows for the creation of a new market,
      *         consisting of a curve and vault. If the creator address is the
      *         same as the deploying address the market the initialization of
      *         the market will fail.
      * @dev    Vyper cannot handle arrays of unknown length, and thus the
      *         funding goals and durations will only be stored in the vault,
      *         which is Solidity.
      * @param  _fundingGoals This is the amount wanting to be raised in each
      *         round, in collateral.
      * @param  _phaseDurations The time for each round in months. This number
      *         is covered into block time within the vault.
      * @param  _creator Address of the researcher.
      * @param  _curveType Curve selected.
      * @param  _feeRate The percentage of fee. e.g: 60
      */
    function deployMarket(
        uint256[] calldata _fundingGoals,
        uint256[] calldata _phaseDurations,
        address _creator,
        uint256 _curveType,
        uint256 _feeRate
    )
        external
        onlyAnAdmin()
    {
        // Breaks down the return of the curve data
        (address curveLibrary,, bool curveState) = curveRegistry_.getCurveData(
            _curveType
        );

        require(_feeRate > 0, "Fee rate too low");
        require(_feeRate < 100, "Fee rate too high");
        require(_creator != address(0), "Creator address invalid");
        require(curveState, "Curve inactive");
        require(curveLibrary != address(0), "Curve library invalid");
        
        address newVault = address(new Vault(
            _fundingGoals,
            _phaseDurations,
            _creator,
            address(collateralToken_),
            address(moleculeVault_)
        ));

        address newMarket = address(new Market(
            _feeRate,
            newVault,
            curveLibrary,
            address(collateralToken_)
        ));

        require(Vault(newVault).initialize(newMarket), "Vault not initialized");
        marketRegistry_.registerMarket(newMarket, newVault, _creator);
    }

    /**
      * @notice This function will only affect new markets, and will not update
      *         already created markets. This can only be called by an admin
      */
    function updateMoleculeVault(
        address _newMoleculeVault
    )
        public
        onlyWhitelistAdmin()
    {
        moleculeVault_ = IMoleculeVault(_newMoleculeVault);
    }

    /**
      * @return address: The address of the molecule vault
      */
    function moleculeVault() public view returns(address) {
        return address(moleculeVault_);
    }

    /**
      * @return address: The contract address of the market registry.
      */
    function marketRegistry() public view returns(address) {
        return address(marketRegistry_);
    }

    /**
      * @return address: The contract address of the curve registry
      */
    function curveRegistry() public view returns(address) {
        return address(curveRegistry_);
    }

    /**
      * @return address: The contract address of the collateral token
      */
    function collateralToken() public view returns(address) {
        return address(collateralToken_);
    }
}