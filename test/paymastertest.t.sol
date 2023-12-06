// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17.0;

//import {IMailbox, IIGP, CIPPaymaster, IEntryPoint} from "flat/TestPaymaster2_f.sol";
//import "contracts/interfaces/ICIPEscrow.sol";
import "forge-std/console.sol";

import {LoadKey} from "test/base/loadkey.t.sol";

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {IEntryPoint, EntryPoint, IAccount, UserOperation, UserOperationLib} from "@4337/core/entryPoint.sol";
import {SimpleAccount, SimpleAccountFactory} from "@4337/samples/SimpleAccountFactory.sol";
import {CIPPaymaster, IMailbox, IIGP} from "src/CIPPaymaster.sol";
import {CIPEscrow} from "src/CIPEscrow.sol";
import {PaymasterAndData, PaymasterAndData2} from "src/interfaces/ICIPEscrow.sol";
import {HyperlaneMailbox} from "src/test/HyperlaneMailbox.sol";
import {HyperlaneIGP} from "src/test/HyperlaneIGP.sol"; 
import {Token} from "src/test/ERC20.sol";

/**
What I need
- Paymaster needs to be deployed
- The paymaster need to have BOTH deposited and staked funds in the EntryPoint
- Test is paymaster works locally with normal transactions
- Escrow test already works
- Test Hyperlane live transactions (easier since hyperlane Mumbai/sepolia doesn’t need payment)
- If all works, make it reproducible with instructions
- Make a video of stepping though the process
- Post video to my YouTube and share it (less than 3 mins)
 */

 contract PaymasterTest is LoadKey {
    using ECDSA for bytes32;
    using UserOperationLib for UserOperation;

    IEntryPoint _entryPoint;
    address _entryPointAddress;
    SimpleAccountFactory _simpleAccountFactory;
    address _simpleAccountFactoryAddress;
    SimpleAccount _simpleAccount;
    address _simpleAccountAddress;
    CIPPaymaster _cipPaymaster;
    address _cipPaymasterAddress;
    CIPEscrow _cipEscrow;
    address _cipEscrowAddress;
    HyperlaneMailbox _hyperlaneMailbox;
    address _hyperlaneMailboxAddress;
    HyperlaneIGP _hyperlaneIGP;
    address _hyperlaneIGPAddress;
    Token _token;
    address _tokenAddress;

    uint256 internal constant _SALT = 0x55;

    address internal constant _RECEIVER = address(bytes20(bytes32(keccak256("defaultReceiver"))));

    address internal constant _BUNDLER = address(bytes20(bytes32(keccak256("defaultBundler"))));

    UserOperation public userOpBase = UserOperation({
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

    PaymasterAndData public paymasterAndDataBase = PaymasterAndData({ // need to fix paymasterAndData ordering
        paymaster: address(0),
        owner: address(0),
        chainId: uint256(0),
        asset: address(0),
        amount: uint256(0)
    });

    PaymasterAndData2 public paymasterAndDataBase2 = PaymasterAndData2({
        paymaster: address(0),
        owner: address(0),
        chainId: uint256(0),
        paymentAsset: address(0),
        paymentAmount: uint256(0),
        transferAsset: address(0),
        transferAmount: uint256(0)
    });

    function setUp() public virtual override {
        super.setUp();

        _token = new Token("Test Token", "TKN");
        _tokenAddress = address(_token);

        _entryPoint = new EntryPoint();
        _entryPointAddress = address(_entryPoint);

        _simpleAccountFactory = new SimpleAccountFactory(IEntryPoint(_entryPointAddress));
        _simpleAccountFactoryAddress = address(_simpleAccountFactory);

        _hyperlaneMailbox = new HyperlaneMailbox(uint32(block.chainid));
        _hyperlaneMailboxAddress = address(_hyperlaneMailbox);
        _hyperlaneIGP = new HyperlaneIGP(_hyperlaneMailboxAddress);
        _hyperlaneIGPAddress = address(_hyperlaneIGP);

        _cipPaymaster = new CIPPaymaster(
            IEntryPoint(_entryPointAddress),//IEntryPoint _entryPoint, 
            _hyperlaneMailboxAddress,//address hyperlane_mailbox_, 
            _hyperlaneIGPAddress,//address hyperlane_igp_,
            _RECEIVER//address defaultReceiver_
        );
        _cipPaymasterAddress = address(_cipPaymaster);
        _cipPaymaster.addEscrow(block.chainid, _cipEscrowAddress);
        _cipPaymaster.addAcceptedChain(block.chainid, true);
        _cipPaymaster.addAcceptedAsset(block.chainid, address(0), true);
        _cipPaymaster.addAcceptedOrigin(_BUNDLER, true);

        _cipEscrow = new CIPEscrow();
        _cipEscrowAddress = address(_cipEscrow);
        _cipEscrow.addEntryPoint(block.chainid, _entryPointAddress);
        _cipEscrow.addHyperlaneAddress(_hyperlaneMailboxAddress, true);

        // paymaster now have 5 ether to support pamaster normal tx and 5 ether to support funded txs
        vm.deal(_cipPaymasterAddress, 5 ether);
        _entryPoint.depositTo{value: 5 ether}(_cipPaymasterAddress);
        vm.prank(_cipPaymasterAddress);
        _entryPoint.addStake{value: 5 ether}(3600);
        vm.deal(_cipPaymasterAddress, 5 ether);

        // need to provide funds to both paymaster deposit and stake
        // needs to execute and accept message on chain A
        // then execute handle on chain B


        // UserOperation memory userOp = userOpBase;
        // bytes memory callData_;
        // bytes memory initCode_;
        // PaymasterAndData memory paymasterAndData_;
        // address sender_;
        // bytes32 userOpHash;
        // uint8 v;
        // bytes32 r;
        // bytes32 s;
        // UserOperation[] memory userOps = new UserOperation[](1);
        // uint256 newSize;
        // address newAddress;
        
        // create callData:
        // initCode_ = abi.encodePacked(_simpleAccountFactory, abi.encodeWithSignature("createAccount(address,uint256)", eoaAddress, _SALT+1));
        // sender_ = _simpleAccountFactory.getAddress(eoaAddress, _SALT+1);

        // userOp.sender = sender_;
        // userOp.initCode = initCode_;

        // userOpHash = _entryPoint.getUserOpHash(userOp);
        // (v, r, s) = vm.sign(privateKey, userOpHash.toEthSignedMessageHash());
        // userOp.signature = abi.encodePacked(r, s, v);
        // _entryPoint.depositTo{value: 1 ether}(sender_);
        // userOps[0] = (userOp);

        // // create calldata from eoa simple account to entrypoint, to create 0x69
        // callData_ = abi.encodeWithSelector(_entryPoint.handleOps.selector, userOps, msg.sender);
        // callData_ = abi.encodeWithSelector(SimpleAccount.execute.selector, _entryPointAddress, 0, callData_);

        // newAddress = sender_;
        // assembly {
        //     newSize := extcodesize(newAddress)
        // }
        // console.log("new address", newAddress);
        // console.log("new balance", _entryPoint.balanceOf(sender_));
        // console.log("new address size", newSize);

        // cannot create double create account due to reentrancy guard
        // initCode_ = abi.encodePacked(_simpleAccountFactory, abi.encodeWithSignature("createAccount(address,uint256)", eoaAddress, _SALT));
        // sender_ = _simpleAccountFactory.getAddress(eoaAddress, _SALT);
        // paymasterAndData_ = paymasterAndDataBase;
        // paymasterAndData_.paymaster = address(0);
        // paymasterAndData_.owner = address(0);
        // paymasterAndData_.chainId = uint256(0);
        // paymasterAndData_.asset = address(0);
        // paymasterAndData_.amount = uint256(0);

        // userOp.sender = sender_;
        // userOp.initCode = initCode_;
        // userOp.callData = callData_; // null for now
        // callData_ = abi.encodeWithSelector(Token.mint.selector, userOp.sender);
        // callData_ = abi.encodeWithSelector(SimpleAccount.execute.selector, _tokenAddress, 0, callData_);
        // userOp.paymasterAndData = abi.encodePacked(
        //     paymasterAndData_.paymaster,
        //     paymasterAndData_.owner,
        //     paymasterAndData_.chainId,
        //     paymasterAndData_.asset,
        //     paymasterAndData_.amount
        // );

        // userOpHash = _entryPoint.getUserOpHash(userOp);
        // (v, r, s) = vm.sign(privateKey, userOpHash.toEthSignedMessageHash());
        // userOp.signature = abi.encodePacked(r, s, v);
        // _entryPoint.depositTo{value: 1 ether}(sender_);
        // userOps[0] = (userOp);

        // //
        // bytes memory payload_ = abi.encodeWithSelector(bytes4(0x1fad948c), userOps, payable(address(uint160(uint256(6666)))));
        // gas = gasleft();
        // assembly {
        //     pop(call(gas(), sload(_entryPointAddress.slot), 0, add(payload_, 0x20), mload(payload_), 0, 0))
        // }
        // //_entryPoint.handleOps(userOps, payable(address(uint160(uint256(6666)))));
        // newAddress = sender_;
        // assembly {
        //     newSize := extcodesize(newAddress)
        // }
        // console.log("new address", newAddress);
        // console.log("new balance", _entryPoint.balanceOf(sender_));
        // console.log("new address size", newSize);
        // console.log("gas used for factory deployment", gas - gasleft());
    }

    function testCipPaymaster() public {
        uint256 gas;
        UserOperation memory userOp = userOpBase;
        bytes memory callData_;
        bytes memory initCode_;
        PaymasterAndData memory paymasterAndData_;
        address sender_;
        bytes32 userOpHash;
        uint8 v;
        bytes32 r;
        bytes32 s;
        UserOperation[] memory userOps = new UserOperation[](1);
        uint256 newSize;
        address newAddress;

        initCode_ = abi.encodePacked(_simpleAccountFactory, abi.encodeWithSignature("createAccount(address,uint256)", eoaAddress, _SALT));
        sender_ = _simpleAccountFactory.getAddress(eoaAddress, _SALT);
        _simpleAccountAddress = sender_;
        paymasterAndData_ = paymasterAndDataBase;
        paymasterAndData_.paymaster = _cipPaymasterAddress;
        paymasterAndData_.owner = eoaAddress;
        paymasterAndData_.chainId = block.chainid;
        paymasterAndData_.asset = address(0);
        paymasterAndData_.amount = 0.02 ether;

        userOp.sender = sender_;
        userOp.initCode = initCode_;
        userOp.callData = callData_; // null for now
        callData_ = abi.encodeWithSelector(Token.mint.selector, userOp.sender, 10000);
        callData_ = abi.encodeWithSelector(SimpleAccount.execute.selector, _tokenAddress, 0, callData_);
        userOp.callData = callData_;
        userOp.paymasterAndData = abi.encodePacked(
            paymasterAndData_.paymaster,
            paymasterAndData_.owner,
            paymasterAndData_.chainId,
            paymasterAndData_.asset,
            paymasterAndData_.amount
        );

        userOpHash = _entryPoint.getUserOpHash(userOp);
        (v, r, s) = vm.sign(privateKey, userOpHash.toEthSignedMessageHash());
        userOp.signature = abi.encodePacked(r, s, v);
        _entryPoint.depositTo{value: 1 ether}(sender_);
        userOps[0] = (userOp);

        //
        bytes memory payload_ = abi.encodeWithSelector(bytes4(0x1fad948c), userOps, payable(address(uint160(uint256(6666)))));
        gas = gasleft();
        assembly {
            pop(call(gas(), sload(_entryPointAddress.slot), 0, add(payload_, 0x20), mload(payload_), 0, 0))
        }
        //_entryPoint.handleOps(userOps, payable(address(uint160(uint256(6666)))));
        newAddress = sender_;
        assembly {
            newSize := extcodesize(newAddress)
        }

        // needs to call mailbox handle
        //  function handleDispatch(bytes32 destinationDomain, address recipientAddress, bytes calldata messageBody) external {
        //     bytes memory payload_;
        //     bool success;
        //     payload_ = abi.encodeWithSignature("interchainSecurityModule()");
        //     (success, ) = recipientAddress.call(payload_);
        //     require(success); // hyperlane required ISM is defined (even if zero)
        //     payload_ = abi.encodeWithSignature(
        //         "handle(uint32,bytes32,bytes)",
        //         destinationDomain,
        //         msg.sender,
        //         messageBody
        //     );
        //     (success, ) = recipientAddress.call(payload_);
        //     require(success, "recipient execution failed");
        // }

        //need to put money in escrow for eoaAddress
        vm.deal(eoaAddress, 10 ether);
        vm.prank(eoaAddress);
        _cipEscrow.deposit{value: 5 ether}(eoaAddress, address(0), 5 ether);
        //uint256 oldDeadline = _cipEscrow.getDeadline(eoaAddress);
        bytes32 timeHash = _cipEscrow.hashSeconds(eoaAddress, 3600);
        (v, r, s) = vm.sign(privateKey, timeHash.toEthSignedMessageHash());
        bytes memory timeSignature = abi.encodePacked(r, s, v);
        _cipEscrow.extendLock(eoaAddress, 3600, timeSignature);
        console.log("eoadAddress:", eoaAddress);
        console.log("lockTime:", 3600);

        vm.prank(_hyperlaneMailboxAddress);
        _hyperlaneMailbox.handleDispatch(block.chainid, _cipEscrowAddress, abi.encode(userOp, _cipPaymasterAddress));

        console.log("Token adress:", _tokenAddress);
        console.log("Simple Account address:", _simpleAccountAddress);
        console.log("Simple Account Factory address:", _simpleAccountFactoryAddress);
        console.log("EntryPoint address:", _entryPointAddress);
        console.log("HyperlaneMailbox address:", _hyperlaneMailboxAddress);
        console.log("HyperlaneIGP address:", _hyperlaneIGPAddress);
        console.log("Paymaster address:", _cipPaymasterAddress);
        console.log("Escrow address:", _cipEscrowAddress);


        console.log("new address", newAddress);
        console.log("new balance", _entryPoint.balanceOf(sender_));
        console.log("new address size", newSize);
        console.log("gas used for factory deployment", gas - gasleft());
        console.log("new balance hyperlaneMailbox:", _hyperlaneMailboxAddress.balance);
        console.log("new token balance:", _token.balanceOf(userOp.sender));
        console.log("final paymaster balance:", _cipPaymasterAddress.balance);
    }

    // messageId 

    // test the execution of assets moving from paymaster to be used by the AA account
    // TODO: TBA
    function testCipPaymaster2() public {}
 }