// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

// While minting or trasnfering NFTs smart contract checks if thr receiving smart contract can handle NFTs
// otherwise they will be stuck in the smart contract forever and can never be retrieved
// Here's an example contract:


contract ContractCanReciveNFTs is IERC721Receiver {

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) public override returns(bytes4) {
        return this.onERC721Received.selector ;
    }

    // Wheneever an NFT is minted to this smart contract you can make a reentrancy attack because the 
    // contract call this function and you can have malicious code inside this function

    // You need to only define the above function but it'll be of no use because you can receive the NFTs
    // but can't really do anything with them so u need some extra functions like transfer etc.
}