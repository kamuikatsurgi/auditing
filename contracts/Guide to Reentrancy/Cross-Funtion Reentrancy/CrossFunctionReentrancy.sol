// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract VulnerableBank {
    mapping (address => uint256) public balances;

    function deposit() external payable { // consider we have used nonRentrant from oppenzepplin
        require(msg.value > 0, "Send enough ether!");
        balances[msg.sender] += msg.value;
        }

        function withdraw(uint256 amount) external payable {
            uint256 balance = balances[msg.sender];
            require(balance > 0, "Insufficient balance!");

            (bool success, ) = payable(msg.sender).call{value: amount}("");
            require(success, "Withdraw Failed");

            balances[msg.sender] = balance - amount;
        }

        function transfer(uint256 amount, address to) external {
            balances[msg.sender] -= amount;
            balances[to] += amount;
        }
}