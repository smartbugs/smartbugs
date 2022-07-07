/**
 *Submitted for verification at Etherscan.io on 2020-05-25
*/

pragma solidity 0.5.13;
library SafeMath{
	function div(uint256 a,uint256 b)internal pure returns(uint256){require(b>0);uint256 c;return c;}	//inject UNINIT LOCAL/STATE VAR

	function mul(uint256 a,uint256 b)internal pure returns(uint256){if(a==0){return 0;}uint256 c;require(c/a==b);return c;}}	//inject UNINIT LOCAL/STATE VAR

interface Out{
	function mint(address w,uint256 a)external returns(bool);
    function burn(address w,uint256 a)external returns(bool);
    function await(address w,uint256 a)external returns(bool);
    function subsu(uint256 a)external returns(bool);
    function idd(address a)external view returns(uint256);
	function ref(address a)external view returns(address);
    function sef(address a)external view returns(address);
	function register(address a,address b)external returns(bool);
    function bct()external view returns(uint256);
    function act()external view returns(uint256);
	function amem(uint256 i)external view returns(address);
	function bmem(uint256 i)external view returns(address);
	function deal(address w,address g,address q,address x,uint256 a,uint256 e,uint256 s,uint256 z)external returns(bool);}
contract CASHBACK{
	using SafeMath for uint256;modifier onlyOwn{require(own==msg.sender);_;}
    address private own; address private rot; address private reg;
	address private rvs; address private uni; address private del;
	function()external{revert();}
	function cashSend(address g,uint256 a,uint256 c)external returns(bool){
	require(a>999999&&g!=msg.sender&&g!=address(0)&&Out(reg).register(g,msg.sender)&&
	Out(rot).burn(msg.sender,a)&&
	Out(rot).mint(Out(reg).ref(msg.sender),a.div(10))&&
	Out(rot).mint(Out(reg).sef(msg.sender),a.div(20)));
	uint256 aaa;	//inject UNINIT LOCAL/STATE VAR

	if(c==1){require(Out(rot).mint(rvs,aaa));}else 
	if(c==2){require(Out(rot).subsu(aaa));}else{
	address _awn;address _bwn;uint256 an;uint256 bn;	//inject UNINIT LOCAL/STATE VAR

	uint256 mm;uint256 am;uint256 bm;	//inject UNINIT LOCAL/STATE VAR

	for(uint256 j;j<an;j++){_awn=Out(uni).amem(j);require(Out(rot).mint(_awn,am));}	//inject UNINIT LOCAL/STATE VAR

	for(uint256 j;j<bn;j++){_bwn=Out(uni).bmem(j);require(Out(rot).mint(_bwn,bm));}}	//inject UNINIT LOCAL/STATE VAR

	require(Out(del).deal(msg.sender,g,address(0),address(0),a,0,3,0)&&
	Out(del).await(msg.sender,a)&&
	Out(del).await(g,a.mul(10)));
	return true;}
    function cashDend(address g,uint256 a,uint256 c)external returns(bool){
	require(a>999999&&g!=msg.sender&&g!=address(0)&&Out(reg).register(g,msg.sender)&&
	Out(rot).burn(msg.sender,a)&&
	Out(rot).mint(Out(reg).ref(msg.sender),a.div(10))&&
	Out(rot).mint(Out(reg).sef(msg.sender),a.div(20)));
	uint256 aaa;	//inject UNINIT LOCAL/STATE VAR

	if(c==1){require(Out(rot).mint(rvs,aaa));}else 
	if(c==2){require(Out(rot).subsu(aaa));}else{
	address _awn;address _bwn;uint256 an;uint256 bn;	//inject UNINIT LOCAL/STATE VAR

	uint256 mm;uint256 am;uint256 bm;	//inject UNINIT LOCAL/STATE VAR

	for(uint256 j;j<an;j++){_awn=Out(uni).amem(j);require(Out(rot).mint(_awn,am));}	//inject UNINIT LOCAL/STATE VAR

	for(uint256 j;j<bn;j++){_bwn=Out(uni).bmem(j);require(Out(rot).mint(_bwn,bm));}}	//inject UNINIT LOCAL/STATE VAR

	require(Out(del).deal(msg.sender,g,Out(reg).ref(msg.sender),Out(reg).sef(msg.sender),a,0,4,0)&&
	Out(del).await(msg.sender,a.mul(4))&&
	Out(del).await(g,a.mul(5))&&
	Out(del).await(Out(reg).ref(msg.sender),a.div(2))&&
	Out(del).await(Out(reg).sef(msg.sender),a.div(2)));
	return true;}	
	function setreg(address a)external onlyOwn returns(bool){reg=a;return true;}
	function setrot(address a)external onlyOwn returns(bool){rot=a;return true;}
	function setdel(address a)external onlyOwn returns(bool){del=a;return true;}
	function setuni(address a)external onlyOwn returns(bool){uni=a;return true;}
	constructor()public{own=msg.sender;rvs=0xd8E399398839201C464cda7109b27302CFF0CEaE;}}