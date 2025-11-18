// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleTimelock.sol";

contract SimpleTimelockTest is Test {
    SimpleTimelock timelock;
    address admin;
    address target = address(0x1234);

    function setUp() public {
        admin = msg.sender;
        timelock = new SimpleTimelock(2 days);
    }

    function testQueue() public {
        bytes memory data = "";
        bytes32 id = timelock.queue(target, 0, data);
        assertEq(timelock.queuedAt(id), block.timestamp);
    }

    function testExecuteAfterDelay() public {
        bytes memory data = "";
        bytes32 id = timelock.queue(target, 0, data);
        
        vm.warp(block.timestamp + 3 days);
        
        timelock.execute{value: 0}(target, 0, data, id);
    }

    function testExecuteBeforeDelayFails() public {
        bytes memory data = "";
        bytes32 id = timelock.queue(target, 0, data);
        
        vm.expectRevert("delay not passed");
        timelock.execute{value: 0}(target, 0, data, id);
    }

    function testSetDelay() public {
        timelock.setDelay(7 days);
        assertEq(timelock.delay(), 7 days);
    }

    function testChangeAdmin() public {
        address newAdmin = address(0x5678);
        timelock.changeAdmin(newAdmin);
        assertEq(timelock.admin(), newAdmin);
    }
}
