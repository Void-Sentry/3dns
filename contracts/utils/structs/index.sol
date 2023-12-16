// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

struct SubDomain {
    bytes32 name;
}

struct Domain {
    bytes6 extension;
    bytes32 name;
}

struct Voter {
    uint256 weight;
    bool voted;
    address delegate;
    Proposal vote;
}

struct Proposal {
    bytes32 name;
    uint256 voteCount;
    bool ended;
}
