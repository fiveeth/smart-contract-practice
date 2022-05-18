// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract EnglishAuction {

    IERC721 public immutable nft;
    uint public immutable nftId;
    address payable public immutable seller;
    uint32 public endAt; //过期时间
    bool public started;
    bool public ended;
    address public highestBidder; //最高的出价者
    uint public highestBid; //最高的出价
    mapping(address=>uint) public bids; //记录出价记录

    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed sender, uint amount);
    event End(address highestBidder, uint amount);

    constructor(
        address _nft,
        uint _nftId,
        uint _startingBid
    ) {
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start() external {
        require(msg.sender == seller, "not seller");
        require(!started, "started");

        started = true;
        endAt = uint32(block.timestamp + 60);
        nft.transferFrom(seller, address(this), nftId); // 将nft从seller账户转移到合约账户

        emit Start();
    }

    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, "value < highest bid");

        // 记录上一位最高出价者的出价记录，可以进行累加，后续返还
        if(highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require(started, "not started");
        require(!ended, "ended");
        require(block.timestamp>=endAt, "not ended");

        ended = true;

        if(highestBidder != address(0)) {
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.transferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}