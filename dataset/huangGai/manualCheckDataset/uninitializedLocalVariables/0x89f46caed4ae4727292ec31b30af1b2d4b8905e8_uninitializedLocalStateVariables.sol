pragma solidity 0.5.2;

/*
"Crypto Casino 333" (c) v.1.0
Copyright (c) 2019 by -= 333ETH Team =-

THIS IS TEST CONTRACT!!! DO NOT PLACE BET!!!

* Web - https://333eth.io
* Telegram_channel - https://t.me/Ethereum333
* EN  Telegram_chat: https://t.me/Ethereum333_chat_en
* RU  Telegram_chat: https://t.me/Ethereum333_chat_ru
*

... Fortes fortuna juvat ...

The innovative totally fair gambling platform -
A unique symbiosis of the classic online casino system and the revolutionary possibilities of the blockchain, using the power of the Ethereum smart contract for 100% transparency.

"Crypto Casino 333" is the quintessence of fair winning opportunities for any participant on equal terms. The system and technologies are transparent due to the blockchain, which is really capable of meeting all your expectations.

... Alea jacta est ...

We start  project without ICO & provide the following guarantees:

- ABSOLUTE TRANSPARENCY -
The random number generator is based on an Ethereum Smart Contract which is completely public. This means that everyone can see everything that is occurring inside the servers of the casino.

- NO HUMAN FACTOR -
All transactions are processed automatically according to the smart contract algorithms.

- TOTAL PROTECTION & PRIVACY -
All transactions are processed anonymously inside smart contract.


- TOTALLY FINANCIAL PLEASURE -
Only 1% casino commission, 99% goes to payout wins. Instant automatic withdrawal of funds directly from the smart contract.

Copyright (c) 2019 by -= 333ETH Team =-
"Games People are playing"


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/



library PaymentLib {
  struct Payment {
    address payable beneficiary;
    uint amount;
    bytes32 message;
  }

  event LogPayment(address indexed beneficiary, uint amount, bytes32 indexed message);
  event LogFailedPayment(address indexed beneficiary, uint amount, bytes32 indexed message);

  function send(Payment memory p) internal {
    if (p.beneficiary.send(p.amount)) {
      emit LogPayment(p.beneficiary, p.amount, p.message);
    } else {
      emit LogFailedPayment(p.beneficiary, p.amount, p.message);
    }
  }
}



library BytesLib {


  // index returns the index of the first instance of sub in s, or -1 if sub is not present in s. 
  function index(bytes memory b, bytes memory subb, uint start) internal pure returns(int) {
    uint lensubb ;	//inject UNINIT LOCAL/STATE VAR

    
    uint hashsubb;
    uint ptrb;
    assembly {
      hashsubb := keccak256(add(subb, 0x20), lensubb)
      ptrb := add(b, 0x20)
    }
    
    for (uint lenb ; start < lenb; start++) {	//inject UNINIT LOCAL/STATE VAR

      if (start+lensubb > lenb) {
        return -1;
      }
      bool found;
      assembly {
        found := eq(keccak256(add(ptrb, start), lensubb), hashsubb)
      }
      if (found) {
        return int(start);
      }
    }
    return -1;
    
    /* assembly
    require(subb.length < 32,"unsuppotyed bytes len");
    
    bool found;
    assembly {
      let lenb := mload(b) 
      let lensubb := mload(subb)  
      let subbHash := keccak256(add(subb, 0x20), lensubb)
      let ptrb := add(b, 0x20)
      for 
        {} 
        and(and(lt(start, lenb), eq(found, 0)), lt(add(start, lensubb), add(lenb,1))) 
        { start := add(start, 1) }
      {
        found := eq(keccak256(add(ptrb, start), lensubb), subbHash)
      }

    }
    if (found) {
      return int(start)-1;
    }
    return -1;
    */

    
    // brute force solidity
    // for ((uint i, bool found) = (start, true); i < b.length; (i++, found = true)) {
    //   for (uint j = 0; j < sub.length; j++) {
    //     if (i+j > b.length-1) {
    //       found = false;
    //       break;
    //     }
    //     if (b[i+j] != sub[j]) {
    //       found = false;
    //       break;
    //     }
    //   }
    //   if (found) {
    //     return int(i);
    //   }
    // }
    // return -1;
  }  
  
  // index returns the index of the first instance of sub in s, or -1 if sub is not present in s. 
  function index(bytes memory b, bytes memory sub) internal pure returns(int) {
    return index(b, sub, 0);
  }

  function index(bytes memory b, byte sub, uint start) internal pure returns(int) {
    for (uint len ; start < len; start++) {	//inject UNINIT LOCAL/STATE VAR

      if (b[start] == sub) {
        return int(start);
      }
    }
    return -1;
  }

  function index(bytes memory b, byte sub) internal pure returns(int) {
    return index(b, sub, 0);
  }

  function count(bytes memory b, bytes memory sub) internal pure returns(uint times) {
    int i ;	//inject UNINIT LOCAL/STATE VAR

    while (i != -1) {
      times++;
      i = index(b, sub, uint(i)+sub.length);
    }
  }
  
  function equals(bytes memory b, bytes memory a) internal pure returns(bool equal) {
    if (b.length != a.length) {
      return false;
    }
    
    uint len ;	//inject UNINIT LOCAL/STATE VAR

    
    assembly {
      equal := eq(keccak256(add(b, 0x20), len), keccak256(add(a, 0x20), len))
    }  
  }
  
  function copy(bytes memory b) internal pure returns(bytes memory) {
    return abi.encodePacked(b);
  }
  
  function slice(bytes memory b, uint start, uint end) internal pure returns(bytes memory r) {
    if (start > end) {
      return r;
    }
    if (end > b.length-1) {
      end = b.length-1;
    }
    r = new bytes(end-start+1);
    
    uint j;
    uint i ;	//inject UNINIT LOCAL/STATE VAR

    for (; i <= end; (i++, j++)) {
      r[j] = b[i];
    }
  }
  
  function append(bytes memory b, bytes memory a) internal pure returns(bytes memory r) {
    return abi.encodePacked(b, a);
  }
  
  
  function replace(bytes memory b, bytes memory oldb, bytes memory newb) internal pure returns(bytes memory r) {
    if (equals(oldb, newb)) {
      return copy(b);
    }
    
    uint n ;	//inject UNINIT LOCAL/STATE VAR

    if (n == 0) {
      return copy(b);
    }
    
    uint start;
    for (uint i; i < n; i++) {
      uint j ;	//inject UNINIT LOCAL/STATE VAR

      j += uint(index(slice(b, start, b.length-1), oldb));  
      if (j!=0) {
        r = append(r, slice(b, start, j-1));
      }
      
      r = append(r, newb);
      start = j + oldb.length;
    }
    if (r.length != b.length+n*(newb.length-oldb.length)) {
      r = append(r, slice(b, start, b.length-1));
    }
  }

  function fillPattern(bytes memory b, bytes memory pattern, byte newb) internal pure returns (uint n) {
    uint start;
    while (true) {
      int i ;	//inject UNINIT LOCAL/STATE VAR

      if (i < 0) {
        return n;
      }
      uint len ;	//inject UNINIT LOCAL/STATE VAR

      for (uint k ; k < len; k++) {	//inject UNINIT LOCAL/STATE VAR

        b[uint(i)+k] = newb;
      }
      start = uint(i)+len;
      n++;
    }
  }
}





