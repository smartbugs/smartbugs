pragma solidity ^0.5.1;

interface TokenRecipient {

    function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
}

contract ERC20Interface {

    function totalSupply() public view returns (uint256);
    
    function balanceOf(address _owner) public view returns (uint256 balance);
    
    function transfer(address _to, uint256 _value) public returns (bool success);
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    
    function approve(address _spender, uint256 _value) public returns (bool success);
    
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success);
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
    
    function burn(uint256 _value, string memory _note) public returns (bool success);
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event Burn(address indexed _burner, uint256 _value, string _note);
}

contract LockRequestable {

    uint256 public lockRequestCount;

    constructor() public {
        lockRequestCount = 0;
    }

    function generateLockId() internal returns (bytes32 lockId) {
        return keccak256(
        abi.encodePacked(blockhash(block.number - 1), address(this), ++lockRequestCount)
        );
    }
}

contract CustodianUpgradeable is LockRequestable {

    struct CustodianChangeRequest {
        address proposedNew;
    }

    address public custodian;

    
    mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;

    constructor(address _custodian) public LockRequestable() {
        custodian = _custodian;
    }
    
    modifier onlyCustodian {
        require(msg.sender == custodian);
        _;
    }

    function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
        require(_proposedCustodian != address(0));

        lockId = generateLockId();

        custodianChangeReqs[lockId] = CustodianChangeRequest({
            proposedNew: _proposedCustodian
        });

        emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
    }

    function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
        custodian = getCustodianChangeReq(_lockId);

        delete custodianChangeReqs[_lockId];

        emit CustodianChangeConfirmed(_lockId, custodian);
    }
    
    function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
        CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];

        require(changeRequest.proposedNew != address(0));

        return changeRequest.proposedNew;
    }

    event CustodianChangeRequested(
        bytes32 _lockId,
        address _msgSender,
        address _proposedCustodian
    );
    
    event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
}

