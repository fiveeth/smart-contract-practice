// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    constructor() ERC721("TEST", "T") {
    }

    function safeMint(address to, uint256 tokenId) external virtual {
        super._safeMint(to, tokenId, "");
    }

}