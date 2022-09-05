// Sources flattened with hardhat v2.7.0 https://hardhat.org

// File @openzeppelin/contracts/access/IAccessControl.sol@v4.4.0

// OpenZeppelin Contracts v4.4.0 (access/IAccessControl.sol)

pragma solidity ^0.8.13;

/**
 * @dev External interface of AccessControl declared to support ERC165 detection.
 */
interface IAccessControl {
    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) external view returns (bool);

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {AccessControl-_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) external;
}

// File @openzeppelin/contracts/utils/Context.sol@v4.4.0

// OpenZeppelin Contracts v4.4.0 (utils/Context.sol)

pragma solidity ^0.8.13;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File @openzeppelin/contracts/utils/Strings.sol@v4.4.0

// OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)

pragma solidity ^0.8.13;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

// File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.0

// OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.13;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.0

// OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.13;

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// File @openzeppelin/contracts/access/AccessControl.sol@v4.4.0

// OpenZeppelin Contracts v4.4.0 (access/AccessControl.sol)

pragma solidity ^0.8.13;

/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms. This is a lightweight version that doesn't allow enumerating role
 * members except through off-chain means by accessing the contract event logs. Some
 * applications may benefit from on-chain enumerability, for those cases see
 * {AccessControlEnumerable}.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControl is Context, IAccessControl, ERC165 {
    struct RoleData {
        mapping(address => bool) members;
        bytes32 adminRole;
    }

    mapping(bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with a standardized message including the required role.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     *
     * _Available since v4.1._
     */
    modifier onlyRole(bytes32 role) {
        _checkRole(role, _msgSender());
        _;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view override returns (bool) {
        return _roles[role].members[account];
    }

    /**
     * @dev Revert with a standard message if `account` is missing `role`.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     */
    function _checkRole(bytes32 role, address account) internal view {
        if (!hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: account ",
                        Strings.toHexString(uint160(account), 20),
                        " is missing role ",
                        Strings.toHexString(uint256(role), 32)
                    )
                )
            );
        }
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been revoked `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) public virtual override {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     *
     * NOTE: This function is deprecated in favor of {_grantRole}.
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        bytes32 previousAdminRole = getRoleAdmin(role);
        _roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * Internal function without access restriction.
     */
    function _grantRole(bytes32 role, address account) internal virtual {
        if (!hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * Internal function without access restriction.
     */
    function _revokeRole(bytes32 role, address account) internal virtual {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}

// File @openzeppelin/contracts/security/Pausable.sol@v4.4.0

// OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)

pragma solidity ^0.8.13;

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!paused(), "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(paused(), "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.0

// OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)

pragma solidity ^0.8.13;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File contracts/apestrapv3.sol

// SPDX-License-Identifier: MIT
// ░█████╗░██╗░░██╗░█████╗░░█████╗░░██████╗██████╗░░█████╗░░█████╗░
// ██╔══██╗██║░░██║██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗
// ██║░░╚═╝███████║███████║██║░░██║╚█████╗░██║░░██║███████║██║░░██║
// ██║░░██╗██╔══██║██╔══██║██║░░██║░╚═══██╗██║░░██║██╔══██║██║░░██║
// ╚█████╔╝██║░░██║██║░░██║╚█████╔╝██████╔╝██████╔╝██║░░██║╚█████╔╝
// ░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░╚═════╝░╚═════╝░╚═╝░░╚═╝░╚════╝░
// New contract, new puzzle. If you solve it, you will unlock a secret world.
// 00111 10010 10010 01110 10001 00011 01000 10001 00010 01101 10000 00011 00110 00110 10111 01110 00011 00110 01111 01100 01000 10110 10011
// If you solve the puzzle, contact 0xTaylor
// Twitter: 0xTaylor_ |  Discord: 0xTaylor#0001 | E-mail: 0xTaylor@chaosdao.org
// If you find this contract useful you can donate to me @ 0x8c077d3DF38f1BA73eC83a78a4b59dfF7a47BE8f
/// @title ChaosDAO Moonriver collator payment distribution contract v3
/// @author 0xTaylor
/// @dev Shout out to Polka Haus for all of their support!!!
pragma solidity 0.8.13;

contract ApeStrapper is AccessControl, Pausable, ReentrancyGuard {

    ///// State Variables /////////////////////////////////////////////////////

    address private contractCreator;
    address private constant APESTRAPPER_MULTISIG_ADDRESS 
    = 0x19F54Ecd7d17895fADDb017d901Db551cA59AF75;
    address private constant CHAOSDAO_MULTISIG_ADDRESS 
    = 0x74800569E2cc88A73c6cB234326b95F7aB8293A1;
    bool public initialized = false;
    uint256 private constant CHAOSDAO_ALLOCATION = 12; // 12%
    uint256 private constant MOVR_BONDED = 602;
    uint256 private constant MAX_APES = 20;
    uint256 private initialNumberOfPayees = 0;
    uint256 private numberOfPayees = 0;
    bytes32 private constant APE_ADMIN_ROLE = keccak256("APE_ADMIN_ROLE");
    bytes32 private constant APE_ROLE = keccak256("APE_ROLE");
    string private constant ADD = "ADD";
    string private constant DROP = "DROP";

    mapping(address => uint256) public apeAllocation;
    mapping(address => bool) public apeApproved;

    address[] public apes;

    ///// Events //////////////////////////////////////////////////////////////

    event ApeApproval(address indexed ape, string indexed);
    event ApeApprovalCheck(address indexed ape);
    event Transfer(address indexed ape, uint256 indexed payout);
    event Deposit(address indexed sender, uint256 indexed amount);
    event ApeList(string indexed action, address indexed apeAddress, uint256 indexed apeAllocations);

    ///// Errors //////////////////////////////////////////////////////////////

    error ApeDoesntApprove(address);
    error BalanceUnder1Eth(uint256);
    error Initialized(bool);
    error NotAllApesApprove();
    error NoValue();
    error AddressZeroNotAllowed(address);
    error NoContribution(uint256);
    error TotalsDontAddUp(uint256);
    error TransferFailed(address recipient, uint256 contractBalance, bytes);

    ///// Modifiers ///////////////////////////////////////////////////////////

   modifier isInitialized() {
       // Logic starts here
       if (!initialized) revert Initialized(false);
       _;
   }

    ///// Constructor /////////////////////////////////////////////////////////

    constructor() {
        contractCreator = _msgSender();
        initialNumberOfPayees = 1;
        _grantRole(APE_ADMIN_ROLE, contractCreator);
        _grantRole(APE_ADMIN_ROLE, APESTRAPPER_MULTISIG_ADDRESS);
        _setRoleAdmin(APE_ROLE, APE_ADMIN_ROLE);
        _addApe(CHAOSDAO_MULTISIG_ADDRESS, CHAOSDAO_ALLOCATION * 1e18);
        apeApproved[CHAOSDAO_MULTISIG_ADDRESS] = true;
    }

    ///// Payable Function ////////////////////////////////////////////////////

    /// @notice This function takes deposits.
    /// @notice Contract must not be paused
    function deposit() external payable whenNotPaused {
        // Logic starts here
        if (msg.value == 0) revert NoValue();
        emit Deposit(_msgSender(), msg.value);
    }

    ///// APE_ROLE Function ///////////////////////////////////////////////////

    /// @notice Used by the Ape to signify their approval of the contract
    /// @notice This mapping is set back to false anytime the allocation list is modified
    /// @notice Only APE_ROLE can call approveContract
    function approveContract() external onlyRole(APE_ROLE) {
        // Logic starts here
        if (!apeApproved[_msgSender()]) {
            apeApproved[_msgSender()] = true;
            emit ApeApproval(_msgSender(), "True");
        }
    }

    ///// APE_ADMIN_ROLE Functions ////////////////////////////////////////////

    /// @notice Sets the list of Apes and their allocations. Arrays must be equal length
    /// @notice Contract must not be paused
    /// @notice Only APE_ADMIN_ROLE can calls setApeAllocationList
    /// @param _addresses takes in an array of Ape addresses
    /// @param _contributions takes in an array of Ape contribution
    function setApeAllocationList(
        address[] calldata _addresses, 
        uint256[] calldata _contributions
        )
        external
        whenNotPaused
        onlyRole(APE_ADMIN_ROLE)
        {
            uint256 _numberOfApes = _addresses.length; // Load storage variables we reuse into memory.
            uint256 _totalMovr = 0; // Total is calculated in Wei.
            numberOfPayees = _numberOfApes + initialNumberOfPayees; // Updating state variable
        require(numberOfPayees <= MAX_APES, "Allocation list must be less than or equal to MAX_APES");
        require(_numberOfApes == _contributions.length, "Arrays not equal length");
        // Revokes and removes items from the array if contract was previously initialized
        if (initialized) {
            // Skips the ChaosDAO multi-sig entry at index 0
            for (uint256 i = initialNumberOfPayees; apes.length > i; ) {
                _dropApe(apes[i]);
                unchecked {
                    i++;
                }
            }
        }

        for (uint256 i = 0; _numberOfApes > i; ) {
            address ape = _addresses[i];
            uint256 contribution = _contributions[i];
            if (ape == address(0)) revert AddressZeroNotAllowed(ape);
            if (contribution == 0) revert NoContribution(contribution);
            _addApe(ape, contribution);
            _totalMovr += contribution;
            unchecked {
                ++i;
            }
        }

        if (_totalMovr != (MOVR_BONDED * 1e18)) revert TotalsDontAddUp(_totalMovr);

        if (!initialized) {
            initialized = true;
        }
    }

    /// @notice Will withdraw whatever $MOVR balance is in the account to the ApeStrapper MultiSig Account
    /// @notice Only the APE_ADMIN_ROLE can call emergencyWithdraw
    function emergencyWithdraw() external onlyRole(APE_ADMIN_ROLE) {
        // Logic starts here
        if (address(this).balance == 0) revert NoValue();
        _sendNanners(payable(address(APESTRAPPER_MULTISIG_ADDRESS)), address(this).balance);
    }

    /// @notice Used to pause the contract if necessary
    /// @notice Only the APE_ADMIN_ROLE can call pause
    function pause() external onlyRole(APE_ADMIN_ROLE) {
        _pause();
    }

    /// @notice Used to unpause the contract if necessary
    /// @notice Only the APE_ADMIN_ROLE can call pause
    function unpause() external onlyRole(APE_ADMIN_ROLE) {
        _unpause();
    }

    /// @notice Revokes the contractCreators access to modify the configuration of this contract.
    /// @notice Can be called by either the contractCreator or the APESTRAPPER_MULTISIG_ADDRESS
    function revokeContractCreatorAccess() external onlyRole(APE_ADMIN_ROLE) isInitialized {
        // Logic starts here
        renounceRole(APE_ADMIN_ROLE, contractCreator);
    }

    ///// External Function ///////////////////////////////////////////////////

    /// @notice This function pays everyone who has an allocation, emptying the contract balance
    /// @notice Anyone can call this function but the depositer will usually be the one to call it.
    /// @notice Contract must have at least one $MOVR in the contract (ether in this context)
    /// @notice Contract cannot be paused, must be initialized, and all Apes must approve
    /// @notice Function uses reentrancyGuard
    function nannerTime() external whenNotPaused isInitialized nonReentrant {
        // Logic starts here
        // Revert if the contract balance is less than 1 Ether.
        if (address(this).balance < 1 ether) revert BalanceUnder1Eth(address(this).balance);
     //   if(!allApesApprove()) revert NotAllApesApprove(); // Function reverts if any ape has not approved
        allApesApprove();
        uint256 currentBalance = address(this).balance;
        // Starts at array object 1 as 0 is the ChaosDAO multi-sig address. Will pay that out at the end.
        for (uint256 i = 1; apes.length > i; ) {
            address ape = apes[i];
            uint256 allocation = apeAllocation[ape];
            uint256 payout = ((currentBalance * allocation) / 100e18);
            _sendNanners(ape, payout);
            unchecked {
                ++i;
            }
        }
        // Send ChaosDAO multi-sig the rest of the balance left in the contract to clear any rounding dust
        _sendNanners(apes[0], address(this).balance);
    }

    ///// External/Public View Functions //////////////////////////////////////

    function allApesApprove() public view returns (bool) {
        if (numberOfPayees <= 1) return false;
        for (uint256 i = 0; numberOfPayees > i; ) {
            // Logic starts here
            if (!apeApproved[apes[i]]) revert ApeDoesntApprove(apes[i]);
            unchecked {
                i++;
            }
        }
        return true;
    }

    function getBalance() external view returns (uint256 _balance) {
        return address(this).balance;
    }

    ///// Public Pure Functions ///////////////////////////////////////////////

    function calculatePortion(uint256 _contribution) public pure returns (uint256 _portion) {
        return ((_contribution * (100 - CHAOSDAO_ALLOCATION)) / MOVR_BONDED);
    }

    ///// Internal Functions //////////////////////////////////////////////////

    function _addApe(address _ape, uint256 _contribution) private {
        apeApproved[_ape] = false;
        apeAllocation[_ape] = calculatePortion(_contribution);
        apes.push(_ape);
        grantRole(APE_ROLE, _ape);
        emit ApeList(ADD, _ape, apeAllocation[_ape]);
    }

    function _dropApe(address _ape) private {
        apeApproved[_ape] = false;
        apes.pop();
        revokeRole(APE_ROLE, _ape);
        emit ApeList(DROP, _ape, uint256(0));
    }

    function _sendNanners(address _recipient, uint256 _amount) private {
        emit Transfer(_recipient, _amount);
        (bool _success, bytes memory _error) = payable(_recipient).call{ value: _amount }("");
        if (!_success) revert TransferFailed(address(_recipient), _amount, _error);
    }
}
