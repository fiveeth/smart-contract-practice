// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// 对赌游戏
contract Bet {
    // 玩家1
    address public playerOne;
    // 玩家2
    address public playerTwo;
    // 玩家1是否已下注
    bool public onePlayed;
    // 玩家2是否已下注
    bool public twoPlayed;
    // 玩家1的投注
    uint public onePool;
    // 玩家2的投注
    uint public twoPool;

    // 游戏状态
    bool public gameOver;
    // 游戏赢家
    address public winner;
    // 奖金池
    uint public pool;

    // 游戏开始事件
    event gameStartEvent(address p1, address p2);
    // 回合结束事件
    event roundOverEvent(uint onePool, uint twoPool);
    // 游戏结束事件
    event gameOverEvent(address winner, uint pool);

    // 注册玩家
    function register() public {
        // 占位 p1没人占p1，p2没人占p2，都有人则报错
        if(playerOne == address(0)) {
            playerOne = msg.sender;
        } else if(playerTwo == address(0)) {
            playerTwo = msg.sender;

            emit gameStartEvent(playerOne, playerTwo);
        } else {
            revert('Position is full!');
        }
    }

    // 下注
    function bets() public payable{
        // 判断游戏是否结束且用户已注册
        require(gameOver == false && (msg.sender == playerOne || msg.sender == playerTwo), "game is over or you need register");

        // 下注
        if(msg.sender == playerOne) {
            require(onePlayed == false, 'you already played');

            onePlayed = true;
            onePool += msg.value;
        } else {
            require(twoPlayed == false, 'you already played');

            twoPlayed = true;
            twoPool += msg.value;
        }

        // 如果两个玩家都下注可以开牌
        if(onePlayed && twoPlayed) {
            // 玩家1下注超过玩家2下注2倍，则获胜；反之亦然
            if(onePool >= twoPool*2) {
                gameFinish(playerOne);
            } else if(twoPool >= onePool){
                gameFinish(playerTwo);
            } else {
                roundOver();
            }
        }
    }

    // 回合结束
    function roundOver() internal {
        onePlayed = false;
        twoPlayed = false;

        emit roundOverEvent(onePool, twoPool);
    }

    // 游戏结束
    function gameFinish(address player) internal {
        gameOver = true;
        winner = player;
        pool = onePool + twoPool;

        emit gameOverEvent(winner, pool);
    }

    // 赢家提现
    function withdraw() public {
        require(gameOver && (msg.sender == winner), "game is not over or you're not the winner");

        payable(msg.sender).transfer(pool);
        pool = 0;
    }
}