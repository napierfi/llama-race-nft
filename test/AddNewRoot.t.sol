// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.10;

import {BaseTest} from "./Base.t.sol";

import {LlamaRaceDrop} from "src/LlamaRaceDrop.sol";
import {Ownable} from "@openzeppelin/contracts@5.0.2/access/Ownable2Step.sol";

contract AddNewRoot is BaseTest {
    function test_AddNewRoot() public {
        changePrank(owner, owner);
        bytes32 root = keccak256("hoge-root");
        nft.addNewRoot(root, "https://example.com/");
    }

    function test_RevertIf_NotOwner() public {
        bytes32 root = keccak256("hoge-root");
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, alice));
        nft.addNewRoot(root, "https://example.com/");
    }

    function test_RevertIf_RootExists() public {
        changePrank(owner, owner);
        nft.addNewRoot(hex"a8fe44078bc4c841a4570ea18e3adf27f186ac14bd3fbf4b07d2b2fefd41cdde", "https://example.com/");

        vm.expectRevert(LlamaRaceDrop.MerkleRootAlreadyExists.selector);
        nft.addNewRoot(hex"a8fe44078bc4c841a4570ea18e3adf27f186ac14bd3fbf4b07d2b2fefd41cdde", "https://example.com/");
    }

    function test_RevertIf_EmpatyURI() public {
        changePrank(owner, owner);
        vm.expectRevert(LlamaRaceDrop.EmptyURI.selector);
        nft.addNewRoot(hex"a8fe44078bc4c841a4570ea18e3adf27f186ac14bd3fbf4b07d2b2fefd41cdde", "");
    }
}
