// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "cannon-std/Cannon.sol";

import "../src/Pool.sol";
import "../src/Request.sol";
import "../src/StakingRewards.sol";

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract StakingToken is ERC20 {
  constructor() ERC20("StakingToken", "STK") {
    _mint(msg.sender, 1000000 * 10 ** decimals());
  }
}

contract RewardsToken is ERC20 {
  constructor() ERC20("RewardsToken", "REW") {
    _mint(msg.sender, 1000000 * 10 ** decimals());
  }
}

contract BoringPoolTest is Test {
  using Cannon for Vm;

  StakingToken stakingToken;
  RewardsToken rewardsToken;
  Pool pool;

  function setUp() public {
    stakingToken = new StakingToken();
    rewardsToken = new RewardsToken();
    pool = new Pool(address(stakingToken), address(rewardsToken));
  }

  function testOpenRequest() public {
    uint256 fulfilmentReward = 100;

    pool.openRequest("Job1", "Description1", fulfilmentReward);
    Request req = Request(pool.requests(address(this)));

    assertEq(req.name(), "Job1");
    assertEq(req.description(), "Description1");
    assertEq(req.fulfilmentReward(), fulfilmentReward);
    assertEq(req.employer(), address(this));
  }
}
