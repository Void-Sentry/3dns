// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { T3dns } from "contracts/token/t3dns.sol";
import { ONLY_THE_OWNER_CAN_DO_THIS } from "contracts/utils/constants/index.sol";
import { IOwner } from "./iowner.sol";

contract Owner is IOwner {
    address private _owner;

    modifier is_owner() {
        require(msg.sender == _owner, ONLY_THE_OWNER_CAN_DO_THIS);
        _;
    }

    constructor() {
        _owner = msg.sender;
        emit e_owner_set(address(0), _owner);
    }

    function set_owner(address new_owner) is_owner public {
        emit e_owner_set(_owner, new_owner);
        _owner = new_owner;
    }

    function get_owner() public view returns(address) {
        return _owner;
    }
}
