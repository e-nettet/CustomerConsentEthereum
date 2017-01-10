# CustomerConsentEthereum

## Joining the blockchain

 1. Install [Docker](https://www.docker.com/)
 2. Install [Terraform](https://www.terraform.io/)
 3. `cd terraform/personal`
 4a. (Mac only) Change `volume_path` to your docker persistent folder
 4b. `terraform get`
 5. `terraform apply`
 6. Type a name for your node.

The default configuration will start two Docker container for the actual Ethereum nodes called *ethereum-node0* and *ethereum-node1*, and two containers linked to Ethereum nodes called *ethereum-netstats-api0* and *ethereum-netstats-api1* that report statistics to the [Ethereum Network Status](http://35.156.138.143:3000/) dashboard. You can change the number of nodes by editing *personal.tf*.

The node name parameter is used to identify your node on. Participation in the dashboard is completely optional and does not actually influence the functionality of the blockchain itself in any way. It can take a few minutes for the nodes to discover each other.

Please note that the default configuration publishes all administrative functions through an unsecured RPC interface. It is not meant for a deployment on a server.

## How to mine?
 1. `docker exec -it ethereum-node0 geth attach`
 2. `miner.setEtherbase('public key')` set to where transfer currency
 3. `miner.start()` to start mining

## Development tools

### Ethereum Wallet (Mac only)
 1. `cd /Applications/Ethereum\ Wallet.app/Contents/MacOS/`
 2. `./Ethereum\ Wallet --rpc http://localhost:8545`

## Troubleshooting

### Cannot connect to Docker

Default configuration assumes that you run it on Linux with Docker support built-in. On Windows and MacOS, Docker relies on a virtualization layer, and it may be necessary to communicate with the Docker engine via TCP. Edit *personal.tf* and change `docker_host = "unix:///var/run/docker.sock"` to `docker_host = "tcp://localhost:2376"` (or a proper IP address).

### Transactions time out

Transactions will only function if there is an active miner in the blockchain. If there is no mining, the nodes may get out of sync, and will not communicate all that much with each other. You can see if there are any active miners on the [Ethereum Network Status](http://35.156.138.143:3000/) dashboard.

### Miner does not mine transactions

Even with an active miner, transactions may still time out, because it will not mine them. If the miner does not receive any blocks from other nodes, it will assume it is out of sync and will not attempt to mine the transactions. What you want then is to start mining on your own node:

 1. `docker exec -it ethereum-node0 geth attach`
 2. `miner.start()` to start mining
 3. `miner.stop()` to stop mining

It is usually enough to run a miner for a few moments (assuming there are other active miners) just to let the other nodes know that your node is alive.

Please note that the initial startup time for a miner can be over 15 minutes during which an [EtHash DAG](https://github.com/ethereum/wiki/wiki/Ethash-DAG) is generated. After the initial generation is done, mining can be started and stopped at will.

### module.consent_ethereum.provider.docker: "ca_material": conflicts with cert_path ("") module.consent_ethereum.provider.docker: "cert_material": conflicts with cert_path ("") module.consent_ethereum.provider.docker: "key_material": conflicts with cert_path ("")

Install [Terraform 0.7.12](https://releases.hashicorp.com/terraform/0.7.12/)

Applies to Terraform 0.8.0 and 0.8.1. See https://github.com/hashicorp/terraform/issues/10754.
