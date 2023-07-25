// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @dev Transfer the new tokens to this contract. 
 * The new tokens will stay in this wallet forever unless claimed
 */
contract ERC20Migrator {
    IERC20 public tokenOld;
    IERC20 public tokenNew;

    mapping(address => bool) public migratedAddress;

    event TokensMigrated(address _wallet, uint256 _amount);

    constructor (address _tokenOld, address _tokenNew) {
        tokenOld = IERC20(_tokenOld);
        tokenNew = IERC20(_tokenNew);
    }

    function migrateTokens() public {
        require(migratedAddress[msg.sender] == false, "ERC20Migrator: Tokens already migrated!");
        uint256 _balance = tokenOld.balanceOf(msg.sender);
        require(_balance > 0, "ERC20Migrator: No token balance!");
        migratedAddress[msg.sender] = true;
        tokenNew.transfer(msg.sender, _balance);
        emit TokensMigrated(msg.sender, _balance);
    }
}