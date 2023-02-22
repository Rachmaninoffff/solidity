// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract GlobalVariables{
    uint public this_moment = block.timestamp;
    uint public block_number = block.number;
    uint public difficulty = block.difficulty;
    uint public gaslimit = block.gaslimit;
}