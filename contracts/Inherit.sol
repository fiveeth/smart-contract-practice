// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract X {

    function bar() public pure virtual returns(string memory) {
        return "X";
    }

    function foo() public pure virtual returns(string memory) {
        return "X";
    }

    function x() public pure returns(string memory) {
        return "X";
    }
}

contract Y is X {

    function bar() public pure override virtual returns(string memory) {
        return "Y";
    }

    function foo() public pure override virtual returns(string memory) {
        return "Y";
    }

    function y() public pure returns(string memory) {
        return "Y";
    }
}

// 继承顺序：先继承基类，再继承派生类
contract Z is X,Y {

    function bar() public pure override(X,Y) returns(string memory) {
        return "Z";
    }

    function foo() public pure override(Y,X) returns(string memory) {
        return "Z";
    }

    function z() public pure returns(string memory) {
        return "Z";
    }
}