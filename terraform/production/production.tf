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
}
