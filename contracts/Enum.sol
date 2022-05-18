// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Enum {
    enum Status {
        NONE,
        PENDING,
        FINISH
    }

    Status public status;

    function set(Status _status) external {
        status = _status;
    }

    function get() external view returns(Status) {
        return status;
    }

    function setFinish() external {
        status = Status.FINISH;
    }

    function reset() external {
        delete status;
    }
}