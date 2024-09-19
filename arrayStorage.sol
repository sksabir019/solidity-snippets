// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;
contract Storage {
    uint x = 2;
    uint[] a;
    uint256[][] s;
    function pushToArray(uint value) public {
        a.push(value);
    }

    function add() public {
        s.push(); // push empt dynamic array. size - 1
        s[0].push(4);
        s[0].push(4);
        s[0].push(6);
    }

    function pop() public {
        s.pop(); // pop the last element from dynamic array.
    }

    // Helper to read from storage slots
    function readStorageSlots(uint256 i) public view returns (bytes32 content) {
        assembly {
            content := sload(sload(i))
        }
    }

    function getHashOfBucket(uint dynamicArraySlot) public pure returns (uint) {
        return uint256(keccak256(abi.encode(dynamicArraySlot)));
    }

    function expandMemory(
        uint length,
        uint memIndex
    ) public pure returns (bytes32 content) {
        uint[] memory a = new uint[](length);
        a[0] = 2;
        a[a.length - 1] = 4;
        assembly {
            content := mload(mul(memIndex, 0x20))
        }
    }
}
