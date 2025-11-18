// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/SimpleTreasury.sol";

contract SimpleTreasuryTest {
    SimpleTreasury treasury;
    address alice = address(0xAAAA);
    address bob = address(0xBBBB);

    function setUp() public {
        treasury = new SimpleTreasury();
    }

    function testDeposit() public {
        vm.prank(alice);
        treasury.deposit{value: 10 ether}();
        require(treasury.balances(alice) == 10 ether, "Deposit failed");
        require(treasury.totalFunds() == 10 ether, "Total funds failed");
    }

    function testWithdraw() public {
        vm.prank(alice);
        treasury.deposit{value: 10 ether}();
        
        vm.prank(alice);
        treasury.withdraw(5 ether);
        require(treasury.balances(alice) == 5 ether, "Withdraw failed");
    }

    function testReceiveEther() public {
        vm.prank(bob);
        (bool ok, ) = address(treasury).call{value: 5 ether}("");
        require(ok, "Receive failed");
        require(treasury.balances(bob) == 5 ether, "Balance failed");
    }

    function testTreasuryBalance() public {
        vm.prank(alice);
        treasury.deposit{value: 20 ether}();
        require(treasury.getTreasuryBalance() == 20 ether, "Treasury balance failed");
    }

    function testWithdrawFails() public {
        vm.prank(alice);
        try treasury.withdraw(100 ether) {
            require(false, "Should have reverted");
        } catch (bytes memory reason) {
            require(keccak256(reason) == keccak256(abi.encodeWithSignature("Error(string)", "Insufficient balance")), "Wrong error");
        }
    }
}
