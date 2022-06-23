provider "aws" {
  # Credentials are stored in: ~/.aws/credentials
  # access_key = ""
  # secret_key = ""
  region = "us-east-2"
}

resource "aws_instance" "udacity" {
  count = 2

  ami = "ami-02d1e544b84bf7502"
  instance_type = "t2.micro"

  tags = {
    env = "undacity"
    # name key must start with a capital letter!
    Name = "terraform-w-locking-${count.index}"
  }
}