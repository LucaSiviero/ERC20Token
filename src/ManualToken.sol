// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ManualToken {
    mapping(address owner => uint256 balance) private s_balances;

    function name() public pure returns (string memory) {
        return "Manual Token";
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 _amount) public {
        uint256 previousSenderBalance = balanceOf(msg.sender);
        uint256 previousReceiverBalance = balanceOf(_to);
        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;

        require(balanceOf(msg.sender) == previousSenderBalance - _amount);
        require(balanceOf(_to) == previousReceiverBalance + _amount);
    }
}
