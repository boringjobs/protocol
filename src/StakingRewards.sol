// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";


contract StakingRewards is Ownable {
    IERC20 public stakingToken;
    IERC20 public rewardsToken;

    uint public duration;
    uint public finishAt;
    uint public updatedAt;
    uint public rewardRate;
    uint public rewardPerTokenStored;
    uint public totalSupply;

    mapping(address => uint) public userRewardPerTokenPaid;
    mapping(address => uint) public rewards;
    mapping(address => uint) public balanceOf;

    event Staked(address indexed user, uint amount);
    event Withdrawn(address indexed user, uint amount);
    event RewardPaid(address indexed user, uint reward);

    constructor(address _stakingToken, address _rewardsToken) Ownable(msg.sender) {
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
    }

    function stake(uint _amount) external {
        totalSupply += _amount;
        balanceOf[msg.sender] += _amount;
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        emit Staked(msg.sender, _amount);
    }

    function withdraw(uint _amount) external {
        totalSupply -= _amount;
        balanceOf[msg.sender] -= _amount;
        stakingToken.transfer(msg.sender, _amount);
        emit Withdrawn(msg.sender, _amount);
    }

    function getReward() external {
        uint reward = earned(msg.sender);
        if (reward > 0) {
            rewards[msg.sender] = 0;
            rewardsToken.transfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    function earned(address account) public view returns (uint) {
        return (balanceOf[account] * (rewardPerToken() - userRewardPerTokenPaid[account]) / 1e18) + rewards[account];
    }

    function rewardPerToken() public view returns (uint) {
        if (totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return rewardPerTokenStored + (rewardRate * (min(block.timestamp, finishAt) - updatedAt) * 1e18) / totalSupply;
    }

    function updateReward(address account) internal {
        rewardPerTokenStored = rewardPerToken();
        updatedAt = block.timestamp;
        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
    }

    // Additional functions like notifyRewardAmount, setDuration, and emergencyWithdraw can be added for completeness

    function min(uint a, uint b) private pure returns (uint) {
        return a < b ? a : b;
    }
}
