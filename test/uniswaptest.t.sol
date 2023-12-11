// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Token} from "src/tokens/ERC20.sol";
import {WETH9} from "src/tokens/WETH9.sol";
import {UniswapV2Factory} from "src/tokens/UniswapV2Factory.sol";
import {UniswapV2Pair} from "src/tokens/UniswapV2Pair.sol";
import {UniswapV2Router02} from "src/tokens/UniswapV2Router.sol";

// Simple Account Wallet
import {Test} from "lib/forge-std2/src/Test.sol";
import {SimpleAccountFactory, SimpleAccount, IEntryPoint} from "lib/account-abstraction/contracts/samples/SimpleAccountFactory.sol";
import {EntryPoint} from "lib/account-abstraction/contracts/core/EntryPoint.sol";
import {BaseAccount, UserOperation} from "lib/account-abstraction/contracts/core/BaseAccount.sol";
import {ECDSA} from "lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract UniswapTest is Test {
  using ECDSA for bytes32;

  EntryPoint _entryPoint;

  Token public token;
  WETH9 public weth;
  address public owner = address(bytes20(bytes32(keccak256("defaultOwner"))));
  address public user = address(bytes20(bytes32(keccak256("defaultReceiver"))));
  address public relay = address(bytes20(bytes32(keccak256("defaultRelay"))));
  string public mnemonic1 =
    "test test test test test test test test test test test junk";
  string public mnemonic2 =
    "behave else rubber loan crumble clip squirrel deposit fix comic talent cover";
  uint256 public privateKey1;
  uint256 public privateKey2;
  address public publicKey1;
  address public publicKey2;

  uint256 public constant SALT = 0x55;

  UniswapV2Factory public uniswapV2Factory;
  UniswapV2Router02 public uniswapV2Router;
  UniswapV2Pair public uniswapV2Pair;

  SimpleAccountFactory _simpleAccountFactory;

  function setUp() public {
    privateKey1 = vm.deriveKey(mnemonic1, 0);
    privateKey2 = vm.deriveKey(mnemonic2, 0);
    publicKey1 = vm.addr(privateKey1);
    publicKey2 = vm.addr(privateKey2);

    owner = vm.addr(1);
    vm.deal(owner, 10 ether);

    user = vm.addr(2);
    vm.deal(user, 10 ether);

    vm.startPrank(owner);
    _entryPoint = new EntryPoint();
    token = new Token("TestToken", "TEST");
    weth = new WETH9();
    uniswapV2Factory = new UniswapV2Factory(owner);
    uniswapV2Router = new UniswapV2Router02(
      address(uniswapV2Factory),
      address(weth)
    );
    uniswapV2Pair = UniswapV2Pair(
      uniswapV2Factory.createPair(address(token), address(weth))
    );
    vm.deal(owner, 10 ether);

    bytes memory payload = abi.encodeWithSignature("deposit()");
    address(weth).call{value: 0.1 ether}(payload);
    require(weth.balanceOf(owner) > 0);
    token.mint(address(owner), 10000_00000000000000000);
    token.transfer(owner, token.balanceOf(owner));
    weth.transfer(owner, weth.balanceOf(owner));
    uniswapV2Pair.sync();

    vm.deal(relay, 5 ether);
    _entryPoint.depositTo{value: 5 ether}(relay);
    vm.deal(relay, 5 ether);

    _simpleAccountFactory = new SimpleAccountFactory(IEntryPoint(_entryPoint));
    vm.stopPrank();

    vm.prank(relay);
    _entryPoint.addStake{value: 5 ether}(3600);
  }

  UserOperation public userOpBase =
    UserOperation({
      sender: address(0),
      nonce: 0,
      initCode: new bytes(0),
      callData: new bytes(0),
      callGasLimit: 10000000,
      verificationGasLimit: 20000000,
      preVerificationGas: 20000000,
      maxFeePerGas: 2,
      maxPriorityFeePerGas: 1,
      paymasterAndData: new bytes(0),
      signature: new bytes(0)
    });

  function testSwap() public {
    UserOperation memory userOp = userOpBase;
    bytes memory callData_;
    bytes memory initCode_;
    address sender_;
    bytes32 userOpHash;
    uint8 v;
    bytes32 r;
    bytes32 s;
    UserOperation[] memory userOps = new UserOperation[](1);
    uint256 newSize;
    address newAddress;

    sender_ = address(_simpleAccountFactory.createAccount(publicKey1, SALT));

    address[2] memory path;
    path[0] = address(weth);
    path[1] = address(token);
    callData_ = abi.encodeWithSelector(UniswapV2Router02.swapExactTokensForETHSupportingFeeOnTransferTokens.selector,0,path,sender_,block.timestamp + 3600);
    callData_ = abi.encodeWithSelector(SimpleAccount.execute.selector, address(uniswapV2Router), 0.01 ether, callData_);

    userOp.sender = sender_;
    userOp.initCode = initCode_;
    userOp.callData = callData_; 

    userOpHash = _entryPoint.getUserOpHash(userOp);
    (v, r, s) = vm.sign(privateKey1, userOpHash.toEthSignedMessageHash());
    userOp.signature = abi.encodePacked(r, s, v);
    _entryPoint.depositTo{value: 1 ether}(sender_);
    userOps[0] = (userOp);

    //
    vm.startPrank(relay);
    _entryPoint.handleOps(userOps, payable(address(uint160(uint256(6666)))));
    vm.stopPrank();
    newAddress = sender_;
    assembly {
        newSize := extcodesize(newAddress)
    }
  }

  function testSwapWithInitCode() public {
    UserOperation memory userOp = userOpBase;
    bytes memory callData_;
    bytes memory initCode_;
    address sender_;
    bytes32 userOpHash;
    uint8 v;
    bytes32 r;
    bytes32 s;
    UserOperation[] memory userOps = new UserOperation[](1);
    uint256 newSize;
    address newAddress;

    initCode_ = abi.encodePacked(_simpleAccountFactory, abi.encodeWithSignature("createAccount(address,uint256)", publicKey2, SALT));
    sender_ = address(_simpleAccountFactory.getAddress(publicKey2, SALT));

    address[2] memory path;
    path[0] = address(weth);
    path[1] = address(token);
    callData_ = abi.encodeWithSelector(UniswapV2Router02.swapExactTokensForETHSupportingFeeOnTransferTokens.selector,0,path,sender_,block.timestamp + 3600);
    callData_ = abi.encodeWithSelector(SimpleAccount.execute.selector, address(uniswapV2Router), 0.01 ether, callData_);

    userOp.sender = sender_;
    userOp.initCode = initCode_;
    userOp.callData = callData_; 

    userOpHash = _entryPoint.getUserOpHash(userOp);
    (v, r, s) = vm.sign(privateKey2, userOpHash.toEthSignedMessageHash());
    userOp.signature = abi.encodePacked(r, s, v);
    _entryPoint.depositTo{value: 1 ether}(sender_);
    userOps[0] = (userOp);

    //
    vm.startPrank(relay);
    _entryPoint.handleOps(userOps, payable(address(uint160(uint256(6666)))));
    vm.stopPrank();
    newAddress = sender_;
    assembly {
        newSize := extcodesize(newAddress)
    }
  }
}
