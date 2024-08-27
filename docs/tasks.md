# 📋 LORO Testnet Tasks & Awards 🏅

This page will be updated if there are any adjustments to the points allocated to each task or the tasks themselves.

|        ID         | Task                                                      | Max Points | Validator/Service Provider | App Publisher |
| :---------------: | :-------------------------------------------------------- | :--------- | :------------------------: | :-----------: |
|   [1](#task-1)    | Run a validator                                           | 400        |             ✅              |               |
|   [2](#task-2)    | Sign as many blocks as possible                           | 100        |             ✅              |               |
|   [3](#task-3)    | Create a bond                                             | 40         |             ✅              |       ✅       |
|   [4](#task-4)    | Register an authority                                     | 50         |             ✅              |       ✅       |
|   [5](#task-5)    | Register a name                                           | 60         |             ✅              |       ✅       |
| [6](#tasks-6-10)  | Register an application record                            | 40         |             ✅              |       ✅       |
| [7](#tasks-6-10)  | Register an application deployment request record         | 40         |             ✅              |       ✅       |
| [8](#tasks-6-10)  | Register a DNS record                                     | 40         |             ✅              |               |
| [9](#tasks-6-10)  | Register an application deployment record                 | 40         |             ✅              |               |
| [10](#tasks-6-10) | Register an application deployment removal request record | 40         |             ✅              |       ✅       |
|  [11](#task-11)   | Publish a webapp                                          | 50         |             ✅              |       ✅       |
|  [12](#task-12)   | Publish a non-reference webapp                            | 300        |             ✅              |       ✅       |
|  [13](#task-13)   | Deploy your first webapp                                  | 600        |             ✅              |               |
|  [14](#task-14)   | Deploy webapps                                            | 3000       |             ✅              |               |
|  [15](#task-15)   | Participate in a planned authority auction                | 100        |             ✅              |      ✅        |
|  [16](#task-16)   | Win a planned authority auction                           | 500        |             ✅              |      ✅        |
|  [17](#task-17)   | Create or improve registry monitoring                     | 1000       |             ✅              |               |
|  [18](#task-18)   | Create or improve deployment tooling                      | 1000       |             ✅              |               |
|  [19](#task-19)   | Write a new stack for the app publishing pipeline         | 2000       |             ✅              |       ✅       |
|  [20](#task-20)   | Provide the most assistance to other participants         | 1000       |             ✅              |       ✅       |
|  [21](#task-21)   | Publish a webapp from the LORO webapp wishlist            | 1000       |             ✅              |       ✅       |

* The two columns on the right show which tasks can be claimed depending on a participant's role.

## Task Changelog

* Aug 22
  * Add task 21: publish a webapp from the LORO webapp wishlist
  * Bump max points for task 20 to 1000

## Prerequisites

* In order to be eligible for any tasks, you must complete the sign-up process.
* You must use the laconic address registered through the onboarding process for all on-chain tasks: creating a validator, creating a bond, registering records, etc.


## Task 1
Run a validator
* All participants that run a validator node will be awarded 400 points.
* Instructions on how to set up a node will be posted in this repo ahead of the testnet launch.


## Task 2
Sign as many blocks as possible
* You must run a validator node and keep downtime to a minimum.
* Validators will be ranked by blocks signed: the top one will get 100 points, the second place will get 90, third place will get 80, and so on. 
* Only the top 10 validators will be awarded points.


## Task 3
Create a bond - [instructions](/docs/instructions.md#create-a-bond)
* A bond will allow you to register records on chain.
* You will be awarded 4 points for each of the first 10 bonds you create, for a maximum of 40 points.

## Task 4
Register an authority - [instructions](/docs/instructions.md#register-an-authority)
* Registering a name requires a registered authority.
* You will be awarded 5 points for each of the first 10 authorities you register, for a maximum of 50 points.
* Authorities that contain offensive or language that is deemed inappropriate by the testnet coordinators will not be counted.

## Task 5
Register a name - [instructions](/docs/instructions.md#register-a-name)
* Names must be registered for the following:
  * Application Record
  * Dns Record
  * Application Deployment Record
* You will be awarded 3 points for each of the first 20 names you register, for a maximum of 60 points.
* Names that contain offensive or language that is deemed inappropriate by the testnet coordinators will not be counted.

## Tasks 6-10
Register a record - [instructions](/docs/instructions.md#register-an-application-record)
* You will be awarded 2 points for each of the first 20 records you register, per record type, for a maximum of 40 points for each of these tasks.

## Task 11
Publish an app - [instructions](/docs/service-provider-setup.md#deploy-a-test-webapp)
* You must publish at least one app. You can use [this repo](https://github.com/LaconicNetwork/loro-testnet-example-pwa) as reference.
* This task will be considered complete when it meets the following criteria:
  * An Application Deployment Request is registered.
  * The application can be verified using the URL from the Application Deployment Record.
* You will be awarded 10 points for each of the first 5 apps you publish for task 11, for a maximum of 50 points.

### Reference app

* https://github.com/LaconicNetwork/loro-testnet-example-pwa

## Task 12
Publish a non-reference app - [reference workflow](/docs/publishing-webapps.md)
* You must publish one app that is different from the reference one listed above.
* Each of these tasks will be considered complete when it meets the following criteria:
  * An Application Deployment Request is registered.
  * The Application Record includes a `non-reference` tag.
  * The application can be verified using the URL from the Application Deployment Record.
  * Testnet coordinators confirm that the deployed app is different from the reference app.
* Only the first Application Record that is registered with a `non-reference` tag will be evaluated.
* You will be awarded 300 points for the first non-reference app you deploy.

## Task 13
Deploy your first app - [reference workflow](/docs/publishing-webapps.md)
* This task will be considered complete when it meets the following criteria:
  * A DNS Record is registered.
  * An Application Deployment Record is registered.
  * The application can be verified using the URL from the Application Deployment Record.
* A reference Service Provider setup guide can be found [here](/docs/service-provider-setup.md).
* You will be awarded 600 points for the first app you deploy.

## Task 14
Deploy apps - [reference workflow](/docs/publishing-webapps.md)
* You must deploy multiple apps and keep them online.
* The following criteria must be met for each before each task is considered eligible for points:
  * A DNS Record is registered.
  * An Application Deployment Record is registered.
  * The application can be verified using the URL from the Application Deployment Record.
* A reference Service Provider setup guide can be found [here](/docs/service-provider-setup.md).
* You will be awarded 2 points per app you deploy for each day it remains online, for a maximum of 30 points per app.
  * A maximum of 100 apps per Service Provider will be considered.
  * A maximum of 3000 points will be awarded for task 13.
* Testnet coordinators will verify deployments at least once a day. If the app is not reachable at that time, that day will not be counted towards the total.

## Task 15
Participate in a planned authority auction - [instructions](/docs/instructions.md#register-an-authority)
* You must submit a bid commit and a bid reveal in a planned authority auction.
* Testnet coordinators will announce when a planned authority auction will take place.
* You will be awarded 10 points for each planned auction you participate in, for a maximum of 100 points.

## Task 16
Win a planned authority auction - [instructions](/docs/instructions.md#register-an-authority)
* You must win a planned authority auction and register the corresponding authority.
* Testnet coordinators will announce when a planned authority auction will take place.
* This task will be considered complete when the authority is [set with a bond ID](/docs/instructions.md#set-authority).
* You will be awarded 50 points for each auction you win, for a maximum of 500 points.

## Task 17
Create or improve deployment tooling.
* You must publish code and a demo for a tool you created or contributed to in order to improve the Service Provider workflow.
* Claims will be evaluated by testnet coordinators and the Laconic team.
* A maximum of 1000 points will be awarded to each participant.
* Open a pull request in this repository to notify testnet coordinators you have a contribution you would like to be considered.

### Laconicman
- Code: https://github.com/BlackBlocks-io/laconicman
- Demo: https://github.com/BlackBlocks-io/laconicman?tab=readme-ov-file#screenshots
  
## Task 18
Create or improve registry monitoring.
* You must publish code and a demo for a tool you created or contributed to in order to improve registry monitoring.
* Claims will be evaluated by testnet coordinators and the Laconic team.
* A maximum of 1000 points will be awarded to each participant.
* Open a pull request in this repository to notify testnet coordinators you have a contribution you would like to be considered.

### Laconic Registry Leaderboard
- Code: https://github.com/BlackBlocks-io/Laconic-Registry-Leaderboard
- Demo: https://blackblocks.io/laconic-registry-leaderboard/
- Demo: https://laconic-registry-leaderboard-4667880952.pwa.laconic.blackblocks.io/

## Task 19
Write a new stack for the app publishing pipeline.
* You must publish code and a demo for a deployment stack that does not exist yet: examples include deployer code for non-npm web apps, or an interactive app deployment dashboard.
* Claims will be evaluated by testnet coordinators and the Laconic team.
* A maximum of 2000 points will be awarded to each participant.
* Open a pull request in this repository to notify testnet coordinators you have developed a new working stack.

### Celestia-node stack
- Code: https://github.com/BlackBlocks-io/stack-orchestrator/commit/e8b91e601b41192f30733f1b3f60c3fc7eb3e47b
- Demo: https://github.com/BlackBlocks-io/stack-orchestrator/commit/e8b91e601b41192f30733f1b3f60c3fc7eb3e47b#commitcomment-145918265

## Task 20
Provide assistance to other participants.
* Providing assistance (e.g. operational guidance and onboarding support) to other participants in Discord will be considered for point awards.
* A maximum of 1000 points will be awarded to each participant that contributes towards making this testnet a smooth and positive experience.
* Notable participation efforts will be evaluated by testnet coordinators and the Laconic team.

## Task 21
* Publish a webapp from the LORO webapp wishlist (see below).
* This task will be considered complete when it meets the following criteria:
  * An Application Deployment Request is registered.
  * The Application Record includes a `wishlist` tag.
  * The application can be verified using the URL from the Application Deployment Record.
  * Testnet coordinators confirm that the deployed app is in the wishlist.
* For each webapp, the **first participant to publish it** will receive 500 points.

### LORO Webapp Wishlist

1. https://github.com/osmosis-labs/osmosis-frontend
2. ~~https://github.com/DarkFlorist/Horswap~~ (claimed)
