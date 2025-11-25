variable "aws_region" {
    description = "AWS region"
    type = string
    default = "eu-west-2"
}

variable "instance_class" {
    description = "DB Instance Type"
    type = string
    default = "db.t3.micro"
}

variable "db_name" {
    type = string
}

variable "db_username" {
    type = string
    sensitive = true
}

variable "db_password" {
    type = string
    sensitive = true
}

variable "subnet_ids" {
    type = list(string)
}

variable "security_group_ids" {
    type = list(string)
}