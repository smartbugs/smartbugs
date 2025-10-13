// SPDX-License-Identifier: MIT

/**
 * @title NoPragmaContract
 * @dev Edge case contract without pragma statement for testing pragma parsing
 * Note: This will use the compiler's default version when compiled
 */
contract NoPragmaContract {
    address public owner;
    uint256 public value;

    event ValueChanged(uint256 newValue);
    event OwnerChanged(address newOwner);

    constructor() {
        owner = msg.sender;
        value = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function setValue(uint256 _value) public onlyOwner {
        value = _value;
        emit ValueChanged(_value);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
        emit OwnerChanged(newOwner);
    }

    function getValue() public view returns (uint256) {
        return value;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}
