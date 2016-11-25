variable "node_name" {
}

module "consent_ethereum" {
    source = "../modules/ethereum"
    docker_host = "unix:///var/run/docker.sock"
    docker_cert_path = ""
    netstats_secret = "fc3790e391e058a04d6a81aac40e1e51adb675f85a2e0d5c9c95477b22836185ffe5761c4c21f049cdb2b579ff615935"
    netstats_host = "35.156.138.143"
    bootnode_host = "35.156.138.143"
    node_nat = "any"
    node_count = 2
    node_name = "${var.node_name}"
    node_verbosity = 3
}
