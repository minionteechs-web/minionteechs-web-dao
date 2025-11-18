// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Timelock
 * @notice Minimal timelock: queue -> execute after delay
 */

contract Timelock {
    address public admin;
    uint256 public delay; // seconds

    mapping(bytes32 => uint256) public queuedAt;

    event Queued(bytes32 indexed id, address target, uint256 value, bytes data);
    event Executed(bytes32 indexed id, address target, uint256 value, bytes data);

    constructor(uint256 _delay) {
        admin = msg.sender;
        delay = _delay;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "not admin");
        _;
    }

    function queue(address target, uint256 value, bytes calldata data) external onlyAdmin returns (bytes32) {
        bytes32 id = keccak256(abi.encode(target, value, data, block.timestamp));
        queuedAt[id] = block.timestamp;
        emit Queued(id, target, value, data);
        return id;
    }

    function execute(address target, uint256 value, bytes calldata data, bytes32 id) external onlyAdmin payable returns (bytes memory) {
        require(queuedAt[id] != 0, "not queued");
        require(block.timestamp >= queuedAt[id] + delay, "delay not passed");
        delete queuedAt[id];
        (bool ok, bytes memory res) = target.call{value: value}(data);
        require(ok, "call failed");
        emit Executed(id, target, value, data);
        return res;
    }

    // Admin management
    function setDelay(uint256 _delay) external onlyAdmin {
        delay = _delay;
    }

    function changeAdmin(address newAdmin) external onlyAdmin {
        admin = newAdmin;
    }

    receive() external payable {}
}
