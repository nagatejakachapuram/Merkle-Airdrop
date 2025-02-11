// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {SportsToken} from "../src/SportsToken.sol";
import {Script} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployMerkleAirdrop is Script {
    uint256 public s_amountToTransfer = 4 * 25 * 1e18;
    bytes32 private s_merkleRoot = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

    function run() external returns (MerkleAirdrop, SportsToken) {}

    function deployMerkleAirdrop() external returns (MerkleAirdrop, SportsToken) {
        vm.startBroadcast();
        SportsToken token = new SportsToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(s_merkleRoot, IERC20(address(token)));
        token.mint(token.owner(), s_amountToTransfer);
        token.transfer(address(airdrop), s_amountToTransfer);
        vm.stopBroadcast();
        return (airdrop, token);
    }
}
