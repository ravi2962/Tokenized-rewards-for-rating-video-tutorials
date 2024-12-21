// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VideoTutorialRewards {
    // Token details
    string public constant name = "TutorialToken";
    string public constant symbol = "TUT";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    address public owner;
    uint256 public rewardPerRating = 10 * 10**decimals; // Reward 10 tokens per rating

    mapping(address => uint256) public balanceOf;
    mapping(uint256 => bool) public ratedVideos; // To track rated videos (videoID => true/false)

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event VideoRated(address indexed rater, uint256 videoID, uint256 reward);

    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply * 10**decimals;
        balanceOf[owner] = totalSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can execute this");
        _;
    }

    // Transfer tokens
    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        require(to != address(0), "Invalid address");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    // Rate a video
    function rateVideo(uint256 videoID) public {
        require(!ratedVideos[videoID], "Video has already been rated");
        require(balanceOf[owner] >= rewardPerRating, "Not enough tokens for rewards");

        ratedVideos[videoID] = true;
        balanceOf[owner] -= rewardPerRating;
        balanceOf[msg.sender] += rewardPerRating;

        emit VideoRated(msg.sender, videoID, rewardPerRating);
    }

    // Update reward amount (owner only)
    function updateReward(uint256 newReward) public onlyOwner {
        rewardPerRating = newReward * 10**decimals;
    }
}