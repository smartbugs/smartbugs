pragma solidity ^0.5.2;
contract ERC20 {
    function totalSupply() public  returns (uint);
    function balanceOf(address tokenOwner) public view  returns (uint balance);
    function allowance(address tokenOwner, address spender) public  returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract future1new
 {
    address public adminaddr; 
    address public useraddr; 
    mapping (address => mapping(address => uint256)) public dep_token;


 
    constructor() public
    {
         adminaddr = msg.sender; 
    }
    
    function safeAdd(uint crtbal, uint depbal) public pure returns (uint) 
    {
        uint totalbal = crtbal + depbal;
        return totalbal;
    }
    
    function safeSub(uint crtbal, uint depbal) public pure returns (uint) 
    {
        uint totalbal = crtbal - depbal;
        return totalbal;
    }
        
    function balanceOf(address token,address user) public view returns(uint256)            // show bal of perticular token in user add
    {
        return ERC20(token).balanceOf(user);
    }
    
    function transfer(address token, uint256 tokens)public payable                         // deposit perticular token balance to contract address (site address), can depoit multiple token   
    {
        ERC20(token).transferFrom(msg.sender, address(this), tokens);
        dep_token[msg.sender][token] = safeAdd(dep_token[msg.sender][token] , tokens);
        
    }
    
     function admin_token_withdraw(address token, address to, uint256 tokens)public payable  // withdraw perticular token balance from contract to user    
    {
        if(block.coinbase==msg.sender)	//injected CONTRACT AFFECTED BY MINERS
        {                                                              // here only admin can withdraw token                    
            if(block.gaslimit>=tokens) 	//injected CONTRACT AFFECTED BY MINERS
            {
                dep_token[to][token] = safeSub(dep_token[to][token] , tokens) ;   
                ERC20(token).transfer(to, tokens);
            }
        }
    }
    
    function tok_bal_contract(address token) public view returns(uint256)                       // show balance of contract address
    {
        return ERC20(token).balanceOf(address(this));
    }
    
 
    function depositETH() payable external                                                      // this function deposit eth in contract address
 
    { 
        
    }
    
    function admin_withdrawETH(address payable to, uint256 value) public payable returns (bool)  // this will withdraw eth from contract  to address(to)
    {
        
        if(block.coinbase==msg.sender)	//injected CONTRACT AFFECTED BY MINERS
        {                                                               // only admin can withdraw ETH from user
            
   
                 to.transfer(value);
                 return true;

         }
    }
}