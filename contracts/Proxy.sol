// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
* 通过合约来部署合约
*/
contract TestContractOne {
    address public owner = msg.sender;

    function setOwner(address _owner) public {
        require(msg.sender == owner, "not owner");
        owner = _owner;
    }
}

contract TestContractTwo {
    address public owner = msg.sender;
    uint public value = msg.value;
    uint public x;
    uint public y;

    constructor(uint _x, uint _y) payable {
        x = _x;
        y = _y;
    }
}

contract Proxy {
    event Deploy(address);

    // 通过new的方式可以部署合约，但是这种方式的缺点是：每部署一次新的合约，就必须得重新部署代理合约
    // function deploy() external payable {
    //     new TestContractOne();
    // }

    // 通过内联汇编的方式部署合约
    function deploy(bytes memory _code) external payable returns(address addr) {
        // create(v,p,n)  v: 发送给合约的eth,正常是msg.value,但是在内联汇编中需要callvalue()获取
        // p: 代表内存中机器码开始的位置 n: _code的大小
        assembly {
            addr := create(
                callvalue(),
                add(_code, 0x20),
                mload(_code)
            )
        }

        require(addr != address(0), "deploy failed!");
        emit Deploy(addr);
    }

    function excute(address _target, bytes memory _data) external payable {
         (bool success,) = _target.call{value: msg.value}(_data);
         require(success, "failed");
    }
}

contract Helper {

    // 获取合约一的字节码
    function getByteCodeOne() external pure returns (bytes memory) {
        bytes memory bytecode = type(TestContractOne).creationCode;
        return bytecode;
    }

    // 获取合约二的字节码
    function getByteCodeTwo(uint _x, uint _y) external pure returns (bytes memory) {
        bytes memory bytecode = type(TestContractTwo).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_x,_y));
    }

    function getCalldata(address _owner) external pure returns(bytes memory) {
        return abi.encodeWithSignature("setOwner(address)", _owner);
    }
}