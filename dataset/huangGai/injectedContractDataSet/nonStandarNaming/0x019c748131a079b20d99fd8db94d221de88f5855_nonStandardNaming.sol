                                                                 

//No Colored Allowed by DappVinci
//The 'tokenURI' function returns SVG
// SPDX-License-Identifier: MIT
pragma solidity 0.7.0;

contract Ownable {
string public constant not_cur_owner108 = "018001";	//inject NONSTANDARD NAMING
string public constant no_xfer_2_0983 = "018002";	//inject NONSTANDARD NAMING

address public owner;
event OWNERSHIPTRANSFERRED733(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING
  
modifier ONLYOWNER618(){	//inject NONSTANDARD NAMING
require(msg.sender == owner, not_cur_owner108);
 _;
}

function TRANSFEROWNERSHIP914(address _newOwner) public ONLYOWNER618 {	//inject NONSTANDARD NAMING
require(_newOwner != address(0), no_xfer_2_0983);
emit OWNERSHIPTRANSFERRED733(owner, _newOwner);
owner = _newOwner;
}}

library AddressUtils {
function ISCONTRACT915(address _addr) internal view returns (bool addressCheck) {	//inject NONSTANDARD NAMING
bytes32 codehash;
bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
assembly { codehash := extcodehash(_addr) } // solhint-disable-line
addressCheck = (codehash != 0x0 && codehash != accountHash);
}}

interface ERC165{
function SUPPORTSINTERFACE217(bytes4 _interfaceID) external view returns (bool);	//inject NONSTANDARD NAMING
}

contract SupportsInterface is ERC165 {
mapping(bytes4 => bool) internal supportedInterfaces;

function SUPPORTSINTERFACE217(	//inject NONSTANDARD NAMING
bytes4 _interfaceID) external override view returns (bool) {
return supportedInterfaces[_interfaceID];
}}

library SafeMath {
string constant overflow201 = "008001";	//inject NONSTANDARD NAMING
string constant subtrahend_greater_then_minuend467 = "008002";	//inject NONSTANDARD NAMING

function ADD46(uint256 _addend1, uint256 _addend2) internal pure returns (uint256 sum) {	//inject NONSTANDARD NAMING
sum = _addend1 + _addend2;
require(sum >= _addend1, overflow201);
}}

interface ERC721TokenReceiver {
function ONERC721RECEIVED244(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);	//inject NONSTANDARD NAMING
}

interface ERC721{
event TRANSFER898(address indexed _from, address indexed _to, uint256 indexed _tokenId);	//inject NONSTANDARD NAMING
event APPROVAL562(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);	//inject NONSTANDARD NAMING
event APPROVALFORALL444(address indexed _owner, address indexed _operator, bool _approved);	//inject NONSTANDARD NAMING

function SAFETRANSFERFROM138(address _from, address _to, uint256 _tokenId, bytes calldata _data) external;	//inject NONSTANDARD NAMING
function SAFETRANSFERFROM138(address _from, address _to, uint256 _tokenId) external;	//inject NONSTANDARD NAMING
function TRANSFERFROM921(address _from, address _to, uint256 _tokenId) external;	//inject NONSTANDARD NAMING
function APPROVE958(address _approved, uint256 _tokenId) external;	//inject NONSTANDARD NAMING
function SETAPPROVALFORALL105(address _operator, bool _approved) external;	//inject NONSTANDARD NAMING
function BALANCEOF270(address _owner) external view returns (uint256);	//inject NONSTANDARD NAMING
function OWNEROF456(uint256 _tokenId) external view returns (address);	//inject NONSTANDARD NAMING
function GETAPPROVED790(uint256 _tokenId) external view returns (address);	//inject NONSTANDARD NAMING
function ISAPPROVEDFORALL873(address _owner, address _operator) external view returns (bool);	//inject NONSTANDARD NAMING
}

contract NFToken is ERC721, SupportsInterface {
using SafeMath for uint256;
using AddressUtils for address;

string constant zero_address727 = "003001";	//inject NONSTANDARD NAMING
string constant not_valid_nft741 = "003002";	//inject NONSTANDARD NAMING
string constant not_owner_or_operator13 = "003003";	//inject NONSTANDARD NAMING
string constant not_owner_approwed_or_operator515 = "003004";	//inject NONSTANDARD NAMING
string constant not_able_to_receive_nft141 = "003005";	//inject NONSTANDARD NAMING
string constant nft_already_exists595 = "003006";	//inject NONSTANDARD NAMING
string constant not_owner152 = "003007";	//inject NONSTANDARD NAMING
string constant is_owner158 = "003008";	//inject NONSTANDARD NAMING

bytes4 internal constant magic_on_erc721_received864 = 0x150b7a02;	//inject NONSTANDARD NAMING

mapping (uint256 => address) internal idToOwner;
mapping (uint256 => address) internal idToApproval;
mapping (address => uint256) private ownerToNFTokenCount;
mapping (address => mapping (address => bool)) internal ownerToOperators;

modifier CANOPERATE488(uint256 _tokenId) {	//inject NONSTANDARD NAMING
address tokenOwner = idToOwner[_tokenId];
require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender], not_owner_or_operator13);
_;
}

