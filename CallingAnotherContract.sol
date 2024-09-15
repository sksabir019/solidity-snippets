// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Alice {
    uint256 public x;
    uint256 public value;

    function setter(uint256 _x) public {
        x = _x;
    }

    function getter() public view returns (uint) {
        return x;
    }

    function payableSetter(uint256 _x) public payable {
        x = _x;
        value = msg.value;
    }
}

contract Bob {
    // if you use (address _alice), it will only store the address of Alice not it's functions/ atrtributres
    function setter(Alice _alice, uint256 _x) public {
        _alice.setter(_x);
    }

    function getter(Alice _alice) public view returns (uint) {
        uint item = _alice.getter();
        return item;
    }

    function setterViaAddress(address _addr, uint256 _x) public {
        Alice alice = Alice(_addr);
        alice.setter(_x);
    }

    function payableSetter(Alice _alice, uint256 _x) public payable {
        _alice.payableSetter{value: msg.value}(_x);
    }
}


// interface IERC20 {
//     function transfer(address _to, uint256 _value) external returns (bool);
    
// //    functions, only using `transfer()` in this case
// }

// contract MyContract {
   
//     function sendUSDT(address _to, uint256 _amount) external {
//          // This is the mainnet USDT contract address
//          // Using on other networks (rinkeby, local, ...) would fail
//          //  - there's no contract on this address on other networks
//         IERC20 usdt = IERC20(address(0xdAC17F958D2ee523a2206206994597C13D831ec7));
        
//         // transfers USDT that belong to your contract to the specified address
//         usdt.transfer(_to, _amount);
//     }
// }