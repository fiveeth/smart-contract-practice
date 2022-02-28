// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Bonus {

    // 奖金余额
    uint balance;
    // 获奖人列表
    address[] winners = [
      0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
      0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,
      0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
    ];
    // 领奖人集合
    mapping(address=> uint) paiders;
    // 领奖成功信息通知
    event withdrawSuccess(address, uint, string);

    constructor() payable{
        // 设置奖金余额
        setTotalBalance();
    }

    // 设置余额
    function setBalance() public payable{
        setTotalBalance();
    }

    // 设置总的余额，msg.value不直接暴露给外部调用
    function setTotalBalance() internal {
        balance += msg.value;
    }

    // 判断领奖人是否在获奖人名单中
    modifier isWinner() {
        bool contain;

        for(uint i = 0; i < winners.length; i++) {
            if(msg.sender == winners[i]){
                contain = true;
                break;
            }
        }

        require(contain);
        _;
    }

    // 领奖
    function withdraw() public isWinner {
        // 应领奖金
        uint avg = balance / winners.length;
        // 已领奖金
        uint paid = paiders[msg.sender];
        // 未领取奖金
        uint shouldPay = avg - paid;
        // 断言未领取奖金是否大于0，否则直接抛错
        assert(shouldPay > 0);
        // 必须要是payable，否则报错
        if(payable(msg.sender).send(shouldPay)) {
            paiders[msg.sender] += shouldPay;
            emit withdrawSuccess(msg.sender, shouldPay, "Withdraw Successfully!");
        }
    }
}
