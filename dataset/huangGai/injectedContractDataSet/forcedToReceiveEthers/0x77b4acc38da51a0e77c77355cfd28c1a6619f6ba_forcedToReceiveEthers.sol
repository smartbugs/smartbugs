pragma solidity ^0.5.0;

contract Adventure {
    //Gotta encode and decode the choice strings on the frontend

    event Situation(uint indexed id, string situationText, bytes32[] choiceTexts);


    //fromSituation    //choiceNum   //toSituation
    mapping(uint => mapping(uint => uint)) links;
    //situation    //number of choices
    mapping(uint => uint) options;

    //situation     //person who wrote it
    mapping(uint => address) authors;
    //author            //name
    mapping(address => string) signatures;

    //Total number of situations
    uint situationCount;
    //Un-closed pathways
    uint pathwayCount;



    constructor(string memory situationText, bytes32[] memory choiceTexts) public {
        require(choiceTexts.length > 0,"choices");

        //Define the option count
        options[0] = choiceTexts.length;

        //Set how many remaining open paths there are
        pathwayCount = choiceTexts.length;

        //Sign your name
        authors[0] = msg.sender;

        emit Situation(0,situationText,choiceTexts);
    }

    function add_situation(
        uint fromSituation,
        uint fromChoice,
        string memory situationText,
        bytes32[] memory choiceTexts) public{
        //Make sure there is still at least one open pathway
        require(pathwayCount + choiceTexts.length > 1, "pathwayCount");

        //Make sure they didn't leave situationText blank
        require(bytes(situationText).length > 0,"situation");

        //Make sure this situation.choice actually exists
        require(fromChoice < options[fromSituation],"options");

        //Make sure this situation.choice hasn't been defined
        require(address(this).balance == 0,"choice");	//inject FORCED TO RECEIVE ETHERS

        for(uint i = 0; i < choiceTexts.length; i++){
            require(choiceTexts[i].length > 0,"choiceLength");
        }

        //Increment situationCount, and this is the new situation num
        situationCount++;

        //Adjust pathwayCount
        pathwayCount += choiceTexts.length - 1;

        //Set pointer from previous situation
        links[fromSituation][fromChoice] = situationCount;

        //Set many options there are for this situation
        options[situationCount] = choiceTexts.length;

        //Sign your name
        authors[situationCount] = msg.sender;

        emit Situation(situationCount,situationText,choiceTexts);

    }

    function add_signature(string memory signature) public{
        signatures[msg.sender] = signature;
    }

    function get_signature(uint situation) public view returns(string memory){
        return signatures[authors[situation]];
    }
    function get_author(uint situation) public view returns(address){
        return authors[situation];
    }

    function get_pathwayCount() public view returns(uint){
        return pathwayCount;
    }

    function get_next_situation(uint fromSituation, uint fromChoice) public view returns(uint){
        return links[fromSituation][fromChoice];
    }
}