library NumberLib {
  struct Number {
    uint num;
    uint den;
  }

  function muluint(Number memory a, uint b) internal pure returns (uint) {
    return b * a.num / a.den;
  }

  function mmul(Number memory a, uint b) internal pure returns(Number memory) {
    a.num = a.num * b;
    return a;
  }

  function maddm(Number memory a, Number memory b) internal pure returns(Number memory) {
    a.num = a.num * b.den + b.num * a.den;
    a.den = a.den * b.den;
    return a;
  }

  function madds(Number memory a, Number storage b) internal view returns(Number memory) {
    a.num = a.num * b.den + b.num * a.den;
    a.den = a.den * b.den;
    return a;
  }

  // function mul(Number memory a, uint b) internal pure returns (Number memory c) {
  //   c.num = a.num * b;
  //   c.den = a.den;
  // }

  // function add(Number memory a, Number memory b) internal pure returns (Number memory c) {
  //   c.num = a.num * b.den + b.num * a.den;
  //   c.den = a.den * b.den;
  // }

//   function div(Number storage p, uint a) internal view returns (uint) {
//     return a/p.num*p.den;
//   }

//   function sub(Number storage p, uint a) internal view returns (uint) {
//     uint b = mul(p, a);
//     if (b >= a) return 0;
//     return a - b;
//   }
}

library Rnd {
  byte internal constant NONCE_SEP = "\x3a"; // ':'

  function uintn(bytes32 hostSeed, bytes32 clientSeed, uint n) internal pure returns(uint) {
    return uint(keccak256(abi.encodePacked(hostSeed, clientSeed))) % n;
  }

  function uintn(bytes32 hostSeed, bytes32 clientSeed, uint n, bytes memory nonce) internal pure returns(uint) {
    return uint(keccak256(abi.encodePacked(hostSeed, clientSeed, NONCE_SEP, nonce))) % n;
  }
}



library ProtLib {
  function checkBlockHash(uint blockNumber, bytes32 blockHash) internal view {
    require(block.number > blockNumber, "protection lib: current block must be great then block number");
    require(blockhash(blockNumber) != bytes32(0), "protection lib: blockhash can't be queried by EVM");
    require(blockhash(blockNumber) == blockHash, "protection lib: invalid block hash");
  }

  function checkSigner(address signer, bytes32 message, uint8 v, bytes32 r, bytes32 s) internal pure {
    require(signer == ecrecover(message, v, r, s), "protection lib: ECDSA signature is not valid");
  }

  function checkSigner(address signer, uint expirationBlock, bytes32 message, uint8 v, bytes32 r, bytes32 s) internal view {
    require(block.number <= expirationBlock, "protection lib: signature has expired");
    checkSigner(signer, keccak256(abi.encodePacked(message, expirationBlock)), v, r, s);
    // require(
    //   signer == ecrecover(keccak256(abi.encodePacked(message, expirationBlock)), v, r, s), 
    //   "protection lib: ECDSA signature is not valid"
    // );
  }
}


/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c / a == b);

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR


        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c >= a);

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}



