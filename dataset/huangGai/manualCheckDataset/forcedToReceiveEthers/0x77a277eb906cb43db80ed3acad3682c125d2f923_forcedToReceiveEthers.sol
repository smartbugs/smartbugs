/**
 *Submitted for verification at Etherscan.io on 2020-08-14
*/

/**
 *Submitted for verification at Etherscan.io on 2020-08-14
*/
pragma solidity ^0.5.16;

interface tokenRecipient { 
    function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
}

contract Ownable {

    address payable owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() { require(msg.sender == owner); _; }

    function transferOwnership(address payable newOwner) onlyOwner public { require(newOwner != address(0)); emit OwnershipTransferred(owner, newOwner); owner = newOwner; }
}

contract TokenERC20 is Ownable{
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    mapping(address => bool) public whiteList;
    uint256 public totalWhiteListed;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event Burn(address indexed from, uint256 value);
    event Mint(address indexed from, uint256 value);

    event LogWhiteListed(address indexed user, uint totalWhiteListed);
    event LogRemoveWhiteListed(address indexed totalWhiteListed);

    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != address(0x0));
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][owner]);
        allowance[_from][owner] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public onlyOwner
        returns (bool success) {
        allowance[owner][_spender] = _value;
        emit Approval(owner, _spender, _value);
        return true;
    }

    function approveAndCall(address _spender, uint256 _value, bytes  memory _extraData)
        public
        returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, address(this), _extraData);
            return true;
        }
    }

    function burn(uint256 _value) public returns (bool success) {
        
        uint256  amount;
        amount = _value * 10 ** uint256(decimals);
        require(balanceOf[msg.sender] >= amount);   // Check if the sender has enough
        balanceOf[msg.sender] -= amount;            // Subtract from the sender
        totalSupply -= amount;                      // Updates totalSupply
        emit Burn(msg.sender, amount);
        return true;
    }

    function burnFrom(address _from, uint256 _value) public  onlyOwner returns (bool success) {
        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
        require(_value <= allowance[_from][owner]);    // Check allowance
        uint256  amount;
        amount = _value * 10 ** uint256(decimals);
        balanceOf[_from] -= amount;                         // Subtract from the targeted balance
        allowance[_from][owner] -= amount;             // Subtract from the sender's allowance
        totalSupply -= amount;                              // Update totalSupply
        emit Burn(_from, amount);
        return true;
    }

    function mint(uint256 _value) public  onlyOwner returns (bool success) {
        require(_value >= 0);
        uint256  amount;
        amount = _value * 10 ** uint256(decimals);
        balanceOf[owner] += amount;
        totalSupply += amount;
        emit Mint(owner,amount);
        return true;
    }

    function mintTo(address _to, uint256 _value) public  onlyOwner returns (bool success) {
        require(_value >= 0);
        uint256  amount;
        amount = _value * 10 ** uint256(decimals);
        balanceOf[_to] += amount;
        totalSupply += amount;
        emit Mint(_to, amount);
        return true;
    }

    function isWhiteListed(address user) external view returns (bool) {

        return whiteList[user]; 
    }

    function removeFromWhiteList(address _user) public onlyOwner returns (bool) {
    
        require(whiteList[_user] == true);
        whiteList[_user] = false;
        totalWhiteListed--;
        emit LogRemoveWhiteListed(_user);
        return true;
    }
    
    function addToWhiteList(address _user) public  onlyOwner returns (bool) {

        if (whiteList[_user] != true) {
            whiteList[_user] = true;
            totalWhiteListed++;
            emit LogWhiteListed(_user, totalWhiteListed);            
        }
        return true;
    }   
}

library SafeMath {
    int256 constant private INT256_MIN = -2**255;

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function mul(int256 a, int256 b) internal pure returns (int256) {
        if (a == 0) {
            return 0;
        }

        require(!(a == -1 && b == INT256_MIN));

        int256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b > 0);
        uint256 c = a / b;

        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != 0);
        require(!(b == -1 && a == INT256_MIN));

        int256 c = a / b;

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

contract Fundraising is TokenERC20{
    using SafeMath for uint256;
    uint256 layer = 1;
    uint256 layerExchangeRate = 40000;
    uint256 offset;
    uint256 exchangeTokenNum;
    uint256 lastUserTime;
    uint256 lastSum;
    uint256 tokencount;
    uint256 layercount;
    uint8   fomoStatus = 0;
    uint256 public amountRaised;
    address payable lastUserAddress;
    address payable lastUser;

    event Play(address indexed dest, uint256 amount);
    event Withdrawal(address indexed src, uint256 amount);

    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol
    ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        name = tokenName; 
        symbol = tokenSymbol;
        owner = msg.sender;
    }
   
    function () external payable{
        if(fomoStatus == 2){
            emit Play(msg.sender, msg.value);
        }
        else
        {
            exchangeTokenNum =calculateToken(msg.value);
            balanceOf[msg.sender] = balanceOf[msg.sender].add(exchangeTokenNum);
            
            totalSupply = totalSupply.add(exchangeTokenNum);
            tokencount += exchangeTokenNum;
    
            if(address(this).balance == 0){	//inject FORCED TO RECEIVE ETHERS
                lastUserTime =now;
            }
    
            if(msg.value*10 >= 5){
                lastUserTime =now;
            }
    
            amountRaised += msg.value;
            if (amountRaised >= 2058 && fomoStatus == 0){
                fomoStatus = 1;
            }
    
            if (msg.value >=1){
                lastUserAddress = msg.sender;
            }
            emit Play(msg.sender, msg.value);
        }
    }

    function calculateToken(uint256 amount) internal returns(uint256){
        uint256 noExchangeETH;
        uint256 currentExchangeETH;
        uint256 currentTotalToken;
        
        noExchangeETH = amount;
        offset += amount;
        layercount = 8 ether + SafeMath.mul(layer-1, 2 ether);
        while(offset > layercount){
            offset = offset - layercount;
            currentExchangeETH = noExchangeETH - offset;
            currentTotalToken += currentExchangeETH * layerExchangeRate;

            layercount += 2 ether;
            layer += 1;
            layerExchangeRate = layerExchangeRate*25/27;
            noExchangeETH = offset;
        }
        
        currentTotalToken += noExchangeETH * layerExchangeRate;
        return currentTotalToken;
    }
    
    function check() public  returns (bool){
        if ((now - lastUserTime) >= 3 days && fomoStatus == 1){
            lastUser = lastUserAddress;
            lastSum  = amountRaised;
            fomoStatus =2;
            lastUser.transfer(lastSum*1/20);
        }
        return true;
    }

    function withdrawal(uint256 _amount) onlyOwner public returns (bool){
        owner.transfer(_amount);
        return true;
    }

    function getSystemInfo()public view returns (uint256,uint256,uint256,uint256,address,address,uint256){
        return (
            layerExchangeRate,
            layer,
            amountRaised,
            tokencount,
            lastUser,
            lastUserAddress,
            lastUserTime
        );
    }
}