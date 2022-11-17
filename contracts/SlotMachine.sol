// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract SlotMachine {

    mapping(address=>int) public players;
    uint256 public contractBalance;
    uint256 randHelp = 0;

    constructor() payable {
        console.log("Contract here!");
    }

    event balances (
        uint256 betAmount, 
        uint256 userBalance, 
        uint256 contractBalance
    );

    function play(uint256 _betAmount) public payable {
        // Uncomment below code once dummy user has balance

        uint userBalance = msg.value ;
        console.log("bet amount ", _betAmount);
        console.log("user balance: ", userBalance);

        require(userBalance > _betAmount, "User should have enough balance");
        contractBalance = address(this).balance;

        console.log("contract Balance: ", contractBalance);

        emit balances(_betAmount, userBalance, contractBalance);

       //logicOfLuck(_betAmount);
    }

    function logicOfLuck (uint256 _betAmount) public payable {
        // Add functionality to make payout according to bet amount

        // Check if user balance > betAmount

        uint8 reel1 = random();
        uint8 reel2 = random();
        uint8 reel3 = random();
        bool isWin = false;

        console.log("Amount bet: ", _betAmount);

        console.log("Reel1: ", reel1);
        console.log("Reel2: ", reel2);
        console.log("Reel3: ", reel3);

        uint256 prizeAmount = 0 ether;

        if(reel1 == reel2 || reel2 == reel3 || reel3 == reel1) {
            // Check if all same
            if(reel1 == reel2 && reel2 == reel3) {
                console.log("JACKPOT! You win 0.1 ETH");
                prizeAmount = 0.1 ether;
            } else {
                console.log("Congratulations. You win 0.01 ETH");
                prizeAmount = 0.01 ether;
            }
            isWin = true;
        } else {
            console.log("Loser :) ");
        }
        
        if (isWin) {
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
    }

    function random() public returns (uint8) {
        // Use available information to produce hash that aids in random number generation

        // Increment value that will help in random number generation
        randHelp++; 
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp,msg.sender,randHelp)))) % 20;

        /* 
        Another way to solve this would be to use an oracle to access a random number function from 
        outside the Ethereum blockchain. There are other cryptographic algorithms and third party 
        functions that can be utilized, but they are not safe or should be audited.
        Source: https://www.geeksforgeeks.org/random-number-generator-in-solidity-using-keccak256/
        */
    }
}