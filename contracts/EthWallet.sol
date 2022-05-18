// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EthWallet {

    address payable public owner; 

    constructor() {
        owner = payable(msg.sender);
    }

    function withdraw(uint _amount) public {
        require(msg.sender == owner, "caller must be owner!");
        owner.transfer(_amount);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    receive() external payable {}
}