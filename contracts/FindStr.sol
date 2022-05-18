// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FindStr {

    // 查找source中是否包含target
    // source: "BBAA", target: "AA"
    // sourceBytes.length - targetBytes.length = 2
    // 第一次循环：i=0 j=0 => sourceBytes[0]="B", targetBytes[0]="A" => 跳出内层循环，flag=false
    // 第二次循环：i=1 j=0 => sourceBytes[1]="B", targetBytes[0]="A" => 跳出内层循环，flag=false
    // 第三次循环：i=2 j=0 => sourceBytes[2]="A", targetBytes[0]="A"
    // 第三次循环：i=2 j=1 => sourceBytes[3]="A", targetBytes[1]="A"
    function containWord (string memory source, string memory target) public pure returns(bool) {
        bytes memory sourceBytes = bytes (source);
        bytes memory targetBytes = bytes (target);

        require(sourceBytes.length >= targetBytes.length);

        bool found = false;
        for (uint i = 0; i <= sourceBytes.length - targetBytes.length; i++) {
            bool flag = true;
            for (uint j = 0; j < targetBytes.length; j++) {
                if (sourceBytes [i + j] != targetBytes [j]) {
                    flag = false;
                    break;
                }
            }

            if (flag) {
                found = true;
                break;
            }
        }

        return found;
    }
}