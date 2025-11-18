// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GovernanceToken.sol";

contract GovernanceTokenTest is Test {
    GovernanceToken token;
    address alice = address(0xAAAA);
    address bob = address(0xBBBB);

    function setUp() public {
        token = new GovernanceToken();
    }

    function testMint() public {
        token.mint(alice, 1000e18);
        assertEq(token.balanceOf(alice), 1000e18);
    }

    function testBurn() public {
        token.mint(alice, 1000e18);
        vm.prank(alice);
        token.burn(100e18);
        assertEq(token.balanceOf(alice), 900e18);
    }

    function testDelegate() public {
        token.mint(alice, 1000e18);
        vm.prank(alice);
        token.delegate(alice);
        assertEq(token.getVotes(alice), 1000e18);
    }

    function testTransfer() public {
        token.mint(alice, 1000e18);
        vm.prank(alice);
        token.transfer(bob, 100e18);
        assertEq(token.balanceOf(bob), 100e18);
        assertEq(token.balanceOf(alice), 900e18);
    }

    function testMaxSupply() public {
        token.mint(alice, 100_000_000e18);
        vm.expectRevert("Exceeds max supply");
        token.mint(bob, 1e18);
    }
}
