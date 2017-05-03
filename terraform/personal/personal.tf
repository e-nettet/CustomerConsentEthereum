variable "node_name" {
}

variable "docker_host" {
    default = "unix:///var/run/docker.sock"
}

module "consent_ethereum" {
    source = "../modules/ethereum"
    docker_host = "${var.docker_host}"
    docker_cert_path = ""
    netstats_secret = "fc3790e391e058a04d6a81aac40e1e51adb675f85a2e0d5c9c95477b22836185ffe5761c4c21f049cdb2b579ff615935"
    netstats_host = "netstats"
    bootnode_host = "node0"
    node_nat = "any"
    node_count = 2
    node_name = "${var.node_name}"
    node_verbosity = 3
}

module "consent_netstats" {
    source = "../modules/netstats"
    docker_host = "${var.docker_host}"
    docker_cert_path = ""
    netstats_secret = "fc3790e391e058a04d6a81aac40e1e51adb675f85a2e0d5c9c95477b22836185ffe5761c4c21f049cdb2b579ff615935"
}

module "consent_id_service" {
    source = "../modules/idservice"
    docker_host = "${var.docker_host}"
    docker_cert_path = ""
    link_node = "${module.consent_ethereum.first_node_name}"
}

module "consent_wallet" {
    source = "../modules/wallet"
    docker_host = "${var.docker_host}"
    docker_cert_path = ""
}

module "consent_ethexplorer" {
    source = "../modules/ethexplorer"
    docker_host = "${var.docker_host}"
    docker_cert_path = ""
    node_host = "localhost"
}

module "consent_data_owner" {
    source = "../modules/dataowner"
    docker_host = "${var.docker_host}"
    docker_cert_path = ""
    link_node = "ethereum-node0"
}

module "consent_data_requester" {
    source = "../modules/datarequester"
    docker_host = "${var.docker_host}"
    docker_cert_path = ""
    link_node = "ethereum-node0"
}
