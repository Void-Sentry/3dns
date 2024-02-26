// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "contracts/token/t3dns.sol";

interface IHolder {
    function set_token(T3dns t3dns) external;
    function get_token() external view returns(T3dns);
}