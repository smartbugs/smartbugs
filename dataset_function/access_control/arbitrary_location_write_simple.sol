/*
 * @source: https://smartcontractsecurity.github.io/SWC-registry/docs/SWC-124#arbitrary-location-write-simplesol
 * @author: Suhabe Bugrara
 * @vulnerable_at_lines: 27
 */



















     function PopBonusCode() public {
         // <yes> <report> ACCESS_CONTROL
         require(0 <= bonusCodes.length); // this condition is always true since array lengths are unsigned
         bonusCodes.length--; // an underflow can be caused here
     }











