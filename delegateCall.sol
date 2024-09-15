// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract A {
    uint public value;
    address public sender;
    address private contractB; // Use a private variable for the contract B address

    constructor() {
        contractB = address(0); // Initialize the contract B address in the constructor
    }

    function makeDelegateCall(uint256 _value) public {
        // Use the abi.encodeWithSelector function to encode the function call
        // This is safer and more efficient than using abi.encodePacked
        bytes4 selector = bytes4(keccak256("setValue(uint256)"));
        (bool success, ) = contractB.delegatecall(abi.encodeWithSelector(selector, _value));
        require(success, "Delegate call failed");
    }
}

contract B {
    uint public value;
    address public sender;

    function setValue(uint _value) public {
        value = _value;
        sender = msg.sender; // msg.sender is preserved in delegatecall. It was not available in callcode.
    }
}