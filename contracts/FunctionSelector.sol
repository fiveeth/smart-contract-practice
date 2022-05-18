// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FunctionSelector {

    // 函数在链上的签名
    function getSelector(string calldata _func) external pure returns(bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}

contract Receiver {

    event Log(bytes data);

    function transfer(address _to, uint _amount) external {
        emit Log(msg.data);
        //0xa9059cbb // 函数签名
        //0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4 // 参数_to
        //00000000000000000000000000000000000000000000000000000000000186a0 // 参数_amount
    }
}