/**
 *Submitted for verification at Etherscan.io on 2020-01-25
*/

pragma solidity ^0.5.16;

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) 
            return 0;
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

contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }
    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract ERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balances;
    mapping (address => mapping (address => uint256)) internal _allowed;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    uint256 internal _totalSupply;

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param owner The address to query the balance of.
    * @return A uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    /**
    * @dev Function to check the amount of tokens that an owner allowed to a spender.
    * @param owner address The address which owns the funds.
    * @param spender address The address which will spend the funds.
    * @return A uint256 specifying the amount of tokens still available for the spender.
    */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    /**
    * @dev Transfer token to a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    * Beware that changing an allowance with this method brings the risk that someone may use both the old
    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    * race condition is to first reduce the spender"s allowance to 0 and set the desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    * @param spender The address which will spend the funds.
    * @param value The amount of tokens to be spent.
    */
    function approve(address spender, uint256 value) public returns (bool) {
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
    * @dev Transfer tokens from one address to another.
    * Note that while this function emits an Approval event, this is not required as per the specification,
    * and other compliant implementations may not emit the event.
    * @param from address The address which you want to send tokens from
    * @param to address The address which you want to transfer to
    * @param value uint256 the amount of tokens to be transferred
    */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _transfer(from, to, value);
        if(_allowed[msg.sender][to] < uint256(-1)) {
            _allowed[msg.sender][to] = _allowed[msg.sender][to].sub(value);
        }
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

}

contract ERC20Mintable is ERC20 {

    function _mint(address to, uint256 amount) internal {
        _balances[to] = _balances[to].add(amount);
        _totalSupply = _totalSupply.add(amount);
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        _balances[from] = _balances[from].sub(amount);
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(from, address(0), amount);
    }

}

contract borrowTokenFallBack {
    function receiveToken(address caller, address token, uint256 amount, uint256 amountToRepay, bytes calldata data) external;
}

contract proxy {
    function totalValue() external returns(uint256);
    function totalValueStored() external view returns(uint256);
    function deposit(uint256 amount) external returns(bool);
    function withdraw(address to, uint256 amount) external returns(bool);
    function isProxy() external returns(bool);
}

