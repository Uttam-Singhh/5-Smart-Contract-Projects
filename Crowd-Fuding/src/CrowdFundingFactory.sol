//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "./CrowdFunding.sol";

contract CrowdFundingFactory {
    event ProjectCreated(
        address indexed creator,
        address indexed project,
        uint256 amountToRaise
    );

    function createCrowdFunding(
        uint256 amountToRaise,
        string calldata name,
        string calldata symbol
    ) external {
        CrowdFunding project = new CrowdFunding(msg.sender, amountToRaise, name, symbol);
        emit ProjectCreated(msg.sender, address(project), amountToRaise);
    }
}