// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Timelock.sol";

contract TimelockTest is Test {
    Timelock timelock;
    address admin;
    address alice = address(0xAAAA);
    address target = address(0xCCCC);

    function setUp() public {
        admin = msg.sender;
        timelock = new Timelock(3 days);
    }

    function testQueueAndExecute() public {
        bytes memory data = "";
        
        vm.prank(admin);
        bytes32 id = timelock.queue(target, 0, data);
        
        assertEq(timelock.queuedAt(id), block.timestamp);
        
        // Move time forward
        vm.warp(block.timestamp + 4 days);
        
        vm.prank(admin);
        timelock.execute{value: 0}(target, 0, data, id);
    }

    function testExecuteBeforeDelayFails() public {
        bytes memory data = "";
        
        vm.prank(admin);
        bytes32 id = timelock.queue(target, 0, data);
        
        vm.prank(admin);
        vm.expectRevert("delay not passed");
        timelock.execute{value: 0}(target, 0, data, id);
    }

    function testOnlyAdminCanQueue() public {
        bytes memory data = "";
        
        vm.prank(alice);
        vm.expectRevert("not admin");
        timelock.queue(target, 0, data);
    }

    function testChangeAdmin() public {
        vm.prank(admin);
        timelock.changeAdmin(alice);
        
        assertEq(timelock.admin(), alice);
    }

    function testSetDelay() public {
        vm.prank(admin);
        timelock.setDelay(7 days);
        
        assertEq(timelock.delay(), 7 days);
    }

    function testReceiveEther() public {
        (bool success, ) = address(timelock).call{value: 1 ether}("");
        require(success);
    }
}
