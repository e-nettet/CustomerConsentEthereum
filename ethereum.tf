variable "docker_host" {
    default = "unix:///var/run/docker.sock"
}

variable "bootnode_enode" {
    default = "53216148b33a67390c2c76a41e5b59af74f5842d2f983d17af66874d007f1d2b62efe6f73872a77a7799ab5b0a6fb4318416c2b8d3b6e7f665676629e2e45da0"
}

variable "miner_etherbase" {
    default = "0x0000000000000000000000000000000000000001"
}

variable "volume_path" {
    default = "/var/lib/enettet-ethereum"
}

provider "docker" {
    host = "${var.docker_host}"
}

resource "docker_image" "ethereum_node" {
    name = "enettet/ethereum-node:latest"
}

resource "docker_image" "ethereum_bootnode" {
    name = "enettet/ethereum-bootnode:latest"
}

resource "docker_container" "ethereum_node" {
    count = 1
    image = "${docker_image.ethereum_node.latest}"
    name = "ethereum-node${count.index}"
    hostname = "node${count.index}"
    depends_on = [
        "docker_container.ethereum_bootnode"
    ]
    volumes {
        container_path = "/root/.ethereum"
        host_path = "${var.volume_path}/node${count.index}/ethereum"
    }
    ports {
        internal = "8545"
        external = "${8545 + (10 * count.index)}"
    }
    ports {
        internal = "8546"
        external = "${8546 + (10 * count.index)}"
    }
    links = [
        "${docker_container.ethereum_bootnode.name}:bootnode"
    ]
    command = [
        "--bootnodes=enode://${var.bootnode_enode}@${docker_container.ethereum_bootnode.ip_address}:30301",
        "--fast",
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
        "8546"
    ]
    must_run = true
    restart = "no"
}

resource "docker_container" "ethereum_miner" {
    image = "${docker_image.ethereum_node.latest}"
    name = "ethereum-miner"
    hostname = "miner"
    depends_on = [
        "docker_container.ethereum_bootnode"
    ]
    links = [
        "${docker_container.ethereum_bootnode.name}:bootnode"
    ]
    volumes {
        container_path = "/root/.ethereum"
        host_path = "${var.volume_path}/miner/ethereum"
    }
    volumes {
        container_path = "/root/.ethash"
        host_path = "${var.volume_path}/miner/ethash"
    }
    command = [
        "--bootnodes=enode://${var.bootnode_enode}@${docker_container.ethereum_bootnode.ip_address}:30301",
        "--fast",
        "--lightkdf",
        "--mine",
        "--minerthreads=1",
        "--etherbase=${var.miner_etherbase}"
    ]
    must_run = true
    restart = "no"
}

resource "docker_container" "ethereum_bootnode" {
    image = "${docker_image.ethereum_bootnode.latest}"
    name = "ethereum-bootnode"
    volumes {
        container_path = "/root/.ethereum"
        host_path = "${var.volume_path}/bootnode/ethereum"
    }
    ports {
        internal = 30301
        external = 30301
    }
    command = [
        "-nodekey",
        "/etc/ethereum/boot.key"
    ]
    must_run = true
    restart = "no"
}
