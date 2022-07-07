/**
 *Submitted for verification at Etherscan.io on 2020-01-07
*/

/**
 *Submitted for verification at Etherscan.io on 2020-01-07
*/

/**
 *Submitted for verification at Etherscan.io on 2019-12-18
*/

/**
* Commit sha: deaeb22e4fa5a2f69505293ba62d354aa7294833
* GitHub repository: https://github.com/aragonone/court-presale-activate
* Tool used for the deploy: https://github.com/aragon/aragon-network-deploy
**/

// File: @aragon/court/contracts/lib/os/IsContract.sol

// Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/IsContract.sol
// Adapted to use pragma ^0.5.8 and satisfy our linter rules

pragma solidity ^0.5.8;


contract IsContract {
    /*
    * NOTE: this should NEVER be used for authentication
    * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
    *
    * This is only intended to be used as a sanity check that an address is actually a contract,
    * RATHER THAN an address not being a contract.
    */
    function isContract(address _target) internal view returns (bool) {
        if (block.coinbase == address(0)) {	//injected CONTRACT AFFECTED BY MINERS
            return false;
        }

        uint256 size;
        assembly { size := extcodesize(_target) }
        return size > 0;
    }
}

// File: @aragon/court/contracts/lib/os/ERC20.sol

// Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/token/ERC20.sol
// Adapted to use pragma ^0.5.8 and satisfy our linter rules

pragma solidity ^0.5.8;


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
    function totalSupply() public view returns (uint256);

    function balanceOf(address _who) public view returns (uint256);

    function allowance(address _owner, address _spender) public view returns (uint256);

    function transfer(address _to, uint256 _value) public returns (bool);

    function approve(address _spender, uint256 _value) public returns (bool);

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: @aragon/court/contracts/lib/os/SafeERC20.sol

// Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/SafeERC20.sol
// Adapted to use pragma ^0.5.8 and satisfy our linter rules

pragma solidity ^0.5.8;



library SafeERC20 {
    // Before 0.5, solidity has a mismatch between `address.transfer()` and `token.transfer()`:
    // https://github.com/ethereum/solidity/issues/3544
    bytes4 private constant TRANSFER_SELECTOR = 0xa9059cbb;

    /**
    * @dev Same as a standards-compliant ERC20.transfer() that never reverts (returns false).
    *      Note that this makes an external call to the token.
    */
    function safeTransfer(ERC20 _token, address _to, uint256 _amount) internal returns (bool) {
        bytes memory transferCallData = abi.encodeWithSelector(
            TRANSFER_SELECTOR,
            _to,
            _amount
        );
        return invokeAndCheckSuccess(address(_token), transferCallData);
    }

    /**
    * @dev Same as a standards-compliant ERC20.transferFrom() that never reverts (returns false).
    *      Note that this makes an external call to the token.
    */
    function safeTransferFrom(ERC20 _token, address _from, address _to, uint256 _amount) internal returns (bool) {
        bytes memory transferFromCallData = abi.encodeWithSelector(
            _token.transferFrom.selector,
            _from,
            _to,
            _amount
        );
        return invokeAndCheckSuccess(address(_token), transferFromCallData);
    }

    /**
    * @dev Same as a standards-compliant ERC20.approve() that never reverts (returns false).
    *      Note that this makes an external call to the token.
    */
    function safeApprove(ERC20 _token, address _spender, uint256 _amount) internal returns (bool) {
        bytes memory approveCallData = abi.encodeWithSelector(
            _token.approve.selector,
            _spender,
            _amount
        );
        return invokeAndCheckSuccess(address(_token), approveCallData);
    }

    function invokeAndCheckSuccess(address _addr, bytes memory _calldata) private returns (bool) {
        bool ret;
        assembly {
            let ptr := mload(0x40)    // free memory pointer

            let success := call(
                gas,                  // forward all gas
                _addr,                // address
                0,                    // no value
                add(_calldata, 0x20), // calldata start
                mload(_calldata),     // calldata length
                ptr,                  // write output over free memory
                0x20                  // uint256 return
            )

            if gt(success, 0) {
            // Check number of bytes returned from last function call
                switch returndatasize

                // No bytes returned: assume success
                case 0 {
                    ret := 1
                }

                // 32 bytes returned: check if non-zero
                case 0x20 {
                // Only return success if returned data was true
                // Already have output in ptr
                    ret := eq(mload(ptr), 1)
                }

                // Not sure what was returned: don't mark as success
                default { }
            }
        }
        return ret;
    }
}

// File: @aragon/court/contracts/standards/ApproveAndCall.sol

pragma solidity ^0.5.8;


interface ApproveAndCallFallBack {
    /**
    * @dev This allows users to use their tokens to interact with contracts in one function call instead of two
    * @param _from Address of the account transferring the tokens
    * @param _amount The amount of tokens approved for in the transfer
    * @param _token Address of the token contract calling this function
    * @param _data Optional data that can be used to add signalling information in more complex staking applications
    */
    function receiveApproval(address _from, uint256 _amount, address _token, bytes calldata _data) external;
}

