// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender;
    } 

    receive() external payable{
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));
    
    }
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }
    function any() public view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function winnerSelection() public{
        
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint a = any();
        address payable winner;
        uint index = a % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}