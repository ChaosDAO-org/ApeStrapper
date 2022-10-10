import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/IAccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// SPDX-License-Identifier: MIT
// ░█████╗░██╗░░██╗░█████╗░░█████╗░░██████╗██████╗░░█████╗░░█████╗░
// ██╔══██╗██║░░██║██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗
// ██║░░╚═╝███████║███████║██║░░██║╚█████╗░██║░░██║███████║██║░░██║
// ██║░░██╗██╔══██║██╔══██║██║░░██║░╚═══██╗██║░░██║██╔══██║██║░░██║
// ╚█████╔╝██║░░██║██║░░██║╚█████╔╝██████╔╝██████╔╝██║░░██║╚█████╔╝
// ░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░╚═════╝░╚═════╝░╚═╝░░╚═╝░╚════╝░
// New contract, new puzzle. If you solve it, you will unlock a secret world.
// 00111 10010 10010 01110 10001 00011 01000 10001 00010 01101 10000 00011
// 00110 00110 10111 01110 00011 00110 01111 01100 01000 10110 10011
// If you solve the puzzle, contact 0xTaylor
// Twitter: 0xTaylor_ |  Discord: 0xTaylor#0001 | E-mail: 0xTaylor@chaosdao.org
// If you find this contract useful you can donate to me @ 0x8c077d3DF38f1BA73eC83a78a4b59dfF7a47BE8f
/// @title ChaosDAO Moonriver collator payment distribution contract v3
/// @author 0xTaylor
/// @dev Shout out to Polka Haus for all of their support!!!

