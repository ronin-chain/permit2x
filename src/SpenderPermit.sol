// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ISpenderPermit} from "./interfaces/ISpenderPermit.sol";

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

abstract contract SpenderPermit is ISpenderPermit, Ownable {
    /// @dev Mapping of addresses allowed to spend.
    mapping(address => bool) private _spenderPermitFlags;
    /// @dev Whether arbitrary addresses are allowed to spend. Default is `false`.
    bool private _allSpendersPermitted;

    modifier onlyPermittedSpender(address spender) {
        _requirePermittedSpender(spender);
        _;
    }

    /// @inheritdoc ISpenderPermit
    function isPermittedSpender(address account) public view virtual returns (bool) {
        return _allSpendersPermitted || _spenderPermitFlags[account];
    }

    /// @inheritdoc ISpenderPermit
    function permitSpender(address account, bool isPermitted) external virtual onlyOwner {
        _spenderPermitFlags[account] = isPermitted;
        emit SpenderPermitUpdated(account, msg.sender, isPermitted);
    }

    /// @inheritdoc ISpenderPermit
    function areAllSpendersPermitted() public view virtual returns (bool) {
        return _allSpendersPermitted;
    }

    /// @inheritdoc Ownable
    /// @dev Allows arbitrary addresses to be spenders.
    function renounceOwnership() public virtual override {
        super.renounceOwnership();

        _allSpendersPermitted = true;
        emit AllSpendersPermitted();
    }

    /// @dev Checks if the spender is allowed to spend.
    function _requirePermittedSpender(address spender) internal view {
        if (!isPermittedSpender(spender)) {
            revert SpenderIsNotPermitted(spender);
        }
    }
}
