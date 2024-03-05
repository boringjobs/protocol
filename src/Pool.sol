//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./Request.sol";
import "./StakingRewards.sol";

contract Pool {
  mapping(address => address) public requests;

  StakingRewards private stakingRewards;

  constructor(address _stakingToken, address _rewardsToken) {
    stakingRewards = new StakingRewards(address(_stakingToken), address(_rewardsToken));
  }

  function openRequest(string memory _name, string memory _description, uint256 _reward) public {
    // require(stakingRewards.balanceOf(msg.sender) >= _reward, "Not approved to spend");
    Request req = new Request(_name, _description, _reward, msg.sender);
    requests[msg.sender] = address(req);
  }
}
