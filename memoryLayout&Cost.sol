// SPDX-License-Identifier: GPL-3.0
/**
 * The second data area is called memory, of which a contract obtains freshly cleared instance for each message call. Memory is linear & can be addressed at byte level, but reads are limited to a width of 256 bits, while writes can be either 8 bits or 256 bits wide. Memory is expanded by a word (256 bit), when accessing (either reading or writing) a previously untouched memory word (i.e. any offset within a word). At the time of expansion, the cost in gas must be paid. Memory is more costly the larger it grows (it scales quasratically)
 * Solidity reserves four 32-byte slots, with specific byte ranges (inclusive of endpoints) being used as follows:
 * 0x00 - 0x3f (64 bytes): scratch space for hashing methods
 * 0x40 - 0x5f (32 bytes): currently allocated memory size (aka. free memory pointer)
 * 0x60 - 0x7f (32 bytes): zero slot
 * Total blocks for memory is 123000 until you hit the block gas limit. = 30 million gas used

*/
pragma solidity 0.8.27;
contract MemoryLayout {
    function probeMemoryLayout(
        uint length,
        uint memIndex
    ) public pure returns (bytes32 content) {
        uint[] memory a = new uint[](length);

        a[0] = 10;
        a[a.length - 1] = 4;

        assembly {
            content := mload(mul(memIndex, 0x20))
        }
    }

    function memoryCrash() public pure returns (uint content) {
        assembly {
            content := mload(mul(130000, 0x20))
        }
    }
}
