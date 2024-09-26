// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {MockPermit2} from "./mocks/MockPermit2.sol";
import {TokenProvider} from "./utils/TokenProvider.sol";
import {SpenderAuthorization} from "../src/SpenderAuthorization.sol";

contract SpenderAuthorizationTest is Test, TokenProvider {
    MockPermit2 permit2;
    SpenderAuthorization spenderControl;

    address from = address(0x1);
    address spender = address(0x2);
    address other = address(0x3);

    function setUp() public {
        permit2 = new MockPermit2();
        spenderControl = SpenderAuthorization(address(permit2));
        initializeERC20Tokens();
    }

    function test_areAllSpendersAllowed() public {
        assertFalse(spenderControl.areAllSpendersAllowed());
        spenderControl.renounceOwnership();
        assertTrue(spenderControl.areAllSpendersAllowed());
    }

    function test_isSpender() public {
        assertFalse(spenderControl.areAllSpendersAllowed());
        assertFalse(spenderControl.isSpender(spender));
        spenderControl.grantSpender(spender);
        assertTrue(spenderControl.isSpender(spender));
    }

    function test_isSpender_WhenAllSpendersAllowed() public {
        spenderControl.renounceOwnership();
        assertTrue(spenderControl.areAllSpendersAllowed());
        assertTrue(spenderControl.isSpender(spender));
    }

    function test_grantSpender() public {
        spenderControl.grantSpender(spender);
        assertTrue(spenderControl.isSpender(spender));
    }

    function test_revokeSpender() public {
        spenderControl.grantSpender(spender);
        spenderControl.revokeSpender(spender);
        assertFalse(spenderControl.isSpender(spender));
    }

    function test_renounceOwnership() public {
        spenderControl.renounceOwnership();
        vm.expectRevert("Ownable: caller is not the owner");
        spenderControl.grantSpender(spender);
        vm.expectRevert("Ownable: caller is not the owner");
        spenderControl.revokeSpender(spender);
    }

    function test_grantSpender_RevertIfCallerIsNotOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(other);
        spenderControl.grantSpender(spender);
    }

    function test_revokeSpender_RevertIfCallerIsNotOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(other);
        spenderControl.revokeSpender(spender);
    }

    function test_renounceOwnership_RevertIfCallerIsNotOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(other);
        spenderControl.renounceOwnership();
        assertFalse(spenderControl.areAllSpendersAllowed());
    }
}
