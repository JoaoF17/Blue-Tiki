// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BlueTiki is ERC20 {
    constructor() ERC20("BlueTiki", "BTIKI") {
        _mint(msg.sender, 30000000 * 10 ** decimals());
    }
}
