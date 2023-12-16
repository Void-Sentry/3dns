// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

interface IProxy {
    function setDelegate(address delegate) external;
    function forward(bytes memory _data) external returns(bytes memory);
}