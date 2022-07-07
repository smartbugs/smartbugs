pragma solidity ^0.5.0;	//inject UNLIMITED COMPILER VERSIONS

contract Prize {
    event Successful(address winner, uint withdrawableHeight);

    bytes32 private flagHash;

    mapping(address => bytes32) private commits;
    mapping(address => uint) private heights;

    address payable private winner;
    uint private withdrawableHeight;

    constructor(bytes32 _flagHash) public payable {
        flagHash = _flagHash;
        withdrawableHeight = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    }

    function commit(bytes32 commitment) external {
        commits[msg.sender] = commitment;
        heights[msg.sender] = block.number + 256;
    }
    function reveal(bytes32 flag) external {
        require(calcFlagHash(flag) == flagHash);
        require(calcCommitment(flag, msg.sender) == commits[msg.sender]);
        require(heights[msg.sender] < withdrawableHeight);
        emit Successful(
            winner = msg.sender,
            withdrawableHeight = heights[msg.sender]
        );
    }
    function withdraw() external {
        require(msg.sender == winner);
        require(block.number >= withdrawableHeight);
        selfdestruct(winner);
    }

    function calcFlagHash(bytes32 flag) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(flag));
    }
    function calcCommitment(bytes32 flag, address sender) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(flag, sender));
    }
}