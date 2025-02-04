// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AucEngine {
    address public owner;
    uint constant DURATION = 2 days;
    uint constant FEE = 10; // 10%

    struct Auction {
        address payable seller;
        uint startingPrice; 
        uint finalPrice;
        uint startAt;
        uint endAt;
        uint discountRate;
        string item;
        bool stopped;
    }

    Auction[] public auctions;

    event AuctionCreated(uint index,  string itemName, uint startingPrice, uint duration);
    event AuctionEnded(uint index,  uint finalPrice, address winner);


    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Sen owner emassan!");
        _;
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }



    function createAuction(uint _startingPrice, uint _discountRate, string calldata _item, uint _duration) external {
        uint duration = _duration == 0 ? DURATION : _duration; 
        
        require(_startingPrice >= _discountRate * duration, "Incorrect Starting Price");
    
        Auction memory newAuction = Auction({
            seller: payable(msg.sender),
            startingPrice: _startingPrice,
            finalPrice: _startingPrice,
            discountRate: _discountRate, 
            startAt: block.timestamp,
            endAt: block.timestamp + duration, 
            item: _item,
            stopped: false
        });

        auctions.push(newAuction);
    
        emit AuctionCreated(auctions.length - 1, _item, _startingPrice, duration);
    }

    function getPriceFor(uint index) public view returns(uint) {
        Auction memory cAuciton  = auctions[index];
        require(!cAuciton.stopped, "stopped!");
        uint elapsed = block.timestamp - cAuciton.startAt;
        uint discount = cAuciton.discountRate  * elapsed;
        return cAuciton.startingPrice - discount;
    }

    function stop(uint index) external {
        Auction storage cAuction = auctions[index];
        require(msg.sender == cAuction.seller || msg.sender == owner, "Not authorized");
        cAuction.stopped = true;
    }

    function buy(uint index) external payable {
        Auction storage cAuction = auctions[index];

        require(!cAuction.stopped, "stopped!");
        require(block.timestamp < cAuction.endAt, "ended!");

        uint cPrice = getPriceFor(index);

        require(msg.value >= cPrice, "not enough funds");

        cAuction.stopped = true;
        cAuction.finalPrice = cPrice;

        uint refund = msg.value - cPrice;

        if(refund > 0){
            payable(msg.sender).transfer(refund);
        }

        cAuction.seller.transfer(
            cPrice - ((cPrice * FEE) / 100)
        );

        emit AuctionEnded(index, cPrice, msg.sender);
    }
}
