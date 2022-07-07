/**
 *Submitted for verification at Etherscan.io on 2020-02-03
*/

pragma solidity ^0.5.12;

/**
 * @dev Simplified contract of a `../Swapper.sol`
 */
contract SwapperLike {
    function fromDaiToBTU(address, uint256) external;
}


/**
 * @dev Simplified contract of a VatLike
 * For full implementation please see MakerDAO's repo at <https://github.com/makerdao/dss>
 */
contract VatLike {
    function hope(address) external;
}


/**
 * @dev Simplified contract of a PotLike
 * For full implementation please see MakerDAO's repo at <https://github.com/makerdao/dss>
 */
contract PotLike {
    function chi() external view returns (uint256);
    function rho() external view returns (uint256);
    function dsr() external view returns (uint256);
    function drip() external returns (uint256);
    function join(uint256) external;
    function exit(uint256) external;
}


/**
 * @dev Simplified contract of a DaiJoin
 * For full implementation please see MakerDAO's repo at <https://github.com/makerdao/dss>
 */
contract JoinLike {
    function join(address, uint256) external;
    function exit(address, uint256) external;
}


/**
 * @dev Simplified contract of a ERC20 Token
 */
contract ERC20Like {
    function transferFrom(address, address, uint256) external returns (bool);
    function transfer(address, uint256) external returns (bool);
    function approve(address, uint256) external returns (bool);
    function allowance(address, address) external view returns (uint256);
}




/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
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
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}










library RayMath {
    uint256 internal constant ONE_RAY = 10**27;

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a, "Bdai: overflow");

        return c;
    }

    function sub(uint256 a, uint256 b, string memory errMsg)
        internal
        pure
        returns (uint256)
    {
        require(b <= a, errMsg);

        return a - b;
    }

    function subOrZero(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b > a) {
            return uint256(0);
        } else {
            return a - b;
        }
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }

        c = a * b;
        require(c / a == b, "bDai: multiplication overflow");

        return c;
    }

    function rmul(uint256 a, uint256 b) internal pure returns (uint256) {
        return mul(a, b) / ONE_RAY;
    }

    /**
     * @dev Warning : result is rounded toward zero
     */
    function rdiv(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "bDai: division by 0");

        return mul(a, ONE_RAY) / b;
    }

    /**
     * @dev do division with rouding up
     */
    function rdivup(uint256 a, uint256 b) internal pure returns (uint256) {
        return add(mul(a, ONE_RAY), sub(b, 1, "bDai: division by 0")) / b;
    }
}


/**
 * @dev Implementation of the bDAI ERC20 token
 *
 * This contracts aims to take `amount` DAI, subscribes it to the DSR program and
 * gives back `amount` of bDAI. User can then earn interests on these bDAI in BTU
 *
 * To have bDAI user needs to call join or joinFor
 * claim and claimFor are used to be get back interests in BTU
 * exit and exitFor are aimed to claim back the user's DAI
 */
