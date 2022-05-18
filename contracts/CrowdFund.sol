// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract CrowdFund {

    struct Campaign {
        address creator; 
        uint goal; // 众筹目标数量
        uint pledged; // 已参与的数量
        uint startAt;
        uint endAt;
        bool claimed; // 是否已提取
    }

    IERC20 public immutable token;

    uint public count; // 众筹编号
    mapping(uint=>Campaign) public campaigns; // 众筹编号=>众筹结构体
    mapping(uint=>mapping(address=>uint)) public pledgedAmount; // 众筹编号=>(捐赠人=>捐赠token)

    event Launch(uint id, address indexed creator, uint goal, uint startAt, uint endAt);
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed caller, uint amount);
    event UnPledge(uint indexed id, address indexed caller, uint amount);
    event Claim(uint id);
    event Refund(uint indexed id, address indexed caller, uint amount);

    constructor(address _token) {
        token = IERC20(_token);
    }

    // 开启众筹
    function launch(uint _goal, uint _startAt, uint _endAt) external {
        require(_startAt >= block.timestamp, "start at < now");
        require(_endAt >= _startAt, "end at < start at");
        require(_endAt <= block.timestamp + 90 days, "end at > max duration");

        count += 1;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    // 取消众筹
    function cancel(uint _id) external {
        Campaign memory campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator");
        require(block.timestamp < campaign.startAt, "started");
        delete campaigns[_id];

        emit Cancel(_id);
    }

    // 参与众筹
    function pledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp>=campaign.startAt, "not started");
        require(block.timestamp<=campaign.endAt, "ended");

        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);
    }

    // 取消参与众筹
    function unPledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp<=campaign.endAt, "ended");

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit UnPledge(_id, msg.sender, _amount);
    }

    // 取出众筹的token
    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator");
        require(block.timestamp >= campaign.endAt, "not ended");
        require(campaign.pledged >= campaign.goal, "pledged < goal");
        require(!campaign.claimed, "claimed");

        campaign.claimed = true;    
        token.transfer(msg.sender, campaign.pledged);
        
        emit Claim(_id);
    }

    // 未达到众筹目标，则用户可以取回token
    function refund(uint _id) external {
        Campaign memory campaign = campaigns[_id];
        require(block.timestamp >= campaign.endAt, "not ended");
        require(campaign.pledged < campaign.goal, "pledged > goal");

        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);

        emit Refund(_id, msg.sender, bal);
    }
}