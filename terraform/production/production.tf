variable "consent_aws_access_key" {
}

variable "consent_aws_secret_key" {
}

variable "consent_cidr_blocks" {
}

variable "consent_public_key" {
}

module "consent_aws" {
    source = "../modules/aws"
    consent_aws_access_key = "${var.consent_aws_access_key}"
    consent_aws_secret_key = "${var.consent_aws_secret_key}"
    consent_cidr_blocks = "${var.consent_cidr_blocks}"
    consent_public_key = "${var.consent_public_key}"
}

module "consent_ethereum" {
    source = "../modules/ethereum"
    docker_host = "tcp://${module.consent_aws.consent_ec2_public_ip}:2376"
    docker_cert_path = "docker_0"
    netstats_secret = "fc3790e391e058a04d6a81aac40e1e51adb675f85a2e0d5c9c95477b22836185ffe5761c4c21f049cdb2b579ff615935"
}

module "consent_netstats" {
    source = "../modules/netstats"
    docker_host = "tcp://${module.consent_aws.consent_ec2_public_ip}:2376"
    docker_cert_path = "docker_0"
    netstats_secret = "fc3790e391e058a04d6a81aac40e1e51adb675f85a2e0d5c9c95477b22836185ffe5761c4c21f049cdb2b579ff615935"
}
