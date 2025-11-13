// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract EventExample {
    mapping(address => uint) public tokenBalance;
    event TokensSale(address sender, address to, uint amount);
    constructor() {
        tokenBalance[msg.sender] = 100;
    }

    function sendToken(address _to, uint _amount) public returns(bool) {
        require(tokenBalance[msg.sender] >= _amount, "Not enough token");
        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_to] += _amount;
        emit TokensSale(msg.sender, _to, _amount);
        return true;
    }
}