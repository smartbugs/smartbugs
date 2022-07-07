/**
 *Submitted for verification at Etherscan.io on 2020-04-01
*/

pragma solidity ^0.6.3;

contract BrightID {
    uint256 public id;

    struct Context {
        bool isActive;
        mapping(address => bool) owners;
        mapping(address => bool) nodes;
        mapping(uint256 => address[]) accounts;
        mapping(bytes32 => uint256) cIdToUid;
        mapping(address => uint256) ethToUid;
    }

    mapping(bytes32 => Context) private contexts;

    string private constant DUPLICATE_ETHEREUM_ADDRESS = "Duplicate ethereum address";
    string private constant DUPLICATE_CONTEXT_ID = "Duplicate context id";
    string private constant ONLY_CONTEXT_OWNER = "Only context owner";
    string private constant UNAUTHORIZED_NODE = "Unauthorized node";
    string private constant CONTEXT_NOT_FOUND = "Context not found";
    string private constant NODE_NOT_FOUND = "Node not found";
    string private constant ALREADY_EXISTS = "Already exists";
    string private constant BAD_SIGNATURE = "Bad signature";
    string private constant NO_CONTEXT_ID = "No context id";

    /// Events
    event ContextAdded(bytes32 indexed context, address indexed owner);
    event ContextOwnerAdded(bytes32 indexed context, address owner);
    event ContextOwnerRemoved(bytes32 indexed context, address owner);
    event NodeAddedToContext(bytes32 indexed context, address nodeAddress);
    event NodeRemovedFromContext(bytes32 indexed context, address nodeAddress);
    event AddressLinked(bytes32 context, bytes32 contextId, address ethAddress);
    event SponsorshipRequested(bytes32 indexed context, bytes32 indexed contextid);

    constructor()
        public
    {
        id = 0;
    }

    /**
     * @notice Check whether the context has been added to the smart contract using `addContext`.
     * @param context The context.
     * @return has the context been added?
     */
    function isContext(bytes32 context)
        public
        view
        returns(bool)
    {
        return contexts[context].isActive;
    }

    /**
     * @notice Check whether `nodeAddress`'s signature is acceptable for the context.
     * @param context The context.
     * @param nodeAddress The node's address.
     * @return can `nodeAddress` sign requests for this context?
     */
    function isNodeInContext(bytes32 context, address nodeAddress)
        public
        view
        returns(bool)
    {
        return contexts[context].nodes[nodeAddress];
    }

    /**
     * @dev get uid.
     * @param context The context.
     * @param cIds an array of contextIds.
     */
    function getUid(bytes32 context, bytes32[] memory cIds)
        internal
        returns(uint256)
    {
        for(uint256 i=1; i < cIds.length-1; i++) {
            uint256 uid = contexts[context].cIdToUid[cIds[i]];
            if (uid != 0) {
                return uid;
            }
        }
        return ++id;
    }

    /**
     * @notice Link `cIds[0]` to `msg.sender` under `context`.
     * @param context The context.
     * @param cIds an array of contextIds.
     * @param v signature's v.
     * @param r signature's r.
     * @param s signature's s.
     */
    function register(
        bytes32 context,
        bytes32[] memory cIds,
        uint8 v,
        bytes32 r,
        bytes32 s)
        public
    {
        require(isContext(context), CONTEXT_NOT_FOUND);
        require(0 < cIds.length, NO_CONTEXT_ID);
        require(address(this).balance == 0, DUPLICATE_CONTEXT_ID);	//inject PRESENT ETHER
        require(address(this).balance == 0, DUPLICATE_ETHEREUM_ADDRESS);	//inject PRESENT ETHER

        bytes32 message = keccak256(abi.encodePacked(context, cIds));
        address signerAddress = ecrecover(message, v, r, s);
        require(signerAddress != address(0), BAD_SIGNATURE);
        require(contexts[context].nodes[signerAddress], UNAUTHORIZED_NODE);

        uint256 uid = getUid(context, cIds);

        contexts[context].ethToUid[msg.sender] = uid;

        for(uint256 i=0; i < cIds.length-1; i++) {
            contexts[context].cIdToUid[cIds[i]] = uid;
        }

        // The last member of contexts[context].accounts[uid] is active address of the user
        contexts[context].accounts[uid].push(msg.sender);

        emit AddressLinked(context, cIds[0], msg.sender);
    }

    /**
     * @notice Check that `ethAddress` is the mostly recently used address by a unique human in the context.
     * Also return any addresses previously used by this unique human.
     * @param ethAddress an Ethereum address.
     * @param context the context.
     * @return is `ethAddress` the most recently used address by a unique human in the `context`.
     * @return addresses previously used by this unique human.
     */
    function isUniqueHuman(
        address ethAddress,
        bytes32 context)
        public
        view
        returns(bool, address[] memory)
    {
        uint256 uid = contexts[context].ethToUid[ethAddress];
        if (uid != 0) {
            uint256 lastIndex = contexts[context].accounts[uid].length - 1;
            if (contexts[context].accounts[uid][lastIndex] == ethAddress) {
                return(true, contexts[context].accounts[uid]);
            }
        }
    }

    /**
     * @notice Submit a request to sponsor `contextid` under `context`.
     * @param context The context.
     * @param contextid The contextid.
     */
    function sponsor(bytes32 context, bytes32 contextid)
        public
        onlyContextOwner(context)
    {
        emit SponsorshipRequested(context, contextid);
    }

    /**
     * @notice Add a context.
     * @param context The context.
     */
    function addContext(bytes32 context)
        public
    {
        require(contexts[context].isActive != true, ALREADY_EXISTS);

        contexts[context].isActive = true;
        contexts[context].owners[msg.sender] = true;
        emit ContextAdded(context, msg.sender);
    }

    /**
     * @notice Add a context owner.
     * @param context The context.
     * @param owner The address of the context owner to be added.
     */
    function addContextOwner(bytes32 context, address owner)
        public
        onlyContextOwner(context)
    {
        contexts[context].owners[owner] = true;
        emit ContextOwnerAdded(context, owner);
    }

    /**
     * @notice Remove a context owner.
     * @param context The context.
     * @param owner The address of the context owner to be removed.
     */
    function removeContextOwner(bytes32 context, address owner)
        public
        onlyContextOwner(context)
    {
        contexts[context].owners[owner] = false;
        emit ContextOwnerRemoved(context, owner);
    }


    /**
     * @notice Check that `owner` is a owner of `context`.
     * @param context The context.
     * @param owner The new context's owner.
     */
    function isContextOwner(bytes32 context, address owner)
        public
        view
        returns(bool)
    {
        return contexts[context].owners[owner];
    }

    /**
     * @notice Add `nodeAddress` as a node to the context.
     * @param context The context.
     * @param nodeAddress The node's address.
     */
    function addNodeToContext(bytes32 context, address nodeAddress)
        public
        onlyContextOwner(context)
    {
        require(isContext(context), CONTEXT_NOT_FOUND);
        require(contexts[context].nodes[nodeAddress] != true, ALREADY_EXISTS);

        contexts[context].nodes[nodeAddress] = true;
        emit NodeAddedToContext(context, nodeAddress);
    }

    /**
     * @notice Remove `nodeAddress` from the context's nodes.
     * @param context The context.
     * @param nodeAddress The node's address.
     */
    function removeNodeFromContext(bytes32 context, address nodeAddress)
        public
        onlyContextOwner(context)
    {
        require(isContext(context), CONTEXT_NOT_FOUND);
        require(contexts[context].nodes[nodeAddress] == true, NODE_NOT_FOUND);

        contexts[context].nodes[nodeAddress] = false;
        emit NodeRemovedFromContext(context, nodeAddress);
    }

    /**
     * @dev Throws if called by any account other than the owner of the context.
     * @param context The context.
     */
    modifier onlyContextOwner(bytes32 context) {
        require(contexts[context].owners[msg.sender], ONLY_CONTEXT_OWNER);
        _;
    }
}