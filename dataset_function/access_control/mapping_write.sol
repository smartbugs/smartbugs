













     function set(uint256 key, uint256 value) public {
         if (map.length <= key) {
             map.length = key + 1;
         }
        // <yes> <report> ACCESS_CONTROL
         map[key] = value;
     }
