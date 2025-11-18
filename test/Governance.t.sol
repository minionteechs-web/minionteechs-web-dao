// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Governance.sol";
import "../src/GovernanceToken.sol";

contract GovernanceTest is Test {
    Governance governance;
    GovernanceToken token;

    function setUp() public {
        token = new GovernanceToken();
        governance = new Governance(address(token));
    }

    function testExample() public {
        // Add your tests here
    }
}
