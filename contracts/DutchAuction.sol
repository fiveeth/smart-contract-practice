//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}

// 荷兰拍
contract DutchAuction {

    uint private constant DURATION = 7 days;

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint public immutable startingPrice; //起拍价格
    uint public immutable startAt; //起拍时间
    uint public immutable expiresAt; //过期时间
    uint public immutable discountRate; //折扣率：每秒折损费

    constructor(
        address _nft, 
        uint _nftId, 
        uint _startingPrice, 
        uint _discountRate
    ) {
        require(
            _startingPrice>=_discountRate*DURATION,
            "starting price <= discount"
        );

        nft = IERC721(_nft);
        nftId = _nftId;
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        seller = payable(msg.sender);
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;
    }

    // 获取拍品当前价格
    function getPrice() public view returns(uint) {
        require(block.timestamp < expiresAt, "auction expired");
        // 流逝时间
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }

    // 购买
    function buy() external payable {
        require(block.timestamp < expiresAt, "auction expired");

        uint price = getPrice();
        require(msg.value >= price, "ETH < price");

        nft.transferFrom(seller, msg.sender, nftId);

        // 退还金额
        uint refund = msg.value - price;
        if(refund>0) {
            payable(msg.sender).transfer(refund);
        }

        selfdestruct(seller);
    }
}