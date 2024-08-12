# Validator Setup

## Chain Details

* Binary repo: https://git.vdb.to/cerc-io/laconicd
* Binary version: [v0.1.6](https://git.vdb.to/cerc-io/laconicd/src/tag/v0.1.6)
* Genesis file:
* Peers: 

## Set up a Validator in Stage 1

### Prerequisites

* Minimum hardware requirements:
  ```bash
  RAM: 8GB
  Disk space: 200GB
  CPU: 2 cores
  ```
* Testnet genesis file and peer node address
* Mnemonic from the wallet app
* Participant onboarded in Stage 0
* Stage 1 has started

### Setup

* Clone the stack repo:

  ```bash
  laconic-so fetch-stack git.vdb.to/cerc-io/testnet-laconicd-stack
  ```

* Clone required repositories:

  ```bash
  laconic-so --stack ~/cerc/testnet-laconicd-stack/stack-orchestrator/stacks/testnet-laconicd setup-repositories --pull

  # If this throws an error as a result of being already checked out to a branch/tag in a repo, remove the repositories and re-run the command
  ```

* Build the container images:

  ```bash
  laconic-so --stack ~/cerc/testnet-laconicd-stack/stack-orchestrator/stacks/testnet-laconicd build-containers
  ```

  This should create the following docker images locally:

  * `cerc/laconicd`

### Create a deployment

* Create a spec file for the deployment:

  ```bash
  laconic-so --stack ~/cerc/testnet-laconicd-stack/stack-orchestrator/stacks/testnet-laconicd deploy init --output testnet-laconicd-spec.yml
  ```

* Edit `network` in the spec file to map container ports to host ports as required:

  ```bash
  # testnet-laconicd-spec.yml
  ...
  network:
    ports:
      laconicd:
        - '6060:6060'
        - '26657:26657'
        - '26656:26656'
        - '9473:9473'
        - '9090:9090'
        - '1317:1317'
  ```

* Create the deployment from the spec file:

  ```bash
  laconic-so --stack ~/cerc/testnet-laconicd-stack/stack-orchestrator/stacks/testnet-laconicd deploy create --spec-file testnet-laconicd-spec.yml --deployment-dir testnet-laconicd-deployment
  ```

* Copy over the published testnet genesis file (`.json`) to data directory in deployment (`testnet-laconicd-deployment/data/laconicd-data/tmp`):

  ```bash
  # Example
  mkdir -p testnet-laconicd-deployment/data/laconicd-data/tmp
  cp genesis.json testnet-laconicd-deployment/data/laconicd-data/tmp/genesis.json
  ```

### Configuration

* Inside the `testnet-laconicd-deployment` deployment directory, open `config.env` file and set following env variables:

  ```bash
  # Comma separated list of nodes to keep persistent connections to
  # Example: "node-1-id@laconicd.laconic.com:26656"
  # Use the provided node id
  CERC_PEERS=""

  # A custom human readable name for this node (default: TestnetNode)
  CERC_MONIKER=
  ```

### Start the deployment

```bash
laconic-so deployment --dir testnet-laconicd-deployment start
```

### Check status

* To list down and monitor the running containers:

  ```bash
  # With status
  docker ps -a

  # Follow logs for laconicd container
  laconic-so deployment --dir testnet-laconicd-deployment logs laconicd -f
  ```

* Check the sync status of your node:

  ```bash
  laconic-so deployment --dir testnet-laconicd-deployment exec laconicd "laconicd status | jq .sync_info"

  # `catching_up: false` indicates that node is completely synced
  ```

* After the node has caught up, view current list of staking validators:

  ```bash
  laconic-so deployment --dir testnet-laconicd-deployment exec laconicd "laconicd query staking validators"
  ```

  * Confirm that in the list of validators, your node moniker does not exist

### Join as testnet validator

#### Using the onboarding app

* Open the [wallet app](https://wallet.laconic.com/)
* Create a validator from the onboarding app:
  * Visit the [validator creation](https://loro-signup.laconic.com/validator) page
    * If required, connect the onboarding app to the wallet used in Stage 0
  * Select the Laconic account you wish to send the create validator request from (it should be the same one you used while onboarding)
    * This should display the details of your onboarded participant
    * You can proceed if the participant has the `validator` role
  * Enter your node's moniker (use the same one used while [configuring](#configuration) the `testnet-laconicd-deployment`)
  * Enter your validator's pubkey. You can obtain the pubkey with the following command:
    ```bash
    laconic-so deployment --dir testnet-laconicd-deployment exec laconicd "laconicd cometbft show-validator" | jq -r .key
    ```
  * Send the transaction request to wallet
    * From the wallet app, approve and send transaction to the Stage 1 laconicd chain

#### Using the `laconicd` CLI

* Import a key pair:

  ```bash
  KEY_NAME=alice

  # Restore existing key with mnemonic seed phrase
  # You will be prompted to enter mnemonic seed
  laconic-so deployment --dir testnet-laconicd-deployment exec laconicd "laconicd keys add $KEY_NAME --recover"

  # Query the keystore for your account's address
  laconic-so deployment --dir testnet-laconicd-deployment exec laconicd "laconicd keys show $KEY_NAME -a"
  ```

* Check balance for your account:

  ```bash
  laconic-so deployment --dir testnet-laconicd-deployment exec laconicd "laconicd query bank balances <account-address>"
  ```

* Create required validator configuration:

  ```bash
  # Note:
  # Edit the staking amount and other fields as required
  # Replace <your-node-moniker> with your node's moniker in command below

  laconic-so deployment --dir testnet-laconicd-deployment exec laconicd 'cat <<EOF > my-validator.json
  {
    "pubkey": $(laconicd cometbft show-validator),
    "amount": "1000000000000000alnt",
    "moniker": "<your-node-moniker>",
    "commission-rate": "0.1",
    "commission-max-rate": "0.2",
    "commission-max-change-rate": "0.01",
    "min-self-delegation": "1"
  }
  EOF'
  ```

* Create a validator:

  ```bash
  laconic-so deployment --dir testnet-laconicd-deployment exec laconicd "laconicd tx staking create-validator my-validator.json \
  --fees 500000alnt \
  --chain-id=laconic_9000-1 \
  --from $KEY_NAME"
  ```

* View staking validators:

  ```bash
  laconic-so deployment --dir testnet-laconicd-deployment exec laconicd "laconicd query staking validators"
  ```

  * Check that in the list of validators `<your-node-moniker>` exists

* View validator set:

  ```bash
  laconic-so deployment --dir testnet-laconicd-deployment exec laconicd "laconicd query consensus comet validator-set"
  ```

### Clean up (only do this if you need to stop your node)

* Stop all `testnet-laconicd` services running in the background:

  ```bash
  # Stop the docker containers
  laconic-so deployment --dir testnet-laconicd-deployment stop
  ```

* To stop all services and also delete data:

  ```bash
  # Stop the docker containers
  laconic-so deployment --dir testnet-laconicd-deployment stop --delete-volumes

  # Remove deployment directory (deployment will have to be recreated for a re-run)
  rm -r testnet-laconicd-deployment
  ```