// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.13;

import {Cheats} from "forge-std/Cheats.sol";
import {console} from "forge-std/console.sol";
import {Utils} from "forge-std/Utils.sol";
import {PRBTest} from "@prb/test/PRBTest.sol";
import {ApeStrapper} from "src/ApeStrapper.sol";

/* need to add in expectEmits, expectRevert, expectCall  (https://book.getfoundry.sh/cheatcodes/expect-emit)
add tests pause, unpause
*/

contract ApeStrapperTest is PRBTest, Cheats, Utils, ApeStrapper {
    ApeStrapper public apeContract;

    address private constant CHAOSDAO_MULTISIG_ADDRESS = 0x74800569E2cc88A73c6cB234326b95F7aB8293A1;
    address private constant APESTRAPPER_MULTISIG_ADDRESS = 0x19F54Ecd7d17895fADDb017d901Db551cA59AF75;

    address[] private contributors = [
        0x5854dc6c98520274B9D592ee01982807A39978E8,
        0x97057dEf7F0590C0F8455290E26B42F72cb11d79,
        0x0cb96b749e57F2eE5b61711b4BB37a9567d7b090,
        0xd3dE1f8Aa8e9Cf7133Bb65f4555F8f09cFCB7473,
        0x4C0398b106Bc617A935f63b28a550A923aaDE6bf,
        0x151AE0BD359D32E2a76D0237ac7Ac9f0888263b6,
        0x014536b207090CF1d4D38409f32864e94d6090A5,
        0xD4b954c7DBD77c2FADCD66Ec681Dd992e97a9374,
        0x3185E982D8Dc70af2634DC2406714C59cc3db550,
        0xcC2c8f387c4FafcBfE299F21dC9dD0dCc8E3f7aC,
        0xB5D93Dbeff89f84058DEC857E8b60817B6C4E62d
    ];

    uint256[] private contributions = [
        169346642468240000000,
        163883847549909000000,
        68284936479128900000,
        54627949183303100000,
        55174228675136000000,
        27313974591651500000,
        11471869328493600000,
        13656987295825800000,
        10925589836660600000,
        10925589836660600000,
        16388384754990900000
    ];

    /*//////////////////////////////////////////////////////////////
                            SETUP          
    //////////////////////////////////////////////////////////////*/

    address public ape12 = address(12);
    address public ape13 = address(13);
    address public ape14 = address(14);
    address public ape15 = address(15);
    address public ape16 = address(16);
    address public ape17 = address(17);
    address public ape18 = address(18);
    address public ape19 = address(19);
    address public ape20 = address(20);
    address public ape21 = address(21);

    address[] private contributors2 = [
        ape12,
        ape13,
        ape14
    ];

    uint256[] private contributions2 = [
        200e18,
        100e18,
        302e8
    ];

    function setUp() public {
        /// @notice Multi-sig labels
        vm.label(address(0x19F54Ecd7d17895fADDb017d901Db551cA59AF75), "ApeStrapper Multi-Sig");
        vm.label(CHAOSDAO_MULTISIG_ADDRESS, "ChaosDAO Multi-Sig");
        /// @notice Ape labels
        vm.label(address(0x5854dc6c98520274B9D592ee01982807A39978E8), "Ape01");
        vm.label(address(0x97057dEf7F0590C0F8455290E26B42F72cb11d79), "Ape02");
        vm.label(address(0x0cb96b749e57F2eE5b61711b4BB37a9567d7b090), "Ape03");
        vm.label(address(0xd3dE1f8Aa8e9Cf7133Bb65f4555F8f09cFCB7473), "Ape04");
        vm.label(address(0x4C0398b106Bc617A935f63b28a550A923aaDE6bf), "Ape05");
        vm.label(address(0x151AE0BD359D32E2a76D0237ac7Ac9f0888263b6), "Ape06");
        vm.label(address(0x014536b207090CF1d4D38409f32864e94d6090A5), "Ape07");
        vm.label(address(0xD4b954c7DBD77c2FADCD66Ec681Dd992e97a9374), "Ape08");
        vm.label(address(0x3185E982D8Dc70af2634DC2406714C59cc3db550), "Ape09");
        vm.label(address(0xcC2c8f387c4FafcBfE299F21dC9dD0dCc8E3f7aC), "Ape10");
        vm.label(address(0xB5D93Dbeff89f84058DEC857E8b60817B6C4E62d), "Ape11");
        vm.label(ape12, "Ape12");
        vm.label(ape13, "Ape13");
        vm.label(ape14, "Ape14");
        vm.label(ape15, "Ape15");
        vm.label(ape16, "Ape16");
        vm.label(ape17, "Ape17");
        vm.label(ape18, "Ape18");
        vm.label(ape19, "Ape19");
        vm.label(ape20, "Ape20");
        vm.label(ape21, "Ape21");

        apeContract = new ApeStrapper();
    //    assertFalse(apeContract.initialized());
    //    apeContract.setApeAllocationList(contributors, contributions);
    //    assertTrue(apeContract.initialized());
    //    startHoax(address(apeContract), 0e18);
    //    vm.stopPrank();
    //
    //    startHoax(address(this), 1000e18);
    //    vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                                HELPERS   
    //////////////////////////////////////////////////////////////*/
    function makeAllApesApprove() public {
        for (uint256 i; i < contributors.length; ++i) {
            vm.startPrank(contributors[i], contributors[i]);
            apeContract.approveContract();
            vm.stopPrank();
        }
        apeContract.revokeContractCreatorAccess();
    }

    function makeAllApesApprove2() public {
        for (uint256 i; i < contributors2.length; ++i) {
            vm.startPrank(contributors2[i], contributors2[i]);
            apeContract.approveContract();
            vm.stopPrank();
        }
    }

    function makeNotAllApesApprove() public {
        for (uint256 i; i < contributors.length; ++i) {
            vm.startPrank(contributors[i], address(0));
            vm.expectRevert(
                abi.encodeWithSelector(
                    bytes4(keccak256("ContractsNotAllowed(address,address)")), address(0), contributors[i]
                )
            );
            apeContract.approveContract();
            vm.stopPrank();
        }
        apeContract.revokeContractCreatorAccess();
    }

    /*//////////////////////////////////////////////////////////////
                           HAPPY PATH TESTS          
    //////////////////////////////////////////////////////////////*/

    function testRevokeContractCreatorAccess() public {
        vm.startPrank(address(this), address(this));
        // vm.expectEmit(true, true, false, true, address(apeContract));
        assertTrue(
            apeContract.hasRole(0xc8646254b43d5f02db6fe5d5d02c9a52e5ab473f9fa90147574047707f10dda9, address(this))
        );
        apeContract.revokeContractCreatorAccess();
        assertFalse(
            apeContract.hasRole(0xc8646254b43d5f02db6fe5d5d02c9a52e5ab473f9fa90147574047707f10dda9, address(this))
        );
    }

    function testIfAllApesApprove() public {
        makeAllApesApprove();
        for (uint256 i; i < contributors.length; ++i) {
            assertEq(apeContract.apeApproved(contributors[i]), true);
        }
    }

    function testDeposit() public {
        assertEq(address(apeContract).balance, 0 ether);
        apeContract.deposit{value: 100e18}();
        assertEq(address(apeContract).balance, 100 ether);
    }

    function testEmergencyWithdrawal() public {
        startHoax(address(apeContract), 10e18);
        vm.stopPrank();

        vm.startPrank(APESTRAPPER_MULTISIG_ADDRESS);
        apeContract.emergencyWithdraw();
        vm.stopPrank();

        assertEq(address(apeContract).balance, 0);
        assertEq(address(APESTRAPPER_MULTISIG_ADDRESS).balance, 10e18);
    }

    function testNannerTime() public {
        {
            makeAllApesApprove();
            apeContract.deposit{value: 4 ether}();
            assertEq(address(apeContract).balance, 4 ether);
            apeContract.nannerTime();
            assertEq(address(apeContract).balance, 0 ether);
        }
        {
     //  vm.startPrank(APESTRAPPER_MULTISIG_ADDRESS);
     //  apeContract._clearApeAllocationList();
        //apeContract.setApeAllocationList(contributors2, contributions2);
      //  vm.stopPrank();
      //  makeAllApesApprove();
      //  apeContract.deposit{value: 4 ether}();
      //  assertEq(address(apeContract).balance, 4 ether);
      //  apeContract.nannerTime();
      //  assertEq(address(apeContract).balance, 0 ether);
        }
    }

    function testClearApes() public {
        vm.startPrank(APESTRAPPER_MULTISIG_ADDRESS);
        apeContract._clearApeAllocationList();
      //  apeContract.setApeAllocationList(contributors2, contributions2);
        vm.stopPrank();
        makeAllApesApprove();
        apeContract.deposit{value: 4 ether}();
        assertEq(address(apeContract).balance, 4 ether);
        apeContract.nannerTime();
        assertEq(address(apeContract).balance, 0 ether);
    }
    

    function testFailApesAllApproveOnlyDAO() public {
        startHoax(address(apeContract), 100e18);
        assertEq(address(apeContract).balance, 100 ether);
        assertFalse(apeContract.allApesApprove());
        apeContract.nannerTime();
        assertEq(address(apeContract).balance, 0 ether);
    }

    /*//////////////////////////////////////////////////////////////
                           SAD PATH TESTS          
    //////////////////////////////////////////////////////////////*/

    function testNannerTimeNotAllApesApprove() public {
        makeNotAllApesApprove();
        apeContract.deposit{value: 4 ether}();
        assertEq(address(apeContract).balance, 4 ether);
        vm.expectRevert(
            abi.encodeWithSelector(
                bytes4(keccak256("ApeDoesntApprove(address)")), 0x5854dc6c98520274B9D592ee01982807A39978E8
            )
        );
        apeContract.nannerTime();
        assertEq(address(apeContract).balance, 4 ether);
    }

    function testEmergencyWithdrawalExpectFail() public {
        startHoax(address(apeContract), 10e18);
        vm.stopPrank();

        vm.startPrank(address(1));
        //   vm.stopPrank();
        vm.expectRevert(
            abi.encodePacked(
                "AccessControl: account 0x0000000000000000000000000000000000000001 is missing role 0xc8646254b43d5f02db6fe5d5d02c9a52e5ab473f9fa90147574047707f10dda9"
            )
        );
        apeContract.emergencyWithdraw();
        assertEq(address(apeContract).balance, 10e18);
        vm.stopPrank();
    }

    function testRevokeContractCreatorAccessFail() public {
        vm.startPrank(address(1), address(1));
        assertTrue(
            apeContract.hasRole(0xc8646254b43d5f02db6fe5d5d02c9a52e5ab473f9fa90147574047707f10dda9, address(this))
        );
        vm.expectRevert(
            abi.encodePacked(
                "AccessControl: account 0x0000000000000000000000000000000000000001 is missing role 0xc8646254b43d5f02db6fe5d5d02c9a52e5ab473f9fa90147574047707f10dda9"
            )
        );
        apeContract.revokeContractCreatorAccess();
        assertTrue(
            apeContract.hasRole(0xc8646254b43d5f02db6fe5d5d02c9a52e5ab473f9fa90147574047707f10dda9, address(this))
        );
    }

    /*//////////////////////////////////////////////////////////////
                           FUZZ TESTS          
    //////////////////////////////////////////////////////////////*/
    function testFuzzDeposit(uint256 _amount) public {
        // Using bound https://book.getfoundry.sh/reference/forge-std/bound?highlight=bound#bound
        _amount = bound(_amount, 1, type(uint256).max);
        startHoax(address(msg.sender), type(uint256).max);
        assertEq(address(apeContract).balance, 0 ether);
        apeContract.deposit{value: _amount}();
        assertEq(address(apeContract).balance, _amount);
    }

    function testFuzzCalculatePortion(uint256 _contribution) external {
        _contribution = bound(_contribution, 1, 602);
        assertEq(apeContract.calculatePortion(_contribution), _contribution * (100 - 12) / 602);
    }
}
