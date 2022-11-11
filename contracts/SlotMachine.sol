// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract SlotMachine {

    mapping(address=>int) public players;
    uint256 public contractBalance;

    constructor() payable {
        console.log("Contract here!");
    }

    function play(string memory _betAmount) public payable {
        // Uncomment below code once dummy user has balance

        /*
        uint256 userBalance = msg.value;
        require(userBalance > _betAmount, "User should have enough balance");
        contractBalance = address(this).balance;
        uint256 winBalance = calculateLoL();
        if(winBalance > 0){
            payable(msg.sender).transfer(winBalance);
            contractBalance = address(this).balance;
        }
        */

       logicOfLuck(_betAmount);
    }

    function logicOfLuck (string memory _betAmount) public payable {
        // Add functionality to make payout according to bet amount

        // Check if user balance > betAmount

        uint8 reel1 = random(1);
        uint8 reel2 = random(2);
        uint8 reel3 = random(3);
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

    function random(uint8 option) public view returns (uint8) {
        // Think of better way to randomize for multiple calls at same time
        if (option == 1) {
            return uint8(uint256(keccak256(abi.encodePacked(block.timestamp))) % 5) + 1;
        } else if (option == 2) {
            return uint8(uint256(keccak256(abi.encodePacked(block.difficulty))) % 10) + 1;
        } else {
            return uint8(uint256(keccak256(abi.encodePacked(msg.sender))) % 10) + 1;
        }
    }
}