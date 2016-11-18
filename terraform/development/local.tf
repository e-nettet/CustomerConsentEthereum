module "consent_ethereum" {
    source = "../modules/ethereum"
    docker_host = "unix:///var/run/docker.sock"
    docker_cert_path = ""
}
