// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { Proposal } from "contracts/utils/structs/index.sol";

interface IVoteSystem {
    function index(uint16 startIndex, uint16 endIndex) external view returns (Proposal[] memory);
    function registerProposal(Proposal memory proposal) external;
    function giveRightToVote(address potentialVoter) external;
    function vote(Proposal memory proposal) external;
}