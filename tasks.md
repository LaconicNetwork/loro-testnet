# 📋 LORO Testnet Tasks & Awards 🏅

This page will be updated if there are any adjustments to the points allocated to each task or the tasks themselves.

| ID | Task | Max Points |
|:---:|:----|:---|
| [1](#task-1) |  Run a validator | 400  |
| [2](#task-2)  | Sign as many blocks as possible  |  100 |
| [3](#task-3) | Create a bond   | 40  |
| [4](#task-4) | Register an authority  | 50  |
| [5](#task-5) | Register a name  | 60  |
| [6](#task-6) | Register an application record  | 40  |
| [7](#task-7) | Register an application deployment request record | 40  |
| [8](#task-8) | Register a DNS record  | 40  |
| [9](#task-9) | Register an application deployment record | 40  |
| [10](#task-10) | Register an application deployment removal request record | 40  |
| [11](#task-11) | Publish a reference webapp  |  50 |
| [12](#task-12)  | Publish a modified reference webapp  | 100  |
| [13](#task-13) | Publish a non-reference webapp  |  200 |
| [14](#task-14)  |  Deploy your first webapp | 600  |
| [15](#task-15)  |  Deploy webapps | 3000 |
| [16](#task-16)   | Participate in a planned authority auction |  100 |
| [17](#task-17)  | Win a planned authority auction  |  500 |
| [18](#task-18)  | Create or improve registry monitoring  |  1000 |
| [19](#task-19)  | Create or improve deployment tooling  |  1000 |
| [20](#task-20)  | Write a new stack for the app publishing pipeline | 2000  |
| [21](#task-21)  | Provide the most assistance to other participants  |  100 |


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
* You will be awarded 4 points for each of the first 10 bonds you create, for a maximum of 10 points.

## Task 4
Register an authority - [instructions](/docs/instructions.md#register-an-authority)
* Registering a name requires a registered authority.
* You will be awarded 5 points for each of the first 10 authorities you register, for a maximum of 50 points.
* Authorities that contain offensive or language that is deemed inappropriate by the testnet coordinators will not be counted.

## Task 5
Register a name - [instructions](/docs/instructions.md#register-a-name)
* An application deployment request requires a registered name to be processed.
* You will be awarded 3 points for each of the first 20 names you register, for a maximum of 60 points.
* Names that contain offensive or language that is deemed inappropriate by the testnet coordinators will not be counted.

## Tasks 6 - 10
Register a record - [instructions](/docs/instructions.md#register-an-application-record)
* You will be awarded 2 points for each of the first 20 records you register, per record type, for a maximum of 40 points for each of these tasks.

## Tasks 11 - 13
Publish apps - [reference workflow](/docs/publishing-webapps.md)
* You must publish at least one app that falls under the following categories:
  * Reference app: Several ready-made apps are listed below.
  * Modified reference app: An app from the list that you have forked and made changes to.
  * Non-reference app: A brand new app.
* Each of these tasks will be considered complete when it meets the following criteria:
  * An Application Deployment Request is registered.
  * The application can be verified using the URL from the Application Deployment Record.
* You will be awarded 10 points for the first 5 unique apps you publish for task 8, for a maximum of 50 points.
* You will be awarded 10 points for the first 5 unique apps you publish for task 9, for a maximum of 50 points.
* You will be awarded 20 points for the first 10 unique apps you publish for task 10, for a maximum of 200 points.

### Reference apps

* https://git.vdb.to/cerc-io/test-progressive-web-app

## Task 14
Deploy your first app - [reference workflow](/docs/publishing-webapps.md)
* This task will be considered complete when it meets the following criteria:
  * A DNS Record is registered.
  * An Application Deployment Record is registered.
  * The application can be verified using the URL from the Application Deployment Record.
* You will be awarded 600 points for the first app you deploy.

## Task 15
Deploy apps - [reference workflow](/docs/publishing-webapps.md)
* You must deploy multiple apps and keep them online.
* The following criteria must be met for each before each task is considered eligible for points:
  * A DNS Record is registered.
  * An Application Deployment Record is registered.
  * The application can be verified using the URL from the Application Deployment Record.
* You will be awarded 2 points per app you deploy for each day it remains online, for a maximum of 30 points per app.
  * A maximum of 100 apps per Service Provider will be considered.
  * A maximum of 3000 points will be awarded for task 13.
* Testnet coordinators will verify deployments at least once a day. If the app is not reachable at that time, that day will not be counted towards the total.

## Task 16
Participate in a planned authority auction - [instructions](/docs/instructions.md#register-an-authority)
* You must submit a bid commit and a bid reveal in a planned authority auction.
* Testnet coordinators will announce when a planned authority auction will take place.
* You will be awarded 10 points for every planned auction you participate in, for a maximum of 100 points.

## Task 17
Win a planned authority auction - [instructions](/docs/instructions.md#register-an-authority)
* You must win a planned authority auction and register the corresponding authority.
* Testnet coordinators will announce when a planned authority auction will take place.
* This task will be considered complete when the authority is registered.
* You will be awarded 50 points for winning an auction.

## Task 18
Create or improve deployment tooling.
* You must publish code and a demo for a tool you created or contributed to in order to improve the Service Provider workflow.
* Claims will be evaluated by testnet coordinators and the Laconic team.
* A maximum of 1000 points will be awarded to each participant.
* Open a pull request in this repository to notify testnet coordinators you have a contribution you would like to be considered.

## Task 19
Create or improve registry monitoring.
* You must publish code and a demo for a tool you created or contributed to in order to improve registry monitoring.
* Claims will be evaluated by testnet coordinators and the Laconic team.
* A maximum of 1000 points will be awarded to each participant.
* Open a pull request in this repository to notify testnet coordinators you have a contribution you would like to be considered.

## Task 20
Write a new stack for the app publishing pipeline.
* You must publish code and a demo for a deployment stack that does not exist yet: examples include deployer code for non-npm web apps, or an interactive app deployment dashboard.
* Claims will be evaluated by testnet coordinators and the Laconic team.
* A maximum of 2000 points will be awarded to each participant.
* Open a pull request in this repository to notify testnet coordinators you have developed a new working stack.

## Task 21
* Provide assistance to other participants.
* Providing assistance (e.g. operational guidance and onboarding support) to other participants in Discord will be considered for point awards.
* A maximum of 100 points will be awarded to each participant that contributes towards making this testnet a smooth and positive experience.
* Notable participation efforts will be evaluated by testnet coordinators and the Laconic team.
