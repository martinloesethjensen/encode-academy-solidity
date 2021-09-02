// SPDX-License-Identifier: UNLICENSED 

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VolcanoCoin is ERC20("Volcano Coin", "VOC"), Ownable {
    constructor() {
        _mint(msg.sender, 10000);
    }

    mapping(address => Payment[]) public payments;
    
    event TotalSupplyIncrease(uint);
    
    struct Payment {
        uint256 transferAmount;
        address _recipient;
    }
    
    function increaseTotalSupplyWith1000() public onlyOwner {
        _mint(msg.sender, 1000);

        emit TotalSupplyIncrease(totalSupply());
    }
    
    function transfer(address _recipient, uint256 _amount) public override returns (bool) {
        _transfer(msg.sender, _recipient, _amount);

        payments[msg.sender].push(Payment(_amount, _recipient));

        return true;
    }
}