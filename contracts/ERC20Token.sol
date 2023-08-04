// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Token is Ownable, ERC20Burnable, Pausable {
    constructor(string memory name, string memory symbol) ERC20(name, symbol){
        _mint(msg.sender, 10000000 * 10 ** decimals());
    }

    function mint(uint256 amount) public onlyOwner whenNotPaused {
        _mint(_msgSender(), amount);
    }

    function burn(uint256 value) public override onlyOwner whenNotPaused {
        _burn(_msgSender(), value);
    }

    function _update(address from, address to, uint256 value) internal virtual whenNotPaused {
        _update(from, to, value);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function transfer(address to, uint256 amount) public virtual whenNotPaused override returns (bool) {
        return super.transfer(to, amount);
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}