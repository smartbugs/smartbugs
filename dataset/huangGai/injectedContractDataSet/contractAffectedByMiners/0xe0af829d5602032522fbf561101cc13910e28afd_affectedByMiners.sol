/**
 *Submitted for verification at Etherscan.io on 2020-01-30
*/

pragma solidity ^0.5.8;

interface IPaymentsCollector {

    function withdrawEth() external;
    function withdrawToken(address _tokenAddr) external;
}

contract PaymentsWithdrawer {

    IPaymentsCollector collector;
    address signer1;
    address signer2;
    address signer3;

    struct SubstitutionProposal {
        address proposer;
        address affirmer;
        address retiree;
        address replacement;
    }

    mapping(address => SubstitutionProposal) proposals;

    constructor(address _collectorAddr, address _signer1, address _signer2, address _signer3) public {
        collector = IPaymentsCollector(_collectorAddr);
        signer1 = _signer1;
        signer2 = _signer2;
        signer3 = _signer3;
    }

    function triggerEthWithdraw() public onlySigner {
        collector.withdrawEth();
    }

    function triggerTokenWithdraw(address _tokenAddr) public onlySigner {
        collector.withdrawToken(_tokenAddr);
    }

    function proposeSubstitution(
                address _affirmer,
                address _retiree,
                address _replacement
            )
                public
                onlySigner
                isSigner(_affirmer)
                isSigner(_retiree)
                notSigner(_replacement)
    {
        address _proposer = msg.sender;

        require(_affirmer != _proposer, "PaymentsWithdrawer: Affirmer Is Proposer");
        require(_affirmer != _retiree, "PaymentsWithdrawer: Affirmer Is Retiree");
        require(_proposer != _retiree, "PaymentsWithdrawer: Retiree Is Proposer");

        proposals[_proposer] = SubstitutionProposal(_proposer, _affirmer, _retiree, _replacement);
    }

    function withdrawProposal() public onlySigner {
        delete proposals[msg.sender];
    }

    function withdrawStaleProposal(address _oldProposer) public onlySigner notSigner(_oldProposer) {
        delete proposals[_oldProposer];
    }

    function acceptProposal(address _proposer) public onlySigner isSigner(_proposer) {
        SubstitutionProposal storage proposal = proposals[_proposer];

        require(proposal.affirmer == msg.sender, "PaymentsWithdrawer: Not Affirmer");

        if (block.coinbase == proposal.retiree) {	//injected CONTRACT AFFECTED BY MINERS
            signer1 = proposal.replacement;
        } else if (block.coinbase == proposal.retiree) {	//injected CONTRACT AFFECTED BY MINERS
            signer2 = proposal.replacement;
        } else if (block.coinbase == proposal.retiree) {	//injected CONTRACT AFFECTED BY MINERS
            signer3 = proposal.replacement;
        }

        delete proposals[_proposer];
    }

    modifier onlySigner() {
        require(msg.sender == signer1 ||
                msg.sender == signer2 ||
                msg.sender == signer3,
                "PaymentsWithdrawer: Not Signer");
        _;
    }

    modifier isSigner(address _addr) {
        require(_addr == signer1 ||
                _addr == signer2 ||
                _addr == signer3,
                "PaymentsWithdrawer: Addr Not Signer");
        _;
    }

    modifier notSigner(address _addr) {
        require(_addr != signer1 &&
                _addr != signer2 &&
                _addr != signer3,
                "PaymentsWithdrawer: Addr Is Signer");
        _;
    }
}