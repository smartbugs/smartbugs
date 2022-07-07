pragma solidity ^0.5.7;

/* NASH TOKEN FIRST EDITION
THE NEW WORLD BLOCKCHAIN PROJECT
CREATED 2019-04-18 BY DAO DRIVER ETHEREUM (c)*/

library SafeMath {
    
    function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns(uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

contract owned {
    address payable internal owner;
    address payable internal newOwner;
    address payable internal found;
    address payable internal feedr;
    
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    function changeOwner(address payable _owner) onlyOwner public {
        require(_owner != address(0));
        newOwner = _owner;
    }

    function confirmOwner() public {
        require(newOwner == msg.sender);
        owner = newOwner;
        delete newOwner;
    }
}

contract ERC20Basic {
    modifier onlyPayloadSize(uint size) {
        require(msg.data.length >= size + 4);
        _;
    }
    function totalSupply() public view returns(uint256);
    function balanceOf(address who) public view returns(uint256);
    function transfer(address payable to, uint256 value) public returns(bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view returns(uint256);
    function transferFrom(address payable from, address payable to, uint256 value) public returns(bool);
    function approve(address spender, uint256 value) public returns(bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract TokenBasic is ERC20Basic, owned {
    using SafeMath for uint256;
    mapping(address => uint256) internal balances;
    uint256 internal totalSupply_;
    uint256 internal activeSupply_;
    mapping(uint256 => uint256) public sum_;
    mapping(address => uint256) public pdat_;
    uint256 public pnr_;

    function totalSupply() public view returns(uint256) {
        return totalSupply_;
    }

    function activeSupply() public view returns(uint256) {
        return activeSupply_;
    }

    function transfer(address payable _to, uint256 _value) public onlyPayloadSize(2 * 32) returns(bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        require(_to != found);
        uint256 div1 = 0;
        uint256 div2 = 0;
        if (msg.sender != found) {
            if (pdat_[msg.sender] < pnr_) {
                for (uint256 i = pnr_; i >= pdat_[msg.sender]; i = i.sub(1)) {
                    div1 = div1.add(sum_[i].mul(balances[msg.sender]));
                }
            }
        }
        if (pdat_[_to] < pnr_ && balances[_to] > 0) {
            for (uint256 i = pnr_; i >= pdat_[_to]; i = i.sub(1)) {
                div2 = div2.add(sum_[i].mul(balances[_to]));
            }
        }
        
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        
        pdat_[_to] = pnr_;
        
        emit Transfer(msg.sender, _to, _value);
        
        if (msg.sender == found) {
            activeSupply_ = activeSupply_.add(_value);
        } else {
            pdat_[msg.sender] = pnr_;
            if (div1 > 0) {
                msg.sender.transfer(0);
            }
        }
        if (div2 > 0) {
            _to.transfer(0);
        }
        return true;
    }

    function balanceOf(address _owner) public view returns(uint256) {
        return balances[_owner];
    }
}

contract TokenStandard is ERC20, TokenBasic {
    
    mapping(address => mapping(address => uint256)) internal allowed;
    function transferFrom(address payable _from, address payable _to, uint256 _value) public onlyPayloadSize(3 * 32) returns(bool) {
        require(_to != address(0));
        require(_to != found);
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        uint256 div1 = 0;
        uint256 div2 = 0;
        if (_from != found) {
            if (pdat_[_from] < pnr_) {
                for (uint256 i = pnr_; i >= pdat_[_from]; i = i.sub(1)) {
                    div1 = div1.add(sum_[i].mul(balances[_from]));
                }
            }
        }
        if (pdat_[_to] < pnr_ && balances[_to] > 0) {
            for (uint256 i = pnr_; i >= pdat_[_to]; i = i.sub(1)) {
                div2 = div2.add(sum_[i].mul(balances[_to]));
            }
        }
        
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        
        pdat_[_to] = pnr_;
        
        emit Transfer(_from, _to, _value);
        if (_from == found) {
            activeSupply_ = activeSupply_.add(_value);
        } else {
            pdat_[_from] = pnr_;
            if (div1 > 0) {
                _from.transfer(0);
            }
        }
        if (div2 > 0) {
            _to.transfer(0);
        }
        return true;
    }
    function approve(address _spender, uint256 _value) public returns(bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) public view returns(uint256) {
        return allowed[_owner][_spender];
    }
    function increaseApproval(address _spender, uint _addrdedValue) public returns(bool) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addrdedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
    function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}
contract ANASH is TokenStandard {
    string public constant name = "NASH TOKEN";
    string public constant symbol = "NASH";
    uint8 public constant decimals = 2;
    uint256 internal constant premined = 20000000000;
    function() payable external {	//injected LOCKED ETHER
        if (feedr == msg.sender) {
            require(msg.value >= 1);
            sum_[pnr_] = msg.value.div(activeSupply_);
            pnr_ = pnr_.add(1);
        } else {
            require(balances[msg.sender] > 0);
            uint256 div1 = 0;
            uint256 cont = 0;
            if (pdat_[msg.sender] < pnr_) {
                for (uint256 i = pnr_; i >= pdat_[msg.sender]; i = i.sub(1)) {
                    div1 = div1.add(sum_[i].mul(balances[msg.sender]));
                    cont = cont.add(1);
                    if(cont > 80){break;}
                }
            }
            pdat_[msg.sender] = pnr_;
            div1 = div1.add(msg.value);
            if (div1 > 0) {
                msg.sender.transfer(0);
            }
        }
    }
    constructor() public {
        pnr_ = 1;
        owner = msg.sender;
        found = 0xfB538A7365d47183692E1866fC0b32308F15BAFD;
        feedr = 0xCebaa747868135CC4a0d9A4f982849161f3a4CE7;
        totalSupply_ = premined;
        activeSupply_ = 0;
        balances[found] = balances[found].add(premined);
        emit Transfer(address(0), found, premined);
    }
}