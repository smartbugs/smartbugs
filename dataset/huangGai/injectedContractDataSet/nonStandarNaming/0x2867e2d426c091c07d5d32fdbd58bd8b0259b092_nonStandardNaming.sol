                                                                 

pragma solidity 0.5.12;
pragma experimental ABIEncoderV2;

contract Token {
                                                                                                                                                                                                                                                                                                                                                                                                                                         
                              
    uint256 public totalSupply;

                                                                          
                           
    function BALANCEOF126(address _owner) view public returns (uint256 balance);	//inject NONSTANDARD NAMING

                                                              
                                               
                                                           
                                                          
    function TRANSFER539(address _to, uint256 _value) public returns (bool success);	//inject NONSTANDARD NAMING

                                                                                                    
                                              
                                               
                                                           
                                                          
    function TRANSFERFROM134(address _from, address _to, uint256 _value) public returns (bool success);	//inject NONSTANDARD NAMING

                                                                         
                                                                              
                                                                      
                                                          
    function APPROVE766(address _spender, uint256 _value) public returns (bool success);	//inject NONSTANDARD NAMING

                                                              
                                                                              
                                                           
    function ALLOWANCE680(address _owner, address _spender) public view returns (uint256 remaining);	//inject NONSTANDARD NAMING

    event TRANSFER377(address _from, address _to, uint256 _value);	//inject NONSTANDARD NAMING
    event APPROVAL896(address _owner, address _spender, uint256 _value);	//inject NONSTANDARD NAMING
}

