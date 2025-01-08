// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, Vm, console} from "forge-std/Test.sol";

import {MultiSigWallet} from "../src/MultiSigWallet.sol";
import {TestContract} from "./TestContract.sol";

contract MultiSigWalletTest is Test {
    MultiSigWallet wallet;
    address[] owners;

    address owner1 = makeAddr("owner1");
    address owner2 = makeAddr("owner2");

    TestContract testContract;

    function setUp() public {
        // Deploy the initial implementation
        owners.push(owner1);
        owners.push(owner2);
        wallet = new MultiSigWallet(owners, 2);

        testContract = new TestContract();
    }

    function test_MultiSigSetup() public {
        // GIVEN + WHEN setup
        // THEN
        address[] memory walletOwners = wallet.getOwners();
        assertEq(walletOwners.length, 2, "unexpected number of owners");
        assertEq(walletOwners[0], owner1, "unexpected owner1");
        assertEq(walletOwners[1], owner2, "unexpected owner2");
        assertEq(wallet.numConfirmationsRequired(), 2, "unexpected numConfirmationsRequired");
        assertEq(wallet.getTransactionCount(), 0, "transaction count > 0");
    }

    function test_MultiSigSubmitTransaction() public {
        // GIVEN
        bytes memory data_in = testContract.getData();
        uint256 value_in = 0;

        // WHEN
        vm.startPrank(owner1);
        wallet.submitTransaction(address(testContract), value_in, data_in);
        vm.stopPrank();

        // THEN
        assertEq(wallet.getTransactionCount(), 1, "unexpected transaction count");

        (address to, uint256 value_out, bytes memory data_out, bool executed, uint256 numConfirmations) =
            wallet.getTransaction(0);

        assertEq(to, address(testContract), "unexpected to");
        assertEq(value_out, value_in, "unexpected value");
        assertEq(data_out, data_in, "unexpected data");
        assertEq(executed, false, "unexpected executed");
        assertEq(numConfirmations, 0, "unexpected numConfirmations");
    }

    function test_MultiSigConfirmTransaction() public {
        // GIVEN
        bytes memory data_in = testContract.getData();
        uint256 value_in = 0;

        vm.startPrank(owner1);
        wallet.submitTransaction(address(testContract), value_in, data_in);
        vm.stopPrank();

        // WHEN - onwer1 confirms
        vm.startPrank(owner1);
        wallet.confirmTransaction(0);
        vm.stopPrank();

        // THEN
        (,,,, uint256 numConfirmations) = wallet.getTransaction(0);
        assertEq(numConfirmations, 1, "unexpected numConfirmations (after owner 1)");

        // WHEN - onwer2 confirms
        vm.startPrank(owner2);
        wallet.confirmTransaction(0);
        vm.stopPrank();

        // THEN
        (,,,, numConfirmations) = wallet.getTransaction(0);
        assertEq(numConfirmations, 2, "unexpected numConfirmations (after owner 2)");
    }
}
