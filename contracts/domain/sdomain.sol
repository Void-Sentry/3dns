// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { THE_SUBDOMAIN_IS_ALREADY_IN_USE } from "../utils/constants/index.sol";
import { Holder } from "../roles/holder/holder.sol";
import { SubDomain } from "../utils/structs/index.sol";

contract SDomainLinked is Holder {
    mapping(bytes => SubDomain[]) private ownedSubDomains;
    SubDomain[] private subDomains;

    function index(uint16 startIndex, uint16 endIndex) external view returns (SubDomain[] memory) {
        SubDomain[] memory list;

        require(startIndex < subDomains.length && startIndex >= 0, 'startIndex must be great then 0');
        require(endIndex < subDomains.length && endIndex > startIndex, 'endIndex must be great then startIndex');
        
        unchecked {
            for (uint16 i = startIndex; i < endIndex; ++i)
                list[i] = subDomains[i];
        }

        return list;
    }

    function getSubDomains(bytes6 _extension, bytes32 _name)
        external
        view
        is_holder
        returns (SubDomain[] memory)
    {
        bytes memory key = abi.encodePacked(_extension, _name, msg.sender);
        return ownedSubDomains[key];
    }

    function addSubDomain(bytes6 _extension, bytes32 _name) external is_holder {
        bytes memory key = abi.encodePacked(_extension, _name, msg.sender);

        unchecked {
            for (uint256 i; i < ownedSubDomains[key].length; ++i) {
                SubDomain memory sd = ownedSubDomains[key][i];
                if (sd.name == _name) revert(THE_SUBDOMAIN_IS_ALREADY_IN_USE);
            }
        }

        ownedSubDomains[key].push(SubDomain(_name));
        subDomains.push(SubDomain(_name));
    }
}
