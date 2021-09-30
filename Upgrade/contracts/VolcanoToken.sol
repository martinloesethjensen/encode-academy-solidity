//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoToken is Ownable, ERC721("VolcanoToken", "VoT") {
    uint256 public tokenId = 0;

    mapping(address => Meta[]) public ownerships;

    struct Meta {
        uint256 timestamp;
        uint256 id;
        string tokenURI;
    }

    function getMetas() public view returns (Meta[] memory) {
        return ownerships[_msgSender()];
    }

    function getMeta(uint8 index) public view returns (Meta memory) {
        return ownerships[_msgSender()][index];
    }

    function getCurrentTokenId() public view returns (uint256) {
        return tokenId;
    }

    function mint(string memory uri) public {
        tokenId++;

        _safeMint(_msgSender(), tokenId);

        ownerships[_msgSender()].push(
            Meta({
                id: tokenId,
                tokenURI: uri,
                timestamp: block.timestamp
            })
        );
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
            if (array[i].id == _tokenId) {
                delete array[i];
                ownerships[_msgSender()] = array;
            }
        }
    }
}
