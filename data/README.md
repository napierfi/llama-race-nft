# Merkle Proof

## Format

- ABI-encoded dynamic array of leaf nodes in the form of a tuple `(address,uint24,uint8)[]`, sorted by merkle tree index.

```solidity
Struct LeafInfo {
    address account;
    uint24 rank;
    uint8 questId;
}
```

```
abi_encode(leaves: (address,uint24,uint8)[])
```

## Example

- [example.txt](./example.txt)

- Encode the following leaf nodes:
  - index 1: `(0x328809Bc894f92807417D2dAD6b7C998c1aFdac6,1,2)`
  - index 2: `(5c9d55b78febcc2061715ba4f57ecf8ea2711f2c,10,2)`

Run the following command to get the encoded data:

```bash
cast abi-encode "en((address,uint24,uint8)[])" '[(0x328809Bc894f92807417D2dAD6b7C998c1aFdac6,1,2),(5c9d55b78febcc2061715ba4f57ecf8ea2711f2c,10,2)]'
```

Test verification:

```bash
forge test --mt=testFFI_Redeem -vvv
```
