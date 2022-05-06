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
  region = "us-east-2"
  access_key = "AKIA6JYQXNU7VALNVZXO"
  secret_key = "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"
}

# Basic Usage with tags - VPC

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name = "vpc-22"
  }
}

# Basic Usage - SUbnet

resource "aws_subnet" "dmzsub1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/23"
  availability_zone = "us-east-2a"
  tags = {
    Name = "dmzsubnet1"
  }
}
resource "aws_subnet" "dmzsub2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/23"
  availability_zone = "us-east-2b"
  tags = {
    Name = "dmzsubnet2"
  }
}
resource "aws_subnet" "pubsub1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/23"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "pubsubnet1"
  }
}
resource "aws_subnet" "pubsub2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.6.0/23"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "pubsubnet2"
  }
}

# Internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-22"
  }
}

# Rout table Public Subnet

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "pubRT"
  }
}

# Subnet Association Public Subnet

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.pubrt.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.pubrt.id
}

# Rout table DMZ Subnet

resource "aws_route_table" "dmzrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "dmzRT"
  }
}

# Subnet Association DMZ Subnet

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.dmzsub1.id
  route_table_id = aws_route_table.dmzrt.id
}
resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.dmzsub2.id
  route_table_id = aws_route_table.dmzrt.id
}
