// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// The idea behind delegate call is to use code from different smart contracts inside your own smart contract
// and use its local storage 


contract TestDelegateCall{

    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) external payable {
        num = 2 * _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract DelegateCall {

    uint256 public num;
    address public sender;
    uint256 public value;

    function setVariables(address test, uint256 _num) external payable {
        // Delegatecall function is always used on a address type only

        /* 
        test.delegatecall(
            abi.encodeWithSignature("setVar(uint256)", _num)
            );
        Used when you know the signature of a function on a smart contract 
        */

        (bool success, bytes memory data) = test.delegatecall(
            abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num)
            );

        require(success, "Delegate call successfull!");
    }
}