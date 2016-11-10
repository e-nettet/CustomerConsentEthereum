variable "docker_host" {
    default = "unix:///var/run/docker.sock"
}

provider "docker" {
    host = "${var.docker_host}"
}

resource "docker_image" "ethereum_node" {
    name = "ethereum-node:latest"
}

resource "docker_image" "ethereum_bootnode" {
    name = "ethereum-bootnode:latest"
}

resource "docker_container" "ethereum_node" {
    image = "${docker_image.ethereum_node.latest}"
    name = "ethereum-node"
    hostname = "node0"
    depends_on = [
        "docker_container.ethereum_bootnode"
    ]
    ports {
        internal = 8545
        external = 8545
    }
    ports {
        internal = 8546
        external = 8546
    }
    links = [
        "${docker_container.ethereum_bootnode.name}:bootnode"
    ]
    command = [
        "--bootnodes=enode://53216148b33a67390c2c76a41e5b59af74f5842d2f983d17af66874d007f1d2b62efe6f73872a77a7799ab5b0a6fb4318416c2b8d3b6e7f665676629e2e45da0@${docker_container.ethereum_bootnode.ip_address}:30301",
        "--fast",
        "--lightkdf",
        "--rpc",
        "--rpccorsdomain",
        "'*'",
        "--rpcapi",
        "db,eth,net,web3,personal",
        "--rpcaddr",
        "node0",
        "--rpcport",
        "8545",
        "--ws",
        "--wsorigins",
        "'*'",
        "--wsaddr",
        "node0",
        "--wsport",
        "8546"
    ]
    must_run = true
    restart = "no"
}

resource "docker_container" "ethereum_bootnode" {
    image = "${docker_image.ethereum_bootnode.latest}"
    name = "ethereum-bootnode"
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
