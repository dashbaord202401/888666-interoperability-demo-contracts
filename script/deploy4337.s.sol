// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.15;

import "test/base/loadkey.t.sol";
import "lib/forge-std/src/console.sol";
import {EntryPoint} from "lib/account-abstraction/contracts/core/EntryPoint.sol";
import {IEntryPoint, SimpleAccountFactory} from "lib/account-abstraction/contracts/samples/SimpleAccountFactory.sol";

contract Deploy is LoadKey {

  function setUp() public virtual override {
    super.setUp();
  }

  function run() public {
    EntryPoint entryPoint;
    SimpleAccountFactory simpleAccountFactory;

    vm.startBroadcast(privateKey);
    entryPoint = new EntryPoint();
    simpleAccountFactory = new SimpleAccountFactory(IEntryPoint(entryPoint));
    vm.stopBroadcast();
  }
}
