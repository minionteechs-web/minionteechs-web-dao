// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SimpleToken.sol";
import "../src/SimpleTimelock.sol";
import "../src/SimpleTreasury.sol";
import "../src/SimpleStorage.sol";

contract DeployDAO is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy Governance Token
        SimpleToken token = new SimpleToken();
        console.log("SimpleToken deployed at:", address(token));

        // Deploy Timelock
        SimpleTimelock timelock = new SimpleTimelock(1 days);
        console.log("SimpleTimelock deployed at:", address(timelock));

        // Deploy Treasury
        SimpleTreasury treasury = new SimpleTreasury();
        console.log("SimpleTreasury deployed at:", address(treasury));

        // Deploy DAO Storage
        SimpleStorage daoStorage = new SimpleStorage();
        console.log("SimpleStorage deployed at:", address(daoStorage));

        // Mint initial tokens to deployer
        token.mint(msg.sender, 1000000e18);
        console.log("Minted 1M tokens to deployer");

        vm.stopBroadcast();

        console.log("\n=== DAO Deployment Complete ===");
        console.log("Token:", address(token));
        console.log("Timelock:", address(timelock));
        console.log("Governor:", address(governor));
        console.log("Treasury:", address(treasury));
        console.log("Storage:", address(daoStorage));
    }
}
