// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MultiSigWallet {
    // 存款事件
    event Deposit(address indexed sender, uint amount);
    // 提交事件
    event Submit(uint indexed txId);
    // 批准事件
    event Approve(address indexed owner, uint indexed txId);
    // 撤销事件
    event Revoke(address indexed owner, uint indexed txId);
    // 执行事件
    event Execute(uint indexed txId);

    address[] public owners;
    // 这样操作是为了查找一个用户是否是owner时比较方便，可以避免for循环，降低gas消耗
    mapping(address=>bool) public isOwner;

    // 最低批准数，>=这个数则批准
    uint public required;

    struct Transaction {
        address to;
        uint value;
        bytes data; // 如果目标地址是合约地址，可以执行方法
        bool executed;
    }

    // 记录需要执行交易
    Transaction[] public transactions;
    // 记录某个交易之下，签名人是否已经批准该交易
    mapping(uint => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint txId) {
        require(txId < transactions.length, "tx doex not existed");
        _;
    }

    modifier notApproved(uint txId) {
        require(!approved[txId][msg.sender], "tx already approved");
        _;
    }

    modifier notExecuted(uint txId) {
        require(!transactions[txId].executed, "tx already executed");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "owners required");
        require(_required > 0 && required <= _owners.length-1, "invalid required number of owners");

        for(uint i = 0; i<_owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "invalid owner");
            // 不能是已添加过的地址
            require(!isOwner[owner], "owner is not unique");

            isOwner[owner] = true;
            owners.push(_owners[i]);
        }

        required = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        }));
        emit Submit(transactions.length-1);
    }

    function approve(uint _txId) external onlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId) {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function _getApproveCount(uint _txId) private view returns(uint count) {
        for(uint i=0; i<owners.length; i++) {
            if(approved[_txId][owners[i]]) {
                count += 1;
            }
        }
    }

    function execute(uint _txId) external txExists(_txId) notExecuted(_txId) {
        require(_getApproveCount(_txId) >= required, "approvals < required");
        Transaction storage transaction = transactions[_txId];
        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "tx failed");

        emit Execute(_txId);
    }

    function revoke(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId) {
        require(approved[_txId][msg.sender], "tx not approved");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }
}