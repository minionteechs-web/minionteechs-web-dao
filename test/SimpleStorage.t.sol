// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/SimpleStorage.sol";

contract SimpleStorageTest {
    SimpleStorage storage_;
    address alice = address(0xAAAA);
    address bob = address(0xBBBB);

    function setUp() public {
        storage_ = new SimpleStorage();
    }

    function testAddMember() public {
        storage_.addMember(alice, 100);
        require(storage_.isMember(alice), "Add member failed");
        require(storage_.getShares(alice) == 100, "Shares failed");
    }

    function testAddMultipleMembers() public {
        storage_.addMember(alice, 100);
        storage_.addMember(bob, 50);
        require(storage_.totalShares() == 150, "Total shares failed");
        require(storage_.getMemberCount() == 2, "Member count failed");
    }

    function testRemoveMember() public {
        storage_.addMember(alice, 100);
        storage_.removeMember(alice);
        require(!storage_.isMember(alice), "Remove member failed");
        require(storage_.totalShares() == 0, "Total shares failed");
    }

    function testCannotAddDuplicateMember() public {
        storage_.addMember(alice, 100);
        try storage_.addMember(alice, 50) {
            require(false, "Should have reverted");
        } catch (bytes memory reason) {
            require(keccak256(reason) == keccak256(abi.encodeWithSignature("Error(string)", "Member exists")), "Wrong error");
        }
    }

    function testCannotRemoveNonMember() public {
        try storage_.removeMember(alice) {
            require(false, "Should have reverted");
        } catch (bytes memory reason) {
            require(keccak256(reason) == keccak256(abi.encodeWithSignature("Error(string)", "Member not found")), "Wrong error");
        }
    }
}
