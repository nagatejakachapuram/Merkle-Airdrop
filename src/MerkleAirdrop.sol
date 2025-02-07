// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    using SafeERC20 for IERC20;

    // some list of addresses
    // Allow someone on the list to claim the ERC20  tokens

    error MerkleAirdrop_InvalidProof();
    error MerkleAirdrop_alreadyClamied();

    event Claim(address indexed account, uint256 indexed amount);

    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;
    mapping(address claimer => bool claimed) s_hasClamied;

    constructor(bytes32 merkleRoot, IERC20 airdropToken) {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        // CHECKS
        if (s_hasClamied[account]) {
            revert MerkleAirdrop_alreadyClamied();
        }
        // calculate using the account and the amount, the hash -> leaf node
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop_InvalidProof();
        }
        // FOLLOWING C.E.I pattern
        s_hasClamied[account] = true;

        emit Claim(account, amount);
        i_airdropToken.safeTransfer(account, amount);
    }

    // Getters -> for varaibles that have private visibility

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropTokens() external view returns (IERC20) {
        return i_airdropToken;
    }
}
