// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.15;

import "test/base/loadkey.t.sol";
import "lib/forge-std/src/console.sol";
import {WETH9} from "src/tokens/WETH9.sol";
import {UniswapV2Factory} from "src/tokens/UniswapV2Factory.sol";
import {UniswapV2Pair} from "src/tokens/UniswapV2Pair.sol";
import {UniswapV2Router02} from "src/tokens/UniswapV2Router.sol";

contract Deploy is LoadKey {

  function setUp() public virtual override {
    super.setUp();
  }

  function run() public {
    WETH9 weth;
    UniswapV2Factory uniswapV2Factory;
    UniswapV2Router02 uniswapV2Router02;

    vm.startBroadcast(privateKey);
    weth = new WETH9();
    uniswapV2Factory = new UniswapV2Factory(eoaAddress);
    uniswapV2Router02 = new UniswapV2Router02(
      address(uniswapV2Factory),
      address(weth)
    );
    vm.stopBroadcast();
  }
}
