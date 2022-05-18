// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SendEth {

    constructor() payable {}

    receive() external payable {}

    // transfer
    function sendViaTransfer(address payable _to) external payable {
        _to.transfer(123);
    }

    // send
    function sendViaSend(address payable _to) external payable {
        bool status = _to.send(123);
        require(status, "send failed!");
    }

    // call
    function sendViaCall(address payable _to) external payable {
        (bool status,) = _to.call{value: 123}("");
        require(status, "send failed!");
    }
}

contract EthReceiver {
    event Log(uint amount, uint gas);

    receive() external payable {
        emit Log(msg.value, gasleft());
    }
}

