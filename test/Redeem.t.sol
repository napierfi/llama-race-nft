// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import {BaseTest} from "./Base.t.sol";

import {LlamaRaceDrop, LeafInfo, TokenData} from "src/LlamaRaceDrop.sol";
import {Merkle} from "murky/src/Merkle.sol";

contract Redeem is BaseTest {
    /// @dev How to generate toy data
    /// 1. `bun run script/tree.example.ts`
    /// 2. `bun run script/get-proof.example.ts`
    // LeafInfo[2] memory leaves = [LeafInfo(alice, 1, 2), LeafInfo(0x2222222222222222222222222222222222222222, 10, 2)];
    bytes32[3] tree = [
        bytes32(hex"22e22637c0f16a7cee0d1576d830415be427880e266db03c01eec60b6f2251c7"),
        hex"d0ae4cd299e394b7e79c3df47ac6e1f8e60b495182a66ba517084cca595648f7",
        hex"16c96db6f680723b9edda3524e700f93b27b3a9e3570a5f44db5654cb536fb97"
    ];
    bytes32 root = tree[0];

    function setUp() public override {
        super.setUp();

        changePrank(owner, owner);
        nft.addNewRoot(root, "https://example.com/");
        vm.startPrank(alice, alice);
    }

    function test_Redeem() public {
        LeafInfo[2] memory leaves = [LeafInfo(alice, 1, 2), LeafInfo(0x2222222222222222222222222222222222222222, 10, 2)];
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = tree[1];
        nft.redeem(leaves[0], proof, root);

        uint256 tokenId = nft.getTokenId(leaves[0], root);
        assertEq(nft.ownerOf(tokenId), alice, "Owner of the token is not correct");
        assertEq(nft.getTokenData(tokenId).rank, 1, "Rank of the token is not correct");
        assertEq(nft.getTokenData(tokenId).questId, 2, "QuestId of the token is not correct");

        // Test tokenURI
        string memory uri = nft.tokenURI(tokenId);
        assertEq(uri, "https://example.com/1.json", "TokenURI is not correct");
    }

    function testFuzz_Redeem(LeafInfo[] memory leaves, uint256 index) public {
        vm.assume(leaves.length > 1);
        /// Prepare Merkle Tree
        Merkle m = new Merkle();
        // Toy Data
        bytes32[] memory _data = new bytes32[](leaves.length);
        for (uint256 i = 0; i < leaves.length; i++) {
            if (leaves[i].account == address(0)) leaves[i].account = makeAddr(vm.toString(i));
            // Get Leaf hash from LeafInfo
            _data[i] = nft.getLeaf(leaves[i]);
        }

        index = _bound(index, 0, leaves.length - 1);
        bytes32 _root = m.getRoot(_data);
        bytes32[] memory _proof = m.getProof(_data, index);

        changePrank(owner, owner);
        nft.addNewRoot(_root, "https://example.com/");
        changePrank(alice, alice);
        uint256 tokenId = nft.getTokenId(leaves[index], _root);
        assertEq(nft.redeem(leaves[index], _proof, _root), tokenId, "Redeem function should return tokenId");

        assertEq(nft.ownerOf(tokenId), leaves[index].account, "Owner of the token is not correct");
        assertEq(nft.getTokenData(tokenId).rank, leaves[index].rank, "Rank of the token is not correct");
        assertEq(nft.getTokenData(tokenId).questId, leaves[index].questId, "QuestId of the token is not correct");
    }

    function test_RevertIf_ReuseProof() public {
        test_Redeem();

        changePrank(bob, bob);
        vm.expectRevert(LlamaRaceDrop.TokenAlreadyMinted.selector);
        this.test_Redeem();
    }

    function test_RevertIf_RootDoesNotExist() public {
        LeafInfo memory leaf = LeafInfo(alice, 1, 2);
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = hex"22e22637c0f16a7cee0d1576d830415be427880e266db03c01eec60b6f2251c7";

        vm.expectRevert(LlamaRaceDrop.MerkleRootDoesNotExist.selector);
        nft.redeem(leaf, proof, 0xd0ae4cd299e394b7e79c3df47ac6e1f8e60b495182a66ba517084cca595648f7);
    }

    function test_RevertIf_InvalidProof() public {
        LeafInfo memory leaf = LeafInfo(alice, 1, 2);
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = tree[2];

        vm.expectRevert(LlamaRaceDrop.InvalidMerkleProof.selector);
        nft.redeem(leaf, proof, root);
    }
}
