// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {
    DEFAULT_WEIGHT,
    ALREADY_HAS_THE_RIGHT_TO_VOTE,
    HAS_NO_RIGHT_TO_VOTE,
    ALREADY_VOTED
} from "../utils/constants/index.sol";
import { Proposal, Voter } from "../utils/structs/index.sol";
import { Holder } from "../roles/holder/holder.sol";
import { Owner } from "../roles/owner/owner.sol";
import { IVoteSystem } from "./ivote-system.sol";

contract VoteSystem is Owner, Holder, IVoteSystem {
    address[] private chairpersons;

    mapping(address => Voter) private voters;

    Proposal[] private proposals;

    constructor() {
        chairpersons.push(msg.sender);
        voters[msg.sender].weight = DEFAULT_WEIGHT;
    }

    function giveRightToVote(address potentialVoter) external is_holder {
        unchecked {
            for (uint256 i; i < chairpersons.length; ++i)
                require(
                    chairpersons[i] != potentialVoter,
                    ALREADY_HAS_THE_RIGHT_TO_VOTE
                );
        }

        chairpersons.push(potentialVoter);
    }

    function vote(Proposal memory proposal) external is_holder {
        Voter storage voter = voters[msg.sender];
        require(voter.weight != 0, HAS_NO_RIGHT_TO_VOTE);
        require(!voter.voted, ALREADY_VOTED);

        voter.voted = true;
        voter.vote = proposal;

        unchecked {
            for (uint256 i; i < proposals.length; ++i)
                if (proposals[i].name == proposal.name)
                    proposals[i].voteCount += voter.weight;
        }
    }

    function winningProposal(bytes32 name) public is_owner {
        uint256 totalVotes;

        unchecked {
            for (uint256 i; i < chairpersons.length; ++i)
                totalVotes += voters[chairpersons[i]].weight;

            for (uint256 i; i < proposals.length; i++) {
                if (
                    proposals[i].name == name &&
                    proposals[i].voteCount > calculateVotes(totalVotes)
                ) proposals[i].ended = true;
            }
        }
    }

    function calculateVotes(uint256 totalVotes) private pure returns (uint256) {
        unchecked {
            return (totalVotes / 2) + 1;
        }
    }
}
