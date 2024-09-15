// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

interface IERC20 {
    function transfer(address reciver, uint256 amount) external;
}
contract ABIencodeDecode is IERC20 {
    event Transfer(address _receiver, uint amount);
    function transfer(address _receiver, uint256 _amount) external override {
        emit Transfer(_receiver, _amount);
    }
    function encodeData(
        uint256 fixedNumber,
        string memory dynamicString,
        uint256[2] memory fixedArray,
        uint256[] memory dynamicArray
    ) public pure returns (bytes memory) {
        return abi.encode(fixedNumber, dynamicString, fixedArray, dynamicArray);
    }

    function decodeData(
        bytes memory data
    )
        public
        pure
        returns (uint256, string memory, uint256[2] memory, uint256[] memory)
    {
        (
            uint256 fixedNumber,
            string memory dynamicString,
            uint256[2] memory fixedArray,
            uint256[] memory dynamicArray
        ) = abi.decode(data, (uint256, string, uint256[2], uint256[]));
        return (fixedNumber, dynamicString, fixedArray, dynamicArray);
    }
}

contract encodeFunctions {
    function callABIencodeDecodeFunction(
        address _contract,
        bytes calldata data
    ) external {
        (bool ok, ) = _contract.call(data);
        require(ok, "Failed to call contract");
    }
    function encodeWithSignature(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    }
    function encodeWithSelector(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
    }
    function encodeCall(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }
}