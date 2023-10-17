// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CrowdFunding is ERC721 {

    uint256 public constant ROUND_DURATION = 30 days;
    uint256 public immutable AMOUNT_TO_RAISE;
    uint256 public immutable ROUND_ENDTIME;
    uint256 public contractBalance;
    uint256 public tokenId;
    address public immutable CREATOR;

    event ContributionReceived(address indexed contributor, uint256 amount);
    event CreatorWithdrawal(uint256 amount);
    event ContributorRefund(address indexed contributor, uint256 amount);
    event CrowdFundingCompleted(uint256 timeStamp);
    event CrowdFundingCanceled(uint256 timeStamp);


    modifier onlyCreator() {
        require(msg.sender == CREATOR, "Unauthorized");
        _;
    }
    
    enum Status {
        Active,
        Completed,
        Failed
    }
    Status public status;

    modifier onlyActive() {
        require(status == Status.Active, "CrowdFunding not Active");
        require(block.timestamp < ROUND_ENDTIME, "Round ended");
        _;

    }

    mapping(address => uint256) public badgesGiven;
    mapping(address => uint256) public contributions;


    constructor(
        address creator_,
        uint256 amountToRaise_,
        string memory name_,
        string memory symbol_
    ) ERC721(name_, symbol_){
        require(creator_ != address(0), "invalid address");
        require(amountToRaise_ > 0.1 ether, "invalid amount");
        status = Status.Active;
        CREATOR = creator_;
        AMOUNT_TO_RAISE = amountToRaise_;
        ROUND_ENDTIME = block.timestamp + ROUND_DURATION;
    }

    function contribute() external payable onlyActive {
        require(msg.value > 0.1 ether, "Min Amount is 0.1 ETH");

        if (contractBalance + msg.value >= AMOUNT_TO_RAISE) {
            _setStatusToComplete();
        }

        contributions[msg.sender] += msg.value;
        contractBalance += msg.value;

        uint256 badgestoGive = (contributions[msg.sender] / 1 ether) - badgesGiven[msg.sender];
        badgesGiven[msg.sender] += badgestoGive;

        emit ContributionReceived(msg.sender, msg.value);

        for (uint256 i = 0; i < badgestoGive; i++) {
            _safeMint(msg.sender, tokenId++);
        }

    }

    function cancelProject() external onlyCreator onlyActive {
        status = Status.Failed;
        emit CrowdFundingCanceled(block.timestamp);
        
    }

    function claimContributions() external {
        if (status == Status.Active && block.timestamp > ROUND_ENDTIME) {
            status = Status.Failed;
        }
        require(contributions[msg.sender] > 0, "No contributions");
        require(status == Status.Failed, "Project active or completed");
        uint256 amount = contributions[msg.sender];
        require(contractBalance < AMOUNT_TO_RAISE, "Goal met");
        contractBalance -= amount;
        contributions[msg.sender] -= amount;

        emit ContributorRefund(msg.sender, amount);

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "call failed");
    }

    function claimProjectFund(uint256 amount) external onlyCreator {
        require(status == Status.Completed, "Project not completed");
        require(contractBalance >= amount, "invalid");
        contractBalance -= amount;

        emit CreatorWithdrawal(amount);

        (bool success, ) = payable(CREATOR).call{value: amount}("");
        require(success, "Call failed");

    }

    function _setStatusToComplete() internal {
        require(status == Status.Active, "Invalid state transition");
        status = Status.Completed;
        emit CrowdFundingCompleted(block.timestamp);
    }
}