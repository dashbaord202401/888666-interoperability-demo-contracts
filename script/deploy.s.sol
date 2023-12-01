// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.15;

import "../test/base/loadkey.t.sol";
import "forge-std/console.sol";
import {IEntryPoint, EntryPoint, IAccount, UserOperation, UserOperationLib} from "@4337/core/entryPoint.sol";
import {SimpleAccount, SimpleAccountFactory} from "@4337/samples/SimpleAccountFactory.sol";

contract Deploy is LoadKey {
    // using UserOperationLib for UserOperation;

    function setUp() public virtual override {
        super.setUp();
    }

    function run() public {
        vm.startBroadcast(privateKey);
        //
        IEntryPoint _entryPoint;
        address entryPointAddress;
        //vm.nonce(72);
        SimpleAccountFactory _simpleAccountFactory;
        address simpleAccountFactoryAddress;
        //vm.nonce(73);
        _entryPoint = new EntryPoint();
        entryPointAddress = address(_entryPoint);

        _simpleAccountFactory = new SimpleAccountFactory(
            IEntryPoint(entryPointAddress)
        );
        simpleAccountFactoryAddress = address(_simpleAccountFactory);
        vm.stopBroadcast();
    }
}
//forge script script/deploy.s.sol:MyScript --rpc-url "https://rpc.apothem.network" --broadcast
forge create --rpc-url "https://rpc.apothem.network" --private-key d2f29e5f86349ed3d860762bc77365d9fff2f0de6868e70feeb0741c2770b36a flat/EntryPoint.sol:EntryPoint
    --constructor-args "ForgeUSD" "FUSD" 18 1000000000000000000000 \
    --private-key <your_private_key> \
    --etherscan-api-key <your_etherscan_api_key> \
    --verify \
    src/MyToken.sol:MyToken