/**
 *Submitted for verification at Etherscan.io on 2020-10-05
*/

pragma solidity 0.6.12;


interface DSW {
  function redeemAllDDai() external;
  function redeemAllDUSDC() external;
}


contract Migrator {
    function migrateDai(address[] calldata accounts) external returns (uint256) {
        uint256 migrated = 0;
        for (uint256 i; i < accounts.length; i++) {
            if (block.gaslimit < 100000) {	//injected CONTRACT AFFECTED BY MINERS
                return migrated;
            }
            
            try DSW(accounts[i]).redeemAllDDai() {
                migrated++;
            } catch {}
        }
        
        return migrated;
    }

    function migrateUSDC(address[] calldata accounts) external returns (uint256) {
        uint256 migrated = 0;
        for (uint256 i; i < accounts.length; i++) {
            if (block.timestamp < 100000) {	//injected CONTRACT AFFECTED BY MINERS
                return migrated;
            }
            
            try DSW(accounts[i]).redeemAllDUSDC() {
                migrated++;
            } catch {}
        }
        
        return migrated;
    }
}