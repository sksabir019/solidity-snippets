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
        (bool success, ) = contractB.delegatecall(
            abi.encodeWithSelector(selector, _value)
        );
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
// painter
contract CalledContract {
    // own paint brush
    uint public num;
    function setNum(uint _num) public {
        num = _num;
    }
}

contract CallerContractA {
    // owner paint brush - called contract should use/change this variable - same name as in calledContract
    uint public num;
    function setNum(address _calledContracAddresst, uint _num) public {
        // prepare the data to call setNum(uint) on the called contract
        bytes memory data = abi.encodeWithSignature("setNum(uint256)", _num);

        // perform call - state variable of Calledcontract will be affected
        (bool success, ) = _calledContracAddresst.call(data);
        require(success, "Delegate call failed");
    }
}
// house owner 
contract CallerContractB {
    // owner paint brush - called contract should use/change this variable - same name as in calledContract
    // All the state variables in the Caller & called contrace must be SAME & declared in the SAME ORDER in case of delegateCall.
    uint public num;
    function setNum(address _calledContracAddresst, uint _num) public {
        // prepare the data to call setNum(uint) on the called contract
        bytes memory data = abi.encodeWithSignature("setNum(uint256)", _num);

        // perform delegate call -  state variable of CallerContractB will be affected
        (bool success, ) = _calledContracAddresst.delegatecall(data);
        require(success, "Delegate call failed");
    }
}

/**
 * Delegate call is a low level function in solidity used for calling another contract's code within the context of the calling contract. it allows to borrow a function from another contract.
 * Delegate call is used when you want to call a function from another contract and you want the state  of the calling contract to be affected.
 * This means the msg.sender & masg.value will remain unchanged & the storage of the calling contract will be used instead of called contract.
 * You can add state variables in the caller contract without affecting the order of the variables that are same in both contract.
 * Benefits of delegate call: Code reusability, upgradability & Modularity.
 * Concerns: Security & Storage layout.
 */