modifier CANTRANSFER713(uint256 _tokenId) {	//inject NONSTANDARD NAMING
address tokenOwner = idToOwner[_tokenId];
require(
  tokenOwner == msg.sender
  || idToApproval[_tokenId] == msg.sender
  || ownerToOperators[tokenOwner][msg.sender], not_owner_approwed_or_operator515);
_;
}

modifier VALIDNFTOKEN826(uint256 _tokenId) {	//inject NONSTANDARD NAMING
require(idToOwner[_tokenId] != address(0), not_valid_nft741);
_;
}

function SAFETRANSFERFROM138(address _from, address _to, uint256 _tokenId, bytes calldata _data) external override{	//inject NONSTANDARD NAMING
_SAFETRANSFERFROM261(_from, _to, _tokenId, _data);
}

function SAFETRANSFERFROM138(address _from, address _to, uint256 _tokenId) external override {	//inject NONSTANDARD NAMING
_SAFETRANSFERFROM261(_from, _to, _tokenId, "");
}

function TRANSFERFROM921(address _from, address _to, uint256 _tokenId) external override CANTRANSFER713(_tokenId) VALIDNFTOKEN826(_tokenId) {	//inject NONSTANDARD NAMING
address tokenOwner = idToOwner[_tokenId];
require(tokenOwner == _from, not_owner152);
require(_to != address(0), zero_address727);

_TRANSFER192(_to, _tokenId);
}

function APPROVE958( address _approved, uint256 _tokenId) external override CANOPERATE488(_tokenId) VALIDNFTOKEN826(_tokenId) {	//inject NONSTANDARD NAMING
address tokenOwner = idToOwner[_tokenId];
require(_approved != tokenOwner, is_owner158);

idToApproval[_tokenId] = _approved;
emit APPROVAL562(tokenOwner, _approved, _tokenId);
}

function SETAPPROVALFORALL105(address _operator, bool _approved) external override {	//inject NONSTANDARD NAMING
ownerToOperators[msg.sender][_operator] = _approved;
emit APPROVALFORALL444(msg.sender, _operator, _approved);
}

function BALANCEOF270(address _owner) external override view returns (uint256) {	//inject NONSTANDARD NAMING
require(_owner != address(0), zero_address727);
return _GETOWNERNFTCOUNT378(_owner);
}

function OWNEROF456(uint256 _tokenId) external override view returns (address _owner){	//inject NONSTANDARD NAMING
_owner = idToOwner[_tokenId];
require(_owner != address(0), not_valid_nft741);
}

function GETAPPROVED790(uint256 _tokenId)	//inject NONSTANDARD NAMING
external override view VALIDNFTOKEN826(_tokenId)
returns (address) {
return idToApproval[_tokenId];
}

function ISAPPROVEDFORALL873(address _owner, address _operator) external override view returns (bool) {	//inject NONSTANDARD NAMING
return ownerToOperators[_owner][_operator];
}

function _TRANSFER192(address _to, uint256 _tokenId) internal {	//inject NONSTANDARD NAMING
address from = idToOwner[_tokenId];
_CLEARAPPROVAL604(_tokenId);

_REMOVENFTOKEN830(from, _tokenId);
_ADDNFTOKEN970(_to, _tokenId);

emit TRANSFER898(from, _to, _tokenId);
}

function _MINT19(address _to, uint256 _tokenId) internal virtual {	//inject NONSTANDARD NAMING
require(_to != address(0), zero_address727);
require(idToOwner[_tokenId] == address(0), nft_already_exists595);

_ADDNFTOKEN970(_to, _tokenId);
emit TRANSFER898(address(0), _to, _tokenId);
}

