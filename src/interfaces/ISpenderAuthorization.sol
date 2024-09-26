// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISpenderAuthorization {
    /**
     * @dev Emitted when `account` is granted as a spender.
     *
     * @param caller is the account that originated the contract call, the owner.
     */
    event SpenderGranted(address indexed account, address indexed caller);

    /**
     * @dev Emitted when `account` is revoked as a spender.
     *
     * @param caller is the account that originated the contract call, the owner.
     */
    event SpenderRevoked(address indexed account, address indexed caller);

    /**
     * @dev Emitted when arbitrary addresses are allowed to spend.
     *
     * This happens when the admin renounces the ownership of the contract.
     */
    event AllSpendersAllowed();

    /**
     * @dev The `account` is not a spender.
     */
    error SpenderAuthorizationUnauthorizedSpender(address account);

    /**
     * @dev Returns `true` if `account` has been granted as a spender.
     * @param account The address to check
     */
    function isSpender(address account) external view returns (bool);

    /**
     * @dev Grants the spender role to an account.
     *
     * Requirements:
     *  - The caller must be the owner.
     *
     * @param account The address to grant the spender role
     */
    function grantSpender(address account) external;

    /**
     * @dev Revokes the spender role from an account.
     *
     * Requirements:
     * - The caller must be the owner.
     *
     * @param account The address to revoke the spender role
     */
    function revokeSpender(address account) external;

    /**
     * @dev Returns `true` if arbitrary addresses are allowed to be spenders.
     */
    function areAllSpendersAllowed() external view returns (bool);
}
