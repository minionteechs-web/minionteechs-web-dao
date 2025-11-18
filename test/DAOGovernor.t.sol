// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GovernanceToken.sol";
import "../src/Timelock.sol";
import "../src/DAOGovernor.sol";

contract DAOGovernorTest is Test {
    GovernanceToken token;
    Timelock timelock;
    DAOGovernor governor;
    
    address alice = address(0xAAAA);
    address bob = address(0xBBBB);
    address recipient = address(0xCCCC);

    function setUp() public {
        // Deploy token
        token = new GovernanceToken();
        
        // Deploy timelock with 2 day delay
        timelock = new Timelock(2 days);
        
        // Deploy governor
        governor = new DAOGovernor(token, timelock);
        
        // Mint tokens to alice and bob
        token.mint(alice, 100e18);
        token.mint(bob, 100e18);
        
        // Delegate votes
        vm.prank(alice);
        token.delegate(alice);
        
        vm.prank(bob);
        token.delegate(bob);
    }

    function testGovernanceFlow() public {
        // Alice proposes something
        address[] memory targets = new address[](1);
        targets[0] = recipient;
        
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSignature("test()");
        
        string memory description = "Test Proposal";
        bytes32 descriptionHash = keccak256(abi.encodePacked(description));

        vm.prank(alice);
        uint256 proposalId = governor.propose(targets, values, calldatas, description);
        
        // Check proposal created
        assertTrue(proposalId > 0);
    }

    function testVotingDelay() public {
        // Voting should be delayed by votingDelay blocks
        uint256 delay = governor.votingDelay();
        assertEq(delay, 1);
    }

    function testVotingPeriod() public {
        // Check voting period is set
        uint256 period = governor.votingPeriod();
        assertEq(period, 50400);
    }

    function testQuorumPercentage() public {
        // Check quorum is 4%
        uint256 quorum = governor.quorumNumerator();
        assertEq(quorum, 4);
    }

    function testProposalThreshold() public {
        // Check proposal threshold
        uint256 threshold = governor.proposalThreshold();
        assertEq(threshold, 100e18);
    }
}
