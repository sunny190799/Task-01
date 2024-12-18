# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"
}
variable "vpc_availability_zones" {
  description = "Number of availability zones is 3"
  # default = ["us-east-1a", "us-east-1b","us-east-1c"]
}

variable "aws_cidr_block" {
  description = "cidr range for vpc"
  # default = "10.0.0.0/16"
}

variable "vpc_dmz_subnet" {
    description = "cidr range for dmz subnet "
    # default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "vpc_web_subnet" {
description = "Cidr range for web subnet"
# default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_app_subnet" {
  description = "Cidr range for app subnet"
  # default = ["10.0.151.0/24", "10.0.152.0/24", "10.0.153.0/24"]
}

variable "vpc_db_subnet" {
  description = "Cidr range for database subnet"
  # default = ["10.0.201.0/24", "10.0.252.0/24", "10.0.253.0/24"]
}

variable "ec2_instance_type" {
    description = "ec2-instance-type"
    # default = "t2.micro"
}

variable "ec2_private_ip" {
description = "The private Ip of ec2 instance"  
type = string
# default = "10.10.34.44"
}

variable "enable_imds_v2" {
  description = "Enable or disable IMDSv2 for EC2 instances"
  type        = bool
  default     = true
}
