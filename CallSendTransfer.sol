// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Transact {
    // 2300 gas forwarded - Return: None - revert on failure: Yes
    function transferEther(address payable receiver) public {
        receiver.transfer(1 ether);
    }
    // 2300 gas forwareded - Return: Boolean - revert on failure: No
    function sendEther(address payable receiver) public payable {
        bool sent = receiver.send(1 ether);
        require(sent, "Failed to send Ether");
    }
    // customised gas forwareded - Return: Boolean + Data - revert on failure: No
    function callEther(
        address payable receiver
    ) public returns (bool, bytes memory) {
        (bool success, bytes memory data) = receiver.call{value: 1 ether}("");
        return (success, data);
    }
}
