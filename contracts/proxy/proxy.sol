// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import { ONLY_ADMIN_CAN_UPDATE_CONTRACT, FORWARDING_CALL_FAILED } from "../utils/constants/index.sol";
import { Holder } from "../roles/holder/holder.sol";
import { Owner } from "../roles/owner/owner.sol";
import { IProxy } from "./iproxy.sol";

contract Proxy is Owner, Holder, IProxy {
    address private _delegate;

    constructor(address delegate) {
        _delegate = delegate;
        set_owner(msg.sender);
    }

    function setDelegate(address delegate) is_owner external {
        require(msg.sender == get_owner(), ONLY_ADMIN_CAN_UPDATE_CONTRACT);
        _delegate = delegate;
    }

    function forward(bytes memory _data) is_holder external returns(bytes memory) {
        (bool success, bytes memory result) = address(_delegate).call(_data);
        require(success, FORWARDING_CALL_FAILED);
        return result;
    }
}
