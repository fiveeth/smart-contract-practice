// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownerable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "just owner can do it!");
        _;
    }

    function setNewOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "address can not be zero!");
        owner = _newOwner;
    }

    function onlyOwnerDo() external onlyOwner {

    }

    function widthoutOwnerDo() external {

    }
}