// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.27;
contract DynamicArrayStorage {
    uint x = 2;
    uint[] a;
    // push - 4:
    // hash(bucket) = > this will return the slot where the value is present.
    // initaial slot - store the length of the array as value.

    function pushToArray(uint value) public {
        a.push(value);
    }

    function getAllValues() public view returns (uint[] memory) {
        return a;

    }
    // 80084422859880547211683076133703299733277748156566366325829078699459944778998 => 3 (starting index)
    function getStorageBucket(uint index) public view returns (uint content) {
        assembly {
            content := sload(index)
        }
    }

    function getHashOfBucket(uint index) public pure returns (uint hashVal) {
        return uint(keccak256(abi.encode(index))); // will return 1 for slot 1 after adding 4.
        // in oprder to get value 4, need to hash(bucket) => hash(1) => will return value 4
        // 80084422859880547211683076133703299733277748156566366325829078699459944778998
    }
}