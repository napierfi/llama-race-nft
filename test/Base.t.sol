// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {LlamaRaceDrop, LeafInfo, TokenData} from "src/LlamaRaceDrop.sol";

contract BaseTest is Test {
    address owner = makeAddr("owner");
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    LlamaRaceDrop nft;

    function setUp() public virtual {
        nft = new LlamaRaceDrop(owner);

        vm.startPrank(alice, alice);
    }
}
