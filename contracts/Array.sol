// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Array {

    uint[] public nums = [1,2,3];
    uint[3] public numsFixed = [1,2,3];

    function arrayControl(uint _num) public {
        // 只有非定长数组才有这个push方法
        nums.push(_num);
        // update
        // nums[0] = 0;
        // delete: 只是删除数组元素，但是没有更改数组的长度，只是将值置为默认值
        // delete nums[2];  
        // pop: 删除最后一个元素
        // nums.pop();
    }

    function readAllArray() public view returns(uint[] memory) {
        return nums;
    }

    // 通过移动位置进而变相实现删除数组中元素的方法
    // function remove(uint _index) public {
    //     require(_index < nums.length, "out of bound!");
    //     for(uint i=_index;i<nums.length-1;i++) {
    //         nums[i] = nums[i+1];
    //     }

    //     nums.pop();
    // }

    function remove(uint _index) public {
        require(_index < nums.length, "out of bound!");
        nums[_index] = nums[nums.length-1];
        nums.pop();
    }
}