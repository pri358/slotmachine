// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract SlotMachine {

    mapping(address=>int) public players;
    uint256 public contractBalance;

    function play(uint256 _betAmount) public payable {
        uint256 userBalance = msg.value;
        require(userBalance > _betAmount, "User should have enough balance");
        contractBalance = address(this).balance;
        uint256 winBalance = calculateLoL();
        if(winBalance > 0){
            payable(msg.sender).transfer(winBalance);
            contractBalance = address(this).balance;
        }
    }

    function calculateLoL() internal pure returns (uint256) {
        return 100;
    }

    function random() internal view returns (uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp))) % 100) + 1; // 1 ~ 100 (Only for testing.)
    }

}