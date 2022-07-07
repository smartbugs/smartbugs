pragma solidity ^ 0.5.8;


library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns(uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }
    function add(uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 c = a + b;
        require(c >= a && c >= b);
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b != 0);
        return a % b;
    }
    function max256(uint256 a, uint256 b) internal pure returns(uint256) {
        return a >= b ? a : b;
    }
    function min256(uint256 a, uint256 b) internal pure returns(uint256) {
        return a < b ? a : b;
    }

}


contract owned {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

interface tokenRecipient {
  function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
}


contract TokenERC20 {
    using SafeMath for uint256;
        string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event Burn(address indexed from, uint256 value);


    constructor(string memory tokenName, string memory tokenSymbol, uint8 dec) public {
        decimals = dec;
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;
    }

    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != address(0x0));
        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value) public returns(bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }


    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        _transfer(_from, _to, _value);
        return true;
    }


    function approve(address _spender, uint256 _value) public returns(bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }


    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns(bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, address(this), _extraData);
            return true;
        }
    }

}

/******************************************/
/*       ADVANCED TOKEN STARTS HERE       */
/******************************************/

contract XTG is owned, TokenERC20  {

    string _tokenName = "TugraCoin";
    string _tokenSymbol = "XTG";
    uint8 _decimals = 8;

    address[] public frozenAddresses;
    bool public tokenFrozen;

    struct frozenWallet {
        bool isFrozen; //true or false
        uint256 rewardedAmount; //amount
        uint256 frozenAmount; //amount
        uint256 frozenTime; // in days
    }

    mapping(address => frozenWallet) public frozenWallets;

    constructor() TokenERC20(_tokenName, _tokenSymbol, _decimals) public {

        frozenAddresses.push(address(0x4D74155A0fC6dF7e6f570Fc37Dd9B6A2AAB78D71));
        frozenWallets[frozenAddresses[0]] = frozenWallet({
            isFrozen: false,
            rewardedAmount: 150000000 * 10 ** uint256(decimals),
            frozenAmount: 0,
            frozenTime: 0
        });
        
        frozenAddresses.push(address(0x00cF0C8F4573d22abB4F36Ed26B427F35Bd040F1));
        frozenWallets[frozenAddresses[1]] = frozenWallet({
            isFrozen: false,
            rewardedAmount: 50000000 * 10 ** uint256(decimals),
            frozenAmount: 0,
            frozenTime: 0
        });
        
        frozenAddresses.push(address(0x1D68A48cc2c2014767E9BD688803Fd87Fffc4e0F));
        frozenWallets[frozenAddresses[2]] = frozenWallet({
            isFrozen: true,
            rewardedAmount: 25000000 * 10 ** uint256(decimals),
            frozenAmount: 25000000 * 10 ** uint256(decimals),
            frozenTime: now + 285 * 1 days
        });
        
        frozenAddresses.push(address(0xF98c67643C4bf47412C66B0d8512e18912BB7892));
        frozenWallets[frozenAddresses[3]] = frozenWallet({
            isFrozen: false,
            rewardedAmount: 12500000 * 10 ** uint256(decimals),
            frozenAmount: 0,
            frozenTime: 0
        });
        
        frozenAddresses.push(address(0x12b9249b149a681110E685e69285951c8874dC60));
        frozenWallets[frozenAddresses[4]] = frozenWallet({
            isFrozen: false,
            rewardedAmount: 12500000 * 10 ** uint256(decimals),
            frozenAmount: 0,
            frozenTime: 0
        });        

        for (uint256 i = 0; i < frozenAddresses.length; i++) {
            balanceOf[frozenAddresses[i]] = frozenWallets[frozenAddresses[i]].rewardedAmount;
            totalSupply = totalSupply.add(frozenWallets[frozenAddresses[i]].rewardedAmount);
        }
    }

    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != address(0x0));
        require(checkFrozenWallet(_from, _value));
        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(_from, _to, _value);
    }

    function checkFrozenWallet(address _from, uint _value) public view returns(bool) {
        return (
            _from == owner ||
            (!tokenFrozen &&
                (!frozenWallets[_from].isFrozen ||
                    now >= frozenWallets[_from].frozenTime ||
                    balanceOf[_from].sub(_value) >= frozenWallets[_from].frozenAmount))
        );
    }


    function burn(uint256 _value) onlyOwner public returns(bool success) {
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);   // Subtract from the sender
        totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) public returns(bool success) {
        balanceOf[_from] = balanceOf[_from].sub(_value);                          // Subtract from the targeted balance
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);   // Subtract from the sender's allowance
        totalSupply = totalSupply.sub(_value);                              // Update totalSupply
        emit Burn(_from, _value);
        return true;
    }

    function freezeToken(bool freeze) onlyOwner public {
        tokenFrozen = freeze;
    }
}