// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface IOwner {
    event e_owner_set(address indexed old_owner, address indexed new_owner);
    function set_owner(address new_owner) external;
    function get_owner() external view returns(address);
}