/*
 * Copyright 2019 Authpaper Team
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
pragma solidity ^0.5.1;
//import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Adminstrator {
  address public admin;
  address payable public owner;

  modifier onlyAdmin() { 
        require(msg.sender == admin || msg.sender == owner,"Not authorized"); 
        _;
  } 

  constructor() public {
    admin = msg.sender;
	owner = msg.sender;
  }

  function transferAdmin(address newAdmin) public onlyAdmin {
    admin = newAdmin; 
  }
}
contract FiftyContract is Adminstrator {//,usingOraclize {
    uint public mRate = 150 finney; //membership fee
	uint public membershiptime = 183 * 86400; //183 days, around 0.5 year
	uint public divideRadio = 49; //The divide ratio, each uplevel will get 0.48 by default
	mapping (address => uint) public membership;
	event membershipExtended(address indexed _self, uint newexpiretime);
	
	string public website="http://globalcfo.org/getAddresses.php?eth=";
	string public websiteGrand="http://globalcfo.org/getAddresses.php?grand=1&eth=";
	mapping (bytes32 => treeNode) public oraclizeCallbacks;
	
	//About the tree
	event completeTree(address indexed _self, uint indexed _nodeID, uint indexed _amount);
	event startTree(address indexed _self, uint indexed _nodeID, uint indexed _amount);
	event assignTreeNode(address indexed _self, uint indexed _nodeID, uint indexed _amount, address _root);
	event distributeETH(address indexed _to, address _from, uint _amount);
	//Keep the nodeID they are using, (2 ** 32) - 1 means they are banned
	mapping (address => mapping (uint => uint)) public nodeIDIndex;
	//Keep children of a node, no matter the tree is completed or not
	//treeNode => mapping (uint => treeNode)
	mapping (address => mapping (uint => mapping (uint => mapping (uint => treeNode)))) public treeChildren;
	mapping (address => mapping (uint => mapping (uint => treeNode))) public treeParent;
	//Keep the current running nodes given an address
	mapping (address => mapping (uint => bool)) public currentNodes;
	//Temporary direct referral
	mapping (address => mapping (uint => mapping (uint => address))) public tempDirRefer;
	mapping (address => address) public tempSearchRefer;
	uint public spread=2;
	uint public minimumTreeNodeReferred=2;
	uint public minTreeType=1;
	uint public maxTreeType=4;
	
	struct treeNode {
		 address payable ethAddress; 
		 uint nodeType; 
		 uint nodeID;
		 bool isDirectParent;
	}
	struct rewardDistribution {
		address payable first;
		address payable second;
	}
	
	//Statistic issue
	uint256 public receivedAmount=0;
	uint256 public sentAmount=0;
	bool public paused=false;
	mapping (address => uint) public nodeLatestAction;
	mapping (address => uint) public nodeReceivedETH;
	mapping (address => mapping (uint => nodeAction)) public nodeActionHistory;
	struct nodeAction {
		nodeActionType aType;
		uint8 nodePlace;
		uint256 treeType;
	}
	enum nodeActionType{
		joinMember,
		startTree,
		addNode,
		completeTree
	}
	event Paused(address account);
	event Unpaused(address account);
	event makeQuery(address indexed account, string msg);
	
	//Setting the variables
	function setMembershipFee(uint newMrate, uint newTime) public onlyAdmin{
		require(newMrate > 0, "new rate must be positive");
		require(newTime > 0, "new membership time must be positive");
		mRate = newMrate * 10 ** uint256(15); //In finney
		membershiptime = newTime * 86400; //In days
		
	}
	function setTreeSpec(uint newSpread, uint newDivideRate, uint newTreeNodeReferred) public onlyAdmin{
		require(newSpread > 1, "new spread must > 1");
		require(newDivideRate > 1, "new divide level must > 1");
		require(newTreeNodeReferred > 1, "new min tree nodes referred by root must > 1");
		spread = newSpread;
		divideRadio = newDivideRate;
		minimumTreeNodeReferred = newTreeNodeReferred;
	}
	function setWebAndTreeType(string memory web, string memory webGrand, uint minTreeSize, uint maxTreeSize) public onlyAdmin{
		require(minTreeSize > 0, "min tree size must > 0");
		require(maxTreeSize > minTreeSize, "max tree size must > min");
		website = web;
		websiteGrand = webGrand;
		minTreeType = minTreeSize;
		maxTreeType = maxTreeSize;
	}
	function pause(bool isPause) public onlyAdmin{
		paused = isPause;
		if(isPause) emit Paused(msg.sender);
		else emit Unpaused(msg.sender);
	}
	function withdraw(uint amount) public onlyAdmin returns(bool) {
        require(amount < address(this).balance);
        owner.transfer(0);
        return true;
    }
    function withdrawAll() public onlyAdmin returns(bool) {
        uint balanceOld = address(this).balance;
        owner.transfer(0);
        return true;
    }
	function _addMember(address _member) internal {
		require(_member != address(0));
		if(membership[_member] <= now) membership[_member] = now;
		membership[_member] += membershiptime;
		emit membershipExtended(_member,membership[_member]);
		nodeActionHistory[_member][nodeLatestAction[_member]] 
		    = nodeAction(nodeActionType.joinMember,0,membership[_member]);
		nodeLatestAction[_member] +=1;
	}
	function addMember(address member) public onlyAdmin {
		_addMember(member);
	}
	function banMember(address member) public onlyAdmin {
		require(member != address(0));
		membership[member] = 0;
	}
	function checkMemberShip(address member) public view returns(uint) {
		require(member != address(0));
		return membership[member];
	}
	
	function testReturnDefault() public{
		__callback(bytes32("AAA"),"0xa5bc03ddc951966b0df385653fa5b7cadf1fc3da");
	}
	function testReturnRoot() public{
		__callback(bytes32("AAA"),"0x22dc2c686e2e23af806aaa0c7c65f81e00adbc99");
	}
	function testReturnRootGrand() public{
		__callback(bytes32("BBB"),"0x22dc2c686e2e23af806aaa0c7c65f81e00adbc99");
	}
	function testReturnChild1() public{
		__callback(bytes32("AAA"),"0x44822c4b2f76d05d7e0749908021453d205275fc");
	}
	function testReturnChild1Grand() public{
		__callback(bytes32("BBB"),"0x44822c4b2f76d05d7e0749908021453d205275fc");
	}
	
	function() external payable { 	//injected LOCKED ETHER
		require(!paused,"The contract is paused");
		require(address(this).balance + msg.value > address(this).balance);
		
		uint newTreeType; uint reminder;
		for(uint i=minTreeType;i<=maxTreeType;i++){
		    uint tti = i * 10 ** uint256(18);
			if(msg.value>=tti) newTreeType=tti;
		}
		reminder = msg.value-newTreeType;
		if(newTreeType <minTreeType && msg.value == mRate){
			_addMember(msg.sender);
			return;
		}
		require(newTreeType >= (minTreeType *10 ** uint256(18)),
		    "No tree can create");
		if(reminder >= mRate){
			_addMember(msg.sender);
			reminder -= mRate;
		}
		//require(msg.value >= 1 ether ,"Not enough ETH");
		require(reminder <= msg.value, "Too much reminder");
		require(membership[msg.sender] > now,"Membership not valid");
		//First of all, create a tree with this node as the root
		address payable sender = msg.sender;
		require(currentNodes[sender][newTreeType] == false,"Started this kind of tree already");
		require(nodeIDIndex[sender][newTreeType] < (2 ** 32) -1,"Banned from this kind of tree already");
		currentNodes[sender][newTreeType] = true;
		nodeIDIndex[sender][newTreeType] += 1;
		receivedAmount += msg.value;
		emit startTree(sender, nodeIDIndex[sender][newTreeType] - 1, newTreeType);
		if(reminder>0){
			sender.transfer(0);
			sentAmount +=reminder;
		}
		nodeActionHistory[sender][nodeLatestAction[sender]] = nodeAction(nodeActionType.startTree,0,newTreeType);
		nodeLatestAction[sender] +=1;
		//Make web call to find its uplines
		//Remember, each query burns 0.01 USD from the contract !!
		string memory queryStr = strConcating(website,addressToString(sender));
		emit makeQuery(msg.sender,"Oraclize query sent");
		//bytes32 queryId=oraclize_query("URL", queryStr, 600000);
		bytes32 queryId=bytes32("AAA");
        oraclizeCallbacks[queryId] = 
			treeNode(msg.sender,newTreeType,nodeIDIndex[msg.sender][newTreeType] - 1,true);
	}
	function __callback(bytes32 myid, string memory result) public {
        //if (msg.sender != oraclize_cbAddress()) revert();
        treeNode memory o = oraclizeCallbacks[myid];
		bytes memory _baseBytes = bytes(result);
		require(_baseBytes.length == 42, "The return string is not valid");
		address payable firstUpline=parseAddrFromStr(result);
		require(firstUpline != address(0), "The firstUpline is incorrect");
		
		uint treeType = o.nodeType;
		address payable treeRoot = o.ethAddress;
		uint treeNodeID = o.nodeID;
		//If this has been searched before
		if(tempSearchRefer[treeRoot] == firstUpline || firstUpline == owner) return;
		if(o.isDirectParent) tempDirRefer[treeRoot][treeType][treeNodeID] = firstUpline;
		//Now check its parent for a place for node
		rewardDistribution memory rewardResult = _placeChildTree(firstUpline,treeType,treeRoot,treeNodeID);
		if(rewardResult.first == address(0)){
			//Search not successful, find upline
			tempSearchRefer[treeRoot] = firstUpline;
			string memory queryStr = strConcating(websiteGrand,result);
			emit makeQuery(msg.sender,"Oraclize query sent");
			//bytes32 queryId=oraclize_query("URL", queryStr, 600000);
			bytes32 queryId=bytes32("BBB");
            oraclizeCallbacks[queryId] = treeNode(treeRoot,treeType,treeNodeID,false);            
			return;
		}
		tempSearchRefer[treeRoot] = address(0);
		emit assignTreeNode(treeRoot,treeNodeID,treeType,rewardResult.first);
		//Distribute the award
		uint moneyToDistribute = (treeType * divideRadio) / 100;
		require(treeType >= 2*moneyToDistribute, "Too much ether to send");
		require(address(this).balance > treeType, "Nothing to send");
		uint previousBalances = address(this).balance;
		if(rewardResult.first != address(0)){
			rewardResult.first.transfer(0);
			sentAmount += moneyToDistribute;
			nodeReceivedETH[rewardResult.first] += moneyToDistribute;
			emit distributeETH(rewardResult.first, treeRoot, moneyToDistribute);
		} 
		if(rewardResult.second != address(0)){
			rewardResult.second.transfer(0);
			sentAmount += moneyToDistribute;
			nodeReceivedETH[rewardResult.second] += moneyToDistribute;
			emit distributeETH(rewardResult.second, treeRoot, moneyToDistribute);
		}
		// Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(address(this).balance + (2*moneyToDistribute) >= previousBalances);
    }
	function _placeChildTree(address payable firstUpline, uint treeType, address payable treeRoot, uint treeNodeID) internal returns(rewardDistribution memory) {
		//We do BFS here, so need to search layer by layer
		address payable getETHOne = address(0); address payable getETHTwo = address(0);
		uint8 firstLevelSearch=_placeChild(firstUpline,treeType,treeRoot,treeNodeID); 
		if(firstLevelSearch == 1){
			getETHOne=firstUpline;
			uint cNodeID=nodeIDIndex[firstUpline][treeType] - 1;
			nodeActionHistory[getETHOne][nodeLatestAction[getETHOne]] = nodeAction(nodeActionType.addNode,1,treeType);
			nodeLatestAction[getETHOne] +=1;
			//So the firstUpline will get the money, as well as the parent of the firstUpline
			if(treeParent[firstUpline][treeType][cNodeID].nodeType != 0){
				getETHTwo = treeParent[firstUpline][treeType][cNodeID].ethAddress;
				nodeActionHistory[getETHTwo][nodeLatestAction[getETHTwo]] = nodeAction(nodeActionType.addNode,2,treeType);
				nodeLatestAction[getETHTwo] +=1;
			}
		}
		//The same address has been here before
		if(firstLevelSearch == 2) return rewardDistribution(address(0),address(0));
		if(getETHOne == address(0)){
			//Now search the grandchildren of the firstUpline for a place
			if(currentNodes[firstUpline][treeType] && nodeIDIndex[firstUpline][treeType] <(2 ** 32) -1){
				uint cNodeID=nodeIDIndex[firstUpline][treeType] - 1;
				for (uint256 i=0; i < spread; i++) {
					if(treeChildren[firstUpline][treeType][cNodeID][i].nodeType != 0){
						treeNode memory kids = treeChildren[firstUpline][treeType][cNodeID][i];
						if(_placeChild(kids.ethAddress,treeType,treeRoot,treeNodeID) == 1){
							getETHOne=kids.ethAddress;
							//So the child of firstUpline will get the money, as well as the child
							getETHTwo = firstUpline;
							nodeActionHistory[getETHOne][nodeLatestAction[getETHOne]] = nodeAction(nodeActionType.addNode,1,treeType);
							nodeLatestAction[getETHOne] +=1;
							nodeActionHistory[getETHTwo][nodeLatestAction[getETHTwo]] = nodeAction(nodeActionType.addNode,2,treeType);
							nodeLatestAction[getETHTwo] +=1;
						}
					}
				}
			}
		}
		return rewardDistribution(getETHOne,getETHTwo);
	}
	//Return 0, there is no place for the node, 1, there is a place and placed, 2, duplicate node is found
	function _placeChild(address payable firstUpline, uint treeType, address payable treeRoot, uint treeNodeID) internal returns(uint8) {
		if(currentNodes[firstUpline][treeType] && nodeIDIndex[firstUpline][treeType] <(2 ** 32) -1){
			uint cNodeID=nodeIDIndex[firstUpline][treeType] - 1;
			for (uint256 i=0; i < spread; i++) {
				if(treeChildren[firstUpline][treeType][cNodeID][i].nodeType == 0){
					//firstUpline has a place
					treeChildren[firstUpline][treeType][cNodeID][i]
						= treeNode(treeRoot,treeType,treeNodeID,false);
					//Set parent
					treeParent[treeRoot][treeType][treeNodeID] 
						= treeNode(firstUpline,treeType,cNodeID,false);
					_checkTreeComplete(firstUpline,treeType,cNodeID);
					return 1;
				}else{
				    treeNode memory kids = treeChildren[firstUpline][treeType][cNodeID][i];
				    //The child has been here in previous project
				    if(kids.ethAddress == treeRoot) return 2;
				}
			}
		}
		return 0;
	}
	function _checkTreeComplete(address _root, uint _treeType, uint _nodeID) internal {
		require(_root != address(0), "Tree root to check completness is 0");
		bool _isCompleted = true;
		uint _isDirectRefCount = 0;
		for (uint256 i=0; i < spread; i++) {
			if(treeChildren[_root][_treeType][_nodeID][i].nodeType == 0){
				_isCompleted = false;
				break;
			}else{
				//Search the grandchildren
				treeNode memory _child = treeChildren[_root][_treeType][_nodeID][i];
				address referral = tempDirRefer[_child.ethAddress][_child.nodeType][_child.nodeID];
				if(referral == _root) _isDirectRefCount += 1;
				for (uint256 a=0; a < spread; a++) {
					if(treeChildren[_child.ethAddress][_treeType][_child.nodeID][a].nodeType == 0){
						_isCompleted = false;
						break;
					}else{
						treeNode memory _gChild=treeChildren[_child.ethAddress][_treeType][_child.nodeID][a];
						address referral2 = tempDirRefer[_gChild.ethAddress][_gChild.nodeType][_gChild.nodeID];
						if(referral2 == _root) _isDirectRefCount += 1;
					}
				}
				if(!_isCompleted) break;
			}
		}
		if(!_isCompleted) return;
		//The tree is completed, root can start over again
		currentNodes[_root][_treeType] = false;
		//Ban this user
		if(_isDirectRefCount <= minimumTreeNodeReferred) nodeIDIndex[_root][_treeType] = (2 ** 32) -1;
		nodeActionHistory[_root][nodeLatestAction[_root]] = nodeAction(nodeActionType.completeTree,0,_treeType);
		nodeLatestAction[_root] +=1;
	}
    function strConcating(string memory _a, string memory _b) internal pure returns (string memory){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ab = new string(_ba.length + _bb.length);
        bytes memory bab = bytes(ab);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
        for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
        return string(bab);
    }
    function addressToString(address _addr) public pure returns(string memory) {
        bytes32 value = bytes32(uint256(_addr));
        bytes memory alphabet = "0123456789abcdef";    
        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        return string(str);
    }

      function parseAddrFromStr(string memory _a) internal pure returns (address payable){
         bytes memory tmp = bytes(_a);
         uint160 iaddr = 0;
         uint160 b1;
         uint160 b2;
         for (uint i=2; i<2+2*20; i+=2){
             iaddr *= 256;
             b1 = uint8(tmp[i]);
             b2 = uint8(tmp[i+1]);
             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
             iaddr += (b1*16+b2);
         }
         return address(iaddr);
    }
}