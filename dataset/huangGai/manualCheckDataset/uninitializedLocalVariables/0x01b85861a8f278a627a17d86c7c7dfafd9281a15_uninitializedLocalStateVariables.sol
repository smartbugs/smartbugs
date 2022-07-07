pragma solidity ^0.5.0;
//p3Dank.io
//A never ending free for all strategy game
//send 0.2 ETH to contract to play
//you get 3 lives/plants/houses(it can be anything, you get 3)
//you cant rebuy till your out
//each life has a type
//BLOCK smashes fork
//FORK forks the chain
//CHAIN adds the block
//plants automatically grow over time 
//the older the plants get a bigger % bonus for selling
//choose to sell 1 plant or attack at random every 7 hours 
//if your random attack wins the rock paper scissors...
//you sell the targets plant for 50% its base value(no bonus)
//sucessful attacks raise the value of every other plant, >>DONT MISS ATTACKS<<
//sold plants have a bonus and reduce the value of every other plant. 
//Sell bonus is 2x after 42000 blocks, Max bonus of 4x after 69420 blocks
//sell price = (total eth in contract) * (growth of plant being sold) / (total growth in game) + (big plant bonus)
//1% dev cut 99% back to players.
//If this works as intended the game expands and contracts to any amount of players and never ends

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
        }
    }



//import "browser/safemath.sol";

