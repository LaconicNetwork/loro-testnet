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

## Task 6 - Host additional services

* 100 points for an explorer (claimed)
* 500 points for Blast (allocated, transfered to Task 7)

## Task 7 - Host DIN Services

* Deploy and register an “RpcNodeDeploymentRecord” for:
    * [Blast](https://docs.blast.io/tools/node-providers#how-to-run-your-own-nodes)
    * [zkSync](https://docs.zksync.io/zksync-node/running-node)
* This task is additionally eligible for recurring USD payment
* Bonus points for making a “stack” for each service to contracted Service Providers
* Until our decentralized solution to load balancing is completed (i.e., “Watcher Parties”), we will run caddy proxies at blast.rpc.laconic.com and zksync.rpc.laconic.com
* Laconic is a founding member of DIN. We would like to announce that “Laconic Network Service Providers are running RPC infrastructure for DIN”

## Task 8 - Host Ollama

* Deploy and register an "LLMDeploymentRecord" for:
    * [Ollama](https://github.com/ollama/ollama)
* Bonus: create a stack that allows for two modes of usage:
    * 1-to-1 usage a single user connects to a single ollama instance
    * 1-to-many: multiple user connect to the same ollama instance
    * Use the [default Ollama docker image](https://hub.docker.com/r/ollama/ollama)

## Task 9 - Leaderboard Accounting

* The current testnet 2 tally was created manually and does not necessarily include all contributions / efforts since the end of testnet 1.
* This task is to provide an automated script to tally any and all outstanding contributions that are not accounted for [here](https://github.com/LaconicNetwork/loro-testnet/pull/60).


## Bonus points

* Arbitrary bonuses will be allocated for outstanding contributions and rapid turnaround on Tasks 1 & 2.
* If you are reading this, the second testnet has unofficially begun ;)
