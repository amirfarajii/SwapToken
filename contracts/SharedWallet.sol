// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract SharedWallet{
    address private _Owner;
    mapping(address => uint8) private _Owners;
    
    //modifier
    modifier isOwner{
        require(msg.sender == _Owner);
        _;
    }
    modifier validOwner{
        require(msg.sender  == _Owner || _Owners[msg.sender]  == 1);
        _;
    }

    event DepositFounds(address from , uint amount);
    event WithdrawFounds(address from, uint amount);
    event TransferFounds(address from, address to, uint amount);
    
    constructor(){
        _Owner = msg.sender;
    }

    function addOwner(address Owner) isOwner public{
        _Owners[Owner] = 1;
    }
    function removeOwner(address Owner) isOwner public{
        _Owners[Owner] = 0;
    }
    //every one can send ETH to contract
 


    function withdraw(uint amount) validOwner public{
        address payable address_msg_sender = payable(msg.sender);
        require(address(this).balance >= amount, "not enough ETH");
        address_msg_sender.transfer(amount);
        emit WithdrawFounds(address_msg_sender, amount);
    }

    function transferFrom(address to,uint amount) validOwner public{
        address payable addressTo = payable(to);
        require(address(this).balance >= amount, "not enough ETH");
        addressTo.transfer(amount);
        emit TransferFounds(addressTo, to , amount);
    } 
}