function _REMOVENFTOKEN830(address _from, uint256 _tokenId) internal virtual {	//inject NONSTANDARD NAMING
require(idToOwner[_tokenId] == _from, not_owner152);
ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
delete idToOwner[_tokenId];
}

function _ADDNFTOKEN970(address _to, uint256 _tokenId) internal virtual {	//inject NONSTANDARD NAMING
require(idToOwner[_tokenId] == address(0), nft_already_exists595);

idToOwner[_tokenId] = _to;
ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].ADD46(1);
}

function _GETOWNERNFTCOUNT378(address _owner) internal virtual view returns (uint256){	//inject NONSTANDARD NAMING
return ownerToNFTokenCount[_owner];
}

function _SAFETRANSFERFROM261(address _from, address _to, uint256 _tokenId, bytes memory _data)	//inject NONSTANDARD NAMING
private CANTRANSFER713(_tokenId) VALIDNFTOKEN826(_tokenId){
address tokenOwner = idToOwner[_tokenId];
require(tokenOwner == _from, not_owner152);
require(_to != address(0), zero_address727);

_TRANSFER192(_to, _tokenId);

if (_to.ISCONTRACT915()) {
bytes4 retval = ERC721TokenReceiver(_to).ONERC721RECEIVED244(msg.sender, _from, _tokenId, _data);
require(retval == magic_on_erc721_received864, not_able_to_receive_nft141);
}}
  
function _CLEARAPPROVAL604(uint256 _tokenId) private {	//inject NONSTANDARD NAMING
if (idToApproval[_tokenId] != address(0)) {
delete idToApproval[_tokenId];
}}}

contract NFTokenMetadata is NFToken {
string internal nftName;
string internal nftSymbol;

mapping (uint256 => string) internal idToUri;

function NAME497() external view returns (string memory _name){	//inject NONSTANDARD NAMING
_name = nftName;
}

function SYMBOL48() external view returns (string memory _symbol) {	//inject NONSTANDARD NAMING
_symbol = nftSymbol;
}}

