// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SimpleStorage
 * @dev DAO member registry
 */
contract SimpleStorage {
    struct Member {
        uint256 shares;
        bool active;
    }

    mapping(address => Member) public members;
    address[] public memberList;
    uint256 public totalShares;

    event MemberAdded(address indexed member, uint256 shares);
    event MemberRemoved(address indexed member);

    function addMember(address member, uint256 shares) public {
        require(member != address(0), "Invalid address");
        require(shares > 0, "Shares must be positive");
        require(!members[member].active, "Member exists");
        
        members[member] = Member(shares, true);
        memberList.push(member);
        totalShares += shares;
        emit MemberAdded(member, shares);
    }

    function removeMember(address member) public {
        require(members[member].active, "Member not found");
        totalShares -= members[member].shares;
        members[member].active = false;
        emit MemberRemoved(member);
    }

    function isMember(address member) public view returns (bool) {
        return members[member].active;
    }

    function getShares(address member) public view returns (uint256) {
        return members[member].shares;
    }

    function getMemberCount() public view returns (uint256) {
        return memberList.length;
    }
}
