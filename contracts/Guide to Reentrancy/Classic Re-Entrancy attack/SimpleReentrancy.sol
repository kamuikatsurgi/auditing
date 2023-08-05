// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// 1. Classic Re-Entrancy attack

// Bonus: There is one another vulnerability here if you can find it, try!!

contract Vault {
    error NativeTokenTransferError();

    mapping (address => uint256) public balances;

    function deposit() payable external{
        balances[msg.sender] = msg.value;
    }

    function withdraw() payable external{
        (bool sent, ) = payable(msg.sender).call{value: balances[msg.sender]}("");

        /* 
        So what's happening here is we are interacting with the user's which might be an EOA or a 
        smart contract and calling their receive or fallback function to send ether and in turn 
        giving them the control the execution

        Why this happened? Because the state that is the mapping is updated after the external call and that
        should not be the case.
        */
        if(!sent) revert NativeTokenTransferError();
        delete balances[msg.sender];
    }
}