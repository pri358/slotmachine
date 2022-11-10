// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract Lock {
    uint public unlockTime;
    address payable public owner;

    event Withdrawal(uint amount, uint when);

    constructor() payable {
        // require(
        //     block.timestamp < _unlockTime,
        //     "Unlock time should be in the future"
        // );

        // unlockTime = _unlockTime;
        // owner = payable(msg.sender);
        console.log("Contract here!");
    }

    function logicOfLuck (string memory _message) public payable {
        // Add functionality to make payout according to bet amount

        // Check if user balance > betAmount

        uint8 reel1 = random(1);
        uint8 reel2 = random(2);
        uint8 reel3 = random(3);
        bool isWin = false;

        console.log("Amount bet: ", _message);

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

    function withdraw() public {
        // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
        // console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
    }
}
