// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract ERC20{
    // 代币名称
    string public tokenName;
    // 代币符号
    string public tokenSymbol;
    // 代币小数位
    uint public decimals = 18;
    // 代币供应量
    uint public totalSupply;

    // 持币者余额列表
    mapping (address=>uint) public balanceOf;
    // 持币者授权额度列表
    mapping (address=>mapping (address=>uint)) allowance;

    // 转账事件
    event Transfer(address indexed from, address indexed to, uint value);
    // 授权额度(副卡批准)事件
    event Approval(address indexed owenr, address indexed spender, uint value);
    // 销毁事件
    event Burn(address indexed from, uint value);

    // 合约构造器
    constructor(uint _initSupply, string memory _tokenName, string memory _tokenSymbol) {
        totalSupply = _initSupply * (10 ** decimals);
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;

        balanceOf[msg.sender] = totalSupply;
    }

    // 转账(内部)
    function _transfer(address from, address to, uint value) internal {
        // 防止给零地址转账
        require(to != address(0));
        // 余额检查
        require(balanceOf[from] >= value);
        // 溢出检查
        require(balanceOf[to]+value >= balanceOf[to]);
        
        // 账目平衡检查(转账前)
        uint preBalance = balanceOf[from] + balanceOf[to];

        balanceOf[from] -= value;
        balanceOf[to] += value;

        // 账目平衡检查(转账后)
        assert(balanceOf[from]+balanceOf[to] == preBalance);

        emit Transfer(from, to, value);
    }

    // 发起人转账
    function transfer(address to, uint value) public returns(bool) {
        _transfer(msg.sender, to, value);

        return true;
    }

    // 授权(副卡批准)
    function approval(address spender, uint value) public returns(bool) {
        require(spender != address(0));

        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    // 其他人转账(副卡发起转账)
    function transferFrom(address from, address to, uint value) public returns(bool) {
        require(from != address(0));
        require(to != address(0));

        // 转账的value小于批准的额度检查
        require(value<=allowance[from][msg.sender]);

        allowance[from][msg.sender] -= value;
        
        _transfer(from,to,value);
        return true;
    }

    // 销毁
    function burn(uint value) public returns(bool) {
        // 余额检查
        require(balanceOf[msg.sender] >= value);

        balanceOf[msg.sender] -= value;
        totalSupply -= value;

        emit Burn(msg.sender, value);

        return true;
    }

    // 销毁副卡中的钱
    function burnFrom(address from, uint value) public returns(bool) {
        require(from != address(0));
        // 余额检查
        require(balanceOf[from] >= value);
        // 授权额度检查
        require(allowance[from][msg.sender] >= value);
 
        allowance[from][msg.sender] -= value;
        balanceOf[from] -= value;
        totalSupply -= value;

        emit Burn(from, value);

        return true;
    }
}