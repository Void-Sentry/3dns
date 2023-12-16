// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import { Proposal } from "contracts/utils/structs/index.sol";

interface IVoteSystem {
    function giveRightToVote(address potentialVoter) external;
    function vote(Proposal memory proposal) external;
}