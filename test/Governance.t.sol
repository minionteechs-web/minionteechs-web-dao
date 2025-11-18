// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Governance.sol";

contract GovernanceTest is Test {
    Governance governance;

    function setUp() public {
        governance = new Governance();
    }

    function testExample() public {
        // Add your tests here
    }
}
