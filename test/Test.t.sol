// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleToken.sol";

contract SimpleTokenTest is Test {
    SimpleToken token;

    function setUp() public {
        token = new SimpleToken();
    }

    function test_mint() public {
        token.mint(address(0x1), 100e18);
        assertEq(token.balanceOf(address(0x1)), 100e18);
    }
}
