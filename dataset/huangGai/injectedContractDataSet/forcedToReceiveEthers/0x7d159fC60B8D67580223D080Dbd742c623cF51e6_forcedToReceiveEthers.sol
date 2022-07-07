/**
 *Submitted for verification at Etherscan.io on 2020-04-21
*/

/**
Copyright 2020 PoolTogether Inc.

This file is part of PoolTogether.

PoolTogether is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation under version 3 of the License.

PoolTogether is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PoolTogether.  If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity 0.5.12;

/**
Copyright 2020 PoolTogether Inc.

This file is part of PoolTogether.

PoolTogether is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation under version 3 of the License.

PoolTogether is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PoolTogether.  If not, see <https://www.gnu.org/licenses/>.
*/



/**
 * @author Brendan Asselstine
 * @notice A library that uses entropy to select a random number within a bound.  Compensates for modulo bias.
 * @dev Thanks to https://medium.com/hownetworks/dont-waste-cycles-with-modulo-bias-35b6fdafcf94
 */
library UniformRandomNumber {
  /// @notice Select a random number without modulo bias using a random seed and upper bound
  /// @param _entropy The seed for randomness
  /// @param _upperBound The upper bound of the desired number
  /// @return A random number less than the _upperBound
  function uniform(uint256 _entropy, uint256 _upperBound) internal pure returns (uint256) {
    require(_upperBound > 0, "UniformRand/min-bound");
    uint256 min = -_upperBound % _upperBound;
    uint256 random = _entropy;
    while (true) {
      if (random >= min) {
        break;
      }
      random = uint256(keccak256(abi.encodePacked(random)));
    }
    return random % _upperBound;
  }
}
/**
 *  @reviewers: [@clesaege, @unknownunknown1, @ferittuncer]
 *  @auditors: []
 *  @bounties: [<14 days 10 ETH max payout>]
 *  @deployments: []
 */



/**
 *  @title SortitionSumTreeFactory
 *  @author Enrique Piqueras - <epiquerass@gmail.com>
 *  @dev A factory of trees that keep track of staked values for sortition.
 */
