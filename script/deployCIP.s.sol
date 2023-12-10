// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.15;

import "test/base/loadkey.t.sol";
import "lib/forge-std2/src/console.sol";
import {IEntryPoint} from "lib/account-abstraction/contracts/samples/SimpleAccountFactory.sol";
import {CIPPaymaster} from "src/CIPPaymaster.sol";
import {CIPEscrow} from "src/CIPEscrow.sol";

contract Deploy is LoadKey {
  function setUp() public virtual override {
    super.setUp();
  }

  function run() public {
    //address _entryPointAddress = 0xA01F675b2839e4104ca5deAb898e49fFa4a8f7d3; // sepolia
    address _entryPointAddress = 0x8F82ece0Ee8242Ca9AC4Af8963cd5238E13eFa37; // mumbai
    //address _hyperlaneMailboxAddress = 0xfFAEF09B3cd11D9b20d1a19bECca54EEC2884766; // sepolia
    address _hyperlaneMailboxAddress = 0x2d1889fe5B092CD988972261434F7E5f26041115; // mumbai
    //address _hyperlaneIGPAddress = 0x6f2756380FD49228ae25Aa7F2817993cB74Ecc56; // sepolia
    address _hyperlaneIGPAddress = 0x8aB67CAF605c6ee83cbFeFb0D8d67FDd3BF7B591; // mumbai

    CIPPaymaster _cipPaymaster;
    CIPEscrow _cipEscrow;

    address receiver = 0xaeD6b252635DcEF5Ba85dE52173FF040a18CEC6a;
    address bundler = 0xaeD6b252635DcEF5Ba85dE52173FF040a18CEC6a;

// mumbai -> sepolia
// IMailbox mailbox = IMailbox("0x2d1889fe5B092CD988972261434F7E5f26041115");
// bytes32 messageId = mailbox.dispatch{value: msg.value}(
//   80001,
//   "0x000000000000000000000000eDc1A3EDf87187085A3ABb7A9a65E1e7aE370C07",
//   bytes("Hello, world")
// );
// igs: 0x8aB67CAF605c6ee83cbFeFb0D8d67FDd3BF7B591

// sepolia -> mumbai
// IMailbox mailbox = IMailbox("0xfFAEF09B3cd11D9b20d1a19bECca54EEC2884766");
// bytes32 messageId = mailbox.dispatch{value: msg.value}(
//   11155111,
//   "0x000000000000000000000000F45A4D54223DA32bf7b5D43a9a460Ef3C94C713B",
//   bytes("Hello, world")
// );
// igs: 0x6f2756380FD49228ae25Aa7F2817993cB74Ecc56

    vm.startBroadcast(privateKey);

    _cipPaymaster = new CIPPaymaster(
      IEntryPoint(_entryPointAddress), //IEntryPoint _entryPoint,
      _hyperlaneMailboxAddress, //address hyperlane_mailbox_,
      _hyperlaneIGPAddress, //address hyperlane_igp_,
      receiver //address defaultReceiver_
    );
    _cipEscrow = new CIPEscrow();

    _cipPaymaster.addEscrow(block.chainid, address(_cipEscrow));
    _cipPaymaster.addAcceptedChain(block.chainid, true);
    _cipPaymaster.addAcceptedAsset(block.chainid, address(0), true);
    _cipPaymaster.addAcceptedOrigin(bundler, true);

    _cipEscrow.addEntryPoint(block.chainid, _entryPointAddress);
    _cipEscrow.addHyperlaneAddress(_hyperlaneMailboxAddress, true);

    // todo
    // paymaster now have 5 ether to support pamaster normal tx and 5 ether to support funded txs
    // vm.deal(_cipPaymasterAddress, 5 ether);
    // _entryPoint.depositTo{value: 5 ether}(_cipPaymasterAddress);
    // vm.prank(_cipPaymasterAddress);
    // _entryPoint.addStake{value: 5 ether}(3600);
    // vm.deal(_cipPaymasterAddress, 5 ether);

    
    vm.stopBroadcast();
  }
}
