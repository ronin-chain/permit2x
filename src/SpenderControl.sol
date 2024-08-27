// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ISpenderControl} from "./interfaces/ISpenderControl.sol";

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

abstract contract SpenderControl is ISpenderControl, Ownable {
    /// @dev Mapping of addresses allowed to spend.
    mapping(address => bool) private _spenders;
    /// @dev Whether arbitrary addresses are allowed to spend.
    bool private _allSpendersAllowed = false;

    modifier onlyGrantedSpender(address spender) {
        _checkSpender(spender);
        _;
    }

    /// @inheritdoc ISpenderControl
    function isSpender(address account) public view virtual returns (bool) {
        return _allSpendersAllowed || _spenders[account];
    }

    /// @inheritdoc ISpenderControl
    function grantSpender(address account) external virtual onlyOwner {
        _spenders[account] = true;
        emit SpenderGranted(account, msg.sender);
    }

    /// @inheritdoc ISpenderControl
    function revokeSpender(address account) external virtual onlyOwner {
        _spenders[account] = false;
        emit SpenderRevoked(account, msg.sender);
    }

    /// @inheritdoc ISpenderControl
    function areAllSpendersAllowed() public view virtual returns (bool) {
        return _allSpendersAllowed;
    }

    /// @inheritdoc Ownable
    /// @dev Allows arbitrary addresses to be spenders.
    function renounceOwnership() public override {
        super.renounceOwnership();

        _allSpendersAllowed = true;
        emit AllSpendersAllowed();
    }

    /// @dev Checks if the spender is allowed to spend.
    function _checkSpender(address spender) internal view {
        if (!isSpender(spender)) {
            revert SpenderControlUnauthorizedSpender(spender);
        }
    }
}