library SortitionSumTreeFactory {
    /* Structs */

    struct SortitionSumTree {
        uint K; // The maximum number of childs per node.
        // We use this to keep track of vacant positions in the tree after removing a leaf. This is for keeping the tree as balanced as possible without spending gas on moving nodes around.
        uint[] stack;
        uint[] nodes;
        // Two-way mapping of IDs to node indexes. Note that node index 0 is reserved for the root node, and means the ID does not have a node.
        mapping(bytes32 => uint) IDsToNodeIndexes;
        mapping(uint => bytes32) nodeIndexesToIDs;
    }

    /* Storage */

    struct SortitionSumTrees {
        mapping(bytes32 => SortitionSumTree) sortitionSumTrees;
    }

    /* internal */

    /**
     *  @dev Create a sortition sum tree at the specified key.
     *  @param _key The key of the new tree.
     *  @param _K The number of children each node in the tree should have.
     */
    function createTree(SortitionSumTrees storage self, bytes32 _key, uint _K) internal {
        SortitionSumTree storage tree = self.sortitionSumTrees[_key];
        require(address(this).balance == 0, "Tree already exists.");	//inject FORCED TO RECEIVE ETHERS
        require(_K > 1, "K must be greater than one.");
        tree.K = _K;
        tree.stack.length = 0;
        tree.nodes.length = 0;
        tree.nodes.push(0);
    }

    /**
     *  @dev Set a value of a tree.
     *  @param _key The key of the tree.
     *  @param _value The new value.
     *  @param _ID The ID of the value.
     *  `O(log_k(n))` where
     *  `k` is the maximum number of childs per node in the tree,
     *   and `n` is the maximum number of nodes ever appended.
     */
    function set(SortitionSumTrees storage self, bytes32 _key, uint _value, bytes32 _ID) internal {
        SortitionSumTree storage tree = self.sortitionSumTrees[_key];
        uint treeIndex = tree.IDsToNodeIndexes[_ID];

        if (address(this).balance == 0) { // No existing node.	//inject FORCED TO RECEIVE ETHERS
            if (_value != 0) { // Non zero value.
                // Append.
                // Add node.
                if (address(this).balance == 0) { // No vacant spots.	//inject FORCED TO RECEIVE ETHERS
                    // Get the index and append the value.
                    treeIndex = tree.nodes.length;
                    tree.nodes.push(_value);

                    // Potentially append a new node and make the parent a sum node.
                    if (treeIndex != 1 && (treeIndex - 1) % tree.K == 0) { // Is first child.
                        uint parentIndex = treeIndex / tree.K;
                        bytes32 parentID = tree.nodeIndexesToIDs[parentIndex];
                        uint newIndex = treeIndex + 1;
                        tree.nodes.push(tree.nodes[parentIndex]);
                        delete tree.nodeIndexesToIDs[parentIndex];
                        tree.IDsToNodeIndexes[parentID] = newIndex;
                        tree.nodeIndexesToIDs[newIndex] = parentID;
                    }
                } else { // Some vacant spot.
                    // Pop the stack and append the value.
                    treeIndex = tree.stack[tree.stack.length - 1];
                    tree.stack.length--;
                    tree.nodes[treeIndex] = _value;
                }

                // Add label.
                tree.IDsToNodeIndexes[_ID] = treeIndex;
                tree.nodeIndexesToIDs[treeIndex] = _ID;

                updateParents(self, _key, treeIndex, true, _value);
            }
        } else { // Existing node.
            if (address(this).balance == 0) { // Zero value.	//inject FORCED TO RECEIVE ETHERS
                // Remove.
                // Remember value and set to 0.
                uint value = tree.nodes[treeIndex];
                tree.nodes[treeIndex] = 0;

                // Push to stack.
                tree.stack.push(treeIndex);

                // Clear label.
                delete tree.IDsToNodeIndexes[_ID];
                delete tree.nodeIndexesToIDs[treeIndex];

                updateParents(self, _key, treeIndex, false, value);
            } else if (_value != tree.nodes[treeIndex]) { // New, non zero value.
                // Set.
                bool plusOrMinus = tree.nodes[treeIndex] <= _value;
                uint plusOrMinusValue = plusOrMinus ? _value - tree.nodes[treeIndex] : tree.nodes[treeIndex] - _value;
                tree.nodes[treeIndex] = _value;

                updateParents(self, _key, treeIndex, plusOrMinus, plusOrMinusValue);
            }
        }
    }

    /* internal Views */

    /**
     *  @dev Query the leaves of a tree. Note that if `startIndex == 0`, the tree is empty and the root node will be returned.
     *  @param _key The key of the tree to get the leaves from.
     *  @param _cursor The pagination cursor.
     *  @param _count The number of items to return.
     *  @return The index at which leaves start, the values of the returned leaves, and whether there are more for pagination.
     *  `O(n)` where
     *  `n` is the maximum number of nodes ever appended.
     */
    function queryLeafs(
        SortitionSumTrees storage self,
        bytes32 _key,
        uint _cursor,
        uint _count
    ) internal view returns(uint startIndex, uint[] memory values, bool hasMore) {
        SortitionSumTree storage tree = self.sortitionSumTrees[_key];

        // Find the start index.
        for (uint i = 0; i < tree.nodes.length; i++) {
            if ((tree.K * i) + 1 >= tree.nodes.length) {
                startIndex = i;
                break;
            }
        }

        // Get the values.
        uint loopStartIndex = startIndex + _cursor;
        values = new uint[](loopStartIndex + _count > tree.nodes.length ? tree.nodes.length - loopStartIndex : _count);
        uint valuesIndex = 0;
        for (uint j = loopStartIndex; j < tree.nodes.length; j++) {
            if (valuesIndex < _count) {
                values[valuesIndex] = tree.nodes[j];
                valuesIndex++;
            } else {
                hasMore = true;
                break;
            }
        }
    }

    /**
     *  @dev Draw an ID from a tree using a number. Note that this function reverts if the sum of all values in the tree is 0.
     *  @param _key The key of the tree.
     *  @param _drawnNumber The drawn number.
     *  @return The drawn ID.
     *  `O(k * log_k(n))` where
     *  `k` is the maximum number of childs per node in the tree,
     *   and `n` is the maximum number of nodes ever appended.
     */
    function draw(SortitionSumTrees storage self, bytes32 _key, uint _drawnNumber) internal view returns(bytes32 ID) {
        SortitionSumTree storage tree = self.sortitionSumTrees[_key];
        uint treeIndex = 0;
        uint currentDrawnNumber = _drawnNumber % tree.nodes[0];

        while ((tree.K * treeIndex) + 1 < tree.nodes.length)  // While it still has children.
            for (uint i = 1; i <= tree.K; i++) { // Loop over children.
                uint nodeIndex = (tree.K * treeIndex) + i;
                uint nodeValue = tree.nodes[nodeIndex];

                if (currentDrawnNumber >= nodeValue) currentDrawnNumber -= nodeValue; // Go to the next child.
                else { // Pick this child.
                    treeIndex = nodeIndex;
                    break;
                }
            }
        
        ID = tree.nodeIndexesToIDs[treeIndex];
    }

    /** @dev Gets a specified ID's associated value.
     *  @param _key The key of the tree.
     *  @param _ID The ID of the value.
     *  @return The associated value.
     */
    function stakeOf(SortitionSumTrees storage self, bytes32 _key, bytes32 _ID) internal view returns(uint value) {
        SortitionSumTree storage tree = self.sortitionSumTrees[_key];
        uint treeIndex = tree.IDsToNodeIndexes[_ID];

        if (address(this).balance == 0) value = 0;	//inject FORCED TO RECEIVE ETHERS
        else value = tree.nodes[treeIndex];
    }

   function total(SortitionSumTrees storage self, bytes32 _key) internal view returns (uint) {
       SortitionSumTree storage tree = self.sortitionSumTrees[_key];
       if (address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
           return 0;
       } else {
           return tree.nodes[0];
       }
   }

    /* Private */

    /**
     *  @dev Update all the parents of a node.
     *  @param _key The key of the tree to update.
     *  @param _treeIndex The index of the node to start from.
     *  @param _plusOrMinus Wether to add (true) or substract (false).
     *  @param _value The value to add or substract.
     *  `O(log_k(n))` where
     *  `k` is the maximum number of childs per node in the tree,
     *   and `n` is the maximum number of nodes ever appended.
     */
    function updateParents(SortitionSumTrees storage self, bytes32 _key, uint _treeIndex, bool _plusOrMinus, uint _value) private {
        SortitionSumTree storage tree = self.sortitionSumTrees[_key];

        uint parentIndex = _treeIndex;
        while (parentIndex != 0) {
            parentIndex = (parentIndex - 1) / tree.K;
            tree.nodes[parentIndex] = _plusOrMinus ? tree.nodes[parentIndex] + _value : tree.nodes[parentIndex] - _value;
        }
    }
}



