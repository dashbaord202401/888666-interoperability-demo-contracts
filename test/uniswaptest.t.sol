// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Token} from "src/tokens/ERC20.sol";
import {WETH9} from "src/tokens/WETH9.sol";
import {UniswapV2Factory} from "src/tokens/UniswapV2Factory.sol";
import {UniswapV2Pair} from "src/tokens/UniswapV2Pair.sol";
import {UniswapV2Router02} from "src/tokens/UniswapV2Router.sol";


// Simple Account Wallet
import "lib/forge-std/src/Test.sol";
import {SimpleAccountFactory, SimpleAccount, IEntryPoint} from "lib/account-abstraction/contracts/samples/SimpleAccountFactory.sol";
import {EntryPoint} from "lib/account-abstraction/contracts/core/EntryPoint.sol";
import {BaseAccount, UserOperation} from "lib/account-abstraction/contracts/core/BaseAccount.sol";
import {ECDSA} from "lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract UniswapTest is Test {
    using ECDSA for bytes32;

    EntryPoint public entryPoint;
    address internal entryPointAddress;

    Token public token;
    WETH9 public weth;
    address owner;
    address user;
    uint256[2] internal publicKey;
    uint256[2] internal publicKey2;
    string internal constant SIGNER_1 = "1";
    string internal constant SIGNER_2 = "2";

    UniswapV2Factory public uniswapV2Factory;
    UniswapV2Router02 public uniswapV2Router02;
    UniswapV2Pair public uniswapV2Pair;


    DawnWalletFactory public dawnWalletFactory;

    //CompatibilityFallbackHandler internal handler;
    ForumAccount public forumAccountSingleton;
    ForumAccountFactory public forumAccountFactory;
    ForumAccount internal forumAccount;
    address payable internal forumAccountAddress;

    SimpleAccount public simpleAccount;
    SimpleAccountFactory public simpleAccountFactory;

    
    function setUp() public {
        owner = vm.addr(1);
        vm.deal(owner, 10 ether);

        user = vm.addr(2);
        vm.deal(user, 10 ether);
        // publicKey = createPublicKey(SIGNER_1);
        // publicKey2 = createPublicKey(SIGNER_2);

        vm.startPrank(owner);
        entryPoint = new EntryPoint();
        entryPointAddress = address(entryPoint);
        token = new Token("TestToken", "TEST");
        weth = new WETH9();
        uniswapV2Factory = new UniswapV2Factory(owner);
        uniswapV2Router02 = new UniswapV2Router02(address(uniswapV2Factory), address(weth));
        uniswapV2Pair = UniswapV2Pair(uniswapV2Factory.createPair(address(token), address(weth)));
        vm.deal(owner, 10 ether);
        
        bytes memory payload = abi.encodeWithSignature("deposit()");
        address(weth).call{value: 10 ether}(payload);
        require(weth.balanceOf(owner) > 0);
        token.mintMore(address(owner), 10000000);
        token.transfer(owner, token.balanceOf(owner));
        weth.transfer(owner, token.balanceOf(owner));
        uniswapV2Pair.sync();

        // address[2] memory path;
        // path[0] = address(weth);
        // path[1] = address(token);
        // bytes memory payload2 = abi.encodeWithSignature("swapExactETHForTokensSupportingFeeOnTransferTokens(uint,address[],address,uint)",0,path,address(user),block.timestamp + 3600);


        // handler = new CompatibilityFallbackHandler();
        // bytes memory ellipticLibraryByteCode =
        //     abi.encodePacked(vm.getCode("FCL_Elliptic_ZZ.sol:FCL_Elliptic_ZZ"));
        // address ellipticAddress;
        // assembly {
        //     ellipticAddress := create(0, add(ellipticLibraryByteCode, 0x20), mload(ellipticLibraryByteCode))
        // }

        // forumAccountSingleton = new ForumAccount(ellipticAddress);

        // forumAccountFactory = new ForumAccountFactory(
    	// 	forumAccountSingleton,
    	// 	entryPointAddress,
    	// 	address(handler),
    	// 	hex'1584482fdf7a4d0b7eb9d45cf835288cb59e55b8249fff356e33be88ecc546d11d00000000',
    	// 	'{"type":"webauthn.get","challenge":"',
    	// 	'","origin":"https://development.forumdaos.com"}'
    	// );

        // forumAccountAddress = forumAccountFactory.createForumAccount(publicKey);
        // forumAccount = ForumAccount(forumAccountAddress);
        // bytes memory _calldata = buildExecutionPayload(address(uniswapV2Router02), 0.2 ether, payload2, Enum.Operation.Call);

        // vm.deal(address(forumAccount), 10 ether);
        // bytes memory _initCode;
        // UserOperation memory userop = buildUserOp(address(forumAccount), 0, _initCode, _calldata);
        // UserOperation[1] memory userops;
        // userops[0] = userop;

        simpleAccountFactory = new SimpleAccountFactory(IEntryPoint(entryPoint));
        vm.stopPrank();

        //instance = new FDemo();
        //dawnWalletFactory = new DawnWalletFactory();
    }

    // -----------------------------------------------------------------------
    // 4337 Helper Functions
    // -----------------------------------------------------------------------

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

    function buildUserOp(address sender, uint256 nonce, bytes memory initCode, bytes memory callData)
        public
        view
        returns (UserOperation memory userOp)
    {
        // Build on top of base op
        userOp = userOpBase;

        // Add sender and calldata to op
        userOp.sender = sender;
        userOp.nonce = nonce;
        userOp.initCode = initCode;
        userOp.callData = callData;
    }

    // Build payload which the entryPoint will call on the sender 4337 account
    function buildExecutionPayload(address to, uint256 value, bytes memory data, Enum.Operation operation)
        internal
        pure
        returns (bytes memory)
    {
        return abi.encodeWithSignature("executeAndRevert(address,uint256,bytes,uint8)", to, value, data, operation);
    }

    // !!!!! combine with the above
    // function signAndFormatUserOpIndividual(UserOperation memory userOp, string memory signer1)
    //     internal
    //     returns (UserOperation[] memory)
    // {
    //     userOp.signature =
    //         abi.encode(signMessageForPublicKey(signer1, Base64.encode(abi.encodePacked(entryPoint.getUserOpHash(userOp)))));

    //     UserOperation[] memory userOpArray = new UserOperation[](1);
    //     userOpArray[0] = userOp;

    //     return userOpArray;
    // }

    

    function testDeployWallets() public {
        
        simpleAccount = simpleAccountFactory.createAccount(user, uint256(555));
        //address simpleAccountAddress = simpleAccountFactory.getAddress(user, uint256(555));
        vm.startPrank(user);
        // Deploy Dawn Wallet
        //address account = dawnWalletFactory.deployWallet(address(entryPoint), user, 555);
        vm.stopPrank();
    }

    function testSimpleWallet() public {
        vm.startPrank(user);
        //address account = dawnWalletFactory.deployWallet(address(entryPoint), user, 555);
        vm.stopPrank();
    }

    function testSimpleAccountUniswapV2() public payable {}
}