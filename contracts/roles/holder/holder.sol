// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { ONLY_HOLDERS_CAN_DO_THIS, MIN_TO_BE_HOLDER } from "contracts/utils/constants/index.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IHolder } from "./iholder.sol";

contract Holder is Ownable {
    address private _tokenAddress;

    modifier is_holder() {
        uint amount = IERC20(_tokenAddress).balanceOf(msg.sender);
        require(amount >= MIN_TO_BE_HOLDER, ONLY_HOLDERS_CAN_DO_THIS);
        _;
    }

    constructor() Ownable(msg.sender) {}

    function set_token_address(address tokenAddress) public onlyOwner {
        _tokenAddress = tokenAddress;
    }

    function get_token_address() external view returns (address) {
        return _tokenAddress;
    }
}
