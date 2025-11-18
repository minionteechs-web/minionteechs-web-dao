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
        address[] memory admins = new address[](1);
        admins[0] = admin;
        timelock = new Timelock(admins);
    }

    function testScheduleOperation() public {
        bytes32 salt = keccak256("test");
        uint256 delay = 3 days;
        bytes memory data = "";

        timelock.schedule(target, 0, data, bytes32(0), salt, delay);
        
        bytes32 id = timelock.hashOperation(target, 0, data, bytes32(0), salt);
        assertEq(timelock.timestamps(id), block.timestamp + delay);
    }

    function testScheduleInvalidDelay() public {
        bytes32 salt = keccak256("test");
        bytes memory data = "";

        vm.expectRevert("Invalid delay");
        timelock.schedule(target, 0, data, bytes32(0), salt, 1 days);

        vm.expectRevert("Invalid delay");
        timelock.schedule(target, 0, data, bytes32(0), salt, 31 days);
    }

    function testExecuteBeforeDelay() public {
        bytes32 salt = keccak256("test");
        uint256 delay = 3 days;
        bytes memory data = "";

        timelock.schedule(target, 0, data, bytes32(0), salt, delay);
        
        vm.expectRevert("Operation not ready");
        timelock.execute(target, 0, data, bytes32(0), salt);
    }

    function testExecuteAfterDelay() public {
        bytes32 salt = keccak256("test");
        uint256 delay = 3 days;
        bytes memory data = "";

        timelock.schedule(target, 0, data, bytes32(0), salt, delay);
        
        vm.warp(block.timestamp + delay);
        timelock.execute(target, 0, data, bytes32(0), salt);
        
        bytes32 id = timelock.hashOperation(target, 0, data, bytes32(0), salt);
        assertEq(timelock.timestamps(id), 0);
    }

    function testCancelOperation() public {
        bytes32 salt = keccak256("test");
        uint256 delay = 3 days;
        bytes memory data = "";

        timelock.schedule(target, 0, data, bytes32(0), salt, delay);
        timelock.cancel(target, 0, data, bytes32(0), salt);
        
        bytes32 id = timelock.hashOperation(target, 0, data, bytes32(0), salt);
        assertEq(timelock.timestamps(id), 0);
    }

    function testIsOperationReady() public {
        bytes32 salt = keccak256("test");
        uint256 delay = 3 days;
        bytes memory data = "";

        bytes32 id = timelock.hashOperation(target, 0, data, bytes32(0), salt);
        
        assertFalse(timelock.isOperationReady(id));
        
        timelock.schedule(target, 0, data, bytes32(0), salt, delay);
        assertFalse(timelock.isOperationReady(id));
        
        vm.warp(block.timestamp + delay);
        assertTrue(timelock.isOperationReady(id));
    }

    function testOnlyAdminCanSchedule() public {
        bytes32 salt = keccak256("test");
        uint256 delay = 3 days;
        bytes memory data = "";

        vm.prank(alice);
        vm.expectRevert("Not admin");
        timelock.schedule(target, 0, data, bytes32(0), salt, delay);
    }
}
