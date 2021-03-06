terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "terraform_example" {
  cidr_block = "10.127.0.0/16"
  tags = {
    Name = "terraform_example"
  }
}