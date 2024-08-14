# LORO Testnet 🦜

Welcome to the Laconic Operational Ranking and Onboarding Testnet! This is a three-week incentivized testnet program that will onboard and assess participants interested in joining the [Laconic Network](https://laconic.com/).

This repo contains the event plan and information on the tasks that must be completed to collect points.

## Operator Profile

The main goal of the LORO testnet is to identify qualified Service Providers to operate in the Laconic Network.

You should sign up as a Validator/Service Provider if:
* You have experience managing cloud infrastructure and cluster deployments.
* You have experience deploying infrastructure on demand.
* You have experience working with CI/CD app deployment pipelines.

## How to Join

### Sign up

You must follow a sign-up process regardless of whether you are participating as a Validator/Service Provider or as an App Publisher.

Open the [wallet](https://wallet.laconic.com/) and [onboarding](https://loro-signup.laconic.com/) apps in separate tabs and follow the steps below.

| Wallet app |  Onboarding app  |
|:----|:----|
| Click on `Create wallet`* | |
|   | Accept the Terms and Conditions  |
|   | Verify your email adddress |
|    | Click on `Connect wallet` |
|    | Click the top-right icon of the WalletConnect dialog to copy the URI |
|  Click the top-right icon of the page |   |
|  Click on `Pair` and paste the URI |  |
|  | Select the Laconic and Nitro accounts from your wallet |
|  | Sign using the Nitro key  |
| Approve the sign request | |
| | Select your role |  
|  | Click the `Request tokens from faucet` button** |
| | Send transaction request to the wallet |
| Approve and send transaction | |

**\* Save the mnemonic in a safe place.**  
\** Ensure the displayed balance is updated.

### Set up a Validator Node

The testnet chain will be started through a two-staged process:

#### Stage 0

* A Stage 0 chain is launched as a single-node Proof of Authority network.
* The Stage 0 chain is used to collect all the onboarding app transactions and register account addresses.
* At the end of Stage 0, the following items will be published in this repo:
  * Genesis file
  * Stage 1 bootstrap node information
* **Participants must complete the sign-up process during this stage.**

**Stage 0 requirements**

Participants who have registered as Validator/Service Providers must complete Task 11 during Stage 0 to be eligible for Stage 1.

Visit the [Stage 0 requirements page](/docs/stage-0-requirements.md) for details.

#### Stage 1

Follow [these instructions](/docs/validator-setup.md) to set up a validator node.

* The Stage 1 chain (the LORO testnet) is launched from a bootstrap node using the genesis file generated at the end of Stage 0.
* Participants sync their nodes to the Stage 1 chain using the published genesis file and Stage 1 bootstrap node peer
* Participants submit a `create-validator` transaction to the chain.
* **Participants must begin signing blocks within 24 hours after Stage 1 begins.**

### Set up Service Provider Infrastructure

Follow [these instructions](/docs/service-provider-setup.md) to set up Service Provider infrastructure.

## Testnet Plan Overview
> ⚠️ Please be aware that the schedule, tasks, and point breakdown are subject to change. ⚠️

The LORO testnet will focus on:
1. Onboarding participants to the app publishing workflow afforded by a Laconic chain and 
2. Evaluating their ability to run the relevant infrastructure and maintain a reliable distributed network.

Participants will be required to demonstrate their proficiency operating as validators and Service Providers. This will be accomplished by performing tasks within a Laconic network. This includes:
* Running a validator node
* Registering records in the Laconic chain
* Publishing apps
* Deploying apps

Testnet coordinators will provide updates to participants via Discord channels and monitor task completion status throughout the event.

After the testnet concludes, the participants will be ranked according to the tasks they completed.

### The list of tasks and associated points can be found [here](/docs/tasks.md).

## Timeline

### Week 1
* Testnet launch
* Participants set up Service Provider infrastructure
* Participants begin registering authorities
* Participants begin publishing and deploying apps

### Week 2
* Participants continue to publish and deploy apps

### Week 3
* Planned authority auctions take place
* Testnet conclusion

## Laconic Testnet Software

This testnet will allow participants to become familiar with the following components:
* [laconicd](https://git.vdb.to/cerc-io/laconicd)
  * The binary that validators must run to keep the Laconic chain online.
* [laconic-registry-cli](https://git.vdb.to/cerc-io/laconic-registry-cli)
  * A CLI tool to interact with the Laconic chain.
* [laconic-console](https://git.vdb.to/cerc-io/laconic-console)
  * A web application to browse records in the chain.
* [stack-orchestrator](https://git.vdb.to/cerc-io/stack-orchestrator)
  * A CLI tool to configure and deploy laconicd, laconic-registry-cli, and laconic-console containers in a local host.
  * Testnet participants will be expected to use stack-orchestator to run their nodes and interact with the chain.

A reference workflow for publishing apps through a Laconic chain can be found [here](/docs/publishing-webapps.md).

### Service Provider infrastructure

Participants interested in becoming Service Providers must set up relevant infrastructure:
* Hosts that will run apps requested via the Laconic chain (e.g. Kubernetes clusters)
* Monitoring software to detect application deployment requests
* DNS and Deployment Record registration tools

A reference guide for setting up Service Provider infrastructure can be found [here](/docs/service-provider-setup.md).

## Rules

The rules for participating in the LORO Testnet can be changed at any time. Changes will be committed here and announced in Discord by the testnet coordinators.

* Engaging in any prohibited behaviour may result in disqualification.
* The testnet coordinators have sole discretion over whether a behaviour qualifies as ‘prohibited’ or not, using their best judgement.
* Depending on the severity of the incident, a single warning may be given before a participant is disqualified.

### Prohibited Behaviour

* Any attack against a node that violates the acceptable use policy outlined by that node's cloud service provider. Please familiarize yourself with those policies (such as [Google's](https://cloud.google.com/terms/aup), [Amazon's](https://aws.amazon.com/aup/), or [DigitalOcean's](https://www.digitalocean.com/legal/acceptable-use-policy)).
* Social engineering attacks against other validators. This includes but is not limited to phishing, compromising cloud account credentials, malware, and physical security attacks on data centers.
* Causing long-term harm to a validator setup.
* Repeated incidents of any of the ‘[dirty dozen](https://en.wikipedia.org/wiki/The_No_Asshole_Rule#Recognition)’ social behaviours recognized by Sutton’s No Asshole Rule.
