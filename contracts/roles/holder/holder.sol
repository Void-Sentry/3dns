// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import { T3dns } from "contracts/token/t3dns.sol";
import { Owner } from "../owner/owner.sol";
import {
    ONLY_HOLDERS_CAN_DO_THIS,
    MIN_TO_BE_HOLDER
} from "contracts/utils/constants/index.sol";
import { IHolder } from "./iholder.sol";

contract Holder is Owner, IHolder {
    T3dns private _token;

    modifier is_holder() {
        require(
            _token.balanceOf(msg.sender) > MIN_TO_BE_HOLDER,
            ONLY_HOLDERS_CAN_DO_THIS
        );
        _;
    }

    function set_token(T3dns t3dns) external is_owner {
        _token = t3dns;
    }

    function get_token() external view returns (T3dns) {
        return _token;
    }
}
