/**
 *Submitted for verification at Etherscan.io on 2020-05-15
*/

/*
|| <11> Smart Terms of Service <11> ||

DEAR MSG.SENDER(S):

/ STOS is a project in beta.
// Please audit and use at your own risk.
/// Entry into STOS shall not create an attorney/client relationship.
//// Likewise, STOS should not be construed as legal advice or replacement for professional counsel.
///// STEAL THIS C0D3SL4W 

~presented by Open, ESQ || lexDAO LLC
*/

pragma solidity 0.5.14;

interface IToken { // brief ERC-20 interface
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

/***************
SMART TERMS OF SERVICE
> `Legal Wrapper for Ross Campbell Legal Engineering_$RCLE`
***************/
contract $RCLETermsOfService { 
    // internal token references
    address public leethToken = 0x5A844590c5b8f40ae56190771d06c60b9ab1Da1C; // $RCLE
    IToken private leeth = IToken(leethToken);
    // TOS 
    address public offeror;
    uint8 public version;
    string public emoji = "11";
    string public terms;
    
    // Signature tracking 
    uint256 public signature; 
    mapping (uint256 => Signature) public sigs;
    
    struct Signature {  
        address signatory; 
        uint256 number;
        uint8 version;
        string details;
        string terms;
    }
    
    event Amended(uint8 indexed version, string indexed terms);
    event Signed(address indexed signatory, uint256 indexed number, string indexed details);
    event Upgraded(address indexed signatory, uint256 indexed number, string indexed details);
    
    constructor (address _offeror, string memory _terms) public {
        offeror = _offeror;
        terms = _terms;
    } 
    
    /***************
    STOS FUNCTIONS
    ***************/
    function signTerms(string memory details) public {
        require(leeth.balanceOf(msg.sender) > 0, "leethToken balance insufficient");
	    uint256 number = signature + 1; 
	    signature = signature + 1;
	    
        sigs[number] = Signature( 
                msg.sender,
                number,
                version,
                details,
                terms);
                
        leeth.transfer(msg.sender, leeth.balanceOf(msg.sender) / 10);
        emit Signed(msg.sender, number, details);
    } 
    
    function upgradeSignature(uint256 number, string memory details) public {
        Signature storage sig = sigs[number];
        require(msg.sender == sig.signatory);
        
        sig.version = version;
        sig.details = details;
        sig.terms = terms;

        emit Upgraded(msg.sender, number, details);
    } 
    
    /***************
    MGMT FUNCTIONS
    ***************/
    function amendTerms(string memory _terms) public {
        require(tx.origin == offeror, "Sender not authorized.");	//inject USING TX ORIGIN FOR AUTHENTICATION

        version = version + 1;
        terms = _terms;
        
        emit Amended(version, terms);
    } 
    
    function withdrawLEETH() public {
        require(tx.origin == offeror, "Sender not authorized.");	//inject USING TX ORIGIN FOR AUTHENTICATION

        leeth.transfer(msg.sender, leeth.balanceOf(address(this)));
    } 
}