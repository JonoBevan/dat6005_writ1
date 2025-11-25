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

resource "aws_db_subnet_group" "mysql_subnets" {
    name = "mysql-subnet-group"
    subnet_ids = var.subnet_ids
  
}

resource "aws_bd_instance" "mysql" {
    identifier = "swfavorites"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = var.instance_class
    allocated_storage = 20
    db_name = var.db_name
    username = var.db_username
    password = var.db_password
    vpc_security_group_ids = var.security_group_ids
    db_subnet_group_name = aws_db_subnet_group.mysql_subnets.name
    skip_final_snapshot = true
}