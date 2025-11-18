// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleTreasury.sol";

contract SimpleTreasuryTest is Test {
    SimpleTreasury treasury;
    address alice = address(0xAAAA);
    address bob = address(0xBBBB);

    function setUp() public {
        treasury = new SimpleTreasury();
    }

    function testDeposit() public {
        vm.prank(alice);
        treasury.deposit{value: 10 ether}();
        assertEq(treasury.balances(alice), 10 ether);
        assertEq(treasury.totalFunds(), 10 ether);
    }

    function testWithdraw() public {
        vm.prank(alice);
        treasury.deposit{value: 10 ether}();
        
        vm.prank(alice);
        treasury.withdraw(5 ether);
        assertEq(treasury.balances(alice), 5 ether);
    }

    function testReceiveEther() public {
        vm.prank(bob);
        (bool ok, ) = address(treasury).call{value: 5 ether}("");
        require(ok);
        assertEq(treasury.balances(bob), 5 ether);
    }

    function testTreasuryBalance() public {
        vm.prank(alice);
        treasury.deposit{value: 20 ether}();
        assertEq(treasury.getTreasuryBalance(), 20 ether);
    }

    function testWithdrawFails() public {
        vm.prank(alice);
        vm.expectRevert("Insufficient balance");
        treasury.withdraw(100 ether);
    }
}
