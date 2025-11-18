// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title DAOStorage
 * @dev Centralized storage for DAO state
 */
contract DAOStorage is Ownable {
    struct Member {
        uint256 shares;
        uint256 delegatedVotes;
        bool active;
    }

    mapping(address => Member) public members;
    address[] public memberList;
    uint256 public totalShares;
    uint256 public memberCount;

    event MemberAdded(address indexed member, uint256 shares);
    event MemberRemoved(address indexed member);
    event SharesUpdated(address indexed member, uint256 newShares);

    /**
     * @dev Add a new member
     */
    function addMember(address member, uint256 shares) public onlyOwner {
        require(member != address(0), "Invalid address");
        require(shares > 0, "Shares must be positive");
        require(!members[member].active, "Member already exists");

        members[member] = Member(shares, 0, true);
        memberList.push(member);
        totalShares += shares;
        memberCount++;

        emit MemberAdded(member, shares);
    }

    /**
     * @dev Remove a member
     */
    function removeMember(address member) public onlyOwner {
        require(members[member].active, "Member not found");
        
        totalShares -= members[member].shares;
        members[member].active = false;
        memberCount--;

        emit MemberRemoved(member);
    }

    /**
     * @dev Update member shares
     */
    function updateShares(address member, uint256 newShares) public onlyOwner {
        require(members[member].active, "Member not found");
        require(newShares > 0, "Shares must be positive");

        totalShares -= members[member].shares;
        members[member].shares = newShares;
        totalShares += newShares;

        emit SharesUpdated(member, newShares);
    }

    /**
     * @dev Get member info
     */
    function getMember(address member) public view returns (Member memory) {
        return members[member];
    }

    /**
     * @dev Get all members
     */
    function getMembers() public view returns (address[] memory) {
        return memberList;
    }

    /**
     * @dev Check if address is active member
     */
    function isMember(address member) public view returns (bool) {
        return members[member].active;
    }
}
