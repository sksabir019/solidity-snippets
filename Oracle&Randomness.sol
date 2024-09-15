// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/provable-things/ethereum-api/blob/master/provableAPI.sol";

contract Oracle is usingProvable {
    string public activity;

    function getActivity() public payable {
        provable_query(
            "URL",
            "json(https://bored-api.appbrewery.com/random).activity"
        );
    }

    function __callback(bytes32 _myid, string memory _result) public {
        require(msg.sender == provable_cbAddress());
        activity = _result;
        _myid;
    }

    function getRandomNum(uint256 _seed) public view returns (uint256) {
        uint256 random = (uint256(
            keccak256(abi.encodePacked(block.timestamp, _seed))
        ) % 100) + 1;
        return random;
    }
}
