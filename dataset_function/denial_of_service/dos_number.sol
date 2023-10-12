












    function insertNnumbers(uint value,uint numbers) public {

        // Gas DOS if number > 382 more or less, it depends on actual gas limit
        // <yes> <report> DENIAL_OF_SERVICE
        for(uint i=0;i<numbers;i++) {
            if(numElements == array.length) {
                array.length += 1;
            }
            array[numElements++] = value;
        }
    }
