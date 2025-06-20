// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract VotingSystem {
    address public admin;
    uint public proposalCount;

    struct Proposal {
        uint id;
        string description;
        uint voteCount;
        bool exists;
    }

    mapping(uint => Proposal) public proposals;
    mapping(address => mapping(uint => bool)) public hasVoted;

    event ProposalCreated(uint id, string description);
    event Voted(uint proposalId, address voter);

    constructor() {
        admin = msg.sender;
    }

    function createProposal(string memory _description) public {
        require(msg.sender == admin, "Only admin can create proposals");
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, _description, 0, true);
        emit ProposalCreated(proposalCount, _description);
    }

    function vote(uint _proposalId) public {
        require(proposals[_proposalId].exists, "Proposal does not exist");
        require(!hasVoted[msg.sender][_proposalId], "You have already voted");
        proposals[_proposalId].voteCount++;
        hasVoted[msg.sender][_proposalId] = true;
        emit Voted(_proposalId, msg.sender);
    }

    function getProposal(uint _proposalId) public view returns (string memory, uint) {
        Proposal memory p = proposals[_proposalId];
        return (p.description, p.voteCount);
    }

    function getTotalProposals() public view returns (uint) {
        return proposalCount;
    }
}
