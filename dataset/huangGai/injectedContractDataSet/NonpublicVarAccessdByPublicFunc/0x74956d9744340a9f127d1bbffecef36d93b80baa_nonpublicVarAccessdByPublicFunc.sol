/**
 *Submitted for verification at Etherscan.io on 2020-04-27
*/

pragma solidity 0.5.7;

contract PHCMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x, "phc-math-add");
    }
    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x, "phc-math-sub");
    }
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, "phc-math-mul");
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x <= y ? x : y;
    }
    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x >= y ? x : y;
    }
    function imin(int x, int y) internal pure returns (int z) {
        return x <= y ? x : y;
    }
    function imax(int x, int y) internal pure returns (int z) {
        return x >= y ? x : y;
    }

    uint256 constant WAD = 10 ** 18;
    uint256 constant RAY = 10 ** 27;

    function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
    function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }
    function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
    function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }
}

contract ERC20Events {
    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
}

contract ERC20 is ERC20Events {
    function totalSupply() public view returns (uint256);
    function balanceOf(address guy) public view returns (uint256);
    function allowance(address src, address guy) public view returns (uint256);

    function approve(address guy, uint256 wad) public returns (bool);
    function transfer(address dst, uint256 wad) public returns (bool);
    function transferFrom(
        address src, address dst, uint256 wad
    ) public returns (bool);
}

contract PHCTokenBase is ERC20, PHCMath {
    mapping (address => uint256)                       _balances;
    mapping (address => mapping (address => uint256))  _approvals;

    uint256 constant _supply = (2000000000) * (10**18);
    constructor() public {
        _balances[msg.sender] = _supply;
    }

    function totalSupply() public view returns (uint256) {
        return _supply;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    function balanceOf(address src) public view returns (uint256) {
        return _balances[src];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    function allowance(address src, address guy) public view returns (uint256) {
        return _approvals[src][guy];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function transfer(address dst, uint256 wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint256 wad)
        public
        returns (bool)
    {
        if (src != msg.sender) {
            require(_approvals[src][msg.sender] >= wad, "phc-token-insufficient-approval");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }

        require(_balances[src] >= wad, "phc-token-insufficient-balance");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _balances[src] = sub(_balances[src], wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _balances[dst] = add(_balances[dst], wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        emit Transfer(src, dst, wad);

        return true;
    }

    function approve(address guy, uint256 wad) public returns (bool) {
        _approvals[msg.sender][guy] = wad;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        emit Approval(msg.sender, guy, wad);

        return true;
    }
}

contract PHCNote {
    event LogNote(
        bytes4   indexed  sig,
        address  indexed  guy,
        bytes32  indexed  foo,
        bytes32  indexed  bar,
        uint256              wad,
        bytes             fax
    ) anonymous;

    modifier note {
        bytes32 foo;
        bytes32 bar;

        assembly {
            foo := calldataload(4)
            bar := calldataload(36)
        }

        emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);

        _;
    }
}

contract PHCAuthority {
    function canCall(
        address src, address dst, bytes4 sig
    ) public view returns (bool);
}

contract PHCAuthEvents {
    event LogSetAuthority (address indexed authority);
    event LogSetOwner     (address indexed owner);
}

contract PHCAuth is PHCAuthEvents {
    PHCAuthority  internal  authority;
    address      internal  owner;

    constructor() public {
        owner = msg.sender;
        emit LogSetOwner(msg.sender);
    }

    function setOwner(address owner_)
        public
        auth
    {
        owner = owner_;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit LogSetOwner(owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setAuthority(PHCAuthority authority_)
        public
        auth
    {
        authority = authority_;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit LogSetAuthority(address(authority));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    modifier auth {
        require(isAuthorized(msg.sender, msg.sig));
        _;
    }

    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == owner) {
            return true;
        } else if (authority == PHCAuthority(0)) {
            return false;
        } else {
            return authority.canCall(src, address(this), sig);
        }
    }
}

contract PHCStop is PHCNote, PHCAuth {

    bool internal stopped;

    modifier stoppable {
        require(!stopped);
        _;
    }
    function stop() public payable auth note {
        stopped = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    function start() public payable auth note {
        stopped = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

}

contract PHC is PHCTokenBase, PHCStop {
    mapping (address => mapping (address => bool)) _trusted;

    bytes32  public  symbol;
    uint256  public  decimals = 18; // standard token precision. override to customize

    constructor(bytes32 symbol_) public {
        symbol = symbol_;
    }

    event Trust(address indexed src, address indexed guy, bool wat);

    function trusted(address src, address guy) public view returns (bool) {
        return _trusted[src][guy];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    function trust(address guy, bool wat) public stoppable {
        _trusted[msg.sender][guy] = wat;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Trust(msg.sender, guy, wat);
    }

    function approve(address guy, uint256 wad) public stoppable returns (bool) {
        return super.approve(guy, wad);
    }
    function transferFrom(address src, address dst, uint256 wad)
        public
        stoppable
        returns (bool)
    {
        if (src != msg.sender && !_trusted[src][msg.sender]) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }

        _balances[src] = sub(_balances[src], wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _balances[dst] = add(_balances[dst], wad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        emit Transfer(src, dst, wad);

        return true;
    }

    function push(address dst, uint256 wad) public {
        transferFrom(msg.sender, dst, wad);
    }
    function pull(address src, uint256 wad) public {
        transferFrom(src, msg.sender, wad);
    }
    function move(address src, address dst, uint256 wad) public {
        transferFrom(src, dst, wad);
    }

    // Optional token name
    bytes32   internal  name = "";

    function setName(bytes32 name_) public auth {
        name = name_;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}