contract ERC20Impl is CustodianUpgradeable {

    struct PendingPrint {
        address receiver;
        uint256 value;
    }

    struct PendingBurnLimits {
        uint256 min;
        uint256 max;
        bool isSet;
    }
    
    ERC20Proxy public erc20Proxy;
    ERC20Store public erc20Store;

    uint256 public burnMin ;	//inject UNINIT LOCAL/STATE VAR

    uint256 public burnMax ;	//inject UNINIT LOCAL/STATE VAR


    address public sweeper;
    bytes32 public sweepMsg;

    mapping (address => bool) public sweptSet;
    mapping (bytes32 => PendingPrint) public pendingPrintMap;
    mapping (bytes32 => PendingBurnLimits) public pendingBurnLimitsMap;

    constructor(
    address _erc20Proxy,
    address _erc20Store,
    address _custodian,
    address _sweeper
    ) public CustodianUpgradeable(_custodian) {
        require(_sweeper != address(0));
        erc20Proxy = ERC20Proxy(_erc20Proxy);
        erc20Store = ERC20Store(_erc20Store);

        sweeper = _sweeper;
        sweepMsg = keccak256(
        abi.encodePacked(address(this), "sweep")
        );
    }
    
    modifier onlyProxy {
        require(msg.sender == address(erc20Proxy));
        _;
    }

    modifier onlySweeper {
        require(msg.sender == sweeper);
        _;
    }

    function approveWithSender(
        address _sender,
        address _spender,
        uint256 _value
    )
        public
        onlyProxy
        returns (bool success)
    {
        require(_spender != address(0)); 
        erc20Store.setAllowance(_sender, _spender, _value);
        erc20Proxy.emitApproval(_sender, _spender, _value);
        return true;
    }

    
    function approveAndCallWithSender(
        address _sender,
        address _spender,
        uint256 _value,
        bytes memory _extraData
    )
        public
        onlyProxy
        returns (bool success)
    {
        TokenRecipient spender ;	//inject UNINIT LOCAL/STATE VAR

        if (approveWithSender(_sender, _spender, _value)) {
            spender.receiveApproval(_sender, _value, msg.sender, _extraData);
            return true;
        }
    }

    function increaseApprovalWithSender(
        address _sender,
        address _spender,
        uint256 _addedValue
    )
        public
        onlyProxy
        returns (bool success)
    {
        require(_spender != address(0)); 
        uint256 currentAllowance ;	//inject UNINIT LOCAL/STATE VAR

        uint256 newAllowance ;	//inject UNINIT LOCAL/STATE VAR


        require(newAllowance >= currentAllowance);

        erc20Store.setAllowance(_sender, _spender, newAllowance);
        erc20Proxy.emitApproval(_sender, _spender, newAllowance);
        return true;
    }

    function decreaseApprovalWithSender(
        address _sender,
        address _spender,
        uint256 _subtractedValue
    )
        public
        onlyProxy
        returns (bool success)
    {
        require(_spender != address(0)); 
        uint256 currentAllowance ;	//inject UNINIT LOCAL/STATE VAR

        uint256 newAllowance ;	//inject UNINIT LOCAL/STATE VAR


        require(newAllowance <= currentAllowance);

        erc20Store.setAllowance(_sender, _spender, newAllowance);
        erc20Proxy.emitApproval(_sender, _spender, newAllowance);
        return true;
    }

    function requestPrint(address _receiver, uint256 _value) public returns (bytes32 lockId) {
        require(_receiver != address(0));

        lockId = generateLockId();

        pendingPrintMap[lockId] = PendingPrint({
            receiver: _receiver,
            value: _value
        });

        emit PrintingLocked(lockId, _receiver, _value);
    }

    function confirmPrint(bytes32 _lockId) public onlyCustodian {
        PendingPrint storage print = pendingPrintMap[_lockId];

        
        
        address receiver ;	//inject UNINIT LOCAL/STATE VAR

        require(receiver != address(0));
        uint256 value ;	//inject UNINIT LOCAL/STATE VAR


        delete pendingPrintMap[_lockId];

        uint256 supply ;	//inject UNINIT LOCAL/STATE VAR

        uint256 newSupply ;	//inject UNINIT LOCAL/STATE VAR

        if (newSupply >= supply) {
            erc20Store.setTotalSupply(newSupply);
            erc20Store.addBalance(receiver, value);

            emit PrintingConfirmed(_lockId, receiver, value);
            erc20Proxy.emitTransfer(address(0), receiver, value);
        }
    }

    function print(address _receiver, uint256 _value) public onlyCustodian {
        require(_receiver != address(0));
        uint256 supply ;	//inject UNINIT LOCAL/STATE VAR

        uint256 newSupply ;	//inject UNINIT LOCAL/STATE VAR

        if (newSupply >= supply) {
            erc20Store.setTotalSupply(newSupply);
            erc20Store.addBalance(_receiver, _value);
            erc20Proxy.emitTransfer(address(0), _receiver, _value);
        }
    }

    function requestBurnLimitsChange(uint256 _newMin, uint256 _newMax) public returns (bytes32 lockId) {
        require(_newMin <= _newMax, "min > max");

        lockId = generateLockId();
        pendingBurnLimitsMap[lockId] = PendingBurnLimits({
            min: _newMin,
            max: _newMax,
            isSet: true
        });

        emit BurnLimitsChangeLocked(lockId, _newMin, _newMax);
    }

    function confirmBurnLimitsChange(bytes32 _lockId) public onlyCustodian {
        PendingBurnLimits storage limits = pendingBurnLimitsMap[_lockId];

        
        
        bool isSet ;	//inject UNINIT LOCAL/STATE VAR

        require(isSet == true, "not such lockId");
        delete pendingBurnLimitsMap[_lockId];

        emit BurnLimitsChangeConfirmed(_lockId, limits.min, limits.max);
        burnMin = limits.min;
        burnMax = limits.max;   
    }

    function burnWithNote(address _burner, uint256 _value, string memory _note) public onlyProxy returns (bool success) {
        if (burnMin > 0) {
            require(_value >= burnMin, "below min burn limit");
        }
        if (burnMax > 0) {
            require(_value <= burnMax, "exceeds max burn limit");
        }

        uint256 balanceOfSender ;	//inject UNINIT LOCAL/STATE VAR

        require(_value <= balanceOfSender);

        erc20Store.setBalance(_burner, balanceOfSender - _value);
        erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);

        erc20Proxy.emitBurn(_burner, _value, _note);
        erc20Proxy.emitTransfer(_burner, address(0), _value);
        return true;
    }

    function batchTransfer(address[] memory _tos, uint256[] memory _values) public returns (bool success) {
        require(_tos.length == _values.length);

        uint256 numTransfers ;	//inject UNINIT LOCAL/STATE VAR

        uint256 senderBalance ;	//inject UNINIT LOCAL/STATE VAR


        for (uint256 i ; i < numTransfers; i++) {	//inject UNINIT LOCAL/STATE VAR

            address to ;	//inject UNINIT LOCAL/STATE VAR

            require(to != address(0));
            uint256 v ;	//inject UNINIT LOCAL/STATE VAR

            require(senderBalance >= v);

            if (msg.sender != to) {
                senderBalance -= v;
                erc20Store.addBalance(to, v);
            }
            erc20Proxy.emitTransfer(msg.sender, to, v);
        }

        erc20Store.setBalance(msg.sender, senderBalance);

        return true;
    }

    function enableSweep(uint8[] memory _vs, bytes32[] memory _rs,
    bytes32[] memory _ss, address _to) public onlySweeper {
        require(_to != address(0));
        require((_vs.length == _rs.length) && (_vs.length == _ss.length));

        uint256 numSignatures ;	//inject UNINIT LOCAL/STATE VAR

        uint256 sweptBalance ;	//inject UNINIT LOCAL/STATE VAR


        for (uint256 i ; i < numSignatures; ++i) {	//inject UNINIT LOCAL/STATE VAR

            address from ;	//inject UNINIT LOCAL/STATE VAR


            
            if (from != address(0)) {
                sweptSet[from] = true;
               
                uint256 fromBalance ;	//inject UNINIT LOCAL/STATE VAR


                if (fromBalance > 0) {
                    sweptBalance += fromBalance;
                    erc20Store.setBalance(from, 0);
                    erc20Proxy.emitTransfer(from, _to, fromBalance);
                }
            }
        }

        if (sweptBalance > 0) {
            erc20Store.addBalance(_to, sweptBalance);
        }
    }

    function replaySweep(address[] memory _froms, address _to) public onlySweeper {
        require(_to != address(0));
        uint256 lenFroms ;	//inject UNINIT LOCAL/STATE VAR

        uint256 sweptBalance ;	//inject UNINIT LOCAL/STATE VAR


        for (uint256 i ; i < lenFroms; ++i) {	//inject UNINIT LOCAL/STATE VAR

            address from ;	//inject UNINIT LOCAL/STATE VAR


            if (sweptSet[from]) {
                uint256 fromBalance ;	//inject UNINIT LOCAL/STATE VAR


                if (fromBalance > 0) {
                    sweptBalance += fromBalance;

                    erc20Store.setBalance(from, 0);

                    erc20Proxy.emitTransfer(from, _to, fromBalance);
                }
            }
        }

        if (sweptBalance > 0) {
            erc20Store.addBalance(_to, sweptBalance);
        }
    }

    function transferFromWithSender(
        address _sender,
        address _from,
        address _to,
        uint256 _value
    )
        public
        onlyProxy
        returns (bool success)
    {
        require(_to != address(0)); 

        uint256 balanceOfFrom ;	//inject UNINIT LOCAL/STATE VAR

        require(_value <= balanceOfFrom);

        uint256 senderAllowance ;	//inject UNINIT LOCAL/STATE VAR

        require(_value <= senderAllowance);

        erc20Store.setBalance(_from, balanceOfFrom - _value);
        erc20Store.addBalance(_to, _value);

        erc20Store.setAllowance(_from, _sender, senderAllowance - _value);

        erc20Proxy.emitTransfer(_from, _to, _value);

        return true;
    }

    function transferWithSender(
        address _sender,
        address _to,
        uint256 _value
    )
        public
        onlyProxy
        returns (bool success)
    {
        require(_to != address(0));

        uint256 balanceOfSender ;	//inject UNINIT LOCAL/STATE VAR

        require(_value <= balanceOfSender);

        erc20Store.setBalance(_sender, balanceOfSender - _value);
        erc20Store.addBalance(_to, _value);

        erc20Proxy.emitTransfer(_sender, _to, _value);

        return true;
    }
    
    function totalSupply() public view returns (uint256) {
        return erc20Store.totalSupply();
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return erc20Store.balances(_owner);
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return erc20Store.allowed(_owner, _spender);
    }

    event PrintingLocked(bytes32 _lockId, address _receiver, uint256 _value);

    event PrintingConfirmed(bytes32 _lockId, address _receiver, uint256 _value);

    event BurnLimitsChangeLocked(bytes32 _lockId, uint256 _newMin, uint256 _newMax);
    
    event BurnLimitsChangeConfirmed(bytes32 _lockId, uint256 _newMin, uint256 _newMax);
}

