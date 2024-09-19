// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.27;

// Define the CollisionExample contract
contract CollisionExample {
    // Function collate_propagate_storage with a parameter of type bytes16
    function collate_propagate_storage(bytes16 x) external {} // has selector "0x42966c68"

    // Function burn with a parameter of type uint256 - will not compile because of same selector
    function burn(uint256 amount) external {} // also has selector "0x42966c68" --> clash with "collate_propagate_storage"!

    // This contract will not compile due to a hash collision between the function selectors.
    // The function selectors for both collate_propagate_storage and burn result in the same hash,
    // causing a collision and preventing the contract from being compiled.
}
