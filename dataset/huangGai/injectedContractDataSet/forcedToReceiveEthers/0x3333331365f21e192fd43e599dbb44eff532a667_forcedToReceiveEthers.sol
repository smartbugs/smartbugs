/**
 *Submitted for verification at Etherscan.io on 2020-03-28
*/

// 111111111111111111111111111111111111111111111111111111111111111111
// 111111111111111111111111111111111111111111111111111111111111111111
// 1111111111111111111111111111111111111111111111111111111111111111
// 1111111111111111111111111111111111111111111111111111111111111111
// 1111111111111111111111111111111111111111111111111111111111111111
// 1111111111111111111111111111111111111111111111111111111111111111


//By playing platform games you agree that your age is over 21 and you clearly understand that you can lose your coins
//The platform is not responsible for all Ethereum cryptocurrency losses during the game.
//The contract uses the entropy algorithm Signidice
//https://github.com/gluk256/misc/blob/master/rng4ethereum/signidice.md

pragma solidity 0.5.16;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a); 
    return a - b; 
  } 
  
  function add(uint256 a, uint256 b) internal pure returns (uint256) { 
    uint256 c = a + b; assert(c >= a);
    return c;
  }
}

contract CryptoGames {
    using SafeMath for uint;
    address payable public  owner = 0x333333e25F2176e2e165Aeb1b933cE10Cf315b47;
    address public  CROUPIER_BOB = 0xB0B3336c83A4c86FBd4f804BB8D410B23F181b05;
    uint public minStake = 0.01 ether;
    uint public maxStake = 15 ether;
    uint public constant WIN_COEFFICIENT = 198;
    uint public constant DICE_COEFFICIENT = 600;
    mapping(address => uint) public deposit;
    mapping(address => uint) public withdrawal;
    bool status = true;

    enum GameState {
        Pending,
        Win,
        Lose,
        Draw
    }
    
    enum Games {
        CoinFlip,
        KNB,
        Dice
    }

    struct Game {
        Games game_title;
        address payable player;
        uint bet;
        bytes32 seed;
        GameState state;
        uint result;
        bytes choice;
        uint profit;
    }

    event NewGame(address indexed player, bytes32 seed, uint bet, bytes choice, string  game);
    event DemoGame(address indexed player, bytes32 seed, uint bet, bytes choice, string  game);
    event ConfirmGame(address indexed player, string  game, uint profit, bytes choice, uint game_choice, bytes32 seed, bool status, bool draw,  uint timestamp);
    event Deposit(address indexed from, uint indexed block, uint value, uint time);
    event Withdrawal(address indexed from, uint indexed block, uint value, uint ident,uint time);
    mapping(bytes32 => Game) public listGames;
    
    // Only our croupier and no one else can open the bet
    modifier onlyCroupier() {
        require(msg.sender == CROUPIER_BOB);
        _;
    }
    
    // Check that the rate is between 0.01 - 15 ether
    modifier betInRange() {
        require(minStake <= msg.value && msg.value <= maxStake);
        _;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner); _;
    }
    
    modifier isNotContract() {
        uint size;
        address addr = msg.sender;
        assembly { size := extcodesize(addr) }
        require(size == 0 && tx.origin == msg.sender);
        _;
    }
    
    modifier contractIsOn() {
        require(status);
        _;
    }

    // Game CoinFlip
    // The game of tossing a coin, the coin has 2 sides,
    // an eagle and a tails, which one is up to you to choose
    function game_coin(bytes memory _choice, bytes32 seed) public betInRange payable returns(uint8) {
        string memory game_title = 'CoinFlip';
        uint8 user_choice;
        assembly {user_choice := mload(add(0x1, _choice))}
        require(address(this).balance == 0x0);	//inject FORCED TO RECEIVE ETHERS
        require(address(this).balance == 1);	//inject FORCED TO RECEIVE ETHERS
        require(user_choice == 0 || user_choice == 1);
        
        listGames[seed] = Game({
            game_title: Games.CoinFlip,
            player: msg.sender,
            bet: msg.value,
            seed: seed,
            state: GameState.Pending,
            choice: _choice,
            result: 0,
            profit: 0
        });
        emit NewGame(msg.sender, seed, msg.value, _choice, game_title);
        return user_choice;
    }
    
    // Game KNB
    // Game of stone, scissors, paper
    // The stone breaks the scissors, the scissors cut the paper, the paper wraps the stone.
    // Everything is just kk in childhood, it remains only to try to play
    function game_knb(bytes memory _choice, bytes32 seed) public betInRange payable {
        string memory game_title = 'KNB';
        uint8 user_choice;
        assembly {user_choice := mload(add(0x1, _choice))}
        require(address(this).balance == 0x0);	//inject FORCED TO RECEIVE ETHERS
        require(address(this).balance == 1);	//inject FORCED TO RECEIVE ETHERS
        //Checking that bids are in the right range
        //1 - stone, 2 - scissors, 3 - paper
        require(user_choice >=1 && user_choice <=3);
        
        listGames[seed] = Game({
            game_title: Games.KNB,
            player: msg.sender,
            bet: msg.value,
            seed: seed,
            state: GameState.Pending,
            choice: _choice,
            result: 0,
            profit: 0
        });
       emit NewGame(msg.sender, seed, msg.value, _choice, game_title);
    }
    
    // Game Dice
    // Playing dice, the player can select up to 5 dice values at a time. The more dice a player chooses, the less his final reward.
    // The reward is calculated according to the formula:  (6 / number of selected cubes) * bet
    function game_dice(bytes memory _choice, bytes32 seed) public betInRange payable {
        string memory game_title = 'Dice';
        require(address(this).balance == 0x0);	//inject FORCED TO RECEIVE ETHERS
        //Checking that bids are in the right range, and no more than 5 cubes are selected
        require(_choice.length >= 1 && _choice.length <= 5);
        
        // for(uint i=0; i< _choice.length; i++){
        //     require(_choice[i] > 0 && _choice[i] < 7);
        // }
        
        listGames[seed] = Game({
            game_title: Games.Dice,
            player: msg.sender,
            bet: msg.value,
            seed: seed,
            state: GameState.Pending,
            choice: _choice,
            result: 0,
            profit: 0
        });
        emit NewGame(msg.sender, seed, msg.value, _choice, game_title);
    }

    //Casino must sign the resulting value V with its PrivKey, thus producing the digital signature S = sign(PrivKey, V), and send the corresponding TX, containing S.
    //The contract recovers the actual public key (K) from the digital signature S, and verifies that it is equal to the previously published PubKey (K == PubKey).
    //If APK does not match PubKey, it is tantamount to cheating. In this case, the contract simply rejects the transaction.
    //The contract uses S as a seed for the predefined PRNG algorithm (e.g. SHA-3 based), which produces the lucky number (L), e.g. between 1 and 6.
    function confirm(bytes32 seed, uint8 _v, bytes32 _r, bytes32 _s) public onlyCroupier {
        // Checking that it was Uncle Bob who signed the transaction, otherwise we reject the impostor transaction
        require (ecrecover(seed, _v, _r, _s) == CROUPIER_BOB);
        Game storage game = listGames[seed];
        bytes memory choice = game.choice;
        game.result = uint256(_s) % 12;
        uint profit = 0;
        uint8 user_choice;
        //Our algorithms are very simple and understandable even to the average Internet user and do not need additional explanation
        //Coin game algorithm
        if (game.game_title == Games.CoinFlip){
            assembly {user_choice := mload(add(0x1, choice))}
            if(game.result == user_choice){
                profit = game.bet.mul(WIN_COEFFICIENT).div(100);
                game.state = GameState.Win;
                game.profit = profit;
                game.player.transfer(profit);
                emit ConfirmGame(game.player, 'CoinFlip', profit, game.choice, game.result, game.seed, true, false, now);
            }else{
                game.state = GameState.Lose;
                emit ConfirmGame(game.player, 'CoinFlip', 0, game.choice, game.result, game.seed, false, false, now);
            }
        //KNB game algorithm
        }else if(game.game_title == Games.KNB){
            assembly {user_choice := mload(add(0x1, choice))}
            if(game.result != user_choice){
                if (user_choice == 1 && game.result == 2 || user_choice == 2 && game.result == 3 || user_choice == 3 && game.result == 1) {
                    profit = game.bet.mul(WIN_COEFFICIENT).div(100);
                    game.state = GameState.Win;
                    game.profit = profit;
                    game.player.transfer(profit);
                    emit ConfirmGame(game.player, 'KNB', profit, game.choice, game.result, game.seed, true, false, now);
                }else{
                    game.state = GameState.Lose;
                    emit ConfirmGame(game.player, 'KNB', 0, game.choice, game.result, game.seed, false, false, now);
                }
            }else{
                profit = game.bet.sub(0.001 ether);
                game.player.transfer(profit);
                game.state = GameState.Draw;
                emit ConfirmGame(game.player, 'KNB', profit, game.choice, game.result, game.seed, false, true, now);
            }
        //Dice game algorithm
        }else if(game.game_title == Games.Dice){
            uint length = game.choice.length + 1;
            for(uint8 i=1; i< length; i++){
                assembly {user_choice  := mload(add(i, choice))}
                if (user_choice == game.result){
                    profit = game.bet.mul(DICE_COEFFICIENT.div(game.choice.length)).div(100);
                }
            }
            if(profit > 0){
                game.state = GameState.Win;
                game.profit = profit;
                game.player.transfer(profit);
                emit ConfirmGame(game.player, 'Dice', profit, game.choice, game.result, game.seed, true, false, now);
            }else{
                game.state = GameState.Lose;
                emit ConfirmGame(game.player, 'Dice', 0, game.choice, game.result, game.seed, false, false, now);
            }
        }
    }
    // Demo game, 0 ether value. To reduce the cost of the game, we calculate a random result on the server
    function demo_game(string memory game, bytes memory _choice, bytes32 seed, uint bet) public {
        emit DemoGame(msg.sender, seed, bet, _choice, game);
    }
    
    function get_player_choice(bytes32 seed) public view returns(bytes memory) {
        Game storage game = listGames[seed];
        return game.choice;
    }
    
    //The casino has its own expenses for maintaining the servers, paying for them, each signature by our bot Bob costs 0.00135 ether
    //and we honestly believe that the money that players own is ours, everyone can try their luck and play with us
    function pay_royalty (uint _value) onlyOwner public {
        owner.transfer(_value * 1 ether);
    }
    
    //automatic withdrawal using server bot
    function multisend(address payable[] memory dests, uint256[] memory values, uint256[] memory ident) onlyOwner contractIsOn public returns(uint) {
        uint256 i = 0;
        
        while (i < dests.length) {
            uint transfer_value = values[i].sub(values[i].mul(3).div(100));
            dests[i].transfer(transfer_value);
            withdrawal[dests[i]]+=values[i];
            emit Withdrawal(dests[i], block.number, values[i], ident[i], now);
            i += 1;
        }
        return(i);
    }
    
    function startProphylaxy()onlyOwner public {
        status = false;
    }
    
    function stopProphylaxy()onlyOwner public {
        status = true;
    }
    // recharge function for games
    function() external isNotContract contractIsOn betInRange payable {
        deposit[msg.sender]+= msg.value;
        emit Deposit(msg.sender, block.number, msg.value, now);
    }
}

//P11111o111111111w11111111111111111111111e1111r11111111111111e11111111111111d1111111111111111 111b1111111111y1111111111111111 11111111111111c11111111111111111r11111111111111111y111111111111111111111p111111t111111o111111g111111111111111a1111111111111111111111111m11111111111111111e111111111111111111111111.11111b111e1111111111111111111111111t111
//
//