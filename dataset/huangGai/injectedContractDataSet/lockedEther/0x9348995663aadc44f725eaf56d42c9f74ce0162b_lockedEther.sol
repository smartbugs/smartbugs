pragma solidity >=0.5.8;
/*
MMMMZ$..?ZOMMMMMMMMMMMMMMMMMOZ?~~IZMMMMM
MMMZ~.~~,..ZOMMMMMMMMMMMMMDZ~~~~~~+ZMMMM
MMDZ.~====~.:ZMMMMMMMMMMMO7~======~$8MMM
MMO.,=======.:7~.......+$=~=======~~OMMM
MMO.=====...............~~~~~~=====~ZMMM
MMZ.==~.................~~~~~~~~===~ZMMM
MMO.=~..................:~~~~~~~~~~~ZMMM
MMO......................~~~~~~~~~~~OMMM
MMMZ......................:~~~~~~~~OMMMM
MMO+........................~~~~~~~ZDMMM
MMO............................:~~~~ZMMM
MO~......:ZZ,.............ZZ:.......ZMMM
MO......+ZZZZ,...........ZZZZ+......7DMM
MDZ?7=...ZZZZ............OZZZ.......ZMMM
O+....Z==........ZZ~Z.......====.?ZZZ8MM
,....Z,$....................,==~.ZODMMMM
Z.O.=ZZ.......................7OZOZDMMMM
O.....:ZZZ~,................I$.....OMMMM
8=.....ZZI??ZZZOOOZZZZZOZZZ?O.Z.:~.ZZMMM
MZ.......+7Z7????$OZZI????Z~~ZOZZZZ~~$OM
MMZ...........IZO~~~~~ZZ?.$~~~~~~~~~~~ZM
MMMO7........==Z=~~~~~~O=+I~~IIIZ?II~~IN
MMMMMZ=.....:==Z~~~Z~~+$=+I~~ZZZZZZZ~~IN
MMMMDZ.+Z...====Z+~~~$Z==+I~~~~$Z+OZ~~IN
MMMMO....O=.=====~I$?====+I~~ZZ?+Z~~~~IN
MMMMZ.....Z~=============+I~~$$$Z$$$~~IN
MMMMZ......O.============OI~ZZZZZZZZZ~IN
MMMMZ,.....~7..,=======,.ZI~Z?~OZZ~IZ~IN
MMMZZZ......O...........7+$~~~~~~~~~~~ZM
MMZ,........ZI:.........$~$=~~~~~~~~~7OM
MMOZ,Z.,?$Z8MMMMND888DNMMNZZZZZZZZZOOMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMMMMMMM

This is the generic Manek.io wager contract where all Mankek.io bets live unless
otherwise stated. With a standard end timer. Betting can only be stared by the
admin. Who sets an endtime and number of picks. Betting can only be ended once
the timer is over or betting is ended and a refund is triggered. Players must
withdraw their funds once betting is over. There is a single jackpot winner which is
based off the hash of the block 200 before betting ends and will be valid for 6000
blocks (about 1 day). The jackpot winner must claim their prize or it will
go to the next winner.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
BedID's [bID] reference a specific bet, bet names can be looked up via the viewPck
method.
*/

