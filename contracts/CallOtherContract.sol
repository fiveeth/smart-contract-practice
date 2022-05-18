// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CallOtherContract {

    // 第一种方式
    // function setX(address _test, uint _x) external {
    //     TestContract(_test).setX(_x);
    // }

    // 第二种方式
    function setX(TestContract _test, uint _x) external {
        _test.setX(_x);
    }

    function getX(address _test) external view returns(uint) {
        return TestContract(_test).getX();
    }

    function setXandSendEth(address _test, uint _x) external payable{
        TestContract(_test).setXandSendEth{value: msg.value} (_x);
    }

    function getXandSendEth(address _test) external view returns(uint x, uint value) {
        (x, value) = TestContract(_test).getXandSendEth();
    }

}

contract TestContract {
    uint public x;
    uint public value;

    function setX(uint _x) public {
        x = _x;
    }

    function getX() public view returns(uint) {
        return x;
    }

    function setXandSendEth(uint _x) public payable {
        x = _x;
        value = msg.value;
    }

    function getXandSendEth() public view returns(uint,uint) {
        return (x, value);
    } 
}