contract p3Dank  {
    using SafeMath for uint;
    uint256 public _totalhouses; // total number of houses in the game, used to calc divs
    uint256 public blocksbeforeaction ;// blocks between player action. 7 hours / 420 minutes / 3 moves per day	//inject UNINIT LOCAL/STATE VAR

    uint256 public nextFormation;// next spot in formation
    mapping(address => uint256)public _playerhouses; // number of houses owned by player
    mapping(address => uint256)public lastmove;//blocknumber lastMove
    mapping(address => uint256) buyblock;// block that houses were purchased by a player
    address payable happydev ; // dev cut	//inject UNINIT LOCAL/STATE VAR


   struct house { //houses for the battlefield
       address owner; //who owns the house
       uint8 rpstype; //what type of house is it 1=roc 2=pap 3=sis
   }

    mapping(uint256 => house)public formation;// the playing field

    //modifiers

    modifier ishuman() {//"real" players only
        address _addr ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _codeLength;
        assembly {_codeLength := extcodesize(_addr)}
        require(_codeLength == 0, "sorry humans only");
        _;
    }

    modifier canmove() {
          address sender ;	//inject UNINIT LOCAL/STATE VAR

          require(_playerhouses[sender] > 0);
          require(canimoveyet());
          _;
    }

    //events

    event sell (address seller, uint256 plantsize, uint256 cashout);
    event battle(address attacker, uint8 ktype, address defender);
    event win (uint256 position, uint256 sizesold, uint256 amountsent);    

    function () external payable{}

    function buyhouses() ishuman() public payable { // houses... plants... lives ... its all good
        uint256 value ;	//inject UNINIT LOCAL/STATE VAR

        if(value == 200 finney){// buying 3 houses costs 0.2 eth
            address sender ;	//inject UNINIT LOCAL/STATE VAR

            if(_playerhouses[sender] == 0 ){ // check that user has no houses
                _playerhouses[sender] = 3; // add houses to players count
                uint256 next ;	//inject UNINIT LOCAL/STATE VAR

                formation[next++] = house(sender, 1);// add houses to playing field
                formation[next++] = house(sender, 2);// roc = 1, pap =2, sis = 3.
                formation[next++] = house(sender, 3);
                nextFormation = next;
                lastmove[sender] = block.number; // reset lastMove to prevent people from attacking right away
                buyblock[sender] = block.number; // log the buy block of the sender
                _totalhouses += 3;// update totalSupply
                happydev.transfer(2 finney);
                totaldivpts += 3000;
                } } }

    bool gameon;

    function startgame() public payable {
        uint256 value ;	//inject UNINIT LOCAL/STATE VAR

        require(value == 200 finney);// buying 3 houses costs 0.2 eth
        require (gameon == false);
        address sender ;	//inject UNINIT LOCAL/STATE VAR

        _playerhouses[sender] = _playerhouses[sender]+3;// add houses to players count
        formation[nextFormation] = house(sender, 1);// add houses to playing field
        nextFormation++;
        formation[nextFormation] = house(sender, 2);// roc = 1, pap =2, sis = 3.
        nextFormation++;
        formation[nextFormation] = house(sender, 3);
        nextFormation++;
        lastmove[sender] = block.number; // reset lastMove to prevent people from attacking right away
        buyblock[sender] = block.number; // log the buy block of the sender
        _totalhouses = _totalhouses+3;// update totalSupply
        happydev.transfer(2 finney);
        lastupdateblock = block.number;
        gameon = true;
        totaldivpts += 3000;
    }

    //divsection
    uint256 lastupdateblock;
    uint256 totaldivpts;

    function updateglobal() internal {                       
        totaldivpts = gametotaldivs();
        lastupdateblock = block.number;//updated
        lastmove[msg.sender] = block.number; // reset lastmove of attacker
    }

    function rekt(uint8 typeToKill) internal {
        updateglobal();
        uint256 attacked ;	//inject UNINIT LOCAL/STATE VAR

        uint256 _rpstype ;	//inject UNINIT LOCAL/STATE VAR

        address killed ;//set address of attacked player	//inject UNINIT LOCAL/STATE VAR

        address payable sender ;	//inject UNINIT LOCAL/STATE VAR

        if(_rpstype == typeToKill) {
            formation[attacked] = formation[--nextFormation];//reform playing field
            delete formation[nextFormation];  //delete unused formation
            uint256 playerdivpts ;//figure out how big robbed plant is	//inject UNINIT LOCAL/STATE VAR

            uint256 robbed ; //figure out how much was robbed	//inject UNINIT LOCAL/STATE VAR

            totaldivpts = totaldivpts.sub(playerdivpts); //adjust total div points
            _totalhouses--;//update total houses in game
            _playerhouses[killed]--;//update attacked players houses
            sender.transfer(robbed);//pay the robber
            emit win(attacked, playerdivpts, robbed);  
        }
        emit battle(sender, typeToKill, killed);
        } 
  
        

    function rockattack() canmove() public { //rock attack function
        rekt(3);
        }

    function sisattack() canmove() public { //sicssor attack function
        rekt(1);
        }

    function papattack() canmove() public {//paper attack function
        rekt(2);
        }

    function sellhouse (uint256 selling) canmove() public {// house sell function
        address payable sender ;	//inject UNINIT LOCAL/STATE VAR

        address beingsold ;	//inject UNINIT LOCAL/STATE VAR

        if (beingsold == sender){ // how to comfirm sender is owner
            updateglobal();
            uint256 next ;	//inject UNINIT LOCAL/STATE VAR

            formation[selling] = formation[next];
            delete formation[next];
            _totalhouses--;//update total houses in game
            _playerhouses[sender]--;//update selling players houses
            uint256 maxbuyblock ;	//inject UNINIT LOCAL/STATE VAR

            uint256 playerdivpts ;	//inject UNINIT LOCAL/STATE VAR

            uint256 sold;
            if (playerdivpts >= maxbuyblock) {
                sold = (address(this).balance).mul(maxbuyblock * 4).div(totaldivpts);
                }
            else {
                uint256 payoutmultiplier ;	//inject UNINIT LOCAL/STATE VAR

                sold = (address(this).balance).mul(playerdivpts).mul(payoutmultiplier).div(totaldivpts).div(10000);
            }
            totaldivpts = totaldivpts.sub(playerdivpts); //adjust total div points
            sender.transfer(sold);//payout
            emit sell(sender, playerdivpts, sold);
            } }         


    //view functions
    function singleplantdivs ()public view returns(uint256){ //how big are are my plants?
        return(block.number.sub(buyblock[msg.sender]).add(1000));
    }
    function howmanyplants ()public view returns(uint256){ //how many plants do I have?
        return(_playerhouses[msg.sender]);
    }
    function whatblockmove ()public view returns(uint256){  // what block # can I make my next move at
        return(lastmove[msg.sender]).add(blocksbeforeaction);
    }
    function canimoveyet ()public view returns(bool){ //can i move
        if (blocksbeforeaction <= (block.number).sub(lastmove[msg.sender])) return true;
    }
    function howmucheth ()public view returns(uint256){//how much eth is in the contract
        return address(this).balance;
    }
    function gametotaldivs ()public view returns(uint256){//how many div points are in the game right now
        return (block.number).sub(lastupdateblock).mul(_totalhouses).add(totaldivpts);
    }
    function singleplantpayout ()public view returns(uint256){
        uint256 playerdivpts ;	//inject UNINIT LOCAL/STATE VAR

        uint256 maxbuyblock ;	//inject UNINIT LOCAL/STATE VAR

        if (playerdivpts >= maxbuyblock) {
            return (address(this).balance).mul(maxbuyblock * 4).div(totaldivpts);
        }
        else {
            uint256 payoutmultiplier ;	//inject UNINIT LOCAL/STATE VAR

            return (address(this).balance).mul(playerdivpts).mul(payoutmultiplier).div(totaldivpts).div(10000);
        }
    }

//thanks for playing
}