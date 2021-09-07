//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoToken is Ownable, ERC721("VolcanoToken", "VoT") {
    uint256 public tokenId = 1;

    mapping(address => Meta[]) public ownerships;

    struct Meta {
        uint256 timestamp;
        uint256 tokenId;
        string tokenURI;
    }

    function mint(string memory uri) public {
        _safeMint(_msgSender(), tokenId);

        Meta[] storage tokens = ownerships[_msgSender()];

        tokens.push(
            Meta({
                timestamp: block.timestamp,
                tokenId: tokenId,
                tokenURI: uri
            })
        );

        ownerships[_msgSender()] = tokens;
        tokenId++;
    }

    function burn(uint256 _tokenId) public {
        require(
            _msgSender() == ERC721.ownerOf(_tokenId),
            "Only token owner can burn"
        );
        _burn(_tokenId);
        _remove(_tokenId);
    }

    function _remove(uint256 _tokenId) internal {
        Meta[] storage array = ownerships[_msgSender()];

        for (uint256 i = 0; i < array.length; i++) {
            if (array[i].tokenId == _tokenId) {
                delete array[i];
                ownerships[_msgSender()] = array;
            }
        }
    }
}