library SlotGameLib {
  using BytesLib for bytes;
  using SafeMath for uint;
  using SafeMath for uint128;
  using NumberLib for NumberLib.Number;

  struct Bet {
    uint amount; 
    uint40 blockNumber; // 40
    address payable gambler; // 160
    bool exist; // 1
  }

  function remove(Bet storage bet) internal {
    delete bet.amount;
    delete bet.blockNumber;
    delete bet.gambler;
  }

  struct Combination {
    bytes symbols;
    NumberLib.Number multiplier;
  }

  struct SpecialCombination {
    byte symbol;
    NumberLib.Number multiplier;
    uint[] indexes; // not uint8, optimize spin and hasIn
  }

  function hasIn(SpecialCombination storage sc, bytes memory symbols) internal view returns (bool) {
    uint len ;	//inject UNINIT LOCAL/STATE VAR

    byte symbol ;	//inject UNINIT LOCAL/STATE VAR

    for (uint i ; i < len; i++) {	//inject UNINIT LOCAL/STATE VAR

      if (symbols[sc.indexes[i]] != symbol) {
        return false;
      }
    }
    return true;
  }

  // the symbol that don't use in reels
  byte private constant UNUSED_SYMBOL = "\xff"; // 255
  uint internal constant REELS_LEN = 9;
  uint private constant BIG_COMBINATION_MIN_LEN = 8;
  bytes32 private constant PAYMENT_LOG_MSG = "slot";
  bytes32 private constant REFUND_LOG_MSG = "slot.refund";
  uint private constant HANDLE_BET_COST = 0.001 ether;
  uint private constant HOUSE_EDGE_PERCENT = 1;
  uint private constant JACKPOT_PERCENT = 1;
  uint private constant MIN_WIN_PERCENT = 30;
  uint private constant MIN_BET_AMOUNT = 10 + (HANDLE_BET_COST * 100 / MIN_WIN_PERCENT * 100) / (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT);
  
  function MinBetAmount() internal pure returns(uint) {
    return MIN_BET_AMOUNT;
  }

  
  struct Game {
    address secretSigner;
    uint128 lockedInBets;
    uint128 jackpot;
    uint maxBetAmount;
    uint minBetAmount;

    bytes[REELS_LEN] reels;
    // pay table array with prioritet for 0-elem to N-elem, where 0 - MAX prior and N - LOW prior
    Combination[] payTable;
    SpecialCombination[] specialPayTable;

    mapping(bytes32 => Bet) bets;
  }

  event LogSlotNewBet(
    bytes32 indexed hostSeedHash,
    address indexed gambler,
    uint amount,
    address indexed referrer
  );

  event LogSlotHandleBet(
    bytes32 indexed hostSeedHash,
    address indexed gambler,
    bytes32 hostSeed,
    bytes32 clientSeed,
    bytes symbols,
    uint multiplierNum,
    uint multiplierDen,
    uint amount,
    uint winnings
  );

  event LogSlotRefundBet(
    bytes32 indexed hostSeedHash,
    address indexed gambler, 
    uint amount
  );

  function setReel(Game storage game, uint n, bytes memory symbols) internal {
    require(REELS_LEN > n, "slot game: invalid reel number");
    require(symbols.length > 0, "slot game: invalid reel`s symbols length");
    require(symbols.index(UNUSED_SYMBOL) == -1, "slot game: reel`s symbols contains invalid symbol");
    game.reels[n] = symbols;
  }

  function setPayLine(Game storage game, uint n, Combination memory comb) internal {
    require(n <= game.payTable.length, "slot game: invalid pay line number");
    require(comb.symbols.index(UNUSED_SYMBOL) == -1, "slot game: combination symbols contains invalid symbol");

    if (n == game.payTable.length && comb.symbols.length > 0) {
      game.payTable.push(comb);
      return;
    } 
    
    if (n == game.payTable.length-1 && comb.symbols.length == 0) {
      game.payTable.pop();
      return;
    }

    require(
      0 < comb.symbols.length && comb.symbols.length <= REELS_LEN, 
      "slot game: invalid combination`s symbols length"
    );
    game.payTable[n] = comb;
  }

  function setSpecialPayLine(Game storage game, uint n, SpecialCombination memory scomb) internal {
    require(game.specialPayTable.length >= n, "slot game: invalid pay line number");
    require(scomb.symbol != UNUSED_SYMBOL, "slot game: invalid special combination`s symbol");

    if (n == game.specialPayTable.length && scomb.indexes.length > 0) {
      game.specialPayTable.push(scomb);
      return;
    } 
    
    if (n == game.specialPayTable.length-1 && scomb.indexes.length == 0) {
      game.specialPayTable.pop();
      return;
    }

    require(
      0 < scomb.indexes.length && scomb.indexes.length <= REELS_LEN, 
      "slot game: invalid special combination`s indexes length"
    );
    game.specialPayTable[n] = scomb;
  }

  function setMinMaxBetAmount(Game storage game, uint minBetAmount, uint maxBetAmount) internal {
    require(minBetAmount >= MIN_BET_AMOUNT, "slot game: invalid min of bet amount");
    require(minBetAmount <= maxBetAmount, "slot game: invalid [min, max] range of bet amount");
    game.minBetAmount = minBetAmount;
    game.maxBetAmount = maxBetAmount;
  }

  function placeBet(
    Game storage game,
    address referrer,
    uint sigExpirationBlock,
    bytes32 hostSeedHash,
    uint8 v, 
    bytes32 r, 
    bytes32 s
  ) 
    internal
  {
    ProtLib.checkSigner(game.secretSigner, sigExpirationBlock, hostSeedHash, v, r, s);

    Bet storage bet = game.bets[hostSeedHash];
    require(!bet.exist, "slot game: bet already exist");
    require(game.minBetAmount <= msg.value && msg.value <= game.maxBetAmount, "slot game: invalid bet amount");
    
    bet.amount = msg.value;
    bet.blockNumber = uint40(block.number);
    bet.gambler = msg.sender;
    bet.exist = true;
    
    game.lockedInBets += uint128(msg.value);
    game.jackpot += uint128(msg.value * JACKPOT_PERCENT / 100);

    emit LogSlotNewBet(
      hostSeedHash, 
      msg.sender, 
      msg.value,
      referrer
    );
  }


  // function placeBet(
  //   Game storage game,
  //   address referrer,
  //   bytes32 hostSeedHash,
  //   uint8 v, 
  //   bytes32 r, 
  //   bytes32 s
  // ) 
  //   internal
  // {
  //   ProtLib.checkSigner(game.secretSigner, hostSeedHash, v, r, s);

  //   Bet storage bet = game.bets[hostSeedHash];
  //   require(!bet.exist, "slot game: bet already exist");
  //   require(game.minBetAmount <= msg.value && msg.value <= game.maxBetAmount, "slot game: invalid bet amount");
    
  //   bet.amount = msg.value;
  //   bet.blockNumber = uint40(block.number);
  //   bet.gambler = msg.sender;
  //   bet.exist = true;
    
  //   game.lockedInBets += uint128(msg.value);
  //   game.jackpot += uint128(msg.value * JACKPOT_PERCENT / 100);

  //   emit LogSlotNewBet(
  //     hostSeedHash, 
  //     msg.sender, 
  //     msg.value,
  //     referrer
  //   );
  // }

  function handleBet(
    Game storage game,
    bytes32 hostSeed,
    bytes32 clientSeed
  ) 
    internal 
    returns(
      PaymentLib.Payment memory p
    ) 
  {
    bytes32 hostSeedHash ;	//inject UNINIT LOCAL/STATE VAR

    Bet storage bet = game.bets[hostSeedHash];
    uint betAmount ;	//inject UNINIT LOCAL/STATE VAR

    require(bet.exist, "slot game: bet does not exist");
    require(betAmount > 0, "slot game: bet already handled");
    ProtLib.checkBlockHash(bet.blockNumber, clientSeed);
    game.lockedInBets -= uint128(betAmount);

    Combination memory c = spin(game, hostSeed, clientSeed);
    uint winnings ;	//inject UNINIT LOCAL/STATE VAR


    if (winnings > 0) {
      winnings = winnings * (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT) / 100;
      winnings = winnings.sub(HANDLE_BET_COST);
    }
    p.beneficiary = bet.gambler; 
    p.amount = winnings; 
    p.message = PAYMENT_LOG_MSG; 

    emit LogSlotHandleBet(
      hostSeedHash,
      p.beneficiary, 
      hostSeed, 
      clientSeed, 
      c.symbols, 
      c.multiplier.num, 
      c.multiplier.den,
      betAmount,
      winnings
    );
    remove(bet);
  }
  
  function spin(
    Game storage game,
    bytes32 hostSeed,
    bytes32 clientSeed
  ) 
    internal 
    view 
    returns (
      Combination memory combination
    ) 
  {
    bytes memory symbolsTmp = new bytes(REELS_LEN);
    for (uint i; i < REELS_LEN; i++) {
      bytes memory nonce = abi.encodePacked(uint8(i));
      symbolsTmp[i] = game.reels[i][Rnd.uintn(hostSeed, clientSeed, game.reels[i].length, nonce)];
    }
    combination.symbols = symbolsTmp.copy();
    combination.multiplier = NumberLib.Number(0, 1); // 0/1 == 0.0
    
    for ((uint i, uint length) = (0, game.payTable.length); i < length; i++) {
      bytes memory tmp = game.payTable[i].symbols;
      uint times ;	//inject UNINIT LOCAL/STATE VAR

      if (times > 0) {
        combination.multiplier.maddm(game.payTable[i].multiplier.mmul(times));
        if (tmp.length >= BIG_COMBINATION_MIN_LEN) {
          return combination; 
			  }
      }
    }
    
    for ((uint i, uint length) = (0, game.specialPayTable.length); i < length; i++) {
      if (hasIn(game.specialPayTable[i], combination.symbols)) {
        combination.multiplier.madds(game.specialPayTable[i].multiplier);
      }
    }
  }

  function refundBet(Game storage game, bytes32 hostSeedHash) internal returns(PaymentLib.Payment memory p) {
    Bet storage bet = game.bets[hostSeedHash];
    uint betAmount ;	//inject UNINIT LOCAL/STATE VAR

    require(bet.exist, "slot game: bet does not exist");
    require(betAmount > 0, "slot game: bet already handled");
    require(blockhash(bet.blockNumber) == bytes32(0), "slot game: cannot refund bet");
   
    game.jackpot = uint128(game.jackpot.sub(betAmount * JACKPOT_PERCENT / 100));
    game.lockedInBets -= uint128(betAmount);
    p.beneficiary = bet.gambler; 
    p.amount = betAmount; 
    p.message = REFUND_LOG_MSG; 

    emit LogSlotRefundBet(hostSeedHash, p.beneficiary, p.amount);
    remove(bet);
  }
}



