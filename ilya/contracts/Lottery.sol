// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Lottery {
    address public manager;
    address payable[] public players;
    address payable public winner;
    uint constant public FEE = 15;
    constructor(){
        manager = msg.sender;
    }

    function participiate() public payable {
        require(msg.value == 1 ether, "Please pay 1ether only");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) { 
        require(manager == msg.sender, "You are not the manager"); 
        return address(this).balance;
    }

    function random() public  view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function findWinner() public{
      require(manager == msg.sender, "You are not the manager");
      require(players.length >= 3, "Players are less then 3");

      uint r = random();
      uint index = r % players.length;
      winner = players[index];
      uint commision = (getBalance() * FEE) / 100;
      winner.transfer(address(this).balance - commision);
    }
}