terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.70.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "webserver" {
  ami           = "ami-0bddbd9020098a4f5"
  instance_type = "t3.micro"
  count         = "3"

  tags={
  Name="One"
  }
}
