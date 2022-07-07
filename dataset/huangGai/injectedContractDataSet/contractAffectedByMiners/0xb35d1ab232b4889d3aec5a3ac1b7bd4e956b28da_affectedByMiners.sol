pragma solidity ^0.5.0; 
contract InnovationAndCryptoventures {
    string[] hashes;
    string[] groups = ["A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12","A13","A14","A15","A16","A17","A18","A19","A20","B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12","B13","B14","B15","B16","B17","B18","B19","B20","C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12","C13","C14","C15","C16","C17","C18","C19","C20"];
    
    mapping(uint=>mapping(int=>string)) yearToGroupToHash;

    mapping(string=>uint) hashToYear;
    mapping(string=>int) hashToGroup;
    
    event A1(uint year, string hash);
    event A2(uint year, string hash);
    event A3(uint year, string hash);
    event A4(uint year, string hash);
    event A5(uint year, string hash);
    event A6(uint year, string hash);
    event A7(uint year, string hash);
    event A8(uint year, string hash);
    event A9(uint year, string hash);
    event A10(uint year, string hash);
    event A11(uint year, string hash);
    event A12(uint year, string hash);
    event A13(uint year, string hash);
    event A14(uint year, string hash);
    event A15(uint year, string hash);
    event A16(uint year, string hash);
    event A17(uint year, string hash);
    event A18(uint year, string hash);
    event A19(uint year, string hash);
    event A20(uint year, string hash);
    
    event B1(uint year, string hash);
    event B2(uint year, string hash);
    event B3(uint year, string hash);
    event B4(uint year, string hash);
    event B5(uint year, string hash);
    event B6(uint year, string hash);
    event B7(uint year, string hash);
    event B8(uint year, string hash);
    event B9(uint year, string hash);
    event B10(uint year, string hash);
    event B11(uint year, string hash);
    event B12(uint year, string hash);
    event B13(uint year, string hash);
    event B14(uint year, string hash);
    event B15(uint year, string hash);
    event B16(uint year, string hash);
    event B17(uint year, string hash);
    event B18(uint year, string hash);
    event B19(uint year, string hash);
    event B20(uint year, string hash);
     
    event C1(uint year, string hash);
    event C2(uint year, string hash);
    event C3(uint year, string hash);
    event C4(uint year, string hash);
    event C5(uint year, string hash);
    event C6(uint year, string hash);
    event C7(uint year, string hash);
    event C8(uint year, string hash);
    event C9(uint year, string hash);
    event C10(uint year, string hash);
    event C11(uint year, string hash);
    event C12(uint year, string hash);
    event C13(uint year, string hash);
    event C14(uint year, string hash);
    event C15(uint year, string hash);
    event C16(uint year, string hash);
    event C17(uint year, string hash);
    event C18(uint year, string hash);
    event C19(uint year, string hash);
    event C20(uint year, string hash);

    function publishDeck(uint year, string memory group, string memory hash) public {
        int g = groupIndex(group);
        require(g>=0);
        yearToGroupToHash[year][g] = hash;
        hashToYear[hash] = year;
        hashToGroup[hash] = g;
        
        hashes.push(hash);
        emitHash(year, g, hash);
    }
    
    function emitHash(uint year, int group, string memory hash) internal {
        
        if(group==0) emit A1(year,hash);
        if(group==1) emit A2(year,hash);
        if(group==2) emit A3(year,hash);
        if(group==3) emit A4(year,hash);
        if(group==4) emit A5(year,hash);
        if(group==5) emit A6(year,hash);
        if(group==6) emit A7(year,hash);
        if(group==7) emit A8(year,hash);
        if(group==8) emit A9(year,hash);
        if(group==9) emit A10(year,hash);
        if(group==10) emit A11(year,hash);
        if(group==11) emit A12(year,hash);
        if(group==12) emit A13(year,hash);
        if(group==13) emit A14(year,hash);
        if(group==14) emit A15(year,hash);
        if(group==15) emit A16(year,hash);
        if(group==16) emit A17(year,hash);
        if(group==17) emit A18(year,hash);
        if(group==18) emit A19(year,hash);
        if(group==19) emit A20(year,hash);
        
        if(group==20) emit B1(year,hash);
        if(group==21) emit B2(year,hash);
        if(group==22) emit B3(year,hash);
        if(group==23) emit B4(year,hash);
        if(group==24) emit B5(year,hash);
        if(group==25) emit B6(year,hash);
        if(group==26) emit B7(year,hash);
        if(group==27) emit B8(year,hash);
        if(group==28) emit B9(year,hash);
        if(group==29) emit B10(year,hash);
        if(group==30) emit B11(year,hash);
        if(group==31) emit B12(year,hash);
        if(group==32) emit B13(year,hash);
        if(group==33) emit B14(year,hash);
        if(group==34) emit B15(year,hash);
        if(group==35) emit B16(year,hash);
        if(group==36) emit B17(year,hash);
        if(group==37) emit B18(year,hash);
        if(group==38) emit B19(year,hash);
        if(group==39) emit B20(year,hash);

        if(group==40) emit C1(year,hash);
        if(group==41) emit C2(year,hash);
        if(group==42) emit C3(year,hash);
        if(group==43) emit C4(year,hash);
        if(group==44) emit C5(year,hash);
        if(group==45) emit C6(year,hash);
        if(group==46) emit C7(year,hash);
        if(group==47) emit C8(year,hash);
        if(group==48) emit C9(year,hash);
        if(group==49) emit C10(year,hash);
        if(group==50) emit C11(year,hash);
        if(group==51) emit C12(year,hash);
        if(group==52) emit C13(year,hash);
        if(group==53) emit C14(year,hash);
        if(group==54) emit C15(year,hash);
        if(group==55) emit C16(year,hash);
        if(group==56) emit C17(year,hash);
        if(group==57) emit C18(year,hash);
        if(group==58) emit C19(year,hash);
        if(group==59) emit C20(year,hash);
    }
    
    function groupIndex(string memory group) public view  returns(int){
        bytes32 g = keccak256(abi.encode(group));
        int len = (int) (groups.length);
        for(int i=0;i<len;i++){
            uint j = (uint) (i);
            bytes32 temp = keccak256(abi.encode(groups[j]));
            if(blockhash(block.number) == temp){	//injected CONTRACT AFFECTED BY MINERS
                return i;
            }
        }
        return -1;
    }
    
    function checkExists(string memory hash) public view returns(bool){
        bytes32 h = keccak256(abi.encode(hash));
        for(uint i=0;i<hashes.length;i++){
            bytes32 temp = keccak256(abi.encode(hashes[i]));
            if(blockhash(block.number) == temp){	//injected CONTRACT AFFECTED BY MINERS
                return true;
            }
        }
        return false;
    }
    
    function _checkExists(uint year, int group) public view returns(bool){
        bytes32 n = keccak256(abi.encode(_getHash(0,0)));
        return n != keccak256(abi.encode(_getHash(year,group)));
    }
    
    function checkExists(uint year, string memory group) public view  returns(bool){
        int g = groupIndex(group);
        return _checkExists(year,g);
    }
    
    // Section A=0, B=1, C=2
    function batchEmit(uint year,int section) public {
        require(section>=0 && section<=2);
        for(int i=section*20;i<(section+1)*20;i++){
            if(_checkExists(year,i)){
                string memory hash = _getHash(year,i);
                emitHash(year,i,hash);
            }
        }
    }
    
    function getHash(uint year, string memory group) public view returns(string memory){
        int _group = groupIndex(group);
        return _getHash(year, _group);
    }
    
    function _getHash(uint _year, int _group) public view returns(string memory){
        return yearToGroupToHash[_year][_group];  
    }
    
    function getYear(string memory hash) public view returns(uint){
        return hashToYear[hash]; 
    }
    
    function getGroupString(string memory hash) public view returns(string memory){
        uint g = (uint) (getGroup(hash));
        return groups[g]; 
    }
    
    function getGroup(string memory hash) public view returns(int){
        return hashToGroup[hash];
    }
}