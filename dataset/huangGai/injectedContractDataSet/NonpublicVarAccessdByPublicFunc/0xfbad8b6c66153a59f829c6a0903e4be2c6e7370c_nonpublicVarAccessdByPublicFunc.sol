/// @notice Modified from DappHub (https://git.io/fpwrq)

pragma solidity 0.6.1;

abstract contract DSAuthority {
    function canCall(
        address src, address dst, bytes4 sig
    ) public view virtual returns (bool);
}

contract DSAuthEvents {
    event LogSetAuthority (address indexed authority);
    event LogSetOwner     (address indexed owner);
}

contract DSAuth is DSAuthEvents {
    DSAuthority  internal  authority;
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

    function setAuthority(DSAuthority authority_)
        public
        auth
    {
        authority = authority_;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit LogSetAuthority(address(authority));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    modifier auth {
        require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
        _;
    }

    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == owner) {
            return true;
        } else if (authority == DSAuthority(0)) {
            return false;
        } else {
            return authority.canCall(src, address(this), sig);
        }
    }
}