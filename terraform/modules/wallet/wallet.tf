variable "docker_host" {
}

variable "docker_cert_path" {
}

provider "docker" {
    host = "${var.docker_host}"
    cert_path = "${var.docker_cert_path}"
}

data "docker_registry_image" "consent_wallet" {
    name = "enettet/consent-wallet:latest"
}

resource "docker_image" "consent_wallet" {
    name = "${data.docker_registry_image.consent_wallet.name}"
}

resource "docker_container" "consent_wallet" {
    image = "${docker_image.consent_wallet.latest}"
    name = "consent-wallet"
    ports {
        internal = 80
        external = 8080
    }
    must_run = true
    restart = "always"
}
