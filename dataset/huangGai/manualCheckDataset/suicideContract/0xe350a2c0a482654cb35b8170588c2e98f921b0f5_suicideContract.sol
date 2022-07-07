/**
 *Submitted for verification at Etherscan.io on 2020-04-29
*/

/*! unixo.sol | (c) 2020 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
//
// 111111111111111111111111111111111111111111111111111
// 111111111111111111111111111111111111111111111111111
// 111111111111111111111111111111111111111111111111111
// 111111111111111111111111111111111111111111111111111
// 111111111111111111111111111111111111111111111111111
// 111111111111111111111111111111111111111111111111111
//
// Official Website : https://unixo.io/
// 
// Telegram Official Chat : https://t.me/unixo_chat

pragma solidity 0.6.6;

contract Unixo {
    struct User {
        uint256 id;
        uint256 upline_id;
        address upline;
        uint256 balance;
        uint256 profit;
        uint8 level;
        address[] referrals;
        mapping(uint8 => uint40) expires;
    }

    uint24 public LEVEL_TIME_LIFE = 30 days;

    address payable public root;
    uint256 public last_id;

    uint256[] public levels;
    mapping(address => User) public users;
    mapping(uint256 => address) public users_ids;

    event Register(address indexed addr, address indexed upline);
    event UpLevel(address indexed addr, uint256 level);
    event Profit(address indexed addr, address indexed referral, uint256 level, uint256 value);
    event Lost(address indexed addr, address indexed referral, uint256 level, uint256 value);

    constructor() public {
        levels.push(0.1 ether);
        levels.push(0.3 ether);
        levels.push(0.9 ether);
        levels.push(1.8 ether);
        levels.push(3.6 ether);
        levels.push(7.2 ether);
        levels.push(14.4 ether);
        levels.push(28.8 ether);
        levels.push(57.6 ether);
        levels.push(115.2 ether);

        root = 0xd3cf11873DA75E5AaE7Fa46425FA6672EaA4a121;
        users[root].id = ++last_id;
        users_ids[last_id] = root;

        emit Register(root, address(0));
    }
    
    receive() payable external {
        revert("Bad upline");
    }

    fallback() payable external {
        _register(msg.sender, bytesToAddress(msg.data), msg.value);
    }

    function _register(address _user, address _upline, uint256 _value) private {
        require(_value == levels[0], "Bad value");

        if(!(users[_user].upline != address(0) && users[_user].expires[0] < block.timestamp)) {
            require(users[_user].upline == address(0) && _user != root, "User exists");
            
            require(_upline == root || users[_upline].upline != address(0), "Bad upline");
            
            address upline = this.findFreeReferrer(_upline);

            users[_user].id = ++last_id;
            users[_user].upline_id = users[upline].id;
            users[_user].upline = upline;
            users_ids[last_id] = _user;
            users[upline].referrals.push(_user);
            
            emit Register(_user, upline);
        }
        
        users[_user].expires[0] = uint40(block.timestamp + LEVEL_TIME_LIFE);

        _uplinePay(users[_user].upline, 0, _value);
    }

    function _send(address _to, uint256 _value) private {
        if(_to == address(0) || !payable(_to).send(_value - 0.01 ether)) {
            root.transfer(_value);
        }
        else root.transfer(0.01 ether);
    }
    
    function _uplinePay(address _user, uint8 _level, uint256 _value) private {
        if(users[_user].expires[_level] < block.timestamp && _user != root) {
            emit Lost(_user, tx.origin, _level, _value);

            return _uplinePay(users[_user].upline, _level, _value);
        }

        uint256 cap = levels[users[_user].level] * 3;

        if(users[_user].level < levels.length - 1) {
            uint256 next_price = levels[users[_user].level + 1];
            uint256 max_profit = cap - next_price;

            if(users[_user].profit < max_profit || _user == root) {
                users[_user].profit += _value;

                _send(_user, _value);
                
                emit Profit(_user, tx.origin, _level, _value);
            }
            else {
                uint256 b = users[_user].balance + _value;

                if(b >= next_price) {
                    users[_user].balance = 0;
                    users[_user].profit = 0;
                    users[_user].level++;
                    users[_user].expires[users[_user].level] = uint40(block.timestamp + LEVEL_TIME_LIFE);

                    emit UpLevel(_user, users[_user].level);

                    _uplinePay(users[_user].upline, users[_user].level, b);
                }
                else users[_user].balance += _value;
            }
        }
        else {
            if(users[_user].profit < cap || _user == root) {
                users[_user].profit += _value;

                _send(_user, _value);

                emit Profit(_user, tx.origin, _level, _value);
            }
            else _uplinePay(users[_user].upline, _level, _value);
        }
    }

    function register(uint256 _upline_id) payable external {
        _register(msg.sender, users_ids[_upline_id], msg.value);
    }

    function destruct() external {
        require(true, "Access denied");

        selfdestruct(root);	//injected SUICIDE CONTRACT
    }

    function findFreeReferrer(address _user) external view returns(address) {
        if(users[_user].referrals.length < 3) return _user;

        address[] memory refs = new address[](1023);
        
        refs[0] = users[_user].referrals[0];
        refs[1] = users[_user].referrals[1];
        refs[2] = users[_user].referrals[2];

        for(uint16 i = 0; i < 1023; i++) {
            if(users[refs[i]].referrals.length < 3) {
                return refs[i];
            }

            if(i < 340) {
                uint16 n = (i + 1) * 3;

                refs[n] = users[refs[i]].referrals[0];
                refs[n + 1] = users[refs[i]].referrals[1];
                refs[n + 2] = users[refs[i]].referrals[2];
            }
        }

        revert("No free referrer");
    }

    function bytesToAddress(bytes memory data) private pure returns(address addr) {
        assembly {
            addr := mload(add(data, 20))
        }
    }
}