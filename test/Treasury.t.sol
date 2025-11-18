// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Treasury.sol";

contract TreasuryTest is Test {
    Treasury treasury;
    address owner;
    address alice = address(0xAAAA);
    address bob = address(0xBBBB);

    function setUp() public {
        owner = msg.sender;
        treasury = new Treasury();
    }

    function testDeposit() public {
        uint256 amount = 10 ether;
        
        vm.prank(alice);
        treasury.deposit{value: amount}();
        
        assertEq(treasury.getTreasuryBalance(), amount);
        assertEq(treasury.balance(alice), amount);
        assertEq(treasury.totalFunds(), amount);
    }

    function testReceive() public {
        uint256 amount = 5 ether;
        
        vm.prank(alice);
        (bool success, ) = address(treasury).call{value: amount}("");
        require(success);
        
        assertEq(treasury.getTreasuryBalance(), amount);
    }

    function testWithdraw() public {
        uint256 amount = 10 ether;
        
        vm.prank(alice);
        treasury.deposit{value: amount}();
        
        treasury.withdraw(payable(bob), amount);
        
        assertEq(bob.balance, amount);
        assertEq(treasury.getTreasuryBalance(), 0);
    }

    function testWithdrawInsufficientFunds() public {
        uint256 amount = 10 ether;
        
        vm.prank(alice);
        treasury.deposit{value: amount}();
        
        vm.expectRevert("Insufficient funds");
        treasury.withdraw(payable(bob), amount + 1 ether);
    }

    function testWithdrawOnlyOwner() public {
        uint256 amount = 10 ether;
        
        vm.prank(alice);
        treasury.deposit{value: amount}();
        
        vm.prank(bob);
        vm.expectRevert();
        treasury.withdraw(payable(bob), amount);
    }

    function testGetUserBalance() public {
        uint256 amount = 5 ether;
        
        vm.prank(alice);
        treasury.deposit{value: amount}();
        
        assertEq(treasury.getUserBalance(alice), amount);
    }

    function testMultipleDeposits() public {
        uint256 amount1 = 5 ether;
        uint256 amount2 = 3 ether;
        
        vm.prank(alice);
        treasury.deposit{value: amount1}();
        
        vm.prank(alice);
        treasury.deposit{value: amount2}();
        
        assertEq(treasury.getUserBalance(alice), amount1 + amount2);
        assertEq(treasury.getTreasuryBalance(), amount1 + amount2);
    }
}
