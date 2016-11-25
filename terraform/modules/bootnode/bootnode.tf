variable "docker_host" {
}

variable "docker_cert_path" {
}

variable "bootnode_nat" {
}

variable "volume_path" {
    default = "/var/lib/enettet-ethereum"
}

provider "docker" {
    host = "${var.docker_host}"
    cert_path = "${var.docker_cert_path}"
}

data "docker_registry_image" "ethereum_bootnode" {
    name = "enettet/ethereum-bootnode:latest"
}

resource "docker_image" "ethereum_bootnode" {
    name = "${data.docker_registry_image.ethereum_bootnode.name}"
    pull_trigger = "${data.docker_registry_image.ethereum_bootnode.sha256_digest}"
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
        protocol = "tcp"
    }
    ports {
        internal = 30301
        external = 30301
        protocol = "udp"
    }
    command = [
        "-nodekey",
        "/etc/ethereum/boot.key",
        "-verbosity",
        "9",
        "-nat",
        "${var.bootnode_nat}"
    ]
    must_run = true
    restart = "no"
}
