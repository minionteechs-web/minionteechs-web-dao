// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GovernanceToken.sol";

contract GovernanceTokenTest is Test {
    GovernanceToken token;
    address owner;
    address alice = address(0xAAAA);
    address bob = address(0xBBBB);

    function setUp() public {
        owner = msg.sender;
        token = new GovernanceToken();
    }

    function testInitialState() public {
        assertEq(token.name(), "MinionTechs DAO Token");
        assertEq(token.symbol(), "MTD");
        assertEq(token.decimals(), 18);
    }

    function testMint() public {
        uint256 amount = 1000e18;
        token.mint(alice, amount);
        assertEq(token.balanceOf(alice), amount);
        assertEq(token.totalSupply(), amount);
    }

    function testMintMaxSupply() public {
        uint256 maxSupply = token.MAX_SUPPLY();
        token.mint(alice, maxSupply);
        
        vm.expectRevert("Exceeds max supply");
        token.mint(bob, 1e18);
    }

    function testMintOnlyOwner() public {
        vm.prank(alice);
        vm.expectRevert();
        token.mint(bob, 100e18);
    }

    function testBurn() public {
        uint256 amount = 1000e18;
        token.mint(alice, amount);
        
        vm.prank(alice);
        token.burn(500e18);
        
        assertEq(token.balanceOf(alice), 500e18);
        assertEq(token.totalSupply(), 500e18);
    }

    function testTransfer() public {
        uint256 amount = 1000e18;
        token.mint(alice, amount);
        
        vm.prank(alice);
        token.transfer(bob, 500e18);
        
        assertEq(token.balanceOf(alice), 500e18);
        assertEq(token.balanceOf(bob), 500e18);
    }

    function testVotes() public {
        uint256 amount = 1000e18;
        token.mint(alice, amount);
        
        vm.prank(alice);
        token.delegate(alice);
        
        assertEq(token.getVotes(alice), amount);
    }

    function testDelegation() public {
        uint256 amount = 1000e18;
        token.mint(alice, amount);
        token.mint(bob, amount);
        
        vm.prank(alice);
        token.delegate(bob);
        
        assertEq(token.getVotes(bob), amount);
        assertEq(token.getVotes(alice), 0);
    }
}
