## Token Swap chainLink - using Foundry for testing

address ETH_USD_FEED = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

address DAI_USD_FEED = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;

address USDAddress = 0xf08A50178dfcDe18524640EA6618a1f965821715;

address DAIAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

address WETHAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

TOKENSWAP Contract = 0x41296f1567D195d2D1130c33a521cadBEbCb4b97

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
