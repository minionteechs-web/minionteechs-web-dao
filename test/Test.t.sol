// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleToken.sol";
import "../src/SimpleTimelock.sol";
import "../src/SimpleTreasury.sol";
import "../src/SimpleStorage.sol";

contract SimpleTokenTest is Test {
    SimpleToken token;

    function setUp() public {
        token = new SimpleToken();
    }

    function test_mint() public {
        token.mint(address(0x1), 100e18);
        assertEq(token.balanceOf(address(0x1)), 100e18);
    }

    function test_transfer() public {
        token.mint(address(this), 100e18);
        token.transfer(address(0x1), 50e18);
        assertEq(token.balanceOf(address(this)), 50e18);
        assertEq(token.balanceOf(address(0x1)), 50e18);
    }

    function test_burn() public {
        token.mint(address(this), 100e18);
        token.burn(50e18);
        assertEq(token.balanceOf(address(this)), 50e18);
        assertEq(token.totalSupply(), 50e18);
    }
}

contract SimpleTimelockTest is Test {
    SimpleTimelock timelock;

    function setUp() public {
        timelock = new SimpleTimelock(1 days);
    }

    function test_queue_and_execute() public {
        bytes memory data = abi.encodeWithSignature("setDelay(uint256)", 2 days);
        bytes32 id = timelock.queue(address(timelock), 0, data);
        
        assertNotEq(id, bytes32(0));
        assertEq(timelock.queuedAt(id), block.timestamp);
    }

    function test_change_admin() public {
        address newAdmin = address(0x5);
        timelock.changeAdmin(newAdmin);
        // Verify admin changed by attempting operation
        vm.prank(address(0x5));
        timelock.setDelay(2 days);
    }
}

contract SimpleTreasuryTest is Test {
    SimpleTreasury treasury;

    function setUp() public {
        treasury = new SimpleTreasury();
        vm.deal(address(this), 10 ether);
    }

    function test_deposit() public {
        treasury.deposit{value: 1 ether}();
        assertEq(treasury.balances(address(this)), 1 ether);
        assertEq(treasury.totalFunds(), 1 ether);
    }

    function test_withdraw() public {
        treasury.deposit{value: 1 ether}();
        treasury.withdraw(0.5 ether);
        assertEq(treasury.balances(address(this)), 0.5 ether);
        assertEq(treasury.totalFunds(), 0.5 ether);
    }

    function test_get_treasury_balance() public {
        treasury.deposit{value: 2 ether}();
        assertEq(treasury.getTreasuryBalance(), 2 ether);
    }

    receive() external payable {}
}

contract SimpleStorageTest is Test {
    SimpleStorage storage_contract;

    function setUp() public {
        storage_contract = new SimpleStorage();
    }

    function test_add_member() public {
        storage_contract.addMember(address(0x1), 100);
        assertTrue(storage_contract.isMember(address(0x1)));
        assertEq(storage_contract.getShares(address(0x1)), 100);
    }

    function test_remove_member() public {
        storage_contract.addMember(address(0x1), 100);
        storage_contract.removeMember(address(0x1));
        assertFalse(storage_contract.isMember(address(0x1)));
    }

    function test_get_member_count() public {
        storage_contract.addMember(address(0x1), 100);
        storage_contract.addMember(address(0x2), 200);
        assertEq(storage_contract.getMemberCount(), 2);
    }
}
