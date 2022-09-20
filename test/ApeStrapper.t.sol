// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8 .13;

import {Cheats} from "forge-std/Cheats.sol";
// import { Vm } from "forge-std/Vm.sol";
import {console} from "forge-std/console.sol";
import {Utils} from "forge-std/Utils.sol";
import {PRBTest} from "@prb/test/PRBTest.sol";
import {ApeStrapper} from "src/ApeStrapper.sol";

/* need to add in expectEmits, expectRevert, expectCall  (https://book.getfoundry.sh/cheatcodes/expect-emit)

*/

// / @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
// / https://book.getfoundry.sh/forge/writing-tests
contract ApeStrapperTest is PRBTest,
Cheats,
Utils,
ApeStrapper {
    ApeStrapper public apeContract;

    address public user1 = address(1);
    address public user2 = address(2);
    address public user3 = address(3);
    address public user4 = address(4);
    address public user5 = address(5);
    address public user6 = address(6);
    address public user7 = address(7);
    address public user8 = address(8);
    address public user9 = address(9);
    address public user10 = address(10);
    address public user11 = address(11);
    address public user12 = address(12);
    address public user13 = address(13);
    address public user14 = address(14);
    address public user15 = address(15);
    address public user16 = address(16);
    address public user17 = address(17);
    address public user18 = address(18);
    address public user19 = address(19);
    address public user20 = address(20);
    address public user21 = address(21);

    //    vm.label(user01, "User01");
    // vm.label(user02, "User02");
    // vm.label(user03, "User03");
    // vm.label(user04, "User04");
    // vm.label(user05, "User05");
    // vm.label(user06, "User06");
    // vm.label(user07, "User07");
    // vm.label(user08, "User08");
    // vm.label(user09, "User09");
    // vm.label(user10, "User10");
    // vm.label(user11, "User11");
    // vm.label(user12, "User12");
    // vm.label(user13, "User13");
    // vm.label(user14, "User14");
    // vm.label(user15, "User15");
    // vm.label(user16, "User16");
    // vm.label(user17, "User17");
    // vm.label(user18, "User18");
    // vm.label(user19, "User19");
    // vm.label(user20, "User20");
    //     vm.label(user21, "User21");

    address private constant CHAOSDAO_MULTISIG_ADDRESS = 0x74800569E2cc88A73c6cB234326b95F7aB8293A1;
    address private constant APESTRAPPER_MULTISIG_ADDRESS = 0x19F54Ecd7d17895fADDb017d901Db551cA59AF75;

    // vm.label(address(0x19F54Ecd7d17895fADDb017d901Db551cA59AF75), "ApeStrapper Multi-Sig");
    // vm.label(CHAOSDAO_MULTISIG_ADDRESS, "ChaosDAO Multi-Sig");

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

    // /// Setup  ///////////////////////////////////////////////////
    function setUp()public {
        apeContract = new ApeStrapper();
        apeContract.setApeAllocationList(contributors, contributions);

        startHoax(address(apeContract), 0e18);
        vm.stopPrank();

        hoax(address(this), 1000e18);
        vm.stopPrank();
    }

    // /// Helpers  ///////////////////////////////////////////////////
    function makeAllApesApprove()public {
        for (uint256 i; i < contributors.length; ++i) {
            vm.startPrank(contributors[i], contributors[i]);
            apeContract.approveContract();
            vm.stopPrank();
        }
        apeContract.revokeContractCreatorAccess();
    }

    function makeNotAllApesApprove()public {
        for (uint256 i; i < contributors.length; ++i) {
            vm.startPrank(contributors[i], address(0));
            vm.expectRevert(abi.encodeWithSelector(bytes4(keccak256("ContractsNotAllowed(address,address)")), address(0), contributors[i]));
            apeContract.approveContract();
            vm.stopPrank();
        }
        apeContract.revokeContractCreatorAccess();
    }

    // /// Happy Path Tests  ///////////////////////////////////////////////////
    function testIfAllApesApprove()public {
        makeAllApesApprove();
        for (uint256 i; i < contributors.length; ++i) {
            assertEq(apeContract.apeApproved(contributors[i]), true);
        }
    }

    function testDeposit()public {
        assertEq(address(apeContract).balance, 0 ether);
        apeContract.deposit {
            value : 100e18
        }();
        assertEq(address(apeContract).balance, 100 ether);
    }

    function testEmergencyWithdrawal()public {
        startHoax(address(apeContract), 10e18);
        vm.stopPrank();

        vm.startPrank(APESTRAPPER_MULTISIG_ADDRESS);
        apeContract.emergencyWithdraw();
        vm.stopPrank();

        assertEq(address(apeContract).balance, 0);
        assertEq(address(APESTRAPPER_MULTISIG_ADDRESS).balance, 10e18);
    }

    function testNannerTime()public {
        makeAllApesApprove();
        apeContract.deposit {
            value : 4 ether
        }();
        assertEq(address(apeContract).balance, 4 ether);
        apeContract.nannerTime();
        assertEq(address(apeContract).balance, 0 ether);
    }

    function testFailApesAllApproveOnlyDAO()public {
        startHoax(address(apeContract), 100e18);
        assertEq(address(apeContract).balance, 100 ether);
        assertFalse(apeContract.allApesApprove());
        apeContract.nannerTime();
        assertEq(address(apeContract).balance, 0 ether);
    }

    ///// Sad Path Tests  ///////////////////////////////////////////////////
    function testNannerTimeNotAllApesApprove()public { 
        makeNotAllApesApprove();
        apeContract.deposit {
            value : 4 ether
        }();
        assertEq(address(apeContract).balance, 4 ether);
        vm.expectRevert(abi.encodeWithSelector(bytes4(keccak256("ApeDoesntApprove(address)")), 0x5854dc6c98520274B9D592ee01982807A39978E8));
        apeContract.nannerTime();
        assertEq(address(apeContract).balance, 4 ether);
    }

    ///// Fuzz Tests  ///////////////////////////////////////////////////
    function testFuzzDeposit(uint256 _amount)public {
        // Using bound https://book.getfoundry.sh/reference/forge-std/bound?highlight=bound#bound
        _amount = bound(_amount, 1, type(uint256).max);
        startHoax(address(msg.sender), type(uint256).max);
        assertEq(address(apeContract).balance, 0 ether);
        apeContract.deposit {
            value : _amount
        }();
        assertEq(address(apeContract).balance, _amount);
    }
}
