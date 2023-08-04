# Contract Deploy Guide

## Compile

npx hardhat compile

## Deploy

### Deploy ERC20 Token

npx hardhat deployContract --network testnet ERC20Token token

### Verify ERC20 Token

npx hardhat verify --network testnet --constructor-args ./scripts/token.js <CONTRACT_ADDRESS>

### Deploy Staking

npx hardhat deployContract --network testnet Staking staking

### Verify Staking

npx hardhat verify --network testnet <CONTRACT_ADDRESS>
