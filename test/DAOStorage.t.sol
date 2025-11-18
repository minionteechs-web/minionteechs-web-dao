// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/DAOStorage.sol";

contract DAOStorageTest is Test {
    DAOStorage storage_;
    address alice = address(0xAAAA);
    address bob = address(0xBBBB);

    function setUp() public {
        storage_ = new DAOStorage();
    }

    function testAddMember() public {
        storage_.addMember(alice, 100);
        assertTrue(storage_.isMember(alice));
        assertEq(storage_.getMember(alice).shares, 100);
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

    function testUpdateShares() public {
        storage_.addMember(alice, 100);
        storage_.updateShares(alice, 200);
        assertEq(storage_.getMember(alice).shares, 200);
        assertEq(storage_.totalShares(), 200);
    }

    function testCannotAddDuplicateMember() public {
        storage_.addMember(alice, 100);
        vm.expectRevert("Member exists");
        storage_.addMember(alice, 50);
    }
}
