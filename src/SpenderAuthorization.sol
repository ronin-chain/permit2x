// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ISpenderAuthorization} from "./interfaces/ISpenderAuthorization.sol";

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

abstract contract SpenderAuthorization is ISpenderAuthorization, Ownable {
    /// @dev Mapping of addresses allowed to spend.
    mapping(address => bool) private _spenders;
    /// @dev Whether arbitrary addresses are allowed to spend.
    bool private _allSpendersAllowed = false;

    modifier onlyGrantedSpender(address spender) {
        _checkSpender(spender);
        _;
    }

    /// @inheritdoc ISpenderAuthorization
    function isSpender(address account) public view virtual returns (bool) {
        return _allSpendersAllowed || _spenders[account];
    }

    /// @inheritdoc ISpenderAuthorization
    function grantSpender(address account) external virtual onlyOwner {
        _spenders[account] = true;
        emit SpenderGranted(account, msg.sender);
    }

    /// @inheritdoc ISpenderAuthorization
    function revokeSpender(address account) external virtual onlyOwner {
        _spenders[account] = false;
        emit SpenderRevoked(account, msg.sender);
    }

    /// @inheritdoc ISpenderAuthorization
    function areAllSpendersAllowed() public view virtual returns (bool) {
        return _allSpendersAllowed;
    }

    /// @inheritdoc Ownable
    /// @dev Allows arbitrary addresses to be spenders.
    function renounceOwnership() public virtual override {
        super.renounceOwnership();

        _allSpendersAllowed = true;
        emit AllSpendersAllowed();
    }

    /// @dev Checks if the spender is allowed to spend.
    function _checkSpender(address spender) internal view {
        if (!isSpender(spender)) {
            revert SpenderAuthorizationUnauthorizedSpender(spender);
        }
    }
}