//slither-disable-next-line solc-version
pragma solidity 0.8.13;
contract ApeStrapper is AccessControl, ReentrancyGuard, Pausable {

    /*//////////////////////////////////////////////////////////////
                           STATE VARIABLES          
    //////////////////////////////////////////////////////////////*/

    address private constant APESTRAPPER_MULTISIG_ADDRESS = 0x19F54Ecd7d17895fADDb017d901Db551cA59AF75;
    address private constant CHAOSDAO_MULTISIG_ADDRESS = 0x74800569E2cc88A73c6cB234326b95F7aB8293A1;
    uint256 private constant CHAOSDAO_ALLOCATION = 12; // 12%
    uint256 private constant MAX_APES = 20;
    uint256 private constant MOVR_BONDED = 602;
    bytes32 private constant APE_ADMIN_ROLE = keccak256("APE_ADMIN_ROLE");
    bytes32 private constant APE_ROLE = keccak256("APE_ROLE");
    string private constant ADD = "ADD";
    string private constant DROP = "DROP";

    address private immutable contractCreator;
    bool public initialized = false;
    uint8 private initialNumberOfPayees = 0;

    mapping(address => uint256) public apeAllocation;
    mapping(address => bool) public apeApproved;
    address[] public apes;

    /*//////////////////////////////////////////////////////////////
                               EVENTS          
    //////////////////////////////////////////////////////////////*/

    event ApeApproval(address indexed ape, string indexed);
    event ApeList(string indexed action, address indexed apeAddress, uint256 apeAllocations);
    event Deposit(address indexed sender, uint256 amount);
    event Transfer(address indexed ape, uint256 payout);

    /*//////////////////////////////////////////////////////////////
                               ERRORS          
    //////////////////////////////////////////////////////////////*/

    error AddressZeroNotAllowed(address);
    error ApeDoesntApprove(address);
    error ArraysNotEqualLength(uint256, uint256);
    error BalanceUnder1Eth(uint256);
    error ContractsNotAllowed(address origin, address sender);
    error Initialized(bool);
    error NoContribution(uint256);
    error NoValue();
    error TooManyApes(uint256 _sumTotal, uint256 _numberOfApes);
    error NotEnoughApes(uint256 _numberOfApes);
    error TotalsDontAddUp(uint256);
    error TransferFailed(address recipient, uint256 contractBalance, bytes _error);

    /*//////////////////////////////////////////////////////////////
                              MODIFIERS          
    //////////////////////////////////////////////////////////////*/

    modifier isInitialized() {
        if (!initialized) {
            revert Initialized(false);
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR           
    //////////////////////////////////////////////////////////////*/

    constructor() {
        // Effects
        contractCreator = msg.sender;
        initialNumberOfPayees = 1;
        _grantRole(APE_ADMIN_ROLE, contractCreator);
        _grantRole(APE_ADMIN_ROLE, APESTRAPPER_MULTISIG_ADDRESS);
        _setRoleAdmin(APE_ROLE, APE_ADMIN_ROLE);
        _addApe(CHAOSDAO_MULTISIG_ADDRESS, CHAOSDAO_ALLOCATION * 1e18);
        apeApproved[CHAOSDAO_MULTISIG_ADDRESS] = true;
    }

    /*//////////////////////////////////////////////////////////////
                          PAYABLE FUNCTION          
   //////////////////////////////////////////////////////////////*/

    /// @notice This function takes deposits.
    /// @notice Contract must not be paused
    function deposit() external payable whenNotPaused {
        // Checks
        if (msg.value == 0) {
            revert NoValue();
        }
        // Effects
        emit Deposit(msg.sender, msg.value);
    }

    /*//////////////////////////////////////////////////////////////
                           APE_ROLE FUNCTION                      
    //////////////////////////////////////////////////////////////*/

    /// @notice Used by the Ape to signify their approval of the contract
    /// @notice This mapping is set back to false anytime the allocation list is modified
    /// @dev Only APE_ROLE can call approveContract
    /// @dev only EOA's can call this function.
    function approveContract() external onlyRole(APE_ROLE) {
        // Checks
        if (tx.origin != msg.sender) {
            revert ContractsNotAllowed(tx.origin, msg.sender);
        }
        // Checks
        if (!apeApproved[msg.sender]) {
            // Effects
            apeApproved[msg.sender] = true;
            emit ApeApproval(msg.sender, "True");
        }
    }
    /*//////////////////////////////////////////////////////////////
                      APE_ADMIN_ROLE FUNCTIONS          
    //////////////////////////////////////////////////////////////*/

    /// @notice Sets the list of Apes and their allocations. Arrays must be == length
    /// @notice Contract must not be paused
    /// @notice Only APE_ADMIN_ROLE can calls setApeAllocationList
    /// @param _contributors takes in an address array of Ape addresses
    /// @param _contributions takes in an uint256 array of Ape contributions
    //slither-disable-next-line naming-convention
    function setApeAllocationList(address[] calldata _contributors, uint256[] calldata _contributions)
        external
        whenNotPaused
        onlyRole(APE_ADMIN_ROLE)
    {
        /// @notice Do this to prevent future SLOADs in this scope
        uint256 _numberOfApes = _contributors.length;
        uint256 _apeContributions = _contributions.length;

        // Checks
        if (_numberOfApes != _apeContributions) {
            revert ArraysNotEqualLength(_numberOfApes, _apeContributions);
        }
        // Checks
        require(_numberOfApes + initialNumberOfPayees <= MAX_APES, "Too many apes");

        /// @notice Total is calculated in Wei.
        uint256 _totalMovr = 0;
        // Checks
        if (initialized) {
            // Effects
            /// @notice Revokes and removes items from the array if contract was previously initialized
            _clearApeAllocationList();
        }

        for (uint256 i = 0; _numberOfApes > i;) {
            address ape = _contributors[i];
            uint256 contribution = _contributions[i];
            // Checks
            if (ape == address(0)) {
                revert AddressZeroNotAllowed(ape);
            }
            // Checks
            if (contribution == 0) {
                revert NoContribution(contribution);
            }
            // Effects
            _addApe(ape, contribution);
            _totalMovr += contribution;
            unchecked {
                ++i;
            }
        }
        // Checks
        if (_totalMovr != (MOVR_BONDED * 1e18)) {
            revert TotalsDontAddUp(_totalMovr);
        }
        // Checks
        if (!initialized) {
            // Effects
            initialized = true;
        }
    }

    /// @notice Will withdraw whatever $MOVR balance is in the account to the ApeStrapper MultiSig Account
    /// @notice Only the APE_ADMIN_ROLE can call emergencyWithdraw
    function emergencyWithdraw() external onlyRole(APE_ADMIN_ROLE) {
        // Checks
        //slither-disable-next-line incorrect-equality
        if (address(this).balance == 0) {
            revert NoValue();
        }
        // Interactions
        _sendNanners(payable(APESTRAPPER_MULTISIG_ADDRESS), address(this).balance);
    }

    /// @notice Used to pause the contract if necessary
    /// @notice Only the APE_ADMIN_ROLE can call pause
    function pause() external onlyRole(APE_ADMIN_ROLE) {
        // Effects
        _pause();
    }

    /// @notice Revokes the contractCreators access to modify the configuration of this contract.
    /// @notice Can be called by either the contractCreator or the APESTRAPPER_MULTISIG_ADDRESS
    function revokeContractCreatorAccess() external onlyRole(APE_ADMIN_ROLE) isInitialized {
        // Effects
        renounceRole(APE_ADMIN_ROLE, contractCreator);
    }

    /// @notice Used to unpause the contract if necessary
    /// @notice Only the APE_ADMIN_ROLE can call pause
    function unpause() external onlyRole(APE_ADMIN_ROLE) {
        // Effects
        _unpause();
    }

    /*//////////////////////////////////////////////////////////////
                           EXTERNAL FUNCTION          
    //////////////////////////////////////////////////////////////*/

    /// @notice This function pays everyone who has an allocation, emptying the contract balance
    /// @notice Anyone can call this function but the depositer will usually be the one to call it.
    /// @notice Contract must have at least one $MOVR in the contract (ether in this context)
    /// @notice Contract cannot be paused, must be initialized, and all Apes must approve
    /// @notice Function uses reentrancyGuard
    function nannerTime() external whenNotPaused isInitialized nonReentrant {
        // Checks
        /// @notice Revert if the contract balance is less than 1 Ether.
        if (address(this).balance < 1 ether) {
            revert BalanceUnder1Eth(address(this).balance);
        }
        // Checks
        /// @notice Verify that all apes approve
        allApesApprove();
        uint256 _apes = apes.length;
        // Effects
        uint256 currentBalance = address(this).balance;
        /// @notice Starts at array object 1 as 0 is the ChaosDAO multi-sig address. Will pay that out at the end.
        for (uint256 i = initialNumberOfPayees; _apes > i;) {
            address ape = apes[i];
            uint256 allocation = apeAllocation[ape];
            uint256 payout = ((currentBalance * allocation) / 100e18);
            // Interactions
            _sendNanners(ape, payout);
            unchecked {
                ++i;
            }
        }
        // Interactions
        /// @notice Sends ChaosDAO multi-sig the rest of the balance left in the contract to clear any rounding dust
        _sendNanners(apes[0], address(this).balance);
    }

    /*//////////////////////////////////////////////////////////////
                          INTERNAL FUNCTIONS          
    //////////////////////////////////////////////////////////////*/

    /// @dev Internal functions do not have access control checks as those
    /// @dev checks are handled in the external functions.
    function _addApe(address _ape, uint256 _contribution) private {
        // Effects
        apeApproved[_ape] = false;
        apeAllocation[_ape] = calculatePortion(_contribution);
        apes.push(_ape);
        grantRole(APE_ROLE, _ape);
        emit ApeList(ADD, _ape, apeAllocation[_ape]);
    }

    /// @dev This function is only ever used in the process of removing all apes.
    /// @dev You can only safely call into this ape to remove on member,
    /// @dev if they are the last item in the array.
    /// @param _ape The address of the Ape to remove.
    function _dropApe(address _ape) private {
        // Effects
        apeApproved[_ape] = false;
        apes.pop();
        revokeRole(APE_ROLE, _ape);
        emit ApeList(DROP, _ape, uint256(0));
    }

    /// @param _recipient Which Ape the nanners belog to.
    /// @param _amount How man nanners to send to the Ape.
    //slither-disable-next-line calls-loop arbitrary-send-eth
    function _sendNanners(address _recipient, uint256 _amount) private {
        // Effects
        emit Transfer(_recipient, _amount);
        // Interactions
        //slither-disable-next-line low-level-calls arbitrary-send-eth
        (bool _success, bytes memory _error) = payable(_recipient).call{value: _amount}("");
        // Checks on Interactions
        if (!_success) {
            revert TransferFailed(address(_recipient), _amount, _error);
        }
    }

    /// @notice Clears all apes except for the ChaosDAO mutli-sig from the allocation list
    //function _clearApeAllocationList() private { !!!!!!!!! CHANGE BACK!!!!!!!
    function _clearApeAllocationList() public {
        /// @notice saves on the sloads
        uint256 _apesLength = apes.length;
        /// @notice Skips the ChaosDAO multi-sig entry at index 0
        for (uint256 i = initialNumberOfPayees; _apesLength > 4;) {
            // Effects
            _dropApe(apes[i]);
            unchecked {
                i++;
            }
        }
    }

    /*//////////////////////////////////////////////////////////////
                   EXTERNAL/PUBLIC VIEW FUNCTIONS          
    //////////////////////////////////////////////////////////////*/

    /// @notice returns true only if all apes approve and there is more than 1 ape in the contract.
    /// @return approve true/false if all apes approve
    function allApesApprove() public view returns (bool approve) {
        /// @notice Load storage variables we reuse into memory.
        uint256 _numberOfApes = apes.length;
        // Checks
        if (_numberOfApes <= 1) {
            revert NotEnoughApes(_numberOfApes);
        }
        for (uint256 i = 0; _numberOfApes > i;) {
            // Checks
            if (!apeApproved[apes[i]]) {
                revert ApeDoesntApprove(apes[i]);
            }
            unchecked {
                i++;
            }
        }
        return true;
    }
    /// @notice gets MOVR$ balance
    /// @return _balance Returns the MOVR balance in the contract

    function getBalance() external view returns (uint256 _balance) {
        return address(this).balance;
    }

    /*//////////////////////////////////////////////////////////////
                         PUBLIC PURE FUNCTIONS            
    //////////////////////////////////////////////////////////////*/

    /// @notice Calculates the percentage of an Apes share in relation to their contribution.
    /// @param _contribution in WEI
    /// @return _portion what percentage of the allocation you will receive
    //slither-disable-next-line naming-convention
    function calculatePortion(uint256 _contribution) public pure returns (uint256 _portion) {
        return ((_contribution * (100 - CHAOSDAO_ALLOCATION)) / MOVR_BONDED);
    }
}
