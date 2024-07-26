#!/bin/bash

# TODO: Operations to configure a pre-existing priv_validator_key.json

LACONICD_VERSION=TBD
GENESIS_URL=TBD
PEERS=TBD

# Create folders in the home folder
cd

# Clone the stack repo
laconic-so fetch-stack git.vdb.to/cerc-io/testnet-laconicd-stack

# Clone the required repositories
# laconicd
laconic-so --stack ~/cerc/testnet-laconicd-stack/stack-orchestrator/stacks/testnet-laconicd setup-repositories
# laconic cli and console
laconic-so --stack ~/cerc/testnet-laconicd-stack/stack-orchestrator/stacks/laconic-console setup-repositories

# Checkout correct version
cd ~/cerc/laconicd
git checkout $LACONICD_VERSION
cd

# Build the container images
# laconicd
laconic-so --stack ~/cerc/testnet-laconicd-stack/stack-orchestrator/stacks/testnet-laconicd build-containers
# laconic cli and console
laconic-so --stack ~/cerc/testnet-laconicd-stack/stack-orchestrator/stacks/laconic-console build-containers

# Create deployment spec files
laconic-so --stack ~/cerc/testnet-laconicd-stack/stack-orchestrator/stacks/testnet-laconicd deploy init --output testnet-laconicd-spec.yml
laconic-so --stack ~/cerc/testnet-laconicd-stack/stack-orchestrator/stacks/laconic-console deploy init --output laconic-console-spec.yml

# Modify the spec files to expose container ports before creating the deployments directories.
sed -i -e 's/6060/6060:6060/' testnet-laconicd-spec.yml 
sed -i -e 's/26657/26657:26657/' testnet-laconicd-spec.yml 
sed -i -e 's/26656/26656:26656/' testnet-laconicd-spec.yml 
sed -i -e 's/9473/9473:9473/' testnet-laconicd-spec.yml 
sed -i -e 's/9090/9090:9090/' testnet-laconicd-spec.yml 
sed -i -e 's/1317/1317:1317/' testnet-laconicd-spec.yml

sed -i -e 's/80/80:80/' laconic-console-spec.yml 

# Create deployments from spec files
laconic-so --stack ~/cerc/testnet-laconicd-stack/stack-orchestrator/stacks/testnet-laconicd deploy create --spec-file testnet-laconicd-spec.yml --deployment-dir testnet-laconicd-deployment
laconic-so --stack ~/cerc/testnet-laconicd-stack/stack-orchestrator/stacks/laconic-console deploy create --spec-file laconic-console-spec.yml --deployment-dir laconic-console-deployment
# Place them both in the same namespace (cluster)
cp testnet-laconicd-deployment/deployment.yml laconic-console-deployment/deployment.yml

# Copy over the genesis file
mkdir -p testnet-laconicd-deployment/data/laconicd-data/tmp
wget $GENESIS_URL -O testnet-laconicd-deployment/data/laconicd-data/tmp/genesis.json

# Update config.env with the public peer
echo "CERC_PEERS=\"$PEERS\"" >> testnet-laconicd-deployment/config.env

# Start the deployments
laconic-so deployment --dir testnet-laconicd-deployment start
laconic-so deployment --dir laconic-console-deployment start