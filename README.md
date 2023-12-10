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

| Chain            | Drip Faucet                                | USDT                                       | Token                                      |
|------------------|--------------------------------------------|--------------------------------------------|--------------------------------------------|
| Ethereum Sepolia | 0xa651484C43383f27ad98647ef434769796cC0Bc6 | 0x1448a1620170b28c561c41A7FAe5BEea71EFc7B9 | 0x50aB7C2597422ecc7083536dE93c5459E315CaC2 |
| Polygon Mumbai   | 0xbD829426BF1c8A09C35F7d402D7a92894d22DC2F | 0xEF4Ca181511EF094cb6e14439cf33868aed1875B | 0xaCB3bc70A807fa1F5f36c80C7C2c0402d9341D5B |
| Avalanche Fuji   | 0x199A199B680E61980d3DFB0c6D46754CF23Efb6f | 0x2FC38Afad493dB7a3049f0B8CB1a7d538C67f286 | 0x416e604EB518F126898a2f25e55A9Dd2E373B9C4 |
| Polygon zkEVM    | 0x9100621e7b609138cC7E07035Ba476b249D42EA3 | 0x6dDD392833eC341da955bE9baC5Ab5aff69AF5d6 | 0x6A4e8C62544A707ea22fd9BdC8B40492a7f0e2aE


| Chain            | UniswapV2Factory                           | UniswapV2Router                            | WETH9                                      |
|------------------|--------------------------------------------|--------------------------------------------|--------------------------------------------|
| Ethereum Sepolia | 0x52B89Df7ADc921778235c6da397f9Beb6ce1185D | 0xF2a0e4e62f4aA5D041391f8fF345E9157BaB1a8D | 0x09d26696836b7106C1283761c54A11bCeb63FB61 |
| Polygon Mumbai   | 0x6c4e0B7330B5D2d975Cf74b77f89b5471F2793Be | 0xB50773a800B868dBD0EFE6Dac901c63BEa406AFE | 0x24A6F9C58EC4c3e8C009Ae7E4E07B17Df019a47a |
| Avalanche Fuji   | 0x6dDD392833eC341da955bE9baC5Ab5aff69AF5d6 | 0x6A4e8C62544A707ea22fd9BdC8B40492a7f0e2aE | 0x9100621e7b609138cC7E07035Ba476b249D42EA3 |
| Polygon zkEVM    | 0x3D67E72851c9aa61E4fF22ca2c9995D0134fff29 | 0x9394142Baf05e400BAA14254098Bb334b80CCBDA | 0x8F6407ffEA8Db16195318A380dd937De9b635cCF |


| Chain            | EntryPoint                                 | SimpleAccountFactory                       | Singleton                                  |
|------------------|--------------------------------------------|--------------------------------------------|--------------------------------------------|
| Ethereum Sepolia | 0xA01F675b2839e4104ca5deAb898e49fFa4a8f7d3 | 0x8d123E05cc7d2Eb0d411Ef727160E726F73Da3D2 | 0x321F7bD506D273C9b37E1535aF2BE1787d2cdCE1 |
| Polygon Mumbai   | 0x8F82ece0Ee8242Ca9AC4Af8963cd5238E13eFa37 | 0xe7BA114ca47Fb69C253001554966A0a7B24bd4f0 | 0x01A6EfaaceC3CCF42d5D3496f55DC06C91A910ff |
| Avalanche Fuji   | 0x453F47921f489117EFF6E10BF0BB68176506ebfe | 0x09F556A6E41268E57b2dFD6a47d611D9Ad6bD0E2 | 0x529544B675825c930C6Ee2DffE4C8602A8c4Cf9c |
| Polygon zkEVM    | 0x1c1beCCf0333CAf36ed2c2f5611FC3e074917A60 | 0xc0a145D0b7e6B5b183C11470eD9e2f7c9C6699da |  |


| Chain            | Escrow                                     | Paymaster                                  |
|------------------|--------------------------------------------|--------------------------------------------|
| Ethereum Sepolia | 0x4A3B53985D7993A09eD6144F456720153bF1fD40 | 0x7d4a0b3170BEa5B22A2A142DE0A67a3d92d0EB7D |
| Polygon Mumbai   | 0x1A838bD66C52B1cFAF226727B262B84c6dA34011 | 0x977475D91CAD19f0980fE58bA7EC27E20fE8f451 |
| Avalanche Fuji   | 0x8F6407ffEA8Db16195318A380dd937De9b635cCF | 0xc19bB1790DfA227827815048E6BE8Fb7Fe0A30FC |
| Polygon zkEVM    | 0x5E67598e7221C81a30346C3cC4762eE8C49E2cD1 | 0xd097C581f2249eDB705CF5B3b0E55b8A4aa7fcA1 |


