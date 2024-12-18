# Terraform Block
terraform {
  required_version = ">= 1.7" # Any version equal & above than 1.10
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">= 5.0"
    }
  }
  
}
# Specify the provider and version
provider "aws" {
    region = var.aws_region
    profile = "default"
}
