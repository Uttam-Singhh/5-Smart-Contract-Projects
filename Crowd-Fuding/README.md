## Crowd-Funding Project

1. Describe all functions & Technical Specifications
2. Design the Project with Diagrams
3. Code the Smart Contract
4. Write Unit Tests

### Project Setup

```shell
$ forge build
```

### Test

```shell
$ forge test
```
### Technical Specification & functions:

- Crowdfunding is an online money-raising strategy.
- The goal amount of project should be more than 0.01 ETH & there needs to be a desired amount.
- Anyone can contribute(including creator) to the project as long as it is active.
- Project is considered active if it's less than 30 days of it's creation or the creator of the project does not cancel it.
- If the project has already raised desired amount, no can can contribute further.
- Per 1 ETH donated, the user gets 1 badge/NFT. (Each project has its separate NFT badges)
- Refund Policy:
  - Project has not reached its goal and 30 days since its creation have passed.
  - User has contributed to the project.
  - No partial withdraws (only full amount)
- Only Creator can withdraw funds from the Project contract if the Project has raised the amount desired or the amount to withdraw is less than contributions made to the Project.

