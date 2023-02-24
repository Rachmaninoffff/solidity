// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Property{
    uint public price;
    address public owner;


    constructor(){
        price = 0;
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(owner == msg.sender);
        _;
        // 避免代码冗余，类似java中的注解
    }

    function changeOwner(address _owner) public onlyOwner{
        owner = _owner;
    }

    function setPrice(uint _price) public onlyOwner{
        price = _price;
    }


    // function changeOwner(address _owner) public{
    //     require(owner == msg.sender);
    //     owner = _owner;
    // }

    // function setPrice(uint _price) public{
    //     require(owner == msg.sender);
    //     price = _price;
    // }

}