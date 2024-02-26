// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Token
uint8 constant DECIMALS = 18;

// Owner
string constant ONLY_THE_OWNER_CAN_DO_THIS = "Only the owner can do this";

// Holder
uint16 constant MIN_TO_BE_HOLDER = 2000;
string constant ONLY_HOLDERS_CAN_DO_THIS = "Only holders can do this";

// Proxy
string constant FORWARDING_CALL_FAILED = "Forwarding call failed";
string constant ONLY_ADMIN_CAN_UPDATE_CONTRACT = "Only admin can update Contract";

// Domain
string constant THE_DOMAIN_IS_ALREADY_IN_USE = "The domain is already in use";
string constant THE_SUBDOMAIN_IS_ALREADY_IN_USE = "The subdomain is already in use";

// VoteSystem
uint8 constant DEFAULT_WEIGHT = 1;
string constant ALREADY_HAS_THE_RIGHT_TO_VOTE = "already has the right to vote!";
string constant HAS_NO_RIGHT_TO_VOTE = "Has no right to vote";
string constant ALREADY_VOTED = "Already voted";