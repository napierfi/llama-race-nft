import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";

// (1)
const values = [
  ["0x328809Bc894f92807417D2dAD6b7C998c1aFdac6", "1", "2"],
  ["0x2222222222222222222222222222222222222222", "10", "2"]
];

// (2)
const tree = StandardMerkleTree.of(values, ["address", "uint24", "uint8"]);

// (3)
console.log('Merkle Root:', tree.root);

// (4)
fs.writeFileSync("tree.example.json", JSON.stringify(tree.dump()));