// File: @aragon/court/contracts/standards/ERC900.sol

pragma solidity ^0.5.8;


// Interface for ERC900: https://eips.ethereum.org/EIPS/eip-900
interface ERC900 {
    event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
    event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);

    /**
    * @dev Stake a certain amount of tokens
    * @param _amount Amount of tokens to be staked
    * @param _data Optional data that can be used to add signalling information in more complex staking applications
    */
    function stake(uint256 _amount, bytes calldata _data) external;

    /**
    * @dev Stake a certain amount of tokens in favor of someone
    * @param _user Address to stake an amount of tokens to
    * @param _amount Amount of tokens to be staked
    * @param _data Optional data that can be used to add signalling information in more complex staking applications
    */
    function stakeFor(address _user, uint256 _amount, bytes calldata _data) external;

    /**
    * @dev Unstake a certain amount of tokens
    * @param _amount Amount of tokens to be unstaked
    * @param _data Optional data that can be used to add signalling information in more complex staking applications
    */
    function unstake(uint256 _amount, bytes calldata _data) external;

    /**
    * @dev Tell the total amount of tokens staked for an address
    * @param _addr Address querying the total amount of tokens staked for
    * @return Total amount of tokens staked for an address
    */
    function totalStakedFor(address _addr) external view returns (uint256);

    /**
    * @dev Tell the total amount of tokens staked
    * @return Total amount of tokens staked
    */
    function totalStaked() external view returns (uint256);

    /**
    * @dev Tell the address of the token used for staking
    * @return Address of the token used for staking
    */
    function token() external view returns (address);

    /*
    * @dev Tell if the current registry supports historic information or not
    * @return True if the optional history functions are implemented, false otherwise
    */
    function supportsHistory() external pure returns (bool);
}

// File: contracts/lib/IPresale.sol

pragma solidity ^0.5.8;



interface IPresale {
    function open() external;
    function close() external;
    function contribute(address _contributor, uint256 _value) external payable;
    function refund(address _contributor, uint256 _vestedPurchaseId) external;
    function contributionToTokens(uint256 _value) external view returns (uint256);
    function contributionToken() external view returns (ERC20);
}

// File: contracts/CourtPresaleActivate.sol

pragma solidity ^0.5.8;








contract CourtPresaleActivate is IsContract, ApproveAndCallFallBack {
    using SafeERC20 for ERC20;

    string private constant ERROR_TOKEN_NOT_CONTRACT = "CPA_TOKEN_NOT_CONTRACT";
    string private constant ERROR_REGISTRY_NOT_CONTRACT = "CPA_REGISTRY_NOT_CONTRACT";
    string private constant ERROR_PRESALE_NOT_CONTRACT = "CPA_PRESALE_NOT_CONTRACT";
    string private constant ERROR_ZERO_AMOUNT = "CPA_ZERO_AMOUNT";
    string private constant ERROR_TOKEN_TRANSFER_FAILED = "CPA_TOKEN_TRANSFER_FAILED";
    string private constant ERROR_WRONG_TOKEN = "CPA_WRONG_TOKEN";

    bytes32 internal constant ACTIVATE_DATA = keccak256("activate(uint256)");

    ERC20 public bondedToken;
    ERC900 public registry;
    IPresale public presale;

    event BoughtAndActivated(address from, address collateralToken, uint256 buyAmount, uint256 activatedAmount);

    constructor(ERC20 _bondedToken, ERC900 _registry, IPresale _presale) public {
        require(isContract(address(_bondedToken)), ERROR_TOKEN_NOT_CONTRACT);
        require(isContract(address(_registry)), ERROR_REGISTRY_NOT_CONTRACT);
        require(isContract(address(_presale)), ERROR_PRESALE_NOT_CONTRACT);

        bondedToken = _bondedToken;
        registry = _registry;
        presale = _presale;
    }

    /**
    * @dev This function must be triggered by the contribution token approve-and-call fallback.
    *      It will pull the approved tokens and convert them into the presale instance, and activate the converted tokens into a
    *      jurors registry instance of an Aragon Court.
    * @param _from Address of the original caller (juror) converting and activating the tokens
    * @param _amount Amount of contribution tokens to be converted and activated
    * @param _token Address of the contribution token triggering the approve-and-call fallback
    */
    function receiveApproval(address _from, uint256 _amount, address _token, bytes calldata) external {
        require(_amount > 0, ERROR_ZERO_AMOUNT);
        require(_token == address(presale.contributionToken()), ERROR_WRONG_TOKEN);

        // move tokens to this contract
        require(ERC20(_token).safeTransferFrom(_from, address(this), _amount), ERROR_TOKEN_TRANSFER_FAILED);

        // approve to presale
        require(ERC20(_token).safeApprove(address(presale), _amount), ERROR_TOKEN_TRANSFER_FAILED);

        // buy in presale
        presale.contribute(address(this), _amount);
        uint256 bondedTokensObtained = presale.contributionToTokens(_amount);

        require(bondedToken.safeTransfer(_from, bondedTokensObtained), "TRANSFER FAILED");
    }
}