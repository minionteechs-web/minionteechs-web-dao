// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage storage_;
    address alice = address(0xAAAA);
    address bob = address(0xBBBB);

    function setUp() public {
        storage_ = new SimpleStorage();
    }

    function testAddMember() public {
        storage_.addMember(alice, 100);
        assertTrue(storage_.isMember(alice));
        assertEq(storage_.getShares(alice), 100);
    }

    function testAddMultipleMembers() public {
        storage_.addMember(alice, 100);
        storage_.addMember(bob, 50);
        assertEq(storage_.totalShares(), 150);
        assertEq(storage_.getMemberCount(), 2);
    }

    function testRemoveMember() public {
        storage_.addMember(alice, 100);
        storage_.removeMember(alice);
        assertFalse(storage_.isMember(alice));
        assertEq(storage_.totalShares(), 0);
    }

    function testCannotAddDuplicateMember() public {
        storage_.addMember(alice, 100);
        vm.expectRevert("Member exists");
        storage_.addMember(alice, 50);
    }

    function testCannotRemoveNonMember() public {
        vm.expectRevert("Member not found");
        storage_.removeMember(alice);
    }
}