contract ERC20ImplUpgradeable is CustodianUpgradeable {

    struct ImplChangeRequest {
        address proposedNew;
    }

    ERC20Impl public erc20Impl;

    mapping (bytes32 => ImplChangeRequest) public implChangeReqs;

    constructor(address _custodian) public CustodianUpgradeable(_custodian) {
        erc20Impl = ERC20Impl(0x0);
    }

    modifier onlyImpl {
        require(msg.sender == address(erc20Impl));
        _;
    }

    function requestImplChange(address _proposedImpl) public returns (bytes32 lockId) {
        require(_proposedImpl != address(0));

        lockId = generateLockId();

        implChangeReqs[lockId] = ImplChangeRequest({
            proposedNew: _proposedImpl
        });

        emit ImplChangeRequested(lockId, msg.sender, _proposedImpl);
    }

    function confirmImplChange(bytes32 _lockId) public onlyCustodian {
        erc20Impl = getImplChangeReq(_lockId);

        delete implChangeReqs[_lockId];

        emit ImplChangeConfirmed(_lockId, address(erc20Impl));
    }

    function getImplChangeReq(bytes32 _lockId) private view returns (ERC20Impl _proposedNew) {
        ImplChangeRequest storage changeRequest = implChangeReqs[_lockId];

        require(changeRequest.proposedNew != address(0));

        return ERC20Impl(changeRequest.proposedNew);
    }

    event ImplChangeRequested(
        bytes32 _lockId,
        address _msgSender,
        address _proposedImpl
    );

    event ImplChangeConfirmed(bytes32 _lockId, address _newImpl);
}

