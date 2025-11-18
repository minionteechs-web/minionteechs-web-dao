// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IGovernanceToken.sol";

/**
 * @title Governance
 * @notice Simple governance contract using token-weighted voting.
 * - Anyone can propose a call (target, value, calldata), specify voting period.
 * - Voting power = token balance at time of vote (no snapshot implementation here).
 * - After voting, if votesFor >= quorum and votesFor > votesAgainst, owner can queue to timelock.
 * - For real production use, replace with OZ Governor + snapshots + timelock.
 */

contract Governance {
    IERC20Simple public immutable governanceToken;
    address public owner;
    Timelock public timelock; // optional, can be set

    uint256 public proposalCount;

    struct Proposal {
        address proposer;
        address target;
        uint256 value;
        bytes data;
        uint256 start; // block.timestamp
        uint256 end;
        uint256 forVotes;
        uint256 againstVotes;
        bool executed;
        string description;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event Proposed(uint256 id, address proposer, address target, uint256 value, uint256 start, uint256 end);
    event Voted(uint256 id, address voter, bool support, uint256 weight);
    event Queued(uint256 id, bytes32 queueId);
    event Executed(uint256 id);

    constructor(address _token) {
        governanceToken = IERC20Simple(_token);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "owner only");
        _;
    }

    function setTimelock(address _timelock) external onlyOwner {
        timelock = Timelock(_timelock);
    }

    function propose(address target, uint256 value, bytes calldata data, uint256 votingDuration, string memory description) external returns (uint256) {
        require(votingDuration >= 1 minutes && votingDuration <= 30 days, "bad duration");
        uint256 id = ++proposalCount;
        proposals[id] = Proposal({
            proposer: msg.sender,
            target: target,
            value: value,
            data: data,
            start: block.timestamp,
            end: block.timestamp + votingDuration,
            forVotes: 0,
            againstVotes: 0,
            executed: false,
            description: description
        });
        emit Proposed(id, msg.sender, target, value, block.timestamp, block.timestamp + votingDuration);
        return id;
    }

    function vote(uint256 id, bool support) external {
        Proposal storage p = proposals[id];
        require(block.timestamp >= p.start, "not started");
        require(block.timestamp < p.end, "ended");
        require(!hasVoted[id][msg.sender], "already voted");

        uint256 weight = governanceToken.balanceOf(msg.sender);
        require(weight > 0, "no voting power");

        hasVoted[id][msg.sender] = true;
        if (support) {
            p.forVotes += weight;
        } else {
            p.againstVotes += weight;
        }
        emit Voted(id, msg.sender, support, weight);
    }

    function queue(uint256 id, uint256 minQuorum) external onlyOwner returns (bytes32) {
        Proposal storage p = proposals[id];
        require(block.timestamp >= p.end, "voting not ended");
        require(!p.executed, "already executed");
        require(p.forVotes >= minQuorum && p.forVotes > p.againstVotes, "not passed");

        // queue into timelock if set
        if (address(timelock) != address(0)) {
            bytes32 queueId = timelock.queue(p.target, p.value, p.data);
            emit Queued(id, queueId);
            return queueId;
        } else {
            // if no timelock, do nothing; owner may call execute directly
            emit Queued(id, bytes32(0));
            return bytes32(0);
        }
    }

    function execute(uint256 id) external onlyOwner {
        Proposal storage p = proposals[id];
        require(block.timestamp >= p.end, "voting not ended");
        require(!p.executed, "already executed");
        // if timelock set, owner should execute via timelock separately
        (bool ok,) = p.target.call{value: p.value}(p.data);
        require(ok, "call failed");
        p.executed = true;
        emit Executed(id);
    }

    receive() external payable {}
}

abstract contract Timelock {
    function queue(address target, uint256 value, bytes calldata data) external virtual returns (bytes32);
}
