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

data "docker_registry_image" "consent_id_service" {
    name = "enettet/consent-id-service:latest"
}

resource "docker_image" "consent_id_service" {
    name = "${data.docker_registry_image.consent_id_service.name}"
    pull_trigger = "${data.docker_registry_image.consent_id_service.sha256_digest}"
}

resource "docker_container" "consent_id_service" {
    image = "${docker_image.consent_id_service.latest}"
    name = "consent-id-service"
    links = [
        "${var.link_node}:node0",
    ]
    must_run = true
    restart = "always"
}
