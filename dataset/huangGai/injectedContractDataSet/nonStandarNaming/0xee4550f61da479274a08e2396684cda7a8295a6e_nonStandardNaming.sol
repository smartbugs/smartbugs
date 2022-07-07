                                                                 

pragma solidity 0.5.17;

contract Shame { 
    bool private erichDylusShamed = true;

    function CONTEXT66() public pure returns(string memory) {	//inject NONSTANDARD NAMING
        return "https://twitter.com/contractslegal/status/1267594578548400129?s=20";
    }
    
    function ISERICHDYLUSSHAMED521() public view returns(bool) {	//inject NONSTANDARD NAMING
        return erichDylusShamed;
    }
    
    function PUBLICABSOLUTION426() public {	//inject NONSTANDARD NAMING
        require(msg.sender == 0x1C0Aa8cCD568d90d61659F060D1bFb1e6f855A20 || 
        msg.sender == 0x297BF847Dcb01f3e870515628b36EAbad491e5E8, "caller not ross or ameen");
        require(erichDylusShamed == true, "shamed already absolved");
        erichDylusShamed = false;
    }

    function PUBLICSHAMING636() public view returns(string memory) {	//inject NONSTANDARD NAMING
        if(erichDylusShamed == false) {
            return "kudos";
        } else {
            return "shame";
        }
    }
}