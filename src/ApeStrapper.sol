import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/IAccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

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

    address private immutable contractCreator;
    address private constant APESTRAPPER_MULTISIG_ADDRESS = 0x19F54Ecd7d17895fADDb017d901Db551cA59AF75;
    address private constant CHAOSDAO_MULTISIG_ADDRESS = 0x74800569E2cc88A73c6cB234326b95F7aB8293A1;
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
    event Transfer(address indexed ape, uint256 payout);
    event Deposit(address indexed sender, uint256 amount);
    event ApeList(string indexed action, address indexed apeAddress, uint256 apeAllocations);

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
        if (!initialized) {
            revert Initialized(false);
        }
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
        if (msg.value == 0) {
            revert NoValue();
        }
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
    function setApeAllocationList(address[] calldata _addresses, uint256[] calldata _contributions)
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
            for (uint256 i = initialNumberOfPayees; apes.length > i;) {
                _dropApe(apes[i]);
                unchecked {
                    i++;
                }
            }
        }

        for (uint256 i = 0; _numberOfApes > i;) {
            address ape = _addresses[i];
            uint256 contribution = _contributions[i];
            if (ape == address(0)) {
                revert AddressZeroNotAllowed(ape);
            }
            if (contribution == 0) {
                revert NoContribution(contribution);
            }
            _addApe(ape, contribution);
            _totalMovr += contribution;
            unchecked {
                ++i;
            }
        }

        if (_totalMovr != (MOVR_BONDED * 1e18)) {
            revert TotalsDontAddUp(_totalMovr);
        }

        if (!initialized) {
            initialized = true;
        }
    }

    /// @notice Will withdraw whatever $MOVR balance is in the account to the ApeStrapper MultiSig Account
    /// @notice Only the APE_ADMIN_ROLE can call emergencyWithdraw
    function emergencyWithdraw() external onlyRole(APE_ADMIN_ROLE) {
        // Logic starts here
        if (address(this).balance == 0) {
            revert NoValue();
        }
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
        if (address(this).balance < 1 ether) {
            revert BalanceUnder1Eth(address(this).balance);
        }
        //   if(!allApesApprove()) revert NotAllApesApprove(); // Function reverts if any ape has not approved
        allApesApprove();
        uint256 currentBalance = address(this).balance;
        // Starts at array object 1 as 0 is the ChaosDAO multi-sig address. Will pay that out at the end.
        for (uint256 i = 1; apes.length > i;) {
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
        if (numberOfPayees <= 1) {
            return false;
        }
        for (uint256 i = 0; numberOfPayees > i;) {
            // Logic starts here
            if (!apeApproved[apes[i]]) {
                revert ApeDoesntApprove(apes[i]);
            }
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
        (bool _success, bytes memory _error) = payable(_recipient).call{value: _amount}("");
        if (!_success) {
            revert TransferFailed(address(_recipient), _amount, _error);
        }
    }
}
