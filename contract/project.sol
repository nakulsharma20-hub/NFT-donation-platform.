// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract NFTDonationPlatform {
    string public name = "DonationNFT";
    string public symbol = "DNFT";
    uint256 public tokenIdCounter;
    mapping(uint256 => address) public tokenOwners;
    mapping(uint256 => uint256) public donationAmount;
    mapping(address => uint256) public totalDonations;

    event NFTMinted(address indexed recipient, uint256 tokenId);
    event NFTDonated(address indexed donor, uint256 tokenId, uint256 amount);
    event FundsWithdrawn(address indexed recipient, uint256 amount);

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function mintNFT(address recipient) public onlyOwner {
        tokenIdCounter++;
        tokenOwners[tokenIdCounter] = recipient;
        emit NFTMinted(recipient, tokenIdCounter);
    }

    function donateNFT(uint256 tokenId) external payable {
        require(tokenOwners[tokenId] != address(0), "NFT does not exist");
        require(msg.value > 0, "Donation must be greater than 0");
        
        donationAmount[tokenId] += msg.value;
        totalDonations[msg.sender] += msg.value;
        emit NFTDonated(msg.sender, tokenId, msg.value);
    }

    function withdrawFunds(address payable recipient, uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient funds");
        recipient.transfer(amount);
        emit FundsWithdrawn(recipient, amount);
    }

    function getDonationAmount(uint256 tokenId) external view returns (uint256) {
        return donationAmount[tokenId];
    }
    
    function getTotalDonations(address donor) external view returns (uint256) {
        return totalDonations[donor];
    }
}

