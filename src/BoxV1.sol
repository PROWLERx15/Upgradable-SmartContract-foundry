// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// We can't use constructor with our proxies
// Storage is stored in the proxy, NOT the implementation
// Proxy (Borrowing Functions) -> Implementation
// Proxy -> deploy implementation -> call some "initializer" function

contract BoxV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 internal number;

    // @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init(msg.sender); // double underscrore for initialzer function | sets the owner to msg.msg.sender
        __UUPSUpgradeable_init();
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}
