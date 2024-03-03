// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Proposal, Voter } from "../utils/structs/index.sol";
import { Holder } from "../roles/holder/holder.sol";

import {
    DEFAULT_WEIGHT,
    ALREADY_HAS_THE_RIGHT_TO_VOTE,
    HAS_NO_RIGHT_TO_VOTE,
    ALREADY_VOTED
} from "../utils/constants/index.sol";

contract VoteSystem is Holder {
    address[] private chairpersons;
    Proposal[] private proposals;

    mapping(address => Voter) private voters;

    constructor(address tokenAddress) {
        chairpersons.push(msg.sender);
        voters[msg.sender].weight = DEFAULT_WEIGHT;
        set_token_address(tokenAddress);
    }

    function index(uint16 startIndex, uint16 endIndex) external view returns (Proposal[] memory) {
        require(startIndex < proposals.length && startIndex >= 0, 'startIndex must be greater than or equal to 0');
        require(endIndex < proposals.length && endIndex >= startIndex, 'endIndex must be greater than or equal to startIndex');
        require((endIndex - startIndex) < 100, '100 items per request');

        unchecked {
            uint16 resultLength = endIndex - startIndex + 1;
            Proposal[] memory list = new Proposal[](resultLength);
            
            for (uint16 i = startIndex; i <= endIndex; i++)
                list[i - startIndex] = proposals[i];

            return list;
        }
    }

    function registerProposal(Proposal memory proposal) external onlyOwner {
        proposals.push(proposal);
    }

    function giveRightToVote(address potentialVoter) external is_holder {
        bool alreadyExists = false;
        for (uint256 i = 0; i < chairpersons.length; i++) {
            if (chairpersons[i] == potentialVoter) {
                alreadyExists = true;
                break;
            }
        }
        require(!alreadyExists, 'you have been rights');

        chairpersons.push(potentialVoter);
    }

    function vote(Proposal memory proposal) external is_holder {
        Voter storage voter = voters[msg.sender];
        require(!voter.voted, ALREADY_VOTED);

        voter.voted = true;
        voter.vote = proposal;
        voter.weight = 1;

        unchecked {
            for (uint256 i; i < proposals.length; i++)
                if (keccak256(bytes(proposals[i].name)) == keccak256(bytes(proposal.name)))
                    proposals[i].voteCount += voter.weight;
        }
    }

    function winningProposal(string memory name) public onlyOwner {
        uint256 totalVotes;

        unchecked {
            for (uint256 i; i < chairpersons.length; i++)
                totalVotes += voters[chairpersons[i]].weight;

            for (uint256 i; i < proposals.length; i++) {
                if (
                    keccak256(bytes(proposals[i].name)) == keccak256(bytes(name)) &&
                    proposals[i].voteCount > calculateVotes(totalVotes)
                ) proposals[i].ended = true;
            }
        }
    }

    function calculateVotes(uint256 totalVotes) private pure returns (uint256) {
        unchecked {
            return (totalVotes >> 1) + 1;
        }
    }
}
