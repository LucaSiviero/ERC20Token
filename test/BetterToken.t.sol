// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployBetterToken} from "../script/DeployBetterToken.s.sol";
import {BetterToken} from "../src/BetterToken.sol";

contract BetterTokenTest is Test {
    BetterToken public betterToken;
    DeployBetterToken public deployBetterToken;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployBetterToken = new DeployBetterToken();
        betterToken = deployBetterToken.run();
    }

    function testInitialMinting() public {
        uint256 initialSupply = betterToken.totalSupply();
        assertEq(initialSupply, 1000000 ether);
    }

    function testUserCantMint() public {
        vm.expectRevert(BetterToken.BetterToken__AlreadyMinted.selector);
        betterToken.mint(msg.sender, 100);
    }

    function testTransferToUser() public {
        vm.prank(msg.sender);
        betterToken.transfer(bob, STARTING_BALANCE);
        assert(betterToken.balanceOf(bob) == STARTING_BALANCE);
    }

    modifier sendMoneyToBob() {
        vm.prank(msg.sender);
        betterToken.transfer(bob, STARTING_BALANCE);
        _;
    }

    function testAllowancesWorks() public sendMoneyToBob {
        uint256 initialAllowance = 1000;
        uint256 transferAmout = 500;
        uint256 bobInitialBalance = betterToken.balanceOf(bob);
        uint256 aliceInitialBalance = betterToken.balanceOf(alice);

        // Now Bob approves that Alice spends token on her behalf
        vm.prank(bob);
        betterToken.approve(alice, initialAllowance);

        vm.prank(alice);
        betterToken.transferFrom(bob, alice, transferAmout);

        assert(betterToken.balanceOf(bob) == bobInitialBalance - transferAmout);
        assert(
            betterToken.balanceOf(alice) == aliceInitialBalance + transferAmout
        );
    }

    function testTransferFromFailsWithoutAllowance() public sendMoneyToBob {
        vm.prank(alice);
        vm.expectRevert();
        betterToken.transferFrom(bob, alice, 1 ether);
    }

    function testTransferFromFailsWhenExceedAllowance() public sendMoneyToBob {
        vm.prank(bob);
        betterToken.approve(alice, 1000);

        vm.prank(alice);
        vm.expectRevert();
        betterToken.transferFrom(bob, alice, 1001);
    }
}
