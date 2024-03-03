// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { THE_SUBDOMAIN_IS_ALREADY_IN_USE } from "../utils/constants/index.sol";
import { SubDomain } from "../utils/structs/index.sol";
import { Holder } from "../roles/holder/holder.sol";

contract SDomainLinked is Holder {
    mapping(string => SubDomain[]) private ownedSubDomains;
    SubDomain[] private subDomains;

    constructor(address tokenAddress) {
        set_token_address(tokenAddress);
    }

    function index(uint16 startIndex, uint16 endIndex) external view returns (SubDomain[] memory) {
        require(startIndex < subDomains.length && startIndex >= 0, 'startIndex must be greater than or equal to 0');
        require(endIndex < subDomains.length && endIndex >= startIndex, 'endIndex must be greater than or equal to startIndex');
        require((endIndex - startIndex) < 100, '100 items per request');

        unchecked {
            uint16 resultLength = endIndex - startIndex + 1;
            SubDomain[] memory list = new SubDomain[](resultLength);
            
            for (uint16 i = startIndex; i <= endIndex; i++)
                list[i - startIndex] = subDomains[i];

            return list;
        }
    }

    function getSubDomains(string memory _extension, string memory _name)
        external
        view
        is_holder
        returns (SubDomain[] memory)
    {
        string memory key = string(abi.encodePacked(_extension, _name, msg.sender));
        return ownedSubDomains[key];
    }

    function addSubDomain(string memory _extension, string memory _name, string memory _sname) external is_holder {
        string memory key = string(abi.encodePacked(_extension, _name, msg.sender));

        unchecked {
            if (ownedSubDomains[key].length != 0)
                for (uint256 i; i < ownedSubDomains[key].length; i++)
                    if (keccak256(bytes(ownedSubDomains[key][i].name)) == keccak256(bytes(_sname)))
                        revert(THE_SUBDOMAIN_IS_ALREADY_IN_USE);

            ownedSubDomains[key].push(SubDomain(_sname));
            subDomains.push(SubDomain(_sname));
        }
    }
}
