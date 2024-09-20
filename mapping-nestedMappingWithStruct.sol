// SPDX-License-Identifier: MIT
// @author SK Sabiruddin
pragma solidity 0.8.27;

contract StorageLayout {
    // struct doesn't store in storage 0, just defination.
    struct S {
        uint16 a;
        uint16 b;
        uint256 c;
    }
    uint x; // stored in stotage 0
    mapping(uint => mapping(uint => S)) data; // stored in storage 1
    // 2,3,8
    function setC(uint key1, uint key2, uint value) public {
        data[key1][key2].c = value;
    }

    // Ex: data[2][3] = S(0,0,8)
    // Step 1: find the slot of n[2]: Hash(key=2, slpt=1)
    // Step 2: find the slot of n[2][3]: Hash(key=3, slot=step1) => this is the location where the struct is stored / starts 
    // => stores 1st to values in 1 slot and next i.e C in 2nd slot = 8
    // combine 2 hash to a big hash.
    // continue for more nested elements.
    // HELPER TO READ FROM STORAGE SLOTS
    function readStorageSlot(uint256 i) public view returns (bytes32 content) {
        assembly {
            content := sload(i)
        }
    }

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
