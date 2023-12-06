// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17 .0;

//import {IMailbox, IIGP, CIPPaymaster, IEntryPoint} from "flat/TestPaymaster2_f.sol";
//import "contracts/interfaces/ICIPEscrow.sol";
import "forge-std/console.sol";

import {LoadKey} from "test/base/loadkey.t.sol";

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {DripFaucet} from "src/tokens/drip_faucet.sol";
import {Token} from "src/tokens/ERC20.sol";

contract DripTest is LoadKey {
  using ECDSA for bytes32;

  DripFaucet _dripFaucet;
  address _dripFaucetAddress;
  Token _tokenFaucet;
  address _tokenFaucetAddress;

  address internal constant RELAY =
    address(bytes20(bytes32(keccak256("defaultRelay"))));
  address internal constant USER =
    address(bytes20(bytes32(keccak256("defaultUser"))));

  function setUp() public virtual override {
    super.setUp();

    _dripFaucet = new DripFaucet();
    _dripFaucetAddress = address(_dripFaucet);

    _tokenFaucet = new Token("Token", "TKN");
    _tokenFaucetAddress = address(_tokenFaucet);

    _dripFaucet.setAuthorized(RELAY, true);
    _dripFaucet.setDrip(0.5 ether);
    _dripFaucet.setTimelock(3600);
    vm.deal(_dripFaucetAddress, 50 ether);
    vm.deal(RELAY, 50 ether);
    vm.deal(USER, 50 ether);

    skip(10000);
    vm.chainId(31337);
  }

  function testDrip() public {
    uint8 v;
    bytes32 r;
    bytes32 s;
    bytes memory signature;
    bytes32 hash_ = _dripFaucet.generateHash(eoaAddress);
    bytes32 hash_2 = 0x3c026ba09d5d55ac9317f3a87130ebe6d74800b4952dc0265de65be97a87b0a2;
    (v, r, s) = vm.sign(privateKey, hash_.toEthSignedMessageHash());
    signature = abi.encodePacked(r, s, v);
    (v, r, s) = vm.sign(privateKey, hash_2.toEthSignedMessageHash());
    bytes memory signature2 = abi.encodePacked(r, s, v);
    console.log("signature2", vm.toString(signature2));
    console.log("eoaAddress", vm.toString(eoaAddress));
    console.log("eth message", vm.toString(hash_2.toEthSignedMessageHash()));

    vm.startPrank(USER);
    vm.expectRevert(); // unauthorized
    _dripFaucet.dripTokens(USER, signature);
    vm.stopPrank();

    vm.startPrank(RELAY);
    vm.expectRevert(); // bad signature
    _dripFaucet.dripTokens(RELAY, signature);

    _dripFaucet.dripTokens(eoaAddress, signature);

    vm.expectRevert(); // timestamp error
    _dripFaucet.dripTokens(USER, signature);
    vm.stopPrank();

    // _dripFaucet.withdraw();
  }

  function testDrip2() public {
    _tokenFaucet.mint(USER, 5);
  }

}
