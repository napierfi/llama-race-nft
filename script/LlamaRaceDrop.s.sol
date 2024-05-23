// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.10;

import "forge-std/Script.sol";

import {LlamaRaceDrop} from "src/LlamaRaceDrop.sol";

contract LlamaRaceDropScript is Script {
    function run() public {
        address owner = vm.envAddress("OWNER");

        vm.startBroadcast();
        LlamaRaceDrop nft = new LlamaRaceDrop(owner);
        vm.stopBroadcast();

        console2.log("nft.address :>>", address(nft));
    }
}
