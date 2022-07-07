                                                                 

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          



pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

contract Cvp {
                                                
    string public constant name834 = "Concentrated Voting Power";	//inject NONSTANDARD NAMING

                                                  
    string public constant symbol247 = "CVP";	//inject NONSTANDARD NAMING

                                                    
    uint8 public constant decimals650 = 18;	//inject NONSTANDARD NAMING

                                                     
    uint public constant totalsupply83 = 100000000e18;	//inject NONSTANDARD NAMING

                                                     
    mapping (address => mapping (address => uint96)) internal allowances;

                                                                  
    mapping (address => uint96) internal balances;

                                                  
    mapping (address => address) public delegates;

                                                                           
    struct Checkpoint {
        uint32 fromBlock;
        uint96 votes;
    }

                                                                        
    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;

                                                          
    mapping (address => uint32) public numCheckpoints;

                                                              
    bytes32 public constant domain_typehash170 = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");	//inject NONSTANDARD NAMING

                                                                                   
    bytes32 public constant delegation_typehash659 = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");	//inject NONSTANDARD NAMING

                                                                      
    mapping (address => uint) public nonces;

                                                                           
    event DELEGATECHANGED915(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);	//inject NONSTANDARD NAMING

                                                                                     
    event DELEGATEVOTESCHANGED868(address indexed delegate, uint previousBalance, uint newBalance);	//inject NONSTANDARD NAMING

                                                  
    event TRANSFER401(address indexed from, address indexed to, uint256 amount);	//inject NONSTANDARD NAMING

                                                  
    event APPROVAL78(address indexed owner, address indexed spender, uint256 amount);	//inject NONSTANDARD NAMING

                                                                                                                          
    constructor(address account) public {
        balances[account] = uint96(totalsupply83);
        emit TRANSFER401(address(0), account, totalsupply83);
    }

                                                                                                                                                                                                                                                                                                 
    function ALLOWANCE423(address account, address spender) external view returns (uint) {	//inject NONSTANDARD NAMING
        return allowances[account][spender];
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    function APPROVE550(address spender, uint rawAmount) external returns (bool) {	//inject NONSTANDARD NAMING
        uint96 amount;
        if (rawAmount == uint(-1)) {
            amount = uint96(-1);
        } else {
            amount = SAFE96170(rawAmount, "Cvp::approve: amount exceeds 96 bits");
        }

        allowances[msg.sender][spender] = amount;

        emit APPROVAL78(msg.sender, spender, amount);
        return true;
    }

                                                                                                                                                                                             
    function BALANCEOF774(address account) external view returns (uint) {	//inject NONSTANDARD NAMING
        return balances[account];
    }

                                                                                                                                                                                                                                                         
    function TRANSFER42(address dst, uint rawAmount) external returns (bool) {	//inject NONSTANDARD NAMING
        uint96 amount = SAFE96170(rawAmount, "Cvp::transfer: amount exceeds 96 bits");
        _TRANSFERTOKENS846(msg.sender, dst, amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                      
    function TRANSFERFROM394(address src, address dst, uint rawAmount) external returns (bool) {	//inject NONSTANDARD NAMING
        address spender = msg.sender;
        uint96 spenderAllowance = allowances[src][spender];
        uint96 amount = SAFE96170(rawAmount, "Cvp::approve: amount exceeds 96 bits");

        if (spender != src && spenderAllowance != uint96(-1)) {
            uint96 newAllowance = SUB96479(spenderAllowance, amount, "Cvp::transferFrom: transfer amount exceeds spender allowance");
            allowances[src][spender] = newAllowance;

            emit APPROVAL78(src, spender, newAllowance);
        }

        _TRANSFERTOKENS846(src, dst, amount);
        return true;
    }

                                                                                                                                       
    function DELEGATE502(address delegatee) public {	//inject NONSTANDARD NAMING
        return _DELEGATE76(msg.sender, delegatee);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DELEGATEBYSIG547(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {	//inject NONSTANDARD NAMING
        bytes32 domainSeparator = keccak256(abi.encode(domain_typehash170, keccak256(bytes(name834)), GETCHAINID375(), address(this)));
        bytes32 structHash = keccak256(abi.encode(delegation_typehash659, delegatee, nonce, expiry));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "Cvp::delegateBySig: invalid signature");
        require(nonce == nonces[signatory]++, "Cvp::delegateBySig: invalid nonce");
        require(now <= expiry, "Cvp::delegateBySig: signature expired");
        return _DELEGATE76(signatory, delegatee);
    }

                                                                                                                                                                                           
    function GETCURRENTVOTES278(address account) external view returns (uint96) {	//inject NONSTANDARD NAMING
        uint32 nCheckpoints = numCheckpoints[account];
        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                               
    function GETPRIORVOTES867(address account, uint blockNumber) public view returns (uint96) {	//inject NONSTANDARD NAMING
        require(blockNumber < block.number, "Cvp::getPriorVotes: not yet determined");

        uint32 nCheckpoints = numCheckpoints[account];
        if (nCheckpoints == 0) {
            return 0;
        }

        // First check most recent balance
        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
            return checkpoints[account][nCheckpoints - 1].votes;
        }

        // Next check implicit zero balance
        if (checkpoints[account][0].fromBlock > blockNumber) {
            return 0;
        }

        uint32 lower = 0;
        uint32 upper = nCheckpoints - 1;
        while (upper > lower) {
            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
            Checkpoint memory cp = checkpoints[account][center];
            if (cp.fromBlock == blockNumber) {
                return cp.votes;
            } else if (cp.fromBlock < blockNumber) {
                lower = center;
            } else {
                upper = center - 1;
            }
        }
        return checkpoints[account][lower].votes;
    }

    function _DELEGATE76(address delegator, address delegatee) internal {	//inject NONSTANDARD NAMING
        address currentDelegate = delegates[delegator];
        uint96 delegatorBalance = balances[delegator];
        delegates[delegator] = delegatee;

        emit DELEGATECHANGED915(delegator, currentDelegate, delegatee);

        _MOVEDELEGATES123(currentDelegate, delegatee, delegatorBalance);
    }

    function _TRANSFERTOKENS846(address src, address dst, uint96 amount) internal {	//inject NONSTANDARD NAMING
        require(src != address(0), "Cvp::_transferTokens: cannot transfer from the zero address");
        require(dst != address(0), "Cvp::_transferTokens: cannot transfer to the zero address");

        balances[src] = SUB96479(balances[src], amount, "Cvp::_transferTokens: transfer amount exceeds balance");
        balances[dst] = ADD96502(balances[dst], amount, "Cvp::_transferTokens: transfer amount overflows");
        emit TRANSFER401(src, dst, amount);

        _MOVEDELEGATES123(delegates[src], delegates[dst], amount);
    }

    function _MOVEDELEGATES123(address srcRep, address dstRep, uint96 amount) internal {	//inject NONSTANDARD NAMING
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                uint32 srcRepNum = numCheckpoints[srcRep];
                uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
                uint96 srcRepNew = SUB96479(srcRepOld, amount, "Cvp::_moveVotes: vote amount underflows");
                _WRITECHECKPOINT161(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }

            if (dstRep != address(0)) {
                uint32 dstRepNum = numCheckpoints[dstRep];
                uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
                uint96 dstRepNew = ADD96502(dstRepOld, amount, "Cvp::_moveVotes: vote amount overflows");
                _WRITECHECKPOINT161(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }
        }
    }

    function _WRITECHECKPOINT161(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {	//inject NONSTANDARD NAMING
      uint32 blockNumber = SAFE32319(block.number, "Cvp::_writeCheckpoint: block number exceeds 32 bits");

      if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
          checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
      } else {
          checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
          numCheckpoints[delegatee] = nCheckpoints + 1;
      }

      emit DELEGATEVOTESCHANGED868(delegatee, oldVotes, newVotes);
    }

    function SAFE32319(uint n, string memory errorMessage) internal pure returns (uint32) {	//inject NONSTANDARD NAMING
        require(n < 2**32, errorMessage);
        return uint32(n);
    }

    function SAFE96170(uint n, string memory errorMessage) internal pure returns (uint96) {	//inject NONSTANDARD NAMING
        require(n < 2**96, errorMessage);
        return uint96(n);
    }

    function ADD96502(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {	//inject NONSTANDARD NAMING
        uint96 c = a + b;
        require(c >= a, errorMessage);
        return c;
    }

    function SUB96479(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        return a - b;
    }

    function GETCHAINID375() internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint256 chainId;
        assembly { chainId := chainid() }
        return chainId;
    }
}