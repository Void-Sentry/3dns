// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { ONLY_ADMIN_CAN_UPDATE_CONTRACT, FORWARDING_CALL_FAILED } from "../utils/constants/index.sol";
import { Holder } from "../roles/holder/holder.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IProxy } from "./iproxy.sol";

contract Proxy is Ownable, Holder {
    address private _delegate;

    constructor() Ownable(msg.sender) {}
    // constructor(address delegate) {
    //     _delegate = delegate;
    // }

    function setDelegate(address delegate) onlyOwner external {
        require(msg.sender == owner(), ONLY_ADMIN_CAN_UPDATE_CONTRACT);
        _delegate = delegate;
    }

    function forward(bytes memory _data) is_holder external returns(bytes memory) {
        (bool success, bytes memory result) = address(_delegate).call(_data);
        require(success, FORWARDING_CALL_FAILED);
        return result;
    }
}
