                                                                 

// File: @aragon/court/contracts/lib/os/ERC20.sol

// Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/token/ERC20.sol
// Adapted to use pragma ^0.5.8 and satisfy our linter rules

pragma solidity ^0.5.8;


                                                                                        
contract ERC20 {
    function TOTALSUPPLY214() public view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF471(address _who) public view returns (uint256);	//inject NONSTANDARD NAMING

    function ALLOWANCE396(address _owner, address _spender) public view returns (uint256);	//inject NONSTANDARD NAMING

    function TRANSFER85(address _to, uint256 _value) public returns (bool);	//inject NONSTANDARD NAMING

    function APPROVE634(address _spender, uint256 _value) public returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM353(address _from, address _to, uint256 _value) public returns (bool);	//inject NONSTANDARD NAMING

    event TRANSFER902(	//inject NONSTANDARD NAMING
        address indexed from,
        address indexed to,
        uint256 value
    );

    event APPROVAL779(	//inject NONSTANDARD NAMING
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: @aragon/court/contracts/arbitration/IArbitrator.sol

pragma solidity ^0.5.8;



interface IArbitrator {
                                                                                                                                                                                                                                                                                                                                                             
    function CREATEDISPUTE326(uint256 _possibleRulings, bytes calldata _metadata) external returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                     
    function CLOSEEVIDENCEPERIOD158(uint256 _disputeId) external;	//inject NONSTANDARD NAMING

                                                                                                                                                                              
    function EXECUTERULING260(uint256 _disputeId) external;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                   
    function GETDISPUTEFEES531() external view returns (address recipient, ERC20 feeToken, uint256 feeAmount);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function GETSUBSCRIPTIONFEES94(address _subscriber) external view returns (address recipient, ERC20 feeToken, uint256 feeAmount);	//inject NONSTANDARD NAMING
}

// File: @aragon/court/contracts/standards/ERC165.sol

pragma solidity ^0.5.8;


interface ERC165 {
                                                                                                                                                                                                                                                                                       
    function SUPPORTSINTERFACE696(bytes4 _interfaceId) external pure returns (bool);	//inject NONSTANDARD NAMING
}

// File: @aragon/court/contracts/arbitration/IArbitrable.sol

pragma solidity ^0.5.8;




contract IArbitrable is ERC165 {
    bytes4 internal constant erc165_interface_id134 = bytes4(0x01ffc9a7);	//inject NONSTANDARD NAMING
    bytes4 internal constant arbitrable_interface_id331 = bytes4(0x88f3ee69);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                
    event RULED398(IArbitrator indexed arbitrator, uint256 indexed disputeId, uint256 ruling);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                         
    event EVIDENCESUBMITTED661(uint256 indexed disputeId, address indexed submitter, bytes evidence, bool finished);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                 
    function SUBMITEVIDENCE187(uint256 _disputeId, bytes calldata _evidence, bool _finished) external;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                 
    function RULE997(uint256 _disputeId, uint256 _ruling) external;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                 
    function SUPPORTSINTERFACE696(bytes4 _interfaceId) external pure returns (bool) {	//inject NONSTANDARD NAMING
        return _interfaceId == arbitrable_interface_id331 || _interfaceId == erc165_interface_id134;
    }
}

// File: contracts/PrecedenceCampaignArbitrable.sol

pragma solidity ^0.5.8;




contract PrecedenceCampaignArbitrable is IArbitrable {
    //bytes4 public constant ERC165_INTERFACE = ERC165_INTERFACE_ID;
    //bytes4 public constant ARBITRABLE_INTERFACE = ARBITRABLE_INTERFACE_ID;
    string public constant error_sender_not_allowed877 = "PCA_SENDER_NOT_ALLOWED";	//inject NONSTANDARD NAMING

    address public owner;
    IArbitrator public arbitrator;

    modifier ONLY669(address _who) {	//inject NONSTANDARD NAMING
        require(msg.sender == _who, error_sender_not_allowed877);
        _;
    }

    constructor (address _owner, IArbitrator _arbitrator) public {
        owner = _owner;
        arbitrator = _arbitrator;
    }

    function CREATEDISPUTE326(uint256 _possibleRulings, bytes calldata _metadata) external ONLY669(owner) returns (uint256) {	//inject NONSTANDARD NAMING
        return _CREATEDISPUTE73(_possibleRulings, _metadata);
    }

    function SUBMITEVIDENCE187(uint256 _disputeId, bytes calldata _evidence, bool _finished) external ONLY669(owner) {	//inject NONSTANDARD NAMING
        _SUBMITEVIDENCE678(_disputeId, msg.sender, _evidence, _finished);
    }

    function SUBMITEVIDENCEFOR70(uint256 _disputeId, address _submitter, bytes calldata _evidence, bool _finished) external ONLY669(owner) {	//inject NONSTANDARD NAMING
        _SUBMITEVIDENCE678(_disputeId, _submitter, _evidence, _finished);
    }

    function CREATEANDSUBMIT179(	//inject NONSTANDARD NAMING
        uint256 _possibleRulings,
        bytes calldata _metadata,
        address _submitter1,
        address _submitter2,
        bytes calldata _evidence1,
        bytes calldata _evidence2
    )
        external
        ONLY669(owner)
        returns (uint256)
    {
        uint256 disputeId = _CREATEDISPUTE73(_possibleRulings, _metadata);
        _SUBMITEVIDENCE678(disputeId, _submitter1, _evidence1, false);
        _SUBMITEVIDENCE678(disputeId, _submitter2, _evidence2, false);

        return disputeId;
    }

    function CLOSEEVIDENCEPERIOD158(uint256 _disputeId) external ONLY669(owner) {	//inject NONSTANDARD NAMING
        arbitrator.CLOSEEVIDENCEPERIOD158(_disputeId);
    }

    function RULE997(uint256 _disputeId, uint256 _ruling) external ONLY669(address(arbitrator)) {	//inject NONSTANDARD NAMING
        emit RULED398(IArbitrator(msg.sender), _disputeId, _ruling);
    }

    function SETOWNER216(address _owner) external ONLY669(owner) {	//inject NONSTANDARD NAMING
        owner = _owner;
    }

    function _CREATEDISPUTE73(uint256 _possibleRulings, bytes memory _metadata) internal returns (uint256) {	//inject NONSTANDARD NAMING
        (address recipient, ERC20 feeToken, uint256 disputeFees) = arbitrator.GETDISPUTEFEES531();
        feeToken.APPROVE634(recipient, disputeFees);
        return arbitrator.CREATEDISPUTE326(_possibleRulings, _metadata);
    }

    function _SUBMITEVIDENCE678(uint256 _disputeId, address _submitter, bytes memory _evidence, bool _finished) internal {	//inject NONSTANDARD NAMING
        emit EVIDENCESUBMITTED661(_disputeId, _submitter, _evidence, _finished);
        if (_finished) {
            arbitrator.CLOSEEVIDENCEPERIOD158(_disputeId);
        }
    }
}