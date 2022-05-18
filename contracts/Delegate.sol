// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestDelegate {
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

contract Delegate {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _test, uint _num) external payable {
        (bool success, ) = _test.delegatecall(abi.encodeWithSelector(TestDelegate.setVars.selector, _num));
        require(success, "delegatecall failed!");
    }
}