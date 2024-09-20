// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.27;
contract StorageLayout {
    uint256 x; // takes i bytes slot
    uint128 y; // takes half slot
    uint128 z; // takes half slot - cobminely takes 1 slot

    function set(uint newX, uint128 newY, uint128 newZ) public {
        x = newX;
        y = newY;
        z = newZ;
    }
    // Before: At 0 & 1 slot: bytes32: content 0x0000000000000000000000000000000000000000000000000000000000000000
    // input: 5,4,3
    // After: At 0: bytes32: content 0x0000000000000000000000000000000000000000000000000000000000000005
    // After: At 1: bytes32: content 0x0000000000000000000000000000000300000000000000000000000000000004 - store LSB - right - left
     
    // HELPER TO READ FROM STORAGE SLOTS
    function readStorageSlot(uint256 i) public view returns (bytes32 content) {
        assembly {
            content := sload(i)
        }
    }
}
