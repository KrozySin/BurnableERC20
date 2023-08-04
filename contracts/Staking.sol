// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract Staking is Ownable, UUPSUpgradeable {

    // ERC20 standard

    struct StakingAccount {
        uint256 amount;
        uint256 stakedBlock;
    }

    mapping(address => StakingAccount) _stakingList;
    address _tokenAddress;
    uint256 _percentagePerBlock = 1;

    bool public dynamicStaking = true;

    // Staking functions

    function stakingReward(address account) public view returns(uint256) {
        uint256 compoundedValue = block.number - _stakingList[account].stakedBlock;
        compoundedValue = compoundedValue * (compoundedValue - 1) / 2;
        compoundedValue = compoundedValue * _percentagePerBlock;

        return _stakingList[account].amount * compoundedValue / 1000;
    }

    function updateStakeList(uint256 amount) private {
        if (_stakingList[msg.sender].stakedBlock != 0) {
            if (dynamicStaking == true) {
                _stakingList[msg.sender].amount += amount;
                _stakingList[msg.sender].stakedBlock = block.number;
            } else {
                uint256 _reward = stakingReward(msg.sender);

                _stakingList[msg.sender].amount += _reward;
                _stakingList[msg.sender].amount += amount;
            }
        } else {
            _stakingList[msg.sender].amount = amount;
        }
        _stakingList[msg.sender].stakedBlock = block.number;
    }

    function stake(uint256 amount) public {
        ERC20 erc20 = ERC20(_tokenAddress);

        require(erc20.balanceOf(msg.sender) >= amount, "The Account balance is not enough");
        require(erc20.allowance(msg.sender, address(this)) >= amount, "The staking balance is not approved");

        erc20.transferFrom(msg.sender, address(this), amount);

        updateStakeList(amount);
    }

    function unstake() public {
        uint256 _stakingReward = stakingReward(msg.sender);
        ERC20 erc20 = ERC20(_tokenAddress);

        erc20.transferFrom(address(this), msg.sender, _stakingList[msg.sender].amount + _stakingReward);
        
        _stakingList[msg.sender].amount = 0;
        _stakingList[msg.sender].stakedBlock = block.number;
    }

    // Dynamic/Static staking

    function setDynamicStaking() public onlyOwner {
        require(dynamicStaking != true);

        dynamicStaking = true;
    }

    // Autocompound

    bool public autocompound = false;

    function setAutocompound() public onlyOwner {
        require(dynamicStaking != false);

        dynamicStaking = false;
    }

    // Upgradeable

    function _authorizeUpgrade(address) internal override onlyOwner {}

    // Depositable

    function deposit(uint256 amount) public onlyOwner {
        ERC20 erc20 = ERC20(_tokenAddress);

        require(erc20.balanceOf(msg.sender) >= amount, "The Account balance is not enough");
        
        erc20.transferFrom(msg.sender, address(this), amount);
    }
}