| Chain                    | Domain   | Mailbox Address                            | IGS Address                                | Storage Gas Address                        | Merkle Tree Address                        |
|--------------------------|----------|--------------------------------------------|--------------------------------------------|--------------------------------------------|--------------------------------------------|
| Base Goerli              | 84531    | 0x58483b754Abb1E8947BE63d6b95DF75b8249543A | 0x28B02B97a850872C4D33C3E024fab6499ad96564 | 0x267B6B6eAf6790faE5D5E9070F28a9cE64CbF279 | 0x5821f3B6eE05F3dC62b43B74AB1C8F8E6904b1C8 |
| Arbitrumg Goerli         | 421613   | 0x13dABc0351407d5aAa0A50003a166A73b4febfDc | 0x76189acFA212298d7022624a4633411eE0d2f26F | 0xFc8229ADB46D96056A6e451Fb3c55d60FFeD056f | 0xf0A38e1eEA49dAc7968F470c3aA0BDE2565A5d80 |
| Optimism Goerli          | 420      | 0xB5f021728Ea6223E3948Db2da61d612307945eA2 | 0x02A7661273528EfF3d78CBE7CbD1a717b28B89fC | 0x4927C33299091033D935C15DE6b6073164e99BE0 | 0xFEe074B31B5B259eB3109737bE13D39B853b47b9 |
| Scroll Sepolia           | 534351   | 0x3C5154a193D6e2955650f9305c8d80c18C814A68 | 0x86fb9F1c124fB20ff130C41a79a432F770f67AFD | 0x6b1bb4ce664Bb4164AEB4d3D2E7DE7450DD8084C | 0x863E8c26621c52ACa1849C53500606e73BA272F0 |
| Celo Alfajores           | 44787    | 0xEf9F292fcEBC3848bF4bB92a96a04F9ECBb78E59 | 0x44769b0f4a6f01339e131a691cc2eebbb519d297 | 0x8356113754C7aCa297Db3089b89F87CC125499fb | 0x221FA9CBaFcd6c1C3d206571Cf4427703e023FFa |
| Polygon zkEVM Testnet    | 1442     | 0x598facE78a4302f11E3de0bee1894Da0b2Cb71F8 | 0xAD34A66Bf6dB18E858F6B686557075568c6E031C | 0x3707bc8C7342aA6f693bCe1Bd7671Fca146F7F0A | 0x68311418D79fE8d96599384ED767d225635d88a8 |
| Ethereum Sepolia         | 11155111 | 0xfFAEF09B3cd11D9b20d1a19bECca54EEC2884766 | 0x6f2756380FD49228ae25Aa7F2817993cB74Ecc56 | 0x71775B071F77F1ce52Ece810ce084451a3045FFe | 0x4917a9746A7B6E0A57159cCb7F5a6744247f2d0d |
| Avalanche Fuji           | 43113    | 0x5b6CFf85442B851A8e6eaBd2A4E4507B5135B3B0 | 0x6895d3916B94b386fAA6ec9276756e16dAe7480E | 0x9305dE34306886d615B096Bdf23b94a978f6a6c0 | 0x9ff6ac3dAf63103620BBf76136eA1AFf43c2F612 |
| BSC Testnet              | 97       | 0xF9F6F5646F478d5ab4e20B0F910C92F1CCC9Cc6D | 0x0dD20e410bdB95404f71c5a4e7Fa67B892A5f949 | 0x124EBCBC018A5D4Efe639f02ED86f95cdC3f6498 | 0xc6cbF39A747f5E28d1bDc8D9dfDAb2960Abd5A8f |
| Ethereum Goerli          | 5        | 0x49cfd6Ef774AcAb14814D699e3F7eE36Fdfba932 | 0x0cD26594ea6c6526927C0F5225AC09F6288e7140 | 0xeC34c715ee6d050b2172E8aF650Db779561266C1 | 0x28c294C61D3dE053462d2Cfa5d5f8c8D70605A59 |
| Moonbase Alpha           | 1287     | 0x76189acFA212298d7022624a4633411eE0d2f26F | 0x07543860AE9E72aBcF2Bae9827b23621A64Fa416 | 0x62fA20dE68Dbe425f0bc474b12235a4F8449E608 | 0x155B1CD2f7Cbc58d403B9BE341FaB6CD77425175 |
| Polygon Mumbai           | 80001    | 0x2d1889fe5B092CD988972261434F7E5f26041115 | 0x99303EFF09332cDd93E8BC8b2F07b2416e4501e5 | 0xBEd8Fd6d5c6cBd878479C25f4725C7c842a43821 | 0x9AF85731EDd41E2E50F81Ef8a0A69D2fB836EDf9 |
