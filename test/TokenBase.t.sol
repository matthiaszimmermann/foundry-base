// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC1967} from "@openzeppelin/contracts/interfaces/IERC1967.sol";
import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {Test, Vm, console} from "forge-std/Test.sol";

import {Token} from "../src/Token.sol";

contract TokenTestBase is Test {
    Token token;
    address deployer = makeAddr("deployer");
    ProxyAdmin proxyAdmin = ProxyAdmin(address(0));

    function setUp() public {
        // Deploy the initial implementation
        Token implementation = new Token();

        // Initialize the proxy (deployer is proxy admin)
        bytes memory data = abi.encodeWithSignature("initialize(string,string,address)", "MyToken", "MTK", deployer);

        vm.recordLogs();
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(address(implementation), deployer, data);

        proxyAdmin = _getProxyAdmin(vm.getRecordedLogs());
        assertTrue(address(proxyAdmin) != address(0));

        // Use the proxy as the token
        token = Token(address(proxy));

        console.log("deployer", deployer);
        console.log("Token (proxy)", address(token));
        console.log("ProxyAdmin", address(proxyAdmin));
        console.log("ProxyAdmin owner", proxyAdmin.owner());
    }

    function _getProxyAdmin(Vm.Log[] memory logs) internal pure returns (ProxyAdmin admin) {
        for (uint256 i; i < logs.length; i++) {
            if (logs[i].topics[0] == IERC1967.AdminChanged.selector) {
                (, address adminAddress) = abi.decode(logs[i].data, (address, address));
                return ProxyAdmin(adminAddress);
            }
        }
    }

    function _fund(address account, uint256 amount) internal {
        vm.startPrank(deployer);
        token.transfer(account, amount);
        vm.stopPrank();
    }

    function _defund(address account) internal {
        vm.startPrank(account);
        token.transfer(deployer, token.balanceOf(account));
        vm.stopPrank();
    }
}
