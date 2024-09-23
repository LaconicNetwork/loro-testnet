# Tasks for Laconic Testnet 2

The second incentivized testnet offically begins on Monday September 23rd @ 17:00 UTC. Select validators that are still running will receive additional funds that they should bond, to even out voting power.

## Task 1 - Maintain webapp deployer uptime

* Following the first testnet, some SPs kept their infra running. However, as of September 20th, there are no longer SPs deploying webapps; we'd like to see a handful get back in action.
* 500 points will be allocated to SPs that maintain uptime for the foreseable future.

## Task 2 - Deploy Sepolia stack

* The nitro bridge that will be tested in the third testnet will use Sepolia. To begin testing, it will be helpful to have several Sepolia nodes available.
* See the stack instructions [here](https://git.vdb.to/cerc-io/eth-stack/src/branch/main/stack-orchestrator/stacks/eth/README.md).
* Deploy it to your k8s cluster or use compose.
* Publish an RpcNodeDeploymentRecord.
* 500 points to each SP that completes this task in a timely manner.

## Task 3 - Enhanced app store

* Improve upon the app store made by Silent.
* For example, the card for each ApplicationRecord should include a link to the git repo.
* Or, integrate Laconic Wallet to sign in to the app store, require payment to view deployments, etc.
* Up to 200 points based on the complexity of the contribution.

## Task 4 - New deployer APIs

* There are many options, coordinate with @cerebralbosons on Discord.
* Up to 800 points based on the thoroughness of the contribution.

## Task 5 - Wishlist apps to publish

* Identical to Task 21 from the first testnet.
* 50-100 points depending on the complexity of the app.

### Wishlist

* Deploy ping-pub with a fix to see all transactions - [link](https://git.vdb.to/cerc-io/cosmos-explorer)

## Bonus points

* Arbitrary bonuses will be allocated for outstanding contributions and rapid turnaround on Tasks 1 & 2.
* If you are reading this, the second testnet has unofficially begun ;)
