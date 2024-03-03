// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { THE_DOMAIN_IS_ALREADY_IN_USE } from "../utils/constants/index.sol";
import { Domain } from "../utils/structs/index.sol";
import { Holder } from "../roles/holder/holder.sol";

contract DomainLinked is Holder {
    mapping(address => Domain[]) private ownedDomains;
    Domain[] private domains;

    constructor(address tokenAddress) {
        set_token_address(tokenAddress);
    }

    function index(uint16 startIndex, uint16 endIndex) external view returns (Domain[] memory) {
        require(startIndex < domains.length && startIndex >= 0, 'startIndex must be greater than or equal to 0');
        require(endIndex < domains.length && endIndex >= startIndex, 'endIndex must be greater than or equal to startIndex');
        require((endIndex - startIndex) < 100, '100 items per request');

        unchecked {
            uint16 resultLength = endIndex - startIndex + 1;
            Domain[] memory list = new Domain[](resultLength);
            
            for (uint16 i = startIndex; i <= endIndex; i++)
                list[i - startIndex] = domains[i];

            return list;
        }
    }

    function getDomains() external view is_holder returns (Domain[] memory) {
        return ownedDomains[msg.sender];
    }

    function addDomain(string memory _extension, string memory _name) external is_holder {
        unchecked {
            for (uint i; i < domains.length; i++)
                if (keccak256(bytes(domains[i].extension)) == keccak256(bytes(_extension)) && keccak256(bytes(domains[i].name)) == keccak256(bytes(_name)))
                    revert(THE_DOMAIN_IS_ALREADY_IN_USE);
        }

        ownedDomains[msg.sender].push(Domain(_extension, _name));
        domains.push(Domain(_extension, _name));
    }
}
