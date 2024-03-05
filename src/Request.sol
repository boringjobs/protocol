//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Request {
  string public name;
  string public description;
  uint256 public fulfilmentReward;
  address public employer;
  address public employee;
  bool public isCompleted;

  constructor(string memory _name, string memory _description, uint256 _fulfilmentReward, address _employer) {
    name = _name;
    description = _description;
    fulfilmentReward = _fulfilmentReward;
    employer = _employer;
  }

  function complete() public {
    require(msg.sender == employer, "Only employer can complete the open request");
    isCompleted = true;
  }
}
