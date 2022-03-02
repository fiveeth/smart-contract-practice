// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 <0.9.0;

// 众筹
contract CrowSale {
    
    // 众筹结构体
    struct Project {
        // 受益方
        address boss;
        // 目标金额(以太)
        uint goal;
        // 筹集期限
        uint deadline;
        // 实际筹集金额
        uint raised;
    }

    // 投资人结构体
    struct Investor {
        address boss; // 受益方
        uint investment; // 投资额
    } 

    // 众筹列表
    mapping(address=>Project) public projects;

    // 投资人列表
    mapping(address=>Investor) public investors;

    // 事件
    event GoalReached(address, uint); //筹资达成
    event FundTransfered(address, uint); //某个活动的发起人提起了筹集的资金，或者投资人取回了资金

    // 发起一个众筹
    function createProject(uint _goal, uint _deadline) public {
        Project storage p = projects[msg.sender];
        p.boss = msg.sender;
        p.goal = _goal;
        p.deadline = block.timestamp + _deadline * 1 seconds;
    }

    // 投资者的投资
    function invest(address _boss) public payable{
        Project storage p = projects[_boss];
        
        // 期限检查，投资时间点是否超过投资期限
        require(p.deadline >= block.timestamp, 'The project is finished!');

        //更新投资人信息，筹集金额的增加
        Investor storage investor = investors[msg.sender];
        investor.boss = _boss;
        investor.investment = msg.value;

        p.raised += msg.value / (10**18);
    }

    // 兑现 (发起人或者投资者)
    function withdraw(address _boss) public {
        Project memory project = projects[_boss];

        // 众筹是否已结束，结束才能兑现
        require(project.deadline < block.timestamp, 'The project is not finished yet!');

        // 检查筹集目标是否达成，达成则发起人可以提现，否则投资者可以提现
        bool goalReached = (project.raised > project.goal);

        // 目标没达成且不是活动发起人，投资人取回投资额
        if(!goalReached && msg.sender != project.boss) {
            Investor memory investor = investors[msg.sender];
            uint amount = investor.investment;
            if(amount > 0) {
                payable(msg.sender).transfer(amount);
                investor.investment = 0;

                emit FundTransfered(msg.sender, amount);
            }
        }

        // 目标达成且是活动发起人，可以提现
        if(goalReached && msg.sender == project.boss) {
            emit GoalReached(project.boss, project.raised);

            // ether转换成wei这一步很重要
            payable(project.boss).transfer(project.raised * (10**18));

            emit FundTransfered(project.boss, project.raised);
        }
    }
}