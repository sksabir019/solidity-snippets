// pragma solidity >=0.8.2 <0.9.0;

// contract BurgerShop {
//     uint256 public normalCost = 0.2 ether;
//     uint256 public deluxCost = 0.4 ether;

//     event BoughtBurger(address indexed _from, uint256 cost);

//     modifier shouldPay(uint256 _cost){
//         require(msg.value >= _cost, "The Burger cost more");
//         _;
//     }

//     function buyBurger() payable public shouldPay(normalCost){
//         emit BoughtBurger(msg.sender, normalCost);
//     }

//     function buyDeluxBurger() payable public shouldPay(deluxCost){
//         emit BoughtBurger(msg.sender, deluxCost);
//     }

//     function refund(address _to, uint256 _cost) payable public {
//         require(_cost == normalCost || _cost == deluxCost, "You are trying to refund the wrong amount");

//         uint256 balanceBeforeTransaction = address(this).balance;

//         if (balanceBeforeTransaction >= _cost){
//             (bool success, ) = payable(_to).call{value: _cost}("");
//             require(success);
//         }else{
//             revert("Not enough money!");
//         }
//         assert(address(this).balance == balanceBeforeTransaction - _cost);
//     }

//     function getFunds() public view returns(uint256){
//         return address(this).balance;
//     }

// }

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract BurgerShop is ReentrancyGuard, Ownable(msg.sender) {
    using SafeMath for uint256;

    uint256 public normalCost = 0.2 ether;
    uint256 public deluxCost = 0.4 ether;

    event BoughtBurger(address indexed _from, uint256 cost, uint256 timestamp);
    event Refunded(address indexed _to, uint256 cost, uint256 timestamp);

    modifier shouldPay(uint256 _cost) {
        require(msg.value >= _cost, "The Burger costs more");
        _;
    }

    function buyBurger() public payable shouldPay(normalCost) {
        emit BoughtBurger(msg.sender, normalCost, block.timestamp);
    }

    function buyDeluxBurger() public payable shouldPay(deluxCost) {
        emit BoughtBurger(msg.sender, deluxCost, block.timestamp);
    }

    function refund(
        address _to,
        uint256 _cost
    ) public payable nonReentrant onlyOwner {
        require(
            _cost == normalCost || _cost == deluxCost,
            "You are trying to refund the wrong amount"
        );

        uint256 balanceBeforeTransaction = address(this).balance;
        require(balanceBeforeTransaction >= _cost, "Not enough money!");

        (bool success, ) = payable(_to).call{value: _cost}("");
        require(success, "Transfer failed");

        require(
            address(this).balance == balanceBeforeTransaction.sub(_cost),
            "Balance mismatch after refund"
        );

        emit Refunded(_to, _cost, block.timestamp);
    }

    function getFunds() public view returns (uint256) {
        return address(this).balance;
    }
}