contract ERC20Proxy is ERC20Interface, ERC20ImplUpgradeable {

    string public name;
    string public symbol;
    uint8 public decimals;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        address _custodian
    ) public ERC20ImplUpgradeable(_custodian) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return erc20Impl.totalSupply();
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return erc20Impl.balanceOf(_owner);
    }

    function emitTransfer(address _from, address _to, uint256 _value) public onlyImpl {
        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        return erc20Impl.transferWithSender(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        return erc20Impl.transferFromWithSender(msg.sender, _from, _to, _value);
    }

    function emitApproval(address _owner, address _spender, uint256 _value) public onlyImpl {
        emit Approval(_owner, _spender, _value);
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        return erc20Impl.approveWithSender(msg.sender, _spender, _value);
    }

    
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
        return erc20Impl.approveAndCallWithSender(msg.sender, _spender, _value, _extraData);
    }

    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
        return erc20Impl.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
    }

    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
        return erc20Impl.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return erc20Impl.allowance(_owner, _spender);
    }

    function emitBurn(address _burner, uint256 _value, string memory _note) public onlyImpl {
        emit Burn(_burner, _value, _note);
    }

    function burn(uint256 _value, string memory _note) public returns (bool success) {
        return erc20Impl.burnWithNote(msg.sender, _value, _note);
    }
}

contract ERC20Store is ERC20ImplUpgradeable {

    uint256 public totalSupply;

    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    constructor(address _custodian) public ERC20ImplUpgradeable(_custodian) {
        totalSupply = 0;
    }

    function setTotalSupply(
        uint256 _newTotalSupply
    )
        public
        onlyImpl
    {
        totalSupply = _newTotalSupply;
    }

    function setAllowance(
        address _owner,
        address _spender,
        uint256 _value
    )
        public
        onlyImpl
    {
        allowed[_owner][_spender] = _value;
    }

    function setBalance(
        address _owner,
        uint256 _newBalance
    )
        public
        onlyImpl
    {
        balances[_owner] = _newBalance;
    }

    function addBalance(
        address _owner,
        uint256 _balanceIncrease
    )
        public
        onlyImpl
    {
        balances[_owner] = balances[_owner] + _balanceIncrease;
    }
}