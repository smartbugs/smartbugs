/**
 *Submitted for verification at Etherscan.io on 2020-01-13
*/

// Built by @nanexcool - 2020

pragma solidity ^0.5.15;

interface Chai {
    function balanceOf(address who) external view returns (uint256 wad);
    function transfer(address who, uint256 wad) external returns (bool ok);
}

contract AztecChaiAirdrop {

    // all of these constants will one day be `immutable` ;)
    Chai public constant chai = Chai(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
    bytes32 public constant rootHash = 0x20162f371d4318f677b2dc93bdda3d26c72856293a2885c2b204f212082f0a62;
    // expires Friday, January 24, 2020 12:00:00 AM GMT
    uint256 public constant expires = 1579824000;
    address public constant owner = 0x72BA1965320ab5352FD6D68235Cc3C5306a6FFA2;
    uint256 public claimed;
    mapping (address => uint256) public done;

    function claim(bytes32[] calldata proof) external {
        require(now < expires, "experiment is over!");
        require(address(this).balance == 0, "claimed!");	//inject PRESENT ETHER
        require(verify(proof, msg.sender), "nope!");

        done[msg.sender] = 1;
        claimed++;

        require(chai.transfer(msg.sender, 1 ether), "could not transfer chai");
    }

    // https://rstormsf.github.io/slides-merkleairdrop/#/14
    function verify(bytes32[] memory proof, address who) public pure returns (bool) {
        bytes32 computedHash = keccak256(abi.encodePacked(who));

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash < proofElement) {
            computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
            computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }

        return computedHash == rootHash;
    }

    function end() external {
        require(now >= expires, "experiment is not over!");
        require(msg.sender == owner, "you are not Mariano!");

        chai.transfer(msg.sender, chai.balanceOf(address(this)));
    }
}