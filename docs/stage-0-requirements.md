# Stage 0 Requirements

You must complete tasks 11 (publish an app) and 13 (deploy an app) during Stage 0 to be eligible for the Validator/Service Provider role in Stage 1.
* See the [How to Publish a Webapp](/docs/publishing-webapps.md) page for reference: you will complete this workflow as part of Stage 0.

## Steps

* Set up a [fork of this repo](https://github.com/LaconicNetwork/loro-testnet-example-pwa/blob/main/.github/workflows/publish.yaml#L11) with your wallet's private key (exported from the Laconic Wallet).
  * Change the `name` and `repository` fields in `package.json`.
* Set up Service Provider Infrastructure
  * Use the bond ID and authority created in the previous steps.
  * [Instructions](/docs/service-provider-setup.md)
* Publish an app
  * [Instructions](/docs/service-provider-setup.md#deploy-a-test-webapp)
  * Modify the following variables in the `.env` file before requesting the deployment:
    * Set `CERC_TEST_WEBAPP_CONFIG1` to your Laconic address (`laconic...` from the wallet app)
    * Set `CERC_TEST_WEBAPP_CONFIG2` to your Public Key (`0x...` from the wallet app)
* Verify the deployment using the URL listed in the [deployer UI](/docs/service-provider-setup.md#deploy-frontend).
* Verify your registry records are onchain here: https://loro-console.laconic.com/#/registry

## Stage 0 Chain Details

* Chain ID: `laconic_9000-1`
* RPC endpoint: `https://laconicd.laconic.com`
* GraphQL endpoint: `https://laconicd.laconic.com/api`
