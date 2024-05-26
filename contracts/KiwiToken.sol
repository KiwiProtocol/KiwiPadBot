// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract KIWIPADBOT is ERC20, ERC20Burnable {
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address initialOwner
      ) ERC20(name, symbol) {
        _mint(initialOwner, initialSupply * 10 ** decimals());
    }
}
