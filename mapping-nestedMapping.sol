// SPDX-License-Identifier: MIT
// @author SK Sabiruddin
pragma solidity 0.8.27;

contract StorageLayout {
    uint x;
    mapping(uint => mapping(uint => uint)) n;

    function addToN(uint key1, uint key2, uint value) public {
        n[key1][key2] = value;
    }

    // HELPER TO READ FROM STORAGE SLOTS
    function readStorageSlot(uint256 i) public view returns (bytes32 content) {
        assembly {
            content := sload(i)
        }
    }
    // Ex: n[2][3] = 4;
    // Step 1: find the slot of n[2]: Hash(key=2, slpt=1)
    // Step 2: find the slot of n[2][3]: Hash(key=3, slot=step1)
    // combine 2 hash to a big hash.
    // continue for more nested elements.

    // HELPER TO GET THE SLOT INDEX OF A MAPPING'S VALUE UNDER IT'S GIVEN KEY
    function getLocationOfMapping(
        uint mappingSlot,
        uint key
    ) public pure returns (uint slot) {
        // mappingSlot: the slot that the mapping itself sits in -> here: it's slot 1
        // slot: the slot that the value will be sitting in, e.g.: m[key] = value --> value will sit in "slot."
        return uint256(keccak256(abi.encode(key, mappingSlot)));
    }
}
