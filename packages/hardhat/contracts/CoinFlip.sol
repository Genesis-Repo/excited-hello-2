// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CoinFlip is Ownable {
    // Using Ownable from OpenZeppelin to manage contract ownership
    
    uint256 public houseEdge; // House edge percentage
    IERC20 public token; // Token used for betting
    uint256 public constant MAX_BET_AMOUNT = 1 ether; // Maximum bet amount set to 1 ether
    
    event BetResult(address player, uint256 amount, bool won);
    
    constructor() {
        houseEdge = 51;
        token = IERC20(0x1234567890123456789012345678901234567890); // Replace with actual token address
    }
    
    // Function to allow players to bet on the coin flip
    function bet(uint256 amount, bool choice) external {
        require(amount > 0, "Bet amount must be greater than 0");
        require(amount <= MAX_BET_AMOUNT, "Exceeds maximum bet amount");
        require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        // Generate random number between 0 and 99
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 100;
        
        bool playerWins = choice == (randomNumber < houseEdge);
        
        if (playerWins) {
            // Transfer double the amount to the player if they win
            token.transfer(msg.sender, amount * 2);
        }
        
        emit BetResult(msg.sender, amount, playerWins);
    }
}