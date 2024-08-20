# How to Publish a Webapp

## Getting Started

1. Fork [this repo](https://github.com/LaconicNetwork/loro-testnet-example-pwa).
2. Set your private key as the env `CICD_LACONIC_USER_KEY` in Settings -> Secrets -> Actions
3. Modify the `"name":` and `"repository":` fields, then commit.
4. The commit should trigger an Action and publish an ApplicationRecord and ApplicationDeploymentRequest to the chain.

## Reference Workflow

This is a reference workflow for publishing and deploying a webapp using the Laconic Registry:

1. Upload the code to the webapp to a public repo.
2. Set up Service Provider infrastructure.
3. [On-chain] Register an Authority.
4. [On-chain] Register an Application Record and corresponding name.
5. [On-chain] Register an Application Deployment Request.
6. Deploy the app using the data from the deployment request.
7. [On-chain] Register a DNS Record and corresponding name.
8. [On-chain] Register an Application Deployment Record and corresponding name.

[![Webapp publishing workflow diagram](/images/webapp-publishing-workflow.jpg)](/images/webapp-publishing-workflow.jpg)

## Example Workflow Walkthrough

The following steps will provide sample commands and records for an example app being published:

* Our organization is Bob Inc.
* The authority will be set to `bob`.

#### Prerequisites

You must have a `laconic` address and a [bond ID](/docs/instructions.md#create-a-bond) in order to register authorities, names, and records on chain.

* Bond ID: `a742489e5817ef274187611dadb0e4284a49c087608b545ab6bd990905fb61f3`

To create a bond,

### 1. Upload webapp code to a public repo

Our (fictional) webapp repo is `github.com/bobby/fries`. It includes a `package.json` file that looks [like this].

* The app name is `fries`
* The app version is `0.0.1` 
* The git commit is `be15ad5492699aj4c85810fa5c10a28e1f8b8725` 

### 2. Set up Service Provider (SP) infrastructure

We set up the SP infrastructure to monitor the chain registry and deploy apps as required using [this guide](/docs/service-provider-setup.md).
* The `DEPLOYMENT_RECORD_NAMESPACE` must be set to `bob`.

### 3. Register an Authority

We follow the steps in [here](/docs/instructions.md#register-an-authority) to set the `bob` authority.

### 4. Register an Application Record

> This should take place automatically after pushing a commit to the relevant branch in the webapp repo.

We can register an ApplicationRecord that looks like [this](/templates/application-record%20-bob.yml) using the commands shown [here](/docs/instructions.md#register-an-application-deployment-record).

* Application record ID: `bafyreibln2qgnj4swmqnpzfqyryylovei64xglma6euufr4rs3gghu6xe4`

#### 4.1. Register Names for Application Record

We can register the relevant names now using the application record ID:

* `lrn://bob/applications/fries`
* `lrn://bob/applications/fries@0.0.1`
* `lrn://bob/applications/fries@be15ad5492699aj4c85810fa5c10a28e1f8b8725`

```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry name set lrn://bob/applications/fries bafyreibln2qgnj4swmqnpzfqyryylovei64xglma6euufr4rs3gghu6xe4"
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry name set lrn://bob/applications/fries@0.0.1 bafyreibln2qgnj4swmqnpzfqyryylovei64xglma6euufr4rs3gghu6xe4"
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry name set lrn://bob/applications/fries@be15ad5492699aj4c85810fa5c10a28e1f8b8725 bafyreibln2qgnj4swmqnpzfqyryylovei64xglma6euufr4rs3gghu6xe4"
```

### 5. Register an Application Deployment Request

> This should take place automatically after pushing a commit to the relevant branch in the webapp repo.

We can register an ApplicationDeploymenRequest that looks like [this](/templates/application-deployment-request-bob.yml) using the commands shown [here](/docs/instructions.md#register-an-application-deployment-request-record).

### 6. Deploy the app

> If your SP setup is operational, it should deploy the app and register the relevant DNS and ApplicationDeployment Records automatically after it detects the deployment request.

In this example, the app is deployed at `https://fries-13r8rdasg.pwa.bob.tech`.

### 7. Register a DNS Record

> This should take place automatically through your SP setup.

We can register a DnsRecord that looks like [this](/templates/dns-record-bob.yml) using the commands shown [here](/docs/instructions.md#register-a-dns-record).

* Dns record ID: `bafyreiefnnnwbvd2hpmxkhhgx432t4l45su3ipqgrsmqlgvwgz7ztg3l6y`

#### 7.1. Register Name for DNS Record

We can register the relevant name using the Dns record ID:

* `lrn://bob/dns/fries-13r8rdasg.pwa.bob.tech`

```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry name set lrn://bob/dns/fries-13r8rdasg.pwa.bob.tech bafyreiefnnnwbvd2hpmxkhhgx432t4l45su3ipqgrsmqlgvwgz7ztg3l6y"
```

### 8. Register an Application Deployment Record

> This should take place automatically through your SP setup.

We can register an ApplicationDeploymentRecord that looks like [this](/templates/application-deployment-record-bob.yml) using the commands shown [here](/docs/instructions.md#register-an-application-deployment-record).

* Application deployment record ID: `bafyreiape3qbsljhybvgstv6bqlspxqghd7rlxhghcxi5u524mfdyodesq`

#### 8.1. Register Name for Applicaton Deployment Record

We can register the relevant name using the Dns record ID:

* `lrn://bob/deployments/fries-13r8rdasg.pwa.bob.tech`

```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry name set lrn://bob/deployments/fries-13r8rdasg.pwa.bob.tech bafyreiape3qbsljhybvgstv6bqlspxqghd7rlxhghcxi5u524mfdyodesq"
```

