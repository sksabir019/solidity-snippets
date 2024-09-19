// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;
/*
https://www.4byte.directory/

4 bytes that can clash - 0xa9059cbb - transfer(address,uint256)

External & Public have function selector. i.e. like this - 0xa9059cbb - calling from outside , you need to call through selector

Internal - No selector - like, jump to the bytecode

In Ethereum, function selectors are used to identify which function to call in a contract.

A (function) selector is the first four bytes of the Keccak-256 hash of the function signature (e.g., foo() or bar(uint256)).

Purpose of this Example:
This example demonstrates how to retrieve and use these function selectors within a contract.
It includes simple functions (foo and bar) and corresponding functions (getSelectorOfFoo and getSelectorOfBar) to return their selectors.
*/
contract SelectorExample {
    function foo() public {}
    function bar(uint256 x) public {}
    function baz(uint256) internal {} // internal function deoesn't have a fucntion selector - 2 hex char = 1 byte

    function getSelectorOfFoo() external pure returns (bytes4) {
        return this.foo.selector; // Returns 0xc2985578 - it's the 1st 4 bytes of  keccak256 Hash of function signature: foo()
    }

    function getSelectorOfBar() external pure returns (bytes4) {
        return this.bar.selector; // Returns 0x0423a132 or - msg.sig -  does the same thing
    }

    // function getSelectorOfBaz() external pure returns (bytes4) {
    //     return this.baz.selector; // Returns 0xc2985578
    // } // can't find the function
}
