// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FunctionOutPut {

    function returnMany() public pure returns(uint, bool) {
        return (1, true);
    }

    function returnManyWithName() public pure returns(uint a, bool b) {
        return (1, false);
    }

    function manyWithoutReturn() public pure returns(uint a, bool b) {
        a = 1;
        b = true;
    }

    function readReturns() public pure returns(uint, bool) {
       (uint x, bool y) = manyWithoutReturn();
       return (x, y);
    }
}