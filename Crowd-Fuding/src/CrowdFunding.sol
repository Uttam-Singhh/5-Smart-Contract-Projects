// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CrowdFunding is ERC721 {

    function contribute() external payable onlyActive {
    }

    function cancelProject() external onlyCreator onlyActive {
        
    }

    function claimContributions() external {
    
    }

    function claimProjectFund(uint256 amount) external onlyCreator {
    }

    function _setStatusToComplete() internal {
    }
}