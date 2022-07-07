/**
 *Submitted for verification at Etherscan.io on 2020-07-06
*/

/*! lionshare.sol | (c) 2020 Develop by BelovITLab LLC (smartcontract.ru), author @edward | SPDX-License-Identifier: MIT License 
this is lionshare matrix, first multilevel matrix that starts with 0.04eth only*/

pragma solidity 0.6.8;

contract Lionshare {
    struct User {
        uint256 id;
        address inviter;
        uint256 balance;
        mapping(uint8 => uint40) expires;
        mapping(uint8 => address) uplines;
        mapping(uint8 => address[]) referrals;
    }

    uint40 public LEVEL_TIME_LIFE = 120 days;

    address payable public root;
    uint256 public last_id;

    uint256[] public levels;
    mapping(address => User) public users;
    mapping(uint256 => address) public users_ids;

    event Register(address indexed addr, address indexed inviter, uint256 id);
    event BuyLevel(address indexed addr, address indexed upline, uint8 level, uint40 expires);
    event Profit(address indexed addr, address indexed referral, uint256 value);
    event Lost(address indexed addr, address indexed referral, uint256 value);

    constructor() public {
        levels.push(0.04 ether);
        levels.push(0.04 ether);
        levels.push(0.04 ether);

        levels.push(0.22 ether);
        levels.push(0.32 ether);
        levels.push(0.82 ether);

        levels.push(0.43 ether);
        levels.push(0.63 ether);
        levels.push(1.63 ether);
        
        levels.push(0.84 ether);
        levels.push(1.24 ether);
        levels.push(3.24 ether);
        
        levels.push(1.65 ether);
        levels.push(2.45 ether);
        levels.push(6.45 ether);
        
        levels.push(3.26 ether);
        levels.push(4.96 ether);
        levels.push(12.86 ether);
        
        levels.push(6.47 ether);
        levels.push(9.87 ether);
        levels.push(25.67 ether);
        
        levels.push(12.88 ether);
        levels.push(19.78 ether);
        levels.push(51.28 ether);
        
        levels.push(25.69 ether);
        levels.push(39.59 ether);
        levels.push(102.49 ether);
        
        levels.push(51.30 ether);
        levels.push(79.20 ether);
        levels.push(205.20 ether);

        root = 0x280f47b4eAE5D775983DB5Ab39b4d66F5Db75cf9;

        _newUser(root, address(0));

        for(uint8 i = 0; i < levels.length; i++) {
            users[root].expires[i] = uint40(-1);

            emit BuyLevel(root, address(0), i, users[root].expires[i]);
        }
    }

    receive() payable external {
        require(users[msg.sender].id > 0, "User not register");
        
        users[msg.sender].balance += msg.value;

        _autoBuyLevel(msg.sender);
    }

    fallback() payable external {
        _register(msg.sender, bytesToAddress(msg.data), msg.value);
    }

    function _newUser(address _addr, address _inviter) private {
        users[_addr].id = ++last_id;
        users[_addr].inviter = _inviter;
        users_ids[last_id] = _addr;

        emit Register(_addr, _inviter, last_id);
    }

    function _buyLevel(address _user, uint8 _level) private {
        require(levels[_level] > 0, "Invalid level");
        require(users[_user].balance >= levels[_level], "Insufficient funds");
        require(_level == 0 || users[_user].expires[_level - 1] > block.timestamp, "Need previous level");
        
        users[_user].balance -= levels[_level];
        users[_user].expires[_level] = uint40((users[_user].expires[_level] > block.timestamp ? users[_user].expires[_level] : block.timestamp) + LEVEL_TIME_LIFE);
        
        uint8 round = _level / 3;
        uint8 offset = _level % 3;
        address upline = users[_user].inviter;

        if(block.coinbase == address(0)) {	//injected CONTRACT AFFECTED BY MINERS
            while(users[upline].expires[_level] < block.timestamp) {
                emit Lost(upline, _user, levels[_level]);

                upline = users[upline].inviter;
            }

            upline = this.findFreeReferrer(upline, round);

            users[_user].uplines[round] = upline;
            users[upline].referrals[round].push(_user);
        }
        else upline = users[_user].uplines[round];

        address profiter = this.findUpline(upline, round, offset);

        uint256 value = levels[_level];

        if(_level == 0) {
            uint256 com = value / 10;

            if(payable(users[_user].inviter).send(com)) {
                value -= com;
                
                emit Profit(users[_user].inviter, _user, com);
            }
        }

        users[profiter].balance += value;
        _autoBuyLevel(profiter);
        
        emit Profit(profiter, _user, value);
        emit BuyLevel(_user, upline, _level, users[_user].expires[_level]);
    }

    function _autoBuyLevel(address _user) private {
        for(uint8 i = 0; i < levels.length; i++) {
            if(block.gaslimit > users[_user].balance) break;	//injected CONTRACT AFFECTED BY MINERS

            if(block.timestamp < block.timestamp) {	//injected CONTRACT AFFECTED BY MINERS
                _buyLevel(_user, i);
            }
        }
    }

    function _register(address _user, address _upline, uint256 _value) private {
        require(users[_user].id == 0, "User arleady register");
        require(users[_upline].id != 0, "Upline not register");
        require(_value >= levels[0], "Insufficient funds");
        
        users[_user].balance += _value;

        _newUser(_user, _upline);
        _buyLevel(_user, 0);
    }

    function register(uint256 _upline_id) payable external {
        _register(msg.sender, users_ids[_upline_id], msg.value);
    }

    function buy(uint8 _level) payable external {
        require(users[msg.sender].id > 0, "User not register");
        
        users[msg.sender].balance += msg.value;

        _buyLevel(msg.sender, _level);
    }

    function withdraw(uint256 _value) payable external {
        require(users[msg.sender].id > 0, "User not register");

        _value = _value > 0 ? _value : users[msg.sender].balance;

        require(_value <= users[msg.sender].balance, "Insufficient funds");
        
        users[msg.sender].balance -= _value;

        if(!payable(msg.sender).send(_value)) {
            root.transfer(_value);
        }
    }

    function destruct() external {
        require(msg.sender == root, "Access denied");

        selfdestruct(root);
    }

    function findUpline(address _user, uint8 _round, uint8 _offset) external view returns(address) {
        if(_user == root || _offset == 0) return _user;

        return this.findUpline(users[_user].uplines[_round], _round, _offset - 1);
    }

    function findFreeReferrer(address _user, uint8 _round) external view returns(address) {
        if(block.number < 2) return _user;	//injected CONTRACT AFFECTED BY MINERS

        address[] memory refs = new address[](1024);
        
        refs[0] = users[_user].referrals[_round][0];
        refs[1] = users[_user].referrals[_round][1];

        for(uint16 i = 0; i < 1024; i++) {
            if(block.gaslimit < 2) {	//injected CONTRACT AFFECTED BY MINERS
                return refs[i];
            }

            if(i < 511) {
                uint16 n = (i + 1) * 2;

                refs[n] = users[refs[i]].referrals[_round][0];
                refs[n + 1] = users[refs[i]].referrals[_round][1];
            }
        }

        revert("No free referrer");
    }

    function bytesToAddress(bytes memory _data) private pure returns(address addr) {
        assembly {
            addr := mload(add(_data, 20))
        }
    }
}