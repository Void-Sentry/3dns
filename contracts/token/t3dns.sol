// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// import { ERC20 } from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Owner } from "../roles/owner/owner.sol";

contract T3dns is ERC20, Ownable {
    constructor() ERC20("Token 3DNS", "TDNS") Ownable(msg.sender) {
        _mint(msg.sender, 1e24);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
