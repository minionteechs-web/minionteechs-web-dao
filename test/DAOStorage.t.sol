// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/DAOStorage.sol";

contract DAOStorageTest is Test {
    DAOStorage storage_;
    address owner;
    address alice = address(0xAAAA);
    address bob = address(0xBBBB);

    function setUp() public {
        owner = msg.sender;
        storage_ = new DAOStorage();
    }

    function testAddMember() public {
        uint256 shares = 100e18;
        storage_.addMember(alice, shares);
        
        assertTrue(storage_.isMember(alice));
        assertEq(storage_.getMember(alice).shares, shares);
        assertEq(storage_.totalShares(), shares);
        assertEq(storage_.memberCount(), 1);
    }

    function testAddMultipleMembers() public {
        storage_.addMember(alice, 100e18);
        storage_.addMember(bob, 200e18);
        
        assertEq(storage_.memberCount(), 2);
        assertEq(storage_.totalShares(), 300e18);
    }

    function testAddInvalidMember() public {
        vm.expectRevert("Invalid address");
        storage_.addMember(address(0), 100e18);
        
        vm.expectRevert("Shares must be positive");
        storage_.addMember(alice, 0);
    }

    function testAddDuplicateMember() public {
        storage_.addMember(alice, 100e18);
        
        vm.expectRevert("Member already exists");
        storage_.addMember(alice, 100e18);
    }

    function testRemoveMember() public {
        storage_.addMember(alice, 100e18);
        assertEq(storage_.memberCount(), 1);
        
        storage_.removeMember(alice);
        
        assertFalse(storage_.isMember(alice));
        assertEq(storage_.memberCount(), 0);
        assertEq(storage_.totalShares(), 0);
    }

    function testRemoveNonexistentMember() public {
        vm.expectRevert("Member not found");
        storage_.removeMember(alice);
    }

    function testUpdateShares() public {
        storage_.addMember(alice, 100e18);
        storage_.updateShares(alice, 200e18);
        
        assertEq(storage_.getMember(alice).shares, 200e18);
        assertEq(storage_.totalShares(), 200e18);
    }

    function testUpdateSharesInvalid() public {
        storage_.addMember(alice, 100e18);
        
        vm.expectRevert("Shares must be positive");
        storage_.updateShares(alice, 0);
        
        vm.expectRevert("Member not found");
        storage_.updateShares(bob, 100e18);
    }

    function testGetMembers() public {
        storage_.addMember(alice, 100e18);
        storage_.addMember(bob, 200e18);
        
        address[] memory members = storage_.getMembers();
        assertEq(members.length, 2);
    }

    function testOnlyOwner() public {
        vm.prank(alice);
        vm.expectRevert();
        storage_.addMember(bob, 100e18);
    }
}
