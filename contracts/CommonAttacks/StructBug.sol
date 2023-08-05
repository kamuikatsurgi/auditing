// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Main objective here is deleting a struct which has a mapping or another struct inside of it
// doesn't automatically gets deleted.

contract StructBug{

    struct Object {
        mapping (uint256 => uint256) intToint;
    }

    mapping(uint256 => Object) objects;

    function setObject(uint256 x, uint256 y, uint256 z) public {
        objects[x].intToint[y] = z;
    }

    function readObject(uint x, uint y) public view returns(uint){
        return objects[x].intToint[y];
    }

    function deleteObejct(uint x) public {
        delete objects[x];
    }

}