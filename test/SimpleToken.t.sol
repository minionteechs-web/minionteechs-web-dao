// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/SimpleToken.sol";

contract SimpleTokenTest {
    SimpleToken token;
    address alice = address(0xAAAA);
    address bob = address(0xBBBB);

    function setUp() public {
        token = new SimpleToken();
    }

    function testMint() public {
        token.mint(alice, 1000e18);
        require(token.balanceOf(alice) == 1000e18, "Mint failed");
        require(token.totalSupply() == 1000e18, "Total supply failed");
    }

    function testBurn() public {
        token.mint(alice, 1000e18);
        vm.prank(alice);
        token.burn(100e18);
        require(token.balanceOf(alice) == 900e18, "Burn failed");
        require(token.totalSupply() == 900e18, "Total supply failed");
    }

    function testTransfer() public {
        token.mint(alice, 1000e18);
        vm.prank(alice);
        bool ok = token.transfer(bob, 100e18);
        require(ok, "Transfer failed");
        require(token.balanceOf(bob) == 100e18, "Bob balance failed");
        require(token.balanceOf(alice) == 900e18, "Alice balance failed");
    }

    function testApprove() public {
        vm.prank(alice);
        bool ok = token.approve(bob, 500e18);
        require(ok, "Approve failed");
        require(token.allowance(alice, bob) == 500e18, "Allowance failed");
    }

    function testTransferFrom() public {
        token.mint(alice, 1000e18);
        vm.prank(alice);
        token.approve(bob, 500e18);
        
        vm.prank(bob);
        bool ok = token.transferFrom(alice, bob, 200e18);
        require(ok, "TransferFrom failed");
        require(token.balanceOf(bob) == 200e18, "Bob balance failed");
        require(token.allowance(alice, bob) == 300e18, "Allowance failed");
    }
}
