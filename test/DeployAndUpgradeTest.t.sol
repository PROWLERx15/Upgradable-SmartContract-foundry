// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "script/DeployBox.s.sol";
import {UpgradeBox} from "script/UpgradeBox.s.sol";
import {BoxV1} from "src/BoxV1.sol";
import {BoxV2} from "src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public proxy;

    address public OWNER = makeAddr("owner");

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run(); // right now, points to BoxV1
    }

    function testProxyStartsAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(10);
    }

    function testUpgrades() public {
        BoxV2 boxV2 = new BoxV2();

        upgrader.upgradeBox(proxy, address(boxV2));

        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).version());

        BoxV2(proxy).setNumber(10);
        assertEq(10, BoxV2(proxy).getNumber());
    }
}