contract manekio {

  //EVENTS
  event playerBet (
    uint256 BetID,
    address playerAddress,
    uint256 pick,
    uint256 eth
    );
  event playerPaid (
    uint256 BetID,
    address playerAddress,
    uint256 pick,
    uint256 eth
    );
  event jackpotClaim (
    uint256 BetID,
    address playerAddress,
    uint256 eth
    );
  event adminStart (
    uint256 betID,
    uint256 pcknum,
    uint256 endtime,
    uint256 bEndtime
    );
  event adminEndWin (
    uint256 betID,
    uint256 wPck
    );
    //MODIFIERS
    modifier onlyAdministrator(){
      address _playerAddress = msg.sender;
      require(_playerAddress == admin);
      _;
    }
    //STRUCTURES
    struct playerJBook {
      uint256 sShare;
      uint256 eShare;
    }
    struct playerBook {
      uint256 share;
      uint256 eth;
      bool paid;
    }
    struct pickBook {
      uint256 share; //number of shares in each
      uint256 nBet; //number of player bets (ID)
    }
    struct betDataBook {
      //set when games is started
      string pckname;
      uint256 pcknum;
      uint256 endtime;
      uint256 bEndtime;

      //in game values
      uint256 tShare;
      uint256 comm;
      uint256 commPaid;
      uint256 jackpot;

      //current state values
      bool started;
      bool ended;
      bool refund;

      //end of game values
      uint256 wPck;
      uint256 shareval;
      uint256 jendblock;
      uint256 endblockhash;
      address jPotWinner;
      bool jPotclaimed;
    }

    //DATASETS
    mapping(uint256 => mapping(address => mapping(uint256 => playerJBook))) internal plyrJBk; //plyrJBk[bID][addr][bet #] = playerJBook addr => bet num => plyrJBk
    mapping(uint256 => mapping(address => mapping(uint256 => playerBook))) internal pAddrxBk; //pAddrxBk[bID][addr][pck] = shares   address => pick => shares
    mapping(uint256 => mapping(uint256 => pickBook)) internal pBk; //total number of N bets & shares
    mapping(uint256 => betDataBook) internal bDB; //bDB[bID] = all round data except player data and pick totals

    uint256 internal commrate = 25;
    uint256 internal jpotrate = 25;
    uint256 internal jpotinterval = 6000;

    address payable internal admin = 0xe7Cef4D90BdA19A6e2A20F12A1A6C394230d2924;
    uint256 internal donations = 0;
    uint256 internal donationsPaid = 0;


    //FALLBACK FUNCTION
    //all eth sent to contract without proper message will dump into pot, comm, and jackpot
    function() external payable {	//injected LOCKED ETHER
      require(msg.value > 0);
      donations += msg.value;
    }
    //PUBLIC FUNCTIONS
    //this is where players place their bets
    function playerPick(uint256 _bID, uint256 _pck) public payable {	//injected LOCKED ETHER
      address _pAddr = msg.sender;
      uint256 _eth = msg.value;
      require(_eth > 0);
      //minimum bet entry is .01 eth & player chose a valid pick
      if (_eth >= 1e16 && !checkTime(_bID) && !bDB[_bID].ended && _pck <= bDB[_bID].pcknum && bDB[_bID].started && !bDB[_bID].refund) {
        //get my fucking money
        uint256 _commEth = _eth / commrate;
        uint256 _jpEth = _eth / jpotrate;
        uint256 _potEth = _eth - _commEth - _jpEth;
        //calc shares (each share is .00001 eth)
        uint256 _share = _potEth / 1e13;
        //update books
        bDB[_bID].comm += _commEth;
        bDB[_bID].jackpot += _jpEth + (_potEth % 1e13);
        pBk[_bID][_pck].nBet += 1;
        pBk[_bID][_pck].share += _share;
        //update plyrJBk
        for(uint256 i = 0; true; i++) {
          if(plyrJBk[_bID][_pAddr][i].eShare == 0){
            plyrJBk[_bID][_pAddr][i].sShare = bDB[_bID].tShare;
            plyrJBk[_bID][_pAddr][i].eShare = bDB[_bID].tShare + _share - 1;
            break;
          }
        }
        //update total shares
        bDB[_bID].tShare += _share;
        //update pAddrxBk
        pAddrxBk[_bID][_pAddr][_pck].share += _share;
        pAddrxBk[_bID][_pAddr][_pck].eth += _eth;
        //fire event
        emit playerBet(_bID, _pAddr, _pck, _potEth);
      }
      else {
        donations += _eth;
      }
    }
    //call me if you won the jackpot (can check via checkJPotWinner) which this function also calls
    function claimJackpot(uint256 _bID) public {
      address payable _pAddr = msg.sender;
      uint256 _jackpot = bDB[_bID].jackpot;
      require(bDB[_bID].ended == true && checkJPotWinner(_bID, _pAddr) && !bDB[_bID].jPotclaimed && bDB[_bID].refund == false);
      bDB[_bID].jPotclaimed = true;
      bDB[_bID].jPotWinner = _pAddr;
      _pAddr.transfer(0);
      emit jackpotClaim(_bID, _pAddr, _jackpot);
    }
    //call me if you won and betting is over
    function payMeBitch(uint256 _bID, uint256 _pck) public {
      address payable _pAddr = msg.sender;
      require(pAddrxBk[_bID][_pAddr][_pck].paid == false && pAddrxBk[_bID][_pAddr][_pck].share > 0 && bDB[_bID].wPck == _pck && bDB[_bID].refund == false && bDB[_bID].ended == true);
      uint256 _eth = pAddrxBk[_bID][_pAddr][_pck].share * bDB[_bID].shareval;
      pAddrxBk[_bID][_pAddr][_pck].paid = true;
      _pAddr.transfer(0);
      emit playerPaid(_bID, _pAddr, _pck, _eth);
    }
    //call me if a refund was triggered by admin
    function giveMeRefund(uint256 _bID, uint256 _pck) public {
      address payable _pAddr = msg.sender;
      require(bDB[_bID].refund == true);
      require(pAddrxBk[_bID][_pAddr][_pck].paid == false && pAddrxBk[_bID][_pAddr][_pck].eth > 0);
      pAddrxBk[_bID][_pAddr][_pck].paid = true;
      _pAddr.transfer(0);
    }

    //VIEW FUNCTIONS
    //checks if a specific address is the jackpot winner for bet
    function checkJPotWinner(uint256 _bID, address payable _pAddr) public view returns(bool){
      uint256 _endblockhash = bDB[_bID].endblockhash;
      uint256 _tShare = bDB[_bID].tShare;
      uint256 _nend = nextJPot(_bID);
      uint256 _wnum;
      require(plyrJBk[_bID][_pAddr][0].eShare != 0);
      if (bDB[_bID].jPotclaimed == true) {
        return(false);
      }
      //pseudo random function which adds deadline block to a stored block hash and keccack256 hashes it
      _endblockhash = uint256(keccak256(abi.encodePacked(_endblockhash + _nend)));
      _wnum = (_endblockhash % _tShare);
      for(uint256 i = 0; true; i++) {
        if(plyrJBk[_bID][_pAddr][i].eShare == 0){
          break;
        }
        else {
          if (plyrJBk[_bID][_pAddr][i].sShare <= _wnum && plyrJBk[_bID][_pAddr][i].eShare >= _wnum ){
            return(true);
          }
        }
      }
      return(false);
    }
    //returns the current jackpot claim deadline
    function nextJPot(uint256 _bID) public view returns(uint256) {
      uint256 _cblock = block.number;
      uint256 _jendblock = bDB[_bID].jendblock;
      uint256 _tmp = (_cblock - _jendblock);
      uint256 _nend = _jendblock + jpotinterval;
      uint256 _c = 0;
      if (bDB[_bID].jPotclaimed == true) {
        return(0);
      }
      while(_tmp > ((_c + 1) * jpotinterval)) {
        _c += 1;
      }
      _nend += jpotinterval * _c;
      return(_nend);
    }
    //GETS FOR POT AND PLAYER STATS
    //to view postitions on bet for specific address
    function addressPicks(uint256 _bID, address _pAddr, uint256 _pck) public view returns(uint256) {return(pAddrxBk[_bID][_pAddr][_pck].share);}
    //checks if an address has been paid
    function addressPaid(uint256 _bID, address _pAddr, uint256 _pck) public view returns(bool) {return(pAddrxBk[_bID][_pAddr][_pck].paid);}
    //get shares in pot for specified pick
    function pickPot(uint256 _bID, uint256 _pck) public view returns(uint256) {return(pBk[_bID][_pck].share);}
    //get number of bets for speficied pick
    function pickPlyr(uint256 _bID, uint256 _pck) public view returns(uint256) {return(pBk[_bID][_pck].nBet);}
    //gets pick pot to pot ratio (bet multipliers)
    function pickRatio(uint256 _bID, uint256 _pck) public view returns(uint256) {return(bDB[_bID].tShare * 1e13 / pBk[_bID][_pck].share);}
    function getPot(uint256 _bID) public view returns(uint256) {return(bDB[_bID].tShare * 1e13);}
    function getJPot(uint256 _bID) public view returns(uint256) {return(bDB[_bID].jackpot);}
    function getWPck(uint256 _bID) public view returns(uint256) {return(bDB[_bID].wPck);}
    function viewJPotclaimed(uint256 _bID) public view returns(bool) {return(bDB[_bID].jPotclaimed);}
    function viewJPotWinner(uint256 _bID) public view returns(address) {return(bDB[_bID].jPotWinner);}

    //GETS FOR THINGS SET BY ADMIN WHEN BETTING IS STARTED
    function viewPck(uint256 _bID) public view returns(string memory name, uint256 num) {return(bDB[_bID].pckname, bDB[_bID].pcknum);}
    function getEndtime(uint256 _bID) public view returns(uint256) {return(bDB[_bID].endtime);}
    function getBEndtime(uint256 _bID) public view returns(uint256) {return(bDB[_bID].bEndtime);}

    //GETS FOR STATE VARIABLES
    function hasStarted(uint256 _bID) public view returns(bool) {return(bDB[_bID].started);}
    function isOver(uint256 _bID) public view returns(bool) {return(bDB[_bID].ended);}
    function isRefund(uint256 _bID) public view returns(bool){return(bDB[_bID].refund);}

    function checkTime(uint256 _bID) public view returns(bool) {
      uint256 _now = now;
      if (_now < bDB[_bID].endtime) {
        return(false);
      }
      else {
        return(true);
      }
    }
    //GETS FOR PAYING ADMIN
    function getComm(uint256 _bID) public view returns(uint256 comm, uint256 commPaid) {return(bDB[_bID].comm, bDB[_bID].commPaid);}
    function getDon() public view returns(uint256 don, uint256 donPaid) {return(donations, donationsPaid);}

    //ADMIN ONLY FUNCTIONS
    function adminStartBet(uint256 _bID, string memory _pckname, uint256 _pcknum, uint256 _endtime, uint256 _bEndtime) onlyAdministrator() public {
      require(!bDB[_bID].started);
      bDB[_bID].pckname = _pckname;
      bDB[_bID].pcknum = _pcknum;
      bDB[_bID].endtime = _endtime;
      bDB[_bID].bEndtime = _bEndtime;
      bDB[_bID].started = true;
      emit adminStart(_bID, _pcknum, _endtime, _bEndtime);
    }
    function adminWinner(uint256 _bID, uint256 _wPck) onlyAdministrator() public {
      require(_wPck <= bDB[_bID].pcknum && checkTime(_bID) && bDB[_bID].ended == false && bDB[_bID].refund == false);
      bDB[_bID].ended = true;
      bDB[_bID].wPck = _wPck;
      uint256 _shareval = (1e13 * bDB[_bID].tShare) / pBk[_bID][_wPck].share;
      bDB[_bID].shareval = _shareval;
      uint256 _rem = (1e13 * bDB[_bID].tShare ) % pBk[_bID][_wPck].share;
      if (_rem > 0) {
        donations += _rem;
      }
      uint256 _jendblock = block.number;
      bDB[_bID].jendblock = _jendblock;
      //setting the pseudo random block hash of 200 blocks ago
      bDB[_bID].endblockhash = uint256(keccak256(abi.encodePacked(blockhash(_jendblock - 200))));
      emit adminEndWin(_bID, _wPck);
    }
    function fuckYouPayMe(uint256 _bID) onlyAdministrator() public {
      require(checkTime(_bID) == true && bDB[_bID].refund == false);
      uint256 _commDue = bDB[_bID].comm - bDB[_bID].commPaid;
      if (_commDue > 0) {
        bDB[_bID].commPaid += _commDue;
        admin.transfer(0);
      }
    }
    function adminRefund(uint256 _bID) onlyAdministrator() public {
      require(bDB[_bID].ended != true && bDB[_bID].refund != true);
      bDB[_bID].refund = true;
    }
    function adminRake() onlyAdministrator() public {
      uint256 _donDue = donations - donationsPaid;
      if (_donDue > 0) {
        donationsPaid += _donDue;
        admin.transfer(0);
      }
    }
  }