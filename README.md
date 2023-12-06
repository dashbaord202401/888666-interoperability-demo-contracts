### Possible Testnets

| Company   | Testnet            | ChainId   | RPC                                      | Explorer                                  | Currency | Faucet |
|-----------|--------------------|-----------|------------------------------------------|-------------------------------------------|----------|--------|
| Polygon   | Mumbai             | 80001     | https://sepolia-rpc.scroll.io/           | https://rpc.ankr.com/polygon_mumbai       | MATIC    |        |
| Ethereum  | Sepolia            | 11155111  | https://sepolia-rpc.scroll.io/           | https://rpc.ankr.com/eth_sepolia          | ETH      |        |
| Gnosis    | Chiado             | 10200     | https://rpc.chiadochain.net              | https://blockscout.com/gnosis/chiado      | XDAI     |        |
| Chiliz    | Spicy Testnet      | 88882     | https://spicy-rpc.chiliz.com/            | http://spicy-explorer.chiliz.com/         | CHZ      |        |
| Base      | Base Goerli        | 84531     | https://goerli.base.org                  |                                           | ETH      |        |
| Celestia  | Bubs Testnet       | 1582      | https://bubs.calderachain.xyz/http       |                                           | GETH     |        |
| XDC       | Apothem            | 51        | https://erpc.apothem.network             |                                           | TXDC     |        |
| Celo      | Alfajores          | 44787     | https://alfajores-forno.celo-testnet.org | https://explorer.celo.org/alfajores       | A-CELO   |        |
| Mantle    | Mantle Testnet     | 5001      | https://rpc.testnet.mantle.xyz           | https://explorer.testnet.mantle.xyz/      | MNT      |        |
| Neon EVM  | Neon EVM Testnet   | 245022940 | https://testnet.neonevm.org              | https://devnet.explorer.neon-labs.org     | NEON     |        |
| Polygon   | Polygon ZKGoreli   | 1442      | https://rpc.public.zkevm-test.net        | https://testnet-zkevm.polygonscan.com     | MATIC    |        |
| Scroll    | Scroll Sepolia     | 534351    | https://sepolia-rpc.scroll.io/           | https://sepolia-blockscout.scroll.io/     | ETH      |        |
| Arbitrum  | Arbitrum Sepolia   | 421614    | https://sepolia-rollup.arbitrum.io/rpc   | https://sepolia.arbiscan.io               | ETH      |        |

### TODO:

- [x] setup repo
- [x] include last paymaster and escrow contracts
- [x] create todo
- [x] import supporting files
- [x] create simple tokens with drip function
- [x] create drip contract 1271 
- [x] script test tokens
- [x] script test drip
- [x] deploy tokens
- [x] deploy drip
- [x] uniswapv2 contracts
- [x] uniswapv2 script
- [x] revise paymaster, for now paymaster paying is okay -> needs to be changed to bundler
- [x] revise escrow (just double check it works)
- [ ] script uniswapv2 tx via etched validator
- [ ] make paymaster upgradeable
- [ ] make escrow upgradeable
- [ ] make faucet upgradeable
- [x] deploy paymaster and escrow
- [x] deploy uniswapv2
- [ ] create Token and USDT pairs
- [ ] fund Token and USDT tokens
- [ ] deploy uniswapv3
- [ ] deploy uniswapv4
- [ ] script to test uniswapv3
- [ ] script to test uniswapv4
- [ ] script to test gearbox
- [ ] add verify view function to drip
- [ ] cleanup new paymaster/escrow (unused variables)
- [ ] add 1271 to token escrow
- [ ] add deployment costs to readme

### Faucets

| Chain           | Drip Faucet                                | USDT                                       | Token                                      |
|-----------------|--------------------------------------------|--------------------------------------------|--------------------------------------------|
| Ethereum Sepolia| 0xa651484C43383f27ad98647ef434769796cC0Bc6 | 0x1448a1620170b28c561c41A7FAe5BEea71EFc7B9 | 0x50aB7C2597422ecc7083536dE93c5459E315CaC2 |
| Polygon Mumbai  | 0xbD829426BF1c8A09C35F7d402D7a92894d22DC2F | 0xEF4Ca181511EF094cb6e14439cf33868aed1875B | 0xaCB3bc70A807fa1F5f36c80C7C2c0402d9341D5B |


| Chain            | UniswapV2Factory                           | UniswapV2Router                            | WETH9                                      |
|------------------|--------------------------------------------|--------------------------------------------|--------------------------------------------|
| Ethereum Sepolia | 0x52B89Df7ADc921778235c6da397f9Beb6ce1185D | 0xF2a0e4e62f4aA5D041391f8fF345E9157BaB1a8D | 0x09d26696836b7106C1283761c54A11bCeb63FB61 |
| Polygon Mumbai   | 0x6c4e0B7330B5D2d975Cf74b77f89b5471F2793Be | 0xB50773a800B868dBD0EFE6Dac901c63BEa406AFE | 0x24A6F9C58EC4c3e8C009Ae7E4E07B17Df019a47a |


| Chain            | EntryPoint                                 | SimpleAccountFactory                       | Singleton                                  |
|------------------|--------------------------------------------|--------------------------------------------|--------------------------------------------|
| Ethereum Sepolia | 0xA01F675b2839e4104ca5deAb898e49fFa4a8f7d3 | 0x8d123E05cc7d2Eb0d411Ef727160E726F73Da3D2 | 0x321F7bD506D273C9b37E1535aF2BE1787d2cdCE1 |
| Polygon Mumbai   | 0x8F82ece0Ee8242Ca9AC4Af8963cd5238E13eFa37 | 0xe7BA114ca47Fb69C253001554966A0a7B24bd4f0 | 0x01A6EfaaceC3CCF42d5D3496f55DC06C91A910ff |



| Chain            | Escrow                                 | Paymaster                              |
|------------------|----------------------------------------|----------------------------------------|
| Ethereum Sepolia | 0x4A3B53985D7993A09eD6144F456720153bF1fD40 | 0x7d4a0b3170BEa5B22A2A142DE0A67a3d92d0EB7D |
| Polygon Mumbai   | 0x1A838bD66C52B1cFAF226727B262B84c6dA34011 | 0x977475D91CAD19f0980fE58bA7EC27E20fE8f451 |
