// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CustomError {
    error MyError(address caller, uint i);

    function testCumtomError(uint _i) external view {
        if(_i > 10) {
            revert MyError(msg.sender, _i);
        }
    }
}