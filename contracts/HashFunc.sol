// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HashFunc {

    function test(string memory one, uint num, address addr) external pure returns(bytes32) {
        return keccak256(abi.encodePacked(one,num,addr));
    }

    function testEncode(string memory one, string memory two) external pure returns(bytes memory) {
        return abi.encode(one, two);
    }

    function testEncodePacked(string memory one, string memory two) external pure returns(bytes memory) {
        return abi.encodePacked(one, two);
    }
}