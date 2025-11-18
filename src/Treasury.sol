// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Treasury
 * @dev Simple treasury for DAO funds
 */
contract Treasury {
    mapping(address => uint256) public balances;
    uint256 public totalFunds;

    event Deposited(address indexed who, uint256 amount);
    event Withdrawn(address indexed who, uint256 amount);

    function deposit() public payable {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        totalFunds += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        totalFunds -= amount;
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "Transfer failed");
        emit Withdrawn(msg.sender, amount);
    }

    function getTreasuryBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function balance(address account) public view returns (uint256) {
        return balances[account];
    }

    receive() external payable {
        deposit();
    }
}
