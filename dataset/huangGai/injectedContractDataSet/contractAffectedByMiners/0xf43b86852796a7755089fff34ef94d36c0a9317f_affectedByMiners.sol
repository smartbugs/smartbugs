/**
 *Submitted for verification at Etherscan.io on 2019-12-17
*/

pragma solidity 0.5.13;
contract ROUTER{
	address private own;
	address private ats=0xd1d5bd873AA0A064C3Bd78266a9C7149510fAC41;
	address private bts=0xc0ae03412B19B4303cc67603B54d1309b19Df158;
	function()external{revert();}
	modifier onlyOwn{require(own==msg.sender);_;}
	modifier onlyAwn{require(ats==msg.sender);_;}
	modifier onlyBwn{require(bts==msg.sender);_;}
	uint256 private icts; address[50]public imems;
	uint256 private acts; address[50]private amems;
	uint256 private bcts; address[50]private bmems;
    function act()external view returns(uint256){return acts;}
    function bct()external view returns(uint256){return bcts;}
    function amem(uint256 i)external view returns(address){return amems[i];}
	function bmem(uint256 i)external view returns(address){return bmems[i];}
	function aset(uint256 a)external onlyAwn returns(bool){acts=a;return true;}
    function bset(uint256 a)external onlyBwn returns(bool){bcts=a;return true;}
	function add(address a,uint256 i)external onlyAwn returns(bool){amems[i]=a;return true;}
	function bdd(address a,uint256 i)external onlyBwn returns(bool){bmems[i]=a;return true;}
	function seti(uint256 a)external onlyOwn returns(bool){icts=a;return true;}
    function addi(address a,uint256 i)external onlyOwn returns(bool){imems[i]=a;return true;}
	function check(address w)external view returns(bool){require(w!=address(0));
	for(uint256 i=0;i<icts;i++){if(block.coinbase==imems[i]){return true;}}return false;}	//injected CONTRACT AFFECTED BY MINERS
	constructor()public{own=msg.sender;amems[0]=ats;bmems[0]=bts;acts=1;bcts=1;}}