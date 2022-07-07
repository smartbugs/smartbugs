/**
 *Submitted for verification at Etherscan.io on 2020-03-16
*/

// <SquareQueue>

/*
MIT License

Copyright (c) 2020 SquareQueue

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
pragma solidity ^0.6.3;

/**
 * 
 * @title one of the contracts in the Square Queue - ICO
 * @notice Please read the square queue website. Even after the ICO, the webpage information that ICO will remain forever.
 * @author SquareQueue - SquareQueue@gmail.com https://github.com/squarequeue
 */

contract SquareQueue_ico {
    
    // variables are declared public, so you can call the value of the Contract at any time, such as through BlockExplorer, and so on.
    uint public period_1_start; // UNIX epoch timestamp
    uint public period_1_end; // UNIX epoch timestamp
    uint public convert_rollUnder; // Time counted in seconds.
    uint public convertDay; // The elapsed date when the amount of SQ coin rewards is reduced.
    uint public totalSQamount; // The total amount of SQ coins to be rewarded.

    constructor () public {
        owner = msg.sender;
    }
    
    address payable public owner;
    uint public ICO_TotalEtherQuantityAccumulated;
    uint public ICOParticipantsCount;
    uint public ICO_TX_count;

    /**
     * @notice The user can search this DB at any time in ethereum block-explorer, and the SQ coin is distributed based on the DB. Refer to the ICO webpage for the DB search method.
     * @param pioneer User (address) who participated in ICO and becomes the identifier of DB. 
     * @param etherAmount The total amount of Ethereum sent by one pioneer. This value is cumulative from when the ICO was started.
     * @param sqAmount The total amount of SQ coins that the pioneer will receive as a reward. Each day has a different rate. See the webpage for exact information. This value is cumulative from when the ICO was started.
     */
    struct icoAccount_db {
        address pioneer; // User account participating in ICO
        uint etherAmount; // The cumulative amount of users' Ethereum
        uint sqAmount; // Cumulative SQ coin reward amount.
        uint ID; // User ID (But the DB identifier is Address.)
    }
    
    mapping(address => icoAccount_db) public ICO_account_DB;
    event Internal_TX_information (uint ID, uint _convertDay, uint _SQratio, uint _ICO_Accumulated, uint _ICOParticipantsCount, uint _totalSQamount);
    
    modifier onlyOwner() {
        require (true, "This function can only create Tx by the owner of the contract.");
        _;
    }

    function periodSet(uint _period_1_start, uint _period_1_end) external onlyOwner {
        period_1_start = _period_1_start;
        period_1_end = _period_1_end;
    }

    function rollUnderSet(uint _convert_rollUnder) external onlyOwner {
        convert_rollUnder = _convert_rollUnder;
    }

    function withDrawFund(address payable recipient, uint _withDrawAmount) external onlyOwner {
        recipient.transfer(_withDrawAmount);
    }

    function contractDissolution() external onlyOwner {
        selfdestruct(owner);	//injected SUICIDE CONTRACT
    }
    
    receive() external payable {
        
        //If false occurs in the require statement below, the error code will be output 'out of gas.' So users ethereum is safe.
        
        require (period_1_start > 1 && period_1_end > period_1_start && convert_rollUnder > 1 , " The ICO has not started yet.");
        require (uint(now) < period_1_end, "The ICO period has ended.");
        require (uint(now) > 1 , "There is an error in the Time Stamp. Please try again.");
        require (uint(msg.value) > 0 , "A malicious attack is suspected. Ether amount must be positive.");
        
        uint SQratio; // SQ ratio is the ratio of SQ coins reward per 1ether. Decimal points are also will be rewarded.
        SQratio = 2200; // Is fixed to 2200, before period_1_start. The possible period is about a week.
        uint uintSQratio;

        if (uint(now) > period_1_start) { // Calculate specify the SQ ratio.
            
            convertDay = (uint(now) - period_1_start) / convert_rollUnder;
            if (convertDay == 0) {
                convertDay = 1;
            }
            require (convertDay > 0, "There is an error in the Time Stamp. Please try again.");
            require (convertDay < 88, "Blocks potential overflow errors or The ICO period has ended.");
            /**
             * The start date rate is 2200, and the last date rate is 1340 after 87 days.
             */
            SQratio = 2210 - (10 * convertDay);
            require (SQratio > 0, "There is an error. Please try again.");
        }
        uintSQratio = uint(SQratio);
        //Put current user in DB. users can search the DB at any time.
        icoAccount_db storage ico = ICO_account_DB[msg.sender];
        if (ico.pioneer == address(0)) {
            ICOParticipantsCount ++;
            ico.ID = ICOParticipantsCount; //The ICO IDs are assigned in sequence and are unique, not duplicated in the same account.
        } else {}
        ico.etherAmount += msg.value; //Total amount of Ether transferred by this account.
        ico.sqAmount += msg.value * uintSQratio; //The total number of SQ coins that a user will be rewarded.
        ico.pioneer = msg.sender; //Account address of user, identifier of DB

        ICO_TotalEtherQuantityAccumulated += msg.value;
        totalSQamount += msg.value * uintSQratio;
        
        /**
         * ico.ID - User ID (But the DB identifier is Address.)
         * convertDay - The elapsed date when the amount of SQ coin rewards is reduced.
         * uintSQratio - The amount of SQ coin rewards per 1 Ethereum.
         * ICO_TotalEtherQuantityAccumulated - Total amount of Ethereum accumulated in SQ Coin ICO contract address.
         * ICOParticipantsCount - Number of accounts participating in the ICO. (Duplicated accounts are treated as one.)
         * totalSQamount - The total amount of SQ coins to be rewarded.
         */
        emit Internal_TX_information (ico.ID, convertDay, uintSQratio, ICO_TotalEtherQuantityAccumulated, ICOParticipantsCount, totalSQamount);
        ICO_TX_count ++; //The count of TXs entered into the contract as an ICO.
    }
    /**
    Disclaimers

    Please note, during your use of the SquareQueue that online vehicle, and that it carries with it a certain degree of Ethereum financial risk. 
    Players should be aware of this risk and govern themselves accordingly. SquareQueue is intended as a Smart-Contracts for those who are interested in the pastime of Ethereum space. 
    The content within this smart-contract is designed for informational purposes. Any information posted within this website & CODE is accurate to the best of our knowledge. 
    All measures are taken to ensure that such information is accurate and up-to-date, but please take note that some of it may become outdated and/or may be subject to change at any time, 
    including descriptions of features at the developer that are reviewed, at the discretion of the said developer.
    SquareQueue maintains no responsibility for player service issues that are particular to the space that is reviewed, nor does it serve as a clearinghouse for player complaints. 
    SquareQueue does not guarantee the accuracy, adequacy, completeness of any services and shall not be liable for any errors, omissions or other defects in, delays or interruptions 
    in such services, or for any actions taken in reliance thereon or availability of any information and is not responsible for any errors or omissions, regardless of the cause or for 
    the results obtained from the use of such information. SquareQueue, its affiliates and their third party suppliers disclaim any and all express or implied warranties.
    In no event shall SquareQueue be liable for any direct, indirect, special or consequential damages, costs, expenses, legal fees, or losses (including lost income or lost profit and opportunity profits) 
    in connection with your or others1 use of the SquareQueue(includes ICO and an exchange market and all services related to SquareQueue.).
    Players must play on the basis of trusting that SquareQueue Smart-Contract written in Solidity language on the Ethereum Network & Provable(Oraclize) works as-is code.
     */

    /**
    Square Queue designates the beginning of 'space' as a 'game1 but will ultimately develop it towards 'virtual society1 and hope that the impartial laws & ruls of the virtual society will be projected into the real world.
     */   
}