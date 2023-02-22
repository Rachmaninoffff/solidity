// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Property{
		int public price;
        string location;
        address public immutable owner;
		
        constructor(string memory _location){
            location = _location;
            owner = msg.sender;
        }


		function getPrice() public view returns(int){
				return price;
		}

        
}
