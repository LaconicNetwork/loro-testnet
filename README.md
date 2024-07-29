# LORO Testnet 🦜

Welcome to the Laconic Operational Ranking and Onboarding Testnet! This is a three-week incentivized testnet program that will onboard and assess participants interested in joining the [Laconic Network](https://laconic.com/).

This repo contains the event plan and information on the tasks that must be completed to collect points.

## How to Join

### 1. Registration

There are two apps you will use to register for the testnet.

* The [wallet app](https://wallet.laconic.com) will:
  * Generate all the required keys and addresses.
  * Link your KYC UUID with a `laconic` address.
  * Publish your KYC UUID and keys to the chain.
* The [onboarding app](https://loro-signup.laconic.com) will:
  * Register your validator on the testnet.
  * Allow you to request funds from the faucet.

### 2. Node setup
Instructions on how to set up a node will be published in this repo ahead of the testnet launch.

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

### The list of tasks and associated points can be found [here](./tasks.md).

## Timeline

### Week 1
* Testnet launch
* Participants set up Service Provider infrastructure
* Participants begin registering authorities
* Participants begin publishing apps

### Week 2
* Planned authority auctions take place

### Week 3
* Testnet coordinators submit Application Deployment Requests
* Testnet conclusion

## The Laconic Stack

A good first step to onboarding to the Laconic stack is reading this article: https://laconic.com/blog/intro-to-the-laconic-stack

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

### Service Provider infrastructure

Participants interested in becoming Service Providers must set up relevant infrastructure:
* Hosts that will run apps requested via the Laconic chain (e.g. Kubernetes clusters)
* Monitoring software to detect application deployment requests
* DNS and Deployment Record registration tools

A reference workflow for publishing apps through a Laconic chain can be found [here](/docs/publishing-webapps.md).

## Rules

The rules for participating in the LORO Testnet can be changed at any time. Changes will be committed here and announced in Discord by the testnet coordinators.

* Engaging in any prohibited behaviour may result in disqualification.
* The testnet coordinators have sole discretion over whether a behaviour qualifies as ‘prohibited’ or not, using their best judgement.
* Depending on the severity of the incident, a single warning may be given before a participant is disqualified.

### Prohibited Behaviour

* Any attack against a node that violates the acceptable use policy outlined by that node's cloud service provider. Please familiarize yourself with those policies (such as [Google's](https://cloud.google.com/terms/aup), [Amazon's](https://aws.amazon.com/aup/), or [Digital Ocean's](https://www.digitalocean.com/legal/acceptable-use-policy)).
* Social engineering attacks against other validators. This includes but is not limited to phishing, compromising cloud account credentials, malware, and physical security attacks on data centers.
* Causing long-term harm to a validator setup.
* Repeated incidents of any of the ‘[dirty dozen](https://en.wikipedia.org/wiki/The_No_Asshole_Rule#Recognition)’ social behaviours recognized by Sutton’s No Asshole Rule.
