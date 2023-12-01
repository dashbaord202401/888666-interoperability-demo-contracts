//SPDX-License-Identifier: MIT
pragma solidity^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract DripFaucet is Ownable {
  using Strings for uint256;
  using ECDSA for bytes32;
  bool private _isLock;
  uint256 _drip;
  uint256 _timelock;

  constructor(uint256 drip) {
    _drip = drip;
  }

  mapping(address => bool) public isAuthorized;
  mapping(address => uint256) public lastClaim;

  modifier noReentry {
    require(!_isLock, "reentrance locked");
    _isLock = true;
    _;
    _isLock = false;
  }

  function generateHash(address to, uint256 amount) public view returns(bytes32) {
    return keccak256(abi.encode(to, amount, block.chainid));
  }

  function dripTokens(address to, uint256 amount, bytes calldata signature) noReentry public {
    require(isAuthorized[msg.sender], "Invalid isAuthorized");
    require(block.timestamp - lastClaim[to] > _timelock);
    lastClaim[to] = block.timestamp;

    bytes32 hash_ = generateHash(to, amount);
    (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(hash_.toEthSignedMessageHash(), signature);
    if (error != ECDSA.RecoverError.NoError) {
      revert BadSignature();
    }

    if (recovered != to) {
      revert BadSignature();
    }

    (bool success,) = payable(to).call{value: amount}("");
    require(success, "drip failed");
  }

  function getBalance() public view returns(uint256) {
    return address(this).balance;
  }

  function setAuthorized(address to, bool state) onlyOwner public {
    isAuthorized[to] = state;
  }

  function withdraw() onlyOwner public {
    (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
    require(success, "withdraw failed");
  }
  // if 1271 signature is user
  // add claim time to contract

  error BadSignature();

  receive() external payable {}
}