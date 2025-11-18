// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GovernanceToken.sol";
import "../src/Timelock.sol";
import "../src/DAOGovernor.sol";
import "../src/Treasury.sol";
import "../src/DAOStorage.sol";

contract DeployDAO is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy Governance Token
        GovernanceToken token = new GovernanceToken();
        console.log("GovernanceToken deployed at:", address(token));

        // Deploy Timelock
        address[] memory admins = new address[](1);
        admins[0] = msg.sender;
        Timelock timelock = new Timelock(admins);
        console.log("Timelock deployed at:", address(timelock));

        // Deploy Governor
        DAOGovernor governor = new DAOGovernor(token, timelock);
        console.log("DAOGovernor deployed at:", address(governor));

        // Deploy Treasury
        Treasury treasury = new Treasury();
        console.log("Treasury deployed at:", address(treasury));

        // Deploy DAO Storage
        DAOStorage daoStorage = new DAOStorage();
        console.log("DAOStorage deployed at:", address(daoStorage));

        // Mint initial tokens to deployer
        token.mint(msg.sender, 1000000e18);
        console.log("Minted 1M tokens to deployer");

        // Delegate votes to self
        token.delegate(msg.sender);
        console.log("Delegated votes to deployer");

        vm.stopBroadcast();

        console.log("\n=== DAO Deployment Complete ===");
        console.log("Token:", address(token));
        console.log("Timelock:", address(timelock));
        console.log("Governor:", address(governor));
        console.log("Treasury:", address(treasury));
        console.log("Storage:", address(daoStorage));
    }
}
