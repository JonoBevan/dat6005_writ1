terraform {
    required_version = ">=1.0"
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
      }
    }
    backend "s3" {
    bucket = "terraform-state-dat6005"
    key = "rds/terraform.tfstate"
    region = "eu-west-2"
    }
}

provider "aws" {
    region = var.aws_region
}

resource "tls_private_key" "web_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "web_keypair" {
  key_name = "webserver"
  public_key = tls_private_key.web_key.public_key_openssh
}

resource "aws_s3_object" "private_key_upload" {
  bucket = "dat6005-rsa-keys"
  key = "webserver.pem"
  content = tls_private_key.web_key.private_key_pem
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "web_sg" {
  name = "dat6005-jb-sg"
  vpc_id = data.aws_vpc.default.id

  # SSH Restricted
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["109.156.48.178/32"]
  }

  # HTTP (open)
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS (Open)
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name = "aurora-rds-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.web_sg.id]
    description = "Allow MySQL/Aurora access from EC2"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dat6005" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.web_keypair.key_name
  subnet_id = data.aws_subnets.default.ids[0]

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "dat6005-jb"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  owners = ["137112412989"] # Amazon
}