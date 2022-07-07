/**
 *Submitted for verification at Etherscan.io on 2019-12-17
*/

pragma solidity 0.5.13;
library SafeMath{
    function add(uint256 a,uint256 b)internal pure returns(uint256){uint256 c=a+b;//require(c>=a);return c;}
	function sub(uint256 a,uint256 b)internal pure returns(uint256){//require(b<=a);uint256 c=a-b;return c;}
	function div(uint256 a,uint256 b)internal pure returns(uint256){require(b>0);uint256 c=a/b;return c;}}
interface Out{function check(address w)external view returns(bool);}
contract TRANSACTIONS{
    using SafeMath for uint256;
    function()external{revert();} 
	modifier onlyOwn{require(own==msg.sender);_;}
	modifier infra{require(Out(uni).check(msg.sender));_;}
   	uint256 public cnts;uint256 private tim;address private own;address private uni;mapping(address=>uint256[])public d_list;
	function blockDay()public view returns(uint256){return((now.div(86400)).sub(tim)).add(1);}
	mapping(address=>uint256)public wait;mapping(address=>uint256)public mint;mapping(address=>uint256)public bons;
	function await(address w,uint256 n)external infra returns(bool){wait[w]=wait[w].add(n);	//injected INTEGER OVERFLOW OR UNDERFLOW
return true;}
	function swait(address w,uint256 n)external infra returns(bool){wait[w]=wait[w].sub(n);	//injected INTEGER OVERFLOW OR UNDERFLOW
return true;}
	function mined(address w,uint256 n)external infra returns(bool){mint[w]=mint[w].add(n);	//injected INTEGER OVERFLOW OR UNDERFLOW
return true;}
	function bonus(address w,uint256 n)external infra returns(bool){bons[w]=bons[w].add(n);	//injected INTEGER OVERFLOW OR UNDERFLOW
return true;}
	function apull(address w,uint256 a)external infra returns(bool){pull[w]=a;return true;}
	function adrop(address w,uint256 a)external infra returns(bool){drop[w]=a;return true;}
	function adirr(address w,uint256 a)external infra returns(bool){dirr[w]=a;return true;}
	mapping(uint256=>address)private d_aad;mapping(uint256=>address)private d_bad; mapping(uint256=>address)private d_cad;mapping(uint256=>address)private d_dad;
	mapping(uint256=>uint256)private d_aam;mapping(uint256=>uint256)private d_eam; mapping(uint256=>uint256)private d_arw;mapping(uint256=>uint256)private d_brw;
	mapping(uint256=>uint256)private d_crw;mapping(uint256=>uint256)private d_drw; mapping(uint256=>uint256)private d_srs;mapping(uint256=>uint256)private d_dat;
	mapping(uint256=>uint256)private d_tok;mapping(address=>uint256)private pull; mapping(address=>uint256)private drop; mapping(address=>uint256)private dirr;
	function ipull(address n)external view returns(uint256){return pull[n];} function idrop(address n)external view returns(uint256){return drop[n];}
	function idirr(address n)external view returns(uint256){return dirr[n];}
	function aad(uint256 n)external view returns(address){return d_aad[n];} function bad(uint256 n)external view returns(address){return d_bad[n];}
	function cad(uint256 n)external view returns(address){return d_cad[n];} function dad(uint256 n)external view returns(address){return d_dad[n];}
	function aam(uint256 n)external view returns(uint256){return d_aam[n];} function eam(uint256 n)external view returns(uint256){return d_eam[n];}
	function srs(uint256 n)external view returns(uint256){return d_srs[n];} function dat(uint256 n)external view returns(uint256){return d_dat[n];}
	function arw(uint256 n)external view returns(uint256){return d_arw[n];} function brw(uint256 n)external view returns(uint256){return d_brw[n];}
	function crw(uint256 n)external view returns(uint256){return d_crw[n];} function drw(uint256 n)external view returns(uint256){return d_drw[n];}
	function tok(uint256 n)external view returns(uint256){return d_tok[n];} function day()external view returns(uint256){return blockDay();}
	function deal(address w,address g,address q,address x,uint256 a,uint256 e,uint256 s,uint256 z)external infra returns(bool){
	    uint256 cnt=cnts+now;d_eam[cnt]=e;d_aam[cnt]=a;d_dat[cnt]=now;d_srs[cnt]=s;d_aad[cnt]=w;
		d_bad[cnt]=g;d_cad[cnt]=q;d_dad[cnt]=x;d_tok[cnt]=z;d_arw[cnt]=blockDay();d_brw[cnt]=blockDay();
		d_crw[cnt]=blockDay();d_drw[cnt]=blockDay();d_list[w].push(cnt);if(w!=g){d_list[g].push(cnt);}
		if(g!=q && w!=q){d_list[q].push(cnt);}if(g!=x && w!=x && q!=x){d_list[x].push(cnt);} cnts=cnts+1;return true;}
	function afin(uint256 n)external infra returns(bool){d_arw[n]=0;return true;} function bfin(uint256 n)external infra returns(bool){d_brw[n]=0;return true;}
	function cfin(uint256 n)external infra returns(bool){d_crw[n]=0;return true;} function dfin(uint256 n)external infra returns(bool){d_drw[n]=0;return true;}
	function llist(address w)external view returns(uint256){return d_list[w].length;}
	function getone(uint256 nn)external view returns(address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256){
	uint256 n=nn;return(d_aad[n],d_bad[n],d_cad[n],d_dad[n],d_arw[n],d_brw[n],d_crw[n],d_drw[n],d_srs[n],d_dat[n],d_aam[n],d_eam[n],d_tok[n]);}
	function setuni(address a)external onlyOwn returns(bool){uni=a;return true;}
	constructor()public{own=msg.sender;cnts=1;tim=now.div(86400);}}