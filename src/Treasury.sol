// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

/**
 * @title Treasury
 * @dev Treasury contract for managing DAO funds
 */
contract Treasury is Ownable, ReentrancyGuard {
    mapping(address => uint256) public balance;
    uint256 public totalFunds;

    event FundsDeposited(address indexed from, uint256 amount);
    event FundsWithdrawn(address indexed to, uint256 amount);
    event FundsTransferred(address indexed from, address indexed to, uint256 amount);

    receive() external payable {
        balance[msg.sender] += msg.value;
        totalFunds += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }

    /**
     * @dev Deposit ETH to treasury
     */
    function deposit() public payable {
        require(msg.value > 0, "Amount must be greater than 0");
        balance[msg.sender] += msg.value;
        totalFunds += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }

    /**
     * @dev Withdraw funds from treasury (only owner/governance)
     */
    function withdraw(address payable to, uint256 amount) public onlyOwner nonReentrant {
        require(amount <= totalFunds, "Insufficient funds");
        require(to != address(0), "Invalid address");
        
        totalFunds -= amount;
        balance[to] -= amount;
        
        (bool success, ) = to.call{value: amount}("");
        require(success, "Transfer failed");
        
        emit FundsWithdrawn(to, amount);
    }

    /**
     * @dev Get treasury balance
     */
    function getTreasuryBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Get user balance
     */
    function getUserBalance(address user) public view returns (uint256) {
        return balance[user];
    }
}
