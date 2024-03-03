// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "cannon-std/Cannon.sol";

import "../src/BoringJobs.sol";

contract BoringJobsTest is Test {
  using Cannon for Vm;

  BoringJobs bj;

  function setUp() public {
    bj = new BoringJobs("Hello World");
  }

  function testExample() public {
    string memory expectedGreeting = "Hello World";
    bytes32 expectedHash = keccak256(abi.encodePacked(expectedGreeting));

    assertTrue(keccak256(abi.encodePacked(bj.greet())) == expectedHash);
  }
}
