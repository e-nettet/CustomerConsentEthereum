variable "consent_aws_access_key" {
}

variable "consent_aws_secret_key" {
}

variable "consent_cidr_blocks" {
}

variable "consent_public_key" {
}

variable "consent_key_file" {
    default = "consent_key.pem"
}

variable "consent_ec2_user" {
    default = "rancher"
}

variable "consent_ec2_home" {
    default = "/home/rancher"
}

output "consent_ec2_public_ip" {
    value = "${aws_eip.consent_ip.public_ip}"
}

provider "aws" {
    access_key = "${var.consent_aws_access_key}"
    secret_key = "${var.consent_aws_secret_key}"
    region = "eu-central-1"
}

resource "aws_key_pair" "consent_key" {
    key_name = "consent_key"
    public_key = "${var.consent_public_key}"
}

resource "aws_vpc" "consent_vpc" {
    cidr_block = "10.0.2.0/24"
    instance_tenancy = "default"
    tags {
        Name = "consent_vpc"
    }
}

resource "aws_subnet" "consent_subnet" {
    vpc_id = "${aws_vpc.consent_vpc.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-central-1a"
    tags {
        Name = "consent_subnet"
    }
}

resource "aws_internet_gateway" "consent_gateway" {
    vpc_id = "${aws_vpc.consent_vpc.id}"
    tags {
        Name = "consent_gateway"
    }
}

resource "aws_route_table" "consent_route_table" {
    vpc_id = "${aws_vpc.consent_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.consent_gateway.id}"
    }
    tags {
        Name = "consent_route_table"
    }
}

resource "aws_main_route_table_association" "consent_main_route_table_association" {
    vpc_id = "${aws_vpc.consent_vpc.id}"
    route_table_id = "${aws_route_table.consent_route_table.id}"
}

resource "aws_iam_role" "consent_instance_role" {
    name = "consent_role"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                 "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "consent_role_policy" {
    name = "consent_role_policy"
    role = "${aws_iam_role.consent_instance_role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_eip" "consent_ip" {
    vpc = true
}

resource "aws_eip_association" "consent_ip_association" {
    instance_id = "${aws_instance.consent_ec2.id}"
    allocation_id = "${aws_eip.consent_ip.id}"
}

resource "aws_security_group" "consent_security_group" {
    name = "consent_security_group"
    vpc_id = "${aws_vpc.consent_vpc.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [
            "${split(",", var.consent_cidr_blocks)}"
        ]
    }
    ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        self = true
        cidr_blocks = [
            "${split(",", var.consent_cidr_blocks)}",
            "${aws_eip.consent_ip.public_ip}/32"
        ]
    }
    ingress {
        from_port = 8545
        to_port = 8545
        protocol = "tcp"
        self = true
        cidr_blocks = [
            "${split(",", var.consent_cidr_blocks)}",
            "${aws_eip.consent_ip.public_ip}/32"
        ]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        self = true
        cidr_blocks = [
            "${split(",", var.consent_cidr_blocks)}",
            "${aws_eip.consent_ip.public_ip}/32"
        ]
    }
    ingress {
        from_port = 30301
        to_port = 30309
        protocol = "tcp"
        self = true
        cidr_blocks = [
            "${split(",", var.consent_cidr_blocks)}",
            "${aws_eip.consent_ip.public_ip}/32"
        ]
    }
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
        cidr_blocks = [
            "${split(",", var.consent_cidr_blocks)}",
            "${aws_eip.consent_ip.public_ip}/32"
        ]
    }
    ingress {
        from_port = 2376
        to_port = 2376
        protocol = "tcp"
        cidr_blocks = [
            "${split(",", var.consent_cidr_blocks)}"
        ]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }
    tags {
        Name = "consent_security_group"
    }
}

resource "aws_iam_instance_profile" "consent_instance_profile" {
    name = "consent_instance_profile"
    roles = [
        "${aws_iam_role.consent_instance_role.id}"
    ]
}

resource "aws_instance" "consent_ec2" {
    count = 1
    ami = "ami-2025df4f"
    instance_type = "t2.small"
    availability_zone = "eu-central-1a"
    ebs_optimized = false
    associate_public_ip_address = true
    key_name = "${aws_key_pair.consent_key.key_name}"
    iam_instance_profile = "${aws_iam_instance_profile.consent_instance_profile.id}"
    subnet_id = "${aws_subnet.consent_subnet.id}"
    vpc_security_group_ids = [
        "${aws_security_group.consent_security_group.id}"
    ]
    root_block_device = {
        volume_type = "gp2"
        volume_size = 8
        delete_on_termination = true
    }
    provisioner "local-exec" {
        command = "mkdir -p docker_${count.index}"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo ros config set rancher.docker.tls true",
            "sudo ros tls gen --server -H localhost -H ${aws_eip.consent_ip.public_ip}",
            "sudo system-docker restart docker",
            "sudo ros tls gen"
        ]
        connection {
            user = "${var.consent_ec2_user}"
            private_key = "${file(var.consent_key_file)}"
            agent = "false"
        }
    }
    provisioner "local-exec" {
        command = "scp -o \"StrictHostKeyChecking no\" -o \"UserKnownHostsFile /dev/null\" -i ${var.consent_key_file} ${var.consent_ec2_user}@${self.public_ip}:${var.consent_ec2_home}/.docker/* docker_${count.index}"
    }
    tags {
        Name = "consent_ec2_${count.index}"
    }
}