contract NoColoredAllowed is NFTokenMetadata, Ownable{

constructor() {
nftName = "No Colored Allowed";
nftSymbol = "XCA";
owner = msg.sender;
supportedInterfaces[0x01ffc9a7] = true; // ERC165
supportedInterfaces[0x80ac58cd] = true; // ERC721
supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
}

uint256 public artTotal;
uint256 public artCap = 144;
string public constant arthead473 = '<svg version="1.1" id="NoColoredAllowed" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 1000 1000"><symbol id="a" viewBox="-7.9 -13 15.8 26"><path d="M2.6-12.7c0 6 .4-.3-5-.3-3 0-5.5 2-5.5 6.8 0 6.2 2.1 9.5 10.5 8.4 0 2.3.2 3.7-.5 4.8-.9 1.4-4.3 1.3-4.9-1.7h-5c.4 6.2 5.9 8.9 10.9 7.1 6.3-2.3 4.6-9 4.6-25.1H2.6zm0 10.9c-9.2 1.6-4.8-10.7-.7-5.9.9 1.2.7 2.8.7 5.9z"/></symbol><symbol id="b" viewBox="-7.7 -17.9 15.4 35.9"><path d="M-7.7-17.7v35.6h5.1c0-20.1-1.5-10 4.8-10C7.4 7.9 7.6 4 7.6-.5 7.6-10.3 9.1-18 2.3-18c-1.9 0-2.9.4-4.8 2.6-.1-3 .9-2.3-5.2-2.3zM2.5-.1c0 4.3-5 3.7-5 .2 0-10.6-.2-11 .7-12.1 1-1.2 3-1.1 3.8.1.7 1.3.5 2.5.5 11.8z"/></symbol><symbol id="c" viewBox="-7.6 -13 15.3 26"><path d="M-2.5-5.4c0-3.1 4.6-3.7 5 .1h5.1c0-8.6-11-10-14.2-4C-8.2-6.5-7.5 5.8-7.4 7c1.3 8.3 15 8.4 15-2.2H2.5c0 3.5-3.2 3.5-4.3 2.3-.9-.9-.7-1.2-.7-12.5z"/></symbol><symbol id="e" viewBox="-7.6 -13.1 15.3 26.1"><path d="M7.6-1.9C-4.5-1.9-2.5-.8-2.5-5.4c0-3.1 4.6-3.7 5 .1h5.1C7.6-15-7.6-16.7-7.6-4.2-7.6 5.2-8.4 9.4-4 12c4.4 2.6 11.7.5 11.7-6.9v-7zm-10.1 4c6.3 0 5-.9 5 2.9 0 2-1 2.9-2.5 2.9-2.9 0-2.5-2.9-2.5-5.8z"/></symbol><symbol id="f" viewBox="-5.8 -17.8 11.6 35.6"><path d="M-3.2-17.8c0 24.6 1 21.4-2.5 21.4 0 5-.8 4 2.5 4 0 8.5.9 10.2 8.9 10.2 0-6 .7-4.8-2.3-4.8-1.9 0-1.5-1.8-1.5-5.4 4.8 0 3.8 1 3.8-4-5.1 0-3.8 4.3-3.8-21.4h-5.1z"/></symbol><symbol id="h" viewBox="-7.7 -17.8 15.4 35.6"><path id="h_1_" d="M-7.7-17.8v35.6h5.1c0-20.5-1.6-10 4.9-10 6.6 0 5.2-5.9 5.2-25.6h-5C2.5 1 2.7.9 1.8 1.9.9 3.1-1.4 3-2 1.8-2.8.6-2.6 0-2.6-17.8h-5.1z"/></symbol><symbol id="i" viewBox="-2.7 -17.9 5.3 35.7"><path d="M-2.6 12.6c0 6.4-1.3 5.1 5.1 5.1.1-6.4 1.4-5.1-5.1-5.1zm0-30.5V7.5h5.1v-25.4h-5.1z"/></symbol><symbol id="m" viewBox="-12.7 -12.8 25.4 25.7"><path d="M-12.7-12.8v25.4h5.1c0-5.7-.5.3 4.9.3 1.5 0 3-.5 4.6-2.5 4.1 4.5 10.8 2.9 10.8-3.6v-19.5H7.6C7.6 6 7.8 5.8 7 6.9c-1 1.2-3.2 1-3.8-.1-.8-1.2-.7-1.3-.7-19.6h-5.1C-2.5 5.6-1.8 7.7-5 7.7c-3.4 0-2.5-2.1-2.5-20.5h-5.2z"/></symbol><symbol id="n" viewBox="-7.7 -12.8 15.4 25.6"><path d="M-7.7-12.8v25.4h5.1c0-5.7-.5.3 4.9.3 6.6 0 5.2-5.9 5.2-25.6h-5c0 18.7.2 18.5-.7 19.6-1 1.2-3.2 1-3.8-.1-.8-1.2-.6-1.8-.6-19.6h-5.1z"/></symbol><symbol id="o" viewBox="-7.8 -13.1 15.7 26.3"><path d="M7.7 4.1c0-8.8.9-13.5-3.5-16.1-4.1-2.5-10.6-.8-11.5 4.9-4.1 26.8 15 23 15 11.2zM-2.4-5.1c0-3.9 5-3.9 5 0 0 10.7.3 11.2-.6 12.2-.9 1-2.7 1-3.7 0-.9-1-.7-1.6-.7-12.2z"/></symbol><symbol id="p" viewBox="-7.7 -18 15.3 35.9"><path d="M-7.7-18v35.6h5.1c0-3.5-.5-2.3 2-.5 1.6 1.2 5.8 1.3 7.3-1.6 1.5-2.8.8-18.9.7-19.1C6.8-8.8.3-9.5-2.5-5.4c-.1 0-.1 1.1-.1-12.5h-5.1zM2.5 9.4c0 4.8-5 4.4-5 .3-.1-10.7-.3-10.8.7-11.8 1.1-1.2 3.1-1 3.8.1.7 1.2.5 1.3.5 11.4z"/></symbol><symbol id="r" viewBox="-6 -12.8 12 25.6"><path d="M-6-12.8v25.4h5.1c0-6-.2.3 6.8.3 0-8.3 1.1-4.1-3.3-5.4C-1.9 6.1-.9 2-.9-12.8H-6z"/></symbol><symbol id="s" viewBox="-7.7 -13 15.4 26"><path d="M2.4 5.6c-.1 3.5-5.1 3.4-5.1 0C-2.7 1.9 4 3 6.4-1.2 13-12.9-7.4-18.6-7.7-5.3c6.7 0 3.9.5 5.5-2s6.8.3 4.3 3.7c-.7 1-2.2 1.4-4.5 2.2C-8.7 1-8.7 7.7-5.3 11c4.2 4.2 12.5 1.9 12.5-5.4H2.4z"/></symbol><symbol id="t" viewBox="-5.5 -16.6 10.9 33.2"><path d="M-2.8 8.7c0 9.7-1.5 7.7 5.1 7.7 0-9.4-1-7.7 3.1-7.7 0-5 .8-4-3.1-4 0-15.5-.6-16.3 1.7-16.5 1.9-.2 1.4.9 1.4-4.9-10.5 0-8.2 4.6-8.2 21.4-3.3 0-2.5-1-2.5 4h2.5z"/></symbol><symbol id="u" viewBox="-7.7 -12.8 15.4 25.6"><path d="M7.7 12.8v-25.4H2.6c0 5.7.5-.3-4.9-.3-6.6 0-5.2 5.9-5.2 25.6h5.1C-2.5-6-2.7-5.8-1.8-6.9c.9-1.2 3.2-1 3.9.1.7 1.2.5 1.8.5 19.6h5.1z"/></symbol><symbol id="y" viewBox="-8.9 -17.8 17.7 35.7"><path d="M-8.9 17.8h5.4c4.7-21.1 2.5-21 7.1 0h5.2c-7.3-30-6.9-35.6-14.3-35.6-1.9 0-1.4-1-1.4 4.8 2.6 0 3.3-.1 4.2 3.1 1.2 4.3 1.6.6-6.2 27.7z"/></symbol><path id="bg" class="bg" d="M0 0h1000v1000H0z"/><g id="DV"><path id="V" d="M976.7 927.8c-16.6 66.5-9.9 66.8-26.6 0h26.6z"/><path id="D" d="M926.7 927.9c31.1-2 31.2 51.9 0 49.9v-49.9z"/></g><path id="hilite" d="M428.5 471h361.9v58H428.5z"/><path id="T" d="M199.7 442v-31.1c-7.3 0-5.8 1.3-5.8-4.9h16.6c0 6.1 1.5 4.9-5.8 4.9V442h-5z"/><use xlink:href="#h" width="15.4" height="35.6" x="-7.7" y="-17.8" transform="matrix(1 0 0 -1 221.781 423.8)"/><use xlink:href="#a" width="15.8" height="26" x="-7.9" y="-13" transform="matrix(1 0 0 -1 242.106 428.925)"/><use xlink:href="#n" width="15.4" height="25.6" x="-7.7" y="-12.8" transform="matrix(1 0 0 -1 262.83 428.775)"/><path id="k" d="M275.9 441.5v-35.6h5.1c0 22.9-.1 21.3.1 21.3 7.4-13.3 4.8-11.1 11.2-11.1l-6 10.3 7.3 15c-7 0-4.6 2.2-10.1-11-3.1 4.8-2.5 2.4-2.5 11h-5.1z"/><use xlink:href="#s" width="15.4" height="26" x="-7.7" y="-13" transform="matrix(1 0 0 -1 303.423 428.925)"/><use xlink:href="#f" width="11.6" height="35.6" x="-5.8" y="-17.8" transform="matrix(1 0 0 -1 330.453 423.8)"/><use xlink:href="#o" width="15.7" height="26.3" x="-7.8" y="-13.1" transform="matrix(1 0 0 -1 346.17 428.925)"/><use xlink:href="#r" width="12" height="25.6" x="-6" y="-12.8" transform="matrix(1 0 0 -1 365.228 428.775)"/><use xlink:href="#s" width="15.4" height="26" x="-7.7" y="-13" transform="matrix(1 0 0 -1 392.42 428.925)"/><use xlink:href="#u" width="15.4" height="25.6" x="-7.7" y="-12.8" transform="matrix(1 0 0 -1 412.376 429.075)"/><use xlink:href="#b" width="15.4" height="35.9" x="-7.7" y="-17.9" transform="matrix(1 0 0 -1 433.376 423.95)"/><use xlink:href="#m" width="25.4" height="25.7" x="-12.7" y="-12.8" transform="matrix(1 0 0 -1 459.15 428.775)"/><use xlink:href="#i" width="5.3" height="35.7" x="-2.7" y="-17.9" transform="matrix(1 0 0 -1 479.836 423.8)"/><use xlink:href="#t" width="10.9" height="33.2" x="-5.5" y="-16.6" transform="matrix(1 0 0 -1 491 425.075)"/><use xlink:href="#t" width="10.9" height="33.2" x="-5.5" y="-16.6" transform="matrix(1 0 0 -1 503.9 425.075)"/><use xlink:href="#i" width="5.3" height="35.7" x="-2.7" y="-17.9" transform="matrix(1 0 0 -1 516.1 423.8)"/><use xlink:href="#n" width="15.4" height="25.6" x="-7.7" y="-12.8" transform="matrix(1 0 0 -1 532.024 428.775)"/><path id="g" d="M550.6 444.5c.2 3 5 3.8 5-.2 0-9.6.9-2.4-4.8-2.4-6.8 0-5.3-7.5-5.3-17.5 0-3.5-.2-6.2 2.5-7.8 1.1-.8 3.4-.8 4.5-.5 3.4 1 3.2 4.6 3.2.1h5.1v28.5c0 9.3-14 10.7-15.2-.1h5zm0-10.7c0 4.3 5 3.7 5 .2 0-10.7.2-11-.7-12.1-1-1.2-3-1.1-3.8.1-.8 1.3-.5 2.5-.5 11.8z"/><use xlink:href="#t" width="10.9" height="33.2" x="-5.5" y="-16.6" transform="matrix(1 0 0 -1 580.097 425.075)"/><use xlink:href="#o" width="15.7" height="26.3" x="-7.8" y="-13.1" transform="matrix(1 0 0 -1 595.752 428.925)"/><path id="S" d="M636.8 416.1c-6.1 0-5.1.4-5.1-1.1 0-5.6-7-6.1-7 .3 0 8 10.7 3.2 12 12.6 2.4 18.5-17.3 18.2-17.3 3.6 6.1 0 5.1-.5 5.1 1.6 0 4.6 5.5 4.4 6.8 2.2.8-1.4.7-6.3 0-7.6-1.5-2.3-8.4-2.6-10.5-6.7-8-15.6 16-23 16-4.9z"/><use xlink:href="#u" width="15.4" height="25.6" x="-7.7" y="-12.8" transform="matrix(1 0 0 -1 649.37 429.075)"/><use xlink:href="#p" width="15.3" height="35.9" x="-7.7" y="-18" transform="matrix(1 0 0 -1 670.37 433.9)"/><use xlink:href="#e" width="15.3" height="26.1" x="-7.6" y="-13.1" transform="matrix(1 0 0 -1 690.895 429.075)"/><use xlink:href="#r" width="12" height="25.6" x="-6" y="-12.8" transform="matrix(1 0 0 -1 709.72 428.925)"/><path id="R" d="M719.9 441.5v-35.6h8.2c10.3 0 9.9 11.7 8 15.8-3.2 7.2-6.1-4.4 2.1 19.8-7.2 0-4.5 3-10.2-15.2-4.1 0-3-3-3 15.2h-5.1zm5.1-30.8c0 13.3-1 11.1 2.9 11.1 6.2 0 3.8-8.9 3.3-9.7-1.1-1.7-3.8-1.4-6.2-1.4z"/><use xlink:href="#a" width="15.8" height="26" x="-7.9" y="-13" transform="matrix(1 0 0 -1 749.444 428.925)"/><use xlink:href="#r" width="12" height="25.6" x="-6" y="-12.8" transform="matrix(1 0 0 -1 768.87 428.775)"/><use xlink:href="#e" width="15.3" height="26.1" x="-7.6" y="-13.1" transform="matrix(1 0 0 -1 785.144 429.065)"/><path id="dot" d="M797.8 441.5c0-6-1.2-4.8 4.8-4.8 0 6 1.2 4.8-4.8 4.8z"/><path id="U" d="M212.2 478c0 27.9 1.6 32.4-5.1 35.2-4.3 1.9-9-.4-10.8-4.4-.9-1.9-.6-.6-.6-30.8h5.1c0 28.7-1.1 30.8 3.2 30.8 4.2 0 3.1-2 3.1-30.8h5.1z"/><use xlink:href="#n" width="15.4" height="25.6" x="-7.7" y="-12.8" transform="matrix(1 0 0 -1 225.63 500.776)"/><use xlink:href="#f" width="11.6" height="35.6" x="-5.8" y="-17.8" transform="matrix(1 0 0 -1 242.555 495.95)"/><use xlink:href="#o" width="15.7" height="26.3" x="-7.8" y="-13.1" transform="matrix(1 0 0 -1 258.204 500.925)"/><use xlink:href="#r" width="12" height="25.6" x="-6" y="-12.8" transform="matrix(1 0 0 -1 276.73 500.776)"/><use xlink:href="#t" width="10.9" height="33.2" x="-5.5" y="-16.6" transform="matrix(1 0 0 -1 290.454 497.076)"/><use xlink:href="#u" width="15.4" height="25.6" x="-7.7" y="-12.8" transform="matrix(1 0 0 -1 307.788 501.075)"/><use xlink:href="#n" width="15.4" height="25.6" x="-7.7" y="-12.8" transform="matrix(1 0 0 -1 328.228 500.776)"/><use xlink:href="#a" width="15.8" height="26" x="-7.9" y="-13" transform="matrix(1 0 0 -1 348.253 501.075)"/><use xlink:href="#t" width="10.9" height="33.2" x="-5.5" y="-16.6" transform="matrix(1 0 0 -1 363.903 497.18)"/><use xlink:href="#e" width="15.3" height="26.1" x="-7.6" y="-13.1" transform="matrix(1 0 0 -1 379.653 500.925)"/><path id="l" d="M392 478h5.1c0 32.5-.9 30.7 2.5 31.1 0 5.2.8 5.3-3.2 4.5-5.8-1.2-4.4-4.6-4.4-35.6z"/><use xlink:href="#y" width="17.7" height="35.7" x="-8.9" y="-17.8" transform="matrix(1 0 0 -1 409.513 506.05)"/><g id="lit" fill="#fff"><path id="w" d="M456.9 488.3l-6 25.4h-4.5c-3-16.2-2.7-15-2.9-15-3.4 18.1-1.3 15-7.3 15l-6-25.4h5.4c3.4 17.1 3 15.8 3.2 15.8 3.4-18.9 1.5-15.8 6.8-15.8 3.7 21.4 1.9 20.6 5.8 0h5.5z"/><use xlink:href="#e" width="15.3" height="26.1" x="-7.6" y="-13.1" transform="matrix(1 0 0 -1 467.101 500.925)"/><use xlink:href="#c" width="15.3" height="26" x="-7.6" y="-13" transform="matrix(1 0 0 -1 498.15 500.925)"/><use xlink:href="#a" width="15.8" height="26" x="-7.9" y="-13" transform="matrix(1 0 0 -1 516.95 500.925)"/><use xlink:href="#n" width="15.4" height="25.6" x="-7.7" y="-12.8" transform="matrix(1 0 0 -1 537.6 500.776)"/><use xlink:href="#n" width="15.4" height="25.6" x="-7.7" y="-12.8" transform="matrix(1 0 0 -1 558.074 500.776)"/><use xlink:href="#o" width="15.7" height="26.3" x="-7.8" y="-13.1" transform="matrix(1 0 0 -1 578.299 501.012)"/><use xlink:href="#t" width="10.9" height="33.2" x="-5.5" y="-16.6" transform="matrix(1 0 0 -1 593.748 497.076)"/><use xlink:href="#a" width="15.8" height="26" x="-7.9" y="-13" transform="matrix(1 0 0 -1 619.847 501.012)"/><use xlink:href="#c" width="15.3" height="26" x="-7.6" y="-13" transform="matrix(1 0 0 -1 640.547 501.108)"/><use xlink:href="#c" width="15.3" height="26" x="-7.6" y="-13" transform="matrix(1 0 0 -1 660.297 500.925)"/><use xlink:href="#e" width="15.3" height="26.1" x="-7.6" y="-13.1" transform="matrix(1 0 0 -1 679.195 501.108)"/><use xlink:href="#p" width="15.3" height="35.9" x="-7.7" y="-18" transform="matrix(1 0 0 -1 699.522 505.9)"/><use xlink:href="#t" width="10.9" height="33.2" x="-5.5" y="-16.6" transform="matrix(1 0 0 -1 715.446 497.076)"/><use xlink:href="#y" width="17.7" height="35.7" x="-8.9" y="-17.8" transform="matrix(1 0 0 -1 741.295 506.05)"/><use xlink:href="#o" width="15.7" height="26.3" x="-7.8" y="-13.1" transform="matrix(1 0 0 -1 760.148 500.925)"/><use xlink:href="#u" width="15.4" height="25.6" x="-7.7" y="-12.8" transform="matrix(1 0 0 -1 780.458 501.075)"/></g><use xlink:href="#r" width="12" height="25.6" x="-6" y="-12.8" transform="matrix(1 0 0 -1 799.52 500.776)"/><use xlink:href="#s" width="15.4" height="26" x="-7.7" y="-13" transform="matrix(1 0 0 -1 314.03 572.925)"/><use xlink:href="#u" width="15.4" height="25.6" x="-7.7" y="-12.8" transform="matrix(1 0 0 -1 333.905 573.075)"/><use xlink:href="#b" width="15.4" height="35.9" x="-7.7" y="-17.9" transform="matrix(1 0 0 -1 354.704 567.95)"/><use xlink:href="#m" width="25.4" height="25.7" x="-12.7" y="-12.8" transform="matrix(1 0 0 -1 380.676 572.925)"/><use xlink:href="#i" width="5.3" height="35.7" x="-2.7" y="-17.9" transform="matrix(1 0 0 -1 401.37 567.95)"/><use xlink:href="#s" width="15.4" height="26" x="-7.7" y="-13" transform="matrix(1 0 0 -1 416.297 572.925)"/><use xlink:href="#s" width="15.4" height="26" x="-7.7" y="-13" transform="matrix(1 0 0 -1 435.128 573.068)"/><use xlink:href="#i" width="5.3" height="35.7" x="-2.7" y="-17.9" transform="matrix(1 0 0 -1 449.927 567.95)"/><use xlink:href="#o" width="15.7" height="26.3" x="-7.8" y="-13.1" transform="matrix(1 0 0 -1 464.887 573.068)"/><use xlink:href="#n" width="15.4" height="25.6" x="-7.7" y="-12.8" transform="matrix(1 0 0 -1 485.501 573.068)"/><use xlink:href="#a" width="15.8" height="26" x="-7.9" y="-13" transform="matrix(1 0 0 -1 516.275 572.925)"/><use xlink:href="#t" width="10.9" height="33.2" x="-5.5" y="-16.6" transform="matrix(1 0 0 -1 532.025 568.991)"/><use xlink:href="#t" width="10.9" height="33.2" x="-5.5" y="-16.6" transform="matrix(1 0 0 -1 554.224 569.075)"/><use xlink:href="#h" width="15.4" height="35.6" x="-7.7" y="-17.8" transform="matrix(1 0 0 -1 570.548 567.8)"/><use xlink:href="#i" width="5.3" height="35.7" x="-2.7" y="-17.9" transform="matrix(1 0 0 -1 586.268 567.8)"/><use xlink:href="#s" width="15.4" height="26" x="-7.7" y="-13" transform="matrix(1 0 0 -1 601.073 572.925)"/><use xlink:href="#t" width="10.9" height="33.2" x="-5.5" y="-16.6" transform="matrix(1 0 0 -1 626.822 569.075)"/><use xlink:href="#i" width="5.3" height="35.7" x="-2.7" y="-17.9" transform="matrix(1 0 0 -1 638.072 567.8)"/><use xlink:href="#m" width="25.4" height="25.7" x="-12.7" y="-12.8" transform="matrix(1 0 0 -1 658.871 572.776)"/><use xlink:href="#e" width="15.3" height="26.1" x="-7.6" y="-13.1" transform="matrix(1 0 0 -1 684.273 572.863)"/><style>.bg{fill:#';	//inject NONSTANDARD NAMING
string public constant arttail672 = ';}</style></svg>';	//inject NONSTANDARD NAMING

mapping (uint256 => string) internal artDNAStore;
mapping (uint256 => uint256) internal artSetStore;

event BIRTH139(uint256 tokenID, string artDNA, uint256 artSet);	//inject NONSTANDARD NAMING

function GETDNA928(uint256 tokenID) public view returns (string memory artDNA) {	//inject NONSTANDARD NAMING
artDNA = artDNAStore[tokenID];
}

function GETSET947(uint256 tokenID) public view returns (uint256 artSet) {	//inject NONSTANDARD NAMING
artSet = artSetStore[tokenID];
}

function GENERATE93(uint256 tokenID) public view returns (string memory SVG) {	//inject NONSTANDARD NAMING
SVG = string(abi.encodePacked(arthead473, artDNAStore[tokenID], arttail672));
}

function TOKENURI670(uint256 _tokenId) external view VALIDNFTOKEN826(_tokenId) returns (string memory) {	//inject NONSTANDARD NAMING
return GENERATE93(_tokenId);
}

function TOKENIZE443 (string memory artDNA, uint256 artSet) public ONLYOWNER618 {{ 	//inject NONSTANDARD NAMING
artTotal = artTotal + 1;
artDNAStore[artTotal] = artDNA;
artSetStore[artTotal] = artSet;

_MINTPRINT97();
emit BIRTH139(artTotal, artDNA, artSet);
}}

function _MINTPRINT97() private {	//inject NONSTANDARD NAMING
uint256 tokenId = artTotal;
require(artTotal <= artCap, "144 tokens max");
_MINT19(msg.sender, tokenId);
}}