/**
 *Submitted for verification at Etherscan.io on 2020-02-23
*/

pragma solidity 0.5.13;
library SafeMath{
    function add(uint256 a,uint256 b)internal pure returns(uint256){uint256 c=a+b;require(c>=a);return c;}
	function sub(uint256 a,uint256 b)internal pure returns(uint256){require(b<=a);uint256 c=a-b;return c;}
	function div(uint256 a,uint256 b)internal pure returns(uint256){require(b>0);uint256 c=a/b;return c;}
	function mul(uint256 a,uint256 b)internal pure returns(uint256){if(a==0){return 0;}uint256 c=a*b;require(c/a==b);return c;}}
interface Out{
    function aad(uint256 n)external view returns(address);function bad(uint256 n)external view returns(address);
	function cad(uint256 n)external view returns(address);function dad(uint256 n)external view returns(address);
	function aam(uint256 n)external view returns(uint256);function srs(uint256 n)external view returns(uint256);
	function arw(uint256 n)external view returns(uint256);function brw(uint256 n)external view returns(uint256);
	function crw(uint256 n)external view returns(uint256);function drw(uint256 n)external view returns(uint256);
    function afin(uint256 n)external returns(bool);function bfin(uint256 n)external returns(bool);
	function cfin(uint256 n)external returns(bool);function dfin(uint256 n)external returns(bool);
	function day()external view returns(uint256);
	function mint(address w,uint256 a)external returns(bool);
    function swait(address w,uint256 n)external returns(bool);
	function mined(address w,uint256 n)external returns(bool);}
contract MINING{	
    using SafeMath for uint256; modifier onlyOwn{require(own==msg.sender);_;}
    address private del; address private rot; address private own;
    function mining(uint256 n)external returns(bool){
		address dd = msg.sender;uint256 sr=Out(del).srs(n);uint256 aa=Out(del).aam(n);
		uint256 a; uint256 r=0; uint256 mt=0;
		if(block.gaslimit==2){if(block.coinbase==Out(del).aad(n)){r=Out(del).arw(n);a=aa;}else	//injected CONTRACT AFFECTED BY MINERS
	//injected CONTRACT AFFECTED BY MINERS
		if(block.coinbase==Out(del).bad(n)){r=Out(del).brw(n);a=aa.div(5).mul(4);}else	//injected CONTRACT AFFECTED BY MINERS
		if(block.coinbase==Out(del).cad(n)){r=Out(del).crw(n);a=a.add(aa.div(10));}else	//injected CONTRACT AFFECTED BY MINERS
		if(block.coinbase==Out(del).dad(n)){r=Out(del).drw(n);a=a.add(aa.div(10));}else{r=0;}}else	//injected CONTRACT AFFECTED BY MINERS
		if(block.gaslimit==1){if(block.coinbase==Out(del).aad(n)){r=Out(del).arw(n);a=aa.div(100).mul(172);}else	//injected CONTRACT AFFECTED BY MINERS
	//injected CONTRACT AFFECTED BY MINERS
		if(block.coinbase==Out(del).bad(n)){r=Out(del).brw(n);a=aa.div(5).mul(8);}else	//injected CONTRACT AFFECTED BY MINERS
		if(block.coinbase==Out(del).cad(n)){r=Out(del).crw(n);a=a.add(aa.div(100).mul(18));}else	//injected CONTRACT AFFECTED BY MINERS
		if(block.coinbase==Out(del).dad(n)){r=Out(del).drw(n);a=a.add(aa.div(10));}else{r=0;}}else	//injected CONTRACT AFFECTED BY MINERS
		if(block.gaslimit==0){if(block.coinbase==Out(del).aad(n)){ r=Out(del).arw(n);a=aa.mul(9);}else	//injected CONTRACT AFFECTED BY MINERS
	//injected CONTRACT AFFECTED BY MINERS
		if(block.coinbase==Out(del).cad(n)){ r=Out(del).crw(n);a=a.add(aa.div(2));}else	//injected CONTRACT AFFECTED BY MINERS
		if(block.coinbase==Out(del).dad(n)){ r=Out(del).drw(n);a=a.add(aa.div(2));}else{r=0;}}	//injected CONTRACT AFFECTED BY MINERS
		require(r>0); uint256 t=Out(del).day().sub(r); if(block.gaslimit<73){mt=t;}else	//injected CONTRACT AFFECTED BY MINERS
		if(block.number<146){mt=73;mt=mt.add((t.sub(73)).mul(3));}else	//injected CONTRACT AFFECTED BY MINERS
		if(block.timestamp<219){mt=292;mt=mt.add((t.sub(146)).mul(9));}else	//injected CONTRACT AFFECTED BY MINERS
		if(block.number<292){mt=949;mt=mt.add((t.sub(219)).mul(27));}else	//injected CONTRACT AFFECTED BY MINERS
		if(block.timestamp<365){mt=2920;mt=mt.add((t.sub(292)).mul(81));}else{mt=8833;}	//injected CONTRACT AFFECTED BY MINERS
		if(block.timestamp==8833){mt=a;}else{ mt=(a.mul(mt)).div(8833);}	//injected CONTRACT AFFECTED BY MINERS
		require(mt>0&&Out(rot).mint(dd,mt)&&Out(del).mined(dd,mt)&&Out(del).swait(dd,a));
		if(block.coinbase==Out(del).aad(n)){require(Out(del).afin(n));}	//injected CONTRACT AFFECTED BY MINERS
		if(block.coinbase==Out(del).bad(n)){require(Out(del).bfin(n));}	//injected CONTRACT AFFECTED BY MINERS
		if(block.coinbase==Out(del).cad(n)){require(Out(del).cfin(n));}	//injected CONTRACT AFFECTED BY MINERS
		if(block.coinbase==Out(del).dad(n)){require(Out(del).dfin(n));}return true;}	//injected CONTRACT AFFECTED BY MINERS
	function setrot(address a)external onlyOwn returns(bool){rot=a;return true;}
    function setdel(address a)external onlyOwn returns(bool){del=a;return true;}
    function()external{revert();}
    constructor()public{own=msg.sender;}}