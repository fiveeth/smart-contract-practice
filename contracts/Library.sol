// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Math {
    function max(uint _x, uint _y) internal pure returns(uint){
        return _x >_y ? _x : _y;
    }
}

contract Test {
    function max(uint _x, uint _y) external pure returns(uint){
        return Math.max(_x, _y);
    }
}

library ArrayLibrary {
    function find(uint[] storage _arr, uint _target) internal view returns(uint) {
        for(uint i=0;i<_arr.length;i++) {
            if(_arr[i] == _target) {
                return i;
            }
        }

        revert("not find!");
    }
}


contract TestArray {
    using ArrayLibrary for uint[];

    uint[] private arr = [1,2,3];

    function find(uint _target) external view returns(uint) {
        // return ArrayLibrary.find(arr, _target);
        return arr.find(_target);
    }
}
