module "consent_data_owner_goliath" {
    source = "../modules/dataowner"
    docker_host = "unix:///var/run/docker.sock"
    docker_cert_path = ""
    link_node = "ethereum-node0"
    data_owner_name = "goliath"
    data_owner_email = "goliath-national-bank@example.com"
}

module "consent_data_owner_umbrella" {
    source = "../modules/dataowner"
    docker_host = "unix:///var/run/docker.sock"
    docker_cert_path = ""
    link_node = "ethereum-node0"
    data_owner_name = "umbrella"
    data_owner_email = "umbrella-corp@example.com"
}
