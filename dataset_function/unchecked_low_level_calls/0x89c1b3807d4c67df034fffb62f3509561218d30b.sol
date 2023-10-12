












































































































































    function deliver(uint64 requestId, bytes32 paramsHash, uint64 error, bytes32 respData) public {
        if (msg.sender != SGX_ADDRESS ||
                requestId <= 0 ||
                requests[requestId].requester == 0 ||
                requests[requestId].fee == DELIVERED_FEE_FLAG) {
            // If the response is not delivered by the SGX account or the 
            // request has already been responded to, discard the response.
            return;
        }

        uint fee = requests[requestId].fee;
        if (requests[requestId].paramsHash != paramsHash) {
            // If the hash of request parameters in the response is not 
            // correct, discard the response for security concern.
            return;
        } else if (fee == CANCELLED_FEE_FLAG) {
            // If the request is cancelled by the requester, cancellation 
            // fee goes to the SGX account and set the request as having
            // been responded to.
            // <yes> <report> UNCHECKED_LL_CALLS
            SGX_ADDRESS.send(CANCELLATION_FEE);
            requests[requestId].fee = DELIVERED_FEE_FLAG;
            unrespondedCnt--;
            return;
        }

        requests[requestId].fee = DELIVERED_FEE_FLAG;
        unrespondedCnt--;

        if (error < 2) {
            // Either no error occurs, or the requester sent an invalid query.
            // Send the fee to the SGX account for its delivering.
            // <yes> <report> UNCHECKED_LL_CALLS
            SGX_ADDRESS.send(fee);         
        } else {
            // Error in TC, refund the requester.
            externalCallFlag = true;
            // <yes> <report> UNCHECKED_LL_CALLS
            requests[requestId].requester.call.gas(2300).value(fee)();
            externalCallFlag = false;
        }

        uint callbackGas = (fee - MIN_FEE) / tx.gasprice; // gas left for the callback function
        DeliverInfo(requestId, fee, tx.gasprice, msg.gas, callbackGas, paramsHash, error, respData); // log the response information
        if (callbackGas > msg.gas - 5000) {
            callbackGas = msg.gas - 5000;
        }
        
        externalCallFlag = true;
        // <yes> <report> UNCHECKED_LL_CALLS
        requests[requestId].callbackAddr.call.gas(callbackGas)(requests[requestId].callbackFID, requestId, error, respData); // call the callback function in the application contract
        externalCallFlag = false;
    }
