// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {MockPermit2} from "./mocks/MockPermit2.sol";
import {TokenProvider} from "./utils/TokenProvider.sol";
import {SpenderPermit} from "../src/SpenderPermit.sol";

contract SpenderPermitTest is Test, TokenProvider {
    MockPermit2 permit2;
    SpenderPermit spenderControl;

    address from = address(0x1);
    address spender = address(0x2);
    address other = address(0x3);

    function setUp() public {
        permit2 = new MockPermit2();
        spenderControl = SpenderPermit(address(permit2));
        initializeERC20Tokens();
    }

    function test_areAllSpendersPermitted() public {
        assertFalse(spenderControl.areAllSpendersPermitted());
        spenderControl.renounceOwnership();
        assertTrue(spenderControl.areAllSpendersPermitted());
    }

    function test_isPermittedSpender() public {
        assertFalse(spenderControl.areAllSpendersPermitted());
        assertFalse(spenderControl.isPermittedSpender(spender));
        spenderControl.permitSpender(spender, true);
        assertTrue(spenderControl.isPermittedSpender(spender));
    }

    function test_isPermittedSpender_WhenAllSpendersAllowed() public {
        spenderControl.renounceOwnership();
        assertTrue(spenderControl.areAllSpendersPermitted());
        assertTrue(spenderControl.isPermittedSpender(spender));
    }

    function test_permitSpender() public {
        spenderControl.permitSpender(spender, true);
        assertTrue(spenderControl.isPermittedSpender(spender));
    }

    function test_revokeSpender() public {
        spenderControl.permitSpender(spender, true);
        spenderControl.permitSpender(spender, false);
        assertFalse(spenderControl.isPermittedSpender(spender));
    }

    function test_renounceOwnership() public {
        spenderControl.renounceOwnership();
        vm.expectRevert("Ownable: caller is not the owner");
        spenderControl.permitSpender(spender, true);
        vm.expectRevert("Ownable: caller is not the owner");
        spenderControl.permitSpender(spender, false);
    }

    function test_permitSpender_RevertIfCallerIsNotOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(other);
        spenderControl.permitSpender(spender, true);
    }

    function test_revokeSpender_RevertIfCallerIsNotOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(other);
        spenderControl.permitSpender(spender, false);
    }

    function test_renounceOwnership_RevertIfCallerIsNotOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(other);
        spenderControl.renounceOwnership();
        assertFalse(spenderControl.areAllSpendersPermitted());
    }
}
