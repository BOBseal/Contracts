//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";


contract VestingReward {
    IERC20 public token ;

    struct Reward {
        uint amountPM;
        uint month;
        uint amountD;
        uint start;
    }
    mapping (address => Reward) public rewards;
    
    constructor (address _token) {
        token = IERC20(_token);
    }

    function createAllocation (
        address recipient,
        uint amountPM,
        uint month)private{
            token.transferFrom(
                msg.sender,
                address(this),
                amountPM*month
         );
         rewards[recipient]= Reward(
             amountPM,
             month,
             0,
             block.timestamp 
             );
        }
        function DistRewards(address recipient) external {
            Reward storage reward = rewards[recipient];
            require (reward.start>0, "No Rewards for You Chad");
            uint amountVest = ((block.timestamp - reward.start ) / 30 days ) * reward.amountPM;
            uint amountToD = amountVest - reward.amountD;
            require(amountToD>0, "Sorry Chad! Nothing to Distribute");
            reward.amountD += amountToD;
            token.transfer(recipient,amountToD);
        }
}
