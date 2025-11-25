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
