// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "src/BoxV1.sol";
import {BoxV2} from "src/BoxV2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBox is Script {
    function run() external returns (address) {
        address proxy = deployBox();
        return proxy;
    }

    function deployBox() public returns (address) {
        vm.startBroadcast();
        BoxV1 boxV1 = new BoxV1(); // Implementation (Logic)
        ERC1967Proxy proxy = new ERC1967Proxy(address(boxV1), "");
        BoxV1(address(proxy)).initialize();
        vm.stopBroadcast();
        return address(proxy);
    }
}
