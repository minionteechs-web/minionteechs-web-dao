// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleToken.sol";

contract SimpleTokenTest is Test {
    SimpleToken token;
    address alice = address(0xAAAA);
    address bob = address(0xBBBB);

    function setUp() public {
        token = new SimpleToken();
    }

    function testMint() public {
        token.mint(alice, 1000e18);
        assertEq(token.balanceOf(alice), 1000e18);
        assertEq(token.totalSupply(), 1000e18);
    }

    function testBurn() public {
        token.mint(alice, 1000e18);
        vm.prank(alice);
        token.burn(100e18);
        assertEq(token.balanceOf(alice), 900e18);
        assertEq(token.totalSupply(), 900e18);
    }

    function testTransfer() public {
        token.mint(alice, 1000e18);
        vm.prank(alice);
        bool ok = token.transfer(bob, 100e18);
        assertTrue(ok);
        assertEq(token.balanceOf(bob), 100e18);
        assertEq(token.balanceOf(alice), 900e18);
    }

    function testApprove() public {
        vm.prank(alice);
        bool ok = token.approve(bob, 500e18);
        assertTrue(ok);
        assertEq(token.allowance(alice, bob), 500e18);
    }

    function testTransferFrom() public {
        token.mint(alice, 1000e18);
        vm.prank(alice);
        token.approve(bob, 500e18);
        
        vm.prank(bob);
        bool ok = token.transferFrom(alice, bob, 200e18);
        assertTrue(ok);
        assertEq(token.balanceOf(bob), 200e18);
        assertEq(token.allowance(alice, bob), 300e18);
    }
}
