// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { Cheats } from "forge-std/Cheats.sol";
import { console } from "forge-std/console.sol";
import { Utils } from "forge-std/Utils.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";
import { ApeStrapper } from "src/ApeStrapper.sol";

/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract ApeStrapperTest is PRBTest, Cheats, Utils, ApeStrapper {
    ApeStrapper apeContract;

    address[] contributors = [
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

    uint256[] contributions = [
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

    address private constant CHAOSDAO_MULTISIG_ADDRESS = 0x74800569E2cc88A73c6cB234326b95F7aB8293A1;
    address private constant APESTRAPPER_MULTISIG_ADDRESS = 0x19F54Ecd7d17895fADDb017d901Db551cA59AF75;

    function setUp() public {
        apeContract = new ApeStrapper();
        apeContract.setApeAllocationList(contributors, contributions);

        startHoax(address(apeContract), 0e18);
        vm.stopPrank();

        hoax(address(this), 1000e18);
        vm.stopPrank();
    }

    function makeAllApesApprove() public {
        for (uint256 i; i < contributors.length; ++i) {
            vm.startPrank(contributors[i]);
            apeContract.approveContract();
            vm.stopPrank();
        }
        apeContract.revokeContractCreatorAccess();
    }

    function testApesAllApprove() public {
        makeAllApesApprove();
        for (uint256 i; i < contributors.length; ++i) {
            assertEq(apeContract.apeApproved(contributors[i]), true);
        }
    }

    function testDeposit() public {
        assertEq(address(apeContract).balance, 0 ether);
        apeContract.deposit{ value: 100e18 }();
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
        makeAllApesApprove();
        apeContract.deposit{ value: 4 ether }();
        assertEq(address(apeContract).balance, 4 ether);
        apeContract.nannerTime();
        assertEq(address(apeContract).balance, 0 ether);
    }

    function testApesAllApproveOnlyDAO() public {
        startHoax(address(apeContract), 1e18);
        assertEq(address(apeContract).balance, 1 ether);
        assertTrue(apeContract.allApesApprove());
        vm.expectRevert();
        apeContract.nannerTime();
      //  assertEq(address(apeContract).balance, 0 ether);
    }

    function testFuzzDeposit(uint _amount) public {
        _amount = bound(_amount, 1, type(uint256).max );
  //    console.log(address(msg.sender).balance);
        startHoax(address(msg.sender), type(uint256).max );
  //    console.log(address(msg.sender).balance);
        assertEq(address(apeContract).balance, 0 ether);
  //    console.log(address(apeContract).balance);
        apeContract.deposit{ value: _amount}();
  //    console.log(address(apeContract).balance);
        assertEq(address(apeContract).balance, _amount);
    }

}
