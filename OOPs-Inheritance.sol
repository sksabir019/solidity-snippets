// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Define the interface
interface IGreeter {
    function greet() external view returns (string memory);
}

// Implement the interface in a contract
contract Greeter is IGreeter {
    function greet() external pure override returns (string memory) {
        return "Hello, world!";
    }
}

// A contract that interacts with the Greeter contract through the interface
contract GreeterUser {
    function getGreeting(
        address _greeter
    ) external view returns (string memory) {
        return IGreeter(_greeter).greet();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Define the interface
interface IGreeter {
    function greet() external view returns (string memory);
}

// Implement the interface in a contract
contract Greeter is IGreeter {
    string private greeting;

    constructor(string memory _greeting) {
        greeting = _greeting;
    }

    function greet() external view override returns (string memory) {
        return greeting;
    }
}

// A contract that interacts with the Greeter contract through the interface
contract GreeterUser {
    IGreeter public str;

    // Function to set the IGreeter contract address
    function setGreeter(address _greeter) external {
        str = IGreeter(_greeter);
    }

    // Function to get the greeting from the IGreeter contract
    function getGreeting() external view returns (string memory) {
        return str.greet();
    }
}
