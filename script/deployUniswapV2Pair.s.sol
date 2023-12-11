// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "test/base/loadkey.t.sol";
import {Token} from "src/tokens/ERC20.sol";
import {WETH9} from "src/tokens/WETH9.sol";
import {UniswapV2Factory} from "src/tokens/UniswapV2Factory.sol";
import {UniswapV2Pair} from "src/tokens/UniswapV2Pair.sol";
import {UniswapV2Router02} from "src/tokens/UniswapV2Router.sol";

// Simple Account Wallet
import "lib/forge-std2/src/Test.sol";
import {SimpleAccountFactory, SimpleAccount, IEntryPoint} from "lib/account-abstraction/contracts/samples/SimpleAccountFactory.sol";
import {EntryPoint} from "lib/account-abstraction/contracts/core/EntryPoint.sol";
import {BaseAccount, UserOperation} from "lib/account-abstraction/contracts/core/BaseAccount.sol";
import {ECDSA} from "lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract Deploy is LoadKey {

  function setUp() public virtual override {
    super.setUp();
  }

  function run() public {
    Token token = Token(0x6A4e8C62544A707ea22fd9BdC8B40492a7f0e2aE);
    WETH9 weth = WETH9(0x8F6407ffEA8Db16195318A380dd937De9b635cCF);
    UniswapV2Factory uniswapV2Factory = UniswapV2Factory(0x3D67E72851c9aa61E4fF22ca2c9995D0134fff29);
    bytes memory payload = abi.encodeWithSignature("deposit()");

    vm.startBroadcast(privateKey);
    address(weth).call{value: 0.1 ether}(payload);
    token.mint(address(eoaAddress), 10000_00000000000000000);
    UniswapV2Pair uniswapV2Pair = UniswapV2Pair(uniswapV2Factory.createPair(address(token), address(weth)));
    token.transfer(address(uniswapV2Pair), token.balanceOf(eoaAddress));
    weth.transfer(address(uniswapV2Pair), weth.balanceOf(eoaAddress));
    uniswapV2Pair.sync();
    vm.stopBroadcast();
  }
}


// | Chain            | UniswapV2Factory                           | UniswapV2Router                            | WETH9                                      |
// |------------------|--------------------------------------------|--------------------------------------------|--------------------------------------------|
// | Ethereum Sepolia | 0x52B89Df7ADc921778235c6da397f9Beb6ce1185D | 0xF2a0e4e62f4aA5D041391f8fF345E9157BaB1a8D | 0x09d26696836b7106C1283761c54A11bCeb63FB61 |
// | Polygon Mumbai   | 0x6c4e0B7330B5D2d975Cf74b77f89b5471F2793Be | 0xB50773a800B868dBD0EFE6Dac901c63BEa406AFE | 0x24A6F9C58EC4c3e8C009Ae7E4E07B17Df019a47a |
// | Avalanche Fuji   | 0x6dDD392833eC341da955bE9baC5Ab5aff69AF5d6 | 0x6A4e8C62544A707ea22fd9BdC8B40492a7f0e2aE | 0x9100621e7b609138cC7E07035Ba476b249D42EA3 |
// | Polygon zkEVM    | 0x3D67E72851c9aa61E4fF22ca2c9995D0134fff29 | 0x9394142Baf05e400BAA14254098Bb334b80CCBDA | 0x8F6407ffEA8Db16195318A380dd937De9b635cCF |

// | Chain            | Drip Faucet                                | USDT                                       | Token                                      |
// |------------------|--------------------------------------------|--------------------------------------------|--------------------------------------------|
// | Ethereum Sepolia | 0xa651484C43383f27ad98647ef434769796cC0Bc6 | 0x1448a1620170b28c561c41A7FAe5BEea71EFc7B9 | 0x50aB7C2597422ecc7083536dE93c5459E315CaC2 |
// | Polygon Mumbai   | 0xbD829426BF1c8A09C35F7d402D7a92894d22DC2F | 0xEF4Ca181511EF094cb6e14439cf33868aed1875B | 0xaCB3bc70A807fa1F5f36c80C7C2c0402d9341D5B |
// | Avalanche Fuji   | 0x199A199B680E61980d3DFB0c6D46754CF23Efb6f | 0x2FC38Afad493dB7a3049f0B8CB1a7d538C67f286 | 0x416e604EB518F126898a2f25e55A9Dd2E373B9C4 |
// | Polygon zkEVM    | 0x9100621e7b609138cC7E07035Ba476b249D42EA3 | 0x6dDD392833eC341da955bE9baC5Ab5aff69AF5d6 | 0x6A4e8C62544A707ea22fd9BdC8B40492a7f0e2aE |