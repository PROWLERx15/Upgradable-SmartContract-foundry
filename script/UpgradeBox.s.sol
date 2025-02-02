// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BoxV1} from "src/BoxV1.sol";
import {BoxV2} from "src/BoxV2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        BoxV2 boxV2 = new BoxV2();
        vm.stopBroadcast();
        address proxy = upgradeBox(mostRecentlyDeployed, address(boxV2));
        return proxy;
    }

    function upgradeBox(address proxyAddress, address boxV2) public returns (address) {
        vm.startBroadcast();
        BoxV1 proxy = BoxV1(proxyAddress);
        proxy.upgradeToAndCall(address(boxV2), ""); // proxy contract now points to this new address
        vm.stopBroadcast();
        return address(proxy);
    }
}
