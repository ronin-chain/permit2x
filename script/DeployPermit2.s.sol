// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/console2.sol";
import "forge-std/Script.sol";
import {Permit2} from "src/Permit2.sol";

contract DeployPermit2 is Script {
    function setUp() public {}

    function run() public returns (Permit2 permit2) {
        vm.startBroadcast();
        permit2 = new Permit2();
        console2.log("Permit2 Deployed:", address(permit2));

        address multisig = 0x9D05D1F5b0424F8fDE534BC196FFB6Dd211D902a;
        permit2.transferOwnership(multisig);
        console2.log("Permit2 Ownership transferred to:", multisig);
        vm.stopBroadcast();
    }
}