library BitsLib {

  // popcnt returns the number of one bits ("population count") in x.
  // https://en.wikipedia.org/wiki/Hamming_weight 
  function popcnt(uint16 x) internal pure returns(uint) {
    x -= (x >> 1) & 0x5555;
    x = (x & 0x3333) + ((x >> 2) & 0x3333);
    x = (x + (x >> 4)) & 0x0f0f;
    return (x * 0x0101) >> 8;
  }
}




library RollGameLib {
  using NumberLib for NumberLib.Number;
  using SafeMath for uint;
  using SafeMath for uint128;

  // Types
  enum Type {Coin, Square3x3, Roll}
  uint private constant COIN_MOD = 2;
  uint private constant SQUARE_3X3_MOD = 9;
  uint private constant ROLL_MOD = 100;
  bytes32 private constant COIN_PAYMENT_LOG_MSG = "roll.coin";
  bytes32 private constant SQUARE_3X3_PAYMENT_LOG_MSG = "roll.square_3x3";
  bytes32 private constant ROLL_PAYMENT_LOG_MSG = "roll.roll";
  bytes32 private constant REFUND_LOG_MSG = "roll.refund";
  uint private constant HOUSE_EDGE_PERCENT = 1;
  uint private constant JACKPOT_PERCENT = 1;
  uint private constant HANDLE_BET_COST = 0.0005 ether;
  uint private constant MIN_BET_AMOUNT = 10 + (HANDLE_BET_COST * 100) / (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT);

  function MinBetAmount() internal pure returns(uint) {
    return MIN_BET_AMOUNT;
  }

  // solium-disable lbrace, whitespace
  function module(Type t) internal pure returns(uint) {
    if (t == Type.Coin) { return COIN_MOD; } 
    else if (t == Type.Square3x3) { return SQUARE_3X3_MOD; } 
    else { return ROLL_MOD; }
  }

  function logMsg(Type t) internal pure returns(bytes32) {
    if (t == Type.Coin) { return COIN_PAYMENT_LOG_MSG; } 
    else if (t == Type.Square3x3) { return SQUARE_3X3_PAYMENT_LOG_MSG; }
    else { return ROLL_PAYMENT_LOG_MSG; }
  }

  function maskRange(Type t) internal pure returns(uint, uint) {
    if (t == Type.Coin) { return (1, 2 ** COIN_MOD - 2); } 
    else if (t == Type.Square3x3) { return (1, 2 ** SQUARE_3X3_MOD - 2); }
  }

  function rollUnderRange(Type t) internal pure returns(uint, uint) {
    if (t == Type.Roll) { return (1, ROLL_MOD - 1); } // 0..99
  }
  // solium-enable lbrace, whitespace



  struct Bet {
    uint amount;
    Type t; // 8
    uint8 rollUnder; // 8
    uint16 mask;  // 16
    uint40 blockNumber; // 40
    address payable gambler; // 160
    bool exist; // 1
  }

  function roll(
    Bet storage bet,
    bytes32 hostSeed,
    bytes32 clientSeed
  ) 
    internal 
    view 
    returns (
      uint rnd,
      NumberLib.Number memory multiplier
    ) 
  {
    uint m ;	//inject UNINIT LOCAL/STATE VAR

    rnd = Rnd.uintn(hostSeed, clientSeed, m);
    multiplier.den = 1; // prevent divide to zero
    
    uint mask ;	//inject UNINIT LOCAL/STATE VAR

    if (mask != 0) {
      if (((2 ** rnd) & mask) != 0) {
        multiplier.den = BitsLib.popcnt(uint16(mask));
        multiplier.num = m;
      }
    } else {
      uint rollUnder ;	//inject UNINIT LOCAL/STATE VAR

      if (rollUnder > rnd) {
        multiplier.den = rollUnder;
        multiplier.num = m;
      }
    }
  }

  function remove(Bet storage bet) internal {
    delete bet.amount;
    delete bet.t;
    delete bet.mask;
    delete bet.rollUnder;
    delete bet.blockNumber;
    delete bet.gambler;
  }



  struct Game {
    address secretSigner;
    uint128 lockedInBets;
    uint128 jackpot;
    uint maxBetAmount;
    uint minBetAmount;
    
    mapping(bytes32 => Bet) bets;
  }

  event LogRollNewBet(
    bytes32 indexed hostSeedHash, 
    uint8 t,
    address indexed gambler, 
    uint amount,
    uint mask, 
    uint rollUnder,
    address indexed referrer
  );

  event LogRollRefundBet(
    bytes32 indexed hostSeedHash, 
    uint8 t,
    address indexed gambler, 
    uint amount
  );

  event LogRollHandleBet(
    bytes32 indexed hostSeedHash, 
    uint8 t,
    address indexed gambler, 
    bytes32 hostSeed, 
    bytes32 clientSeed, 
    uint roll, 
    uint multiplierNum, 
    uint multiplierDen,
    uint amount,
    uint winnings
  );

  function setMinMaxBetAmount(Game storage game, uint minBetAmount, uint maxBetAmount) internal {
    require(minBetAmount >= MIN_BET_AMOUNT, "roll game: invalid min of bet amount");
    require(minBetAmount <= maxBetAmount, "roll game: invalid [min, max] range of bet amount");
    game.minBetAmount = minBetAmount;
    game.maxBetAmount = maxBetAmount;
  }

  function placeBet(
    Game storage game, 
    Type t, 
    uint16 mask, 
    uint8 rollUnder,
    address referrer,
    uint sigExpirationBlock,
    bytes32 hostSeedHash, 
    uint8 v, 
    bytes32 r, 
    bytes32 s
  ) 
    internal 
  {
    ProtLib.checkSigner(game.secretSigner, sigExpirationBlock, hostSeedHash, v, r, s);
    Bet storage bet = game.bets[hostSeedHash];
    require(!bet.exist, "roll game: bet already exist");
    require(game.minBetAmount <= msg.value && msg.value <= game.maxBetAmount, "roll game: invalid bet amount");

    {  // solium-disable indentation
      (uint minMask, uint maxMask) = maskRange(t);
      require(minMask <= mask && mask <= maxMask, "roll game: invalid bet mask");
      (uint minRollUnder, uint maxRollUnder) = rollUnderRange(t);
      require(minRollUnder <= rollUnder && rollUnder <= maxRollUnder, "roll game: invalid bet roll under");
    }  // solium-enable indentation

    // * do not touch it!
    bet.amount = msg.value;
    bet.blockNumber = uint40(block.number);
    bet.gambler = msg.sender;
    bet.exist = true;
    bet.mask = mask;
    bet.rollUnder = rollUnder;
    bet.t = t;
    // *

    game.lockedInBets += uint128(msg.value);
    game.jackpot += uint128(msg.value * JACKPOT_PERCENT / 100);

    emit LogRollNewBet(
      hostSeedHash,
      uint8(t),
      msg.sender,
      msg.value,
      mask,
      rollUnder,
      referrer
    );
  }


  function handleBet(
    Game storage game,
    bytes32 hostSeed,
    bytes32 clientSeed
  ) 
    internal 
    returns(
      PaymentLib.Payment memory p
    ) 
  {
    bytes32 hostSeedHash ;	//inject UNINIT LOCAL/STATE VAR

    Bet storage bet = game.bets[hostSeedHash];
    uint betAmount ;	//inject UNINIT LOCAL/STATE VAR

    require(bet.exist, "roll game: bet does not exist");
    require(betAmount > 0, "roll game: bet already handled");
    ProtLib.checkBlockHash(bet.blockNumber, clientSeed);
    game.lockedInBets -= uint128(betAmount);

    (uint rnd, NumberLib.Number memory multiplier) = roll(bet, hostSeed, clientSeed);
    uint winnings ;	//inject UNINIT LOCAL/STATE VAR

  
    if (winnings > 0) {
      winnings = winnings * (100 - HOUSE_EDGE_PERCENT - JACKPOT_PERCENT) / 100;
      winnings = winnings.sub(HANDLE_BET_COST);
    }
    p.beneficiary = bet.gambler; 
    p.amount = winnings; 
    p.message = logMsg(bet.t); 

    emit LogRollHandleBet(
      hostSeedHash,
      uint8(bet.t),
      p.beneficiary,
      hostSeed,
      clientSeed,
      rnd,
      multiplier.num,
      multiplier.den,
      betAmount,
      winnings
    );
    remove(bet);
  }


  function refundBet(Game storage game, bytes32 hostSeedHash) internal returns(PaymentLib.Payment memory p) {
    Bet storage bet = game.bets[hostSeedHash];
    uint betAmount ;	//inject UNINIT LOCAL/STATE VAR

    require(bet.exist, "roll game: bet does not exist");
    require(betAmount > 0, "roll game: bet already handled");
    require(blockhash(bet.blockNumber) == bytes32(0), "roll game: cannot refund bet");
   
    game.jackpot = uint128(game.jackpot.sub(betAmount * JACKPOT_PERCENT / 100));
    game.lockedInBets -= uint128(betAmount);
    p.beneficiary = bet.gambler; 
    p.amount = betAmount; 
    p.message = REFUND_LOG_MSG; 

    emit LogRollRefundBet(hostSeedHash, uint8(bet.t), p.beneficiary, p.amount);
    remove(bet);
  }
}



