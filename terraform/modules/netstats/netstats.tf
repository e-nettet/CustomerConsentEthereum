variable "docker_host" {
}

variable "docker_cert_path" {
}

variable "netstats_secret" {
}

data "docker_registry_image" "ethereum_netstats" {
    name = "enettet/ethereum-netstats:latest"
}

resource "docker_image" "ethereum_netstats" {
    name = "${data.docker_registry_image.ethereum_netstats.name}"
    pull_trigger = "${data.docker_registry_image.ethereum_netstats.sha256_digest}"
}

provider "docker" {
    host = "${var.docker_host}"
    cert_path = "${var.docker_cert_path}"
}

resource "docker_container" "ethereum_netstats" {
    image = "${docker_image.ethereum_netstats.latest}"
    name = "ethereum-netstats"
    ports {
        internal = 3000
        external = 3000
    }
    env = [
        "WS_SECRET=${var.netstats_secret}"
    ]
}
