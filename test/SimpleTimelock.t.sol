// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/SimpleTimelock.sol";

contract SimpleTimelockTest {
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
        require(timelock.queuedAt(id) == block.timestamp, "Queue failed");
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
        
        try timelock.execute{value: 0}(target, 0, data, id) {
            require(false, "Should have reverted");
        } catch (bytes memory reason) {
            require(keccak256(reason) == keccak256(abi.encodeWithSignature("Error(string)", "delay not passed")), "Wrong error");
        }
    }

    function testSetDelay() public {
        timelock.setDelay(7 days);
        require(timelock.delay() == 7 days, "Set delay failed");
    }

    function testChangeAdmin() public {
        address newAdmin = address(0x5678);
        timelock.changeAdmin(newAdmin);
        require(timelock.admin() == newAdmin, "Change admin failed");
    }
}