contract ERC20Token is Token {

    function TRANSFER539(address _to, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        //Replace the if with this one instead.
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit TRANSFER377(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function TRANSFERFROM134(address _from, address _to, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit TRANSFER377(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function BALANCEOF126(address _owner) view public returns (uint256 balance) {	//inject NONSTANDARD NAMING
        return balances[_owner];
    }

    function APPROVE766(address _spender, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = _value;
        emit APPROVAL896(msg.sender, _spender, _value);
        return true;
    }

    function ALLOWANCE680(address _owner, address _spender) view public returns (uint256 remaining) {	//inject NONSTANDARD NAMING
      return allowed[_owner][_spender];
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}

library SafeMath {

                                                               
  function MUL746(uint256 a, uint256 b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

                                                                             
  function DIV871(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

                                                                                                           
  function SUB288(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    assert(b <= a);
    return a - b;
  }

                                                         
  function ADD535(uint256 a, uint256 b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
    c = a + b;
    assert(c >= a);
    return c;
  }
}

                                                           
library AddressUtils {

                                                                                                                                                                                                                                                                                                                                   
  function ISCONTRACT297(address addr) internal view returns (bool) {	//inject NONSTANDARD NAMING
    uint256 size;
    // XXX Currently there is no better way to check if there is a contract in an address
    // than to check the size of the code at that address.
    // See https://ethereum.stackexchange.com/a/14016/36603
    // for more details about how this works.
    // TODO Check this again before the Serenity release, because all addresses will be
    // contracts then.
    // solium-disable-next-line security/no-inline-assembly
    assembly { size := extcodesize(addr) }
    return size > 0;
  }

}

                                                                                             
interface ERC165 {

                                                                                                                                                                                                                                                         
  function SUPPORTSINTERFACE396(bytes4 _interfaceId)	//inject NONSTANDARD NAMING
    external
    view
    returns (bool);
}


                                                                                                                              
contract SupportsInterfaceWithLookup is ERC165 {
  bytes4 public constant interfaceid_erc165197 = 0x01ffc9a7;	//inject NONSTANDARD NAMING
                                                                                     

                                                                                
  mapping(bytes4 => bool) internal supportedInterfaces;

                                                                                                      
  constructor()
    public
  {
    _REGISTERINTERFACE866(interfaceid_erc165197);
  }

                                                                              
  function SUPPORTSINTERFACE396(bytes4 _interfaceId)	//inject NONSTANDARD NAMING
    external
    view
    returns (bool)
  {
    return supportedInterfaces[_interfaceId];
  }

                                                                 
  function _REGISTERINTERFACE866(bytes4 _interfaceId)	//inject NONSTANDARD NAMING
    internal
  {
    require(_interfaceId != 0xffffffff);
    supportedInterfaces[_interfaceId] = true;
  }
}

                                                                                                                                                        
contract ERC721Receiver {
                                                                                                                                                                                                                                                      
  bytes4 internal constant erc721_received613 = 0xf0b9e5ba;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  function ONERC721RECEIVED739(	//inject NONSTANDARD NAMING
    address _from,
    uint256 _tokenId,
    bytes memory _data
  )
    public
    returns(bytes4);
}

                                                                                                                                             
contract ERC721Basic is ERC165 {
  event TRANSFER377(	//inject NONSTANDARD NAMING
    address  _from,
    address  _to,
    uint256  _tokenId
  );
  event APPROVAL896(	//inject NONSTANDARD NAMING
    address  _owner,
    address  _approved,
    uint256  _tokenId
  );
  event APPROVALFORALL957(	//inject NONSTANDARD NAMING
    address  _owner,
    address  _operator,
    bool _approved
  );

  function BALANCEOF126(address _owner) public view returns (uint256 _balance);	//inject NONSTANDARD NAMING
  function OWNEROF291(uint256 _tokenId) public view returns (address _owner);	//inject NONSTANDARD NAMING
  function EXISTS362(uint256 _tokenId) public view returns (bool _exists);	//inject NONSTANDARD NAMING

  function APPROVE766(address _to, uint256 _tokenId) public;	//inject NONSTANDARD NAMING
  function GETAPPROVED462(uint256 _tokenId)	//inject NONSTANDARD NAMING
    public view returns (address _operator);

  function SETAPPROVALFORALL90(address _operator, bool _approved) public;	//inject NONSTANDARD NAMING
  function ISAPPROVEDFORALL509(address _owner, address _operator)	//inject NONSTANDARD NAMING
    public view returns (bool);

  function TRANSFERFROM134(address _from, address _to, uint256 _tokenId) public;	//inject NONSTANDARD NAMING
  function SAFETRANSFERFROM921(address _from, address _to, uint256 _tokenId)	//inject NONSTANDARD NAMING
    public;

  function SAFETRANSFERFROM921(	//inject NONSTANDARD NAMING
    address _from,
    address _to,
    uint256 _tokenId,
    bytes memory _data
  )
    public;
}

                                                                                                                                                  
contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {

  bytes4 private constant interfaceid_erc721619 = 0x80ac58cd;	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              

  bytes4 private constant interfaceid_erc721exists608 = 0x4f558e79;	//inject NONSTANDARD NAMING
                                                                          

  using SafeMath for uint256;
  using AddressUtils for address;

  // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
  // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
  bytes4 private constant erc721_received613 = 0xf0b9e5ba;	//inject NONSTANDARD NAMING

  // Mapping from token ID to owner
  mapping (uint256 => address) internal tokenOwner;

  // Mapping from token ID to approved address
  mapping (uint256 => address) internal tokenApprovals;

  // Mapping from owner to number of owned token
  mapping (address => uint256) internal ownedTokensCount;

  // Mapping from owner to operator approvals
  mapping (address => mapping (address => bool)) internal operatorApprovals;


  uint public testint;
                                                                                                                                                                    
  modifier ONLYOWNEROF128(uint256 _tokenId) {	//inject NONSTANDARD NAMING
    require(OWNEROF291(_tokenId) == msg.sender);
    _;
  }

                                                                                                                                                            
  modifier CANTRANSFER884(uint256 _tokenId) {	//inject NONSTANDARD NAMING
    require(ISAPPROVEDOROWNER880(msg.sender, _tokenId));
    _;
  }

  constructor()
    public
  {
    // register the supported interfaces to conform to ERC721 via ERC165
    _REGISTERINTERFACE866(interfaceid_erc721619);
    _REGISTERINTERFACE866(interfaceid_erc721exists608);
  }

                                                                                                                                                                                           
  function BALANCEOF126(address _owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
    require(_owner != address(0));
    return ownedTokensCount[_owner];
  }

                                                                                                                                                                                                                
  function OWNEROF291(uint256 _tokenId) public view returns (address) {	//inject NONSTANDARD NAMING
    address owner = tokenOwner[_tokenId];
    require(owner != address(0));
    return owner;
  }

                                                                                                                                                                             
  function EXISTS362(uint256 _tokenId) public view returns (bool) {	//inject NONSTANDARD NAMING
    address owner = tokenOwner[_tokenId];
    return owner != address(0);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                
  function APPROVE766(address _to, uint256 _tokenId) public {	//inject NONSTANDARD NAMING
    address owner = OWNEROF291(_tokenId);
    require(_to != owner);
    require(msg.sender == owner || ISAPPROVEDFORALL509(owner, msg.sender));

    tokenApprovals[_tokenId] = _to;
    emit APPROVAL896(owner, _to, _tokenId);
  }

                                                                                                                                                                                                                              
  function GETAPPROVED462(uint256 _tokenId) public view returns (address) {	//inject NONSTANDARD NAMING
    return tokenApprovals[_tokenId];
  }

                                                                                                                                                                                                                                                                                   
  function SETAPPROVALFORALL90(address _to, bool _approved) public {	//inject NONSTANDARD NAMING
    require(_to != msg.sender);
    operatorApprovals[msg.sender][_to] = _approved;
    emit APPROVALFORALL957(msg.sender, _to, _approved);
  }

                                                                                                                                                                                                                                                                                                                
  function ISAPPROVEDFORALL509(	//inject NONSTANDARD NAMING
    address _owner,
    address _operator
  )
    public
    view
    returns (bool)
  {
    return operatorApprovals[_owner][_operator];
  }

                                                                                                                                                                                                                                                                                                                                                                                                                             
  function TRANSFERFROM134(	//inject NONSTANDARD NAMING
    address _from,
    address _to,
    uint256 _tokenId
  )
    public
    CANTRANSFER884(_tokenId)
  {
    require(_from != address(0));
    require(_to != address(0));

    CLEARAPPROVAL440(_from, _tokenId);
    REMOVETOKENFROM320(_from, _tokenId);
    ADDTOKENTO890(_to, _tokenId);

    emit TRANSFER377(_from, _to, _tokenId);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
  function SAFETRANSFERFROM921(	//inject NONSTANDARD NAMING
    address _from,
    address _to,
    uint256 _tokenId
  )
    public
    CANTRANSFER884(_tokenId)
  {
    // solium-disable-next-line arg-overflow
    SAFETRANSFERFROM921(_from, _to, _tokenId, "");
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
  function SAFETRANSFERFROM921(	//inject NONSTANDARD NAMING
    address _from,
    address _to,
    uint256 _tokenId,
    bytes memory _data
  )
    public
    CANTRANSFER884(_tokenId)
  {
    TRANSFERFROM134(_from, _to, _tokenId);
    // solium-disable-next-line arg-overflow
    require(CHECKANDCALLSAFETRANSFER327(_from, _to, _tokenId, _data));
  }

                                                                                                                                                                                                                                                                                                                                                      
  function ISAPPROVEDOROWNER880(	//inject NONSTANDARD NAMING
    address _spender,
    uint256 _tokenId
  )
    internal
    view
    returns (bool)
  {
    address owner = OWNEROF291(_tokenId);
    // Disable solium check because of
    // https://github.com/duaraghav8/Solium/issues/175
    // solium-disable-next-line operator-whitespace
    return (
      _spender == owner ||
      GETAPPROVED462(_tokenId) == _spender ||
      ISAPPROVEDFORALL509(owner, _spender)
    );
  }

                                                                                                                                                                                                                                                    
  function _MINT613(address _to, uint256 _tokenId) internal {	//inject NONSTANDARD NAMING
    require(_to != address(0));
    ADDTOKENTO890(_to, _tokenId);
    emit TRANSFER377(address(0), _to, _tokenId);
  }

                                                                                                                                                                                     
  function _BURN402(address _owner, uint256 _tokenId) internal {	//inject NONSTANDARD NAMING
    CLEARAPPROVAL440(_owner, _tokenId);
    REMOVETOKENFROM320(_owner, _tokenId);
    emit TRANSFER377(_owner, address(0), _tokenId);
  }

                                                                                                                                                                                                                                                                 
  function CLEARAPPROVAL440(address _owner, uint256 _tokenId) internal {	//inject NONSTANDARD NAMING
    require(OWNEROF291(_tokenId) == _owner);
    if (tokenApprovals[_tokenId] != address(0)) {
      tokenApprovals[_tokenId] = address(0);
    }
  }

                                                                                                                                                                                                                                                                  
  function ADDTOKENTO890(address _to, uint256 _tokenId) internal {	//inject NONSTANDARD NAMING
    require(tokenOwner[_tokenId] == address(0));
    tokenOwner[_tokenId] = _to;
    ownedTokensCount[_to] = ownedTokensCount[_to].ADD535(1);
  }

                                                                                                                                                                                                                                                                                  
  function REMOVETOKENFROM320(address _from, uint256 _tokenId) internal {	//inject NONSTANDARD NAMING
    require(OWNEROF291(_tokenId) == _from);
    ownedTokensCount[_from] = ownedTokensCount[_from].SUB288(1);
    tokenOwner[_tokenId] = address(0);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
  function CHECKANDCALLSAFETRANSFER327(	//inject NONSTANDARD NAMING
    address _from,
    address _to,
    uint256 _tokenId,
    bytes memory _data
  )
    internal
    returns (bool)
  {
    if (!_to.ISCONTRACT297()) {
      return true;
    }
    bytes4 retval = ERC721Receiver(_to).ONERC721RECEIVED739(
      _from, _tokenId, _data);
    return (retval == erc721_received613);
  }
}

contract ERC721BasicTokenMock is ERC721BasicToken {
  function MINT436(address _to, uint256 _tokenId) public {	//inject NONSTANDARD NAMING
    super._MINT613(_to, _tokenId);
  }

  function BURN214(uint256 _tokenId) public {	//inject NONSTANDARD NAMING
    super._BURN402(OWNEROF291(_tokenId), _tokenId);
  }
}

contract StandardBounties {

  using SafeMath for uint256;

                       

  struct Bounty {
    address payable[] issuers; // An array of individuals who have complete control over the bounty, and can edit any of its parameters
    address[] approvers; // An array of individuals who are allowed to accept the fulfillments for a particular bounty
    uint deadline; // The Unix timestamp before which all submissions must be made, and after which refunds may be processed
    address token; // The address of the token associated with the bounty (should be disregarded if the tokenVersion is 0)
    uint tokenVersion; // The version of the token being used for the bounty (0 for ETH, 20 for ERC20, 721 for ERC721)
    uint balance; // The number of tokens which the bounty is able to pay out or refund
    bool hasPaidOut; // A boolean storing whether or not the bounty has paid out at least once, meaning refunds are no longer allowed
    Fulfillment[] fulfillments; // An array of Fulfillments which store the various submissions which have been made to the bounty
    Contribution[] contributions; // An array of Contributions which store the contributions which have been made to the bounty
  }

  struct Fulfillment {
    address payable[] fulfillers; // An array of addresses who should receive payouts for a given submission
    address submitter; // The address of the individual who submitted the fulfillment, who is able to update the submission as needed
  }

  struct Contribution {
    address payable contributor; // The address of the individual who contributed
    uint amount; // The amount of tokens the user contributed
    bool refunded; // A boolean storing whether or not the contribution has been refunded yet
  }

                       

  uint public numBounties; // An integer storing the total number of bounties in the contract
  mapping(uint => Bounty) public bounties; // A mapping of bountyIDs to bounties
  mapping (uint => mapping (uint => bool)) public tokenBalances; // A mapping of bountyIds to tokenIds to booleans, storing whether a given bounty has a given ERC721 token in its balance


  address public owner; // The address of the individual who's allowed to set the metaTxRelayer address
  address public metaTxRelayer; // The address of the meta transaction relayer whose _sender is automatically trusted for all contract calls

  bool public callStarted; // Ensures mutex for the entire contract

                         

  modifier CALLNOTSTARTED963(){	//inject NONSTANDARD NAMING
    require(!callStarted);
    callStarted = true;
    _;
    callStarted = false;
  }

  modifier VALIDATEBOUNTYARRAYINDEX962(	//inject NONSTANDARD NAMING
    uint _index)
  {
    require(_index < numBounties);
    _;
  }

  modifier VALIDATECONTRIBUTIONARRAYINDEX279(	//inject NONSTANDARD NAMING
    uint _bountyId,
    uint _index)
  {
    require(_index < bounties[_bountyId].contributions.length);
    _;
  }

  modifier VALIDATEFULFILLMENTARRAYINDEX396(	//inject NONSTANDARD NAMING
    uint _bountyId,
    uint _index)
  {
    require(_index < bounties[_bountyId].fulfillments.length);
    _;
  }

  modifier VALIDATEISSUERARRAYINDEX737(	//inject NONSTANDARD NAMING
    uint _bountyId,
    uint _index)
  {
    require(_index < bounties[_bountyId].issuers.length);
    _;
  }

  modifier VALIDATEAPPROVERARRAYINDEX32(	//inject NONSTANDARD NAMING
    uint _bountyId,
    uint _index)
  {
    require(_index < bounties[_bountyId].approvers.length);
    _;
  }

  modifier ONLYISSUER653(	//inject NONSTANDARD NAMING
  address _sender,
  uint _bountyId,
  uint _issuerId)
  {
  require(_sender == bounties[_bountyId].issuers[_issuerId]);
  _;
  }

  modifier ONLYSUBMITTER83(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _fulfillmentId)
  {
    require(_sender ==
            bounties[_bountyId].fulfillments[_fulfillmentId].submitter);
    _;
  }

  modifier ONLYCONTRIBUTOR9(	//inject NONSTANDARD NAMING
  address _sender,
  uint _bountyId,
  uint _contributionId)
  {
    require(_sender ==
            bounties[_bountyId].contributions[_contributionId].contributor);
    _;
  }

  modifier ISAPPROVER33(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _approverId)
  {
    require(_sender == bounties[_bountyId].approvers[_approverId]);
    _;
  }

  modifier HASNOTPAID405(	//inject NONSTANDARD NAMING
    uint _bountyId)
  {
    require(!bounties[_bountyId].hasPaidOut);
    _;
  }

  modifier HASNOTREFUNDED93(	//inject NONSTANDARD NAMING
    uint _bountyId,
    uint _contributionId)
  {
    require(!bounties[_bountyId].contributions[_contributionId].refunded);
    _;
  }

  modifier SENDERISVALID782(	//inject NONSTANDARD NAMING
    address _sender)
  {
    require(msg.sender == _sender || msg.sender == metaTxRelayer);
    _;
  }

                             

  constructor() public {
    // The owner of the contract is automatically designated to be the deployer of the contract
    owner = msg.sender;
  }

                                                                               
                                                
  function SETMETATXRELAYER306(address _relayer)	//inject NONSTANDARD NAMING
    external
  {
    require(msg.sender == owner); // Checks that only the owner can call
    require(metaTxRelayer == address(0)); // Ensures the meta tx relayer can only be set once
    metaTxRelayer = _relayer;
  }

                                              
                                                                                                                                                        
                                                                                  
                                                                                      
                                                                                                                             
                                                                                 
                                                                              
                                                                                                                       
  function ISSUEBOUNTY607(	//inject NONSTANDARD NAMING
    address payable _sender,
    address payable[] memory _issuers,
    address[] memory _approvers,
    string memory _data,
    uint _deadline,
    address _token,
    uint _tokenVersion)
    public
    SENDERISVALID782(_sender)
    returns (uint)
  {
    require(_tokenVersion == 0 || _tokenVersion == 20 || _tokenVersion == 721); // Ensures a bounty can only be issued with a valid token version
    require(_issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck

    uint bountyId = numBounties; // The next bounty's index will always equal the number of existing bounties

    Bounty storage newBounty = bounties[bountyId];
    newBounty.issuers = _issuers;
    newBounty.approvers = _approvers;
    newBounty.deadline = _deadline;
    newBounty.tokenVersion = _tokenVersion;

    if (_tokenVersion != 0){
      newBounty.token = _token;
    }

    numBounties = numBounties.ADD535(1); // Increments the number of bounties, since a new one has just been added

    emit BOUNTYISSUED291(bountyId,
                      _sender,
                      _issuers,
                      _approvers,
                      _data, // Instead of storing the string on-chain, it is emitted within the event for easy off-chain consumption
                      _deadline,
                      _token,
                      _tokenVersion);

    return (bountyId);
  }

                                                                                                                                  


  function ISSUEANDCONTRIBUTE529(	//inject NONSTANDARD NAMING
    address payable _sender,
    address payable[] memory _issuers,
    address[] memory _approvers,
    string memory _data,
    uint _deadline,
    address _token,
    uint _tokenVersion,
    uint _depositAmount)
    public
    payable
    returns(uint)
  {
    uint bountyId = ISSUEBOUNTY607(_sender, _issuers, _approvers, _data, _deadline, _token, _tokenVersion);

    CONTRIBUTE618(_sender, bountyId, _depositAmount);

    return (bountyId);
  }


                                                                             
                                                                            
                                                                                 
                                                                                   
                                                                                    
                                                                              
                                                                              
                                                                                                                                                        
                                              
                                                           
  function CONTRIBUTE618(	//inject NONSTANDARD NAMING
    address payable _sender,
    uint _bountyId,
    uint _amount)
    public
    payable
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
    CALLNOTSTARTED963
  {
    require(_amount > 0); // Contributions of 0 tokens or token ID 0 should fail

    bounties[_bountyId].contributions.push(
      Contribution(_sender, _amount, false)); // Adds the contribution to the bounty

    if (bounties[_bountyId].tokenVersion == 0){

      bounties[_bountyId].balance = bounties[_bountyId].balance.ADD535(_amount); // Increments the balance of the bounty

      require(msg.value == _amount);
    } else if (bounties[_bountyId].tokenVersion == 20){

      bounties[_bountyId].balance = bounties[_bountyId].balance.ADD535(_amount); // Increments the balance of the bounty

      require(msg.value == 0); // Ensures users don't accidentally send ETH alongside a token contribution, locking up funds
      require(ERC20Token(bounties[_bountyId].token).TRANSFERFROM134(_sender,
                                                                 address(this),
                                                                 _amount));
    } else if (bounties[_bountyId].tokenVersion == 721){
      tokenBalances[_bountyId][_amount] = true; // Adds the 721 token to the balance of the bounty


      require(msg.value == 0); // Ensures users don't accidentally send ETH alongside a token contribution, locking up funds
      ERC721BasicToken(bounties[_bountyId].token).TRANSFERFROM134(_sender,
                                                               address(this),
                                                               _amount);
    } else {
      revert();
    }

    emit CONTRIBUTIONADDED888(_bountyId,
                           bounties[_bountyId].contributions.length - 1, // The new contributionId
                           _sender,
                           _amount);
  }

                                                                                 
                                                                                    
                                                                                    
                                                                                                                                                        
                                              
                                                                         
  function REFUNDCONTRIBUTION719(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _contributionId)
    public
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
    VALIDATECONTRIBUTIONARRAYINDEX279(_bountyId, _contributionId)
    ONLYCONTRIBUTOR9(_sender, _bountyId, _contributionId)
    HASNOTPAID405(_bountyId)
    HASNOTREFUNDED93(_bountyId, _contributionId)
    CALLNOTSTARTED963
  {
    require(now > bounties[_bountyId].deadline); // Refunds may only be processed after the deadline has elapsed

    Contribution storage contribution = bounties[_bountyId].contributions[_contributionId];

    contribution.refunded = true;

    TRANSFERTOKENS903(_bountyId, contribution.contributor, contribution.amount); // Performs the disbursal of tokens to the contributor

    emit CONTRIBUTIONREFUNDED423(_bountyId, _contributionId);
  }

                                                                                      
                                                                                                                                                        
                                              
                                                                                      
  function REFUNDMYCONTRIBUTIONS1000(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint[] memory _contributionIds)
    public
    SENDERISVALID782(_sender)
  {
    for (uint i = 0; i < _contributionIds.length; i++){
        REFUNDCONTRIBUTION719(_sender, _bountyId, _contributionIds[i]);
    }
  }

                                                                                    
                                                                                                                                                        
                                              
                                                                     
                                                                                      
  function REFUNDCONTRIBUTIONS786(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _issuerId,
    uint[] memory _contributionIds)
    public
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
    ONLYISSUER653(_sender, _bountyId, _issuerId)
    CALLNOTSTARTED963
  {
    for (uint i = 0; i < _contributionIds.length; i++){
      require(_contributionIds[i] < bounties[_bountyId].contributions.length);

      Contribution storage contribution = bounties[_bountyId].contributions[_contributionIds[i]];

      require(!contribution.refunded);

      contribution.refunded = true;

      TRANSFERTOKENS903(_bountyId, contribution.contributor, contribution.amount); // Performs the disbursal of tokens to the contributor
    }

    emit CONTRIBUTIONSREFUNDED218(_bountyId, _sender, _contributionIds);
  }

                                                                             
                                                                                                                                                                                                                                      
                                                                                                                                                        
                                              
                                                                     
                                                                                                                                                                                                                
  function DRAINBOUNTY345(	//inject NONSTANDARD NAMING
    address payable _sender,
    uint _bountyId,
    uint _issuerId,
    uint[] memory _amounts)
    public
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
    ONLYISSUER653(_sender, _bountyId, _issuerId)
    CALLNOTSTARTED963
  {
    if (bounties[_bountyId].tokenVersion == 0 || bounties[_bountyId].tokenVersion == 20){
      require(_amounts.length == 1); // ensures there's only 1 amount of tokens to be returned
      require(_amounts[0] <= bounties[_bountyId].balance); // ensures an issuer doesn't try to drain the bounty of more tokens than their balance permits
      TRANSFERTOKENS903(_bountyId, _sender, _amounts[0]); // Performs the draining of tokens to the issuer
    } else {
      for (uint i = 0; i < _amounts.length; i++){
        require(tokenBalances[_bountyId][_amounts[i]]);// ensures an issuer doesn't try to drain the bounty of a token it doesn't have in its balance
        TRANSFERTOKENS903(_bountyId, _sender, _amounts[i]);
      }
    }

    emit BOUNTYDRAINED424(_bountyId, _sender, _amounts);
  }

                                                                          
                                                                                        
                                                                                                                                                        
                                              
                                                                                                                                                      
  function PERFORMACTION966(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    string memory _data)
    public
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
  {
    emit ACTIONPERFORMED922(_bountyId, _sender, _data); // The _data string is emitted in an event for easy off-chain consumption
  }

                                                                              
                                                                                                                                                        
                                              
                                                                                             
                                                                                                                                          
  function FULFILLBOUNTY596(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    address payable[] memory  _fulfillers,
    string memory _data)
    public
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
  {
    require(now < bounties[_bountyId].deadline); // Submissions are only allowed to be made before the deadline
    require(_fulfillers.length > 0); // Submissions with no fulfillers would mean no one gets paid out

    bounties[_bountyId].fulfillments.push(Fulfillment(_fulfillers, _sender));

    emit BOUNTYFULFILLED198(_bountyId,
                         (bounties[_bountyId].fulfillments.length - 1),
                         _fulfillers,
                         _data, // The _data string is emitted in an event for easy off-chain consumption
                         _sender);
  }

                                                                                                
                                                                                                                                                        
                                              
                                                        
                                                                                                 
                                                                                                                                              
  function UPDATEFULFILLMENT168(	//inject NONSTANDARD NAMING
  address _sender,
  uint _bountyId,
  uint _fulfillmentId,
  address payable[] memory _fulfillers,
  string memory _data)
  public
  SENDERISVALID782(_sender)
  VALIDATEBOUNTYARRAYINDEX962(_bountyId)
  VALIDATEFULFILLMENTARRAYINDEX396(_bountyId, _fulfillmentId)
  ONLYSUBMITTER83(_sender, _bountyId, _fulfillmentId) // Only the original submitter of a fulfillment may update their submission
  {
    bounties[_bountyId].fulfillments[_fulfillmentId].fulfillers = _fulfillers;
    emit FULFILLMENTUPDATED42(_bountyId,
                            _fulfillmentId,
                            _fulfillers,
                            _data); // The _data string is emitted in an event for easy off-chain consumption
  }

                                                                                        
                                                                                                                                                        
                                              
                                                                       
                                                                           
                                                                               
                                                                                  
                                                                                  
                                                                               
                                                                          
  function ACCEPTFULFILLMENT330(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _fulfillmentId,
    uint _approverId,
    uint[] memory _tokenAmounts)
    public
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
    VALIDATEFULFILLMENTARRAYINDEX396(_bountyId, _fulfillmentId)
    ISAPPROVER33(_sender, _bountyId, _approverId)
    CALLNOTSTARTED963
  {
    // now that the bounty has paid out at least once, refunds are no longer possible
    bounties[_bountyId].hasPaidOut = true;

    Fulfillment storage fulfillment = bounties[_bountyId].fulfillments[_fulfillmentId];

    require(_tokenAmounts.length == fulfillment.fulfillers.length); // Each fulfiller should get paid some amount of tokens (this can be 0)

    for (uint256 i = 0; i < fulfillment.fulfillers.length; i++){
        if (_tokenAmounts[i] > 0){
          // for each fulfiller associated with the submission
          TRANSFERTOKENS903(_bountyId, fulfillment.fulfillers[i], _tokenAmounts[i]);
        }
    }
    emit FULFILLMENTACCEPTED617(_bountyId,
                             _fulfillmentId,
                             _sender,
                             _tokenAmounts);
  }

                                                                                                            
                                                                                                                                                        
                                              
                                                                                             
                                                                                                                                          
                                                                           
                                                                               
                                                                                  
                                                                                  
                                                                               
                                                                          
  function FULFILLANDACCEPT822(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    address payable[] memory _fulfillers,
    string memory _data,
    uint _approverId,
    uint[] memory _tokenAmounts)
    public
    SENDERISVALID782(_sender)
  {
    // first fulfills the bounty on behalf of the fulfillers
    FULFILLBOUNTY596(_sender, _bountyId, _fulfillers, _data);

    // then accepts the fulfillment
    ACCEPTFULFILLMENT330(_sender,
                      _bountyId,
                      bounties[_bountyId].fulfillments.length - 1,
                      _approverId,
                      _tokenAmounts);
  }



                                                                         
                                                                                                                                                        
                                              
                                                                          
                                                                                      
                                                                                          
                                                                                                                                 
                                                                                     
  function CHANGEBOUNTY775(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _issuerId,
    address payable[] memory _issuers,
    address payable[] memory _approvers,
    string memory _data,
    uint _deadline)
    public
    SENDERISVALID782(_sender)
  {
    require(_bountyId < numBounties); // makes the validateBountyArrayIndex modifier in-line to avoid stack too deep errors
    require(_issuerId < bounties[_bountyId].issuers.length); // makes the validateIssuerArrayIndex modifier in-line to avoid stack too deep errors
    require(_sender == bounties[_bountyId].issuers[_issuerId]); // makes the onlyIssuer modifier in-line to avoid stack too deep errors

    require(_issuers.length > 0 || _approvers.length > 0); // Ensures there's at least 1 issuer or approver, so funds don't get stuck

    bounties[_bountyId].issuers = _issuers;
    bounties[_bountyId].approvers = _approvers;
    bounties[_bountyId].deadline = _deadline;
    emit BOUNTYCHANGED890(_bountyId,
                       _sender,
                       _issuers,
                       _approvers,
                       _data,
                       _deadline);
  }

                                                                                                
                                                                                                                                                        
                                              
                                                                          
                                                                           
                                                     
  function CHANGEISSUER877(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _issuerId,
    uint _issuerIdToChange,
    address payable _newIssuer)
    public
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
    VALIDATEISSUERARRAYINDEX737(_bountyId, _issuerIdToChange)
    ONLYISSUER653(_sender, _bountyId, _issuerId)
  {
    require(_issuerId < bounties[_bountyId].issuers.length || _issuerId == 0);

    bounties[_bountyId].issuers[_issuerIdToChange] = _newIssuer;

    emit BOUNTYISSUERSUPDATED404(_bountyId, _sender, bounties[_bountyId].issuers);
  }

                                                                                                    
                                                                                                                                                        
                                              
                                                                          
                                                                       
                                                      
  function CHANGEAPPROVER313(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _issuerId,
    uint _approverId,
    address payable _approver)
    external
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
    ONLYISSUER653(_sender, _bountyId, _issuerId)
    VALIDATEAPPROVERARRAYINDEX32(_bountyId, _approverId)
  {
    bounties[_bountyId].approvers[_approverId] = _approver;

    emit BOUNTYAPPROVERSUPDATED564(_bountyId, _sender, bounties[_bountyId].approvers);
  }

                                                                                                             
                                                                                                                                                        
                                              
                                                                          
                                                                           
                                                                               
                                                    
  function CHANGEISSUERANDAPPROVER5(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _issuerId,
    uint _issuerIdToChange,
    uint _approverIdToChange,
    address payable _issuer)
    external
    SENDERISVALID782(_sender)
    ONLYISSUER653(_sender, _bountyId, _issuerId)
  {
    require(_bountyId < numBounties);
    require(_approverIdToChange < bounties[_bountyId].approvers.length);
    require(_issuerIdToChange < bounties[_bountyId].issuers.length);

    bounties[_bountyId].issuers[_issuerIdToChange] = _issuer;
    bounties[_bountyId].approvers[_approverIdToChange] = _issuer;

    emit BOUNTYISSUERSUPDATED404(_bountyId, _sender, bounties[_bountyId].issuers);
    emit BOUNTYAPPROVERSUPDATED564(_bountyId, _sender, bounties[_bountyId].approvers);
  }

                                                                                
                                                                                                                                                        
                                              
                                                                          
                                                                                                                                 
  function CHANGEDATA475(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _issuerId,
    string memory _data)
    public
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
    VALIDATEISSUERARRAYINDEX737(_bountyId, _issuerId)
    ONLYISSUER653(_sender, _bountyId, _issuerId)
  {
    emit BOUNTYDATACHANGED202(_bountyId, _sender, _data); // The new _data is emitted within an event rather than being stored on-chain for minimized gas costs
  }

                                                                                        
                                                                                                                                                        
                                              
                                                                          
                                                                                     
  function CHANGEDEADLINE144(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _issuerId,
    uint _deadline)
    external
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
    VALIDATEISSUERARRAYINDEX737(_bountyId, _issuerId)
    ONLYISSUER653(_sender, _bountyId, _issuerId)
  {
    bounties[_bountyId].deadline = _deadline;

    emit BOUNTYDEADLINECHANGED293(_bountyId, _sender, _deadline);
  }

                                                                                    
                                                                                                                                                        
                                              
                                                                          
                                                                                
  function ADDISSUERS127(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _issuerId,
    address payable[] memory _issuers)
    public
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
    VALIDATEISSUERARRAYINDEX737(_bountyId, _issuerId)
    ONLYISSUER653(_sender, _bountyId, _issuerId)
  {
    for (uint i = 0; i < _issuers.length; i++){
      bounties[_bountyId].issuers.push(_issuers[i]);
    }

    emit BOUNTYISSUERSUPDATED404(_bountyId, _sender, bounties[_bountyId].issuers);
  }

                                                                                        
                                                                                                                                                        
                                              
                                                                          
                                                                                    
  function ADDAPPROVERS15(	//inject NONSTANDARD NAMING
    address _sender,
    uint _bountyId,
    uint _issuerId,
    address[] memory _approvers)
    public
    SENDERISVALID782(_sender)
    VALIDATEBOUNTYARRAYINDEX962(_bountyId)
    VALIDATEISSUERARRAYINDEX737(_bountyId, _issuerId)
    ONLYISSUER653(_sender, _bountyId, _issuerId)
  {
    for (uint i = 0; i < _approvers.length; i++){
      bounties[_bountyId].approvers.push(_approvers[i]);
    }

    emit BOUNTYAPPROVERSUPDATED564(_bountyId, _sender, bounties[_bountyId].approvers);
  }

                                                         
                                              
                                            
  function GETBOUNTY268(uint _bountyId)	//inject NONSTANDARD NAMING
    external
    view
    returns (Bounty memory)
  {
    return bounties[_bountyId];
  }


  function TRANSFERTOKENS903(uint _bountyId, address payable _to, uint _amount)	//inject NONSTANDARD NAMING
    internal
  {
    if (bounties[_bountyId].tokenVersion == 0){
      require(_amount > 0); // Sending 0 tokens should throw
      require(bounties[_bountyId].balance >= _amount);

      bounties[_bountyId].balance = bounties[_bountyId].balance.SUB288(_amount);

      _to.transfer(_amount);
    } else if (bounties[_bountyId].tokenVersion == 20){
      require(_amount > 0); // Sending 0 tokens should throw
      require(bounties[_bountyId].balance >= _amount);

      bounties[_bountyId].balance = bounties[_bountyId].balance.SUB288(_amount);

      require(ERC20Token(bounties[_bountyId].token).TRANSFER539(_to, _amount));
    } else if (bounties[_bountyId].tokenVersion == 721){
      require(tokenBalances[_bountyId][_amount]);

      tokenBalances[_bountyId][_amount] = false; // Removes the 721 token from the balance of the bounty

      ERC721BasicToken(bounties[_bountyId].token).TRANSFERFROM134(address(this),
                                                               _to,
                                                               _amount);
    } else {
      revert();
    }
  }

                      

  event BOUNTYISSUED291(uint _bountyId, address payable _creator, address payable[] _issuers, address[] _approvers, string _data, uint _deadline, address _token, uint _tokenVersion);	//inject NONSTANDARD NAMING
  event CONTRIBUTIONADDED888(uint _bountyId, uint _contributionId, address payable _contributor, uint _amount);	//inject NONSTANDARD NAMING
  event CONTRIBUTIONREFUNDED423(uint _bountyId, uint _contributionId);	//inject NONSTANDARD NAMING
  event CONTRIBUTIONSREFUNDED218(uint _bountyId, address _issuer, uint[] _contributionIds);	//inject NONSTANDARD NAMING
  event BOUNTYDRAINED424(uint _bountyId, address _issuer, uint[] _amounts);	//inject NONSTANDARD NAMING
  event ACTIONPERFORMED922(uint _bountyId, address _fulfiller, string _data);	//inject NONSTANDARD NAMING
  event BOUNTYFULFILLED198(uint _bountyId, uint _fulfillmentId, address payable[] _fulfillers, string _data, address _submitter);	//inject NONSTANDARD NAMING
  event FULFILLMENTUPDATED42(uint _bountyId, uint _fulfillmentId, address payable[] _fulfillers, string _data);	//inject NONSTANDARD NAMING
  event FULFILLMENTACCEPTED617(uint _bountyId, uint  _fulfillmentId, address _approver, uint[] _tokenAmounts);	//inject NONSTANDARD NAMING
  event BOUNTYCHANGED890(uint _bountyId, address _changer, address payable[] _issuers, address payable[] _approvers, string _data, uint _deadline);	//inject NONSTANDARD NAMING
  event BOUNTYISSUERSUPDATED404(uint _bountyId, address _changer, address payable[] _issuers);	//inject NONSTANDARD NAMING
  event BOUNTYAPPROVERSUPDATED564(uint _bountyId, address _changer, address[] _approvers);	//inject NONSTANDARD NAMING
  event BOUNTYDATACHANGED202(uint _bountyId, address _changer, string _data);	//inject NONSTANDARD NAMING
  event BOUNTYDEADLINECHANGED293(uint _bountyId, address _changer, uint _deadline);	//inject NONSTANDARD NAMING
}

contract BountiesMetaTxRelayer {

  // This contract serves as a relayer for meta txns being sent to the Bounties contract

  StandardBounties public bountiesContract;
  mapping(address => uint) public replayNonce;


  constructor(address _contract) public {
    bountiesContract = StandardBounties(_contract);
  }

  function METAISSUEBOUNTY189(	//inject NONSTANDARD NAMING
    bytes memory signature,
    address payable[] memory _issuers,
    address[] memory _approvers,
    string memory _data,
    uint _deadline,
    address _token,
    uint _tokenVersion,
    uint _nonce)
    public
    returns (uint)
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaIssueBounty",
                                                  _issuers,
                                                  _approvers,
                                                  _data,
                                                  _deadline,
                                                  _token,
                                                  _tokenVersion,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, signature);

    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;
    return bountiesContract.ISSUEBOUNTY607(address(uint160(signer)),
                                         _issuers,
                                         _approvers,
                                         _data,
                                         _deadline,
                                         _token,
                                         _tokenVersion);
  }

  function METAISSUEANDCONTRIBUTE154(	//inject NONSTANDARD NAMING
    bytes memory signature,
    address payable[] memory _issuers,
    address[] memory _approvers,
    string memory _data,
    uint _deadline,
    address _token,
    uint _tokenVersion,
    uint _depositAmount,
    uint _nonce)
    public
    payable
    returns (uint)
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaIssueAndContribute",
                                                  _issuers,
                                                  _approvers,
                                                  _data,
                                                  _deadline,
                                                  _token,
                                                  _tokenVersion,
                                                  _depositAmount,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, signature);

    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    if (msg.value > 0){
      return bountiesContract.ISSUEANDCONTRIBUTE529.value(msg.value)(address(uint160(signer)),
                                                 _issuers,
                                                 _approvers,
                                                 _data,
                                                 _deadline,
                                                 _token,
                                                 _tokenVersion,
                                                 _depositAmount);
    } else {
      return bountiesContract.ISSUEANDCONTRIBUTE529(address(uint160(signer)),
                                                 _issuers,
                                                 _approvers,
                                                 _data,
                                                 _deadline,
                                                 _token,
                                                 _tokenVersion,
                                                 _depositAmount);
    }

  }

  function METACONTRIBUTE650(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _amount,
    uint _nonce)
    public
    payable
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaContribute",
                                                  _bountyId,
                                                  _amount,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);

    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    if (msg.value > 0){
      bountiesContract.CONTRIBUTE618.value(msg.value)(address(uint160(signer)), _bountyId, _amount);
    } else {
      bountiesContract.CONTRIBUTE618(address(uint160(signer)), _bountyId, _amount);
    }
  }


  function METAREFUNDCONTRIBUTION168(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _contributionId,
    uint _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaRefundContribution",
                                                  _bountyId,
                                                  _contributionId,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);

    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.REFUNDCONTRIBUTION719(signer, _bountyId, _contributionId);
  }

  function METAREFUNDMYCONTRIBUTIONS651(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint[] memory _contributionIds,
    uint _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaRefundMyContributions",
                                                  _bountyId,
                                                  _contributionIds,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);

    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.REFUNDMYCONTRIBUTIONS1000(signer, _bountyId, _contributionIds);
  }

  function METAREFUNDCONTRIBUTIONS334(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _issuerId,
    uint[] memory _contributionIds,
    uint _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaRefundContributions",
                                                  _bountyId,
                                                  _issuerId,
                                                  _contributionIds,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);

    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.REFUNDCONTRIBUTIONS786(signer, _bountyId, _issuerId, _contributionIds);
  }

  function METADRAINBOUNTY623(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _issuerId,
    uint[] memory _amounts,
    uint _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaDrainBounty",
                                                  _bountyId,
                                                  _issuerId,
                                                  _amounts,
                                                  _nonce));
    address payable signer = address(uint160(GETSIGNER512(metaHash, _signature)));

    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.DRAINBOUNTY345(signer, _bountyId, _issuerId, _amounts);
  }

  function METAPERFORMACTION278(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    string memory _data,
    uint256 _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaPerformAction",
                                                  _bountyId,
                                                  _data,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);
    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.PERFORMACTION966(signer, _bountyId, _data);
  }

  function METAFULFILLBOUNTY952(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    address payable[] memory  _fulfillers,
    string memory _data,
    uint256 _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaFulfillBounty",
                                                  _bountyId,
                                                  _fulfillers,
                                                  _data,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);
    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.FULFILLBOUNTY596(signer, _bountyId, _fulfillers, _data);
  }

  function METAUPDATEFULFILLMENT854(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _fulfillmentId,
    address payable[] memory  _fulfillers,
    string memory _data,
    uint256 _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaUpdateFulfillment",
                                                  _bountyId,
                                                  _fulfillmentId,
                                                  _fulfillers,
                                                  _data,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);
    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.UPDATEFULFILLMENT168(signer, _bountyId, _fulfillmentId, _fulfillers, _data);
  }

  function METAACCEPTFULFILLMENT218(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _fulfillmentId,
    uint _approverId,
    uint[] memory _tokenAmounts,
    uint256 _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaAcceptFulfillment",
                                                  _bountyId,
                                                  _fulfillmentId,
                                                  _approverId,
                                                  _tokenAmounts,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);
    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.ACCEPTFULFILLMENT330(signer,
                       _bountyId,
                       _fulfillmentId,
                       _approverId,
                       _tokenAmounts);
  }

  function METAFULFILLANDACCEPT21(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    address payable[] memory _fulfillers,
    string memory _data,
    uint _approverId,
    uint[] memory _tokenAmounts,
    uint256 _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaFulfillAndAccept",
                                                  _bountyId,
                                                  _fulfillers,
                                                  _data,
                                                  _approverId,
                                                  _tokenAmounts,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);
    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.FULFILLANDACCEPT822(signer,
                      _bountyId,
                      _fulfillers,
                      _data,
                      _approverId,
                      _tokenAmounts);
  }

  function METACHANGEBOUNTY750(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _issuerId,
    address payable[] memory _issuers,
    address payable[] memory _approvers,
    string memory _data,
    uint _deadline,
    uint256 _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaChangeBounty",
                                                  _bountyId,
                                                  _issuerId,
                                                  _issuers,
                                                  _approvers,
                                                  _data,
                                                  _deadline,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);
    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.CHANGEBOUNTY775(signer,
                  _bountyId,
                  _issuerId,
                  _issuers,
                  _approvers,
                  _data,
                  _deadline);
  }

  function METACHANGEISSUER928(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _issuerId,
    uint _issuerIdToChange,
    address payable _newIssuer,
    uint256 _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaChangeIssuer",
                                                  _bountyId,
                                                  _issuerId,
                                                  _issuerIdToChange,
                                                  _newIssuer,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);
    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.CHANGEISSUER877(signer,
                  _bountyId,
                  _issuerId,
                  _issuerIdToChange,
                  _newIssuer);
  }

  function METACHANGEAPPROVER522(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _issuerId,
    uint _approverId,
    address payable _approver,
    uint256 _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaChangeApprover",
                                                  _bountyId,
                                                  _issuerId,
                                                  _approverId,
                                                  _approver,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);
    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.CHANGEAPPROVER313(signer,
                  _bountyId,
                  _issuerId,
                  _approverId,
                  _approver);
  }

  function METACHANGEDATA703(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _issuerId,
    string memory _data,
    uint256 _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaChangeData",
                                                  _bountyId,
                                                  _issuerId,
                                                  _data,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);
    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.CHANGEDATA475(signer,
                _bountyId,
                _issuerId,
                _data);
  }

  function METACHANGEDEADLINE27(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _issuerId,
    uint  _deadline,
    uint256 _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaChangeDeadline",
                                                  _bountyId,
                                                  _issuerId,
                                                  _deadline,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);
    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.CHANGEDEADLINE144(signer,
                    _bountyId,
                    _issuerId,
                    _deadline);
  }

  function METAADDISSUERS741(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _issuerId,
    address payable[] memory _issuers,
    uint256 _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaAddIssuers",
                                                  _bountyId,
                                                  _issuerId,
                                                  _issuers,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);
    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.ADDISSUERS127(signer,
                _bountyId,
                _issuerId,
                _issuers);
  }

  function METAADDAPPROVERS523(	//inject NONSTANDARD NAMING
    bytes memory _signature,
    uint _bountyId,
    uint _issuerId,
    address[] memory _approvers,
    uint256 _nonce)
    public
    {
    bytes32 metaHash = keccak256(abi.encode(address(this),
                                                  "metaAddApprovers",
                                                  _bountyId,
                                                  _issuerId,
                                                  _approvers,
                                                  _nonce));
    address signer = GETSIGNER512(metaHash, _signature);
    //make sure signer doesn't come back as 0x0
    require(signer != address(0));
    require(_nonce == replayNonce[signer]);

    //increase the nonce to prevent replay attacks
    replayNonce[signer]++;

    bountiesContract.ADDAPPROVERS15(signer,
                _bountyId,
                _issuerId,
                _approvers);
  }

  function GETSIGNER512(	//inject NONSTANDARD NAMING
    bytes32 _hash,
    bytes memory _signature)
    internal
    pure
    returns (address)
  {
    bytes32 r;
    bytes32 s;
    uint8 v;
    if (_signature.length != 65){
      return address(0);
    }
    assembly {
      r := mload(add(_signature, 32))
      s := mload(add(_signature, 64))
      v := byte(0, mload(add(_signature, 96)))
    }
    if (v < 27){
      v += 27;
    }
    if (v != 27 && v != 28){
      return address(0);
    } else {
        return ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)), v, r, s );
    }
  }
}