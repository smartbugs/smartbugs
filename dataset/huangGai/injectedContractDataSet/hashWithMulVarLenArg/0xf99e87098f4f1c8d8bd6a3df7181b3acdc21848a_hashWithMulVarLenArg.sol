/***
 *      ______ _   _               _____      _              _       _           
 *     |  ____| | | |             / ____|    | |            | |     | |          
 *     | |__  | |_| |__   ___ _ _| (___   ___| |__   ___  __| |_   _| | ___ _ __ 
 *     |  __| | __| '_ \ / _ \ '__\___ \ / __| '_ \ / _ \/ _` | | | | |/ _ \ '__|
 *     | |____| |_| | | |  __/ |  ____) | (__| | | |  __/ (_| | |_| | |  __/ |   
 *     |______|\__|_| |_|\___|_| |_____/ \___|_| |_|\___|\__,_|\__,_|_|\___|_|   
 *                                                                               
 *                                                                               
 */

pragma solidity ^ 0.5.1;

library ECRecovery {

  function recover(bytes32 hash, bytes memory sig)
    internal
    pure
    returns (address)
  {
    bytes32 r;
    bytes32 s;
    uint8 v;

    if (sig.length != 65) {
      return (address(0));
    }

    assembly {
      r := mload(add(sig, 32))
      s := mload(add(sig, 64))
      v := byte(0, mload(add(sig, 96)))
    }

    if (v < 27) {
      v += 27;
    }

    if (v != 27 && v != 28) {
      return (address(0));
    } else {
      return ecrecover(hash, v, r, s);
    }
  }


  function toEthSignedMessageHash(bytes32 hash)
    internal
    pure
    returns (bytes32)
  {

    return keccak256(
      abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
    );
  }
}

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }


    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract EtherScheduler {
    using ECRecovery for bytes32;
    using SafeMath for uint;

    mapping(address => uint256) internal balances;
    mapping(address => mapping(uint => bool)) internal usedNonces;
    
    event Fulfilled(bytes indexed signature, address indexed signer);
    
    address payable private fee_collector;
    IERC20 private TXC;
    
    constructor(address payable _fee_collector, address _TXC) public {
        fee_collector = _fee_collector; /* 0xfF91c94F45e1114b1C90Be6D028381964030584C */
        
        TXC = IERC20(_TXC);             /* kovan txc 0x12C942fDbE9981E68DC153CC92dA2e2c301F5a9A */
                                        /* mainnet txc 0x67e35c41060a988f59e2bcb2e0f09b6978fb6614*/
    }

    function getPackedData(
        address _targetAddress,
        uint _amount,
        uint P,
        bool _byBlock,
        uint C,
        uint _nonce,
        uint networkID
    ) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_targetAddress, _amount, P, _byBlock, C, _nonce, networkID));
    }
    
    function getPackedDataBundle(
        address payable[] memory _targetAddresses,
        uint[] memory _amounts,
        uint P,
        bool _byBlock,
        uint C,
        uint _nonce,
        uint networkID
    ) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_targetAddresses, _amounts, P, _byBlock, C, _nonce, networkID));
    }
    
    function verifySigner(
        address _targetAddress,
        uint _amount,
        uint P,
        bool _byBlock,
        uint C,
        uint _nonce,
        uint networkID,
        bytes memory _signature
    ) public pure returns(address) {
        bytes32 hash = keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            keccak256(abi.encodePacked(_targetAddress, _amount, P, _byBlock, C, _nonce, networkID)))
        );
        
        return hash.recover(_signature);
    }
    
    function timeCondition(
        address payable _targetAddress,
        uint _amount,
        uint P,
        bool _byBlock,
        uint C,
        uint _nonce,
        uint networkID,
        bytes memory _signature
    ) public payable {
        bytes32 hash = keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            keccak256(abi.encodePacked(_targetAddress, _amount, P, _byBlock, C, _nonce, networkID)))
        );

        address signer = hash.recover(_signature);
                
        require(!usedNonces[signer][_nonce]);
        usedNonces[signer][_nonce] = true;
        //  v------------------------------ Burned the nonce ------------------------------v
        
        uint Q = balances[signer].sub(P.add(_amount));
        
        require(Q >= 0);
        require(_byBlock ? block.number >= C : now >= C);
        
        // Request
        resolve(_targetAddress, signer, _amount, P);

        // Incentive  
        payout(P);
        
        emit Fulfilled(_signature, signer);
    }
    
    function timeConditionBundle(
        address payable[] memory _targetAddresses,
        uint[] memory _amounts,
        uint P,
        bool _byBlock,
        uint C,
        uint _nonce,
        uint networkID,
        bytes memory _signature
    ) public payable {
        bytes32 hash = keccak256(abi.encodePacked(_targetAddresses, _amounts));	//inject HASH WITH MUL VAR LEN ARG
        
        address signer = hash.recover(_signature);
        
        require(!usedNonces[signer][_nonce]);
        usedNonces[signer][_nonce] = true;
        //  v------------------------------ Burned the nonce ------------------------------v
        
        uint totalAmount = 0;

        for(uint r = 0; r < _amounts.length; r = r.add(1)) {
            totalAmount = totalAmount.add(_amounts[r]);
        }
        
        uint Q = balances[signer].sub(P.add(totalAmount));
        
        require(Q >= 0);
        require(_amounts.length == _targetAddresses.length);
        require(_byBlock ? block.number >= C : now >= C);
        
        // Request  
        for(uint r = 0; r < _amounts.length; r = r.add(1)) {
            resolve(_targetAddresses[r], signer, _amounts[r], P);
        }
        
        // Incentive  
        payout(P);
        
        emit Fulfilled(_signature, signer);
    }
    
    function payout(
        uint P
    ) internal {
        uint fee = TXC.balanceOf(msg.sender) > 0 ? 0 : P.div(10).mul(3);
        
        msg.sender.transfer(P-fee);
        fee_collector.transfer(fee);
    }
    
    function resolve(
        address payable _targetAddress,
        address signer,
        uint _amount,
        uint P
    ) internal {
        balances[signer] = balances[signer].sub(P.add(_amount));
        _targetAddress.transfer(_amount);
    }
    
    function cancelTX(uint _nonce) external {
        usedNonces[msg.sender][_nonce] = true;
        
        balances[msg.sender] = balances[msg.sender].sub(1 finney);
        fee_collector.transfer(1 finney);
    }
    
    function deposit(address _beneficiary) public payable {
        balances[_beneficiary] =  balances[_beneficiary].add(msg.value);
    }
    
    function balanceOf(address _owner) public view returns (uint balance){
        return balances[_owner];
    }
    
    function() external payable {
        deposit(msg.sender);
    }
}