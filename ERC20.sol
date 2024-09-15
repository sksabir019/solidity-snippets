/**
 * Coins: are digital assets that are native to their own blockchain. They are independent and operate on their own network. Bitcoin (BTC), Ethereum (ETH), and Monero (XMR) are examples of coins. These coins exist on their own independent ledgers and can be sent, received, or processed.
 *
 * Tokens:, on the other hand, are digital assets that operate on an existing blockchain network. They do not have their own blockchain but require another blockchain platform to operate. Ethereum is the most common platform for creating tokens, primarily due to its smart contracts feature. Tokens created on the Ethereum blockchain are known as ERC-20 tokens.
 *
 * IERC-20: 2 enents & 6 functions default , you can add more if needed:
 * event Transfer(address indexed from, address indexed to, uint256 value);
 * event Approval(address indexed owner, address indexed spender, uint256 value);=
 * function totalSupply() external view returns (uint256);
 * function balanceOf(address account) external view returns (uint256);
 * function transfer(address to, uint256 value) external returns (bool);
 * function allowance(address owner, address spender) external view returns (uint256);
 * function approve(address spender, uint256 value) external returns (bool);
 * function transferFrom(address from, address to, uint256 value) external returns (bool);
 *
 *
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

contract ERC20 is IERC20 {
    uint256 public override totalSupply = 1000;
    uint8 public decimals = 0;
    string public name = "TestToken";
    string public symbol = "TTK";

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowances;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }
    function balanceOf(address account) external view returns(unit256){
        return balanceOf[account];
    }

    function transfer(
        address to,
        uint256 value
    ) external override returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        require(to != address(0), "Invalid address");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) external view override returns (uint256) {
        return allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 value
    ) external override returns (bool) {
        require(spender != address(0), "Invalid address");

        allowances[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external override returns (bool) {
        require(allowances[from][msg.sender] >= value, "Allowance exceeded");
        require(balanceOf[from] >= value, "Insufficient balance");
        require(to != address(0), "Invalid address");

        allowances[from][msg.sender] -= value;
        balanceOf[from] -= value;
        balanceOf[to] += value;

        emit Transfer(from, to, value);
        return true;
    }
}

// Using OpenZeppelin ERC20
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CTEToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Silver", "Deci1") {
        _mint(msg.sender, initialSupply);
    }
    function decimals() public pure override returns (uint8) {
        return 1;
    }
}
