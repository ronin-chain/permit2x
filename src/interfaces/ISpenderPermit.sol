// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISpenderPermit {
    /**
     * @dev Emitted when `account` is permitted or unpermitted to be a spender.
     *
     * @param caller The account that originated the contract call, is always the current owner
     * @param permitFlag The new value of the permit flag
     */
    event SpenderPermitUpdated(address indexed account, address indexed caller, bool permitFlag);

    /**
     * @dev Emitted when arbitrary addresses are permitted to be spenders.
     *
     * This happens when the admin renounces the ownership of the contract.
     */
    event AllSpendersPermitted();

    /**
     * @dev The `account` is not permitted to spend.
     */
    error SpenderIsNotPermitted(address account);

    /**
     * @dev Returns `true` if `account` is permitted to spend.
     * @param account The address to check
     */
    function isPermittedSpender(address account) external view returns (bool);

    /**
     * @dev Allows the caller to permit `account` to be a spender.
     * @param account The address to permit
     */
    function permitSpender(address account, bool isPermitted) external;

    /**
     * @dev Returns `true` if arbitrary addresses are allowed to be spenders.
     */
    function areAllSpendersPermitted() external view returns (bool);
}
