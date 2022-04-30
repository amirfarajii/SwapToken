// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "../lib/SafeMath.sol";
interface IERC20{
    function totalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns(uint256);
    function transfer(address recipient, uint256 amount) external returns(bool);
    function allowance(address owner, address spender) external view returns(uint256);
    function approve(address spender, uint256 amount) external returns(bool);
    function transferFrom(address spender, address recipient, uint256 amount) external returns(bool);
    event Transfer(address from, address to, uint256 value);
    event Approval(address owner, address spender, uint256 value);
}


contract TokenSwap{
    using SafeMath for uint;
    //state variables
    IERC20 public token1;
    IERC20 public token2;
    address private owner;
    uint8 public rate = 100;

    modifier onlyOwner{
        require(owner == msg.sender, "Just Owner of contract call this function");
        _;
    }
    event SwapToken(address sender, uint amount);

    //when deploying pass in owner1 and owner 2

    constructor(address _token1, address _token2){
        owner = msg.sender;
        //BUSD token
        token1 =IERC20(_token1);
        //token for owner
        token2=IERC20(_token2);
      
        
    }

    //*** Important ***
    //this contract needs an allowance to send tokens at token 1 and token 2 that is owned 
    
    function swap(uint amount) public{
        //stable token
        require(token1.balanceOf(msg.sender) >= amount, "not enough token");
        if(token1.allowance(msg.sender, address(this)) < amount){
            token1.approve(address(this), amount);
        }
        require(token1.allowance(msg.sender, address(this)) >= amount, "Token 1 allowance too low");
        uint amountRate = rate * amount;
        require(token2.allowance(owner, address(this)) >= amountRate, "Token 2 allowance too low");
        address receiver_of_token = msg.sender;
        //transfer TokenSwap
        //token1, owner1, amount 1 --> owner2. needs to be in same order as function
        _safeTransferFrom(token1, receiver_of_token, owner, amount);
        _safeTransferFrom(token2, owner, receiver_of_token, amountRate);
        emit SwapToken(msg.sender, amount);
    }
    
    function _safeTransferFrom(IERC20 token, address sender, address recipient, uint amount) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
    function setRate(uint8 _rate) onlyOwner public{
        rate = _rate;
    }
    function viewRate() public view returns(uint8){
        return rate;
    }




}