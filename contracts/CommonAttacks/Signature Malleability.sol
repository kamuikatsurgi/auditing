// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract  signatureMalleable is Ownable {

    address token;
    mapping (bytes32 => bool) executed;

    function signedTransfer(
        address to,
        uint256 amount,
        uint8 v,
        bytes32 r,
        bytes32 s
    )  external {

        bytes32 msgHash = keccak256(abi.encode(msg.sender, to, amount));

        address signer = ecrecover(msgHash, v, r, s);
        /* 
        r value is the randomly generated temporary public key's(just for the sake of that transaction) 
        X co-ordinate and then s value can be found from it formula using r value
        v value is just that the signing becomes more smooth 
        and we don't actually need it for verifying the transaction

        From one r and s value we can generate another r and s value because the cryptography curve
        has two valid signature for one X co-ordinate(r) so attacker can use that on behalf of the user
        */

        require(signer == owner());

        bytes32 sigHash= keccak256(abi.encode(msgHash, v, r, s));

        require(!executed[sigHash]);
        executed[sigHash] = true;

        IERC20(token).transfer(to, amount);
        
    }
}