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

data "docker_registry_image" "consent_data_owner" {
    name = "enettet/consent-data-owner:latest"
}

resource "docker_image" "consent_data_owner" {
    name = "${data.docker_registry_image.consent_data_owner.name}"
    pull_trigger = "${data.docker_registry_image.consent_data_owner.sha256_digest}"
}

resource "docker_container" "consent_data_owner" {
    image = "${docker_image.consent_data_owner.latest}"
    name = "consent-dataowner"
    ports = {
        internal = 3000
        external = 3100
    }
    links = [
        "${var.link_node}:node0",
    ]
    must_run = true
    restart = "always"
}
