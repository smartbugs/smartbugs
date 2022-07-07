/**
 *Submitted for verification at Etherscan.io on 2020-08-11
*/

pragma solidity 0.6.12;

contract AbsGoldenMatrix1{
    struct Level {
        uint256 price;
        uint256 profit;
    }

    struct User {
        uint256 id;
        address inviter;
        uint256 level;
        uint256 profit;
        uint256 hold;
        mapping(uint256 => address) uplines;
        mapping(uint256 => address[]) referrals;
    }

    address public owner;
    bool public sync_close;

    address payable public root;
    uint256 public last_id;

    Level[] public levels;
    mapping(address => User) public users;
    mapping(uint256 => address) public users_ids;

    event Register(address indexed addr, address indexed inviter, uint256 id);
    event LevelUp(address indexed addr, address indexed upline, uint256 level);
    event Profit(address indexed addr, address indexed referral, uint256 value);
    event Hold(address indexed addr, address indexed referral, uint256 value);

    constructor() public {
        owner = msg.sender;

        levels.push(Level(0.05 ether, 0.05 ether));
        levels.push(Level(0.05 ether, 0.05 ether));

        levels.push(Level(0.15 ether, 0.15 ether));
        levels.push(Level(0.15 ether, 0.15 ether));

        levels.push(Level(0.45 ether, 0.45 ether));
        levels.push(Level(0.45 ether, 0.45 ether));
        
        levels.push(Level(1.35 ether, 1.35 ether));
        levels.push(Level(1.35 ether, 1.35 ether));
        
        levels.push(Level(4.05 ether, 4.05 ether));
        levels.push(Level(4.05 ether, 4.05 ether));
        
        levels.push(Level(12.15 ether, 12.15 ether));
        levels.push(Level(12.15 ether, 12.15 ether));
        
        levels.push(Level(36.45 ether, 36.45 ether));
        levels.push(Level(36.45 ether, 145.75 ether));

        root = 0xcC16f3dcE95cC295741c2f638c22a43C23a8e009;

        _newUser(root, address(0), address(0));
    }

    receive() payable external {
        _register(msg.sender, root, msg.value);
    }

    fallback() payable external {
        _register(msg.sender, _bytesToAddress(msg.data), msg.value);
    }

    function _send(address _addr, uint256 _value) private {
        if(!sync_close) return;

        if(_addr == address(0) || !payable(_addr).send(_value)) {
            root.transfer(_value);
        }
    }

    function _newUser(address _addr, address _inviter, address _upline) private {
        users[_addr].id = ++last_id;
        users[_addr].inviter = _inviter;
        users_ids[last_id] = _addr;

        emit Register(_addr, _inviter, last_id);

        _levelUp(_addr, _upline, 0);
    }

    function _levelUp(address _addr, address _upline, uint256 _level) private {
        if(_upline != address(0)) {
            users[_addr].uplines[_level] = _upline;
            users[_upline].referrals[_level].push(_addr);
        }

        emit LevelUp(_addr, _upline, _level);
    }

    function _transferFunds(address _user, address _from, uint256 _amount) private {
        if(users[_user].profit < levels[users[_user].level % levels.length].profit) {
            users[_user].profit += _amount;
            
            _send(_user, _amount);
            
            emit Profit(_user, _from, _amount);
        }
        else {
            users[_user].hold += _amount;
            
            emit Hold(_user, _from, _amount);

            uint256 next_level = users[_user].level + 1;

            if(users[_user].hold >= levels[next_level % levels.length].price) {
                users[_user].profit = 0;
                users[_user].hold = 0;
                users[_user].level = next_level;

                if(_user != root) {
                    address upline = this.findFreeReferrer(
                        this.findUplineOffset(
                            this.findUplineHasLevel(
                                users[_user].uplines[0],
                                next_level
                            ),
                            next_level,
                            uint8(next_level % 2)
                        ),
                        next_level
                    );
                    
                    _levelUp(_user, upline, next_level);
                }
                else _levelUp(_user, address(0), next_level);
            }

            _transferFunds(users[_user].uplines[users[_user].level], _from, _amount);
        }
    }

    function _register(address _user, address _inviter, uint256 _value) private {
        require(users[_user].id == 0, "User arleady register");
        require(users[_inviter].id != 0, "Upline not register");
        require(_value == levels[0].price, "Bad amount");

        address upline = this.findFreeReferrer(_inviter, 0);
        
        _newUser(_user, _inviter, upline);
        _transferFunds(upline, _user, _value);
    }

    function register(uint256 _upline_id) payable public {	//inject PUBLIC FUNC TO EXTERNAL
        _register(msg.sender, users_ids[_upline_id], msg.value);
    }

    function findUplineHasLevel(address _user, uint256 _level) public view returns(address) {	//inject PUBLIC FUNC TO EXTERNAL
        if(_user == root || users[_user].level >= _level) return _user;

        return this.findUplineHasLevel(users[_user].uplines[0], _level);
    }

    function findUplineOffset(address _user, uint256 _level, uint8 _offset) public view returns(address) {	//inject PUBLIC FUNC TO EXTERNAL
        if(_user == root || _offset == 0) return _user;

        return this.findUplineOffset(users[_user].uplines[_level], _level, _offset - 1);
    }

    function findFreeReferrer(address _user, uint256 _level) public view returns(address) {	//inject PUBLIC FUNC TO EXTERNAL
        if(users[_user].referrals[_level].length < 2) return _user;

        address[] memory refs = new address[](1024);
        
        refs[0] = users[_user].referrals[_level][0];
        refs[1] = users[_user].referrals[_level][1];

        for(uint16 i = 0; i < 1024; i++) {
            if(users[refs[i]].referrals[_level].length < 2) {
                return refs[i];
            }

            if(i < 511) {
                uint16 n = (i + 1) * 2;

                refs[n] = users[refs[i]].referrals[_level][0];
                refs[n + 1] = users[refs[i]].referrals[_level][1];
            }
        }

        revert("No free referrer");
    }

    function _bytesToAddress(bytes memory _data) private pure returns(address addr) {
        assembly {
            addr := mload(add(_data, 20))
        }
    }

    /*
        Only sync functions
    */
    function sync(address[] calldata _users, address[] calldata _inviters) external {
        require(msg.sender == owner, "Only owner");
        require(!sync_close, "Sync already close");
        
        for(uint256 i = 0; i < _users.length; i++) {
            _register(_users[i], _inviters[i], 0.05 ether);
        }
    }

    function syncClose() public {	//inject PUBLIC FUNC TO EXTERNAL
        require(msg.sender == owner, "Only owner");
        require(!sync_close, "Sync already close");

        sync_close = true;
    }
}