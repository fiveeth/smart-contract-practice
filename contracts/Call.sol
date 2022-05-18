// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestCall {
    string public message;
    uint public x;

    event Log(string message);

    fallback() external payable {
        emit Log("fallback called");
    }

    function foo(string memory _message, uint _x) external payable returns(bool, uint) {
        message = _message;
        x = _x;
        return (true, 999);
    }
}

contract Call {
    bytes public data;

    function callFoo(address _test) external payable {
        (bool _status, bytes memory _data) = _test.call{value: 100}(abi.encodeWithSignature(
            "foo(string,uint256)", "call", 10));  // "foo(string,uint256)"这块参数类型之间一定不能有空格
        require(_status, "call failed");
        data = _data;
    }

    function callOther(address _test) external {
        (bool _status, ) = _test.call(abi.encodeWithSignature(
            "callOther()"));
        require(_status, "callOther failed");
    }
}