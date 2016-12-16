variable "docker_host" {
}

variable "docker_cert_path" {
}

variable "link_node" {
}

variable "data_owner_name" {
}

variable "data_owner_email" {
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
    name = "${var.data_owner_name}"
    links = [
        "${var.link_node}:node0",
    ]
    command = [
        "index.js",
        "${var.data_owner_email}"
    ]
    must_run = true
    restart = "always"
}
