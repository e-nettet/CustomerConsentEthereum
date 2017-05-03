variable "docker_host" {
}

variable "docker_cert_path" {
}

variable "link_node" {
}

provider "docker" {
    host = "${var.docker_host}"
    cert_path = "${var.docker_cert_path}"
}

data "docker_registry_image" "consent_data_requester" {
    name = "enettet/consent-data-requester:latest"
}

resource "docker_image" "consent_data_requester" {
    name = "${data.docker_registry_image.consent_data_requester.name}"
    pull_trigger = "${data.docker_registry_image.consent_data_requester.sha256_digest}"
}

resource "docker_container" "consent_data_requester" {
    image = "${docker_image.consent_data_requester.latest}"
    name = "consent-datarequester"
    ports = {
        internal = 3000
        external = 3200
    }
    links = [
        "${var.link_node}:node0",
    ]
    must_run = true
    restart = "always"
}