contract Bdai is IERC20 {
    using RayMath for uint256;

    bool public live;
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    string public constant name = "BTU Incentivized DAI";
    string public constant symbol = "bDAI";
    string public constant version = "1";

    mapping(address => uint256) private _balances;
    mapping(address => uint256) private _pies;
    mapping(address => uint256) private _nonces;

    mapping(address => mapping(address => uint256)) private _allowances;

    ERC20Like public dai;
    JoinLike public daiJoin;
    PotLike public pot;
    VatLike public vat;
    SwapperLike public swapper;

    address public owner;

    bytes32 public DOMAIN_SEPARATOR; //EIP712 domain

    //keccak256 "Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)"
    bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;

    //keccak256 "ClaimFor(address holder,address spender,uint256 nonce,uint256 expiry,address dest)"
    bytes32 public constant CLAIM_TYPEHASH = 0xcbd06f2e482e52538ba0a2e3b1ec074c1ff826895448b9cf7b33c0abbbe904b3;

    //keccak256 "ExitFor(address holder,address spender,uint256 nonce,uint256 expiry,uint256 amount)"
    bytes32 public constant EXIT_TYPEHASH = 0x703d2576480f8b8746c2232693aae93ab2bda9c8b68427bce6eff0c6238807ed;

    /**
     * @dev Sets the external MakerDAO's contract address. All of these values are immutable.
     *      Authorises these contracts to play with DAI owned by `this`
     */
    constructor(
        address dai_,
        address daiJoin_,
        address pot_,
        address vat_,
        address swapper_,
        uint256 chainId_
    ) public {
        owner = msg.sender;
        live = true;

        dai = ERC20Like(dai_);
        daiJoin = JoinLike(daiJoin_);
        pot = PotLike(pot_);
        vat = VatLike(vat_);
        swapper = SwapperLike(swapper_);

        vat.hope(daiJoin_);
        vat.hope(pot_);

        dai.approve(daiJoin_, uint256(-1));
        dai.approve(swapper_, uint256(-1));

        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                chainId_,
                address(this)
            )
        );
    }

    /**
     * @dev Returns the amount of bDAI owned by `account`.
     */
    function balanceOf(address account) public view returns (uint256) {	//inject PUBLIC FUNC TO EXTERNAL
        return _balances[account];
    }

    /**
     * @dev Transfers `amount` of bDAI from `sender` to `recipient`
     *      Before the transfer, `sender` earns interrests on its bDAI
     *
     * Requirements :
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     *
     * Emits {Transfer} event
     */
    function transfer(address recipient, uint256 amount)
        public	//inject PUBLIC FUNC TO EXTERNAL
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev Returns the pie owned by `account` on the DSR contract (e.g. pot.sol from MakerDAO).
     */
    function pieOf(address account) public view returns (uint256) {	//inject PUBLIC FUNC TO EXTERNAL
        return _pies[account];
    }

    /**
     * @dev Returns the last recorded `chi` from the dsr contract
     */
    function chi() public view returns (uint256) {	//inject PUBLIC FUNC TO EXTERNAL
        return pot.chi();
    }

    /**
     * @dev Returns the last recorded `rho` from the dsr contract
     */
    function rho() public view returns (uint256) {	//inject PUBLIC FUNC TO EXTERNAL
        return pot.rho();
    }

    /**
     * @dev Returns the last recorded `dsr` from the dsr contract
     */
    function dsr() public view returns (uint256) {	//inject PUBLIC FUNC TO EXTERNAL
        return pot.dsr();
    }

    /**
     * @dev Returns the amount of bDAI which `spender` can take from `tokenOwner` account
     */
    function allowance(address tokenOwner, address spender)
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns (uint256)
    {
        return _allowances[tokenOwner][spender];
    }

    /**
     * @dev Sets an allowance of `amount` for `spender` over the caller's bDAI
     *
     * Emits {Approval} event
     */
    function approve(address spender, uint256 amount) public returns (bool) {	//inject PUBLIC FUNC TO EXTERNAL
        require(spender != address(0), "Bdai: approve to 0x0");

        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);

        return true;
    }

    /**
     * @dev Transfers `amount` of bDAI from `sender` to `recipient`
     *      Before the transfer, `sender` earns interrests on its bDAI
     *      Updates allowance if not set to MAX_UINT256
     *
     * Requirements :
     * - `sender`cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - the caller must have an allowance of at least `amount`.
     * - `sender` must have at least `amount` of token
     *
     * Emits {Transfer} event
     * Emits an {Approval} event indicating the updated allowance
     */
    function transferFrom(address sender, address recipient, uint256 amount)
        public	//inject PUBLIC FUNC TO EXTERNAL
        returns (bool)
    {
        _allow(sender, msg.sender, amount);
        _transfer(sender, recipient, amount);

        return true;
    }

    /**
     * @dev Takes `amount` of DAI (in wad) from the caller and subscribes it to the dsr
     *      Mints `amount` of bDAI for the caller
     *
     * Requirements :
     * - the caller must have at least `amount` of DAI.
     *
     * Emits {Transfer} event
     */
    function join(uint256 amount) public {	//inject PUBLIC FUNC TO EXTERNAL
        _join(msg.sender, amount);
    }

    /**
     * @dev Takes `amount` of DAI (in wad) from the caller and subscribes it to the dsr
     *      Mints `amount` of bDAI for `dest` (e.g. DAI are taken from caller and bDAI are sent to `dest`)
     *
     * Requirements :
     * - the caller must have at least `amount` of DAI.
     * - `dest` cannot be zero address
     *
     * Emits {Transfer} event
     */
    function joinFor(address dest, uint256 amount) public {	//inject PUBLIC FUNC TO EXTERNAL
        require(dest != address(0), "bDai: dest cannot be 0x0");
        _join(dest, amount);
    }

    /**
     * @dev Recalculates caller's `pie` to fit with its bDAI
     *      Converts interrests to BTU and sends it to caller's address
     */
    function claim() public {	//inject PUBLIC FUNC TO EXTERNAL
        _claim(msg.sender, msg.sender);
    }

    /**
     * @dev Recalculates caller's `pie` to fit with its bDAI
     *      Converts interrests to BTU and sends it to `dest` address
     *
     * Requirements :
     * - `dest` cannot be the zero address
     */
    function claim(address dest) public {	//inject PUBLIC FUNC TO EXTERNAL
        require(dest != address(0), "bDai: dest cannot be 0x0");
        _claim(msg.sender, dest);
    }

    /**
     * @dev Takes `amount` of bDAI and returns `amount` of DAI
     *      Claims interest
     *      Burns `amount` of bDAI
     *
     * Requirements :
     * - the caller must have at least `amount` of bDAI.
     *
     * Emits {Transfer} event
     */
    function exit(uint256 amount) public {	//inject PUBLIC FUNC TO EXTERNAL
        _exit(msg.sender, amount);
    }

    /**
     * @dev Transfers `amounts` of bDAI from caller to `recipients`
     * Before the transfer, caller earns interrests on its bDAI
     *
     * Requirements :
     * - `recipients` cannot contain the zero address.
     * - the caller must have a balance of at least `total(amounts)`.
     *
     * Emits {Transfer} event
     */
    function transfer(address[] memory recipients, uint256[] memory amounts)
        public
        returns (bool)
    {
        _transfer(msg.sender, recipients, amounts);
        return true;
    }

    /**
     * @dev Transfers `amounts` of bDAI from caller to `recipients`
     * Before the transfer, caller earns interrests on its bDAI
     *
     * Requirements :
     * - `sender`cannot be the zero address.
     * - `recipients` cannot contain the zero address.
     * - the caller must have an allowance of at least `total(amounts)`.
     * - `sender` must have a balance of at least `total(amounts)`.
     *
     * Emits {Transfer} event
     * Emits an {Approval} event indicating the updated allowance
     */
    function transferFrom(
        address sender,
        address[] memory recipients,
        uint256[] memory amounts
    ) public returns (bool) {
        uint256 total;

        for (uint256 i; i < recipients.length; ++i) {
            total = total.add(amounts[i]);
        }

        _allow(sender, msg.sender, total);
        _transfer(sender, recipients, amounts);

        return true;
    }

    /**
     * @dev Returns the noce ofe `account`
     */
    function nonces(address account) public view returns (uint256) {	//inject PUBLIC FUNC TO EXTERNAL
        return _nonces[account];
    }

    /**
     * @dev Sets an allowance of `MAX_UINT256` for `spender` over the holder's bDAI if `allowaed` set to `true`
     *
     * Requiremets:
     * - `holder` cannot be the zero address
     * - `spender` cannot be the zero address
     * - `nonce` must be actual nonce of `holder` + 1
     * - `expiry` must be zero (for infinite validity) or lower than `now` if not null
     * - `v`, `r`, `s` must contain the permit message signed by `holder`
     *
     * Emits {Approval} event
     */
    function permit(
        address holder,
        address spender,
        uint256 nonce,
        uint256 expiry,
        bool allowed,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {	//inject PUBLIC FUNC TO EXTERNAL
        require(holder != address(0), "bDai: approve from 0x0");
        require(spender != address(0), "bDai: approve to 0x0");
        require(expiry == 0 || now <= expiry, "bDai: permit-expired");
        require(nonce == _nonces[holder]++, "bDai: invalid-nonce");

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        PERMIT_TYPEHASH,
                        holder,
                        spender,
                        nonce,
                        expiry,
                        allowed
                    )
                )
            )
        );

        require(holder == ecrecover(digest, v, r, s), "bDai: invalid-permit");
        uint256 amount = allowed ? uint256(-1) : 0;
        _allowances[holder][spender] = amount;
        emit Approval(holder, spender, amount);
    }

    /**
     * @dev Recalculates `account`'s `pie` to fit with its bDAI
     *      Converts interrests to BTU and sends it to `dest` address
     *
     * Requirements :
     * - the caller must have an allowance >= of the `account`'s balance
     * - `dest` cannot be the zero address
     */
    function claimFor(
        address holder,
        uint256 nonce,
        uint256 expiry,
        address dest,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {	//inject PUBLIC FUNC TO EXTERNAL
        require(dest != address(0), "bDai: dest cannot be 0x0");
        require(holder != address(0), "bDai: claim from 0x0");
        require(expiry == 0 || now <= expiry, "bDai: permit-expired");
        require(nonce == _nonces[holder]++, "bDai: invalid-nonce");

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        CLAIM_TYPEHASH,
                        holder,
                        msg.sender,
                        nonce,
                        expiry,
                        dest
                    )
                )
            )
        );

        require(holder == ecrecover(digest, v, r, s), "bDai: invalid-permit");
        _claim(holder, dest);
    }

    /**
     * @dev Takes `amount` of bDAI and returns `amount` of DAI in the name of `account`
     * Claims interest
     * Burns `amount` of bDAI
     *
     * Requirements :
     * - `holder` must have at least `amount` of bDAI.
     * - `holder` cannot be the zero address
     * - `nonce` must be actual nonce of `holder` + 1
     * - `expiry` must be zero (for infinite validity) or lower than `now` if not null
     * - `v`, `r`, `s` must contain the permit message signed by `holder`
     *
     * Emits {Transfer} event
     */
    function exitFor(
        address holder,
        uint256 nonce,
        uint256 expiry,
        uint256 amount,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {	//inject PUBLIC FUNC TO EXTERNAL
        require(holder != address(0), "bDai: exit from 0x0");
        require(expiry == 0 || now <= expiry, "bDai: permit-expired");
        require(nonce == _nonces[holder]++, "bDai: invalid-nonce");

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        EXIT_TYPEHASH,
                        holder,
                        msg.sender,
                        nonce,
                        expiry,
                        amount
                    )
                )
            )
        );

        require(holder == ecrecover(digest, v, r, s), "bDai: invalid-permit");
        _exit(holder, amount);
    }

    /**
     * @dev only callers with address equals to `owner` can call functions with this modifier
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "bDai: op not allowed");
        _;
    }

    /**
     * @dev Changes the contract owner from `owner` to `owner_`
     *
     * Requirements :
     * - the caller must be the actual contract `owner`
     * - `owner_` cannot be the zero address
     *
     */
    function setOwner(address owner_) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        require(owner_ != address(0), "bDai: owner cannot be 0x0");
        owner = owner_;
    }

    /**
     * @dev Changes the `live` params, if set to `false` join functionnality is blocked
     *
     * Requirements :
     * - the caller must be the actual contract `owner`
     *
     */
    function freeze(bool freeze_) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        live = !freeze_;
    }

    /**
     * @dev Changes the `swapper` contract
     *
     * Requirements :
     * - the caller must be the actual contract `owner`
     * - `swapper_` cannot be the zero address
     *
     */
    function setSwapper(address swapper_) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        require(swapper_ != address(0), "bDai: cannot set to 0x0");
        address oldSwapper = address(swapper);
        swapper = SwapperLike(swapper_);

        dai.approve(oldSwapper, uint256(0));
        dai.approve(swapper_, uint256(-1));
    }

    /**
     * @dev Returns the actual `chi` from the DSR (e.g. call `pot.drip()` if needed)
     */
    function _chi() internal returns (uint256) {
        return now > pot.rho() ? pot.drip() : pot.chi();
    }

    /**
     * @dev Updates the allowance of `caller` over `sender` for a specified `amount`
     * Emits an {Approval} event indicating the updated allowance
     */
    function _allow(address sender, address caller, uint256 amount) internal {
        uint256 a = _allowances[sender][caller];
        require(a > 0, "bDAI: bad allowance");
        if (a != uint256(-1)) {
            _allowances[sender][caller] = a.sub(amount, "bDAI: bad allowance");
            emit Approval(sender, caller, _allowances[sender][caller]);
        }
    }

    /**
     * @dev Transfers `amount` of bDAI from `sender` to `recipient`
     * Before the transfer, `sender` earns interrests on its bDAI
     *
     * Requirements :
     * - `sender`cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     *
     * Emits {Transfer} event
     */
    function _transfer(address sender, address recipient, uint256 amount)
        internal
    {
        require(sender != address(0), "Bdai: transfer from 0x0");
        require(recipient != address(0), "Bdai: transfer to 0x0");

        uint256 c = _chi();
        uint256 senderBalance = _balances[sender];
        uint256 oldSenderPie = _pies[sender];
        uint256 tmp = senderBalance.rdivup(c); //Pie reseted
        uint256 pieToClaim = oldSenderPie.subOrZero(tmp);
        uint256 pieToBeTransfered = amount.rdivup(c);

        _balances[sender] = senderBalance.sub(
            amount,
            "bDai: not enougth funds"
        );
        _balances[recipient] = _balances[recipient].add(amount);

        tmp = pieToClaim.add(pieToBeTransfered);
        if (tmp > oldSenderPie) {
            _pies[sender] = 0;
            _pies[recipient] = _pies[recipient].add(oldSenderPie);
        } else {
            _pies[sender] = oldSenderPie - tmp;
            _pies[recipient] = _pies[recipient].add(pieToBeTransfered);
        }

        if (pieToClaim > 0) {
            uint256 claimedToken = pieToClaim.rmul(c);

            pot.exit(pieToClaim);
            daiJoin.exit(address(this), claimedToken);
            swapper.fromDaiToBTU(sender, claimedToken);
        }

        emit Transfer(sender, recipient, amount);
    }

    /**
     * @dev Transfers `amounts` of bDAI from caller to `recipients`
     * Before the transfer, caller earns interrests on its bDAI
     *
     * Requirements :
     * - `sender`cannot be the zero address.
     * - `recipients` cannot contain the zero address.
     * - the caller must have an allowance of at least `total(amounts)`.
     * - `sender` must have a balance of at least `total(amounts)`.
     *
     * Emits {Transfer} event
     */
    function _transfer(
        address sender,
        address[] memory recipients,
        uint256[] memory amounts
    ) internal {
        require(sender != address(0), "Bdai: transfer from 0x0");

        uint256 c = _chi();
        uint256 senderBalance = _balances[sender];
        uint256 oldSenderPie = _pies[sender];
        uint256 tmp = senderBalance.rdivup(c); //Pie reseted
        uint256 pieToClaim = oldSenderPie.subOrZero(tmp);
        uint256 pieToBeTransfered;

        uint256 total;
        uint256 totalPie = oldSenderPie;
        for (uint256 i; i < recipients.length; ++i) {
            require(recipients[i] != address(0), "Bdai: transfer to 0x0");
            total = total.add(amounts[i]);

            pieToBeTransfered = amounts[i].rdivup(c);
            _balances[recipients[i]] = _balances[recipients[i]].add(amounts[i]);

            tmp = pieToClaim.add(pieToBeTransfered);
            if (tmp > oldSenderPie) {
                totalPie = 0;
                _pies[recipients[i]] = _pies[recipients[i]].add(oldSenderPie);
            } else {
                totalPie = oldSenderPie - tmp;
                _pies[recipients[i]] = _pies[recipients[i]].add(
                    pieToBeTransfered
                );
            }

            emit Transfer(sender, recipients[i], amounts[i]);
        }

        _balances[sender] = senderBalance.sub(total, "bDai: not enougth funds");
        _pies[sender] = totalPie;

        if (pieToClaim > 0) {
            uint256 claimedToken = pieToClaim.rmul(c);

            pot.exit(pieToClaim);
            daiJoin.exit(address(this), claimedToken);
            swapper.fromDaiToBTU(sender, claimedToken);
        }
    }

    /**
     * @dev Takes `amount` of DAI (in wad) from the caller and subscribes it to the dsr
     * Mints `amount` of bDAI for `dest` (e.g. DAI are taken from caller and bDAI are sent to `dest`)
     *
     * Requirements :
     * - the caller must have at least `amount` of DAI.
     *
     * Emits {Transfer} event
     */
    function _join(address dest, uint256 amount) internal {
        require(live, "bDai: system is frozen");

        uint256 c = _chi();
        uint256 pie = amount.rdiv(c);

        totalSupply = totalSupply.add(amount);
        _balances[dest] = _balances[dest].add(amount);
        _pies[dest] = _pies[dest].add(pie);

        dai.transferFrom(msg.sender, address(this), amount);
        daiJoin.join(address(this), amount);
        pot.join(pie);

        emit Transfer(address(0), dest, amount);
    }

    /**
     * @dev Recalculates `account`'s `pie` to fit with its bDAI
     *      Sends BTU to `dest` address
     * Converts interrests to BTU and sends it to caller's address
     */
    function _claim(address account, address dest) internal {
        uint256 c = _chi();
        uint256 newPie = _balances[account].rdivup(c);
        uint256 pieDiff = _pies[account].subOrZero(newPie);

        if (pieDiff > 0) {
            uint256 exitedTokens = pieDiff.rmul(c);
            _pies[account] = newPie;

            pot.exit(pieDiff);
            daiJoin.exit(address(this), exitedTokens);
            swapper.fromDaiToBTU(dest, exitedTokens);
        }
    }

    /**
     * @dev Takes `amount` of bDAI and returns `amount` of DAI in the name of `account`
     * Claims interest
     * Burns `amount` of bDAI
     *
     * Requirements :
     * - `amount` cannot be zero
     * - `account` must have at least `amount` of bDAI.
     * - the caller must have an allowance of at least `amount` over the `account` address
     *
     * Emits {Transfer} event
     */
    function _exit(address account, uint256 amount) internal {
        require(amount > 0, "bDai : zero amount");

        uint256 c = _chi();
        uint256 bal2 = _balances[account].sub(
            amount,
            "bDai: not enougth funds"
        );
        uint256 pie2 = bal2.rdiv(c);
        uint256 pieDiff = _pies[account].sub(pie2, "bDai: not enougth funds");
        uint256 totalDai = pieDiff.rmul(c);
        uint256 interestToken = totalDai.subOrZero(amount);

        _balances[account] = bal2;
        totalSupply = totalSupply.sub(amount, "bDai: totalSupply underflow");
        _pies[account] = pie2;

        pot.exit(pieDiff);
        daiJoin.exit(address(this), totalDai);
        dai.transfer(account, amount);

        if (interestToken > 0) {
            swapper.fromDaiToBTU(account, interestToken);
        }

        emit Transfer(account, address(0), amount);
    }
}