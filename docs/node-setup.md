# Node Setup

## Chain Details (TBA)

* Genesis file
* Binary repo
* Binary version
* Peers

## How to Join

The following steps will configure and start containers to run `laconicd`, `laconic-console`, and `laconic-registry-cli`.

1. Set up Docker and Laconic's Stack Orchestrator in the machine that will run the LORO Testnet node using [this script](https://raw.githubusercontent.com/cerc-io/stack-orchestrator/main/scripts/quick-install-linux.sh).
2. Add `laconic-so` to the `PATH` (you can also log out and log back in).
   ```
   source ~/.profile
   ```
3. Use Stack Orchestrator to configure and start the containers using [this script](/scripts/setup-node-containers.sh).
4. To confirm the node is online, check the log using this command:
   ```
   laconic-so deployment --dir testnet-laconicd-deployment logs laconicd -f
   ```