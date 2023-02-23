// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TikiTrees is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    //uint256 public maxSupply; - There's no max supply in this contract
    //uint256 public maxPerWallet; - There won't be a maximum mint per wallet
    bool public isPublicMintEnabled;
    string internal baseTokenURI;
    address payable public withdrawWallet; //withdraw funds from wallet

    //mapping(address =>uint256) public walletMints; - keep track of the mints per wallet

    constructor() payable ERC721("TikiTrees", "TT") {
        mintPrice = 0.005 ether;
        totalSupply = 0;
        //withdrawWallet = "0x11F7082427A4BBB0ebbfF025dD3B9beb1476a285";
    }

    function setIsPublicMintEnabled(
        bool isPublicMintEnabled_
    ) external onlyOwner {
        isPublicMintEnabled = isPublicMintEnabled_;
    }

    //add url to metadata
    function setBasedTokenUri(
        string calldata baseTokenURI_
    ) external onlyOwner {
        baseTokenURI = baseTokenURI_;
    }

    //need to override existing function and make sure we add the token uri to a json format for opensea to read the image
    function tokenURI(
        uint256 tokenId_
    ) public view override returns (string memory) {
        require(_exists(tokenId_), "Token does not exist!");
        return
            string(
                abi.encodePacked(
                    baseTokenURI,
                    Strings.toString(tokenId_),
                    ".json"
                )
            );
    }

    //function to withdrraw funds from the contract
    function withdraw(uint amount) external onlyOwner {
        (bool success, ) = owner().call{value: amount}("");
        require(success, "withdraw failed");
    }

    //mint function for tree buyers
    function mint(uint256 quantity_) public payable {
        require(isPublicMintEnabled, "Minting not enabled");
        require(msg.value == quantity_ * mintPrice, "wrong mint value");
        //require(totalSupply + quantity_ <= maxSupply, 'sold out'); Not needed as there is no supply cap
        //require (walletMints[msg.sender] + quantity_ <= maxPerWallet, 'exceed max mint per wallet'); No max when minting

        for (uint256 i = 0; i < quantity_; i++) {
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId);
        }
    }

    //mint function for contract owner
    function safeMint(address to) public onlyOwner {
        uint256 newTokenId = totalSupply + 1;
        _safeMint(to, newTokenId);
        totalSupply++;
    }

    //Soulbound token
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721) {
        require(from == address(0), "Token not transferable");
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    //soulbound nft, non trasnferable
    /* function safeTransferFrom(address, address, uint256) pure public override {
        require(false, "Transfers are not allowed for this token");
    } */
}
