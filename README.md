# Foundry Base Repository

This repository provides a complete development environment for building and testing Solidity smart contracts using Foundry within a VSCode DevContainer setup.

## Purpose 

The setup includes OpenZeppelin V5 contracts and upgradeable contracts, allowing developers to easily create, deploy, and test upgradeable smart contracts. 

The repository features a pre-configured dev container setup to ensuring consistency across environments. 
A sample upgradeable ERC20 contract and corresponding test cases are included to serve as a blueprint on how to use the setup.

## Sample Contracts 

The repository provides two sample Solidity smart contracts in subfolder `src`.

- **Counter**: A very simple smart contract
- **Token**: An upgradeable token contract using OpenZeppelin V5

Corresponding tests are located in subfolder `test`.

## Preparation

To use this repository the following software is required:

- Git
- Docker
- VSCode

## Initial Setup

1. Clone repository into directory of your choice
1. Open VSCode in this directory
1. Run Devcontainer setup


### Git Submodules Checkout

The project makes use of Git submodules for dependencies.
After cloning the repository also checkout the submodules using the command shown below. 

```shell
git submodule update --init --recursive
```

To update the submodules, use the following command.

```shell
git submodule update --recursive
```

## Using Foundry

### Forge Format

Formats Solidity files to common standard.
The command `forge fmt --check` should not show any errors before pushing to Github.

```shell
$ forge fmt
$ forge fmt --check
```

### Forge Build

```shell
$ forge build
$ forge build --sizes
```

### Forge Test

Runs tests. 
The command `forge test` should not show any errors before pushing to Github.

```shell
$ forge test
$ forge test --mt test_Token
$ forge test --gas-report
$ forge coverage
```
