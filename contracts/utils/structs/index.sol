// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

struct SubDomain {
    string name;
}

struct Domain {
    string extension;
    string name;
}

struct Voter {
    uint256 weight;
    bool voted;
    address delegate;
    Proposal vote;
}

struct Proposal {
    string name;
    string description;
    uint256 voteCount;
    bool ended;
}
