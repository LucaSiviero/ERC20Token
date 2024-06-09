// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BetterToken} from "../src/BetterToken.sol";

contract DeployBetterToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000000 ether;

    function run() public returns (BetterToken) {
        vm.startBroadcast();
        BetterToken betterToken = new BetterToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return betterToken;
    }
}
