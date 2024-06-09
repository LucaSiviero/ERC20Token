// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BetterToken is ERC20 {
    error BetterToken__AlreadyMinted();

    bool private immutable i_tokensMinted = false;

    constructor(uint256 initialSupply) ERC20("BetterToken", "BTT") {
        _mint(msg.sender, initialSupply);
        i_tokensMinted = true;
    }
}
