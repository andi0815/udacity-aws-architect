# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  # Credentials are stored in: ~/.aws/credentials
  access_key = ""
  secret_key = ""
  token = ""
  region = "us-east-1"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "udacity_t2_micro" {
  count = 4

  ami = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"

  tags = {
    env = "undacity"
    Name = "Udacity T2 (${count.index})"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "udacity_m4_large" {
  count = 0

  ami = "ami-0cff7528ff583bf9a"
  instance_type = "m4.large"

  tags = {
    env = "undacity"
    Name = "Udacity M4 (${count.index})"
  }
}