// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// 方式一
contract Z is X("X"), Y("Y") {
}

// 方式二
contract V is X,Y {
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}

// 方式三
contract B is X,Y("Y") {
    constructor(string memory _name) X(_name) {}
}