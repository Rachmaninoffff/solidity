// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract AuctionCreator{
    Auction[] public auctions;

    function createAuction() public{
        Auction newAuction = new Auction(msg.sender);
        auctions.push(newAuction);
    }
}

contract Auction{
    address payable public owner;
    uint public startBlock;
    uint public endBlock;

    string public ipfsHash;

    enum State{Started, Running, Ended, Canceled}
    State public auctionState;

    uint public highestBindingBid;
    address payable public highestBidder;

    mapping(address => uint) public bids;

    uint bidIncrement;

    constructor(address eoa){
        owner = payable(eoa);
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = startBlock + 40320;
        ipfsHash = "";
        bidIncrement = 100;

    }

    modifier onlyOwner(){
        require(msg.sender == owner, "must be the owner");
        _;
    }

    modifier notOwner(){
        require(msg.sender != owner, "must not be the owner");
        _;
    }

    modifier afterStart(){
        require(block.number >= startBlock, "must be start");
        _;
    }

    modifier beforeEnd(){
        require(block.number <= endBlock, "must be start");
        _;
    }

    modifier running(){
        require(auctionState == State.Running,"must be running");
        _;
    }

    function min(uint a, uint b) pure internal returns(uint){
        if(a <= b){
            return a;
        }else{
            return b;
        }
    }

    function cancelAuction() public onlyOwner{
        auctionState = State.Canceled;
    }

    function placeBid() public payable notOwner afterStart beforeEnd running{
        require(msg.value >= 100);
        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestBindingBid);
        bids[msg.sender] = currentBid;

        if(currentBid <= bids[highestBidder]){
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        }else{
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        }
    }

    function finalizeAuction() public{
        require(auctionState == State.Canceled || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0);

        address payable recipient;
        uint value;
        if(auctionState == State.Canceled){
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        }else{ //auction ended(not canceled)
            if(msg.sender == owner){
                recipient = owner;
                value = highestBindingBid;
            }else{ // this is a bidder
                if(msg.sender == highestBidder){
                    value = bids[highestBidder] - highestBindingBid;
                    recipient = highestBidder;
                }else{// neither owner or highest
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }
        bids[recipient] = 0;
        recipient.transfer(value);
    }

}