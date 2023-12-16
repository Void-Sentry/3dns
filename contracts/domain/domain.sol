// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import { THE_DOMAIN_IS_ALREADY_IN_USE } from "../utils/constants/index.sol";
import { Holder } from "../roles/holder/holder.sol";
import { Domain } from "../utils/structs/index.sol";

contract DomainLinked is Holder {
    mapping(address => Domain[]) private ownedDomains;

    function getDomains() external view is_holder returns (Domain[] memory) {
        return ownedDomains[msg.sender];
    }

    function addDomain(bytes6 _extension, bytes32 _name) external is_holder {
        Domain[] memory domains = ownedDomains[msg.sender];

        unchecked {
            for (uint256 i; i < domains.length; ++i) {
                Domain memory domain = domains[i];
                if (domain.extension == _extension && domain.name == _name) {
                    revert(THE_DOMAIN_IS_ALREADY_IN_USE);
                }
            }
        }

        ownedDomains[msg.sender].push(Domain(_extension, _name));
    }
}
