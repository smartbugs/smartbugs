/**
 *Submitted for verification at Etherscan.io on 2020-08-19
*/

pragma solidity ^0.6.3;	//inject UNLIMITED COMPILER VERSIONS
contract starkminer {
    function checklasttwentyblock() view public returns(uint256, uint256) {
        if(uint256(blockhash(block.number-1)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-1)) % 5700;
            return (crew, block.number-1);
        }else if(uint256(blockhash(block.number-2)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-2)) % 5700;
            return (crew, block.number-2);
        } else if(uint256(blockhash(block.number-3)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-3)) % 5700;
            return (crew, block.number-3);
        }else if(uint256(blockhash(block.number-4)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-4)) % 5700;
            return (crew, block.number-4);
        }else if(uint256(blockhash(block.number-5)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-5)) % 5700;
            return (crew, block.number-5);
        } else if(uint256(blockhash(block.number-6)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-6)) % 5700;
            return (crew, block.number-6);
        } else if(uint256(blockhash(block.number-7)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-7)) % 5700;
            return (crew, block.number-7);
        } else if(uint256(blockhash(block.number-8)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-8)) % 5700;
            return (crew, block.number-8);
        } else if(uint256(blockhash(block.number-9)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-9)) % 5700;
            return (crew, block.number-9);
        } else if(uint256(blockhash(block.number-10)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-10)) % 5700;
            return (crew, block.number-10);
        } else if(uint256(blockhash(block.number-11)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-11)) % 5700;
            return (crew, block.number-11);
        } else if(uint256(blockhash(block.number-12)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-12)) % 5700;
            return (crew, block.number-12);
        } else if(uint256(blockhash(block.number-13)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-13)) % 5700;
            return (crew, block.number-13);
        } else if(uint256(blockhash(block.number-14)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-14)) % 5700;
            return (crew, block.number-14);
        } else if(uint256(blockhash(block.number-15)) % 5700 == 1){
            uint256 crew = uint256(blockhash(block.number-15)) % 5700;
            return (crew, block.number-15);
        }else {
            uint256 crew = uint256(blockhash(block.number-1)) % 5700;
            return (crew, block.number-1);
        }
    }
}