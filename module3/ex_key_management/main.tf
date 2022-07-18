variable "region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  # Credentials are stored in: ~/.aws/credentials
  access_key = ""
  secret_key = ""
  token      = ""
  region     = var.region
}