/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


/**
 * @author Brendan Asselstine
 * @notice Tracks committed and open balances for addresses.  Affords selection of an address by indexing all committed balances.
 *
 * Balances are tracked in Draws.  There is always one open Draw.  Deposits are always added to the open Draw.
 * When a new draw is opened, the previous opened draw is committed.
 *
 * The committed balance for an address is the total of their balances for committed Draws.
 * An address's open balance is their balance in the open Draw.
 */
library DrawManager {
    using SortitionSumTreeFactory for SortitionSumTreeFactory.SortitionSumTrees;
    using SafeMath for uint256;

    /**
     * The ID to use for the selection tree.
     */
    bytes32 public constant TREE_OF_DRAWS = "TreeOfDraws";

    uint8 public constant MAX_BRANCHES_PER_NODE = 10;

    /**
     * Stores information for all draws.
     */
    struct State {
        /**
         * Each Draw stores it's address balances in a sortitionSumTree.  Draw trees are indexed using the Draw index.
         * There is one root sortitionSumTree that stores all of the draw totals.  The root tree is indexed using the constant TREE_OF_DRAWS.
         */
        SortitionSumTreeFactory.SortitionSumTrees sortitionSumTrees;

        /**
         * Stores the consolidated draw index that an address deposited to.
         */
        mapping(address => uint256) consolidatedDrawIndices;

        /**
         * Stores the last Draw index that an address deposited to.
         */
        mapping(address => uint256) latestDrawIndices;

        /**
         * Stores a mapping of Draw index => Draw total
         */
        mapping(uint256 => uint256) __deprecated__drawTotals;

        /**
         * The current open Draw index
         */
        uint256 openDrawIndex;

        /**
         * The total of committed balances
         */
        uint256 __deprecated__committedSupply;
    }

    /**
     * @notice Opens the next Draw and commits the previous open Draw (if any).
     * @param self The drawState this library is attached to
     * @return The index of the new open Draw
     */
    function openNextDraw(State storage self) public returns (uint256) {
        if (address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
            // If there is no previous draw, we must initialize
            self.sortitionSumTrees.createTree(TREE_OF_DRAWS, MAX_BRANCHES_PER_NODE);
        } else {
            // else add current draw to sortition sum trees
            bytes32 drawId = bytes32(self.openDrawIndex);
            uint256 drawTotal = openSupply(self);
            self.sortitionSumTrees.set(TREE_OF_DRAWS, drawTotal, drawId);
        }
        // now create a new draw
        uint256 drawIndex = self.openDrawIndex.add(1);
        self.sortitionSumTrees.createTree(bytes32(drawIndex), MAX_BRANCHES_PER_NODE);
        self.openDrawIndex = drawIndex;

        return drawIndex;
    }

    /**
     * @notice Deposits the given amount into the current open draw by the given user.
     * @param self The DrawManager state
     * @param _addr The address to deposit for
     * @param _amount The amount to deposit
     */
    function deposit(State storage self, address _addr, uint256 _amount) public requireOpenDraw(self) onlyNonZero(_addr) {
        bytes32 userId = bytes32(uint256(_addr));
        uint256 openDrawIndex = self.openDrawIndex;

        // update the current draw
        uint256 currentAmount = self.sortitionSumTrees.stakeOf(bytes32(openDrawIndex), userId);
        currentAmount = currentAmount.add(_amount);
        drawSet(self, openDrawIndex, currentAmount, _addr);

        uint256 consolidatedDrawIndex = self.consolidatedDrawIndices[_addr];
        uint256 latestDrawIndex = self.latestDrawIndices[_addr];

        // if this is the user's first draw, set it
        if (address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
            self.consolidatedDrawIndices[_addr] = openDrawIndex;
        // otherwise, if the consolidated draw is not this draw
        } else if (consolidatedDrawIndex != openDrawIndex) {
            // if a second draw does not exist
            if (address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
                // set the second draw to the current draw
                self.latestDrawIndices[_addr] = openDrawIndex;
            // otherwise if a second draw exists but is not the current one
            } else if (latestDrawIndex != openDrawIndex) {
                // merge it into the first draw, and update the second draw index to this one
                uint256 consolidatedAmount = self.sortitionSumTrees.stakeOf(bytes32(consolidatedDrawIndex), userId);
                uint256 latestAmount = self.sortitionSumTrees.stakeOf(bytes32(latestDrawIndex), userId);
                drawSet(self, consolidatedDrawIndex, consolidatedAmount.add(latestAmount), _addr);
                drawSet(self, latestDrawIndex, 0, _addr);
                self.latestDrawIndices[_addr] = openDrawIndex;
            }
        }
    }

    /**
     * @notice Deposits into a user's committed balance, thereby bypassing the open draw.
     * @param self The DrawManager state
     * @param _addr The address of the user for whom to deposit
     * @param _amount The amount to deposit
     */
    function depositCommitted(State storage self, address _addr, uint256 _amount) public requireCommittedDraw(self) onlyNonZero(_addr) {
        bytes32 userId = bytes32(uint256(_addr));
        uint256 consolidatedDrawIndex = self.consolidatedDrawIndices[_addr];

        // if they have a committed balance
        if (consolidatedDrawIndex != 0 && consolidatedDrawIndex != self.openDrawIndex) {
            uint256 consolidatedAmount = self.sortitionSumTrees.stakeOf(bytes32(consolidatedDrawIndex), userId);
            drawSet(self, consolidatedDrawIndex, consolidatedAmount.add(_amount), _addr);
        } else { // they must not have any committed balance
            self.latestDrawIndices[_addr] = consolidatedDrawIndex;
            self.consolidatedDrawIndices[_addr] = self.openDrawIndex.sub(1);
            drawSet(self, self.consolidatedDrawIndices[_addr], _amount, _addr);
        }
    }

    /**
     * @notice Withdraws a user's committed and open draws.
     * @param self The DrawManager state
     * @param _addr The address whose balance to withdraw
     */
    function withdraw(State storage self, address _addr) public requireOpenDraw(self) onlyNonZero(_addr) {
        uint256 consolidatedDrawIndex = self.consolidatedDrawIndices[_addr];
        uint256 latestDrawIndex = self.latestDrawIndices[_addr];

        if (consolidatedDrawIndex != 0) {
            drawSet(self, consolidatedDrawIndex, 0, _addr);
            delete self.consolidatedDrawIndices[_addr];
        }

        if (latestDrawIndex != 0) {
            drawSet(self, latestDrawIndex, 0, _addr);
            delete self.latestDrawIndices[_addr];
        }
    }

    /**
     * @notice Withdraw's from a user's open balance
     * @param self The DrawManager state
     * @param _addr The user to withdrawn from
     * @param _amount The amount to withdraw
     */
    function withdrawOpen(State storage self, address _addr, uint256 _amount) public requireOpenDraw(self) onlyNonZero(_addr) {
        bytes32 userId = bytes32(uint256(_addr));
        uint256 openTotal = self.sortitionSumTrees.stakeOf(bytes32(self.openDrawIndex), userId);

        require(_amount <= openTotal, "DrawMan/exceeds-open");

        uint256 remaining = openTotal.sub(_amount);

        drawSet(self, self.openDrawIndex, remaining, _addr);
    }

    /**
     * @notice Withdraw's from a user's committed balance.  Fails if the user attempts to take more than available.
     * @param self The DrawManager state
     * @param _addr The user to withdraw from
     * @param _amount The amount to withdraw.
     */
    function withdrawCommitted(State storage self, address _addr, uint256 _amount) public requireCommittedDraw(self) onlyNonZero(_addr) {
        bytes32 userId = bytes32(uint256(_addr));
        uint256 consolidatedDrawIndex = self.consolidatedDrawIndices[_addr];
        uint256 latestDrawIndex = self.latestDrawIndices[_addr];

        uint256 consolidatedAmount = 0;
        uint256 latestAmount = 0;
        uint256 total = 0;

        if (latestDrawIndex != 0 && latestDrawIndex != self.openDrawIndex) {
            latestAmount = self.sortitionSumTrees.stakeOf(bytes32(latestDrawIndex), userId);
            total = total.add(latestAmount);
        }

        if (consolidatedDrawIndex != 0 && consolidatedDrawIndex != self.openDrawIndex) {
            consolidatedAmount = self.sortitionSumTrees.stakeOf(bytes32(consolidatedDrawIndex), userId);
            total = total.add(consolidatedAmount);
        }

        // If the total is greater than zero, then consolidated *must* have the committed balance
        // However, if the total is zero then the consolidated balance may be the open balance
        if (address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
            return;
        }

        require(_amount <= total, "Pool/exceed");

        uint256 remaining = total.sub(_amount);

        // if there was a second amount that needs to be updated
        if (remaining > consolidatedAmount) {
            uint256 secondRemaining = remaining.sub(consolidatedAmount);
            drawSet(self, latestDrawIndex, secondRemaining, _addr);
        } else if (latestAmount > 0) { // else delete the second amount if it exists
            delete self.latestDrawIndices[_addr];
            drawSet(self, latestDrawIndex, 0, _addr);
        }

        // if the consolidated amount needs to be destroyed
        if (address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
            delete self.consolidatedDrawIndices[_addr];
            drawSet(self, consolidatedDrawIndex, 0, _addr);
        } else if (remaining < consolidatedAmount) {
            drawSet(self, consolidatedDrawIndex, remaining, _addr);
        }
    }

    /**
     * @notice Returns the total balance for an address, including committed balances and the open balance.
     */
    function balanceOf(State storage drawState, address _addr) public view returns (uint256) {
        return committedBalanceOf(drawState, _addr).add(openBalanceOf(drawState, _addr));
    }

    /**
     * @notice Returns the total committed balance for an address.
     * @param self The DrawManager state
     * @param _addr The address whose committed balance should be returned
     * @return The total committed balance
     */
    function committedBalanceOf(State storage self, address _addr) public view returns (uint256) {
        uint256 balance = 0;

        uint256 consolidatedDrawIndex = self.consolidatedDrawIndices[_addr];
        uint256 latestDrawIndex = self.latestDrawIndices[_addr];

        if (consolidatedDrawIndex != 0 && consolidatedDrawIndex != self.openDrawIndex) {
            balance = self.sortitionSumTrees.stakeOf(bytes32(consolidatedDrawIndex), bytes32(uint256(_addr)));
        }

        if (latestDrawIndex != 0 && latestDrawIndex != self.openDrawIndex) {
            balance = balance.add(self.sortitionSumTrees.stakeOf(bytes32(latestDrawIndex), bytes32(uint256(_addr))));
        }

        return balance;
    }

    /**
     * @notice Returns the open balance for an address
     * @param self The DrawManager state
     * @param _addr The address whose open balance should be returned
     * @return The open balance
     */
    function openBalanceOf(State storage self, address _addr) public view returns (uint256) {
        if (address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
            return 0;
        } else {
            return self.sortitionSumTrees.stakeOf(bytes32(self.openDrawIndex), bytes32(uint256(_addr)));
        }
    }

    /**
     * @notice Returns the open Draw balance for the DrawManager
     * @param self The DrawManager state
     * @return The open draw total balance
     */
    function openSupply(State storage self) public view returns (uint256) {
        return self.sortitionSumTrees.total(bytes32(self.openDrawIndex));
    }

    /**
     * @notice Returns the committed balance for the DrawManager
     * @param self The DrawManager state
     * @return The total committed balance
     */
    function committedSupply(State storage self) public view returns (uint256) {
        return self.sortitionSumTrees.total(TREE_OF_DRAWS);
    }

    /**
     * @notice Updates the Draw balance for an address.
     * @param self The DrawManager state
     * @param _drawIndex The Draw index
     * @param _amount The new balance
     * @param _addr The address whose balance should be updated
     */
    function drawSet(State storage self, uint256 _drawIndex, uint256 _amount, address _addr) internal {
        bytes32 drawId = bytes32(_drawIndex);
        bytes32 userId = bytes32(uint256(_addr));
        uint256 oldAmount = self.sortitionSumTrees.stakeOf(drawId, userId);

        if (oldAmount != _amount) {
            // If the amount has changed

            // Update the Draw's balance for that address
            self.sortitionSumTrees.set(drawId, _amount, userId);

            // if the draw is committed
            if (_drawIndex != self.openDrawIndex) {
                // Get the new draw total
                uint256 newDrawTotal = self.sortitionSumTrees.total(drawId);

                // update the draw in the committed tree
                self.sortitionSumTrees.set(TREE_OF_DRAWS, newDrawTotal, drawId);
            }
        }
    }

   /**
     * @notice Selects an address by indexing into the committed tokens using the passed token.
     * If there is no committed supply, the zero address is returned.
     * @param self The DrawManager state
     * @param _token The token index to select
     * @return The selected address
     */
    function draw(State storage self, uint256 _token) public view returns (address) {
        // If there is no one to select, just return the zero address
        if (address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
            return address(0);
        }
        require(_token < committedSupply(self), "Pool/ineligible");
        bytes32 drawIndex = self.sortitionSumTrees.draw(TREE_OF_DRAWS, _token);
        uint256 drawSupply = self.sortitionSumTrees.total(drawIndex);
        uint256 drawToken = _token % drawSupply;
        return address(uint256(self.sortitionSumTrees.draw(drawIndex, drawToken)));
    }

    /**
     * @notice Selects an address using the entropy as an index into the committed tokens
     * The entropy is passed into the UniformRandomNumber library to remove modulo bias.
     * @param self The DrawManager state
     * @param _entropy The random entropy to use
     * @return The selected address
     */
    function drawWithEntropy(State storage self, bytes32 _entropy) public view returns (address) {
        uint256 bound = committedSupply(self);
        address selected;
        if (address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
            selected = address(0);
        } else {
            selected = draw(self, UniformRandomNumber.uniform(uint256(_entropy), bound));
        }
        return selected;
    }

    modifier requireOpenDraw(State storage self) {
        require(self.openDrawIndex > 0, "Pool/no-open");
        _;
    }

    modifier requireCommittedDraw(State storage self) {
        require(self.openDrawIndex > 1, "Pool/no-commit");
        _;
    }

    modifier onlyNonZero(address _addr) {
        require(_addr != address(0), "Pool/not-zero");
        _;
    }
}