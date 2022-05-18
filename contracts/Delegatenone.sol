// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestDelegatenone {
    uint public num;
    address public sender;
    uint public value;
    uint public wenum;

    function setVars(uint _num) external payable {
        num = _num * 2;
        sender = msg.sender;
        value = msg.value;
    }
}

contract Delegatenone {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _test, uint _num) external payable {
        (bool success, ) = _test.call{value: 100}(abi.encodeWithSignature("setVars(uint256)", _num));
        require(success, "call failed!");
    }
}