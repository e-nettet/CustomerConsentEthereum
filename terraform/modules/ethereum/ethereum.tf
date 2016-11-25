variable "netstats_secret" {
}

variable "netstats_host" {
}

variable "bootnode_enode" {
    default = "53216148b33a67390c2c76a41e5b59af74f5842d2f983d17af66874d007f1d2b62efe6f73872a77a7799ab5b0a6fb4318416c2b8d3b6e7f665676629e2e45da0"
}

variable "bootnode_host" {
}

variable "node_nat" {
}

variable "node_name" {
}

variable "miner_etherbase" {
    default = "0x0000000000000000000000000000000000000001"
}

variable "volume_path" {
    default = "/var/lib/enettet-ethereum"
}

variable "node_count" {
    default = 1
}

variable "docker_host" {
}

variable "docker_cert_path" {
}

provider "docker" {
    host = "${var.docker_host}"
    cert_path = "${var.docker_cert_path}"
}

data "docker_registry_image" "ethereum_node" {
    name = "enettet/ethereum-node:latest"
}

data "docker_registry_image" "ethereum_netstats_api" {
    name = "enettet/ethereum-netstats-api:latest"
}

resource "docker_image" "ethereum_node" {
    name = "${data.docker_registry_image.ethereum_node.name}"
    pull_trigger = "${data.docker_registry_image.ethereum_node.sha256_digest}"
}

resource "docker_image" "ethereum_netstats_api" {
    name = "${data.docker_registry_image.ethereum_netstats_api.name}"
    pull_trigger = "${data.docker_registry_image.ethereum_netstats_api.sha256_digest}"
}

resource "docker_container" "ethereum_node" {
    count = "${var.node_count}"
    image = "${docker_image.ethereum_node.latest}"
    name = "ethereum-node${count.index}"
    hostname = "node${count.index}"
    volumes {
        container_path = "/root/.ethereum"
        host_path = "${var.volume_path}/node${count.index}/ethereum"
    }
    volumes {
        container_path = "/root/.ethash"
        host_path = "${var.volume_path}/node${count.index}/ethash"
    }
    ports {
        internal = "8545"
        external = "${8545 + (10 * count.index)}"
    }
    ports {
        internal = "8546"
        external = "${8546 + (10 * count.index)}"
    }
    ports {
        internal = "${30304 + count.index}",
        external = "${30304 + count.index}"
        protocol = "tcp"
    }
    ports {
        internal = "${30304 + count.index}",
        external = "${30304 + count.index}"
        protocol = "udp"
    }
    command = [
        "--networkid=94642",
        "--port=${30304 + count.index}",
        "--nat=${var.node_nat}",
        "--bootnodes=enode://${var.bootnode_enode}@${var.bootnode_host}:30301",
        "--lightkdf",
        "--rpc",
        "--rpccorsdomain",
        "'*'",
        "--rpcapi",
        "db,eth,net,web3,personal",
        "--rpcaddr",
        "node${count.index}",
        "--rpcport",
        "8545",
        "--ws",
        "--wsorigins",
        "'*'",
        "--wsaddr",
        "node${count.index}",
        "--wsport",
        "8546",
        "--autodag",
        "--minerthreads=1",
        "--etherbase=${var.miner_etherbase}",
        "--verbosity=6"
    ]
    must_run = true
    restart = "no"
}

resource "docker_container" "ethereum_netstats_api" {
    count = "${var.node_count}"
    image = "${docker_image.ethereum_netstats_api.latest}"
    name = "ethereum-netstats-api${count.index}"
    env = [
        "WS_SECRET=${var.netstats_secret}",
        "WS_SERVER=http://${var.netstats_host}:3000",
        "INSTANCE_NAME=${var.node_name}${count.index}",
        "RPC_HOST=node${count.index}",
        "RPC_PORT=8545",
    ]
    links = [
        "ethereum-node${count.index}:node0",
    ]
    depends_on = [
        "docker_container.ethereum_node"
    ]
}
