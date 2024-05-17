// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import {BaseTest} from "./Base.t.sol";

import {IERC721Errors} from "@openzeppelin/contracts@5.0.2/token/ERC721/ERC721.sol";

contract View is BaseTest {
    function test_TokenURI_RevertWhen_NotExists() public {
        vm.expectRevert(abi.encodeWithSelector(IERC721Errors.ERC721NonexistentToken.selector, 12121));
        nft.tokenURI(12121);
    }
}
