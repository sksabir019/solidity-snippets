// SPDX-License-Identifier: MIT
// @author SK Sabiruddin
pragma solidity 0.8.27;

contract StorageLayout {
    uint x = 2;
    mapping(uint => uint) m;

    function addToM(uint key, uint value) public {
        m[key] = value;
    }

    // HELPER TO READ FROM STORAGE SLOTS
    function readStorageSlot(uint256 i) public view returns (bytes32 content) {
        assembly {
            content := sload(i)
        }
    } 

    // Before: At slot 0: bytes32: content 0x0000000000000000000000000000000000000000000000000000000000000002
    // AFter AT Slot 1: bytes32: content 0x0000000000000000000000000000000000000000000000000000000000000000

    // input: 2, 4
    // After: At 0: bytes32: content 0x0000000000000000000000000000000000000000000000000000000000000002
    // After: At 1: bytes32: content 0x0000000000000000000000000000000000000000000000000000000000000000
    // The map value didn't store in slot 1 ? where it store then? Need to call the HASH function.

    // HELPER TO GET THE SLOT INDEX OF A MAPPING'S VALUE UNDER IT'S GIVEN KEY
    // Stotarge slot: uint256: slot 98521912898304110675870976153671229506380941016514884467413255631823579132687 - this holds the mapping value
    function getLocationOfMapping(
        uint mappingSlot,
        uint key
    ) public pure returns (uint slot) {
        // abi.encode: concatinate 2 values together - but should use encodePacked - it'll only packed necessary bits together
        // mappingSlot: the slot that the mapping itself sits in -> here: it's slot 1
        // slot: the slot that the value will be sitting in, e.g.: m[key] = value --> value will sit in "slot."
        return uint256(keccak256(abi.encode(key, mappingSlot)));
    }
}