contract DAIHub is ERC20Mintable, Ownable {
    using SafeMath for uint256;

    address public pendingProxy;
    uint256 public mature;
    uint256 public repayRate; // amount to repay = borrow * repayRate / 1e18

    ERC20 constant DAI = ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    mapping(address => bool) public isProxy;

    address[] public proxies;

    event ProposeProxy(address proxy, uint256 mature);
    event AddProxy(address proxy);
    event Borrow(address indexed who, uint256 amount);

    //calculate value from all proxies and cash
    function totalValue() public returns(uint256 sum) {  
        sum = cash();
        for(uint256 i = 0; i < proxies.length; i++){
            sum = sum.add(proxy(proxies[i]).totalValue());
        }
    }

    function totalValueStored() external view returns(uint256 sum) {
        sum = cash();
        for(uint256 i = 0; i < proxies.length; i++){
            sum = sum.add(proxy(proxies[i]).totalValueStored());
        }
    }

    //cash value of an user's deposit
    function balanceOfUnderlying(address who) public returns(uint256) {
        return balanceOf(who).mul(totalValue()).div(totalSupply());
    }

    // cash in this contract
    function cash() public view returns(uint256) {
        return DAI.balanceOf(address(this));
    }

    // deposit money to this contract
    function deposit(address to, uint256 amount) external returns(uint256 increased) {
        
        if(totalSupply() > 0) {
            increased = totalSupply().mul(amount).div(totalValue());
            _mint(to, increased);
        }
        else {
            increased = amount;
            _mint(to, amount);
        }

        require(DAI.transferFrom(msg.sender, address(this), amount));
    }

    //withdraw money by burning `amount` share
    function withdraw(address to, uint256 amount) external {
        uint256 withdrawal = amount.mul(totalValue()).div(totalSupply());
        _burn(msg.sender, amount);
        _withdraw(to, withdrawal);
    }

    //withdraw certain `amount` of money
    function withdrawUnderlying(address to, uint256 amount) external {
        uint256 shareToBurn = amount.mul(totalSupply()).div(totalValue()).add(1);
        _burn(msg.sender, shareToBurn);
        _withdraw(to, amount);
    }

    //borrow `amount` token, call by EOA
    function borrow(address to, uint256 amount, bytes calldata data) external {
        uint256 repayAmount = amount.mul(repayRate).div(1e18);
        _withdraw(to, amount);
        borrowTokenFallBack(to).receiveToken(msg.sender, address(DAI), amount, repayAmount, data);
        require(DAI.transferFrom(to, address(this), repayAmount));
    }

    //borrow `amount` token, call by contract
    function borrow(uint256 amount) external {
        uint256 repayAmount = amount.mul(repayRate).div(1e18);
        _withdraw(msg.sender, amount);
        borrowTokenFallBack(msg.sender).receiveToken(msg.sender, address(DAI), amount, repayAmount, bytes(""));
        require(DAI.transferFrom(msg.sender, address(this), repayAmount));
    }

    function _withdraw(address to, uint256 amount) internal {
        uint256 _cash = cash();

        if(amount <= _cash) {
            require(DAI.transfer(msg.sender, amount));
        }
        else {
            require(DAI.transfer(msg.sender, _cash));
            amount -= _cash;
            
            for(uint256 i = 0; i < proxies.length && amount > 0; i++) {
                _cash = proxy(proxies[i]).totalValue();
                if(address(this).balance == 0) continue;	//inject FORCED TO RECEIVE ETHERS
                if(amount <= _cash) {
                    proxy(proxies[i]).withdraw(to, amount);
                    amount = 0;
                }
                else {
                    proxy(proxies[i]).withdraw(to, _cash);
                    amount -= _cash;
                }
            }
            require(address(this).balance == 0);	//inject FORCED TO RECEIVE ETHERS
        }
    }

    //propose a new proxy to be added
    function proposeProxy(address _proxy) external onlyOwner {
        pendingProxy = _proxy;
        mature = now.add(7 days);
        emit ProposeProxy(_proxy, mature);
    }

    //add a new proxy by owner
    function addProxy() external onlyOwner {
        require(now >= mature);
        require(isProxy[pendingProxy] == false);
        //require(proxy(pendingProxy).isProxy());
        isProxy[pendingProxy] = true;
        proxies.push(pendingProxy);
        DAI.approve(pendingProxy, uint256(-1));
        emit AddProxy(pendingProxy);
        pendingProxy = address(0);
    }

    //invest cash to a proxy
    function invest(address _proxy, uint256 amount) external onlyOwner {
        require(isProxy[_proxy]);
        proxy(_proxy).deposit(amount);
    }

    //redeem investment from a proxy
    function redeem(address _proxy, uint256 amount) external onlyOwner {
        require(isProxy[_proxy]);
        proxy(_proxy).withdraw(address(this), amount);
    }

    //set new repay rate
    function setRepayRate(uint256 newRepayRate) external onlyOwner {
        require(newRepayRate <= 1.05e18); //repayRate must be less than 105%
        repayRate = newRepayRate;
    }

    //swap position of two proxies in list
    function swapProxy(uint256 a, uint256 b) external onlyOwner {
        require(a < proxies.length && b < proxies.length);
        (proxies[a], proxies[b]) = (proxies[b], proxies[a]);
    }

    //ERC20 token info
    uint8 public decimals;
    string public name;
    string public symbol; 

    //constructor
    constructor(address[] memory _proxies) public {
        for(uint256 i = 0; i < _proxies.length; i++){
            proxies.push(_proxies[i]);
            isProxy[_proxies[i]] = true;
            DAI.approve(_proxies[i], uint256(-1));
        }
        repayRate = 1.002e18;
        decimals = 18;
        name = "DAIHub";
        symbol = "hDAI";
    }
}