// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.15;

import "test/base/loadkey.t.sol";
import "lib/forge-std/src/console.sol";
import {DripFaucet} from "src/tokens/drip_faucet.sol";
import {Token} from "src/tokens/ERC20.sol";

contract Deploy is LoadKey {
  // using UserOperationLib for UserOperation;

  function setUp() public virtual override {
    super.setUp();
  }

  function run() public {
    DripFaucet _dripFaucet;
    address _dripFaucetAddress;
    Token _tokenFaucet;
    address _tokenFaucetAddress;
    Token _tokenFaucet2;
    address _tokenFaucetAddress2;

    address FAUCET_RELAY = 0xaeD6b252635DcEF5Ba85dE52173FF040a18CEC6a;

    vm.startBroadcast(privateKey);
    _dripFaucet = new DripFaucet();
    _dripFaucetAddress = address(_dripFaucet);

    _tokenFaucet = new Token("Tether", "USDT");
    _tokenFaucetAddress = address(_tokenFaucet);

    _tokenFaucet = new Token("Token", "TKN");
    _tokenFaucetAddress = address(_tokenFaucet);

    _dripFaucet.setAuthorized(FAUCET_RELAY, true);
    _dripFaucet.setDrip(0.5 ether);
    _dripFaucet.setTimelock(3600);
    vm.stopBroadcast();
  }
}
