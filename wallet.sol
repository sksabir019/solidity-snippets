// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract SimpleWallet {
    struct Transaction {
        address from;
        address to;
        uint timestamp;
        uint amount;
    }

    Transaction[] public transactionHistory;
    bool stop;
    address public owner;
    string public str;
    mapping(address => uint) suspiciousUser;

    event Transfer(address receiver, uint amount);
    event Receiver(address sender, uint amount);
    event ReceiveUser(address sender, address receiver, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    modifier getSuspiciousUser(address _sender) {
        require(suspiciousUser[_sender] < 5, "Sender is not suspicious user");
        _;
    }
    modifier isEmergencyDeclared() {
        require(stop, "Emergency is not declared");
    }

    function changeOwner(
        address newOwner
    ) public onlyOwner isEmergencyDeclared {
        owner = newOwner;
    }
    function suspiciousActivity(address _sender) public {
        suspiciousUser[_sender] += 1;
    }

    function toggleStop() external onlyOwner {
        stop = !stop;
    }

    function transferToContract() external payable {
        transactionHistory.push(
            Transaction({
                from: msg.sender,
                to: address(this),
                timestamp: block.timestamp,
                amount: msg.value
            })
        );
    }

    function transferToUserViaContract(
        address payable _to,
        uint _weiAmount
    ) external onlyOwner {
        require(address(this).balance >= _weiAmount, "Insufficient Balance");
        _to.transfer(_weiAmount);
        transactionHistory.push(
            Transaction({
                from: msg.sender,
                to: _to,
                timestamp: block.timestamp,
                amount: _weiAmount
            })
        );
        emit Transfer(_to, _weiAmount);
    }

    function withdrawFromContract(uint _weiAmount) external onlyOwner {
        require(address(this).balance >= _weiAmount, "Insufficient Balance");
        payable(owner).transfer(_weiAmount);
        transactionHistory.push(
            Transaction({
                from: address(this),
                to: owner,
                timestamp: block.timestamp,
                amount: _weiAmount
            })
        );
    }
    function getContractBalanceInWei() external view returns (uint) {
        return address(this).balance;
    }

    function emergencyWithdrawl() external{
        require(stop == true);
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        transactionHistory.push(
            Transaction({
                from: msg.sender,
                to: address(this),
                timestamp: block.timestamp,
                amount: msg.value
            })
        );
    }

    fallback() external {
        suspiciousActivity(msg.sender);
    }
}

// for suspicipus user.
contract UserManagement {
    struct User {
        bool isSuspicious;
        uint256 suspiciousTimestamp;
    }

    mapping(address => User) public users;

    event UserBlocked(address indexed user);
    event UserUnblocked(address indexed user);

    function markSuspicious(address _user) external {
        User storage user = users[_user];
        user.isSuspicious = true;
        user.suspiciousTimestamp = block.timestamp;
        emit UserBlocked(_user);
    }

    function unblockUser(address _user) external {
        User storage user = users[_user];
        require(user.isSuspicious, "User is not marked as suspicious");
        require(
            block.timestamp >= user.suspiciousTimestamp + 6 hours,
            "6 hours have not passed yet"
        );

        user.isSuspicious = false;
        emit UserUnblocked(_user);
    }

    function isUserSuspicious(address _user) external view returns (bool) {
        return users[_user].isSuspicious;
    }
}

import "@openzeppelin/contracts/access/AccessControl.sol";

contract RBACUserManagement is AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");

    constructor() {
        // Grant the contract deployer the default admin role: it will be able
        // to grant and revoke any roles
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        // Grant the contract deployer the admin role
        _setupRole(ADMIN_ROLE, msg.sender);
    }

    function addUser(address account) external onlyRole(ADMIN_ROLE) {
        grantRole(USER_ROLE, account);
    }

    function removeUser(address account) external onlyRole(ADMIN_ROLE) {
        revokeRole(USER_ROLE, account);
    }

    function isUser(address account) external view returns (bool) {
        return hasRole(USER_ROLE, account);
    }

    function addAdmin(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(ADMIN_ROLE, account);
    }

    function removeAdmin(
        address account
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(ADMIN_ROLE, account);
    }

    function isAdmin(address account) external view returns (bool) {
        return hasRole(ADMIN_ROLE, account);
    }
}
