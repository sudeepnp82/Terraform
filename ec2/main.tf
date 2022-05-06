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
  region     = "us-east-2"
  access_key = "AKIA6JYQXNU7VALNVZXO"
  secret_key = "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"
}

# EC2 creation 3 instances - paste ami id

resource "aws_instance" "web" {
  ami           = "ami-0ba62214afa52bec7"
  instance_type = "t2.micro"
  count			=	3
  key_name		= "snptest"
  tags = {
    Name = "HelloWorld"
  }
}