contract Accessibility {
  enum AccessRank { None, Croupier, Games, Withdraw, Full }
  mapping(address => AccessRank) public admins;
  modifier onlyAdmin(AccessRank  r) {
    require(
      admins[msg.sender] == r || admins[msg.sender] == AccessRank.Full,
      "accessibility: access denied"
    );
    _;
  }
  event LogProvideAccess(address indexed whom, uint when,  AccessRank rank);

  constructor() public {
    admins[msg.sender] = AccessRank.Full;
    emit LogProvideAccess(msg.sender, now, AccessRank.Full);
  }
  
  function provideAccess(address addr, AccessRank rank) public onlyAdmin(AccessRank.Full) {
    require(admins[addr] != AccessRank.Full, "accessibility: cannot change full access rank");
    if (admins[addr] != rank) {
      admins[addr] = rank;
      emit LogProvideAccess(addr, now, rank);
    }
  }
}


contract Casino is Accessibility {
  using PaymentLib for PaymentLib.Payment;
  using RollGameLib for RollGameLib.Game;
  using SlotGameLib for SlotGameLib.Game;

  bytes32 private constant JACKPOT_LOG_MSG = "casino.jackpot";
  bytes32 private constant WITHDRAW_LOG_MSG = "casino.withdraw";
  bytes private constant JACKPOT_NONCE = "jackpot";
  uint private constant MIN_JACKPOT_MAGIC = 3333;
  uint private constant MAX_JACKPOT_MAGIC = 333333333;
  
  SlotGameLib.Game public slot;
  RollGameLib.Game public roll;
  enum Game {Slot, Roll}

  uint public extraJackpot;
  uint public jackpotMagic;

  modifier slotBetsWasHandled() {
    require(slot.lockedInBets == 0, "casino.slot: all bets should be handled");
    _;
  }

  event LogPayment(address indexed beneficiary, uint amount, bytes32 indexed message);
  event LogFailedPayment(address indexed beneficiary, uint amount, bytes32 indexed message);

  event LogJactpot(
    address indexed beneficiary, 
    uint amount, 
    bytes32 hostSeed,
    bytes32 clientSeed,
    uint jackpotMagic
  );

  event LogSlotNewBet(
    bytes32 indexed hostSeedHash,
    address indexed gambler,
    uint amount,
    address indexed referrer
  );

  event LogSlotHandleBet(
    bytes32 indexed hostSeedHash,
    address indexed gambler,
    bytes32 hostSeed,
    bytes32 clientSeed,
    bytes symbols,
    uint multiplierNum,
    uint multiplierDen,
    uint amount,
    uint winnings
  );

  event LogSlotRefundBet(
    bytes32 indexed hostSeedHash,
    address indexed gambler, 
    uint amount
  );

  event LogRollNewBet(
    bytes32 indexed hostSeedHash, 
    uint8 t,
    address indexed gambler, 
    uint amount,
    uint mask, 
    uint rollUnder,
    address indexed referrer
  );

  event LogRollRefundBet(
    bytes32 indexed hostSeedHash, 
    uint8 t,
    address indexed gambler, 
    uint amount
  );

  event LogRollHandleBet(
    bytes32 indexed hostSeedHash, 
    uint8 t,
    address indexed gambler, 
    bytes32 hostSeed, 
    bytes32 clientSeed, 
    uint roll, 
    uint multiplierNum, 
    uint multiplierDen,
    uint amount,
    uint winnings
  );

  constructor() public {
    jackpotMagic = MIN_JACKPOT_MAGIC;
    slot.minBetAmount = SlotGameLib.MinBetAmount();
    slot.maxBetAmount = SlotGameLib.MinBetAmount();
    roll.minBetAmount = RollGameLib.MinBetAmount();
    roll.maxBetAmount = RollGameLib.MinBetAmount();
  }

  function() external payable {}
  
  /**
  * @dev Place bet to roll game.
  * @param t The type of roll game.
  * @param mask Bitmask for special roll game`s type. User choice.
  * @param rollUnder Roll under for special roll game`s type. User choice.
  * @param referrer Address of the gambler`s referrer.
  * @param hostSeedHash keccak256(hostSeed). The roll game`s bet id.
  * @param v V of ECDSA signature from hostSeedHash.
  * @param r R of ECDSA signature from hostSeedHash.
  * @param s S of ECDSA signature from hostSeedHash.
  */
  function rollPlaceBet(
    RollGameLib.Type t, 
    uint16 mask, 
    uint8 rollUnder, 
    address referrer,
    uint sigExpirationBlock, 
    bytes32 hostSeedHash, 
    uint8 v, 
    bytes32 r, 
    bytes32 s
  ) 
    external payable
  {
    roll.placeBet(t, mask, rollUnder, referrer, sigExpirationBlock, hostSeedHash, v, r, s);
  }

  function rollBet(bytes32 hostSeedHash) 
    external 
    view 
    returns (
      RollGameLib.Type t,
      uint amount,
      uint mask,
      uint rollUnder,
      uint blockNumber,
      address payable gambler,
      bool exist
    ) 
  {
    RollGameLib.Bet storage b = roll.bets[hostSeedHash];
    t = b.t;
    amount = b.amount;
    mask = b.mask;
    rollUnder = b.rollUnder;
    blockNumber = b.blockNumber;
    gambler = b.gambler;
    exist = b.exist;  
  }

  function slotPlaceBet(
    address referrer,
    uint sigExpirationBlock,
    bytes32 hostSeedHash,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) 
    external payable
  {
    slot.placeBet(referrer, sigExpirationBlock, hostSeedHash, v, r, s);
  }

  function slotBet(bytes32 hostSeedHash) 
    external 
    view 
    returns (
      uint amount,
      uint blockNumber,
      address payable gambler,
      bool exist
    ) 
  {
    SlotGameLib.Bet storage b = slot.bets[hostSeedHash];
    amount = b.amount;
    blockNumber = b.blockNumber;
    gambler = b.gambler;
    exist = b.exist;  
  }

  function slotSetReels(uint n, bytes calldata symbols) 
    external 
    onlyAdmin(AccessRank.Games) 
    slotBetsWasHandled 
  {
    slot.setReel(n, symbols);
  }

  function slotReels(uint n) external view returns (bytes memory) {
    return slot.reels[n];
  }

  function slotPayLine(uint n) external view returns (bytes memory symbols, uint num, uint den) {
    symbols = new bytes(slot.payTable[n].symbols.length);
    symbols = slot.payTable[n].symbols;
    num = slot.payTable[n].multiplier.num;
    den = slot.payTable[n].multiplier.den;
  }

  function slotSetPayLine(uint n, bytes calldata symbols, uint num, uint den) 
    external 
    onlyAdmin(AccessRank.Games) 
    slotBetsWasHandled 
  {
    slot.setPayLine(n, SlotGameLib.Combination(symbols, NumberLib.Number(num, den)));
  }

  function slotSpecialPayLine(uint n) external view returns (byte symbol, uint num, uint den, uint[] memory indexes) {
    indexes = new uint[](slot.specialPayTable[n].indexes.length);
    indexes = slot.specialPayTable[n].indexes;
    num = slot.specialPayTable[n].multiplier.num;
    den = slot.specialPayTable[n].multiplier.den;
    symbol = slot.specialPayTable[n].symbol;
  }

  function slotSetSpecialPayLine(
    uint n,
    byte symbol,
    uint num, 
    uint den, 
    uint[] calldata indexes
  ) 
    external 
    onlyAdmin(AccessRank.Games) 
    slotBetsWasHandled
  {
    SlotGameLib.SpecialCombination memory scomb = SlotGameLib.SpecialCombination(symbol, NumberLib.Number(num, den), indexes);
    slot.setSpecialPayLine(n, scomb);
  }

  function handleBet(Game game, bytes32 hostSeed, bytes32 clientSeed) external onlyAdmin(AccessRank.Croupier) {
    PaymentLib.Payment memory p; 
    p = game == Game.Slot ? slot.handleBet(hostSeed, clientSeed) : roll.handleBet(hostSeed, clientSeed);
    checkEnoughFundsForPay(p.amount);
    p.send();

    p = rollJackpot(p.beneficiary, hostSeed, clientSeed);
    if (p.amount == 0) {
      return;
    }
    checkEnoughFundsForPay(p.amount);
    p.send();
  }

  function refundBet(Game game, bytes32 hostSeedHash) external {
    PaymentLib.Payment memory p; 
    p = game == Game.Slot ? slot.refundBet(hostSeedHash) : roll.refundBet(hostSeedHash);
    checkEnoughFundsForPay(p.amount);
    p.send();
  }

  function setSecretSigner(Game game, address secretSigner) external onlyAdmin(AccessRank.Games) {
    address otherSigner ;	//inject UNINIT LOCAL/STATE VAR

    require(secretSigner != otherSigner, "casino: slot and roll secret signers must be not equal");
    game == Game.Roll ? roll.secretSigner = secretSigner : slot.secretSigner = secretSigner;
  }

  function setMinMaxBetAmount(Game game, uint min, uint max) external onlyAdmin(AccessRank.Games) {
    game == Game.Roll ? roll.setMinMaxBetAmount(min, max) : slot.setMinMaxBetAmount(min, max);
  }

  function kill(address payable beneficiary) 
    external 
    onlyAdmin(AccessRank.Full) 
  {
    require(lockedInBets() == 0, "casino: all bets should be handled");
    selfdestruct(beneficiary);
  }

  function rollJackpot(
    address payable beneficiary,
    bytes32 hostSeed,
    bytes32 clientSeed
  ) 
    private returns(PaymentLib.Payment memory p) 
  {
    if (Rnd.uintn(hostSeed, clientSeed, jackpotMagic, JACKPOT_NONCE) != 0) {
      return p;
    }
    p.beneficiary = beneficiary;
    p.amount = jackpot();
    p.message = JACKPOT_LOG_MSG;

    delete slot.jackpot;
    delete roll.jackpot;
    delete extraJackpot;
    emit LogJactpot(p.beneficiary, p.amount, hostSeed, clientSeed, jackpotMagic);
  }

  function increaseJackpot(uint amount) external onlyAdmin(AccessRank.Games) {
    checkEnoughFundsForPay(amount);
    extraJackpot += amount;
    // todo event?
  }

  function setJackpotMagic(uint magic) external onlyAdmin(AccessRank.Games) {
    require(MIN_JACKPOT_MAGIC <= magic && magic <= MAX_JACKPOT_MAGIC, "casino: invalid jackpot magic");
    jackpotMagic = magic;
    // todo event?
  }

  function withdraw(address payable beneficiary, uint amount) external onlyAdmin(AccessRank.Withdraw) {
    checkEnoughFundsForPay(amount);
    PaymentLib.Payment(beneficiary, amount, WITHDRAW_LOG_MSG).send();
  }

  function lockedInBets() public view returns(uint) {
    return slot.lockedInBets + roll.lockedInBets;
  }

  function jackpot() public view returns(uint) {
    return slot.jackpot + roll.jackpot + extraJackpot;
  }

  function freeFunds() public view returns(uint) {
    if (lockedInBets() + jackpot() >= address(this).balance ) {
      return 0;
    }
    return address(this).balance - lockedInBets() - jackpot();
  }

  function checkEnoughFundsForPay(uint amount) private view {
    require(freeFunds() >= amount, "casino: not enough funds");
  }
}