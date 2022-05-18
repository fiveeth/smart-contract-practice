// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Structs {

    struct Car {
        uint year;
        string model;
        address owner;
    }

    Car[] public cars;

    function examples() public{
        Car memory BYD = Car(2010, "BYD", msg.sender);

        cars.push(BYD);

        Car storage car = cars[0];
        car.year = 2020;

        delete cars[0];
    }

    function getLength() public view returns(uint){
        return cars.length;
    }
}