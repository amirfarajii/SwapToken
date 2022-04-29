// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.9.0;
import "../lib/SafeMath.sol";
contract Timelock{
    using SafeMath for uint;
    mapping(address => uint256) public balance;
    mapping(address => uint) public lockTime;

    function deposit() public payable{
        balance[msg.sender]+=msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }


    function withdraw() public {
        require(balance[msg.sender] > 0, "Insufficient funds");
        require(block.timestamp > lockTime[msg.sender], "Lock time has not expired");
        uint amount = balance[msg.sender];
        balance[msg.sender] = 0;
        (bool sent,) = msg.sender.call{value:amount}("");
        require(sent, "Failed to send ethers");
        }
     

}