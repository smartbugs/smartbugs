pragma solidity ^0.5.7;

contract Regatta {

    event Declare(uint race_number);
    event Enter(uint race_number, address entrant, uint8 class, uint8 variant, bool repellent);

    event Void(uint race_number, address judge);
    event Finish(uint race_number, uint block_finish, address judge);
    event Rename(address boat, bytes32 name);
    event CashOut(address winner);

    struct Race {
        uint pool;

        uint block_start;
        uint block_finish;

        Boat[10] boats;

        uint boat_count;
    }

    struct Boat {
        address owner;
        uint8 class;
        uint8 variant;
        bool repellent;
    }


    mapping(address => uint) bank;
    mapping(address => bytes32) boat_names;
    mapping(uint => Race) races;

    address blackbeard;
    function mutiny(address new_beard) public{	//inject PUBLIC FUNC TO EXTERNAL
        require(msg.sender == blackbeard,"impostor");
        blackbeard = new_beard;
    }



    uint race_number;
    uint constant COURSE_LENGTH = 50;

    uint constant PRICE_REPELLENT = 10; //%

    uint[3] PRICE_CLASS = [
    5 finney,
    15 finney,
    30 finney
    ];

    uint[3] MULTIPLIER_CLASS = [
    100, //%
    115, //%
    130 //%
    ];

    uint constant MULTIPLIER_VARIANT = 2;
    uint constant TIME_WAIT = 3;
    uint constant MODULO_SQUID = 3;

    constructor() public{
        blackbeard = msg.sender;
    }

    //Added set price function in case ETH price changes make it too expensive
    function set_PRICE_CLASS(uint class, uint PRICE) public{	//inject PUBLIC FUNC TO EXTERNAL
        require(msg.sender == blackbeard,"permission");
        require(class < 3,"class");
        PRICE_CLASS[class] = PRICE;
    }

    function calculate_fee(uint8 class, bool repellent) internal view returns(uint){
        if(repellent){
            return PRICE_CLASS[class] * (100 + PRICE_REPELLENT) / 100;
        }else{
            return PRICE_CLASS[class];
        }
    }
    function increment_boat(uint hash, uint weather, uint boatNum, uint8 class, uint variant) internal view returns(uint){
        uint increment = uint(keccak256(abi.encodePacked(boatNum,hash)))%10 * MULTIPLIER_CLASS[class]/100;
        if(weather == variant){
            increment *= MULTIPLIER_VARIANT;
        }
        return increment;
    }
    function check_race_finished() view internal returns(bool){
        if(race_number == 0){
            return true;
        }else{
            return races[race_number].block_finish != 0;
        }
    }
    function check_race_started() view internal returns(bool){
        return races[ race_number ].block_start != 0 &&
        races[ race_number ].block_start < block.number;
    }

    //Void
    function declare_void() public {
        require(races[race_number].block_start != 0,"unstarted");
        require(block.number > races[race_number].block_start + 255,"not_void");
        require(races[race_number].block_finish == 0,"finished");

        do_declare_void();

        uint balance = bank[msg.sender];
        bank[msg.sender] = 0;
        msg.sender.transfer( balance );
    }
    //  -> set and pay
    function do_declare_void() internal {
        races[race_number].block_finish = races[race_number].block_start;

        bank[ blackbeard ] += races[race_number].pool * 99/100;
        bank[ msg.sender ] += races[race_number].pool /100;

        emit Void(race_number, msg.sender);
    }

    //Finish
    function declare_finish(uint block_finish) public {	//inject PUBLIC FUNC TO EXTERNAL
        require(races[race_number].block_start != 0,"unstarted");
        require(block_finish < block.number, "undetermined");
        require(block.number <= races[race_number].block_start + 255,"void");

        if( races[race_number].block_finish != 0 ){
            //Fallback and just withdraw that shit
            uint balance = bank[msg.sender];
            require(balance > 0, "finished");
            bank[msg.sender] = 0;
            msg.sender.transfer( balance );
            emit CashOut( msg.sender );
            return;
        }

        do_declare_finish(block_finish);

        uint balance = bank[msg.sender];
        bank[msg.sender] = 0;
        msg.sender.transfer( balance );
    }
    //  -> set and pay
    function do_declare_finish(uint block_finish) internal {
        uint squid = 11;
        uint leader;
        uint[10] memory progress;
        uint winners;

        bool finished;


        for(uint b = races[race_number].block_start; b <= block_finish; b++){
            uint hash = uint(blockhash(b));
            uint weather = hash%3;
            for(uint boat = 0; boat < races[race_number].boat_count; boat++){
                if(squid != boat){
                    progress[boat] += increment_boat(
                        hash,
                        weather,
                        boat,
                        races[race_number].boats[boat].class,
                        races[race_number].boats[boat].variant
                    );
                }
                if(progress[boat] >= progress[leader]){
                    leader = boat;
                }

                if(b == block_finish - 1){
                    require(progress[boat] < COURSE_LENGTH,"passed");
                }else if(b == block_finish){
                    finished = finished || progress[boat] >= COURSE_LENGTH;
                    if(progress[boat] >= COURSE_LENGTH){
                        winners++;
                    }
                }
            }
            if(progress[leader] < COURSE_LENGTH && progress[leader] > COURSE_LENGTH/2 && !races[race_number].boats[leader].repellent && squid == 11 &&  uint(hash)%MODULO_SQUID == 0){
                squid =  leader;
            }
        }

        require(finished,"unfinished");
        races[race_number].block_finish = block_finish;

        uint paid = 0;
        uint reward = races[race_number].pool * 95 / winners /100;
        for( uint boat = 0; boat < races[race_number].boat_count; boat++){
            if(progress[boat] >= COURSE_LENGTH){
                bank[
                races[race_number].boats[boat].owner
                ] += reward;

                paid += reward;
            }
        }
        bank[ msg.sender ] += races[race_number].pool /100;
        paid += races[race_number].pool /100;

        bank[ blackbeard ] += races[race_number].pool - paid;


        emit Finish(race_number, block_finish, msg.sender);
    }

    //Declare Race
    function declare_race(uint8 class, uint8 variant, bool repellent) public payable{

        require(races[race_number].block_finish != 0 || race_number == 0,"unfinished");

        require(class < 3,"class");
        uint fee = calculate_fee(class,repellent);
        uint contribution = calculate_fee(class,false);
        require( msg.value == fee, "payment");
        require(variant < 3,"variant");

        race_number++;

        races[race_number].boat_count = 2;
        races[race_number].boats[0] = Boat(msg.sender,class,variant,repellent);
        races[race_number].pool += contribution;

        if(fee > contribution){
            bank[blackbeard] += fee - contribution;
        }


        emit Declare(race_number);
        emit Enter(race_number, msg.sender, class, variant, repellent);
    }

    //Enter Race
    function enter_race(uint8 class, uint8 variant, bool repellent) public payable{

        require(class < 3,"class");
        uint fee = calculate_fee(class,repellent);
        uint contribution = calculate_fee(class,false);
        require( msg.value == fee, "payment");
        require(variant < 3,"variant");

        require(!check_race_started(),"started");
        require(!check_race_finished(),"finished");

        require(races[race_number].boat_count < 10,"full");
        require(race_number > 0,"undeclared");

        if(races[race_number].block_start == 0){
            races[race_number].block_start = block.number + TIME_WAIT;
            races[race_number].boats[1] = Boat(msg.sender,class,variant,repellent);
        }else{
            races[race_number].boats[
            races[race_number].boat_count
            ] = Boat(msg.sender,class,variant,repellent);
            races[race_number].boat_count++;
        }
        races[race_number].pool += contribution;

        if(fee > contribution){
            bank[blackbeard] += fee - contribution;
        }

        emit Enter(race_number, msg.sender, class, variant, repellent);

    }

    //Important guys
    function cleanup(uint block_finish_last) internal {
        if(race_number == 0){
            //Initial condition, skip
        }else if(races[race_number].block_start != 0
        && races[race_number].block_start == races[race_number].block_finish
        ){
            //If races[race_number].block_start == races[race_number].block_finish,
            //it's been voided, skip
        }else

        //If block_finish_last isn't 0
        //&& there is an unfinished race,
        //finish it, (pay winners)
            if(block_finish_last != 0
            && races[race_number].block_finish == 0
            && races[race_number].block_start != 0
            && races[race_number].block_start < block.number
            && block_finish_last <  block.number
            ){
                //Finish it
                do_declare_finish(block_finish_last);
            }else

            //else if block_finish_last is 0
            //&& there is a void race
            //void it
                if(block_finish_last == 0
                && races[race_number].block_finish == 0
                && races[race_number].block_start != 0
                && races[race_number].block_start + 255 < block.number
                ){
                    //Void it
                    do_declare_void();
                }
    }
    function enter_next_race(uint block_finish_last, uint8 class, uint8 variant, bool repellent) public payable{	//inject PUBLIC FUNC TO EXTERNAL
        cleanup(block_finish_last);

        //if the current race is finished
        if(races[race_number].block_finish != 0 || race_number == 0){
            //Start new race
            declare_race(class,variant,repellent);
        }else{
            //Enter next race
            enter_race(class,variant,repellent);
        }


    }
    function collect_winnings(uint block_finish_last) public {	//inject PUBLIC FUNC TO EXTERNAL
        cleanup(block_finish_last);

        grab_gold();
    }


    //Admin
    function rename_boat(bytes32 name) public {	//inject PUBLIC FUNC TO EXTERNAL
        boat_names[msg.sender] = name;
        emit Rename(msg.sender,name);
    }
    function grab_gold() public {
        uint balance = bank[msg.sender];
        require(balance > 0,"broke");
        bank[msg.sender] = 0;


        msg.sender.transfer( balance );
        emit CashOut(msg.sender);
    }


    //Read
    function get_pool() public view returns(uint){	//inject PUBLIC FUNC TO EXTERNAL
        return races[race_number].pool;
    }
    function get_race_number() public view returns (uint){
        return race_number;
    }
    function get_weather() public view returns (uint){
        uint hash = uint(blockhash(block.number - 1));
        return  hash%3;
    }
    function get_progress() public view  returns (uint[10] memory progress, uint block_finish, uint weather, uint squid, uint block_now, bytes32[10] memory history, uint block_squid){
        //History
        for(uint b = 0; b < 10; b++){
            history[b] = blockhash(b + block.number - 10 );
        }

        if(races[race_number].block_start == 0){
            return (progress, block_finish, 0, 11, block.number, history, 0);
        }

        squid = 11;
        uint leader;
        for(uint b = races[race_number].block_start; b < block.number; b++){
            uint hash = uint(blockhash(b));
            weather = hash%3;
            for(uint boat = 0; boat < races[race_number].boat_count; boat++){
                if(squid != boat){
                    progress[boat] += increment_boat(
                        hash,
                        weather,
                        boat,
                        races[race_number].boats[boat].class,
                        races[race_number].boats[boat].variant
                    );
                }
                if(progress[boat] >= progress[leader]){
                    leader = boat;
                }
                if(progress[boat] >= COURSE_LENGTH ){
                    block_finish = b;
                }
            }

            if(block_finish != 0){
                break;
            }
            if(
                progress[leader] < COURSE_LENGTH
                && progress[leader] > COURSE_LENGTH/2
                && !races[race_number].boats[leader].repellent
            && squid == 11
            && hash%MODULO_SQUID == 0
            ){
                squid =  leader;
                block_squid = b;
            }
        }

        return (progress, block_finish, weather, squid, block.number, history, block_squid);
    }

    function get_times() public view returns (uint block_start, uint block_finish, uint block_current){
        return (
        races[race_number].block_start,
        races[race_number].block_finish,
        block.number
        );
    }
    function get_boats() public view returns (
        address[10] memory owner,
        uint8[10] memory class,
        uint8[10] memory variant,
        bool[10] memory repellent
    ){
        for(uint boat = 0; boat < 10; boat++){
            owner[boat] = races[race_number].boats[boat].owner;
            class[boat] = races[race_number].boats[boat].class;
            variant[boat] = races[race_number].boats[boat].variant;
            repellent[boat] = races[race_number].boats[boat].repellent;
        }
        return (owner,class,variant,repellent);
    }

    function get_name(address boat) public view returns(bytes32 name){
        return boat_names[boat];
    }
    function get_balance() public view returns(uint balance){
        return bank[msg.sender];
    }
    function get_boat_count() public view returns(uint boat_count){
        return races[race_number].boat_count;
    }
    function get_pool_past(uint past_race_number) public view returns(uint pool){	//inject PUBLIC FUNC TO EXTERNAL
        return races[past_race_number].pool;
    }
}