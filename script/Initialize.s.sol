// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GovernanceToken.sol";
import "../src/DAOStorage.sol";

/**
 * @dev Script to initialize DAO with members and tokens
 * Usage: forge script script/Initialize.s.sol --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
 */
contract InitializeDAO is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenAddress = vm.envAddress("TOKEN_ADDRESS");
        address storageAddress = vm.envAddress("STORAGE_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        GovernanceToken token = GovernanceToken(tokenAddress);
        DAOStorage daoStorage = DAOStorage(storageAddress);

        // Add members
        address member1 = 0x1234567890123456789012345678901234567890;
        address member2 = 0x0987654321098765432109876543210987654321;

        daoStorage.addMember(member1, 500e18);
        daoStorage.addMember(member2, 300e18);

        // Mint tokens to members
        token.mint(member1, 500000e18);
        token.mint(member2, 300000e18);

        vm.stopBroadcast();

        console.log("DAO initialized successfully");
    }
}
