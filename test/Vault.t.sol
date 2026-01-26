// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Vault.sol";

contract VaultTest is Test {
    Vault public vault;
    address public user1;
    address public user2;

    function setUp() public {
        vault = new Vault();
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    function test_deposit() public {
        vm.prank(user1);
        vault.deposit{value: 1 ether}();
        assertEq(vault.balances(user1), 1 ether);
    }

    function test_withdraw() public {
        vm.prank(user1);
        vault.deposit{value: 1 ether}();

        vm.prank(user1);
        vault.withdraw();

        assertEq(vault.balances(user1), 0);
        assertEq(user1.balance, 10 ether);
    }

    function test_multipleUsers() public {
        vm.prank(user1);
        vault.deposit{value: 2 ether}();

        vm.prank(user2);
        vault.deposit{value: 3 ether}();

        assertEq(vault.balances(user1), 2 ether);
        assertEq(vault.balances(user2), 3 ether);
        assertEq(address(vault).balance, 5 ether);
    }
}
